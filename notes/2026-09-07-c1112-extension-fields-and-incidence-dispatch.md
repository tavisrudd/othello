# C1112: extension fields and incidence-query dispatch

## Outcome

The frozen size > 5 trace selector passes on q=16,23,25,27, without retraining.
The respective maximal-clique counts are 7760,26076,35388,46468, all below the
explicit 100000 budget. The largest nontrace clique has size five in each
case; all four oracle partitions are recovered exactly.

The candidate constructs adjacency by coordinate equality and polynomial field
arithmetic. The checker constructs normalized projective line equations using
log-table multiplication. The field model is shared and every multiplication
is cross-checked; this is not independent field-axiom formalization. Maximal-clique
enumeration is still shared. Exact models/seeds and full limits are recorded.

A new query returns the trace IDs containing at least two selected vertices.
Both controls cache the same partitions; one scans trace bitmaps, the other
accumulates the selected vertices' labels. Output equality holds for all sampled
queries. Seven interleaved Python rounds show sparse counting wins for small
subsets while scanning wins for larger ones.

The existing tree proposer learns size <= 4 from q=16 timing labels. On a new,
held-out q=27 mixed workload of 5000 queries, interpreted dispatch has median
26.213 ms versus 29.050 ms for always scanning: ratio 1.108. The first-batch
cost model, including common reconstruction/verification and extra label
construction/admission, gives only 1.008. It is a model, not two measured cold
processes. Common source/query preparation is excluded; output construction
and dispatch overhead are included in the warm comparison.

Both branches are exact; cost learning cannot change mathematical authority.
This is a bounded Python readout diagnostic, not a native/product speed claim.
C1113 remains gated. The next discriminator is a native readout experiment with
matched accounting and the performance contract, before workload transfer.

## Source and reproduction

Private worktree branch `spike/continuation-reconstruction`, commit `3847f33`,
root `~/.cache/ergodis/worktrees/continuation/ergodis-private`; sibling core
remains pinned at `67d929b`. Main-checkout implementation is untouched.

Run `experiments/continuation/run_adversarial.sh`. The complete report is
`experiments/continuation/ADVERSARIAL.md`; frozen fixtures, training batch,
learned plan and raw measurements are under `adversarial-fixtures/`. The updated
SHA256SUMS binds 43 source/fixture files. This slice adds about 31 KB.

Workspace formatting, scoped Clippy, all three Rust tests, fresh and frozen
calibration replay, and the Python exact-agreement gates pass. Full run log:
`~/.cache/ergodis/continuation-spike/logs/20260907-171612-run_adversarial.sh`.
The entire slice uses disk-backed run/log/temp directories and the existing
shared Cargo target. No Lean, core-kernel, publication or export work.

## ej+tt closeout / Mystery ledger

Extra-value pass (private `20237c9`): frozen-sample cost accounting separates
248.152 ms shared setup from 0.584 ms incremental label construction/admission.
Linear reuse predicts incremental payback at 1030 queries (1340 under the observed
extreme-round envelope, not a confidence bound). Replay and an independent rational
arithmetic check pass; the expanded manifest verifies 46 files. No new timings.

The user's benchmark-application steer selects W2/W3/L2 scheduler grouping and
positive-grading discovery as the best next experiment. The optimized existing
compiler remains the main control; merely rediscovering its reductions is not a
new speedup. Ceph's existing reliability and scheduler readouts are the next reuse
candidate. The complete six-application mapping, exact admission obligations,
perturbation controls and evidence gates are in the worktree's
`experiments/continuation/BENCHMARK-TRANSFER.md`. This is a proposed transfer test,
not an executed application result or a change to the C1113 gate.

The extension-field test settles the former coverage gap at the displayed
models, including characteristics two, three and five. Uniform validity of the
learned threshold remains unproved; no stronger clique theorem enters the paper.

The main gain is query-specific: adjacency compression alone lost, but learned
selection between two cached incidence readouts improves the sampled warm
workload. Setup mostly erases the first-batch benefit. A native end-to-end
workload and equal preparation/verification costs remain the transfer gate.
