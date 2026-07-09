# Op-fusion / strength-reduction hunt — iso-window hot path (2026-06-18)

**Status:** PROPOSE-only spike sheet. No code changed. Verified every cited
function/flag/layout against the tree before listing it.

**Target:** znver5 (`make release`, `-C target-cpu=znver5`). Confirmed features:
AVX-512F/BW/DQ/VL, **GFNI**, **BMI2** (pdep/pext/bzhi/blsr), **AVX512VPOPCNTDQ**,
**AVX512BITALG** (`vpopcntb`/`vpshufbitqmb`), **AVX512VBMI2** (`vpcompress`), POPCNT,
LZCNT/TZCNT (`rustc --print cfg -C target-cpu=znver5` checked).

**Cost being attacked:** frontend-bound (~27% idle on fetch/decode), branch-miss ~10%,
CPI ~1.1. So the win metric is **instructions removed and branches removed in the
hottest region**, not latency. The TT probe is already ~1% of cycles — leave it.

**Equivalence gate (every item must pass byte-identically):**
`queens solve 12 iso-flat --distinct` = exactly **1,060,823**, plus `solve 14 iso-flat
--distinct` ≈ 29.2M @ re-exp ≈ 1.0×, plus `solver_lineage_agrees` (n≤9 vs `naive`).
Crucially: the iso/W8 tables are **relabelling-invariant** — any deterministic labelling
of the live squares yields the same win/loss — so an item that only reorders how the edge
code's bits are *assembled* (not which graph it encodes) is automatically value-safe. That
is the lever almost every item below pulls.

---

## Hot-path map (verified line refs)

| Region | Fn (file:line) | Cost | What it does per node |
|--------|----------------|------|------------------------|
| D4 deep (pc≥9) | `wins_inc` `iso_flat.rs:671` | ~50% | `filter_moves`, `child_orient` (7× `and_not` over `[u64;4]`), `lex_min8`, `hash128`, probe |
| iso band (pc≤7) | `enter_graph` `iso_flat.rs:918` | ~20%, **#1 branch-miss** | extract verts, insertion-sort by rank, O(k²) `closed`/`adj` bit-loop, `solve_local` |
| iso edge-code | `tiny_edge_code<K>` `graph.rs:648` | (inside band entry) | O(k²) `i<j` attack-bit double loop → 21-bit code |
| iso tail | `solve_local` `iso_flat.rs:1012`, `expand_graph` `:1058` | (inside band) | recursive DP over `alive:u8`, `child = alive & !closed[i]` |
| pc==8 | `w8_get` `iso_flat.rs:300` | ~6% | extract 8 verts, O(8²)=28-bit edge code, dense load |
| key hash | `hash128` `tt.rs:622` | per key | 4-iter mix over `[u64;4]` |

`Bits = [u64;4]`, derived `Ord` ⇒ lexicographic, **word 0 most significant**
(`bits.rs:8`). `att[sq][0]` is the identity-frame attack row (`Bits`). `q.attack[sq]` is
self-blocking (includes `sq`). Board ≤ 256 bits, 4 words.

---

## Ranked findings

Rank = (instructions/branches removed in the hottest region) ÷ implementation cost.
Items 1–4 are the real levers; 5–7 are smaller/secondary; 8–10 are flagged washes.

---

### 1. `solve_local` / `expand_graph` child gen: `bzhi` + `pext` to materialize the move bitmask, and fuse the `closed` build — **HIGH**

**Where (verified):**
- `enter_graph` `iso_flat.rs:964-972` builds `closed[i]`/`adj[i]` with an O(k²) inner
  `for j { c |= (row.get(vj) as u8) << j }`.
- `solve_local` `iso_flat.rs:1019-1027` and `expand_graph` `:1076-1086` iterate alive
  vertices with `rem.trailing_zeros()` / `rem &= rem-1`, computing `child = alive &
  !g.closed[i]` per move.

This is the **#1 branch-miss site** (`band_entry`/`enter_graph`) and the highest-node-count
region (deep tree). Two fusions:

**1a. The `closed`-build inner loop is a `pext`.** `closed[i]` extracts, for vertex `i`, the
bits of `att[verts[i]]` at the *board* positions `verts[0..k]`, packed into local positions
`0..k`. That is exactly:

```
closed[i] = pext(att[verts[i]].word_containing, mask_of_verts)   // when verts share a word
```

The general case (verts span up to 4 words) is `pext` per word then OR-shift by the running
popcount — but **k ≤ 7 and the live squares deep in the tree are spatially clustered**, so in
the dominant case all `verts[0..k]` lie in 1–2 of the four `u64`s. Replace the `k`-trip inner
`for j` (k branches/iters per vertex, k vertices ⇒ ~k² = up to 49 iterations, each a
`row.get` = shift+and+test) with **k `pext` instructions** (one per vertex), each
`_pext_u64(att_word, vert_word_mask)`. `pext` is 3-cycle/1-op on Zen5. The `verts`→mask folds
to a single `pext`-able `u64` once per band entry.

- **Identity:** "gather bits at a fixed set of source positions into contiguous low bits" =
  `pext(src, mask)` (BMI2). Bit-exact with the current shift-OR build by construction.
- **Cost attacked:** instruction count + the O(k²) inner branch (frontend + the measured #1
  branch-miss). Removes ~k²−k ≈ up to ~40 ops/band-entry down to ~k `pext`s.
- **Channel-Fermi:** band entry is ~20% of cycles and runs once per ≤7 subtree root; the O(k²)
  build is maybe a third of `enter_graph`'s body. If it's ~6–7% of total cycles and we cut its
  op count ~4–5×, upside ≈ **3–5% wall**. The branch-miss reduction is the sweeter part
  (10% miss rate × frontend-bound), possibly worth as much again.
- **Correctness:** value-safe — produces byte-identical `closed`/`adj`, so the tiny-table key
  and `solve_local` verdicts are unchanged. Gate: `solve 12 --distinct` = 1,060,823.
- **Cheapest experiment:** unit-test `closed_via_pext == closed_via_shiftloop` over all
  `child0` masks at n≤8 in the existing graph test corpus (exhaustive for k≤7). Then A/B
  `solve 14 iso-window` interleaved. Kill if <1%.

**1b. `expand_graph`/`solve_local` move enumeration is already minimal** (`blsr` =
`rem &= rem-1`, `tzcnt`); leave it. The fusable part is **1a only**.

**Caveat / why it might be smaller than 1a's napkin:** the verts often span 2 words, and the
cross-word merge adds a shift+or per spilled word. Still strictly fewer ops than k² `get`s,
but bound the win by measuring the single-word fraction first (a `count`-mode tally of "do
verts[0..k] share one word" would tell you the hit rate cheaply).

---

### 2. `tiny_edge_code` / `w8_get` / `iso_key8_direct`: replace the O(k²) edge-code double-loop with a per-vertex `pext` + prefix-shift pack — **HIGH**

**Where (verified):**
- `tiny_edge_code<K>` `graph.rs:648-670`: `for i { row = attack[verts[i]]; for j>i {
  code |= edge_bit(row,verts[j]) << bit; bit++ } }` — the upper-triangular edge code.
- Identical shape in `w8_get` `iso_flat.rs:312-318`, `iso_key8_direct` `graph.rs:1055-1063`,
  and `tiny_key_from_adj` `graph.rs:702-708`.

This O(k²) double loop (up to 21 bit-tests for k=7, 28 for k=8) is on the **always-run path of
`band_entry`** (the #1 branch-miss site) and inside `w8_get` (~6%).

**Fusion:** for vertex `i`, the contribution to `code` is the bits of `att[verts[i]]` at
positions `verts[i+1..k]`, packed contiguously and shifted to the running `bit` offset. That
inner extraction is a **`pext`**:

```
row_word = att[verts[i]] (relevant word)
hi_mask  = mask of verts[i+1..k] within that word     // = vert_mask & ~bzhi(vert_mask, pos_i+1)
contrib  = pext(row_word, hi_mask)                     // bits packed to low
code    |= contrib << bit
bit     += (k-1-i)
```

`hi_mask` per `i` is `bzhi`/`blsr`-derivable from the full vert mask in O(1). So the whole edge
code becomes **k `pext`s + k shifts/ORs** instead of k²/2 `edge_bit` tests, each of which is
itself a `>>6` word-select + shift + and + bool-cast.

- **Identity:** upper-triangular adjacency packing = per-row `pext` of the neighbour bits at
  the higher-indexed vertex positions; the `<<bit` with running offset reproduces the exact
  triangular bit order `adj_from_edge_code` inverts.
- **Cost attacked:** instruction count (k²/2 → k ops) and, critically, the data-dependent
  structure that feeds the frontend on the #1 branch-miss path. The current loop is already
  *branchless* (the OR is unconditional), so this is pure op-count + decode-width, not branch —
  which is exactly the 27%-frontend-idle lever.
- **Channel-Fermi:** `w8_get` ~6% + the tiny edge-code build inside band entry (call it ~4–5%
  of total). Cutting these inner loops ~3× ⇒ upside ≈ **2–4% wall**, frontend-weighted so
  possibly more than the cycle ratio suggests.
- **Correctness:** byte-identical code value ⇒ same dense/tiny table slot ⇒ identical verdict.
  The W8/tiny tables are relabelling-invariant, but this doesn't even relabel — it produces the
  same labelled code. Gate holds trivially.
- **Cheapest experiment:** the cleanest single target is **`w8_get`** (fixed k=8, hottest of
  the three at ~6%, no `K` generic to template). Write `edge_code_pext(verts, att) ==
  edge_code_loop(...)`, exhaustive-test against the existing loop over random 8-subsets, then
  A/B `iso-window` at n=14. If it lands, fold the same helper into `tiny_edge_code<K>` and
  `iso_key8_direct`.

**Stretch (GFNI, only if 2 lands and you want more):** the full 8×8 adjacency *bit-matrix* of
the W8 graph can be **transposed in one `gf2p8affineqb`** (GFNI transposes an 8×8 bitmatrix via
`gf2p8affine(I, x)` with the identity matrix as the affine operator). If you build the 8 attack
*rows* as a `u64` (one byte per row, bit `j` = edge `i–j`), the upper-triangle extraction and
symmetry checks become one GFNI op + a triangular mask. This is a bigger rewrite; bank it as a
follow-up to 2, not the first cut. (Flagged: the win is only the 28-bit *pack*, which `pext`
already minimizes — GFNI mainly helps if you also need the transpose for a symmetry/canon step,
which `w8_get` does not. Likely a wash *for w8_get specifically*; keep GFNI in reserve for a
future on-the-fly k>8 canon.)

---

### 3. `child_orient` — fuse the 7 lane `and_not`s into AVX-512 `vpandnq` (and consider 2× zmm) — **MEDIUM-HIGH**

**Where (verified):** `incremental.rs:118-129`. Per non-band node (pc≥9, ~50% region),
`child_orient` does 7 `Bits::and_not`, each a 4×`u64` `&!` loop (`bits.rs:38-44`). That's
7×4 = 28 scalar `andn` ops + the loads, **per node**, in the hot D4 path.

**Fusion:** the 7 orientations `parent[1..8]` are `7 × [u64;4]` = 7×32 = 224 contiguous bytes;
the attack masks `a[1..8]` likewise. `child[t] = parent[t] &! a[t]` is a pure elementwise
`andnot`. Pack into **zmm registers (8 u64 = 2 orientations per `vpandnq`)** and do the 7
orientations in **4 `vpandnq`** (covering orientations 1–8, lane 0 is the reused `child0`) plus
the load/store. `vpandnq` is AVX-512F, 1-op. So 28 scalar `andn` → ~4 vector ops.

- **Identity:** elementwise `a & !b` across a contiguous array = `vpandnq` (operates on the
  whole vector; no horizontal step needed, no reduction). Bit-exact.
- **Cost attacked:** instruction count + decode in the ~50% region. 28 → ~4 arithmetic ops
  (loads dominate, but the array is L1/register-resident — `att[sq]` is 64 KB, hot).
- **Channel-Fermi:** `child_orient` is a slice of the ~50% D4 region. If the 7 `and_not`s are
  ~⅓ of `child_orient` and `child_orient` is ~15% of total, upside ≈ **2–4% wall** — *if* LLVM
  isn't already auto-vectorizing this. **It may well be**: the `[u64;4]` `and_not` loop is the
  classic auto-vectorize target, and `-C target-cpu=znver5` will use ymm/zmm. **Check the asm
  first** (`cargo asm` / `objdump` on `child_orient`); if you already see `vpandn`, this is a
  WASH and you should *not* hand-roll it. If you see scalar `andn` (likely, because the 8
  separate `Bits` values defeat cross-`and_not` vectorization), the hand-packed zmm form wins.
- **Correctness:** identical child orientations ⇒ identical `lex_min8` keys. Trivially safe.
- **Cheapest experiment:** `objdump -d` the release `child_orient` and grep for `vpandn` vs
  scalar `andn`/`vandnps`. That one command decides build-or-skip before any code. If scalar,
  prototype the 4-`vpandnq` form behind `lex_min8`-style `#[cfg(avx512f)]` and A/B at n=14.

---

### 4. `filter_moves` survivor compaction → AVX-512 `vpcompressb` (mask-compress) — **MEDIUM**

**Where (verified):** `filter_moves` `iso_flat.rs:133-150`. For each parent move `sq` it writes
`buf[nc]=sq` and `nc += avail_has8(avail,sq)`. Runs once per `wins_inc`/`wins_tiny` node (the
~50% + iso regions). Already branchless, but it's a **scalar, serially-dependent** loop: each
iteration's store address depends on the previous `nc`.

**Fusion:** this is the textbook **stream-compaction** primitive. With AVX512VBMI2,
`_mm512_mask_compressstoreu_epi8` (`vpcompressb`) compacts up-to-64 surviving bytes in one op
given a survivor mask. The survivor mask itself is `avail_has8` over up-to-64 squares at once,
which is a gather-of-bits — computable via the board words: for the (common) case where the
move list is short (deep nodes have few moves), or by testing 64 squares' availability against
`avail` with a `vpshufbitqmb`/`vptestmb` against precomputed per-square `(word,bit)`.

- **Identity:** "write the elements passing a predicate contiguously" = masked compress-store
  (`vpcompressb`, AVX512VBMI2). The output order is preserved (compress is stable), so the
  `q.order` subsequence — and thus the node set — is byte-identical.
- **Cost attacked:** the serial `nc`-dependency chain (a loop-carried dependency that limits
  ILP) and the per-element store. For a move list of length L, L serial iters → ⌈L/64⌉
  compress ops.
- **Channel-Fermi:** `filter_moves` is small per node but runs *every* node; the serial dep is
  its real cost, not op count. Deep nodes have short lists (L often < 16), where a single
  `vpcompressb` + one mask-build replaces ~L serial stores. Upside is **harder to bound** — call
  it 1–3% and verify; the loop-carried dep removal helps the frontend-bound machine keep more
  in flight. **Flag:** building the survivor mask cheaply is the crux; if it costs more than the
  serial loop it removes, this is a wash. The mask build wants `avail` tested against the
  parent's `pmoves` square positions — doable with a small `pext`/gather but not free.
- **Correctness:** stable compress ⇒ identical move order ⇒ identical search. Gate holds.
- **Cheapest experiment:** microbench `filter_moves_compress` vs the scalar form on
  representative `(pmoves, avail)` captured from an n=14 run (dump a few thousand). Only promote
  to an A/B if the microbench shows >1.3× on the compaction in isolation — the mask-build
  overhead is the risk.

---

### 5. `hash128` — keep scalar, but the per-key fold is already near-minimal; the only fusion is folding `route`+`fp` lanes into one zmm — **LOW/WASH-LEANING**

**Where (verified):** `hash128` `tt.rs:622-632`. 4-iteration loop over `[u64;4]`, each iter doing
two independent mix chains (`route` and `fp`). Called once per key created.

**Observation:** `route` and `fp` are **independent** accumulators with different constants —
they already dual-issue (no dependency between them), so the two chains overlap on the scalar
ALUs. There's no horizontal reduction to vectorize away (each is a sequential mix over 4 words —
inherently serial *within* a chain). You can't `vpmullq` across the 4 words because each word's
mix feeds the next (`route = (route ^ w) * C; route ^= route>>29`). So SIMD buys nothing here.

- **Verdict:** **WASH.** The structure is a serial mix chain; AVX-512 doesn't help a
  loop-carried multiply chain. Leave it. (Listed so it isn't re-proposed: the `route`/`fp`
  independence is the only parallelism and the scalar machine already exploits it.)
- The one *micro* nit: `route ^= route >> 29` then next iter `route ^= w` — these are already
  minimal. No identity reduces them.

---

### 6. `solve_local` mex/cut: the win-test is already a `mex==first-loss`, but `expand_graph`'s `seen`-style nimber XOR elsewhere can use `vpopcntq`/`blsi` — **LOW (scoped to oracle, not production)**

**Where (verified):** `comp_nimber` `iso_flat.rs:533-542` builds `seen |= 1<<nimber` then
`mex = (!seen).trailing_zeros()`. That's already optimal (`tzcnt` of `!seen` = mex). The
`1u64 << x` accumulation is a single `bts`-equivalent.

- **Verdict:** **already minimal**, and this is the **oracle path (`QUEENS_NIMBER_ORACLE`),
  DEAD in production** (default `iso_max_avail=7`, oracle off). Do not spend here. Listed to
  pre-empt a re-propose: `mex = (!seen).trailing_zeros()` is the canonical strength-reduced
  mex and needs nothing.

---

### 7. `Bits::popcount` over `[u64;4]` → `vpopcntq` horizontal — **LOW/WASH (already optimal scalar)**

**Where (verified):** `bits.rs:55-57`, `.iter().map(count_ones).sum()`. Called for `pc` in
`node_key`, `w8_get` debug asserts, the segmented path, and `par_wins_inc`.

**Observation:** 4× `popcnt` + 3 adds. AVX512VPOPCNTDQ's `vpopcntq` does 8×u64 popcount in one
op, but here we have only 4 words and then need a *horizontal sum* (`vpaddq` reduce) — for 4
elements the scalar `popcnt`+add chain is as fast or faster (the horizontal reduce costs more
than it saves at width 4). Zen5's 4 `popcnt`/cycle throughput means the scalar form retires in
~1–2 cycles already.

- **Verdict:** **WASH** at WORDS=4. `vpopcntq` wins only when you popcount *many* `Bits` at once
  (e.g. counting all 8 orientations' popcounts together — but the search needs only `orient[0]`'s).
  Skip unless a future change needs batch popcounts.
- Real note: in `wins_inc` `node_pc` is already gated to `MODE != M_NORMAL` (`iso_flat.rs:692`),
  so production **doesn't compute it** — the popcount is already eliminated on the hot path. Good.

---

### 8. `enter_graph` insertion-sort by rank → branchless sorting network — **LOW/WASH**

**Where (verified):** `enter_graph` `iso_flat.rs:947-957`, an insertion sort of ≤7 vertices by
`order_rank`. Insertion sort has data-dependent inner-loop trip counts (the `while j>0 && rank[..]>r`),
a branch the predictor can miss — and this is on the #1 branch-miss path.

**Possible fusion:** a fixed branchless **sorting network** (k≤7: ~16 compare-exchange, each a
`cmov`/min-max pair) replaces the variable-trip insertion sort with a straight-line,
perfectly-predicted sequence. Sorting `(rank, vert)` pairs by rank.

- **Cost attacked:** the branch-miss (relevant!) — but the **op count goes up** (a network does
  more compare-exchanges than insertion sort's average case for nearly-sorted input, and the
  verts arrive in `child0.each` ascending-*square* order, not rank order, so it's not
  nearly-sorted). Net: trades branch-misses for ~16 straight-line `cmov`s.
- **Verdict:** **borderline — flag as likely wash, test only if 1+2 already landed.** On a
  frontend-bound machine, +instructions can hurt as much as −branches helps. The expected value
  is low and the k varies (network must be sized per k, or use a fixed k=7 net padded). Lower
  priority than 1/2 which attack the *same* region more cleanly. If you do try it, the cheap
  validation is a microbench of sort-time + a branch-miss perf counter delta at n=14.

---

### 9. `avail.each` vertex extraction in `enter_graph`/`w8_get` → `vpcompressq`/iterate-words — **LOW/WASH**

**Where (verified):** `w8_get` `iso_flat.rs:305-308` and `enter_graph` `:947` use `Bits::each`
(`bits.rs:69-78`) to pull set squares into `verts[]`. `each` is already the optimal
`tzcnt`+`blsr` scan per word.

- **Verdict:** **WASH** — `each` is already `blsr`/`tzcnt`, the canonical set-bit iteration. A
  `vpcompressq`-of-indices approach needs an index vector and a mask per word and then a
  cross-word offset — more setup than the 8 `tzcnt`s it replaces at this size. Skip.

---

### 10. `comp_nimber`/`position_nimber` flood-fill `component` — **N/A (oracle/cold, dead in production)** 

`component` `graph.rs:1350` (flood-fill) is only reached from the oracle and the WL/cold key
paths, both **dead at the default `iso_max_avail=7` with oracle off**. No production spend.
Listed to close the loop.

---

## Summary table (decision-grade)

| # | Target (file:line) | Fusion / identity | Cost attacked | Fermi upside | Impl cost | Verdict |
|---|--------------------|-------------------|---------------|--------------|-----------|---------|
| 1 | `enter_graph` closed-build `iso_flat.rs:964` | per-vertex `pext` for `closed`/`adj` (BMI2) | O(k²) branch + ops (**#1 branch-miss**) | ~3–6% | med | **BUILD** |
| 2 | `w8_get` edge-code `iso_flat.rs:312` (+ `tiny_edge_code`, `iso_key8_direct`) | per-row `pext`+shift pack (BMI2) | O(k²) frontend ops | ~2–4% | low-med | **BUILD (w8_get first)** |
| 3 | `child_orient` `incremental.rs:118` | 7 `and_not` → ~4 `vpandnq` (AVX-512F) | scalar `andn` decode in ~50% region | ~2–4% *if not already vectorized* | low | **CHECK ASM, then maybe** |
| 4 | `filter_moves` `iso_flat.rs:133` | `vpcompressb` stream-compaction (VBMI2) | serial `nc` dep chain | ~1–3% | med | **MICROBENCH FIRST** |
| 5 | `hash128` `tt.rs:622` | — | — | 0 | — | WASH (serial mix; dual chain already overlaps) |
| 6 | `comp_nimber` mex `iso_flat.rs:542` | — | — | 0 | — | already minimal + **dead in prod** |
| 7 | `Bits::popcount` `bits.rs:55` | `vpopcntq` | — | 0 | — | WASH at WORDS=4 (prod already skips `pc`) |
| 8 | `enter_graph` insertion sort `iso_flat.rs:947` | branchless sort net | branch-miss vs +ops | ~0–1% | med | likely WASH; test only after 1/2 |
| 9 | `avail.each` extract `iso_flat.rs:305` | `vpcompressq` | — | 0 | — | WASH (`each` already blsr/tzcnt) |
| 10| `component` `graph.rs:1350` | — | — | 0 | — | N/A (dead in prod) |

## Recommended sequence

1. **#2 on `w8_get` first** — single fixed-k target, ~6% of cycles, cleanest correctness
   (same labelled code), exhaustively testable. Highest confidence-per-effort.
2. **#1 (`closed`/`adj` via `pext`)** — attacks the #1 branch-miss site; bigger but more
   structural. Do it second so you've proven the `pext`-pack helper in #2.
3. **#3 only after an asm check** — if `child_orient` is already `vpandn`'d, skip entirely.
4. **#4** behind an isolated microbench gate; the survivor-mask build is the make-or-break.

All four hold the equivalence gate by construction (none change *which* graph/key is computed,
only how its bits are assembled). Validate each with `solve 12 iso-flat --distinct` =
1,060,823 + interleaved n=14 `iso-window` A/B; keep only on a measured ≥1% win, else record as
an instructive negative per the perf-discipline rule.

## Channel-Fermi caveat (stated up front)

These are frontend/op-count plays on a latency-bound search where per-node micro-opts have
historically washed to ~0–5% (CLAUDE.md). The reason to expect *some* of these to stick where
slot-shrink/terminal-fast-path didn't: they attack the **measured** binding constraint
(27% frontend-idle + 10% branch-miss) directly, by deleting O(k²) inner loops and a
data-dependent branch from the two hottest regions — not by shaving a latency-bound DRAM probe.
If the bench disagrees with a napkin by an order of magnitude, the model's wrong: re-read the
TMA at a wider angle (is the band region actually I-cache-bound, or is it the `tiny_tt`/`memo`
load?) before iterating on the assumed cost.
