# C1016: related kick retention and bounded carrier arithmetic

Private native authority: `~/src/ergodis-worktrees/c1016-full-2092/ergodis-private`.
Retention commit `5227bfb`; bounded scorer and invariant guards `f1811ec`;
completed evidence checkpoint `96e04d5`. Exact commands, retained executable
hashes, measurements, replay and limitations live in the authority's
`evidence/related-kick-retention-report.md` and companion validation JSON.
No public core, WASM, live8770 or UI changes.

Carrier Fibre/Column, phase-two Full/Q58/Q87/Q174 and Q29 column-margin kicks
now retain strictly better intermediate states. Six independent raw-move replay
tests expose the old loss and cover equal-score retention and empty kicks.
Together with the earlier margin-fibre repair, all four audited implementations
now enforce this invariant. No actual lost solution is claimed.

The first fixed build regressed Carrier Fibre cycles about 2.3–2.5%, including
with kicks disabled. Its normalized step instructions were unchanged but moved
144 bytes. A cold-function annotation did not remove the penalty and was
discarded. The address shift is a diagnostic lead, not a proven cause.

A separate mathematical bound enabled the real improvement: toggle effects sum
two signs; complete candidate-score arithmetic fits below 18 million in absolute
value. The kernel now computes in signed 32 bits and widens the final result.
Initialization/reset enforce ±1 signs; public transfer application rejects invalid
moves before mutation. No validation branch was added to candidate scoring.
The compiler emits packed integer arithmetic previously absent from the step.
This uses validated input ranges, not fixture coordinates or supplied solutions.

Validation: 765 release tests, 336 final fixed-work counter samples, zero
measured-loop allocations, 6,552 independently replayed witness occurrences,
552 distinct rebuilt objectives, 84 exact no-kick identities, and eleven
evidence-mutation tests. Initial and discarded-layout experiments remain retained
and replayable. Final profiles cover seven kernels on one/twelve cores, plus
the Carrier Fibre no-kick control. All final profiles reproduce measured work
and witnesses exactly.

Carrier Fibre/Column use 35.5–35.9% fewer cycles and 33.3–34.5% fewer retired
instructions across both core counts and all three stall policies. This is a
fixed-work result on the current busy host. Q29 twelve-core no-kick cycles rise
0.4% consistently; Phase Full one-core frequent-kick cycles rise 2.95% with
substantial variability. No blanket no-regression or cross-machine claim.
RSS is launcher-inclusive, not a kernel footprint measurement. Static step
instruction count grows 883→1041 despite fewer executed instructions.

## Property testing and next gate

The public core already has `proptest` tests for orbit/quotient compilation,
packed ternary operations and scheduling, including brute-force comparisons.
The private tabu kernels have fixed-seed oracle tests, but no shrinking
property-based state-machine suite yet. Do not describe that coverage as complete.

Next: generate valid states and action sequences, shrink actions while retaining
input invariants, and compare incremental scores, margins and best retention
against independently rebuilt state after every action. Resets/objective changes
start new oracle epochs. Q29 generators must preserve the energy shell; arbitrary
array shrinking would invalidate the test inputs. Keep minimized failures as
permanent regressions, and keep performance gates separate from these properties.

## Closeout and mystery ledger

- Settled: the related retention defects and the carrier scorer's arithmetic
  range proof, including enforcement of its raw-input preconditions.
- Reusable opportunity: certified range analysis can guide representation width
  in other kernels or generated code. No general compiler pass was added here;
  each application still needs a range proof and retained measurements.
- Open: original code-layout penalty, Q29's small parallel cost increase and
  Phase Full variability. No address padding or benchmark-specific dispatch kept.
- Open: shrinking state-machine coverage; this is the next correctness gate.
- Search frontier unchanged: all 252 distinct performance input/policy best
  scores match the control. The roughly 14,800 known-containing-fibre recovery
  gate and the order-2092 construction remain open; no quality gain is claimed.
