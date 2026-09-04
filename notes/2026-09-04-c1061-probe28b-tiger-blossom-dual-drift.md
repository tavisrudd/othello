# C1061 probe 28b: the TigerBlossom dual drift

**Lane**: `complete-ports` · **Date**: 2026-09-04 · **Code**: ergodis-private `6750d5e`,
`6d973a0`, `dfd4ee0` · **Continues**: the probe-28 section of
`2026-09-03-c1061-probe26-tiger-blossom-kernel.md`.

## Headline

**The dual drift is gone: zero certificate declines on the random suite (was 4,434 of 77,174,
4,430 of them optimal answers) and on every real cell. Exactness holds on all 360,000 frozen
shots. The worst cell improved 16% in instructions; the mid cells cost 3 to 8% more, the price of
handling collisions the old code dropped.** The dense matcher now runs only for inner blossoms
that need expansion, which is the next step.

## The model, and what each defect broke

The sparse matcher is Edmonds' primal-dual algorithm realized geometrically: a region's dual is
its radius, its territory is the set of detector nodes within that radius, and dual feasibility
is two local invariants.

- **I1** every covered node has local radius at least zero;
- **I2** on every edge between two different regions the two local radii sum to at most the
  edge weight (an uncovered node counts as zero).

Summing I2 along a shortest path between two defects, with I1 on the interior, gives the pair
constraint the LP certificate checks; the boundary event is the same bound for the boundary
term. A tight edge is a collision. The three defects each broke one invariant, and a debug-only
assertion of I1 and I2 after every event located each in one run.

1. **Release one tick late (I1).** A shrinking region released a node when its local radius was
   `-1`, not `0`. When the shrinking region was a singleton whose dual reached zero while two
   outer regions of one tree pressed on its home node from both sides, the derived-graph edge
   between them was tight *through* that node, and was seen one tick late; the blossom then
   contracted with its pair constraint violated by one unit. This is the "third region on the
   path" in probe 28's diagnosis. Releasing at local radius zero hands the node over at no cost
   and preserves every edge sum.
2. **A singleton with negative dual had no node (I2).** Edmonds allows a vertex dual to go
   negative; geometrically the region has shrunk past its own defect and owns nothing, so once it
   stopped shrinking there was nothing left to collide through, and the region that had grown
   over its home kept growing past the tight point. The singleton now keeps a *phantom* presence
   at its home: a virtual node at distance zero, joined to the home node by a zero-weight edge,
   folded into blossoms exactly like a real node. Tree and blossom links record the contacting
   singleton rather than a detector node, because a phantom makes contact through a node it does
   not own.
3. **A collision from a since-frozen side was dropped (I2).** Each edge carries an entry from
   each endpoint. When the entry armed from one side fired after an augmentation had frozen that
   side, the handler ignored it, although the other side was still growing and the edge was
   tight; the growing side's own entry was stale and late. Collisions are now oriented towards
   whichever side is growing.

A fourth change is work order, not correctness. Releases armed for the current clock jumped the
queue under last-in first-out order, so a block that would have ended at that tick by a boundary
augmentation instead did a tick's worth of release and absorb bookkeeping first (2.5x the
scheduling traffic at distance 3). Releases and phantom contacts now go to a late lane of the
bucket, drained after the main one; the lane is an index offset, so the push path has no branch.
All entries at one clock are still drained before the clock advances, so nothing is made late.

## Gates

- **Random suite** (`the_dual_and_the_extracted_pairing_both_reach_the_optimum`, four distances,
  20,000 instances each): 76,612 answered, 76,612 certified, zero declined; the ratchet now
  requires every answered instance to certify. The remaining 3,388 non-answers are all inner
  blossoms needing expansion. The debug build runs the full I1/I2/boundary assertion after every
  event across the whole suite without firing.
- **Exactness** (`tiger-blossom-bench --mode emit --operations 20000` per cell, PyMatching
  2.4.0 `verify`): zero minimum-weight disagreements on all eighteen cells, 360,000 shots.
  Prediction differences (273 at d=3 p=0.05, down to 0 at low p) are the documented tie policy.
- **Allocation**: the zero-allocation `decode_batch` gate passes in debug and release.
- **Clippy** `-D warnings` on the library: clean.

## Instructions per decode, candidate `dfd4ee0` against the retained probe-28 control `190f009`

Interleaved, eight rounds, two-size differencing, paired log-ratio 95% intervals (all intervals
exclude 1.0 except where noted). Log: ergodis-private
`benchmarks/tiger-blossom/2026-09-04-probe28b-dfd4ee0-binaries-ab.log`.

| d | p | control | candidate | ratio | cycles ratio |
|---|---|---|---|---|---|
| 3  | 0.001 | 67.0     | 67.1     | 1.001 | wash |
| 3  | 0.01  | 98.7     | 100.1    | 1.014 | 0.948 |
| 3  | 0.05  | 660.8    | 698.4    | 1.057 | 1.065 |
| 5  | 0.01  | 203.5    | 210.5    | 1.034 | 1.050 |
| 5  | 0.05  | 2,623.5  | 2,833.3  | 1.080 | 1.077 |
| 7  | 0.05  | 5,036.2  | 5,360.4  | 1.064 | 1.057 |
| 9  | 0.01  | 417.9    | 437.8    | 1.048 | 1.091 |
| 9  | 0.05  | 8,170.5  | 8,635.5  | 1.057 | 1.043 |
| 15 | 0.01  | 1,085.0  | 1,150.0  | 1.060 | 1.101 |
| 15 | 0.05  | 19,170.1 | 18,260.2 | **0.953** | 0.936 |
| 25 | 0.01  | 2,906.5  | 3,103.7  | 1.068 | 1.097 |
| 25 | 0.05  | 42,955.7 | 36,134.1 | **0.841** | 0.862 |

Against PyMatching this moves the three losing cells to about 1.20x (d=9), 1.46x (d=15) and
1.69x (d=25) at p=0.05; none is closed. The mid-cell cost is real work: with all three
correctness changes on and the queue order restored, scheduling traffic at d=3 matches the
control (7,717 vs 7,612 `schedule_node` calls), so the residual is per-event cost plus the tree
operations that the dropped collisions used to skip.

## Attribution record (accepted and rejected variants)

- Toggling the orientation fix or the phantom hooks off leaves scheduling traffic unchanged;
  the whole 2.5x traffic growth was the same-tick release churn.
- FIFO order within a bucket for every kind: rejected, it moved absorptions ahead of boundary
  augmentations (events per answer 6.2 to 8.1 at d=3).
- Tail pointers per bucket: worked, replaced by the two-lane index scheme because the tail
  bookkeeping cost on every push and pop.
- Gating the phantom hooks on a per-solve active-phantom count removes one indexed load per
  `schedule_node` call when no singleton has shrunk past its home.

## What can be simplified, in order of leverage

1. **Implement blossom expansion and delete the dense matcher.** Expansion is the last missing
   Edmonds operation; with it every block is answered and certified by the sparse matcher, and
   `tiger_blossom_match.rs`, the pair matrix, and the cluster plumbing go. Expansion is
   event-driven like everything else: an inner blossom arms an expand event for the clock its
   radius reaches zero, unfolds its members' radii from the wrapped sums, splits the odd cycle
   into the alternating path from the parent's contact to the mate's contact (an odd number of
   members) plus matched pairs, and re-arms.
2. **Replace the LP certificate with the local one.** I1, I2, the boundary bound on covered nodes,
   non-negative blossom duals, and objective equal to primal cost imply optimality (the debug
   assertion is exactly this check). It is linear in the block's footprint instead of quadratic in
   defects with chain walks, and it does not need the metric closure for certification; the
   closure is then only a pricing table.
3. **One entry per edge, not per endpoint.** Both endpoints arm entries for the same edge and both
   revalidate; a single edge-keyed stamp halves the pushes and removes the class of defect behind
   item 3 above.

## Mystery ledger

- The mid-cell 3 to 8% instruction cost is attributed to correct tree work, not measured per
  operation; a per-event instruction count against the control would settle it. Owner: the next
  probe-28 step.
- No genuine mystery remains about the declines.

## Vibe check

Solid. Three principled defects, each caught by an invariant assertion rather than by reading,
each mapped to a step of Edmonds' algorithm; declines to zero, exactness intact, the worst cell
16% better, and the mid cells slightly worse for doing the right thing. The dense matcher is now
one implementation away from deletion.
