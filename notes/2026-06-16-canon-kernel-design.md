# Step 1 — canon/movegen kernel design (the Fermi-check target)

**Date**: 2026-06-16
**For**: [inner-loop-rewrite handoff](handoffs/2026-06-16-queens-inner-loop-rewrite.md) Step 1.
The standalone benchmark that must validate ~20–50 cyc/node *before* committing to the rewrite.

## What today's canon actually does (the fat)

`Queens::canon` (`queens.rs:646`):
```rust
for t in 1..8 {
    let mut img = Bits::ZERO;
    mask.each(|s| img.set(perm[s as usize]));   // scalar per-bit scatter through a Vec index
    if img < best { best = img; }
}
```
This is a **scalar per-set-bit scatter through a `Vec<u32>` permutation in memory** — for each of
8 orientations, iterate every set bit, load `perm[s]`, compute the destination word/bit, OR it in.
At a sparse deep node (~7 set bits) that's ~8×7 = ~56 iterations each with a dependent memory load
≈ hundreds of cycles; the cost scales with `popcount(available)`. **This scatter is the ~250×
per-node fat** the floor identified — not a missing micro-opt, a structural cost.

## The key freedom (why the rewrite is gate-safe)

The TT distinct count = number of D4-equivalence *classes*. That count is **invariant under which
canonical representative we choose**, as long as the new canon is a *perfect* D4-invariant (same
key ⟺ D4-equivalent). So we may pick **any** exact D4-canonical form that's cheaper to compute and
the `solve 12 --distinct = 1,060,823` gate still holds byte-for-byte. We are not bound to the
lex-min representative — only to *a* perfect invariant.

## The kernel (two variants to bench)

Board = 16×16 bit grid, row-major: `square = row*16 + col`, `Bits = [u64;4]` (word w holds rows
4w..4w+3). The 8 D4 orientations are standard bitboard transforms:
- **v-flip** (reverse 16 rows): word/byte permute (`vpermq`/`vpshufb`) — ~2–4 ops.
- **h-flip** (reverse cols within each 16-bit row): GFNI bit-reverse (`GF2P8AFFINEQB` + lane byte-swap) — ~2–3 ops.
- **transpose** (16×16): 4× 8×8 blocks; `GF2P8AFFINEQB` transposes each 8×8 bit-block + swap the two off-diagonal blocks — ~4–6 ops.
- rot90/180/270 + anti-transpose = cheap compositions of the above (compute id/h/v/transpose once, derive the other four).

**Variant A — recompute-per-node (stateless, GFNI):** from `available`, compute all 8 orientation
images (~20–40 vector ops, **independent of popcount**), then the min reduction. Simple, no stack
state. Start here.

**Variant B — incremental:** maintain 8 orientation images live; per move `img_t &= !attack_t[sq]`
(8× `vpandnq`), where `attack_t[sq] = perm_t(attack[sq])` is precomputed (8 × n² × 32 B = 64 KB at
n=16 → spills L1d into the 1 MB L2). Saves the recompute but must carry 8×256 bits down the DFS
stack (flatten the recursion or recompute on backtrack). Bench only if A is borderline.

## CORRECTION to the floor doc: the min reduction is ~30 ops, not ~7

The floor doc said "canon = a ~7-op `vpminuq` reduction." That is **wrong** — `vpminuq` is a
*per-lane* unsigned min, but the canonical key is the **lexicographic min of 8 four-word values**
(word 0 is the most-significant limb, per `Bits`'s derived `Ord`). A per-lane min does not give a
valid representative. The correct reduction is a **multiword lexicographic arg-min of 8 candidates**:
reduce word 0 across the 8 (`vpminuq` tree, ~3 ops) → m0; mask the candidates with word0==m0
(AVX-512 k-reg); among those reduce word 1; …; 4 words. ≈ **~25–35 ops**. (Or pick a different
exact invariant — e.g. min over orientations keyed by a single injective scalar — if one is
cheaper; the class-count is preserved either way, see "key freedom".)

**Revised per-node cost model (Variant A):** ~20–40 (8 images) + ~30 (lex min-of-8) + ~6 (hash) ≈
**~60–80 vector ops ≈ ~30–50 cyc/node** at ~2 ops/cyc with some dependency stalls. Still inside the
floor's ~20–140 band, but at the **upper-middle**, not the ~18 aggressive end — the min reduction
is a real, non-trivial term the first draft under-counted. The Fermi check measures the true number.

## What the benchmark measures

1. **Corpus**: dump a realistic stream of `available` masks from a real n=14 search (the exact
   working set is already recordable — `Counter` exact-set / `working_set()`), weighted as the
   search actually visits them (deep-heavy). ~10–50M masks.
2. **Harness**: tight loop over the corpus, `rdtsc` (or `perf stat`) around it, report **cyc/node**
   for: (baseline) today's `canon`; (A) GFNI recompute; (B) incremental. Defeat the optimizer
   (consume the hash via a `black_box` accumulator).
3. **Correctness**: assert the new kernel's key is a perfect D4-invariant on the corpus — for every
   mask, `kernel_key(mask) == kernel_key(canon_today(mask))` and the class partition matches
   today's (same number of distinct keys over the corpus). This is the in-bench gate before the key
   ever touches the search.

**Decision gate:** A (or B) lands ≲ ~80 cyc/node and is a perfect invariant → commit to Step 3.
Stuck in the hundreds-to-thousands → the model is wrong; re-read at a wider angle (CLAUDE.md Fermi
rule) before writing search code.

## Build note
New standalone bin/bench — will conflict with concurrent `make` from the Step-2 measurement agent
(shared target dir + Cargo). Implement after Step 2 lands. znver5+mold via the Makefile; the kernel
needs `target-feature=+gfni,+avx512f,+avx512bw,+avx512vl` (znver5 has them — confirm in the build).
