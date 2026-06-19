# Proposal: untried Zen5 hardware fast-paths for the queens solver

**Date**: 2026-06-18
**Status**: PROPOSE-only. No code changed. Decision-grade ranking + dataflow for each lever.
**Target**: AMD Ryzen AI 9 HX 370 (Zen 5), `make release` → `-C target-cpu=znver5`, AVX-512 static.
**Scope**: map every untried Zen5 ISA feature onto the four measured cost centers; rank by
`(cycles attackable × hit-probability) ÷ cost`; rule out the misfits with a reason.

---

## 0. Ground truth (verified this session)

**Box ISA** (`/proc/cpuinfo`, this Zen5): `gfni avx512f avx512bw avx512vbmi avx512_vbmi2
avx512bitalg avx512_vpopcntdq avx512vl avx512ifma avx512cd avx512dq avx512_vnni
avx512_vp2intersect avx512_bf16 bmi1 bmi2 pclmulqdq vpclmulqdq vaes sha_ni popcnt`. Every
feature the brief names is present in hardware.

**Rust intrinsic availability** (probed with `rustc 1.93.1`, the toolchain `make release` uses):
- RESOLVE on stable `core::arch::x86_64`: `_mm512_popcnt_epi64` (VPOPCNTDQ),
  `_mm512_bitshuffle_epi64_mask` / `_mm256_bitshuffle_epi64_mask` (BITALG `vpshufbitqmb`),
  `_mm512_mask_compress_epi8` / `_mm_mask_compressstoreu_epi8` (VBMI2 `vpcompressb`),
  `_mm512_gf2p8affine_epi64_epi8` + `inv` (GFNI, const-immediate form),
  `_mm512_permutexvar_epi8` (VBMI `vpermb`), `_mm512_clmulepi64_epi128` (VPCLMULQDQ),
  `_mm512_madd52lo_epu64` (IFMA), `_mm512_conflict_epi32` (CD), `_pext_u64`/`_pdep_u64`/`_bzhi_u64`
  (BMI2), `_mm_crc32_u64` (SSE4.2), `_cvtmask64_u64` (kmov).
- **DOES NOT RESOLVE on stable**: `_mm512_2intersect_epi32` / `..._epi64` (**VP2INTERSECT**).
  Hardware has it; the Rust intrinsic is still nightly-gated. **Rule out any lever needing it** —
  it would force a nightly toolchain and break `make release`.

**Code anchors verified** (grep'd, exact line refs):
- `filter_moves` / `avail_has8`: `src/queens/solver/iso_flat.rs:108,142`. `avail: Bits=[u64;4]`,
  `pmoves: &[u8]` (a `q.order` byte subsequence), `buf: [MaybeUninit<u8>; MAXV]`, `MAXV = 256`.
- `Bits`: `src/queens/bits.rs:9` — `Bits(pub(crate) [u64;4])`, `WORDS=4`, `MAX_N=16`. `and_not`/`and`
  are 4× scalar `&!`/`&`; `popcount` is 4× `count_ones().sum()`; derived `Ord` is lexicographic.
- `child_orient` / `lex_min8`: `src/queens/solver/incremental.rs:82,49`. `[Bits;8]` → 7× `and_not`,
  then 8-way scalar lexicographic min (early-exits on word 0).
- `tiny_edge_code<K>` / `enter_graph` `closed`/`adj` build: `src/queens/graph.rs:648`,
  `iso_flat.rs:973-981`. O(k²) `edge_bit` gather, K≤7. `att08(att,sq) = att[sq][0]` is a `Bits`.
- `hash128`: `src/queens/tt.rs:622`. 4-limb fold → `(route, fp)`. `index`/`index_seg`: `tt.rs:474,433`
  (Lemire fastrange). `TT_HASH_ID = 1` at `tt.rs:312` (bump on any key-byte change).
- Validation gate (`rust/CLAUDE.md`): `queens solve 12 iso-flat --distinct` = **1,060,823**;
  `solver_lineage_agrees`; `solve 14 iso-flat --distinct` ≈ 29.2 M, re-exp ≈ 1.0×.

**Throughput anchors** (iso-window handoff): production n=16 ~33–34 M/s, warm n=14 ~41 M/s. A node is
**frontend-bound** (27% fetch-idle, CPI ~1.1). The relevant currency is therefore **µops / I-cache
footprint**, not raw ALU throughput — an instruction that *replaces a scalar loop with one wide op*
helps even if its own latency is mediocre, but a high-latency op on the critical dependency chain
(gather: −9% measured) loses.

**Cost-center budget** (n=16 perf annotate, from brief):
`filter_moves`/`avail_has8` ≈ 26% · flat-TT probe (latency) ≈ large but mostly stall ·
`tiny_edge_code`+`closed`/`adj` ≈ 16% · `child_orient`+`lex_min8` ≈ 20%.

---

## 1. Ranked fast-paths

Rank metric = `(attackable cycles % × hit-probability) ÷ implementation+latency cost`.

| # | Lever | Instr | Cost center | Upside bound | Risk | Verdict |
|---|-------|-------|-------------|--------------|------|---------|
| 1 | BITALG move-filter | `vpshufbitqmb`+`kmov`+`popcnt` | filter 26% | up to ~26% of the 26% block; realistic 8–15% of it | low | **BUILD FIRST** |
| 2 | VBMI2 compaction (on top of #1) | `vpcompressb`/`compressstoreu` | filter 26% | folds the compaction store into #1 | low | **BUILD WITH #1** |
| 3 | GFNI 8×8 transpose for edge-code | `gf2p8affineqb` | edge-code 16% | the K≤7 row-gather, ~1/2 of the 16% | med | **PROTOTYPE** |
| 4 | VPOPCNTDQ board popcount | `vpopcntq` | scattered | ~1–2% (popcount is everywhere, small each) | low | **CHEAP, FOLD IN** |
| 5 | `pext` edge/move bit-gather | `pext_u64` | edge-code / filter | replaces shift-loops; modest | low | **FOLD INTO #1/#3** |
| 6 | VPCLMULQDQ / CRC32 TT hash | `vpclmulqdq` / `crc32` | hash128 (small) | hash is <5%; latency-hidden anyway | low | **MARGINAL — skip** |
| 7 | `lzcnt`/`tzcnt`/`blsr` board iter | BMI1 | `Bits::each` | already largely emitted | — | **NO-OP (compiler does it)** |
| 8 | IFMA `vpmadd52` | — | (no 52-bit mul need) | none | — | **RULE OUT** |
| 9 | CD `vpconflictd` | — | (no dedup-in-register need) | none | — | **RULE OUT** |
| 10 | VP2INTERSECT | — | (move∩avail) | blocked: no stable intrinsic | — | **RULE OUT (toolchain)** |
| 11 | AVX-512 gather/scatter | `vpgatherqq` | any | **measured −9%** | high | **RULE OUT (re-confirmed)** |
| 12 | non-temporal TT stores | `movnt`/`prefetchnta` | TT probe | hurts (TT *is* reused) | — | **RULE OUT** |

---

## 2. Lever 1 — BITALG `vpshufbitqmb` move-availability filter  ★ build first

**Attacks**: cost center #1, `avail_has8`/`filter_moves`, the single biggest 26% block.

**What it does.** `vpshufbitqmb` (`_mm512_bitshuffle_epi64_mask`) treats the 512-bit source as eight
independent **64-bit bit-lanes**; the index vector supplies, per output byte, a 6-bit selector picking
**one bit** out of that byte's containing 64-bit lane, and writes the selected bits packed into a
64-bit mask register (one mask bit per input byte). This is *exactly* the move-availability pattern:
"for a vector of square indices, fetch one availability bit each."

**The dataflow against `Bits=[u64;4]` and the `u8` move list.** `avail` is 256 bits = four 64-bit
lanes; `vpshufbitqmb` operates per-64-bit-lane, so we must route each square's index to the right
lane. A square `sq∈0..256` lives in lane `sq>>6` at bit `sq&63`.

Concrete plan, processing up to 64 squares of `pmoves` per instruction:
1. Broadcast `avail` so all the squares of a given 64-lane group see the right limb. Two workable
   layouts:
   - **(a) lane-replicated source.** Build a 512-bit source where the 8 lanes are
     `[avail0,avail1,avail2,avail3,avail0,avail1,avail2,avail3]` (a `_mm256` broadcast of the
     four-limb `avail`, or two 256-bit halves). Load 64 move-bytes; the selector byte for move `sq`
     must point into the lane holding `avail[sq>>6]`. Because the *byte's own lane* is fixed by its
     position in the index vector (byte j sits in lane j>>3), and we need lane = sq>>6, we **bucket
     `pmoves` by `sq>>6` (which limb)** — i.e. one `vpshufbitqmb` per occupied limb-bucket, selector
     = `sq&63`. With ≤4 limbs and the move list usually concentrated in 1–2 limbs deep in the tree,
     this is 1–2 instructions, not 64 scalar bit-tests.
   - **(b) per-limb scalar selector via `pext`.** Simpler: for limb `w=avail[k]`, gather the bytes of
     `pmoves` whose `sq>>6==k`, mask their `sq&63`, run one `vpshufbitqmb` with source-broadcast of
     `w`, get a `kmask` of survivors. (See Lever 5 `pext` for the bucketing.)
2. The result `kmask` has bit j = "move j is available." Survivor **count** = `popcnt(kmask)` (the
   `nc` the loop currently accumulates one `+=` at a time). Survivor **compaction** = Lever 2.

**Channel-Fermi upside.** The filter is 26% of cycles and is today a *scalar dependency stream*:
per square, `sq>>6` index, a `1<<(sq&63)` shift, a limb load, an AND, a compare-to-zero, a
branchless `+=`. That's ~5–6 µops/square feeding a frontend that's already 27% fetch-idle. Replacing
64 squares' worth (≈384 µops) with `(1–2)×vpshufbitqmb + kmov + popcnt` (≈4–6 µops) is a ~50–80×
µop reduction *on the squares processed by the vector path*. But the move list is short deep in the
tree (the 50/50-survival comment in `filter_moves` means lists are typically 4–20 long), so the win
is bounded by **how many squares per node** ride the vector path vs the fixed vector setup cost.
Realistic capture: if the filter is 26% and we cut its µops by ~3–4× *amortised over short lists*,
that's **~8–15% of total cycles** — a top-tier lever, larger than the entire "branchless+segment
+16%" combined win from the last session. Upper bound (long lists near the root) approaches the full
26%.

**Zen5 latency/throughput.** `vpshufbitqmb` is a single-µop BITALG op (~3–4c latency, 1/c
throughput on Zen5's 512-bit datapath — Zen5 is native-512, not double-pumped like Zen4). `kmov
k,r` + `popcnt r,r` are 1c each. **No gather, no memory indirection** — this is the anti-gather: the
"gather one bit per index" is done in-register by the shuffle network. That is the whole reason it
should *win* where the explicit `vpgatherqq` lex_min8 lost.

**Correctness/gate.** The filter output must remain the **byte-identical `q.order` subsequence** of
survivors (the searched node set is defined by move order). `vpshufbitqmb` + a compaction that
preserves index order (Lever 2 `vpcompressb` is order-preserving) reproduces `filter_moves` exactly.
**Not a key change** → no `TT_HASH_ID` bump. Gate: `solve 12 iso-flat --distinct` = 1,060,823 must
hold to the digit (proves move order unchanged); `solver_lineage_agrees`; n=14 re-exp ≈ 1.0×.

**Cheapest experiment.** A standalone `#[bench]`/criterion microbench in `src/bin/` (mirror
`canon_bench.rs`): feed 10⁷ random `(avail, pmoves)` pairs with realistic list-length distribution
(pull the actual length histogram from a `count` run, or just sweep len∈{4,8,16,32}), compare scalar
`filter_moves` vs the BITALG path, assert byte-identical output, report ns/call and µops
(`perf stat -e uops_dispatched`). **Gate the experiment on equality before any n=16 A/B.**

---

## 3. Lever 2 — VBMI2 `vpcompressb` survivor compaction  ★ build with #1

**Attacks**: cost center #1, the *store* half of `filter_moves` (currently the branchless
`buf[nc].write(sq); nc += has`).

**What it does.** `vpcompressb` (`_mm512_maskz_compress_epi8` / `_mm_mask_compressstoreu_epi8`) takes
a 64-byte vector of move indices + the survivor `kmask` (the Lever-1 output) and writes the selected
bytes **contiguously, in order**, to `buf` — the entire compaction in one instruction. The
order-preserving property is guaranteed by the ISA, so the `q.order` subsequence is exact.

**Dataflow.** Inputs: `zmm` = the 64 move bytes already loaded in Lever 1; `kmask` = survivors from
`vpshufbitqmb`. `_mm_mask_compressstoreu_epi8(buf_ptr, kmask, zmm)` stores `popcnt(kmask)` bytes;
advance `buf_ptr` by `popcnt(kmask)`. For lists >64, loop in 64-byte chunks. This *is* `filter_moves`
with the per-byte branchless store replaced by one masked compress-store.

**Upside.** This is not a separate cycle pool from Lever 1 — it removes the store-port pressure and
the `nc` dependency chain that serialises the scalar loop. Counted together, Levers 1+2 are the
"vectorised `filter_moves`," and the ~8–15% estimate in Lever 1 already assumes both.

**Zen5 latency/throughput.** `vpcompressb` is a multi-µop op on Zen5 (the byte-granular compress is
microcoded-ish, ~3–6 µops, ~3–5c), but it replaces 64 store+increment pairs — net µop win is large.
`compressstoreu` folds the store. *Caveat to measure*: if the move list is almost always ≤8, a
`vpcompressb` on a 128-bit `xmm` (`_mm_maskz_compress_epi8`) is cheaper than the 512-bit form — size
the vector to the list-length histogram, don't reflexively use `zmm`.

**Correctness/gate.** Order-preserving by ISA contract → byte-identical output → same node set. No
key change, no `TT_HASH_ID` bump. Same gate as Lever 1.

**Experiment.** Same microbench as Lever 1; the two are A/B'd as one unit ("scalar filter" vs
"BITALG+VBMI2 filter").

---

## 4. Lever 3 — GFNI `gf2p8affineqb` for the ≤7 edge-code / adjacency build  ★ prototype

**Attacks**: cost center #3, `tiny_edge_code`/`enter_graph`'s `closed`/`adj` build (~16%).

**The current cost.** For K≤7 vertices, the code does an O(k²) double loop: load each vertex's 256-bit
attack row `att08(att,verts[i])`, then for each `j` test `row.get(vj)` and OR a bit into a `u8`
adjacency / `u32` triangular code. That's ~k²≈up to 49 scalar `edge_bit` (limb-index + shift + AND)
operations per band entry, on the always-run path.

**What GFNI offers.** `gf2p8affineqb` computes, per 64-bit qword lane, `transpose8x8(M) · v` over
GF(2) with an XOR post-byte — i.e. it is a **programmable 8×8 bit-matrix × bit-vector** in one µop.
Two distinct uses here:
- **8×8 bit-transpose** (`gf2p8affineqb(x, identity_0x0102…80, 0)` selects the transpose): the K≤7
  adjacency is a ≤8×8 symmetric bit-matrix. If we can land the 7 attack-rows' relevant bits into one
  64-bit lane as an 8×8 block, one `gf2p8affineqb` transposes it (useful if we ever need column-major
  adjacency) — but the bigger win is the **gather-by-matrix-multiply**: choosing the affine matrix =
  a selection/permutation matrix extracts exactly the `verts[j]` bits of a row into a packed byte.
- **The edge-code is a triangular projection** of the adjacency matrix. If we assemble the (up to)
  8×8 closed-neighbourhood bit-matrix (row i = `closed[i]` as a byte over local labels), then the
  whole `tiny_edge_code` triangular packing is a fixed linear map over those 64 bits — expressible as
  `pext` of a constant mask (Lever 5) over the 64-bit matrix, *no* O(k²) loop.

**Concrete dataflow.** The hard step is assembling the 8×8 *local* adjacency byte-matrix from the
256-bit attack rows under the `verts[]` relabelling. Today `enter_graph` already builds `g.closed[i]`
as a `u8` (one byte per vertex, bit j = `row.get(vj)`) — that inner `for j` loop is the candidate to
replace. Pack the 8 `closed` bytes into one `u64` `M` (`M = Σ closed[i] << (8*i)`). Then:
- `adj` = `M` with diagonal cleared (`M & !DIAG`, DIAG=0x8040201008040201).
- `tiny_edge_code` (triangular, i<j) = `pext(M, UPPER_TRI_MASK)` — one BMI2 op replacing the O(k²)
  bit-packing loop.
The remaining O(k) work is producing each `closed[i]` byte = "which of the ≤8 `verts` are in
`att08(verts[i])`." That per-row gather of 8 specific bits out of 256 is itself a **Lever-1
`vpshufbitqmb`** (8 indices = `verts[]`, source = the attack row), so Levers 1 and 3 share machinery:
one `vpshufbitqmb` per vertex row → 8 `closed` bytes → one `pext` → edge code. GFNI's role is the
optional transpose if column-major adjacency is wanted; the load-bearing win is `vpshufbitqmb` +
`pext` collapsing the double loop.

**Channel-Fermi upside.** The edge-code/adj build is ~16%. Collapsing O(k²)≈up to 49 scalar bit-tests
into K `vpshufbitqmb` (≤7) + one `pext` is a ~5–8× µop cut on that block → **~6–10% of total cycles**
if K is typically 5–7, less if mostly K≤4 (where the existing `tiny_comp_key` degree-sequence
shortcut already bypasses this). Need the K-distribution from a `count` run to firm this up; mark it
**prototype, measure-K-first**.

**Zen5 latency/throughput.** `gf2p8affineqb` is single-µop, ~3c latency, 1–2/c throughput on Zen5
(GFNI is full-width native). `pext` on Zen5 is **fast** (~3c, 1/c) — unlike the Zen2 microcoded
`pext` that gave BMI2 a bad reputation; Zen3+ and Zen5 have a hardware `pext`. **No gather.**

**Correctness/gate.** The edge code must remain **bit-identical** to `tiny_edge_code`/`tiny_key_from_adj`
(the iso key feeds the W8 table and the ≤7 tiny table). Any reordering of the triangular packing
silently changes keys → must hold `solve 12 iso-flat --distinct` = 1,060,823 AND the n=14 distinct
count AND re-exp ≈ 1.0×. **If the packing convention changes at all, bump `TT_HASH_ID`** — but the
goal is to reproduce the exact same code value, so no bump if done right. This is the highest-care
lever (key-touching); prototype must assert equality against the scalar `tiny_edge_code` over an
exhaustive enumeration of all ≤7-vertex labelled graphs before any solver wiring.

**Experiment.** Pure-function microbench in `src/bin/`: enumerate **all** labelled graphs on
k∈{4,5,6,7} vertices (2^(k choose 2) each — exhaustive, ≤2²¹), assert `gfni_edge_code == tiny_edge_code`
for every one, then ns/call A/B. Exhaustive equality is cheap here and is the gate.

---

## 5. Lever 4 — VPOPCNTDQ `vpopcntq` for `Bits::popcount` / `and+popcount`  ★ fold in (cheap)

**Attacks**: `Bits::popcount` (`bits.rs:55`) and the `attack[v].and(comp).popcount()` in
`tiny_comp_key` — popcount is sprinkled across the node (`child0.popcount()` for the pc band routing
at every child, `avail.popcount()` in `M_HIST`/oracle paths).

**What it does.** `_mm512_popcnt_epi64` does 8× 64-bit popcounts in one µop; for `Bits=[u64;4]` we
only need a 256-bit `_mm256_popcnt_epi64` then a horizontal add. Today `popcount` is 4× scalar
`popcnt` + 3 adds. The scalar `popcnt` is already 1c/1µop on Zen5, so the win is *only* the
horizontal-reduction µops and is small — but `child0.popcount()` runs on **every child** to pick the
pc band, so it's on the hottest path.

**Upside.** Small per call but high frequency: realistically **~1–2% of total cycles**, and it's a
trivial, zero-risk fold. Not a headline lever; bundle it into the Lever-1 work since the board is
already in a `zmm`/`ymm` there. The bigger structural win is **fusing `and_not`+`popcount`**: the
child routing does `child0 = avail.and_not(a[0])` then `child0.popcount()` — keep `child0` in a
vector register, `_mm256_andnot_si256` + `_mm256_popcnt_epi64` + reduce, avoiding the scalar
round-trip. Whether the SIMD `and_not` beats the current 4× scalar (which the compiler may already
vectorise) is a measurement, not an assumption.

**Zen5.** `_mm256_popcnt_epi64` single-µop ~3c. No gather. **Caution**: the scalar 4× `popcnt`
version may already match or beat it for a mere 4 words (the SIMD horizontal reduce can cost more than
3 scalar adds). **Only keep if the A/B shows it.** Per the project's "per-node micro-opts wash out"
history, treat this as a fold-in, not a standalone session.

**Gate.** Value-identical (popcount is exact) → no key change, no bump. Same distinct-count gate.

---

## 6. Lever 5 — BMI2 `pext` for triangular packing & limb-bucketing  ★ fold into #1/#3

**Attacks**: the bit-packing loops in `tiny_edge_code`/`tiny_key_from_adj` (#3) and the limb-bucketing
in the BITALG filter (#1).

**What it does.** `pext(src, mask)` gathers the masked bits of `src` into a contiguous low field — a
hardware parallel bit-extract. Uses:
- **Triangular edge-code packing** (Lever 3): `pext(M_u64, UPPER_TRIANGULAR_MASK)` produces the
  i<j edge code in one op (replaces the `bit += 1; code |= …` accumulator loop).
- **`Bits` → packed limb selection**: extracting the bits of `avail[k]` at the `verts`/`pmoves`
  positions for a limb-bucket.

**Upside.** Subsumed into Levers 1 and 3 (it's the glue, not a standalone cost center). On Zen5
`pext` is a fast hardware op (~3c, 1/c) — *this is a Zen5-specific enabler*: on Zen2 the same code
would be a microcode trap and lose. Worth calling out precisely because the codebase predates this
being cheap.

**Gate.** Bit-identical packing → must reproduce the exact edge code → same care/bump rules as Lever 3.

---

## 7. Lever 6 — VPCLMULQDQ / CRC32 for a cheaper TT hash  ✗ marginal, skip

**Attacks**: `hash128` (`tt.rs:622`) — but this is **<5% of cycles** and its latency is *already
hidden* behind the prefetched random TT load (cost center #2 is a memory stall, the hash runs in its
shadow).

`clmul`/`crc32` could compute `route`/`fp` in fewer µops than the 4-limb multiply-fold. But: (a) the
hash isn't a measured hot block; (b) **any** change to `route`/`fp` is a key change forcing
`TT_HASH_ID` bump and full re-validation; (c) the fold also feeds `archive_key` and the segmented
band routing — wide blast radius. Risk ≫ reward. **Skip unless `hash128` ever shows up hot in
annotate** (it doesn't today). Documented so it isn't re-proposed.

---

## 8. Ruled out (with reasons)

- **AVX-512 gather/scatter (`vpgatherqq`/`vpscatter`)** — RULE OUT, re-confirmed. The lex_min8
  gather was built and measured **−9%** (CPI 1.110→1.275) on this exact box; gather is CPI-expensive
  on Zen5 and lands on the critical dependency chain. The BITALG/VBMI2 levers exist precisely to do
  "gather one bit per index" *without* `vpgather`. Flag: any future proposal that reaches for gather
  for a per-node op is starting from a measured −9%.
- **IFMA `vpmadd52` (`_mm512_madd52lo_epu64`)** — RULE OUT. It accelerates 52-bit integer multiply
  accumulation (big-int / FP emulation). The solver has no 52-bit multiply; the only multiplies are
  the hash fold (64-bit, full width) and Lemire fastrange (`u128` widening) — neither is a 52×52
  pattern. No mapping. (Possible curiosity: a 52-bit Lemire-style range reduction for the TT index —
  but the table is sized to need full 64-bit routing; not worth the precision juggling.)
- **AVX-512 CD `vpconflictd` (`_mm512_conflict_epi32`)** — RULE OUT. It detects duplicate elements
  within a vector (for safe scatter-conflict resolution / histogram vectorisation). The solver does
  no in-register dedup; the move list is already duplicate-free (a `q.order` subsequence), and TT
  dedup is by hash, not by vector conflict. No mapping.
- **VP2INTERSECT (`_mm512_2intersect_*`)** — RULE OUT on **toolchain**, not concept. The "intersect
  the move-square vector with the available-square vector" idea maps onto it conceptually, but the
  Rust intrinsic is **nightly-gated** (verified: does not resolve on stable 1.93.1), so using it
  breaks `make release`. (Also: Zen5's VP2INTERSECT is known to be a slow, multi-µop implementation —
  even on nightly it would likely lose to the BITALG path. Doubly dead.) `vpshufbitqmb` covers the
  same need on stable.
- **Non-temporal stores / `prefetchnta` for the TT** — RULE OUT. The TT *is* reused (that's the whole
  point of a transposition table); `movnt`/`nta` mark lines as streaming-evict, which is exactly wrong
  for a structure whose hit rate is the win condition. The existing `_mm_prefetch::<T0>` (keep-in-all-
  levels) is correct. `prefetchw` (prefetch-for-write) is a *maybe* for the `put` path — the slot is
  loaded then stored — but the store is `Relaxed` and the line is already T0-prefetched on the get;
  marginal, low priority, note-only.
- **`lzcnt`/`tzcnt`/`blsr`/`blsi`/`blsmsk` (BMI1)** — effectively NO-OP. `Bits::each`/`lowest` already
  use `trailing_zeros()` + `w &= w-1` (blsr), which LLVM emits as `tzcnt`/`blsr` under `-C
  target-cpu=znver5`. No source change needed; verify in `cargo asm` if curious, but nothing to add.
- **`vpermb` (VBMI full byte permute)** — no standalone use. It's a building block *inside* the
  GFNI/BITALG dataflow (e.g. routing `pmoves` bytes into limb-buckets for Lever 1, or applying the
  `verts` relabelling), not a cost center on its own. Folds into Levers 1/3 if needed.
- **mask-register ops (`kmov`/`kand`/`kortest`)** — these are the *output plumbing* of Levers 1–3
  (`kmov` to get the survivor mask to a GPR for `popcnt`; `kortest` for "any survivor?" early-out).
  Not standalone; counted inside those levers.
- **`sha_ni` / `vaes`** — RULE OUT. Cryptographic; the TT hash doesn't need cryptographic strength
  (it needs avalanche + speed, which `mix64`/`clmul` give). No mapping.

---

## 9. Recommended sequence

1. **Levers 1+2 together (BITALG filter + VBMI2 compaction)** — the highest
   `(cycles×prob)÷cost`. Standalone microbench first (byte-identical assert + ns/call + µop count),
   then interleaved n=14 A/B, then n=16. **No key change, no `TT_HASH_ID` bump.** Target: claw a
   meaningful fraction of the 26% filter block; even +8% total throughput would exceed last session's
   whole branchless+segment combined gain.
2. **Lever 4 (vpopcntq) folded into #1's vector context** — cheap, fold-in, keep only if A/B-positive.
3. **Lever 3 (GFNI/`vpshufbitqmb`/`pext` edge-code)** — prototype after #1 lands (shares the
   `vpshufbitqmb` machinery). Key-touching: exhaustive ≤7-graph equality gate *before* any solver
   wiring; bump `TT_HASH_ID` only if the code value changes (goal is no change).
4. Everything in §8 stays ruled out; §7 (hash) parked unless annotate moves it.

**Cross-cutting discipline** (from `rust/CLAUDE.md`): every lever is a `const`-monomorphised /
resolved-once path, never a per-node runtime `if`; interleaved A/B on a clean box; keep only what pays
its way; document negatives. The frontend-bound profile means **the win is fewer µops / smaller I-cache
footprint**, which is exactly what "replace a scalar loop with one wide op" delivers — and is why these
beat the gather that lost.
