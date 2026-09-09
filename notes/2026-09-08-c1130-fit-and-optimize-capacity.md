# C1130 — Fit target and optimize capacity

**PRIVATE — contributor context and evidence pointers; do not ship.**
**Lane**: `ergodis`. Date: 2026-09-08.
**Status**: bounded slice complete. Core `f9faafd`, private `6d81ee2`.
Full C1130 remains open; this is not universal WASM feature-completeness acceptance.

## User contract

Scheduling and recovery now offer three query modes: Evaluate capacities, Fit target,
and Optimize capacity. Fit target minimizes added capacity while treating current
capacities as lower bounds. Optimize capacity allows increases and reductions and
minimizes total installed capacity. All resource units currently have equal cost;
this is a model-unit objective, not a hardware price estimate. Scheduling breaks
minimum-total ties by minimizing additions, which also minimizes removals and
absolute change when total capacity is fixed. Current capacities are never changed
by obtaining a proposal. Apply configuration and run explicitly adopts it and
executes the forward query. The main query heading tracks the inverse objective.

The scheduling default initially has 42 capacity units and serves two of three
rebuilds. Fitting all three requires nine added units: six helper-read units plus
three cross-rack units, preserving the original within-rack capacity (51 total).
Optimization achieves the same target with 48 total units: nine additions and
three removals, including within-rack capacity 12→9 and cross-rack capacity 12→15.
The witness attains the independent 48-unit bound: three rebuilds each require
eight helper reads and eight transfers on this fixture's distinct failed nodes.

The recovery default has 34 units. Fitting six repairs retains all existing units
and adds twenty (54 total). Optimizing yields 36 total, with twenty additions and
eighteen removals: data capacities [5,5,5,5,5,5], local parity 6, globals [0,0].
Recovery uses its existing native design readout against zero lower bounds, then
forward-checks the proposed capacities in WASM. Its accepted native/WASM payloads
are unchanged. The same holds for the QEC payloads.

## Solver and abstraction

The public core adds only the cold `WeightedRepairProblem::materialize_families`
readout. It returns the admitted, nondominated option families surviving that
compiled problem's capacities, not the unfiltered original model. Narrow and wide
loads and empty demands have explicit tests. No public solver hot loop, hot record,
backend policy or private application dependency changes.

Private scheduling re-admits the original source at representable relaxed capacity
(u32::MAX per resource), then materializes the native compiler's options. This
retains the native GPU checkpoint compiler and generic resource-allocation admission
instead of duplicating their domain compilers. Optional positive-grading hints are
recomputed because old capacity-filtered grading need not cover newly available
options; a regression test exercises that case.

`src/resource_capacity_fit.rs` owns the shared bounded exact capacity-design
readout. It flattens the admitted families during cold compilation. Its iterative
traversal uses presized, worker-owned choice/cursor/load arrays; no recursion,
allocation, locks, serialization or owned per-state containers enter the loop.
FitStats has an asserted repr(C) 32-byte, 8-byte-aligned layout on native and WASM.
Mode and pruning dispatch use const generics outside traversal. Accumulation is
u64; any candidate requiring an unrepresentable u32 capacity is rejected.

For load vector L and base C, Fit minimizes sum(max(0,L_i−C_i)). Optimize minimizes
sum(L_i), then additions as a tie-break. Nonnegative loads make partial costs valid
lower bounds. Since removing extra scheduled demands cannot increase either
objective, searching exactly the requested count suffices for an at-least target.
Nondominated source options suffice for both monotone objectives.

The scheduler provider is revision 2 of scheduling.v1. Readout 0 retains the forward
query. Readout 1 fits; readout 2 optimizes; both receive [readout,target,node_budget]
as u32 little-endian words. Result JSON distinguishes feasibility and completed
optimality, reports capacities, witness loads/assignment, additions/removals and
work count. The UI uses a two-million-decision budget. A budget-exhausted result is
labelled an incumbent or no configuration yet; it never claims a proved minimum.
The generic search can be expensive on larger families. Budget controls and resume
are not added to the application UI by this slice.

The new design workspace is allocated lazily in its own box. Unsupported forward
query lengths dispatch to a cold design handler, preserving the ordinary forward
path and keeping the large design implementation out of it. Repeated target/objective
queries retain the original compilation and reuse the design workspace. Applying
capacities explicitly compiles a replacement model.

## Validation and performance

Core fmt, all-target/all-feature Clippy and all-feature tests pass, including the
committed Python differential corpus. Six private scheduling tests pass: existing
forward/lifecycle checks, generic/malformed admission, upgraded shared-plan owned
workers, independent mixed-radix exhaustive objective oracle over twenty capacity
cases and targets 0..4, zero-budget/representability/zero-allocation checks, and
capacity-dependent grading re-admission. Single/four-worker exact results agree.
LRC/QEC provider contract and existing allocation checks still pass.

The frozen source-free native recipient executes forward, Fit and Optimize without
a host rebuild. Actual Chromium agrees with native results for both inverse modes,
checks proposals do not mutate sources, applies and forward-runs them, checks
incomplete-budget status, and reruns QEC, recovery design/maps, drag/hover/pin,
parity double-click, snapshot, mobile and portable CampaignSpec/bundle workflows.
One browser invocation had a transient Worker script-load error before reaching
the new scheduling cases. Diagnostic capture was added; later runs passed. A
subsequent test-only duplicate global const declaration was corrected with local
scope. Neither failure was hidden by changing an acceptance assertion.

Performance uses retained test host capacity-fit-boundary-7173640, SHA256
241296330d1baed21389dd5d5dd348e68672212c5922ee491b96f2240f47b347,
with exact old/new stripped provider packages, physical-core affinity, five
interleaved rounds, one/four owned workers, counters and peak RSS. Original
forward work/result bytes agree. The initial inline design workspace/dispatch
variant cost about 1% forward cycles and is not active. The boxed/cold variant
eliminates a statistically established slowdown on these controls.

Final accepted forward paired cycle ratios are 0.9895 / 0.9917 (one/four workers),
with paired log t-scores −0.67 / −1.40: treat cycles as unchanged within noise, not
as a speedup. Instructions are about 0.9887 in both modes. Ratios of cycle medians
are 1.0128 / 0.9953; all raw samples and the intermediate boxed comparison remain
retained. Final branch misses rose while instructions fell; do not claim an
all-counter improvement. This acceptance is limited to the retained forward
fixture and does not assert a universal native performance result.

The new pruning specialization was compared with exhaustive traversal in the same
retained host: cost/witness parity and zero measured allocations, 910 decisions
per fixture call, about 0.90 cycle ratio on one/four workers. At this small depth,
pruning saves terminal evaluation rather than counted decisions; instructions
increase about 3.4% while branch misses fall. These are not general solver-ranking
claims. Mutable storage is owned per worker; no shared search communication was
introduced. Profiles include the existing forward API's cold preparation and
serialization allocations; its whole call is not claimed allocation-free.

## Replay, running preview and remaining work

Private replay scripts: analysis/module-loading/package-scheduling.py and
capacity-fit-counters.py. The latter accepts --candidate and --forward-only;
retaining the test host uses ../ergodis-contrib/scripts/retain-bin.sh
packages/scheduling-provider contracts --test --label capacity-fit-boundary.
Build providers with build-distribution.sh scheduling in the Nix Cargo/rustc/lld
environment. Package into a fresh output directory; the script requires the
accepted capacity-design recipients and frozen host cache as baselines.
Exact browser/native commands, hashes, native references, raw samples, summaries
and profiles are committed in analysis/module-loading/capacity-fit-evidence/.
The package script audits notices/source-path stripping and preserves LRC/QEC hashes.

Live applications remain at http://127.0.0.1:8769/ and :8770/. Accepted extensions
are ~/.cache/ergodis/module-loading/capacity-fit-accepted/recipients. Owned server
PIDs: 3659647 / 3659648; PID/log locations remain under input-query-mockups and
application-workspace. Temporary fit preview was stopped; campaign port 8767 stays
unchanged. The public module host/WASM client is still canonical.

Next C1130 frontier: CampaignSession/composition integration and the private glossary
pass. Keep source design, fixed-capacity query, feasibility witness, completed
optimality, query target and inspection pin distinct. Weighted resource prices,
per-resource locked bounds, and optimization budget/resume UI are not implied by
this equal-unit-cost implementation.
