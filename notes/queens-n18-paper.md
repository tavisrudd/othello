# Solving the Non-Attacking Queens game for n = 18: a transposition-driven impartial-game solver, its performance engineering, and a machine-checked leaf evaluator

**Draft — technical report for specialist review.** Markdown source; render with pandoc for a typeset version.

---

## Abstract

The Non-Attacking Queens placement game is the impartial, normal-play game in which two
players alternately place a queen on an n×n board so that it attacks no previously placed
queen; the player unable to move loses. It is equivalent to Node-Kayles on the *queen graph*
(vertices = squares, edges = mutually-attacking pairs), and deciding the winner is
PSPACE-complete in general. Jenrich (arXiv:1312.5135) determined the winner for all n ≤ 16;
n = 18 was open. We report that **n = 18 is a first-player win**, witnessed by the opening
move **I9** and a 15-ply principal variation, established by an exhaustive boolean game-tree
search. The verdict is obtained by two *independently configured* runs of the same solver —
two distinct dense-leaf evaluators (a 192-bit code path and a ≥190-bit code path) — that
agree on the verdict, the winning move, and the byte-identical principal variation while
visiting very different node counts (≈2.58 × 10¹¹ and ≈1.14 × 10¹¹). We describe (i) the
algorithmic core — a lockless flat transposition table over isomorphism-canonicalised
positions, with a dense leaf evaluator (`getK`) that resolves every position with at most
`dense_k` live squares directly from precomputed Node-Kayles tables; (ii) the performance
engineering that took the n = 16 search from minutes to tens of seconds and made n = 18
tractable on a single 26 GB workstation; and (iii) a layered validation strategy, culminating
in a machine-checked Lean 4 proof of the leaf evaluator's recurrence, its isomorphism and
induced-subgraph invariances, the build recurrence, and the Sprague–Grundy/Grundy
characterisation, kernel-complete and depending only on mathlib's standard axioms. We are
explicit throughout about what is *certified*, what is *cross-validated*, and what is
*deferred to differential testing*.

---

## 1. Introduction

### 1.1 The game

In the **Non-Attacking Queens game** (Noon & Van Brummelen 2006), players alternately place a
queen on an n×n board subject to the constraint that no two queens attack each other (same
row, column, or diagonal). This is the *placement* / *misère-free* variant: it is **impartial**
(both players have the same moves from any position) and played under the **normal-play
convention** — the player who cannot move loses, equivalently the last player to move wins.

The game is equivalent to **Node-Kayles** on the *queen graph* `Q_n`: the vertices are the n²
squares, and two squares are adjacent iff a queen on one attacks the other. A position is the
set `S` of squares still available (neither occupied nor attacked). A move selects a live
vertex `v ∈ S`; it removes `v` together with all squares it attacks — that is, the *closed
neighbourhood* `N[v] = {v} ∪ N(v)` — leaving the live set `S \ N[v]`. A terminal position
(`S = ∅`) is a loss for the player to move. Deciding the winner of Node-Kayles is
PSPACE-complete (Schaefer 1978), so there is no expected closed form for general n; the
practical question is how far exhaustive search can be pushed.

For **odd** n the first player wins by an O(1) strategy (play the centre, then mirror the
opponent through the 180° rotation), so the substantive open problems are the **even** boards.
The winners are known to be: every odd n → first; n ∈ {4, 6, 8} → first; n ∈ {10, 12, 14} →
second; and, from Jenrich's 2014 computation, **n = 16 → second**. The Sprague–Grundy nimbers
of small boards are catalogued in OEIS **A344227**. The next open even board was **n = 18**.

### 1.2 Contribution

1. **A new game-theoretic result: n = 18 is a first-player win.** The witness is the opening
   move **I9** (square 152 in the 0-based row-major numbering); the game is decided by an
   exhaustive negamax search of the I9 subtree. This extends Jenrich's n ≤ 16 sequence and, if
   accepted, adds a term to OEIS A344227.

2. **A solver design** combining a lockless flat transposition table, isomorphism-aware
   position canonicalisation, and a *dense leaf evaluator* (`getK`) that resolves all positions
   with `pc(S) ≤ dense_k` live squares directly from precomputed complete Node-Kayles tables —
   without subtree expansion or table probes — using a BMI2-`pext` child sweep over a
   bit-packed adjacency code.

3. **A performance-engineering account** — measured, with both wins and instructive negatives —
   that reduced the n = 16 search from the first complete run's ≈10.0 × 10⁹ node evaluations /
   ≈56 min to ≈3.08 × 10⁸ nodes / ≈23.4 s on the same machine, and made the n = 18 root feasible
   via a deliberate *capacity* configuration (band-skipped transposition work + a 17 GB flat
   table).

4. **A layered validation and verification strategy**, including a machine-checked **Lean 4**
   proof of the leaf evaluator's *semantics* — the win/loss recurrence, its termination, its
   isomorphism and induced-subgraph invariances, the table-build recurrence, and the
   Grundy/Sprague–Grundy characterisation — kernel-complete with no `sorry` and depending only
   on the three standard mathlib axioms.

### 1.3 What this paper claims, and what it does not

A complete formal certificate of a 10¹¹-node search is infeasible. We therefore set, and meet,
a different bar for the n = 18 verdict: **cross-validated agreement** of two independently
configured exhaustive searches, on top of a leaf evaluator that is differential-tested against
an independent scalar reference, checked against an independent raw-mask oracle on thousands of
high-index subpositions, audited for integer-width defects, and validated end-to-end against
Jenrich's published n ≤ 16 sequence. The Lean proof hardens the *recurrence semantics* of the
leaf evaluator (the historically bug-prone component), with the bit-level serialization left to
differential tests. Section 7 states the residual trusted base precisely. We deliberately avoid
claiming any "floor" on performance: the numbers below are milestones, not limits.

---

## 2. Problem formalisation and prior work

### 2.1 The win recurrence

Write `G` for the queen graph and `S ⊆ V(G)` for the set of live vertices. Define the boolean
predicate `win(G, S)` — "the player to move from `S` wins under normal play" — by

```
    win(G, S)  ⟺  ∃ v ∈ S .  ¬ win(G, S \ N[v])           (P/N recurrence)
    win(G, ∅)  =  false                                    (terminal = loss)
```

This is the standard finite, impartial, normal-play P/N recurrence: a position is an
N-position (win for the mover) iff some move reaches a P-position (loss for the mover), and the
empty position is a P-position. It is well-founded because `v ∈ S ∩ N[v]`, so `S \ N[v] ⊊ S`
and `|S \ N[v]| < |S|`. The whole game is `firstPlayerWins(G) ≡ win(G, V(G))`.

Equivalently, the **Grundy value** `grundy(G, S) = mex { grundy(G, S \ N[v]) : v ∈ S }`
characterises the outcome: `win(G, S) ⟺ grundy(G, S) ≠ 0`, and for a position that splits into
two parts with no edges between them, `grundy(G, S₁ ∪ S₂) = grundy(G, S₁) ⊕ grundy(G, S₂)`
(Sprague–Grundy). The solver uses the boolean form (with α-β pruning); the Grundy form is
relevant to an optional component-decomposition lever (Section 4.6) and to the Lean
verification (Section 6.3).

### 2.2 Prior work

- **Jenrich (arXiv:1312.5135), 2014.** Determined the winner for all n ≤ 16, finding n = 16 to
  be a second-player win. The reported computation used a backtracking search with partial
  symmetry handling and no transposition table, on the order of **7.146 × 10¹⁰** recursive calls
  over roughly 23 hours. This is the baseline our kernel reproduces (verdicts and the n ≤ 16
  sequence) and improves on in node efficiency.
- **OEIS A344227** records the Sprague–Grundy nimber of the game; our verdicts agree through the
  catalogued range (n ≤ 13 for the nimber, the win/loss outcome through n = 16).
- **Schaefer (1978)** established PSPACE-completeness of Node-Kayles, framing why exhaustive
  search, not a formula, is the tool.
- **Sprague (1935), Grundy (1939); Conway,** *On Numbers and Games.* The impartial-game theory
  underlying Sections 2.1 and 6.3.

n = 17, being odd, is a first-player win by the centre-symmetry argument and requires no search;
the present work concerns the even boards, where n = 18 was the open frontier.

---

## 3. Algorithmic approach

The solver is a parallel boolean game-tree search over canonicalised positions, with a dense
leaf evaluator that short-circuits the deepest ~21 %+ of the tree. Four components carry the
design.

### 3.1 Negamax with α-β over the boolean value

The search realises the recurrence of Section 2.1 directly as a depth-first negamax over
win/loss values with α-β pruning. The tree alternates between two node kinds, which the solver
exploits both for cutoffs and for parallelism (Section 4.5):

- **"prove-a-win" nodes** (the mover seeks any winning move): a single losing child suffices —
  cutoff on the first child that returns a loss for the opponent;
- **"prove-a-loss" nodes** (the mover must be shown to lose): *every* child must be searched
  (no cutoff), since one surviving win for the opponent would refute the loss.

At the root, an existence proof needs only one winning first move; the n = 18 run searched the
single move I9 and stopped (Section 5).

### 3.2 Position representation and canonicalisation

A position is the live mask `S = board & ¬blocked`, where `blocked` is the union of occupied
and attacked squares. For n = 18 the board has 324 squares, so masks are 384-bit (`[u64; 6]`)
and square indices are 16-bit (the consequences of getting this width wrong are the subject of
Section 6.1).

Two canonicalisations merge equivalent positions before they reach the transposition table:

- **Dihedral D₄ board symmetry.** The eight board orientations (rotations and reflections) are
  folded to a canonical representative via a `d4_bits` bijection and a 128-bit hash. This is the
  cheap, always-applied merge.
- **Graph-isomorphism key (selective).** Beyond D₄, isomorphic *available graphs* are merged by
  a Weisfeiler–Leman + individualisation-refinement canonical key, applied selectively to small
  components (a tunable cap). The isomorphism merge is worth roughly a 3.4× reduction in distinct
  positions at small n; it is bounded so its per-node cost does not dominate.

Canonicalisation is the largest single source of node-count reduction and the reason a flat
table is competitive: equivalent subtrees collapse to one entry.

### 3.3 The flat lockless transposition table

The transposition table is a single contiguous `Box<[AtomicU64]>` accessed with relaxed
loads/stores — no sharding, no per-bucket mutex, no read-modify-write. Each slot is **one 64-bit
word** holding `{ used: 1 bit, value: 8 bits, fingerprint: 55 bits }`: the slot stores a 55-bit
fingerprint of the canonical key rather than the full key, so a colliding probe returns a wrong
value with probability ≈ 2⁻⁵⁵ (cross-checked against Jenrich's known verdicts). Indexing uses
Lemire's multiply-shift (`fastrange`) so the table can be any number of slots — sized once at
startup from an environment variable — and the next child's slot is software-prefetched. The
table is backed by 2 MB huge pages (Section 4.7).

A single-word, fingerprint-only slot is what makes the lockless design sound: a `u64` write
cannot tear, and the fingerprint self-validates a foreign key, so concurrent workers need no
synchronisation beyond atomicity.

### 3.4 The dense leaf evaluator `getK` and the W_K hierarchy

The deepest part of the tree is where most nodes live and where memoisation pays least (subtrees
are shallow and rarely revisited). The solver resolves every position with `pc(S) ≤ dense_k`
**directly**, without a table probe or any subtree expansion, via the `getK` evaluator:

1. Precompute, once at startup, the **complete** Node-Kayles win tables `W0 … W8` for *all*
   labelled graphs on up to 8 vertices. There are `8·7/2 = 28` possible edges, so `W8` is a
   2²⁸-bit value bitset — **32 MiB, n-independent, eviction-free** (every lookup is a hit), built
   bottom-up by vertex count in ≈2 s. `W8` lives in 16 huge pages and is TLB-friendly.

2. For a position with `k = pc(S) ≤ dense_k` live vertices, build the `k(k−1)/2`-bit
   upper-triangular adjacency *code* of the induced available graph (one BMI2-`pext` per row;
   Section 4.3). Then for each of the ≤ k moves, project the surviving subgraph's code with a
   single `pext` and look the child up in `W[pc(child)]`; the position is a win iff some child is
   a loss. Because a move deletes `1 + deg(v)` vertices, children fall several layers down, so
   the nested sweep bottoms out in the complete `W0 … W8` base within a couple of levels.

`getK` therefore computes the *exact* value of layers `W9, W10, …` that would be astronomically
expensive to *store* (`W9` as a table is 8 GiB; `W10` ≈ 4 TB) at **zero storage cost**. The
dense ceiling `dense_k` is a tuning parameter (Section 4.2): raising it trades more per-node
evaluator work for fewer search nodes. The dispatch on `dense_k` is a compile-time generic
resolved once per run, never a per-node branch.

---

## 4. Performance engineering

The solver is **transposition- and memory-latency-bound**, not compute- or
parallelism-bound: the binding cost is the depth-first entry probe into a multi-gigabyte table,
which is an inherently serial, path-dependent random access. This shaped every lever below. All
n = 16 figures carry ≈ ±18 % run-to-run node-count noise from parallel cutoff timing; we cite
**deterministic single-threaded n = 14 node counts** as the noise-free measure of direction, and
**cycles/node** (perf cycles ÷ solver nodes) for byte-identical micro-changes. Methodology is in
Section 4.8.

### 4.1 The solver lineage

The n = 16 search wall-clock evolved through a sequence of solvers, each a named, reproducible
configuration (best clean-box search wall; node counts carry parallel noise except where the
n = 14 deterministic figure is cited):

| solver                                        | n=16 wall | nodes    | mechanism                                                      |
|-----------------------------------------------|-----------|----------|----------------------------------------------------------------|
| `iso-flat`                                    | 3m29s     | 6.1 B    | single selective-iso key over the flat lockless TT             |
| `iso-window`                                  | 2m44s     | ≈5.1 B   | dense `W8` tail table over a huge-page-collapsed flat TT        |
| `iso-dense` (W12, fused ETC)                  | 1m32s     | 1.70 B   | `getK` to ceiling 12 + fused enhanced-transposition cutoff      |
| `iso-dense` + dynamic move ordering           | 1m02s     | 1.14 B   | re-sort children by current degree (Section 4.4)               |
| `iso-dense` (W16) + ordering + ETC            | ≈34s      | 0.40 B   | pext code-build + ceiling raised 12 → 16 (Section 4.2/4.3)      |
| `iso-dense` (W17) + degree-ordered `getK`     | ≈24.5s    | 0.31 B   | ceiling 17 (192-bit code), children swept degree-descending     |
| `iso-dense` (W17) + ordering + `skip18` (now) | **23.44s**| **0.31 B**| also skip TT work for the `pc = 18` band (Section 4.5)         |

For reference, the first complete n = 16 solve (a D₄-parallel search, no dense evaluator)
visited **10,017,867,872** nodes in ≈56 min on a thermally throttled box (≈42 min clean) — so
the lineage represents roughly a 33× reduction in node evaluations and ~140× in wall time on the
same hardware, with the verdict (second-player win) unchanged throughout.

### 4.2 Raising the dense ceiling

The per-layer node-count reduction from raising `dense_k` is large and barely diminishing.
Deterministic single-threaded n = 14 node counts:

| ceiling | n=14 deterministic nodes | Δ vs previous |
|---------|--------------------------|---------------|
| W8      | 27,539,495               | —             |
| W9      | 22,527,149               | −18.2 %       |
| W10     | 18,825,047               | −16.4 %       |
| W11     | 15,724,135               | −16.5 %       |
| W12     | 12,896,443  (−53 % vs W8)| −18.0 %       |
| W13     | 10,339,019               | −19.8 %       |
| K = 16  | ≈4.0 M  (−50 % vs K=12)  | (K15→16 −22 %)|

Because the node-count cut is *inherent* (independent of table size), it holds at production
scale: at n = 16 with a 17 GB table, raising the ceiling to 16 collapsed the working set so the
table sat ~16.5 % full. The economically optimal ceiling moved over time as the per-node
evaluator got cheaper: when the evaluator was scalar, **K = 12** was the wall-clock optimum
(node cuts continued but per-node cost grew); the `pext` code-build (Section 4.3) made the deep
builders cheap and moved the optimum to **K = 16** (the u128 code ceiling, −35 % wall vs K = 12);
the 192-bit code path then made **K = 17** the wall sweet spot. Pushing further (W18–W20) keeps
cutting nodes (≈ −52 % at K = 20) but is *work-conserving* — deeper `getK` does the same
combinatorial work — so wall is flat above K ≈ 17. The node cut above 17 is nonetheless valuable
for **memory** (a smaller working set), which is exactly what n = 18 needed (Section 5).

### 4.3 `pext`-per-row code construction

Building the `k(k−1)/2`-bit adjacency code originally cost `k(k−1)/2` scalar bit-tests. Replacing
this with one 4-word BMI2 `pext` (`_pext_u64`) per vertex row (`adj_row_pext`) cut ≈3.8 %
cycles/node at n = 16, byte-identically — and, crucially, made deep ceilings affordable, which
unlocked the −35 % node-cut win of Section 4.2. (An earlier "pext is negative" measurement had
only tested a scalar reshape at tiny k; at K ≥ 12 scale the trade flips.)

### 4.4 Dynamic move ordering and ETC

The single largest search-shaping win was **dynamic move ordering**: at each node, re-sort the
children by their *current* available-block degree (`pc(child)` ascending — most-forcing first),
which surfaces instant wins (`child = ∅` sorts first) and reaches α-β cutoffs earliest. Against
the prior default this was **−34.3 % nodes / −30.2 % wall** at n = 16 (98.1 → 68.5 s), with only
+8.5 % cycles/node for the cheap sort; deterministic n = 14 confirmed −31.3 %. An **enhanced
transposition cutoff** (ETC) — probe the children's table entries before recursing, and cut on a
found loss — stacks on top for a further ≈ −18 % nodes. Move ordering is worth roughly a 2×
node reduction, a fact that recurs as the reason several throughput ideas failed (Section 4.6).

### 4.5 Branchless ordering, `skip18`, and other survivors

- **Branchless counting sort.** The move-ordering sort was the single largest branch-mispredict
  site (≈28 % of all mispredicts in a frontend-bound kernel). Replacing the comparison-based
  insertion sort with a count/prefix/stable-scatter counting sort (no data-dependent compare) was
  **−9.9 % cycles/node / −12.5 % wall**, byte-identical.
- **`skip18`.** For the `pc = 18` band specifically, skip *all* transposition work — the
  canonicalisation, the probe, and the put. This is safe and cascade-free because every child of
  a `pc = 18` node is a `getK` leaf, so a re-expanded `pc = 18` node re-runs one bounded
  evaluator sweep rather than an unmemoised subtree; the band is ~100 % cold anyway. Measured
  −2.5 % wall / −3.6 % cycles, n-agnostic, verdict-preserving. The band is *unique*: extending it
  to neighbouring popcounts measured net-negative. (At n = 18 the analogous skip covers the
  bands 18–25; Section 5.)
- **Flat `W0…W8` arena.** Concatenating the per-layer tables into one contiguous slice removed a
  serial bounds-check load in every `getK` leaf: −2.0 % cycles/node (it won precisely because it
  removed a *serial* load the out-of-order engine could not otherwise hide).
- **Warm-restart off.** A 2-second warm pass plus staggered restart had paid when the kernel was
  slower; once counting sort sped it up, the warm ramp stopped paying, so disabling it by default
  was −3.2 % wall. (Levers are re-tested after each win, because wins change what the next lever
  is worth.)

Parallelism is parity-aware Young-brothers-wait: children are fanned out only at "prove-a-loss"
plies, where every child must be searched anyway, so there is **zero speculation** — this scaled
the search from ~1.4 to 24 cores with no added work.

### 4.6 Instructive negatives

For a methods audience the rejected levers are as informative as the wins; each was kept behind
a disabled flag with its measurement recorded.

- **Sorted-frontier "wave" pipeline (idle-core throughput).** A producer/consumer scheme that
  reorders the frontier into table-friendly order. Forfeiting move order cost **+94 % nodes** at
  n = 16 (the n = 14 proxy had lied at only +13.3 %) — confirming move ordering's ≈2× value. The
  pipeline is dead as built.
- **DFS parallelisation of the giant root tail (ABDADA in-flight markers; frontier
  work-stealing).** All variants *added* re-expansion (best-tuned work-stealing: +8.7 % nodes /
  +13.3 % wall), because the tail is **transposition-saturated**: the work that would fill idle
  cores is shared transpositions, not disjoint subtrees. The route to the tail is *not*
  parallelisation.
- **Component / nimber decomposition.** Splitting a disconnected position into components and
  XOR-ing their Grundy values cut nodes (up to −74 %) but cost **6.6× wall** — the root cause is
  Sprague–Grundy, not the implementation: component nimbers are cutoff-free (every move must be
  refuted) and the value-bearing components are sizes 9–12 (millions of distinct graphs, not
  tabulable). Across the dense layers, positions are overwhelmingly a single component, so the
  premise rarely fires.
- **Memo-less `get17`.** A table-free K = 17 evaluator cut nodes −19.4 % but cost +30.7 %
  cycles/node / +5.7 % wall: the `pc = 17` subtree is shallow, so a memoised recurse beats a
  memo-less recompute (the opposite of the deep layers).
- **Set-associative TT, L0 probe-cache dedup, software-prefetch helpers, PGO, isolated-vertex
  pair-strip.** Each measured wash-to-negative on this single-box, memory-latency-bound workload
  (e.g. the entry probe is serial, so there is no memory-level parallelism for prefetch helpers
  to exploit). Several are parked for the *oversubscribed* small-table / large-n regime.

### 4.7 Memory and the transposition table

Capacity is not the binding constraint; per-probe DRAM latency is. A table-size sweep at n = 16
(8 / 12 / 17 GB, all fully huge-paged) showed warm throughput of 42.7 / 40.4 / 37.7 M nodes/s —
a larger table buys TLB residency but loses it back to eviction, so the curve is shallow.
Raising the dense ceiling shrinks the *working set* (the table sat ~16.5 % full at K = 16) but
not the resident footprint, because the table touches its full span via random page-spread
within seconds. Two memory mechanics matter:

- **Huge pages.** A randomly faulted multi-gigabyte table reaches only ~73 % 2 MB coverage under
  transparent huge pages; an explicit prefault plus `MADV_COLLAPSE` reaches 100 %, worth ~5 %
  wall and cutting startup from ~7 s to ~2 s.
- **Compact slot.** The 8-byte fingerprint slot (vs a full-key slot) cut the n = 14 resident TT
  from 5.4 GB to ~1.07 GB at the same slot count, with re-expansion essentially unchanged.

### 4.8 Benchmarking methodology

- **Interleaved A/B only.** The box thermally throttles within ~1 s of a ~12 s solve, so
  all-A-then-all-B comparisons fabricate deltas; we alternate the two binaries round-by-round.
  The n = 14 proxy can lie about direction (the wave pipeline above), so the **interleaved n = 16
  A/B** is the trustworthy measure, with deterministic n = 14 node counts for noise-free
  node-direction.
- **Metric discipline.** Cycles/node for byte-identical changes (node-count-independent); total
  cycles and wall for node-count-changing levers (where cycles/node rises by design).
- **Box hygiene.** Before any benchmark: compressed-RAM swap off (this box's "swap" is `zram`, a
  per-access decompress CPU cost, not disk), the filesystem cache cap lowered, page cache dropped
  and memory compacted, and the RAM-backed `/tmp` cleared — a degraded box once produced a
  spurious "floor" that clean hardware halved.

We treat any apparent performance limit as a measurement artefact or an untried lever until
proven otherwise; the figures here are milestones.

---

## 5. Solving n = 18

### 5.1 The capacity problem

The n = 16 optimisations are about *speed*; n = 18 is about *memory*. The proving search visits
on the order of 10¹¹ nodes, and on a 26 GB workstation (≈16 GB free) the binding question is
whether the transposition table can hold enough of the working set to avoid catastrophic
re-expansion. An initial unconfigured attempt thrashed: the table filled to 100 % and ~99.7 %
cold, and the root never converged.

The configuration that converged combines two ideas from Section 4:

1. **Band-skip transposition work for `pc ∈ [18, 25]`** (`QUEENS_SKIP18_PCS=18,…,25`). As with
   `skip18` at n = 16, these high-popcount bands are ~100 % cold and their children bottom out
   in `getK` leaves, so skipping their canonicalise/probe/put is verdict-preserving by
   construction (the value is still computed) and merely declines to memoise work that would not
   be reused. This frees the table to hold the lower, genuinely-reused bands.

2. **A 17 GB flat table** (`QUEENS_TT_SLOTS = 2.125 × 10⁹` 8-byte slots; ≈16.7 GB resident),
   sized to the box.

With this configuration the giant root I9 converged at ~10 M nodes/s. The runs are not
resumable (the flat table is not checkpointed); each proving run completed in a single ~7–8 hour
session on 24 worker threads (compiled `-C target-cpu=znver5`).

### 5.2 The result and its cross-validation

The verdict is established by **two independently configured proving runs** that differ in the
dense leaf evaluator they use, and that agree on every observable:

| run     | `dense_k` | `getK` code path | verdict     | root | nodes            | wall      |
|---------|-----------|------------------|-------------|------|------------------|-----------|
| primary | 17        | W17 (192-bit)    | first wins  | I9   | 258,322,944,571  | 8h16m45s  |
| confirm | 20        | W18/19/20 (≥190-bit) | first wins | I9 | 114,318,641,519 | 7h08m39s  |

Both runs report **n = 18 is a first-player win**, both identify **I9** (square 152) as a
winning opening, and both produce the **byte-identical 15-ply principal variation**

```
    I9  K8  G10  J11  H3  M7  N16  E4  P6  D12  O13  F2  R5  L17  A14
```

(squares `152, 136, 168, 189, 43, 120, 283, 58, 105, 201, 230, 23, 89, 299, 234`). The PV was
checked to be a sequence of 15 legal non-attacking moves ending in a terminal position with the
side-to-move unable to move — consistent with a first-player win (the first player makes the
last, 15th, move).

The two runs use different code (a 3-word code path vs a ≥190-bit path), exercise different
internal table dynamics, and converge at node counts differing by more than 2× — yet agree on
the verdict, the move, and the entire PV. Because the leaf evaluator is the component where this
class of solver has historically had bugs (Section 6.1), evaluating the same game two ways and
obtaining the same answer is the central evidence.

### 5.3 On the node count

The realised node counts (≈2.58 × 10¹¹ and ≈1.14 × 10¹¹) substantially exceed a pre-run estimate
(≈4.6 × 10¹⁰ central, from a 3-point extrapolation of n = 12/14/16). The gap is attributable to
**re-expansion**: the table cannot hold the full working set, so transpositions that would be
single entries in an unbounded table are recomputed. This is why the two configurations differ
so much in node count (the higher dense ceiling of the confirm run shrinks the working set and
roughly halves re-expansion) while agreeing on the value — and it is exactly the regime the
band-skip configuration was designed for.

---

## 6. Validation and verification

Correctness rests on a layered stack: a lineage agreement gate, exact distinct-count
invariants, differential tests against an independent scalar reference, an independent raw-mask
oracle on adversarial subpositions, an integer-width audit, reproduction of Jenrich's published
sequence, and a machine-checked Lean proof of the leaf evaluator's semantics. The motivating
defect class is described first.

### 6.1 The motivating defect: `u8` square-index truncation

The one real bug found in this code class was a **leaf-decode defect**. The migration from n ≤ 16
to n = 18 widened square indices from 8 to 16 bits across most of the code, but missed the
small-graph / component-canonicalisation path in one module, which still stored board-square
indices in `u8`. At n ≤ 16 the maximum square index is 255 and fits exactly; at n ≥ 17 squares
reach 323 and silently truncate (256 → 0, …), corrupting the adjacency rows, hence the code,
hence the looked-up value — a loss↔win flip. It was caught at `pc = 3` in milliseconds by the
independent-oracle differential (below) and fixed by widening the indices. This defect is the
direct motivation for the Lean verification of the leaf evaluator's decode and recurrence.

### 6.2 Test and cross-check hierarchy

- **Lineage agreement.** Every solver variant matches the memo-less `naive` recurrence's verdict
  for all n ≤ 9. `naive` is the ground truth the entire lineage is pinned to.
- **Exact distinct-count invariants.** `iso-flat` reports its exact distinct-position count; the
  n = 12 value is **1,060,823** (a second-player win) and the n = 14 value is ≈29.2 M with
  re-expansion ≈1.0×. A change in the distinct count signals a lost transposition merge; a jump
  in re-expansion signals an undersized table. Key/table changes must preserve both. (The ≈49.3 M
  figure sometimes quoted is the *D₄*-distinct count; `iso-flat`'s isomorphism key merges below
  it, so its own distinct count is ≈29.2 M — the figure the gate checks.)
- **Differential tests against a scalar reference** (in `dense.rs`). The optimised `pext`
  evaluator is compared bit-for-bit against a plain scalar recurrence across tens of thousands of
  density-spread codes per layer: `graph_wins8_matches_scalar` pins the `pext` `W8` build to the
  scalar build; `direct_w9..w16_matches_scalar_recurrence` pins the `getK` layers 9–16 to the
  `u16`-coded scalar reference `wins_rec`; and `direct_w17..w20_matches_scalar_recurrence` pins
  the wide layers — **including the W17/W18 leaves the n = 18 verdict bottoms out on** — to a
  3-word scalar reference `winsw_scalar`. Both n = 18 evaluator configurations are thus
  scalar-validated.
- **Independent raw-mask oracle.** A separate test drives ~3,400 18×18 subpositions whose live
  sets span the high-index words and checks both `iso-dense` and `iso-flat` against a *different
  implementation* — a raw-mask negamax with no `getK`, no canonicalisation, no table. This is the
  test that caught the truncation bug; it exercises exactly the high-square decode path that
  differs between n ≤ 16 and n = 18.
- **Integer-width audit.** A from-scratch read of the value path (mask words, geometry, the
  `d4_bits` bijection, the 128-bit hash, the code build, the wide W17–W20 path) for the
  truncation bug class found no defect that could flip an n = 18 value; the two residual findings
  were off the proving runs' configuration.
- **Reproduction of prior work.** The kernel reproduces Jenrich's full n ≤ 16 sequence
  (n = 16 second-player win) and agrees with OEIS A344227 through the catalogued range.

### 6.3 Machine-checked verification of the leaf evaluator (Lean 4)

The leaf evaluator is where the historical bug lived and where ~21 %+ of search nodes are
decided, so it is the target of a machine-checked proof. We follow a **"2-lite"** scope: prove
the *recurrence/algorithm semantics* in Lean, and leave the bit-level `pext`/serialization to the
differential tests of Section 6.2 (where they are cheapest to check). The development is a
self-contained Lean 4 + mathlib project (`lean/NodeKayles/`), `lake build` green with **no
`sorry`**; every theorem depends only on the three standard mathlib axioms
`[propext, Classical.choice, Quot.sound]` — no `sorryAx`, no `native_decide`, no custom axioms.

**What is machine-checked.** An abstract finite simple graph `Graph k` on `Fin k` with a
`closedNbhd` operation, and:

- `win` — the P/N recurrence of Section 2.1 — is **well-defined and terminating** (well-founded
  on `|S|`; the played vertex lies in its own closed neighbourhood, so the child set strictly
  shrinks). This mirrors the scalar reference `wins_rec`.
- `win_iso` — the value is **invariant under graph isomorphism** (same-size relabelling). This
  justifies the freedom to use any labelling of a position's vertices.
- `win_emb` — the value is **invariant under induced-subgraph relabelling**. This is the
  soundness of `projected_code`: the `getK` step that relabels a child's surviving vertices to
  `0 … k′` and reads the smaller `W{k′}` table cannot change the value.
- `buildPred_correct` — the **one-ply build recurrence equals the true value** (mirroring the
  table-build function `graph_wins`), with `not_win_empty` (the empty graph is a loss) as the
  `W0` base case.
- `mex`, `grundy`, and `win_iff_grundy_ne_zero` — the **Grundy characterisation**
  `win ⟺ grundy ≠ 0`, with `grundy` the minimal-excludant of the children's Grundy values.
- `grundy_iso` and `grundy_sum` — Grundy-value **isomorphism invariance** and the
  **Sprague–Grundy component sum** `grundy(S₁ ∪ S₂) = grundy S₁ ⊕ grundy S₂` when no edges run
  between the parts (built on mathlib's `Nat`-xor theory, e.g. `Nat.lt_xor_cases`).

The proofs were subjected to three rounds of adversarial review (integrity, statement
faithfulness, Lean↔Rust correspondence, mathematical adequacy, reproducibility). Adequacy was
corroborated against the literature: the path `P₃` computes to Grundy value 2 (Dawson's-chess /
OEIS A002187), and the isolated-vertex parity computes to `n mod 2`.

**What is deferred (the 2-lite boundary).** Not modelled in Lean, and carried by the differential
tests of Section 6.2: the u128 / 3-word **code bit-layout and its `pext` decode**
(`adj_from_code`, `projected_code`); the `pext` `W8` build fast path; the generic high-popcount
α-β combination logic above the dense ceiling (test-covered for n ≤ 16); and the board→code build
(the queen-graph construction). The **Lean↔Rust correspondence itself** — that the Lean
definitions faithfully mirror the Rust functions — is hand-audited, not machine-checked
end-to-end (auto-translation is not viable through `pext` intrinsics, const-generic
monomorphisation, and unchecked indexing). The move polarity is recorded explicitly: the Lean
`closedNbhd G v` (the deleted set `{v} ∪ N(v)`) corresponds to the Rust `(1<<i) | adj[i]`, and
the surviving child `S \ closedNbhd` to its complement `full & ¬((1<<i) | adj[i])`.

**Scope caveat.** `grundy_sum` and `grundy_iso` harden the mathematics of an **optional,
default-off, parked** component-nimber lever (Section 4.6) — not the default `getK`/`iso-dense`
path and **not** the n = 18 verdict, which use only the boolean `win` recurrence. They are
included because the Grundy characterisation is the cleanest formal statement of the leaf
evaluator's meaning and because the component-decomposition technique may be revisited.

The combinatorial-game theory was, until recently, in mathlib's `SetTheory/Game/`; it has since
been extracted to a standalone library tracking an older Lean toolchain than this project's, so
the Grundy layer is built **self-contained** rather than anchored to mathlib's `Impartial` /
`grundyValue`. The consequence is that the statement "`win` *is* the game value" rests on the
standard-recurrence argument plus the literature cross-checks above, rather than on a cited
library theorem; an upgrade path (a `PGame` bridge) is documented for when the external library
matches our toolchain.

---

## 7. Threats to validity

We state the residual trusted base precisely.

1. **The n = 18 verdict is cross-validated, not formally certified.** A complete certificate of a
   10¹¹-node search is infeasible; the evidence is (a) two independently configured exhaustive
   searches agreeing on verdict + move + full PV, (b) both leaf evaluators differential-tested
   against an independent scalar reference, (c) an independent raw-mask oracle on thousands of
   high-index subpositions, (d) an integer-width audit, and (e) reproduction of Jenrich's n ≤ 16
   sequence. The single component validated *only* at n ≤ 16 (plus the two-run agreement) is the
   generic high-popcount α-β combination logic over the I9 subtree, above the dense ceiling — it
   is neither differential-tested at n = 18 popcounts nor in scope for the Lean proof. The two
   configurations exercise this logic over different node sets and agree.
2. **The Lean proof covers the leaf evaluator's recurrence semantics, not the whole search.** It
   does not model the bit serialization, the high-popcount α-β, the transposition table, the
   concurrency, or the board→code build, and the Lean↔Rust correspondence is hand-audited
   (Section 6.3).
3. **Benchmark numbers are single-machine and noisy.** All n = 16 wall/node figures carry ≈ ±18 %
   parallel node-count noise; deterministic n = 14 node counts are the noise-free measure.
   Throughput figures depend on a clean, huge-paged, non-throttled box.
4. **The fingerprint table admits probabilistic wrong hits** at ≈ 2⁻⁵⁵ per colliding probe;
   cross-checks against Jenrich's verdicts and the two-run agreement bound the practical risk.

None of these undermines the qualitative result; they delimit what "proved" means at each layer.

---

## 8. Conclusion and future work

We determined that the Non-Attacking Queens game on the 18×18 board is a **first-player win**,
witnessed by the opening move I9 and a 15-ply principal variation, by an exhaustive boolean
game-tree search whose verdict is corroborated by two independently configured runs. The result
extends Jenrich's n ≤ 16 sequence and, pending community review, contributes a term to OEIS
A344227. The enabling techniques are a dense leaf evaluator that resolves the deepest fifth of
the tree directly from precomputed Node-Kayles tables, isomorphism-aware canonicalisation over a
lockless flat transposition table, dynamic move ordering, and a capacity configuration
(band-skipped transposition work + a 17 GB table) tuned to a single workstation. The leaf
evaluator's recurrence semantics — the component where this solver class has historically had
bugs — are machine-checked in Lean 4, kernel-complete and depending only on standard axioms,
with the bit-level serialization deferred to differential tests.

Directions for further work: closing the residual trusted base by modelling the u128 code decode
in Lean (removing the serialization from differential-test-only status) and bridging `win`/
`grundy` to a blessed `Impartial`/`grundyValue` once the external game-theory library matches the
toolchain; a resumable, disk-backed transposition tier for n = 20; and pushing the n = 16 search
below 20 s. We make no claim that any reported time is a floor.

### Reproducibility

The verdict runs are reproducible (modulo the non-resumable flat table) with the `iso-dense`
solver at the two configurations of Section 5.2 — the primary run sets `dense_k = 17`, the
confirm run `dense_k = 20`, both with the `pc ∈ [18,25]` transposition-skip and a 2.125 × 10⁹-slot
table — on a 26 GB Zen 5 workstation compiled for `znver5`. The validation gates (lineage
agreement, the n = 12 distinct count 1,060,823, the differential tests, the independent-oracle
subposition check) run from the project's standard test target. The Lean development builds with
Lean v4.32.0-rc1 + mathlib via `lake build`; a green build with no `sorry` warning is the gate,
and `#print axioms` on each theorem yields the standard axiom triple.

---

## References

1. T. Jenrich. *An optimal algorithm for solving the queens game and a proof that the second
   player wins for n = 16.* arXiv:1312.5135, 2013/2014.
2. OEIS Foundation. *A344227: Sprague–Grundy values of the non-attacking queens placement game.*
   The On-Line Encyclopedia of Integer Sequences.
3. T. J. Schaefer. *On the complexity of some two-person perfect-information games.* Journal of
   Computer and System Sciences 16(2), 1978. (PSPACE-completeness of Node-Kayles.)
4. H. Noon and G. Van Brummelen. *The Non-Attacking Queens Game.* College Mathematics Journal
   37(3), 2006.
5. R. P. Sprague (1935); P. M. Grundy (1939); J. H. Conway, *On Numbers and Games*, 1976.
   (Sprague–Grundy theory of impartial games.)
6. D. Lemire. *Fast random integer generation in an interval.* (The multiply-shift `fastrange`
   table index.)
7. The mathlib Community. *mathlib4*, Lean 4 mathematical library. (`Nat` bitwise theory used by
   the Grundy proofs.)
8. OEIS A002187 (Dawson's chess / Grundy values of path Node-Kayles), used as a Lean adequacy
   cross-check.
