# C1130: Stop responsiveness and hidden history work

PRIVATE / not-to-ship.

A live capacity-chart update rebuilt every proposal-history paragraph even when
its details section was folded. With a large discovery history this creates
avoidable main-thread DOM work at the chart refresh rate; terminating workers
cannot process an input event until that work yields.

The viewer now retains history data without rendering hidden rows. Opening the
history appends at most 128 rows per animation frame; closing it cancels pending
work and releases the rows. An unchanged history is not rebuilt on each chart
update. Ordinary chart throttling remains 10/s for coarse pointers and 15/s for
desktop, using animation frames. No solver or native hot path changed.

Stop now retires the run generation and releases controls synchronously in the
input handler, before invoking abort. Touch uses primary pointer-down; click
remains for keyboard activation. Worker abort/termination still happens in that
handler, but asynchronous runner settlement cannot hold the UI. Shared chart
schedulers and view callbacks ignore updates after abort, preventing late cleanup
from repainting an old run. This addresses the user's follow-up that phone Stop
must not wait seconds for cleanup.

Browser checks cover a 20,000-row imported history (zero closed rows, incremental
open rendering, full contents and close cleanup), Stop against an unresponsive
worker, Stop during an actual 360-qubit race with 4x CPU throttling and a deliberately delayed 1.5-second cleanup continuation, synchronous control release on touch, chart-rate
limits and race-selection cancellation. This identifies and removes one concrete
source of input latency. It does not claim the user's exact device/workload has
been reproduced: that detail was requested asynchronously. Safari/iPhone hardware
was not exercised here.

The shared suite gains history-reporting and stop-active-reporting (45 checks
total). The six relevant browser checks (including learned reruns) are the acceptance gate for this UI fix.
The existing server reads these JS modules from source with revalidation, so a
page refresh loads the change without a WASM rebuild or server restart.

Validation: all six selected checks passed in
`~/.cache/ergodis/js-wasm-tests/20260910T141533.169216Z/report.json`.
Stop round-trip measurement was 4 ms for the unresponsive worker test and 10 ms
for the active 4x-throttled test. Both also require controls to be released within
the same input-handler call, before promise settlement. Those measurements include
CDP communication and are not an iPhone hardware benchmark. Cache GC was dry-run
only; nothing was deleted.
