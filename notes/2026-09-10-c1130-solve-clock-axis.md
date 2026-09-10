# C1130: solve clock and logarithmic time axis

The race clock now begins at the common release after every participating worker
finishes preparation and acknowledges readiness. Earlier worker timestamps no
longer include waiting for another worker in solve time. CSS, Hadamard and live-fit
use the shared gate; capacity races already used it. Hadamard's initial status
retrieval belongs to problem setup. Initial chart samples are at zero. Discovery
and reduction checking during search remain timed; genuine computing intervals
without intermediate progress samples remain visible.

The logarithmic axis has no separate tiny linear segment. Times at or below its
floor share the left frame. The floor is at least 0.5 ms, becomes 1 ms for Evolve
runs of 1–10 seconds, 10 ms for 10–100 seconds, and advances by decades thereafter.
It follows Evolve rather than a much slower control. Exact trace and finish times
are retained. The upper extent still advances in fixed decades. Every decade has
a tick (including 100 ms), with small intervening ticks; labels near the initial
floor can be omitted to avoid collision, but ticks are not omitted.

Validation: eight scoped JS/browser checks passed in
`~/.cache/ergodis/js-wasm-tests/20260910T143018.372283Z/report.md`.
The solve-origin browser regression delays two readiness acknowledgements by
500 ms and checks zero initial samples, immediate control dispatch after release,
unchanged distance results, left-frame alignment and adaptive floors. It also
checks decade/minor ticks and the 100 ms label. Hadamard's zero-origin smoke and
certificate verification passed in `~/.cache/ergodis/js-wasm-tests/solve-origin-hadamard-zero/`.
The adaptive chart was visually inspected in Chromium at
`~/.cache/ergodis/js-wasm-tests/solve-origin-adaptive-visual/chart.png`.
These are presentation/clock changes, with no solver or native kernel changes.
The user's physical iPhone has not been tested.
