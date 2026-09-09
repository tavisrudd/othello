# C1130 — running capacity-fit adoption spike

PRIVATE — NOT TO SHIP. 2026-09-08.

Implemented a retained Fit execution object, counted advance/yield, transactional
source-checked minimum-load charge installation, applied epochs, bound-prune
counts and explicit complete/budget-exhausted/cancelled statuses. One run keeps
its exact stack, incumbent and witness. Native and WASM use the same kernel.
The ordinary native const specialization removes continuation bookkeeping.

Private evidence and exact replay commands:
`ergodis-private/analysis/module-loading/live-fit-evidence/README.md`.
10 scheduling contract tests pass; controlled/exhaustive objective and witness
parity, arbitrary slice boundaries, rejection/cancellation and zero allocations
are covered. LRC/QEC contract tests and full browser regression pass. Source-free
native transcript bytes match real WASM readouts, including begin/advance/install.
Desktop/mobile live proof inspectors pass, including LAN HTTP missing-crypto mode.

Final ordinary native retained cycle ratios: 0.9936 / 0.9931 one/four workers.
Controlled no-bound execution still costs ~8–10% median cycles; do not promise free
control. Loaded forward cycles show no established regression in the longer gate;
cache counters are unstable and retained explicitly. See evidence for RSS, hashes,
raw samples, rejected variants and the limits of these measurements.

`/live-fit` is live on 0.0.0.0 ports 8769/8770. The main `/evolve` page offers it as
a separate comparison mode; its default remains the existing capacity grid.
**User clarification:** replacing the original demos with this example is NOT
what was requested. The existing 96-/72-/24-job grid queries must gain live
promotion while preserving their exact original questions and verdicts. That
integration remains open: their adaptive forward scheduler is still blocking.
Do not claim enabling the new page closes that gap.

The spike's zero-base minimum-total-capacity example is separable, and an
independent cheapest-option/top-k oracle confirms its optimum. Its dramatic
node reduction demonstrates transport and safe admission, not novel discovery
or a best-solver speed comparison. The user also requests a genuinely huge-space
benchmark example. BENCHMARKS.md identifies Ceph XOR's 80-diamond 2^80 support
family, retained as a ZDD and reused for reliability/scheduling, as a strong
candidate. Read the existing kernel and implement real WASM operations, not a
static infographic or a copied demo solver.

## Why the existing grid rates mislead

The saved 625-point trace took 58.1393 s baseline, 49.695 s with Evolve. Matching
completion intervals to the deterministic query order shows the 339 excluded
queries represented only 9.7088 s of baseline wall intervals. The 286 retained
queries represented 48.428 s and averaged 169 ms, versus 29 ms for excluded
queries. Thus 54% fewer queries avoided only about 17% of measured baseline time.
Retained-query time rose ~2.6%; intervals include controller/UI effects and do
not isolate kernel execution. The 250 ms rolling rate window amplifies variable
query costs (0.1–376 ms). Do not compare raw queries/sec as equal-work throughput.
Future traces should record per-query identity and kernel/boundary duration.

## Remaining work

1. Actual controlled/resumable adaptive scheduling on the existing grid cases,
   with backend-use proofs. Counted-type DP relaxes multiplicities; its states
   cannot inherit bounded-source residual pruning without a mapping.
2. A large-space benchmark demonstration using actual compiled canonical modules.
3. Integrate these execution objects with CampaignSession; stable lifecycle ABI,
   retained proof dependencies and broader workload/performance acceptance remain.
