# C1065 brief: the sparse matcher's fixed per-shot cost on weighted graphs

**Lane**: `complete-ports` · **Date**: 2026-09-04 · **Code**: `~/src/ergodis-private`
**Follows**: `2026-09-04-c1064-weighted-circuit-level-dem.md`

## The question C1064 left

On a stim-generated weighted circuit-level detector error model the sparse matcher costs about the
same whether the shot has three defects or six — 1,338 ns at three and 1,530 at six on surface
`d = 9` — while doing 2.8 sparse events at three. A cost that flat against the work done is a fixed
entry cost proportional to the graph, not to the shot. It is where all seven of the weighted
PyMatching losses live, it is what a routing threshold of fifteen exists to avoid paying, and
C1064's `ej` pass did not settle where it lives.

The named evidence gap is a profile of one low-defect decode on a weighted graph, attributing the
fixed cost to initialization, workspace clearing, or the pair matrix.

## Hypothesis before measuring

Two costs in `tiger_blossom_sparse.rs` scale with the compiled graph and with the weight range
rather than with the shot, and both were invisible under unit weights:

1. **`reset` clears the whole workspace every shot.** The node records, `queued_edge` (one cell per
   edge), `queued_boundary` (one per detector) and `bucket_head` (two lanes of
   `horizon.next_power_of_two()` heads) are refilled per shot. `sparse_horizon` is
   `4 * max boundary distance + 4 * max_weight + 16`, so a scale-32 model with weights 141 to 263
   makes the bucket array three orders of magnitude larger than the unit-weight one.
2. **`pop_event` scans one bucket per clock unit.** Under unit weights the next event is one or two
   ticks away; under real weights an edge collision is a hundred or more ticks away, so each pop
   walks that many empty buckets on both lanes.

Both predict a cost that grows with the largest edge weight and not with the defect count, which is
what C1064 measured, and both predict the 7 to 8 per cent that C1064's scale-8 control found, since
a coarser scale shrinks the modulus and the tick gaps together.

## What this task does

1. Profile a low-defect weighted decode and attribute the fixed cost by source line; this closes
   the C1064 mystery-ledger item whatever the answer is.
2. Remove the graph-proportional per-shot work: an occupancy bitmap over the bucket queue so a pop
   finds the next non-empty bucket without walking the empty ones and a reset clears only the
   buckets that were used, and undo lists so the per-edge, per-detector and per-node state is
   restored only where it was written.
3. Refit `routing_threshold` on the cheaper matcher. The weighted rule of nine and fifteen was
   fitted on the current fixed cost; a cheaper matcher moves every crossover left, and the fitted
   rule has to move with it or the routed arm pays for a cost that is gone.
4. Restate the weighted grid: the routed ladder, the thirty-three-cell PyMatching standing, and the
   latency rows, all on the same protocol C1064 used.

## Gates

No number is reported without: the debug random suite with the no-late-entry oracle and the
`I1`/`I2` feasibility assertion after every event, extended to a weighted graph, since every
mechanism this task touches is weight-sensitive and the current suite is unit-weight; the release
kernel tests including the zero-allocation `decode_batch` gate; library clippy `-D warnings`;
PyMatching 2.4.0 weight and prediction agreement on every measured cell; and an interleaved
multi-round A/B against a retained control binary with hardware counters.

## Out of scope

The quantization scale stays at 32 (C1064 left dropping it to 8 as a proposal that would restate
the whole grid), the observable-component split stays unbuilt, and the third code family for the
mean-degree crossover rule is a separate task.
