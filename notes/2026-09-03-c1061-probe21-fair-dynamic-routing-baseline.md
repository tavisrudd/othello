# C1061 probe 21: a fair dynamic baseline for routing (wrapped up as documentation)

**Lane**: `complete-ports`
**Date**: 2026-09-03
**Task**: C1061 probe 21, continuing `notes/2026-09-03-c1061-probe17-sparsity-aware-composition-and-routing.md`.
**Status**: **stopped early by a direction change**; routing continues in a fresh session. This note
records what is built and gated, what is measured, and what is not, so the next session can pick it
up cold.

## Why the probe existed

Probe 17 gave routing a positive verdict — the retained fabric delta beat a Dijkstra re-solve by 41x
to 305x at matched exactness. That comparator is *static*: it discards all of its work after every
event. The fair question is how the retained delta compares against a baseline that is itself
incremental, and probe 21 was opened to answer it. **No timing comparison was run before the probe
was stopped, so probe 17's routing ratios stand as measured against a static comparator only, and
must not be quoted as a win over dynamic shortest-path algorithms.**

## What is built, committed and gated

Committed in `ergodis-private` as `23c9b3f` (`git commit -m ... -- <paths>`, pathspec form).

- `/home/tavis/src/ergodis-private/src/dynamic_routing.rs` — new module:
  - `FabricGraph<S>` materializes the explicit layered graph the retained tree summarizes, with
    forward and reverse adjacency in compressed sparse row form and a `(node, port) -> edge ids`
    touch index so one fabric event refreshes only the `O(S)` edges it can change.
  - `IncrementalSssp` — a Ramalingam--Reps style dynamic single-source shortest-path maintainer.
    Weight decreases propagate through a bounded Dijkstra; increases and deletions first identify
    the affected subgraph (vertices that lost every supporting in-edge, propagated forward), reset
    it, and rebuild from its unaffected boundary. It reports `settled`, `relaxations` and
    `affected_count` per repair as the work measures.
  - `DenseApsp` — a maintained full distance matrix with the textbook `O(n^2)` per-edge-decrease
    update and a recomputation on any increase, with `recomputes` and `writes` counters.
  - `apply_event_to_graph` — the bridge that applies a fabric event to the tree and the graph
    together and returns the `(edge, old, new)` batch plus whether anything rose.
- `/home/tavis/src/ergodis-private/src/fabric_routing.rs` — additive accessors only
  (`capacity`, `link_cost`, `pod_cost`, `is_leaf_node`, `set_parameters_raw`) so an external
  comparator can materialize the same graph. No restructuring, per the standing instruction that
  probe 16 reads these modules.

**Gates, all passing (11 tests across the two modules):**

- `incremental_sssp_matches_the_retained_tree_after_every_event` — 3,000 mixed failure, latency and
  capacity events at 64 pods, width 4; the incremental maintainer's sink distance equals the
  retained tree's optimum after every single event.
- `incremental_sssp_matches_a_full_resolve_at_every_vertex` — 600 events at 32 pods, comparing
  **every vertex's** distance against a from-scratch Dijkstra, not just the objective. This is the
  strong gate: it proves the Ramalingam--Reps repair is exact, not merely right at the sink.
- `the_all_pairs_matrix_agrees_with_the_tree_on_the_traversal_objective` — 200 events at width 2.
- `the_graph_refresh_index_covers_every_changed_edge` — after each event, the incrementally
  refreshed edge weights are compared against a full refresh; the touch index must miss nothing.
- `the_retained_tree_agrees_with_dijkstra_at_every_separator_width` — **new, and it closes the gap
  the direction change asked about.** Probe 17's differential gate only covered width 4; widths 2
  and 8 are separate monomorphizations. The gate now runs 500 mixed events (failure, latency and
  capacity) at widths 2 and 8 against the tree's own Dijkstra comparator, and **passes**. The
  latency-event width gate is therefore no longer unmeasured.

`cargo clippy -p ergodis-private --all-targets -- -D warnings` is clean on my files;
`cargo fmt` applied.

## One real bug found, and it was mine

The first version of `apply_event_to_graph` computed the changed edge weights and returned them but
never wrote them into the graph — only `IncrementalSssp::apply_changes` did. Any comparator that
read the graph directly (the all-pairs matrix, and a from-scratch Dijkstra used as an oracle) then
saw stale weights. The symptom was an apparent disagreement between the retained tree and Dijkstra
at width 2, which briefly looked like a tree bug and was not: **the tree was right throughout**. The
repair makes the bridge write the weights and carry `(id, old, new)` so the repair routines still
know each change's direction. The diagnostic that isolated it — comparing an incremental refresh
against a full refresh — is retained as a permanent gate.

The lesson worth carrying: when a differential gate fires between a mature component and a new one,
suspect the new one's *plumbing* before the mature one's mathematics.

## What is NOT measured

Everything quantitative. Specifically, none of the following was run:

1. **Instructions per event: retained delta against `IncrementalSssp`.** This is the whole point of
   the probe and it is ready to run — both sides are built, exact against each other, and the
   fixed-window harness pattern from probe 17 applies unchanged. Expect the retained delta's
   advantage to shrink substantially against a dynamic baseline; probe 17's 41x-305x is against a
   static one and should not be assumed to survive.
2. **Instructions per event: retained delta against `DenseApsp`**, and the fabric size at which the
   `O(n^2)` matrix becomes intractable (at 1,024 pods and width 4 the layered graph has 16,386
   vertices, so a single update is on the order of `2.7 x 10^8` cell visits — the comparator is
   expected to be structurally dominated and only tractable on small fabrics).
3. **The all-pairs objective mismatch.** The retained tree maintains the `S x S` *boundary* matrix,
   not a pod-to-pod all-pairs matrix. `DenseApsp` maintains all pairs over the layered graph. These
   are different objectives, and a like-for-like all-pairs comparison needs either a pod-to-pod
   readout added to the tree or the matrix restricted to pod boundary vertices. Neither is built.
4. **Part B of the probe brief** (a congruence scorer over pod boundary summaries, raw link-level
   events against a boundary-level vocabulary, reusing `CongruenceCorpus::from_parts`). Not started.
   `from_parts` is the confirmed reuse hook.
5. **Part C of the probe brief** (separator scaling: whether Pareto pruning, tropical normalization
   or bandwidth quantization reduce the effective width below `S`, and the `k` at which the delta
   stops beating the fair baseline). Not started. The natural first measurement is the *effective*
   width — how many distinct `(penalty, bandwidth, failed)` port classes a node actually has as
   failures accumulate — since probe 17 showed per-event cost scales as `S^3`.

## Next steps for a fresh session

1. Run the paired A/B, eight interleaved rounds, fixed event window, two-size differencing:
   `routing-delta` against a new `routing-incremental` mode driving `IncrementalSssp`. Report
   instructions per event with confidence intervals at pods 256 and 1,024 and widths 2, 4, 8.
   This single measurement decides whether routing's positive verdict survives a fair baseline.
2. Report `settled`, `relaxations` and `affected_count` per event alongside the instruction counts:
   they say *why* the incremental baseline costs what it does and make the comparison explicable
   rather than just a ratio.
3. Only then attempt the all-pairs comparison, and only after deciding which objective both sides
   should answer.
4. Treat probe 17's routing row as provisional until step 1 lands. The boundary-class census from
   probe 17 (9 to 360 reachable classes over `10^5` events, shrinking with fabric size) is
   independent of the comparator and stands.

## Vibe check

Incomplete but clean. The fair baseline is built, is exact against the retained tree at every vertex
over hundreds of events, and is committed with its gates; what is missing is purely the measurement,
which is a short session's work. The one substantive finding is negative and about my own code: a
plumbing bug in the new bridge briefly impersonated a mathematical disagreement, and the width-2 and
width-8 differential gates that probe 17 never had are now in place and passing.
