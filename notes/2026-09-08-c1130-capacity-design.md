# C1130 — Capacity design and two-axis recovery exploration

**PRIVATE — contributor report; do not ship.**
**Lane**: `ergodis`. Date: 2026-09-08.
**Status**: bounded slice complete, private `5b327eb`. Full C1130 remains open.

## User-visible result

Recovery now edits all nine resource capacities and can ask for the minimum
additive upgrade needed for a chosen repair target. The equal-unit-cost objective
allows increases in any domain, never decreases or transfers existing capacity.
For the original six-demand HostileInstances scenario, the exact minimum is 20
added units: data [14,5,5,5,5,5], local parity 6, globals [0,9]. This is a capacity
planning result in native kernel units, not a monetary estimate or file recovery.

The native/WASM design result is forward-checked in WASM and carries the repair
witness. Apply configuration and run compiles and evaluates the proposed model.
Manual capacity edits stage a replacement input; Run admits/compiles it before
execution. Query-only edits reuse the existing plan. Snapshot views hide resource
edit and apply actions. Input downloads include pending capacity edits.

The 2D map's X axis is Minimum capacity per data domain, in capacity units: smaller
input data capacities rise to that minimum. Y is Global-parity capacity, G0 + G1,
in capacity units, with a vertical label beside integer ticks. The map replaces
the two global capacities with an even split of the chosen total; local parity
stays fixed. This exploratory slice may decrease/redistribute global capacity and
is distinct from the optimizer's additive-only nine-dimensional design space.
Color encodes the exact repair count; outlines identify cells meeting the target.
Selecting a cell exposes its exact coordinates and an explicit Apply and run.
Larger axes are sampled and labelled; totals above u32::MAX are loaded as two
valid domain capacities rather than truncated. Temporary plans/workspaces are
released, and the model's map is cached across query-only edits.

## Native design readout and correctness

Private src/lrc_capacity_design.rs adds an independent readout with fixed arrays
and a 48-byte explicitly asserted result layout. Existing forward kernels and
hot records are unchanged. LRC provider implementation revision 4 adds readout 3
(reserved zero, target); its existing ABI/schema remain compatible. The public
host and QEC package are unchanged. Native and WASM use identical Rust source.

For target t and l local repairs, aggregate data load is A=2t-l. If c_i is data
capacity and m_i is the existing round-robin demand multiplicity, define
D=sum max(0,A-c_i), M=sum min(max(0,A-c_i),m_i). Optimal data addition for this l
is D-min(t,M): each served demand can save one data-capacity unit, up to its
multiplicity and deficit. Add max(0,l-LC) and max(0,t-l-G0-G1) for parity.
The data term is max(D-t, sum max(0,A-c_i-m_i)); each branch is convex in l.
Adding the parity terms preserves discrete convexity. Neighboring-cost binary
search finds the leftmost minimum in at most 65 scalar probes over the entire
u32 target range. The representable interval enforces six mandatory servings if
A exceeds u32::MAX; the reconstructed loads therefore fit the capacity type.
Targets beyond pending demand explicitly return no configuration. Ties do not
claim uniqueness. This is algorithmic optimality, not an independent certificate.

Independent tests enumerate all per-demand unserved/local/global0/global1 choices
for demands 0..7, twelve deterministic capacity sets each, and every target.
They compare the exact minimum addition and verify forward feasibility. Separate
full-u32, single/four-worker, allocation-counted repeated calls, module readout and
plan-preservation gates pass. Clippy passes for the provider. The frozen source-free
native recipient accepts the original transcript plus the new design result.
Chromium verifies native/WASM agreement, edit/recompile, design/apply, selected-map
replay, witness loads, snapshot gating, narrow layout and prior QEC/portable flows.

## Native performance acceptance and retained variants

The first extra dispatch branch changed compilation of an existing batch loop:
20-million-query interleaved controls showed about 6% more cycles at batch 256.
A cold fallback still cost about 3.6% in four-worker batch cycles. Neither variant
is active. The accepted implementation places the unchanged batch executor behind
an explicit non-inline boundary, isolating it from the new design dispatch.

Five interleaved before/after rounds, batches 1/256, workers 1/4, use the identical
retained host lrc-module-boundary-3aafb81 and hashed stripped provider libraries.
Accepted cycle ratios are 0.735/0.731 at batch one and 0.896/0.895 at batch 256;
instruction ratios are about 0.853 and 0.875. Exact output/work checksum parity
holds; branches, branch misses, cache misses, RSS and old/new leaf profiles are
retained. This is scoped boundary evidence, not a general kernel speed claim.
The new design readout has no previous equivalent; zero allocations, at most 65
probes, independent enumeration and cross-target replay are its acceptance gates.

Private reproducibility bundle:
analysis/module-loading/capacity-design-evidence/ (manifest hashes, raw counters,
variant summaries, leaf profiles and accepted package identity). Replay scripts:
package-capacity-design.py, capacity-design-counters.py, capacity-design-profile.py.
Accepted package: ~/.cache/ergodis/module-loading/capacity-design-isolated/.
Stripped notice/path-marker checks pass; Tavis Rudd notices remain embedded.
Rejected variants stay as evidence; the temporary preview serving the first
variant was terminated. Ports 8769 and 8770 serve the accepted package and same
application page; main historical campaign console 8767 stays separate.

## Next

User explicitly requested scheduling next. Use the actual native scheduling
contract and workload inventory; do not represent the FT10 operation diagram as
an implemented job-shop solver. CampaignSession/general execution integration,
third-family/glossary reconciliation and full WASM capability closure remain open.
