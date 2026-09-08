# C1130 — Scheduling modules and direct input interaction

**PRIVATE — contributor context; do not ship.**
**Lane**: `ergodis`. Date: 2026-09-08.
**Status**: bounded application slice complete, private `ec3185c`. Full C1130 remains open.

## Current behavior

Recovery and resource scheduling expose blue capacity grips directly on their bar
charts. Dragging previews a value locally; release stages changed source capacities,
clears the stale result and compiles the replacement model on the next Run. Arrow
keys change one unit; Shift changes ten; Home sets zero. Keyboard focus survives
committed edits. Snapshot charts omit mutation handles. The above-chart capacity
input rows are removed. Target repairs/rebuilds use a range slider with an exact
numeric field; changing only the target reuses the compiled plan.

Hover previews the shared inspector without changing the pinned selection, query,
source or result. Clicking pins the input; leaving the hovered input restores the
pin. This covers recovery/scheduling resources, FT10 machine/operation cells,
QEC detectors, feature rows, Hadamard points and query-comparison tiles. QEC edges
and FT10 competing-machine highlights follow the preview. Keyboard focus also
previews; Enter/Space pin. In a runnable QEC session, double-clicking a detector
uses the same parity mutation as the parity controls. Its first click pins without
replacing detector DOM, allowing real browser double-click recognition. A parity
change clears stale evidence but retains the compiled detector model. Interactive
charts, comparison cells and buttons disable text selection so clicks, drags and
double-clicks do not accidentally select labels. Numeric fields remain editable.

Results retain a distinct heading, status and large count above the resource chart.
Detailed scheduling loads are available in the resource inspector and execution
record. On narrow screens, charts scroll horizontally to preserve usable grips.
Recovery labels distinguish base capacity, returned load and dashed query top-ups;
dragging a base grip never silently incorporates an old parity query top-up or an
unapplied proposed design into the source.

## Scheduling execution and scope

`src/scheduling_contract.rs` is a cold adapter over the existing public native
`WeightedRepairProblem` and `gpu_checkpoint_mds_recovery` compiler. It accepts
`scheduling.v1` models of kind `resource-allocation` (capacities, option families,
optional positive grading) or `gpu-checkpoint` (MDS shards, placements, failures,
replacement nodes and helper/network capacities). It uses the native adaptive
scheduler with an owned reusable workspace. No new search kernel is introduced.

The separately loaded scheduling provider uses the existing public module ABI:
capability `private.resource-scheduling`, implementation revision 1. Prepare accepts
JSON; query readout 0 accepts `[0,target]` u32 LE. Result JSON contains maximum batch
count, assignment and deferred demand IDs, resource loads, target status and work
counts. Loads/counters that can exceed JS-safe range are decimal strings. Output
capacity is conservatively preflighted. Retained plan/workspace ownership and
release/stale-handle behavior match the other providers.

The default modeled GPU checkpoint workload has 12 GPUs across three racks,
8 data shards, 3 missing shards, and 9 surviving helper choices per rebuild.
Each helper GPU initially supplies two reads per window. The exact default batch
is two rebuilds: eighteen available reads independently bound the count by
floor(18/8)=2, and the returned witness attains it. Raising surviving GPU capacities
to three and cross-rack capacity from 12 to 18 permits all three rebuilds.
This is a modeled workload, not a production trace. It schedules a simultaneous
resource batch, not job-shop start times. FT10 remains importable as an inspectable
100-operation input under `scheduling_ft10`; no FT10 solve is implied.

## Native performance and portability

Public core sources, solver hot loops/layouts and backend policies are unchanged.
The accepted LRC and QEC native/WASM payloads are byte-identical to the previously
accepted packages. The scheduling bridge's serialization and existing adaptive
API storage preparation are cold boundaries; the whole call is not claimed to be
allocation-free. No native performance improvement or universal WASM feature
completion is claimed here. Both contributor performance documents were loaded.

One canonical public WASM engine/host loads all three independent application
extensions; this does not introduce another reduced demo engine. Embedded Tavis
Rudd notices and stripped-source-path checks pass for the scheduling payloads.
The frozen native recipient loads and executes the new family without rebuilding
the host. Full CampaignSession integration, composition and glossary reconciliation
remain C1130 frontiers.

## Validation and replay

Three native scheduling tests pass: typed/native module answer parity and lifecycle
rejections, generic allocation and malformed model admission, upgraded inputs and
four owned worker executions. LRC/QEC provider contract tests pass, including their
existing allocation checks. Scheduling Clippy passes. Actual Chromium agrees with
the native scheduling result, runs generic imported options, verifies an actual
mouse capacity drag, keyboard edits and target slider, then verifies all prior
QEC/LRC/design/map/portable workflows. Real double-clicks toggle detector parity
exactly once and twice restore the original query, retaining the plan. Hover/pin
checks preserve results across all named views. Desktop/narrow viewport gates pass.

Committed replay scripts/evidence live under private
`analysis/module-loading/{package-scheduling.py,scheduling-evidence/}` and
`analysis/campaign-console/mockups/applications-smoke.mjs`.
Build the extension with `bash analysis/module-loading/build-distribution.sh scheduling`;
package to a fresh directory with `uv run python analysis/module-loading/package-scheduling.py --output PATH`.
The packager uses the accepted capacity-design recipients and frozen native host;
these cached baselines must exist. Exact native/browser replay commands, source and
payload hashes, native reference output, and screenshot hashes are in the evidence.

Active application previews: `http://127.0.0.1:8769/` and `http://127.0.0.1:8770/`,
serving `~/.cache/ergodis/application-workspace/index.html` and extensions from
`~/.cache/ergodis/module-loading/scheduling-accepted/recipients`.
Owned server PIDs are 3595787 and 3595788; their PID/log files remain under
`~/.cache/ergodis/input-query-mockups` and `~/.cache/ergodis/application-workspace`.
Temporary preview process removed. Main campaign port 8767 is unchanged.
