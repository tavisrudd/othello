# C223 — Formal closure of the remaining arcs-paper claims

**Date:** 2026-07-16
**Lane:** `relconic`
**Status:** REPORTED 2026-07-16

## Goal

Close the remaining mathematical seams between the manuscript's original claims and the
`RelativeConicArcs` Lean theorem graph, without a new search or a new large generated certificate.

## Work packages

1. **q=5 coordinate transport.**  Kernel-check the invertible matrix carrying the displayed C187
   frame conic to the standard model and its action on the four frame points.
2. **q=16 profile.**  Prove from the existing `rejectedLeaves` data that the 2,633 leaves split as
   2,630 full-rank and three forced-hit certificates.  Use one direct aggregate reduction attempt;
   if it is not resource-cheap, stop rather than generate hundreds of count leaves.
3. **q=16 exceptional arithmetic.**  Check the two displayed factorizations and the seven-point
   incidence description using small concrete-field lemmas only.
4. **Global q=16 quadratic avoidance.**  Compose the existing arbitrary-eight-arc normalization,
   canonical-leaf quadratic avoidance, and symbolic pullback of an arbitrary homogeneous
   quadratic under a projectivity.
5. **q=11 non-GRS.**  Formalize the local normal-rational-curve/conic implication needed to turn
   the existing no-quadratic theorem into the manuscript's projectively non-GRS conclusion; avoid
   building a general coding-theory library.

## Completion gate

- every promoted theorem passes guarded elaboration and `#print axioms` with only the accepted
  Mathlib foundations;
- no new generated search data or native evaluator is introduced;
- the result registry, TRUST manifest, proof audit, manuscript verification table, and PDF agree;
- the focused Lean targets and publication rebuild pass; and
- task-owned changes are committed without staging foreign queue or build work.

## Implemented declarations

- `Q5.lean`: invertible displayed-frame matrix, conic pullback, and all four frame images.
- `Q16Profile.lean`: `rejection_profile` proves the exact `2633 = 2630 + 3` split.
- `Q16ExceptionalArithmetic.lean`: the two split factorizations, hit counts `(2,7,2)`, middle
  zero count `17`, and an explicit nonsingular-conic coordinate model.
- `Q16QuadraticTransport.lean`: arbitrary coefficient pullback, evaluation compatibility,
  preservation of nonzeroness, and the arbitrary-eight-arc classification chain.
- `Q11NonGRS.lean`: contradiction from the NRC/GRS nonzero-quadratic consequence, with the
  classical dictionary kept as an explicit premise.

Follow-up hardening links the three displayed exceptional forms to the exact generated
forced-hit records, proves their kernels are precisely the displayed one-dimensional lines, and
adds the end-to-end theorem `arbitrary_eight_arc_projectiveQuadraticAvoidance`.

## Validation

- Every focused module passes `guarded-lean`; printed axiom sets contain only
  `propext`, `Classical.choice`, and `Quot.sound`.
- Queue run `20260716-195041-728e8203` built `RelativeConicArcs.Results` and passed its aggregate
  trace gate (1:28 wall, 7,205,476 kB peak).
- `make arcs` succeeds; there are no undefined references/citations or overfull boxes.
