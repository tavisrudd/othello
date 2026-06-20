# getK throughput recovery — making the W9/W10/W11 dense evaluator cheaper per node

**Date**: 2026-06-19
**Scope**: micro-perf review of the just-landed W_K (W9→W10→W11) dense low-popcount evaluator.
**Status**: READ-AND-REASON proposal. No source modified. Channel-Fermi estimates + dedup verdicts
vs the iso-window micro-opt scorecard; one top recommendation with an A/B plan.

---

## 0. The number we are trying to recover

Raising the dense ceiling K cut total nodes hard (deterministic n=14: 27.5M → 22.5M → 18.8M → 15.7M for
K=8/9/10/11) but throughput fell **29.4 (K=9) → 27.8 (K=10) → 24.3 (K=11) M/s** because `get10`/`get11`
execute *more compute per node* than the flat-TT probe they replace. The wall still won (less total work),
but we want the lost M/s back to push the wall further.

**The single most important context for this review** (from `notes/handoffs/2026-06-18-iso-window.md`,
measurement #0 + the dense-block verdict): the deep region is **co-dominant — backend-by-memory ~35% and
frontend-by-latency ~26%, i-cache-bound; recursion/RAS measured DEAD (0.003%)**. getK is a *frontend lever
that trades memory for compute*: each pc==K node stops issuing a random DRAM probe (drains backend-by-memory)
but executes a larger inlined body (adds to the 26% frontend bucket + raw instruction count). The W8-base
dense block measured this exact trade and **lost** (+17% cyc/node: it "converted ~64 cyc/node of memory stall
into ~330 cyc/node of executed instructions"). getK wins where the block lost *only because its W0..W8 base is
complete* (zero re-expansion) — so the saving is real, but **every cycle we add to the getK body lands
directly in the frontend bucket that is already the second-largest stall.** That is the whole game here:
**shrink the getK body's instruction count and i-cache footprint, do not just "make it look vectorized."**

This also flags the dominant risk up front: the scorecard already killed `pext`-on-small-data
(`tiny_table_index` pext edge-code = **−19% M/s**, instr +20%) and SIMD-gather (`lex_min8` = **+15% CPI,
−9% M/s**) with the lesson *"wide instructions lose on small data; the queens hot regions are small-data."*
Several of the obvious candidates here are exactly that pattern and must be flagged, not boosted.

---

## 1. Where the per-node cost lives in the getK path

Two cost centers per pc∈9..K node, in the order they execute:

### (A) The `wK_get` **code-builder** in `iso_flat.rs` — the board→code projection
`w9_get`/`w10_get`/`w11_get` (`src/queens/solver/iso_flat.rs:493/519/545`) are byte-for-byte the same shape
as `w8_get` (`:467`). Per node:
1. `avail.each(|v| verts[n]=v)` — scatter the K live board squares into `verts[K]` (one `each` walk over the
   256-bit `Bits`, `iso_flat.rs:498-501`).
2. A **scalar double loop** building the K·(K-1)/2-bit labelled code one adjacency bit at a time
   (`iso_flat.rs:505-511` for W9):
   ```rust
   for i in 0..K {
       let row = att08(att, verts[i]);          // Bits ([u64;4]) attack row of board-square verts[i]
       for &vj in verts.iter().take(K).skip(i+1) {
           code |= (row.get(vj as u32) as u64) << bit;   // row.get = (vj/64) word select + shift + test
           bit += 1;
       }
   }
   ```
   This is **K·(K-1)/2 `Bits::get` calls** = 36 (W9) / 45 (W10) / **55 (W11)**. Each `Bits::get`
   (`bits.rs:26`) does `vj/64` word index + `1<<(vj%64)` + AND + bool — and `vj` is a *board* square index
   (0..255) scattered across the 4 words, so it is a genuine variable-word indexed load, not a fixed shift.
   **This is the biggest redundant per-node cost** and it is what grows W9→W10→W11 (36→55 bits), matching the
   observed M/s decay. The handoff already flagged the W8 twin: `perf annotate` of the analogous `band_entry`
   tiny-edge-code build showed `code |= edge_bit(...)` at **31%** + vert-extraction at **~32%** of that
   symbol's cycles (`iso-window.md:571`), so the code-build + vert-scatter together dominate the symbol.
3. `dense8.as_ref().expect(...)` on every call (`iso_flat.rs:494/520/546`) — a branch + panic path inlined
   into the hot body. The handoff explicitly lists this as a deferred nit for `w8_get` (`iso-window.md:156`:
   "thread `&DenseW8` in, or `unwrap_unchecked` + SAFETY"); it now also taxes w9/w10/w11.

### (B) The `getK` **child sweep** in `dense.rs` — the evaluator proper
`get9`/`get10`/`get11` (`dense.rs:201/228/258`) per node:
1. `extract_adj::<K>(code, &WK_MASKS.0)` (`dense.rs:56`) — K `_pext_u64` + per-i shift/mask to recover the
   adjacency rows. K is `const` so it unrolls.
2. The child loop, K iterations (`dense.rs:210/235/265`): per child, one `_pext_u64` to project the child
   code (`WK_MASKS.1[child as usize]` — a **4096/2048-entry table load**, the `induced` mask), one
   `child.count_ones()`, and a lookup.
   - `get9`: every child is ≤8 → one `self.get` table lookup. Clean, branch-light.
   - `get10`: per child a `cpc==9` branch → either nested `get9` or `self.get` (`dense.rs:241-245`).
   - `get11`: per child a `match cpc {10=>get10, 9=>get9, _=>get}` 3-way runtime branch (`dense.rs:270-274`)
     **plus** the recursion. This is where W11's extra frontend/branch cost concentrates.

**Recursion frequency (verify, then don't over-optimize the rare path):** the handoff's own framework note
(`iso-window.md:1304`) says cost grows *sub-factorially* — "a move removes a closed neighborhood `N[v]`, so a
child drops `1+deg(v)` vertices; most children of a pc-10/11 node land in **W8 directly**, not W9." A nested
`get9`/`get10` only fires for a **degree-0 (isolated) vertex** in the parent graph (child keeps K-1 vertices
only if `deg(v)=0`). In a Node-Kayles available graph at pc 10/11 isolated vertices are uncommon, so the
recursion is rare — confirmed by the design intent. **Implication: the recursion path is NOT the lever; the
`extract_adj` + per-child `_pext`/`count_ones`/dispatch on the *common* (lands-in-W8) path is.**

### Cost weighting (why this matters at all — the legitimacy check)
From the n=14 put histogram (`iso-window.md:284`): **pc==9 alone is ~21.6% of all nodes; pc 9–12 is ~61%.**
So the getK body executes on a *majority* of nodes. This is the standing "micro-opts wash to 0–5%" caveat's
genuine exception: getK compute is now a real per-node fraction (that's the entire point of W11), so recovering
it is legitimate — **but bounded.** Channel-Fermi ceiling: M/s fell 29.4→24.3 (K9→K11) ≈ **−17% throughput**
from the *added* getK compute. The recoverable prize is at most that 17% (getting K=11's per-node cost back
down toward K=9's), realistically **half of it (~8–10% M/s)** because part of the K9→K11 delta is the extra
*nodes* each pc-10/11 node sweeps (irreducible — it's the evaluator's actual work), not redundant build cost.

---

## 2. Prioritized micro-opt candidates

Ordered by expected-value / risk. Each: mechanism, Channel-Fermi upside, risk, dedup verdict.

### C1 — Replace the scalar bit-by-bit code-build with a per-row word gather (TOP, see §3)
**Mechanism.** The inner `for vj { code |= row.get(vj) << bit }` re-derives, for a fixed row `i`, the
adjacency of `row` against K-1 scattered board squares one bit at a time. Instead, recognise that the *child
projection* in `getK` already takes the labelled code apart with `pext`. The redundancy is between (A) and (B):
the code-builder packs board adjacency into a labelled code, then `extract_adj` *immediately unpacks it back*
into `adj[K]` rows. **Fuse them**: build `adj[i]` (the K-bit local adjacency of vertex `i` against the other
verts) directly, skipping the labelled-code round-trip, and feed `adj` straight to a child sweep that no longer
needs `extract_adj`. Two sub-forms:
  - **C1a (low-risk, recommended first):** keep the labelled-code interface but build each row's contribution
    with fewer ops — for row `i`, the K-1 target squares `verts[i+1..]` are known; gather is still scalar but
    hoist `row`'s 4 words into registers once per `i` (they are re-loaded per `vj` today through `row.get`),
    and accumulate into a `u64` with `bit` advancing — i.e. the *same* algorithm but row-word-hoisted so each
    `vj` is `(word_hoisted[vj>>6] >> (vj&63)) & 1` against registers, not a fresh `Bits::get`. Pure scalar,
    small-data-safe.
  - **C1b (higher-value, more risk):** build `adj[K]` (K-bit local rows) directly and pass `&adj` to a
    `getK_from_adj` that drops `extract_adj` entirely. The child code projection then uses the `induced` mask
    over the *local* (K-bit) labelled code, which we still build once from `adj` (cheap: K small ORs). This
    removes K `pext`s (extract_adj) **and** the labelled-code↔adj round trip.

**Channel-Fermi.** The build is ~K²/2 `Bits::get` (55 at W11) and `extract_adj` is K `pext`. Fusing removes the
round-trip (~K pext + K shifts) and word-hoisting cuts the build from "K²/2 indexed `Bits::get`" to "K²/2 ops
against 4 hoisted registers." On W11 that is roughly halving the (A)-side op count, and (A) is the part that
grew W9→W11. If (A) is ~⅓–½ of the getK body (consistent with the 31%+32% annotate split on the W8 twin), and
getK is ~61% of nodes, the napkin lands at **~4–8% M/s** recovered — squarely in the legitimate-ceiling range.

**Risk.** Low for C1a (algorithm-identical, just register-hoisted; the compiler *may* already do some of this —
must verify on the actual znver5 asm, see §3). Medium for C1b (changes the dense.rs interface; must re-pass
`direct_wK_matches_scalar_recurrence` and the solver gate). **Strictly scalar — no wide instructions.**

**Dedup verdict.** **Does NOT resemble a scorecard negative.** The killed candidates were *wider* instructions
on *small* data (pext/BITALG/SIMD-gather adding fixed setup). C1 goes the *opposite* direction: it *removes*
ops (fusion + register hoisting), staying scalar. The pext-edge-code negative (−19%) is specifically the
*opposite* move (replacing a scalar loop with pext) — C1 is its inverse and is exactly what the "minimal scalar
loop wins on small data" lesson endorses.

### C2 — Drop the per-call `.expect()` on `dense8.as_ref()` (thread `&DenseW8` in)
**Mechanism.** `w9_get`/`w10_get`/`w11_get` (and `w8_get`) each do `self.dense8.as_ref().expect(...)` per node.
The `WINDOW`/`DK` const generics already guarantee `dense8` is `Some` at these call sites. Either (i) thread
`&DenseW8` as a parameter resolved once at the subtree handoff (cleanest, matches the env-var-once discipline),
or (ii) `unsafe { self.dense8.as_ref().unwrap_unchecked() }` with a `// SAFETY: WINDOW ⇒ Some` note.
**Channel-Fermi.** One branch + a dead panic-string/format path inlined into the hot body per node, on ~61% of
nodes. The branch is trivially predicted (always-Some) so the *cycle* cost is ~0 — **but the panic path is dead
code bloating the i-cache footprint of the hot body**, and the i-cache footprint *is* the measured #2 stall
(the PROVE_LOSS collapse won −74% MPKI purely by removing dead duplicated body). So the upside is an i-cache
shave, not a cycle shave: **~1% M/s, but free + de-risks SMT** (same character as the shipped PROVE_LOSS win).
**Risk.** Very low (option i is safe Rust; option ii is a one-line `unsafe` with an obvious invariant).
**Dedup verdict.** Not a scorecard item. Aligns with the handoff's own deferred-nit list (`:156`) and the
"shrink the hot body footprint" lever that demonstrably worked (PROVE_LOSS). **Bundle with C1.**

### C3 — Hoist `child.count_ones()` / lift the per-child dispatch out of the common path (W10/W11)
**Mechanism.** `get10`/`get11` compute `child.count_ones()` per child and branch on it. For `get11` the
`match cpc {10,9,_}` 3-way branch is per child. Since the *common* case is "child lands in W8" (deg>0), reorder
so the W8 lookup is the fall-through (predicted) path and the nested-getK is the cold arm; and compute the
child code first (`pext`) — `count_ones` of `child` (a u16) is one `popcnt`, cheap, but the *branch* on it is
the frontend cost. Consider a `#[cold]`/`#[inline(never)]` on the nested `get9`/`get10` calls so the rare
recursion does not inline its whole body into `get11`'s hot loop (shrinks `get11`'s L1i footprint — the same
mechanism as PROVE_LOSS).
**Channel-Fermi.** The recursion is rare (§1B), so this is a *footprint* play not a cycle play: keeping the
nested `getK` bodies out-of-line shrinks `get11`'s hot inline footprint. **~1–2% via i-cache**, mostly at W11
(where the 3-way branch + double recursion live). Negligible at W9 (no dispatch).
**Risk.** Low. `#[inline(never)]` on a rarely-taken arm can only help frontend if the arm is truly cold;
verify the recursion frequency first (a one-line counter in the standalone bench, §3) so we don't outline a hot
path. The handoff notes call-overhead *may* cancel for `lex_min8`/`child_orient` (`:717`) — so **measure**, but
here the outlined path is genuinely rare, unlike those.
**Dedup verdict.** Directly mirrors the **shipped** PROVE_LOSS win (remove inlined body from the hot path →
MPKI down). Not a scorecard negative. Lower-confidence than C1/C2 because the rare-path assumption must hold.

### C4 — Vectorize the code-build with `pext`/gather over attack-row words  ⚠️ FLAGGED
**Mechanism.** Build the labelled code by `pext`-ing each attack `Bits` row against a mask of the live-square
positions, or gather K rows and SIMD-pack. Superficially attractive: "one `pext` per row instead of K-1
`Bits::get`."
**Channel-Fermi.** *Looks* like K `pext` replaces K²/2 scalar ops. But the verts are scattered across **4**
64-bit board words, so a single `pext` per row only handles the verts in one word — you need up to 4 `pext`s
per row plus stitching, and a `vpgatherdq`/compress to assemble. On K=9..11 (tiny) the fixed setup dominates.
**Risk.** High.
**Dedup verdict.** **RESEMBLES TWO MEASURED NEGATIVES.** This is *exactly* the pext-edge-code change that cost
**−19% M/s** (`tiny_table_index`, "instr +20% from 4-word overhead × tiny comps") and the SIMD-gather lex_min8
that cost **+15% CPI / −9% M/s**. The handoff's banked lesson is explicit: *"Wide instructions lose on small
data … pext (k≤4 comps) lost its fixed setup to minimal scalar loops … SIMD/pext only pay on the rare long-list
/ large-component tail."* K=9..11 over a 4-word board is small data with multi-word scatter — the worst case
for pext. **Do not implement this without a standalone microbench proving break-even first, and expect it to
lose.** Listed only to record the dedup so it is not re-proposed.

### C5 — Vectorize multiple children at once (batch the child sweep) ⚠️ FLAGGED / deferred
**Mechanism.** The child loop does K independent `pext` projections + lookups. In principle gather all K child
codes, vectorize the table lookups.
**Channel-Fermi.** The lookups are into the *bit-packed* W≤8 tables (`bit_get`), which are random-indexed bit
tests — not gather-friendly (each is a word load + shift + mask at a computed index). SIMD gather of bits buys
little; the per-child `pext` is already minimal. And the loop has an early-out (`if !self.get(...) return
true`) — vectorizing forfeits the early-out, doing *more* work on win nodes.
**Risk.** High (forfeits early-out; same small-data trap as C4).
**Dedup verdict.** Same family as C4. The early-out forfeit is an additional, independent reason it likely
loses. **Defer; do not implement before C1–C3 are measured.**

### C6 — Precompute `verts` once and share it between (A) and the sweep (minor)
**Mechanism.** `wK_get` builds `verts[K]` via `avail.each`; `getK`'s `extract_adj` then reconstructs adjacency
from the code. If C1b fuses build+sweep, `verts` is already shared. As a standalone, this is subsumed by C1b.
**Verdict.** Subsumed by C1b; no independent action.

---

## 3. Top recommendation + A/B plan

**Implement C1a + C2 together first** (register-hoist the code-build + drop the `.expect()`), measure, then
decide on C1b/C3. Rationale: highest expected value (C1 attacks the part that *grew* W9→W11 and runs on ~61% of
nodes), lowest risk (both are scalar/footprint, both go *with* the grain of every banked lesson — minimal
scalar loop + shrink the hot body — and *against* every scorecard negative), and C2 is essentially free and
de-risks SMT exactly as the shipped PROVE_LOSS collapse did.

**Before touching solver source — confirm the cost with the existing standalone harness (no solver edit):**
- `src/bin/w9_purity_bench.rs` already `#[path]`-includes `dense.rs` and times the scalar W9 solve
  (`solve_ns`/graph). `src/bin/dense_window_bench.rs` and `ddd_bandwidth_bench.rs` (`BENCH_ONLY=w9_direct`)
  exercise the getK/direct-address path. Build with `make` (znver5!) and `perf annotate` the getK/code-build
  to confirm the (A) double-loop and `extract_adj` split *on this box's asm* — the handoff's "wide-loses"
  lessons all came from annotate, and C1a's premise (the compiler is NOT already hoisting `row`'s words) must
  be checked on the real binary before coding. A standalone `getK` driver over random codes + a node-counter
  for nested-`getK` frequency (validates §1B's "recursion is rare") is buildable in a bench bin without
  touching the solver.

**The A/B metric — NOT wall.** Per the perf discipline, compare **CPI and instr/node** (node-count- and
thermal-independent) plus i-cache MPKI, interleaved A/B on **n=16 `iso-dense`** (`QUEENS_DENSE_K=11`), via
`perf stat -M PipelineL1,PipelineL2 -D 30000` (skip warm-up). The pass condition:
- **instr/node down** (C1 removes ops on the ~61% getK nodes) — the primary signal, since this is a compute
  lever and the dense-block post-mortem showed instr/node is what moved the needle (+39–66% there).
- **i-cache MPKI down or flat** (C2/C3 footprint shaves), CPI down or flat.
- M/s up *only as a confirming, thermally-noisy secondary* (run interleaved, trust CPI over M/s — the
  PROVE_LOSS A/B showed M/s was thermally confounded across sequential runs).
- **Gate (mandatory):** `solver_lineage_agrees` (n≤9) + `solve 12 iso-flat --distinct` = 1,060,823 + `solve 14
  iso-flat --distinct` ≈29.2M / ~1.0× re-exp, **and** `direct_w9/w10/w11_matches_scalar_recurrence`
  (dense.rs tests) green. getK is value-bearing — any code-build refactor must hold all four.

**Channel-Fermi summary of the ceiling:** the whole getK-added cost is ~17% M/s (K9→K11). C1+C2+C3 realistically
recover **~5–10% M/s** at K=11 (toward K=9's per-node cost), bounded because part of the K9→K11 delta is
irreducible evaluator work (more children swept), not redundant build cost. If C1a's annotate shows the
compiler already hoists the row words (build is not redundant), the prize shrinks to C2+C3's ~2–3% footprint
shave — in which case stop and bank that; do not chase C4/C5 (measured-negative family).

**Do NOT implement C4 or C5** without a standalone microbench proving break-even — both are the small-data
pext/SIMD pattern the scorecard already killed twice (−19%, −9%).

---

## 4. Perf verification (2026-06-19, `perf record` on a live n=16 iso-dense DK=11 run)

Recorded the real solver (not the standalone bench) and annotated. This **refined** the proposal:

**Symbol self-cycles (aggregated across workers):** `wins_inc` 52.2%, `band_entry` 9.9%, **`w11_get` 8.1%,
`w8_get` 7.6%, `w9_get` 6.3%, `w10_get` 5.5%** (the four code-builders = **~27%**), `get10` 3.2%, `get9` 2.4%.
So the `wK_get` code-build is a real, large fraction — C1's premise holds.

**The decisive finding the napkin missed: the compiler ALREADY auto-vectorizes the code-build for K≤9.**
`w8_get`/`w9_get` annotate to an AVX gather (`vmovups ymm0` + `kxnorw`/`vpgatherdd`-style) — no hot scalar
`bt`. **`w10_get`/`w11_get` fall back to scalar `bt`-per-bit** (`row.get(vj)`): w10_get's `bt`s = ~29% of its
cycles, w11_get's = ~18%. So:
- **C1a (manual register-hoist) is the WRONG move for K≤9** — it would fight, and likely lose to, a vectorizer
  that is already doing better than hand-hoisting. And it is moot for K=10/11 (they're already scalar; hoisting
  the words won't recover the vectorization the compiler declined).
- **The real lever is to get the compiler to vectorize K=10/11 the same way it does K≤9** — via the *compiler's*
  vectorizer (uniform loop shape / verts padding), NOT hand-rolled SIMD (which is the −19% C4 negative). 11 is
  not a clean lane count (8/9 fit a gather; 10/11 don't), so this is a real but uncertain codegen-shaping task.
  Prize is bounded: the K=10/11 scalar build is ~3% of total cycles (those pc are rarer than pc≤9).

**C2 confirmed small but real + a bonus finding:** the `dense8` None-check (`test %r8; je <panic>`) is ~0.5% at
each `wK_get` entry, AND the `verts[]` scatter (`avail.each`) carries `panic_bounds_check` blocks in every hot
body. **Landed both as a value-preserving i-cache shave:** `unwrap_unchecked` for `dense8` + `get_unchecked_mut`
for the `verts` write (SAFETY: dispatched only at pc==K ⇒ Some / n<K). Gate-green, n=14 nodes identical
(15,724,135). Prize is below n=16 wall noise but zero-risk and aligns with the banked PROVE_LOSS frontend win.

**Revised recommendation order:**
1. **Compiler-vectorize the K=10/11 code-build** (the throughput-recovery lever; compiler-driven, ~3% ceiling).
2. **K=12** (the bigger *amortization* lever — extend the table-resolved reach; needs a `u128`/two-word code).
3. **C1b/C3** are **demoted** — C1b (build adj in `wK_get`, skip `extract_adj`) trades K cheap pexts for ~K²
   OR-ops (net more ops, likely negative); C3 (outline the recursion) is moot since the recursion is rare and
   `get9` is hot directly. Skip both.
4. **Incremental code maintenance is BLOCKED** — removing a vertex relabels the compact 0..K labeling wholesale,
   so the code can't be carried down the tree; it must be rebuilt at each pc==K (the inherent O(K²) cost).

---

## 5. Reshape experiment — uniform-gather code-build is a MEASURED NEGATIVE (2026-06-20--11)

Tried recommendation #1 the compiler-friendly way (no hand-SIMD): replace the triangular
`for j in i+1..K { code |= row.get(verts[j]) << bit }` build of `w10_get`/`w11_get` with a **uniform
fixed-trip rectangular gather** — build each vertex's full K-bit adjacency row (`for j in 0..K` against the
`verts.iter().enumerate()`, the iterator shape the compiler already vectorizes at K≤9), store in `rows[K]`,
then pack the 45/55-bit triangular labelled code in a cheap scalar second pass. Result-identical by
construction (byte-identical code bits); gates green (clippy/fmt/test; n=12 nodes 728,970 and **n=14 nodes
12,896,443 byte-identical** baseline vs reshaped, single-core deterministic).

**Measured (n=14 iso-dense, single-core, deterministic ⇒ `instructions:u` is an exact count, not noisy):**

| binary | instructions | cycles | instr/node | cyc/node |
|--------|--------------|--------|-----------|----------|
| baseline (scalar triangular) | 468.92 G | 152.43 G | 36,361 | 11,820 |
| reshaped (uniform gather) | 471.42 G | 153.02 G | 36,555 | 11,866 |
| **Δ** | **+0.53%** | +0.39% | **+194** | +46 |

**Verdict: REVERTED (off main, empty diff).** Instruction count went *up* deterministically — the rectangular
gather does ~2× the bit-tests (K² vs K²/2) and the compiler did **not** vectorize the K=10/11 reshape into a
net win, so the extra work is pure overhead. This is precisely the proposal's own prediction ("more ops to
vectorize … expect it to lose") and the banked small-data/multi-word-scatter lesson (C4 pext = −19%). **The
K=10/11 build-vectorization lever does not pay via loop-reshape; the compiler's refusal to gather 10/11 lanes
is not worked around by a uniform-shape rewrite.** Bank as an instructive negative; the getK code-build's ~3%
ceiling stays unrealized and would need a fundamentally different attack (not identified). **Stop chasing it —
the work-shrink/dedup levers (A'' sorted-frontier) are the higher-EV bet.**
