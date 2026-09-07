# C1124 — Real-workload Ergodis campaign console

Date: 2026-09-07. Lane: `ergodis`. Status: in progress.

User direction: the older Ergodis Campaign Console artifact is the desired
interface; avoid infographic presentation and toy examples. Recover the real
console, use current engine runs over actual research corpora, and preserve
clear provenance, baseline, coverage and missing-data semantics.

Owned paths: private `analysis/campaign-console/`; task report, queue row and
Ergodis handoff/archive. Existing console source is recovered from the committed
`c1031-ergodis-viz:tools/c1031-viz` branch, not the 17 MiB browser-saved HTML.
No core or solver edit is currently required. The user-provided saved HTML and
its adjacent saved_resource.html are visual references, not current evidence.

Acceptance: current native-engine run over real order-2092 research corpus;
static and live console browser gates; reader/adversarial and current Rust VM
comparison gates; visible research scope and current/historical provenance;
reviewable console entry and exact replay instructions. No paper-facing or
Hadamard-existence claim.

Operational note: an initial `head` of the minified outer artifact exceeded the
output budget. That output was not inspected; iframe extraction and browser
rendering replaced it. Logged locally in demo-reference/read-failure.txt.
