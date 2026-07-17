# C201 mechanism-audit notebook (legacy discovery-track filename)

**Date opened:** 2026-07-16
**Lane:** `relconic`
**Classification:** task-work notebook, not a discovery track under the normalized
[discovery-track conventions](discovery-track-conventions.md). This file substantially records the
bounded mechanism gates C201 was designed to test, including negative results and closure
dispositions. It is retained at its existing path for stable links. The authoritative deliverables
remain the C201 reports and handoff; do not append new planned work here. Confidence tags are
`CHECKED`, `REASONED`, and `OPEN`.

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

- **The last cheap stronger neighborhood is closed (`CHECKED`).**  From the
  best 805 witness, retain each of its six orbit
  pairs in turn and scan all 730,380 compatible replacement pairs, rejecting
  candidates by the exact pair and ternary bitsets before coverage evaluation.
  This complete two-orbit neighborhood is millions of indexed tests rather
  than billions of quadruples.  No replacement improves 805, so the witness is
  both one- and two-orbit locally optimal.  **Question:** should a three-orbit
  neighborhood be attempted?  **Disposition:** no; it returns to hundreds of
  millions of candidates and no longer qualifies as a cheap bounded gate.  Do
  not confuse local optimality with global family enumeration.

## 2026-07-16 — closure disposition

- **The quadratic mechanism was not itself falsified (`REASONED from checked
  gates`).**  The bounded `q=64` routes fail earlier: their secants do not
  approach the required saturation.  Full rank in the Baer family is trivial
  from the size of its uncovered locus, while the torus and split-`Z3` routes
  never reach the `|U|<=65` prefilter.  **Question:** should future rank work
  begin only after a construction passes a coverage threshold?  **Disposition:**
  yes; record “coverage first, rank second” as design guidance for C210, not as
  a theorem.

- **The negative result has an asymmetric consequence for follow-ons
  (`REASONED`).**  C209 needs stable rank/defect data and therefore remains
  gated, whereas C210 can still use the failure modes to reject low-coverage
  symmetric constructions cheaply.  **Disposition:** C209 dormant; C210 may
  import only the bounded obstruction and explicit claim boundary.
