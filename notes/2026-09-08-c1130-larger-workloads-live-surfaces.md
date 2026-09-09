# C1130 — Larger WASM workloads and live objective surfaces

**PRIVATE — contributor context only. Do not ship, export or publish.**
**Lane**: `ergodis`. Date: 2026-09-08.

Private commits `017f2f1` and `7403a6e` add four loaded runnable workloads and
incremental capacity exploration to the application workspace at 8769/8770.
User steered this ahead of portable run recording. C1130 remains open.

## Delivered behavior

Workload selector offers existing QEC / 12-GPU checkpoint / six-repair inputs,
plus LRC batches of 60 and 600 repairs and heterogeneous CPU/GPU inference
allocations of 24 and 72 jobs. These are explicitly modeled scenarios, not
production traces. The new resource-allocation cases have CPU/GPU alternatives
and a shared transfer capacity. Inputs remain downloadable/editable; activation
is explicit. Selection returns to a snapshot and clears the previous session.

The 72-job initial configuration serves 36 jobs, with transfer capacity 36.
Its resource chart precedes the individual assignments; inspector omits zero
loads. Resource names are validated and escaped at HTML boundaries. This is
simultaneous allocation, not duration/start-time scheduling.

For the CPU/GPU workloads, Query → Explore capacity surface executes a 9 by 9
integer capacity grid through the same native-compiled WASM provider. Axes range
from zero to twice current first/second resource capacity, with a small nonzero
range for initially zero capacities. Other capacities stay fixed. Center-out
ordering reveals the current neighborhood first. Each cell appears only after
an exact forward solve completes; blank cells carry no inferred answer. The
progress count is completed configurations, not an estimated percentage inside
a solver. No kernel instrumentation or artificial delays were added.

Users set a job target and separate nonnegative CPU/GPU capacity weights.
The highlighted configuration minimizes weighted first/second-resource capacity
among computed grid points meeting the target. Fixed-resource costs are constant
across this comparison and are omitted. This is a sampled design comparison,
not a continuous or global optimum claim. Weights are bounded at one million
so weighted u32 capacity sums remain within exact JS integer range. Zero weights
are allowed. The general Fit/Optimize solver objectives remain unchanged.

Stop sweep requests a stop between complete configuration solves, retaining the
computed cells and labeling the surface partial. It does not interrupt an active
inner solve. Temporary compiled plans/workspaces are released through the existing
withModel lifecycle. The accepted base session remains available for later runs.

## Validation

Replay from ergodis-private:

```sh
uv run python analysis/campaign-console/mockups/build.py --output /home/tavis/.cache/ergodis/application-workspace/index.html
nix shell nixpkgs#nodejs nixpkgs#chromium --command node analysis/campaign-console/mockups/run-smoke.mjs --url http://127.0.0.1:8769/ --shot /home/tavis/.cache/ergodis/application-workspace/larger.png
```

Final behavioral gate passed in 12 seconds, including existing portable workflows,
QEC parity/toggling, recovery design/apply, scheduling Fit/Optimize, direct input
interaction, all four larger solves, snapshot-only workload loading and mobile
width. New scheduling results are cross-checked against an independent bounded
reachable-load DP, and assignments are independently checked against source
options, uniqueness, capacity bounds and returned aggregate loads.

The surface gate observed multiple intermediate DOM progress values before full
completion, 81 completed cells, asymmetric objective weights with an eligible
winner, and a separate stopped run retaining between 1 and 80 completed cells.
Saved log:
`/tmp/claude-run-quiet/20260908-182059-nix-shell-nixpkgsnodejs-nixpkgschromium-command-node-run-smoke.mjs-url-127.0.0.18/stdout.log`.
Screenshots are under `~/.cache/ergodis/application-workspace/larger-*.png`.
The compute-72 and completed surface screenshots were visually inspected.
After that gate, a display-only change added axis titles directly beside the
axes using SVG textContent; diff hygiene passed, no new semantic test was needed.

No Rust, provider payload, canonical WASM binary or native solver was changed;
accepted capacity-fit provider packages remain in use. No native performance
claim is derived from browser timings. The broader capability inventory,
composition binding and CampaignSession/portable record integration remain open.

## Review hygiene

An attempted fixture summary printed an unexcluded QEC faults array (37,575
original tokens), violating the command-output cap. The omitted output was not
used or reread; subsequent implementation used known schema fields and bounded
source reads. No result depends on that oversized output.
