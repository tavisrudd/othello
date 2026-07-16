# C201 discovery track

**Date opened:** 2026-07-16
**Lane:** `relconic`
**Context:** incidental observations, surprises, failed intuitions, and follow-on
questions noticed while executing C201.  This append-only log is not the task
queue or proof ledger.  Planned deliverables remain in the C201 reports and
handoff.  Confidence tags are `CHECKED`, `REASONED`, and `OPEN`.

## 2026-07-16 — split-`Z3` indexing and coverage probe

- **The nine-factor determinant norm is more useful as incidence data than as
  a factored polynomial (`CHECKED`).**  For a compatible orbit pair, `F=0` is
  exactly membership of the third orbit label in the union of nine mixed
  secants.  A 1,302-bit pair index therefore replaces symbolic evaluation by
  one lookup.  **Question:** does this pair-indexed ternary relation form a
  recognizable coherent configuration or low-rank association scheme?
  **Disposition:** follow-on only if its intersection numbers yield a certified
  coverage bound; do not pursue as taxonomy for its own sake.

- **The mixed-collinearity filter is unexpectedly sparse (`CHECKED`).**  Every
  one of the 730,380 compatible pairs forbids only 171--179 third labels, with
  mean 174.536228, about 13.4% of the 1,302 legal labels.  Thus the symbolic
  reduction makes each test cheap but does not make quadruple enumeration
  small; the two desired effects point in opposite directions.  **Question:**
  can the narrow 171--179 range itself be derived from orbit intersection
  numbers?  **Disposition:** follow-on if it supports a bound, otherwise do
  not pursue.

- **Coverage, rather than mixed collinearity, is the visible obstruction
  (`CHECKED`, bounded evidence).**  In 100,000 accepted arc draws the best
  ordinary-uncovered size was 824, versus the necessary maximum 65.  Exact
  one-orbit descent from that incumbent improved it only to 805.  **Question:**
  is there a symmetry-forced lower bound on uncovered points for every
  nucleus-plus-four-orbit arc?  **Disposition:** answer in C201 only through a
  certified global bound; heuristic concentration is insufficient.

- **The value 805 recurs across distinct local basins (`CHECKED`, not a global
  claim).**  Nine of 500 deterministic restarts ended at 805, with several
  distinct label quadruples, while all local optima lay in 805--935.  This
  suggests either normalizer-related copies or a small number of coverage
  strata, but the current optimizer does not canonicalize under the
  normalizer.  **Question:** are the 805 witnesses one normalizer orbit, and
  does their shared coverage profile admit a structural explanation?
  **Disposition:** pursue only if a cheap normalizer check directly contributes
  to a global coverage certificate.

- **A natural initial intuition failed (`CHECKED`).**  Adding the conic nucleus
  removes the fixed-point obstruction that killed the order-13 torus family,
  but it does not bring the split-`Z3` unions remotely near relative
  completeness.  Clearing one uncovered fixed point is negligible compared
  with the hundreds of ordinary points left uncovered.  **Disposition:** use
  as the precise bounded-mechanism lesson; do not present it as an exhaustive
  theorem about the family.
