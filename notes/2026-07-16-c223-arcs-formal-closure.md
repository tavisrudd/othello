# C223 — Formal closure of the remaining arcs-paper claims

**Date:** 2026-07-16
**Lane:** `relconic`
**Status:** IN PROGRESS

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
