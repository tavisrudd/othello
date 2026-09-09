# C1130 — live promotion into running solves

PRIVATE — NOT TO SHIP. User requirement clarified 2026-09-08.

Evolve must run independently of solving and promote an admitted reduction into
an already-running solve as soon as it is ready, following the native host pattern.
Generation barriers, finishing Evolve before solve, applying only to subsequent
queries, and restarting a solve are not equivalent acceptance outcomes. A slower
2.15s baseline / 2.46s Evolve comparison is a failed benefit example; state counts
alone must never be presented as speedup.

## Native reference and current gap

Core `src/alignment.rs` has controlled/uncontrolled instantiations and checks
steering at a 4096-state stride. Private `src/alignment_control.rs` has a blocking
watcher, prepared/recycled arenas, and an applied epoch; its safe point swaps a
prepared arena. The inspected consumer selects Ordering/Score plans. This
establishes live ordering injection, not a claim that every native backend already
accepts arbitrary pruning theorems. Core `src/control/client.rs` owns PlanArena.

The resource scheduler used by the demo calls `WeightedRepairProblem::
solve_adaptive_with_workspace` in `src/scheduler.rs`, through private
`src/scheduling_contract.rs` and `packages/execution-provider/src/lib.rs`.
`WeightedRepairWorkspace` explicitly retains storage but no logical solve state
between calls. Counted-type, sparse and dense paths are synchronous. The provider
EXECUTE call blocks its Worker; ordinary postMessage callbacks cannot run inside
that synchronous WASM call. There is no exposed advance/resume/promotion operation
on this application yet. Reusing the generic provider ABI does not close this gap.

The current browser change moves proposal generation, scoring and discovery-side
checking into a dedicated Evolve Worker and keeps a separate solver Worker running.
Controller admission publishes exclusions atomically to queued capacity queries;
in-flight queries are reserved and cannot be double counted. This is explicitly
labelled queued-query promotion, NOT the requested active-solver capability.
Solve completion and background discovery completion have separate timestamps.

## Concrete next implementation and gate

1. Preserve the native watcher/admission/epoch/safe-point pattern and specialized
   uncontrolled kernels. Extract resumable execution state from the existing
   resource kernels, not a second JavaScript or WASM solver. Keep ordinary native
   entry points and optimized layouts. Native hot-loop changes require the full
   retained A/B, allocation, counters and single/parallel gates before acceptance.
2. Expose begin/advance/status/cancel and checked-plan installation over the
   existing family/provider execution boundary. Carry a stable run identity,
   source/plan binding, monotonically applied epoch, incumbent witness and exact
   visited/pruned counters. A bounded advance must preserve the same workspace,
   frontier and witness history. It must not restart the query.
3. On plain HTTP, yield the Worker at bounded kernel safe points so incoming
   promotions can be accepted, then resume the same solve. Shared-memory signalling
   can provide an optimized path under HTTPS + cross-origin isolation; it must not
   become a feature-completeness prerequisite for the canonical WASM target.
4. Lift source cover theorems to residual search contexts. A global capacity-grid
   bound alone is not a branch-pruning rule. For a prefix with k selected jobs,
   residual resources and remaining jobs, independently admit a remaining-job
   cover and prune only if k + its upper bound cannot improve the incumbent (or
   cannot meet the requested threshold). Preserve the distinction between exact
   maximum readout and threshold feasibility; never invent a maximum from a
   failed threshold test. Compile remaining-group counts and immutable charging
   terms off the hot loop; use presized, range-sized records.
5. Prove the migration on a long query: inject a valid checked epoch after positive
   solve progress; observe the applied epoch and reduced future search work on the
   SAME run/frontier, with no restart. Reject wrong-source, wrong-role, stale,
   malformed and invalid plans without damaging the active solve. Compare exact
   optimum and witness against uninterrupted native/WASM controls and a bounded
   independent oracle. Test multiple promotion points/strides and an unhelpful
   rule. Record discovery CPU cost and promotion latency separately from solve
   latency. Report losses honestly.

This is the next C1130 integration slice. The runnable grammar/inspector work does
not close it, full WASM parity, or the production module ABI gates.
