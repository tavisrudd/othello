# W12/W13 dense evaluator — bit-level / ISA-level cheaper-equivalents

**Date**: 2026-06-19
**Scope**: instruction-set / bit-manipulation review of the `u128` two-word `getK` path
(`get12`/`get13` + `pext128`/`pext128_wide`/`extract_adj128` in `dense.rs`, and the
`w12_get`/`w13_get` code-builders in `iso_flat.rs`). A sibling agent covers the algorithmic angle.
**Status**: READ-AND-REASON. No source modified. Each idea: mechanism, exact-equivalence argument,
Channel-Fermi cost, scorecard-dedup. One top recommendation + a node-independent A/B plan.

---

## 0. The number we are recovering, and the standing constraint

W12 is the measured economic optimum (n=16 1m39s); W13 is **net-negative (+4% wall)** because
`get13`'s per-node `u128`-wide compute now exceeds the −15% node saving. So the prize is:
**make `get12`/`get13` cheaper per node** to (a) widen W12's margin and (b) potentially flip W13
positive (and unlock W14 reach later). The whole `wK_get` code-build is ~27% of total cycles
(perf, measured); `get12` was the single biggest kernel symbol at 11.3% → 8.0% after the recent
`[u64;2]`-build fix; the `get12`/`get13` child sweep adds the `extract_adj128` + per-child
two-word `pext` + `count_ones` + dispatch on top.

**The load-bearing constraint, from the iso-window scorecard (PART A) and the getK throughput
proposal (§4 perf verification):**

- **Wide instructions LOSE on small data here, measured twice.** `pext` edge-code
  (`tiny_table_index`) = **−19% M/s** (instr +20% from 4-word overhead × tiny comps); SIMD-gather
  `lex_min8` = **+15% CPI / −9% M/s**. BITALG move-filter = wash. The banked lesson: *"SIMD/pext
  only pay on the rare long-list / large-component tail; minimal scalar wins on small data."*
- **The compiler ALREADY auto-vectorizes the K≤9 code-build** (AVX gather) and **bails to scalar
  `bt`-per-bit for K≥10** — so the W12/W13 builders are *already* scalar; hand-rolling SIMD there
  is the −19% pattern.
- The deep region is **co-dominant: backend-by-memory ~35% + frontend/i-cache ~26%**. getK trades
  a DRAM probe for an inlined body, so **every instruction added to the getK body lands in the #2
  (frontend/i-cache) stall.** The lever is *fewer instructions and smaller i-cache footprint*, not
  "looks vectorized."

So the productive moves here are **scalar op-count / table-load / footprint shaves on the `u128`
path** — not new wide instructions. GFNI/VPCLMULQDQ/AVX-512 are evaluated below and, with one
narrow exception, all land on the wrong side of that line. The dedup verdicts are blunt about it.

---

## 1. Where the `u128`-path cost actually is (the two cost centers)

**(A) `w12_get`/`w13_get` code-build (`iso_flat.rs:586/619`)** — per node:
1. `avail.each` scatters the K live board squares into `verts[K]` (one walk over the 256-bit
   `Bits`).
2. A scalar double loop building the 66/78-bit code one bit at a time, now into `[u64;2]`:
   `words[(bit>>6)] |= (row.get(vj) as u64) << (bit&63)`. `bit` is compile-time per unrolled step,
   so `bit>>6` and `bit&63` const-fold; `row.get(vj)` is the live op = `(word[vj>>6] >> (vj&63))&1`
   over a **board** square `vj ∈ 0..255` scattered across **4** `u64` words. That's K·(K-1)/2 =
   **66 (W12) / 78 (W13)** variable-word-indexed bit-tests. This is the part that grew W9→W13 and
   the compiler declined to vectorize at K≥10.

**(B) `get12`/`get13` child sweep (`dense.rs:375/403`)** — per node:
1. `extract_adj128::<K>` = K two-word `pext128` (2 `_pext_u64` each = **2K `pext`**) + per-i shift/mask.
2. K-iteration child loop: per child one `child = full & !((1<<i)|adj[i])`, one
   `child.count_ones()`, one **two-word `pext128`/`pext128_wide`** projection (load
   `WK_MASKS.1[child]` from a **64 KB (W12) / 128 KB (W13)** `u128` table = 2 dependent cache-line
   loads), then a `match cpc` dispatch to a table lookup or nested `getK`.

The recursion (nested `getK`) only fires for a **degree-0 (isolated) removed vertex** — rare in a
Node-Kayles available graph at pc 12/13 — so the **common path is the W≤8 table lookup**, and the
levers are the always-run `pext128` + table-load + `count_ones`, not the cold recursion.

---

## 2. Prioritized bit/ISA candidates

Ordered by expected-value / risk. Scalar op-count and table-shape ideas first (they go *with* the
banked grain); wide-instruction ideas last (flagged, they go against it).

### B1 — Fold `popcnt(mask_lo)` out of every `pext128` into the mask table (TOP, see §3)
**Mechanism.** `pext128`/`pext128_wide` recompute `let lo_bits = (mask as u64).count_ones()` on
**every call** — a `popcnt` whose input is the *constant* low half of `WK_MASKS.1[child]` (and the
incident masks in `extract_adj128`). The shift amount is a pure function of the mask, known at
table-build time. Store it alongside the mask: change the induced table from `[u128; INDUCED]` to a
companion `shift: [u8; INDUCED]` (or pack the `u128` mask + `u8` shift into a `#[repr(C)]` struct,
but a parallel `u8` array keeps the mask array's stride a clean 16 B — Tiger rule 5). Then
`pext128(code, mask, shift)` drops the per-call `popcnt`:
```
lo | (hi << shift)        // shift loaded with the mask, popcnt gone
```
`wk_masks128` already runs at `const` build time, so computing the shift there is free; it's
literally `induced[alive].count_ones()` of the low 64 bits, computable in the `const fn`.
**Correctness.** Bit-exact by construction: `shift` equals what `count_ones()` returns today, for
every entry; the result expression is unchanged. The `direct_w12/w13_matches_scalar_recurrence`
tests cover it directly. The incident-mask `extract_adj128` path can take the same treatment
(precompute its K shifts as a `[u8; MAX_DENSE_K]` companion to the incident array).
**Channel-Fermi.** `popcnt` is 1 µop / ~1c on Zen5 — cheap *individually*, but it runs **2K + K**
times per `get{12,13}` node (2 per `pext128` in `extract_adj128` over K rows = 2K, plus 1 per child
= K), i.e. **~3K = 36 (W12) / 39 (W13) popcnts per node removed**, each also breaking a
mask→popcnt→shift dependency chain that currently sits on the critical path before the `<<`. On a
frontend/i-cache-bound body, removing ~36 µops/node from the ~majority-of-nodes getK path is a real
**~1–3% instr/node + a shorter dep chain**. The companion `u8[]` table is tiny (4 KB W12 / 8 KB
W13) and is co-accessed with the mask (already a load), so the extra load is L1-resident and
near-free vs. the `popcnt` + dep-chain it removes.
**Dedup.** **Not a scorecard negative — it REMOVES ops** (precompute-a-constant), the inverse of the
−19% pext-add. Squarely the "minimal scalar" grain. The only watch-item is Tiger rule 5/8 (keep the
mask array's 16 B stride; the shift goes in a sibling array, not interleaved into the hot mask
record). **This is the cleanest, lowest-risk win on the `u128` path.**

### B2 — Skip the high-word `pext` when the child mask's high half is empty (common-case branch elision)
**Mechanism.** `pext128`/`pext128_wide` unconditionally do `hi = _pext_u64((code>>64), (mask>>64))`.
But a child code is the *induced* subgraph: when the child drops to ≤8 vertices (the common case,
≤28-bit code) the selected edge bits all live in the **low 64 bits of the labelled code** for most
labelings, so `mask_hi == 0` for those children and `hi` is a wasted `pext` of zero → `0`. Since
`mask_hi` is a known table constant, **precompute a per-child `hi_used: bool`** (or fold it into the
shift byte's sign bit / a sentinel `shift==0 && mask_hi==0`) and branch: when `mask_hi==0`,
`child_code = lo` directly — one `pext`, no high-word extract, no shift.
**Correctness.** Bit-exact: when `mask_hi==0`, `pext(_,0)==0` and `lo | (0<<s) == lo`. Same value,
fewer ops. Covered by the dense.rs equality tests.
**Channel-Fermi.** Removes **1 `pext` + 1 shift + 1 OR per child whose induced edges fit the low
word**. How often? For a W12 node, children dropping to ≤8 vertices (deg≥3 removed vertex) dominate,
and *whether* their edges fit bit<64 depends on the labeling — needs a one-line histogram from a
`count` run to size (see §3). If even half the children qualify, that's ~6 `pext`+shift+OR removed
per W12 node. **Risk: a per-child branch on `hi_used`** adds a predictable branch (the cold-vs-common
split is data-stable per child index, but the predictor sees a mixed stream) — on a frontend-bound
body a *mispredicted* branch can cost more than the `pext` it saves. **Must measure branch-miss%,
not just instr count.**
**Dedup.** Not a scorecard item directly, but it's branch-on-hot-path which the scorecard's "high
perf-attribution ≠ removable cost" caution applies to (the pc==0 reorder was a wash for exactly this
reason — replacing one op with a branch that stalls the same). **Medium-confidence; gate on
branch-miss%.** Lower priority than B1 (which has no branch).

### B3 — Split the `u128` induced table into lo/hi `u64` arrays (cache-line + load shape)
**Mechanism.** `WK_MASKS.1` is `[u128; INDUCED]` = 64 KB (W12) / 128 KB (W13). Every child load
pulls a full 16 B `u128` even though `pext128` immediately splits it into `mask as u64` and
`(mask>>64) as u64`. Store two `[u64; INDUCED]` arrays (`induced_lo`, `induced_hi`) so each is
8 B/entry and the `pext128` lo/hi halves are *direct* loads (no `>>64` extract, which on a `u128`
is a register-pair shuffle). The W13 `induced_hi` only ever holds ≤14 bits (78−64), so it could even
be a `[u16; INDUCED]` (16 KB) — but keep `u64` unless the smaller type pays.
**Correctness.** Identical values, just a different physical layout; `>>64` on a `u128` and reading a
parallel `hi[]` produce the same bits. Tests cover it.
**Channel-Fermi.** The `u128`→two-`u64` split today is cheap register ops (a `u128` in two GPRs is
already split), so the *compute* win is ~0. The real question is **cache footprint**: W13's 128 KB
`u128` table vs two 64 KB `u64` tables doesn't shrink total bytes, but the **hot** half is `lo`
(always read) — `hi` is only needed when `mask_hi≠0` (B2's common-skip case), so splitting lets the
`hi` array fall out of L1 when unused, halving the *touched* footprint to 64 KB/64 KB and improving
L1d residency of the hot `lo` table. **~0–1% via L1d**, mostly a *de-risking* of W13's larger table.
Fold this together with B1+B2 (they all restructure the table): one combined table of
`{lo: u64, shift: u8, hi_used: bool}` hot + a cold `hi: u64` side array.
**Dedup.** Pure representation/layout (Tiger rules 1–2), no wide instruction. Not a scorecard
negative. **Low individual value; bundle with B1/B2, do not ship alone.**

### B4 — Derive `adj` in `w12_get`/`w13_get` directly, skip the code→`extract_adj128` round-trip
**Mechanism.** `w12_get` builds the labelled `u128` code from the board; `get12` *immediately* calls
`extract_adj128` to unpack that code **back** into K adjacency rows via 2K `pext`. The builder
already has the K attack rows in hand (`row = att08(att, verts[i])`). It could emit `adj[i]` (the
K-bit local adjacency of vertex `i` against `verts[i+1..]` and below) directly and hand `&adj` to a
`get12_from_adj` that drops `extract_adj128` entirely — removing **2K = 24 (W12) / 26 (W13) `pext`
per node**. The child-projection `pext128(code, induced)` still needs the labelled `code`, but the
code is recoverable from `adj` by K cheap ORs (or kept as a byproduct of the build).
**Correctness.** `adj[i]` built from the board attack rows equals `extract_adj128(code)[i]` by
construction (both are "is edge (i,j) present"). Must hold the dense.rs tests **and** the solver
`--distinct` gate (it touches the `iso_flat.rs`↔`dense.rs` interface).
**Channel-Fermi.** Removes 2K `pext` (24/26) per node — larger raw op count than B1's popcnts. **BUT**
this was already evaluated in the getK throughput proposal (§3, item C1b/revised-#3) and **demoted**:
the verdict there was "trades K cheap pexts for ~K² OR-ops (net more ops, likely negative)" — because
building `adj[i]` from the *scattered board* rows is the same O(K²) `row.get` scatter the code-build
already does; you don't get the rows for free, you get them by re-scattering. To be clear: it
removes `extract_adj128`'s 2K pext but the W≤8 child projection *still needs the labelled code*, so
you build the code anyway and `extract_adj128` is the only thing saved — and `extract_adj128`'s pext
is already cheap on Zen5 (~3c, 1/c). **Net: likely a wash-to-marginal; the prior proposal said skip.**
I concur for W12/W13 specifically; the round-trip is real but the unpack is the cheap end.
**Dedup.** Not a wide-instruction negative, but **explicitly demoted in the sibling getK proposal** —
do not re-litigate without a microbench. Listed for completeness + to record the dedup. **Skip.**

### B5 — VPCLMULQDQ / GFNI / vpternlog for the projection or adjacency  ⚠️ FLAGGED (all skip)
**Mechanism (what the prompt asks).** Could carry-less multiply (`vpclmulqdq`), Galois affine
(`gf2p8affineqb`), or `vpternlogq` replace the two-word `pext` projection or `extract_adj128`?
- **VPCLMULQDQ:** clmul computes a carryless product (polynomial mult over GF(2)) — it spreads bits,
  it does **not** gather/compress them. `pext` is bit-*compress*; there is no clmul identity that
  compresses an arbitrary mask. Not an equivalent. (The hardware-fastpaths proposal already marked
  VPCLMULQDQ for the TT hash as *"MARGINAL — skip"*; for `pext`-compress it's not even applicable.)
- **GFNI `gf2p8affineqb`:** a programmable 8×8 bit-matrix×vector per qword lane. It can do a fixed
  *linear* bit-permutation/gather **within 8-bit granularity per lane**. The induced-edge projection
  is a fixed linear map (`pext` of a constant mask) over **66/78 bits across two words** — that
  exceeds one 8×8 lane and isn't byte-aligned, so it needs multiple `gf2p8affineqb` + cross-lane
  stitching + a `zmm` round-trip (GPR→`zmm`→GPR). The op-fusion proposal's own GFNI analysis
  concluded that for the *pack* (which is what this is) *"GFNI mainly helps if you also need the
  transpose … `pext` already minimizes the pack — likely a wash."* That was for a single 8×8 (W8);
  the `u128` path is **larger and split across lanes**, strictly worse for GFNI.
- **`vpternlogq`:** a 3-input bitwise LUT — it computes `f(a,b,c)` bitwise, no bit movement. It could
  fuse `full & !((1<<i)|adj[i])` (B6) but cannot do the `pext` compression.
**Channel-Fermi.** All three require moving the `u128` code GPR→vector→GPR. On Zen5 a GPR↔`zmm`
round-trip is ~2×6c latency *plus* the op — for a body that does ~K `pext` (each 3c, 1/c, and the
code is *already* in GPRs), the vector detour is pure added latency on a latency/frontend-bound path.
**Dedup.** **RESEMBLES the −19% pext and −9%/+15%-CPI SIMD-gather negatives directly.** Wide vector
op on small (≤78-bit) data already living in GPRs = the exact small-data-loses pattern, plus a
register-domain-crossing tax the scalar `pext` path doesn't pay. The op-fusion + hardware-fastpaths
proposals independently reached "wash/skip" for GFNI-pack and VPCLMULQDQ-hash. **Do not implement.**
Recorded so it isn't re-proposed.

### B6 — `vpternlogq`-style fuse of `full & !((1<<i)|adj[i])` (the child mask)  ⚠️ marginal
**Mechanism.** Per child the code computes `child = full & !((1u16<<i)|adj[i])`. As scalar `u16` ops
this is `or, not, and` (or `andn` + `and`) = 2–3 µops. A `vpternlogq` LUT does any 3-input bitwise
function in **one** µop — but only in a vector register, and these are `u16` scalars already in GPRs.
The scalar form is already ~2 µops via `andn` (BMI1, which the codegen uses for `& !`).
**Channel-Fermi.** Saving ~1 µop/child × K but at the cost of GPR→vector→GPR for a `u16`. **Net
negative** (same domain-crossing tax as B5). The scalar `andn` is already near-optimal.
**Dedup.** Same small-data/vector-detour family as B5. **Skip.**

### B7 — Hoist `count_ones()` / restructure the `match cpc` (frontend, common-case fall-through)
**Mechanism.** `get12`/`get13` compute `child.count_ones()` per child (1 `popcnt`, cheap) and `match
cpc {12→get12, 11→get11, …, _→get}`. The **common arm is the `_` (W≤8 table lookup)**; the nested
`getK` arms are rare (isolated-vertex children). Order the match so the W≤8 lookup is the predicted
fall-through, and mark the nested `get{12,11,10,9}` calls `#[cold]`/`#[inline(never)]` so their
bodies don't inline into `get13`'s hot loop (W13 currently can inline `get12` which inlines
`get11`… — a large i-cache footprint for a rare path).
**Correctness.** Pure control-flow reordering + outlining; identical values. Tests cover it.
**Channel-Fermi.** This is the **frontend/i-cache** lever — the same mechanism as the **shipped**
PROVE_LOSS collapse (−74% MPKI by removing inlined dead body). `get13` inlining the full
`get12→get11→get10→get9` ladder is a big hot-loop footprint for paths taken <~once per node.
Outlining the rare recursion shrinks `get13`'s resident body → **~1–2% via i-cache MPKI**, the #2
stall. **Verify the recursion is actually rare first** (one counter in a bench bin) so you don't
outline a hot path.
**Dedup.** Mirrors the **shipped** PROVE_LOSS i-cache win; not a scorecard negative. The handoff
flags `#[inline(never)]` *"call overhead may cancel — measure"* for `lex_min8`, but here the outlined
path is genuinely cold (unlike those). **Medium-confidence frontend shave; bundle with B1.**

### B8 — `count_ones` of `child` via the already-known parent (avoid recompute)  (minor)
**Mechanism.** `child.count_ones()` is recomputed per child. The parent knows `full.count_ones()==K`;
`child = full & !((1<<i)|adj[i])` so `cpc = K - 1 - adj[i].count_ones()` (the removed vertex `i` plus
its `deg(i)` neighbors, all within `full`). `adj[i].count_ones()` is one popcnt of the (already-held)
adjacency row — same cost as `child.count_ones()`, so **no win** unless `deg(i)` is carried from the
build. Subsumed by B4 if `adj` is built in `w*_get`. **No independent action.**

---

## 3. Top recommendation + A/B plan

**Implement B1 (fold `popcnt(mask_lo)` into a precomputed `shift` table), bundled with B7 (outline
the rare nested `getK`), and the B3 table-split as the carrier.** Rationale:

- **B1 is the cleanest equivalent-but-cheaper bit op on the `u128` path** the prompt asked for: it
  removes ~3K = **~36–39 `popcnt` per `get{12,13}` node** (the literal answer to *"Can `popcnt(mask_lo)`
  be precomputed/folded into the mask tables?"* — **yes, store the shift alongside the mask**), it
  shortens the mask→popcnt→shift dependency chain on the critical path, it is **bit-exact by
  construction**, it adds zero branches, and it goes *with* every banked lesson (precompute a
  constant, stay scalar, shrink op count). Zero resemblance to the −19%/−9% negatives.
- **B7** is the free frontend companion (PROVE_LOSS-class i-cache shave), conditioned on confirming
  the recursion is rare.
- **B3** is the table-restructure that B1 needs anyway (you're touching `wk_masks128`'s output type
  to add the `shift` companion) — do it in the same edit, lo/hi/shift co-located, hot fields first.

Explicitly **NOT** doing: B5 (GFNI/VPCLMULQDQ/vpternlog — small-data vector detour, the −19% pattern,
already "wash/skip" in two prior proposals), B6 (vector fuse of a scalar `andn`), B4 (demoted in the
sibling getK proposal — net-wash round-trip). B2 is **conditional**: prototype it only if a `count`
histogram shows a large fraction of children have `mask_hi==0`, and gate it on branch-miss%.

**The A/B metric — node-independent, not wall** (per perf discipline; wall is ±18% node-noisy and
thermally confounded on this box):
- **Primary: instr/node and cyc/node** via `perf stat -M PipelineL1,PipelineL2 -D 30000` (skip
  warm-up), **interleaved A/B** (alternate the two binaries round-by-round) on **n=16 `iso-dense`**
  at `QUEENS_DENSE_K=12` (and a second pass at `QUEENS_DENSE_K=13`, since flipping W13 positive is the
  stretch goal). B1's signature is **instr/node down** (~36 fewer popcnts on the getK-majority nodes)
  with **cyc/node down or flat** (dep-chain shorten). B7's signature is **i-cache MPKI down or flat**.
- **Secondary, confirming only:** M/s up — trust cyc/node over M/s (the scorecard showed M/s
  thermally confounded across sequential runs; run interleaved).
- **Build with `make release`** (znver5 + mold) — never bare cargo, or the pext/popcnt codegen and
  bench numbers are invalid.
- **Cheapest first step (no solver edit):** a `src/bin/` microbench that drives `get12`/`get13` over
  random 66/78-bit codes A/B (current popcnt-per-call vs precomputed-shift), asserting equality and
  timing ns/call — plus a counter for nested-`getK` frequency to validate B7's "rare" premise. The
  existing `w9_purity_bench.rs` / `ddd_bandwidth_bench.rs` already `#[path]`-include `dense.rs` and
  are the template.

**Correctness gate (mandatory, all must hold):**
- `direct_w12_matches_scalar_recurrence` + `direct_w13_matches_scalar_recurrence` (the dense.rs
  `u128` equality tests vs the scalar `wins_rec` reference) — **these are the bit-exactness gate**;
  B1's shift table and B3's lo/hi split are exactly equivalent only if these stay green.
- `solver_lineage_agrees` (n≤9) + `queens solve 12 iso-flat --distinct` = **1,060,823** + `solve 14
  iso-flat --distinct` ≈ **29.2M / ~1.0× re-exp**. getK is value-bearing — a code/key-touching change
  must hold the distinct counts. (B1/B3/B7 don't touch the labeling, so distinct should be byte-identical.)

**Channel-Fermi ceiling.** B1 removes ~36–39 popcnt/node + a dep-chain on the ~majority getK nodes →
realistically **~1–3% cyc/node**; B7 adds **~1–2% i-cache**; B3 is **~0–1% L1d** + W13 de-risk. Combined
**~2–5% per-node** on the `u128` path — bounded (the irreducible work is the K `pext` projections and
the child sweep, which are the evaluator's actual job), but it's the right kind of saving: it pushes
W12's margin and is the most plausible single lever to flip **W13 from +4% toward break-even**, which
is the stated goal. If the microbench shows the compiler *already* hoists the `popcnt` (it can't —
the mask is a runtime table load, not a constant — but verify on the real znver5 asm), the prize
shrinks to B7's footprint shave; bank that and stop. **Do not chase B5/B6** (measured-negative family).
