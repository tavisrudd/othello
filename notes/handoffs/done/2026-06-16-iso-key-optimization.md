# Iso-key cost reduction -- make the graph-iso key cheap enough to win at n=16

**Date**: 2026-06-16
**Session**: 2026-06-16--7 (`75f2fb75-ad25-4f5f-8add-6efede5643ba`)
**References**: [burr-live handoff](2026-06-16-burr-live-implementation.md) (the
iso-merge "START HERE" / lever 0 this executes); [inner-loop handoff](2026-06-16-queens-inner-loop-rewrite.md)
(the `canon_bench` precedent + the 62-cyc D4 incremental key). Code: `rust/src/queens/graph.rs`
(the iso keys), `rust/src/bin/iso_key_bench.rs` (the new regression harness).

## Context

The burr-live handoff's headline lever was "instruction-level the iso key" -- the graph-iso
key merges ~3.4× more positions than the D4 key, which would fit the n=16 working set in RAM
(re-exp 1.37→1.0). The premise was "only ~19% to close." This session built the measurement
tooling, **overturned that premise with data**, banked a correct 1.25× cut, and characterised
the real ceiling.

### The load-bearing findings (measured, n=16 unless noted)

1. **The iso merge IS realized live** (the burr-live handoff's open question -- resolved
   POSITIVE). n=12 `symmetry` (sequential, exact): D4 = 1,066,048 nodes; `QUEENS_KEY=fast`
   = 310,249 nodes = **3.44× fewer**, ≈ the static merge factor. The merge is real.
2. **But the iso key is ~100× the D4 key.** `iso_key_fast` cache-off (the live regime)
   ≈ 8453 cyc/key at session start; the D4 incremental key is 62 cyc. Even the *cheapest
   useful* iso keys (available popcount 5-8, the deep bulk) are ~6500 cyc; cost scales
   steeply with graph size (popcount 33-48 → 8 µs; the root → catastrophic).
3. **Net: iso is ~2.2× SLOWER than production at n=16.** Throughput (sustained, this box):
   incremental-D4 (production) **~7.0 M/s**, parallel-D4 ~4.1, **parallel+iso ~0.7 M/s**.
   iso does ~4.6× fewer total nodes (3.4× merge × re-exp 1.37→1.0) but pays ~10×/node →
   net ~2.2× slower. **To break even iso needs throughput > ~1.5 M/s** (cut the key ~2.2×);
   to win ~1.8× needs ~4×. The "~80 cyc within 1.3× of the D4 key" target was never reachable
   -- it's WL *graph* canonicalisation, not a bitmask fold.
4. **Cost breakdown** (cache-off, the live regime): 70.6% of components are k≥5 (full WL);
   the WL refinement (`comp_canon_full` + `wl_refine_in`) is ~66% of cycles; **individualisation
   (the non-discrete path) was 76% of all WL work** before this session's cut.

## What landed (banked, all gates green)

- **`iso_key_bench`** (`rust/src/bin/iso_key_bench.rs`, registered in `Cargo.toml`) -- the
  `canon_bench` analog for the iso key. Calls the real `Queens::iso_key_*` over a realistic
  n=16 corpus (`Queens::iso_corpus`, added to `graph.rs`). Gates: **bijection** (iso_key_fast
  must induce the same partition as the exact `iso_key_canon` -- a broken optimisation that
  over/under-merges fails it); **merge factor**; **cost-by-popcount buckets**; **alloc audit**
  (counting global allocator -- proved the live key path is **zero-alloc**). Modes:
  `bench` | `verify` | `buckets` | `perf:{fast,fast_nc,ir,canon,components,empty}`.
  Run: `taskset -c 0-3 perf stat -e cycles target/release/iso_key_bench 16 1000000 4 perf:fast_nc`
  then `(fast_nc - empty)/keys`. **`fast_nc` (cache off) is the live-representative cost** --
  the cache-on `fast` over a `reps` loop warms the 64 MB `COMP_CACHE` to ~100% hits and hides
  every `comp_canon_full` change, so it is NOT the gate.
- **`iso_key_fast_nocache`** + a `const CACHE: bool` generic threaded through
  `iso_key_fast_in` / `comp_canon` (the project's monomorphise-the-toggle pattern). Production
  is `CACHE = true` (unchanged); the bench measures `CACHE = false` (recompute = live regime).
- **THE WIN -- non-singleton individualisation** (`comp_canon_full`, non-discrete branch).
  The old code individualised *every* non-singleton vertex from the base seed and folded the
  signatures. Now it individualises **only the vertices in non-singleton 1-WL classes** (a
  vertex alone in its colour class is pinned -- its signature is redundant) and folds in the
  base stable-colouring hash once so the restriction cannot weaken the invariant. **Cut WL
  re-runs from 3.1× → 1.6× the base refines; cyc/key 8453 → 6789 (1.25×).** Bijection exact
  on a 100k n=16 sample, merge factor unchanged (2.750×), n=12/n=14 verdict still SECOND,
  zero-alloc, `make test` (lineage + tiny_component + 47) green.
- **`--list-engines` now lists `burr`** (`bin/queens.rs`) + a `const _: () = assert!(INFO.len()
  == SOLVER_NAMES.len())` so a future solver can't silently drop off the list.
- **`Bits::popcount` made `pub`** (was `pub(crate)`) for the bench; **`IsoScratch` got
  `#[repr(C, align(64))]`** (hot-struct hygiene -- see negatives, it's perf-neutral).

## Documented negatives (do NOT re-try without the noted change)

- **nauty target-cell IR canon** -- prototyped (scratch-based, allocation-free recursive
  individualisation-refinement taking the min certificate hash over the IR tree; exact). At
  every budget (4-48) and IR_MAX_CELL (3-6) it measured **~7150 cyc/key -- WORSE than the
  6789 non-singleton fold**. Correct (bijection held) but the recursion + per-frame `[u64;
  MAXV]` copy + per-frame O(k²) target scan beat the cascade savings on these small graphs.
  **Reverted.** The clique tail (full lines = cliques, common in queen graphs, k! IR leaves)
  is the killer; the proper fix is **automorphism-pruning** (see next levers), without which
  target-cell does not pay.
- **`#[repr(C, align(64))]` on `IsoScratch`** -- measured **neutral** (6789 → 6811-6850, noise).
  The WL path is gather/compute-bound, not load-alignment-bound. **Kept** as hot-struct
  hygiene (harmless, future-proofs the AVX-512 colour-map loads) but it is not a win.
- **SIMD is largely exhausted.** The `mix64` colour map (`mc[i] = mix64(lcol[i])`) **already
  auto-vectorises to AVX-512** (confirmed in the asm: `zmm`/`vpmullq`/`vpsrl`/`vpxor`, 8× u64).
  The neighbour fold is a **gather** (`mc[nbr_pad[..]]`) -- LLVM correctly kept it scalar (no
  `gather` in the asm), matching the `canon_bench` finding that AVX gather is a measured loss
  on this Zen5. Sorts + individualisation control-flow are SIMD-hostile.

## Next levers (queued -- decide direction with the user first)

The strategic question is open: **iso is ~2× short of beating production at n=16, and the
remaining levers are all substantial.** Is iso worth more investment for n=16, or is its real
value n=18 (capacity existential) + resume-as-query? Decide before sinking a session.

0. **★ Automorphism-pruning port (the real iso lever).** This is what makes target-cell win:
   nauty/bliss discover automorphisms during the IR search and use the group's orbits to prune
   equivalent branches, collapsing a clique's k! tree to ~1 path -- exactly our clique tail.
   Study **McKay & Piperno, "Practical Graph Isomorphism, II" (2014)** (nauty/Traces internals)
   and **bliss** (Junttila & Kaski, cleaner C++). Port the *algorithm* into the scratch kernel
   -- do NOT link libnauty (built for thousand-vertex graphs; per-call setup dwarfs our
   ~6800-cyc budget on k≈9 components called millions of times). Gate on `iso_key_bench`
   cyc/key + bijection. **Substantial; uncertain it closes the full 2×.**
1. **Precompute table for small k.** Components are tiny (k ≤ ~12); enumerate the distinct
   structures (nauty's `geng` enumerates all graphs up to n), precompute canon, look up per
   node. **Open problem: the cheap *complete* lookup key** (a cheap iso-invariant is not
   collision-free -- 1-WL has 0.8% unsafe; a wrong merge flips a verdict). This is itself a
   mini graph-iso problem. The current `COMP_CACHE` is the dynamic version but keys on the
   *square-set* (low live hit rate -- doubling it is +3.7%); re-keying on *structure* is the
   prize but needs the complete cheap key.
2. **Deep-research pass** on the above (the `deep-research` skill) to scope the port before
   committing -- fan out on nauty/Traces/bliss automorphism-pruning + small-graph canon.
3. **Selective keying** (`QUEENS_KEY_MAX`, the burr-live handoff's lever 1) -- iso-key only
   small/deep graphs (cheap, where merges come from), D4 the rest; kills the catastrophic
   shallow keys. At n=12 `KEY_MAX=10` kept the full merge at 30% less cost. **Blocked at n=16
   on the sentinel-bit-255 collision** (D4 uses all 256 bits; the fix is to hash both key
   types into disjoint tagged namespaces -- a moderate change). Composes with (0)/(1).
4. **If iso stays underwater: pause it.** Bank the 1.25× + tooling; pivot to the roadmap's
   other n=16 rungs (more/faster RAM, tiered compaction) or accept incremental-D4.

## Codebase Reference

| What | Where |
|------|-------|
| iso keys (`iso_key_fast`, `iso_key_fast_nocache`, `comp_canon`, `comp_canon_full`, `wl_refine_in`, `cert_hash_in`, `tiny_comp_key`) | `rust/src/queens/graph.rs` |
| the WIN (non-singleton individualisation) | `comp_canon_full` non-discrete branch, `graph.rs` |
| the exact ground-truth canon (recursive target-cell, allocating) | `canon_cert` / `iso_key_canon`, `graph.rs` -- the algorithm to port (lever 0) |
| `iso_corpus` (bench corpus builder) | `graph.rs` (cold measurement path) |
| the bench | `rust/src/bin/iso_key_bench.rs` |
| `IsoScratch` (per-thread scratch, now `repr(C, align(64))`) | `graph.rs` |
| `COMP_CACHE` (square-set-keyed component canon cache) | `graph.rs` |
| KeyMode wiring (`QUEENS_KEY=fast|canon|ir|comp`, `graph_bits` sentinel, `QUEENS_KEY_MAX`) | `rust/src/queens/solver/mod.rs` |

## Build/Test Commands

Per CLAUDE.md. Bench: `make release` builds `iso_key_bench`; perf as above. Correctness gate
for any iso-key change: `iso_key_bench 16 1000000 1 verify` (bijection must stay true) **and**
`QUEENS_KEY=fast queens solve 12 symmetry` (must stay SECOND, ~310k nodes) + `make test`.

## Progress

- [x] iso_key_bench + iso_corpus + alloc audit + cost-by-popcount buckets
- [x] Characterise: iso ~2.2× underwater at n=16; merge realized live (3.44×); cost = WL canon ~100× D4
- [x] WIN: non-singleton individualisation, 8453 → 6789 cyc/key (1.25×), exact, zero-alloc
- [x] Negatives: target-cell IR (reverted), align(64) (neutral, kept), SIMD (exhausted -- map auto-vec, gather scalar)
- [x] `--list-engines` burr fix + compile guard
- [ ] **Decide with user: pursue iso (automorphism-pruning / precompute / selective) or pause**
- [ ] If pursuing: deep-research nauty/bliss pruning → port into the scratch kernel (lever 0)

## Handoff Notes

### Session 2026-06-16--7 (`75f2fb75-ad25-4f5f-8add-6efede5643ba`)
**Completed**: the iso-key measurement tooling + a banked 1.25× cut + a full characterisation
that reframes the lever (iso is ~2× underwater at n=16, not "19% to close"). Two negatives
documented and reverted/neutral. The library landscape (nauty/Traces/bliss) identified, with
automorphism-pruning as the missing technique.
**Files created/modified**: `rust/src/bin/iso_key_bench.rs` (new), `rust/Cargo.toml` (bin),
`rust/src/queens/graph.rs` (iso_corpus, iso_key_fast_nocache + CACHE generic, non-singleton
individualisation WIN, IsoScratch align(64)), `rust/src/queens/bits.rs` (popcount pub),
`rust/src/bin/queens.rs` (--list-engines burr + assert). NB `rust/Makefile` has an unrelated
user edit (pgo-queens profiles `burr` not `incremental`) -- left as-is.
**Instructions for next agent**: the gate is `iso_key_bench ... perf:fast_nc` (cache OFF) +
the bijection -- do NOT optimise against cache-on `fast` (it warms the cache and hides
`comp_canon_full` changes). Before any more iso instruction-level work, get a direction
decision from the user: the realistic ceiling of pure micro-opt is ~1.5× more (still short of
the 2× needed); the only levers that could close it (automorphism-pruning, structural
precompute) are multi-session and uncertain. The 1.25× win is real and banked regardless.
