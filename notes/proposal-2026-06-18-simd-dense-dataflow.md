# Proposal: SIMD-dense dataflow — wide branchless passes over dense windows of the queens search

**Date**: 2026-06-18
**Status**: Design draft — no code changed. Hands a ranked menu of dataflow restructurings to the user.
**Scope**: Restructure the search's *data movement* so the hot work becomes wide, contiguous,
branch-free AVX-512 over dense arrays, instead of pointer-chasing recursive DFS with random TT probes.
**References**: [iso-window handoff](handoffs/2026-06-18-iso-window.md) (the solver, the perf model,
Codex's windowed-dataflow design), [theoretical floor](2026-06-16-queens-theoretical-floor.md),
[grouped-frontier DDD](proposal-2026-06-18-grouped-frontier-ddd.md), [war-stories](perf-methodology-warstories.md).

---

## 0. The anchor: what the perf model actually says (so we don't chase the wrong cost)

Three independent measurements agree that **n=16/17 GB is per-unit-cost-bound** — the win is making
each node cheaper, not visiting fewer (every node-count lever — set-assoc −7%, component-nimber −74%,
graph-iso-key −2.2× — has its node win eaten by per-unit cost). The cost budget, from TMA + `perf stat`:

| signal (iso-window, n=16) | value | source |
|---|---|---|
| IPC | ≈ 0.79 | war-story 8 |
| **branch-misses** | **≈ 22–24% of cycles** (143 B × ~16 cyc) | war-story 8 — *the elephant* |
| backend-bound-by-memory (selective-key TMA L2) | 34% | war-story 6 |
| frontend-bound-by-latency | 24% | war-story 6 |
| dTLB-load-misses | ~7–8% of cycles | war-story 8 |
| TT probe (pure-iso) | ~1% of cycles | war-story 6 |
| WL graph key (`comp_canon`/`wl_refine`) | **75% of cycles in *pure-iso*; near-0 in production** | war-story 6 |

Three load-bearing implications for *this* proposal:

1. **The graph key (WL) is NOT the production bottleneck.** It dominates only the *pure-iso* key mode,
   which the production solver deliberately abandoned for **selective keying** (cheap tiny-table ≤7 /
   cheap D4 above). So "batch the WL canon as a SIMD pass" (the obvious ask-#1 idea) attacks a cost the
   production path *already removed*. **Flagged as a likely wash — see §Washes.**
2. **The real budget is bad-speculation (branch-misses) + memory latency.** A dense/branchless
   restructuring earns its keep only if it removes mispredicted branches or converts random-latency
   probes into streamed/overlapped ones. That is the W8 template: it deleted both a branch-heavy ≤7
   recursion *and* a random TT probe per pc==8 subtree.
3. **Per-node micro-opts wash; amortization wins.** W8 (−45s) beat every micro-opt because it *skipped
   a subtree*, not because it shaved cycles. Rank dense-block ideas by *work-skipped × branch/latency
   removed*, not by raw SIMD width.

The board is `Bits = [u64;4]` = 256 bits = the low half of one `__m512i` (or one `__m256i`). The target
is znver5 (`make release`, `-C target-cpu=znver5`): native 512-bit datapath, AVX-512F + GFNI +
VPOPCNTDQ, 32 `zmm`. AVX-512 idioms are already in-tree (`_mm512_loadu_si512`,
`_mm512_cmpeq_epi64_mask`, `_mm512_test_epi64_mask`, `_mm512_srli_epi64`, `__mmask8`) on the parked
assoc-bucket branch — copy those, don't invent.

---

## 1. The shape of the hot path today (what we are restructuring)

`wins_inc` (D4/orientation region, pc > iso_max) recurses **one position at a time, depth-first**:
per node it runs `filter_moves` (branchless), then per move: `avail.and_not(att[sq][0])` (child gen),
a `Bits::ZERO` terminal test, `child_orient` (8× `and_not` — the 8 live orientations), `lex_min8`
(8-way scalar early-out min), `hash128`, a **random** TT `get`/`put`, and a single `prefetch_h` of the
*next* child. Cutoff on the first losing child.

Below pc ≤ 8 the path is already dense-ish: `w8_get` is one indexed bit load (the model); `enter_graph`
builds a `TinyGraph{adj,closed:[u8;8]}` once, then `solve_local` recurses in a 128-byte L1 memo over an
`alive:u8` bitmask — pure register/L1, no TT. `expand_graph` **already** gathers all ≤7 children and
issues every prefetch up front (a first taste of MLP batching), then resolves with cutoff.

The two structural weaknesses a SIMD-dense rewrite can attack:
- **DFS issues one random TT probe at a time** and can only prefetch the *next sibling* — it cannot
  overlap N independent DRAM round-trips because it doesn't have N keys in hand at once.
- **Every branch is per-node and data-dependent** (the cutoff, the `pc==8 / pc<=7 / pc<=iso_max / else`
  ladder, the terminal test). The cutoff is irreducible; the *ladder* and the *sibling independence*
  are not.

---

## 2. The ideas, ranked by (expected leverage ÷ implementation cost)

| # | idea | attacks | napkin upside | impl cost | verdict |
|---|---|---|---|---|---|
| **A** | MLP-batched prefetch stream over a sibling/cousin window | DRAM latency (34% mem-bound) | ~10–25% | **low–med** | **build first** |
| **B** | Dense `[u8;8]` block solver for the whole pc≤12 frontier subtree (W8-style, branchless) | branch-miss (24%) + latency + amortization | ~10–20% | med | **strong second** |
| **C** | SIMD-widen `solve_local` / `expand_graph` (the ≤7 L1 region) into a bitset-parallel DP | branch-miss + instr count in the highest-node-count region | ~5–12% | med | promising |
| **D** | Vectorize `child_orient` + `lex_min8` as one `__m512i` per node (8 orientations = 8 lanes) | instr count + a scalar min branch | ~3–6% | low–med | marginal, cheap to try |
| **E** | Branchless GFNI W8 code-build (replace the scalar 28-bit pack in `w8_get`) | instr/branch at pc==8 (~5% of nodes) | ~1–3% | low | tie-breaker only |
| **W** | Batch the WL graph key as a wide SoA SIMD pass | the *pure-iso* WL cost | ~0% (production) | high | **likely wash — §Washes** |
| **Z** | Full layered DDD over dense popcount layers (loses α-β) | — | negative at n=16 | very high | **parked — §Washes** |

The throughline of the winners (A, B, C): **gather a window of independent work into a contiguous dense
block, then sweep it branch-free.** A does it for *probes* (latency); B/C do it for *subtree solves*
(branches + amortization). None of them touch the WL key, because the production path doesn't run it hot.

---

## 3. Idea A — MLP-batched prefetch stream (software-pipelined TT probes)

### Dataflow restructuring
Today the DFS holds one key and prefetches one sibling. Restructure a *bounded window* of independent
positions — the children of a prove-a-loss node, or a small BFS frontier collected before recursing —
into a **dense SoA staging buffer**, then run a 3-stage software pipeline over it:

```
// Stage 1 (wide, branchless): for each of W queued children, gen child0, compute (route, fp),
//   write into SoA columns:  keys[], routes[], fps[], pcs[]   (contiguous Box<[_]> / stack arrays)
// Stage 2 (wide): issue _mm_prefetch on slots[index(route)] for ALL W — N independent DRAM
//   round-trips now in flight at once (MLP), instead of 1-deep
// Stage 3 (scan): read the now-warm slots in order, resolve with cutoff
```

This is the classic "gather keys → prefetch all → process" pattern the ask calls for. The board ops in
stage 1 are already SIMD-friendly (`and_not` over `[u64;4]`); `hash128` is a short mix chain that
vectorizes across the W lanes (it's a per-lane independent fold — ideal for an 8-wide `__m512i` SoA
sweep of the 4 words). Stage 2 is pure `_mm_prefetch` (already in-tree).

### Why it suits SIMD/dense/branchless
The win isn't the SIMD width per se — it's **memory-level parallelism**: the LPDDR5x random latency is
~120 ns; a Zen5 core sustains ~20+ outstanding misses. DFS issues ~1–2; a W=8..16 window issues 8–16,
hiding 4–8× more latency behind the same wall time. Stages 1–2 are branchless by construction.

### Which cost it attacks
Backend-bound-by-memory (34% of cycles, war-story 6) + frontend-by-latency (24%). This is the *only*
idea that directly attacks the DRAM-latency wall the roadmap calls the marginal lever.

### Channel-Fermi (bound the upside)
Memory stalls are ≤34% of cycles. If batching hides half the *exposed* probe latency, the ceiling is
~17%; realistically ~10–25% on the memory-bound fraction, throttled by (a) prove-a-win nodes that cut
off early (wasted prefetches — but a prefetch is cheap and non-faulting) and (b) the segmented-TT
already capturing some TLB locality. **Caveat:** `expand_graph` *already* batches prefetches for the ≤7
children and it's a measured part of the kernel — so A's incremental win is over the *D4/orient region*
(pc > 8), where probes are still 1-deep. That bounds it below the naive 34%.

### Soundness
Pure dataflow reordering of independent siblings; the TT is lockless and order-independent (a position's
value is fixed; fingerprint-validated). **The cutoff order must be preserved for the node-set gate** —
so stage 3 resolves children in `q.order` and stops at the first loss, exactly as today. Prefetching a
child that the cutoff then skips is harmless (non-faulting hint). Transposition-safe: keys unchanged.

### Cheapest experiment
Prototype stage-1/2 only at the prove-a-loss arm of `wins_inc` (those expand *all* children — no cutoff
to lose, so the full window is always consumed → cleanest MLP win, zero wasted prefetch). Gate on a
`const` window width. Measure **CPI + LLC-load-miss latency** on n=16 (node-count-independent). Kill if
CPI doesn't drop. ~1 day. This is the lowest-risk, highest-confidence first build.

---

## 4. Idea B — dense `[u8;8]`-block solver for the whole pc≤12 frontier subtree (W8 generalized, branchless)

### Dataflow restructuring
W8 collapses a pc==8 subtree to one bit load. The structural reason it works: an 8-vertex Node-Kayles
subgame **fits in a `u8` alive-mask**, so its *entire* game tree is a branchless DP over 256 states. Extend
this not by enlarging the *labelled global table* (W9 = 8 GiB, W10 = 4 TB — dead), but by giving every
pc≤K *boundary subtree* its own **local dense block** solved in registers/L1, like `solve_local` does for
≤7 but widened to K≤12..16 and **bitset-parallel**:

When a node first drops to pc ≤ K (K=12..16, one decision at the boundary), extract its ≤K live vertices
into a local `closed[i]: u16` adjacency (the `TinyGraph` pattern, widened from `u8` to `u16`/`u32`). Then
solve the whole subtree over the `alive` bitmask with a **dense win/loss bitset DP**: `won[alive] = OR
over set bits i of ( (alive & !closed[i]) == 0  ||  !won[alive & !closed[i]] )`. For K≤12 that's ≤4096
states = a 512-byte bitset — **L1-resident, never a TT probe, never a random DRAM access**. The board is
read once at boundary entry; everything below is `u16`-mask ops.

### Why it suits SIMD/dense/branchless
The DP is a **branch-free bitset recurrence**: `won` is a `[u64; 64]` bitset over `alive` states. Process
64 `alive` states per word; for each child relation, the "is this child a loss" test is a gather of one
bit from the same bitset, ANDed and ORed across lanes. AVX-512 does 8 states' child-resolution per
instruction once the dependency order is respected (solve by ascending popcount of `alive`, so all
children of a state are already resolved — a clean dense forward sweep, the Codex "linear pass in
dependency order"). No cutoff branch inside the block — the DP evaluates the full reachable set, but the
set is *tiny and L1-resident*, so (unlike global DDD idea Z) it does **not** lose pruning at scale.

### Which cost it attacks
All three: it deletes the per-node branch-mispredict (replaced by a dense sweep), the random TT probe
(replaced by L1 bitset reads), AND amortizes (the boundary value is memoized once per distinct boundary
graph, W8-style — `enter_graph`'s `tiny_tt` already does this for ≤7; extend the complete-table memo to
the pc≤8 case it already has + a *bounded reachable* memo for 9..12).

### Channel-Fermi (bound the upside)
Phase-0 of the grouped-frontier proposal **measured** the coverage: raising the no-recursion cap 8→12
resolves +22 pts (n=12) / +27 pts (n=14) more nodes, and the lever *grows with n* (bigger boards fragment
later). That's the node fraction this block solver would pull out of the DFS-with-TT path. But the
grouped-frontier Phase-1 negative is the warning: the −74% node win there came **at 6.6× wall** because it
used the **cutoff-free nimber recursion**. **B sidesteps that** — it computes plain **win/loss** (one bit,
α-β-free is fine because the block is *bounded ≤4096 states*, not an unbounded mex recursion), and the
solve is a dense L1 sweep, not a recursion. So B is the dense-block reformulation that *removes the cost
killer* the nimber lever hit. Upside: the ~10–20% range, set by (boundary-graph reuse rate) × (per-block
solve being L1 vs the DFS subtree being TT-probed). **The make-or-break unknown is the distinct reachable
boundary-graph count at K=9..12** — if it's small enough to stay cache-resident in the memo, B wins; if
it explodes, the memo thrashes and B degrades toward "solve every block fresh" (still branchless, but no
amortization). Open-question #2 in the grouped-frontier proposal — measure first.

### Soundness
Win/loss over an induced subgraph is exactly the Node-Kayles value (the game *is* graph-local). The
block is the available graph of the boundary position; placing a queen removes a vertex + its neighbours
(`closed[i]`) — identical to `solve_local`'s relation, just wider. Iso-invariant ⇒ the boundary memo is
keyable by labelled edge-code like `tiny_tt`. **Gate:** must hold `solve 12 iso-flat --distinct` =
1,060,823 and n=14 re-exp ≈1.0× (the block changes *how* a subtree is solved, not *which* positions are
distinct — like W8, the block's internal nodes drop out of the comparable node count, so validate via the
distinct gate on the boundary keys + lineage on n≤9, exactly as W8 was).

### Cheapest experiment
Two cheap pre-checks before any solver code, both with existing tooling:
1. **Reuse rate / footprint:** extend `count --comps` to tally *distinct reachable connected boundary
   graphs* at each size 9..12 (the grouped-frontier open-question #2; `component_profile` already
   decomposes). If distinct-count(K=12) fits a few-MB memo, B is cache-resident → GO.
2. **Block solve cost:** microbench the bitset DP for a worst-case K=12 connected graph (a `bench_*`
   example, like `dense_window_bench.rs`) — confirm it's < the ~tens-of-TT-probes a DFS subtree of the
   same boundary would cost. If a single block solve is cheaper than ~10 random probes, the math closes.

Then build K=9 first (smallest extension past W8), validate the gate, A/B n=16 M/s, raise K only while it
pays. **This is the natural successor to W8 and the most likely real win below 2m44s.**

---

## 5. Idea C — SIMD-widen the ≤7 L1 region (`solve_local` / `expand_graph`)

### Dataflow restructuring
The ≤7 band is the **highest-node-count region** of the search (the tree fragments small and deep).
`solve_local` recurses scalar over `alive:u8` with a 128-byte `memo:[i8;128]`; `expand_graph` gathers
children + prefetches. Replace the *recursion* with the same **dense bitset DP as B but for K≤7**: one
forward sweep over the ≤128 `alive` states in ascending popcount, `won` as a 128-bit value, child
resolution branch-free (a bit-gather from `won`). No recursion, no per-state branch, no `memo[alive]`
miss-test branch — just a fixed-trip dense sweep that AVX-512 runs 8 states wide.

### Why it suits SIMD/dense/branchless
`closed[i]:[u8;8]` is already the dense adjacency. The DP over a ≤128-state space is a tiny fixed-size
kernel — fully unrollable, branch-free, L1/register-resident, monomorphisable per K. It's B at K≤7 where
the table is trivially complete (already the `tiny_tt`), so it's lower-risk than B (no reachable-set
footprint question) and it hits the densest part of the node count.

### Which cost it attacks
Branch-miss (the `solve_local` recursion + cutoff is a diffuse mispredict source — war-story 7 placed
~35% of branch-miss samples in `band_entry`) and instruction count, in the region with the most nodes.

### Channel-Fermi
Bounded by (fraction of cycles in the ≤7 region) × (branch-miss share there). `band_entry`/`solve_local`
is a large slice of `band_entry`'s ~35% branch-miss share; if the dense DP halves the mispredicts there,
ballpark ~5–12%. **But** `solve_local` is already *L1-only* (no DRAM, no TT) so the latency win is zero —
this is purely a branch/instr play, capped by how much of the 24% bad-spec lives in this region (some,
not all).

### Soundness
Identical relation to `solve_local`, just iterated dense instead of recursive — same values, byte-identical
boundary win/loss → gate-clean by construction (the `tiny_tt` keys don't change).

### Cheapest experiment
Rewrite `solve_local` as the dense sweep behind a `const` toggle, A/B the **CPI/branch-miss-rate** on
n=16. Self-contained (one function), ~half a day, no footprint risk. Good warm-up that de-risks B's DP
kernel (same recurrence, smaller K).

---

## 6. Idea D — vectorize `child_orient` + `lex_min8` (8 orientations = 8 SIMD lanes)

### Dataflow restructuring
In the D4/orient region, each node carries `[Bits;8]` = 8×256 bits = 2048 bits = **four `__m512i`** (one
per board word, 8 orientation-lanes each). `child_orient` is `parent[t].and_not(a[t])` for t=1..7 — a pure
lane-parallel `_mm512_andnot_si512` across the 8 orientations (4 vector ops for the whole update vs 7×4
scalar `and_not`s). `lex_min8` (the 8-way lexicographic min that picks the D4 canonical key) becomes a
`__m512i` word-0 `_mm512_cmp_epu64`-mask reduction with tie-break into word 1 — replacing the scalar
early-out loop's data-dependent branch.

### Which cost it attacks
Instruction count + the one scalar min branch in `lex_min8`. Per node in the pc>iso_max region only.

### Channel-Fermi
The floor doc measured the incremental `lex_min8`/`child_orient` kernel at ~62 cyc/canon, but the
*production* selective path runs this only **above** iso_max_avail (the shallower, lower-node-count
region — the deep nodes go through the orientation-free `wins_tiny`/`band_entry` tail). So D touches a
*minority* of nodes. Bounded ~3–6%, and the floor doc already recorded that "vectorised lex-min without
the lane-gather" and "GFNI full-transpose" were tried and measured **negative/neutral** in the isolated
`canon_bench` — the lex-min "resists optimisation." So D is **marginal and partly pre-refuted**; only
worth a cheap retry because the negative was on the isolated canon, not in-search where the orientation
*update* (not just the min) is also vectorizable.

### Soundness / experiment
Byte-identical key (same 8 images, same min) ⇒ gate-clean. One-function A/B behind a `const`. Try only
after A/B/C; low expected value.

---

## 7. Idea E — branchless GFNI W8 code-build

### Dataflow restructuring
`w8_get` builds the 28-bit edge code with a scalar double loop over 8 verts (`for i { for j>i { code |=
row.get(vj) << bit }}`). For exactly-8 vertices this is a fixed `8×8` adjacency extraction — a candidate
for a GFNI `gf2p8affine`/bit-matrix-transpose + mask-pack into the 28-bit code, branch-free and
straight-line. Touches only the pc==8 nodes (~5% — `w8_get` was ~5% of branch-miss samples, war-story 7).

### Verdict
Lowest leverage (~1–3%, on 5% of nodes), but trivially gate-safe (same code, same bit) and a clean GFNI
demonstration. **Tie-breaker only** — do it if touching `w8_get` for another reason. Note the handoff's
deferred nit (the per-node `Option::expect` in `w8_get`) could be cleaned in the same pass.

---

## 8. Likely washes — flagged explicitly with the reason

### W — "Batch the WL graph key as a wide SoA SIMD pass" (the literal ask-#1)
**Likely a wash in production, and here's the mechanism.** The WL canon (`comp_canon`/`wl_refine_in`)
is 75% of cycles **only in the pure-iso key mode** (war-story 6). The production solver replaced it with
**selective keying**: tiny-table labelled-index lookups for ≤7 (one `get_unchecked` into a 2 MB table,
no WL), cheap D4 `lex_min8` above iso_max. The WL fast key (`iso_key_fast`) is reached only in a thin
`iso_max_avail`-gated band that the default (`iso_max ≤ 7`) doesn't even enter live. So batching the WL
pass optimizes a code path the production config **doesn't run hot**. `wl_refine_in` is *also already*
auto-vectorized by LLVM to AVX-512 (the `mc[i]=mix64(lcol[i])` map — see its doc comment), so even the
freeze-time/measurement use is partly done. **Recommendation: do not build W** unless a future config
re-raises `iso_max_avail` into the live deep path (then revisit — the SoA-batched WL over a sibling
window would be the right structure, but that's a different solver regime). This is the key place the
generic "SIMD the graph key" intuition collides with the measured reality, so it's called out up front.

### Z — full layered DDD over dense popcount layers
The grouped-frontier proposal's Approach C: forward-enumerate the frontier and solve bottom-up by
popcount with dense arrays. **Parked there as fatal at n=16** because it *loses α-β cutoffs entirely* — a
full pc≥9 layered solve evaluates every reachable node where the DFS stops at the first losing child, so
it can do **more** total work than today's pruned 5.4 B. Idea B is the *bounded-block* version that keeps
this safe (the dense solve is confined to a tiny ≤4096-state window the DFS would have fully expanded
anyway). Z stays parked; it's the n=18 external-memory dataflow, not an n=16 speed lever.

### Per-node SIMD that doesn't change the dataflow
Widening a single position's board ops (`and_not` over `[u64;4]`) to one `__m256i` is a ~0% change — the
4-word loop already compiles to a couple of instructions and isn't the bottleneck. SIMD only pays when it
**widens across a dense window of independent work** (A's probe lanes, B/C's state lanes, D's orientation
lanes). "SIMD one position harder" is the micro-opt that the project banked as washing out.

---

## 9. Recommended sequence (decision-grade)

1. **Idea A (MLP-batched prefetch at the prove-a-loss arm)** — lowest risk, directly attacks the 34%
   memory-bound fraction, no correctness subtlety beyond cutoff-order. Build + A/B first. *~1 day.*
2. **Idea C (dense bitset DP for `solve_local`)** — de-risks B's DP kernel at trivial K≤7, hits the
   densest node region, gate-clean by construction. *~0.5 day.*
3. **Idea B (dense `[u8;8]`-block solver, K=9..12)** — the real successor to W8 and the most likely path
   below 2m44s. **Gate it on the two cheap `count --comps` pre-checks first** (distinct reachable
   boundary-graph footprint + block-solve microbench) — if the footprint is cache-resident, build K=9,
   validate, then climb K while it pays. This is the one that can move the wall, not just shave it.
4. **Idea D / E** — cheap tie-breakers, marginal and partly pre-refuted; only if already in the file.
5. **Do not build W or Z** for the n=16 speed goal (reasons in §8).

Every step holds the full validation gate (`solver_lineage_agrees` on n≤9; `solve 12 iso-flat
--distinct` = exact 1,060,823; `solve 14 iso-flat --distinct` second, re-exp ≈1.0×) and is A/B'd
**interleaved** on **n=16** using the node-count-independent **CPI / branch-miss-rate** metric (wall
hides wins under ±18% parallel node-count noise — war-story 8). Channel-Fermi every lever's *per-unit
cost*, not just its count (the lesson Phase-1 of grouped-frontier taught), before writing solver code.

### Why this set is the right answer to the ask
The ask is "fast SIMD passes over windows we transform into dense blocks, worked on branch-free." The
project's measured truth is that the win must be **branch-miss + memory-latency + amortization**, not raw
compute (compute/WL is already either removed or auto-vectorized). A, B, C are exactly "gather a window
→ dense block → branchless sweep," each aimed at one of those three real costs; W (the most *obvious*
dense-SIMD target, the graph key) is the trap, because production already routed around the cost it would
optimize. The single highest-value build is **B** — it is W8's "collapse a subtree into a dense
branchless solve" generalized to the pc≤12 frontier, and it removes the very cost (cutoff-free recursion)
that defeated the component-nimber lever.
