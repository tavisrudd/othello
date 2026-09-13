# C1154 — offline FeatureDag intervals and identity acyclicity

**Lane**: `ergodis`
**Date**: 2026-09-12
**Status**: COMPLETE. Private implementation/evidence commit `89f7ccf`.

Implemented the queued offline slice: one bounded topological interval pass,
separate successful-value/error propagation, and an exact weak-term dependency
graph for the current directed identity inventory. Production evaluation,
simplification and admission are unchanged. No runtime dependency was added.

The implementation, complete contract, replay commands, receipts and post-gate
review are in `ergodis-private/analysis/feature-interval/README.md`.
The shared kernel is `ergodis-private/src/feature_interval.rs`; its fixed audit
is exposed through the existing `ergodis-tools feature-interval-audit` command.

## Gate results

- Original C1082 corpus: 1,984 rows × 10 selected roots = 19,840 checks;
  zero missed overflow/value outcomes and no conservative warnings.
- Overflow-boundary singleton cases: 3,630 checks, 1,404 actual errors;
  zero missed errors, false positives, value misses or false-empty results.
- Fully enumerated small boxes: 1,210 root/box cases, 584 boxes containing
  errors; zero missed errors or false positives. The separate five-integer
  correlation box has one conservative false positive and no missed value.
- There are 28,835 concrete evaluations inside box checks. These are finite
  conformance results, not a general compiler proof. The comparison uses the
  existing scalar VM/lowering boundary tied to C1082's primitive oracle.
- Twenty directed identities produce 23 labeled ordinary edges and no special
  edges: the finite syntax inventory passes Definition 45 weak term acyclicity.
  Checked constant-folding callbacks and dynamic literal computations remain
  outside that syntactic theorem. No confluence or canonical-form claim follows.
- Seven interval integration tests and all 11 frontend regression tests pass;
  strict private-library/test Clippy passes. The interval test observes zero
  allocations over 100 prepared full-box analyses. Native audit JSON replays
  exactly and 16 source/artifact SHA-256 entries verify. No speed claim is made.

## Post-gate ej + tt / Mystery ledger

1. **Settled — selected-root error erasure.** The actual simplifier retains a
   square in whole-DAG evaluation, but lowering only the simplified root of
   `(x*x)*0` hides square overflow. The regression demonstrates both contracts.
   Interval safety permits discarding on [-100,100] and refuses to certify FULL.
   C1157 must preserve this error-domain obligation under merging/extraction.
2. **Settled — ordinary cycles are harmless for this criterion.** Constructor
   commutativity introduces ordinary graph cycles. The checker separately tests
   a special-edge cycle and an already-present nested subpattern.
3. **Open precision boundary.** Independent intervals lose correlation for
   `x+(MAX-x)`. The five-value exhaustive control records the exact false positive.
   A richer domain needs a workload showing that this precision loss matters.
4. **Open adoption gate.** This is private offline machinery. Any production
   use must bind input boxes to admitted scope; possible overflow is a warning,
   never an automatic rejection. Lean proof coverage and saturation integration
   are not claimed by the finite audit.

These were targeted task findings; no incidental discovery entry was warranted.
The continuation now moves to already allocated C1159 under the user's lane-wide
2-hour authorization. C1170 remains at its validated, explicitly partial frontend
checkpoint. Original continuation deadline: 2026-09-13 07:24:50 UTC.
