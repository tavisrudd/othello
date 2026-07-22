# C482 — multi-centre gauge synchronization

**Lane:** `reed-solomon`

## Entry gate

C481 identifies every syndrome fibre with an abstract projected sextic and fixes the diagonal
support and Frobenius actions.

## Exact domain

Two, three, or four distinct deepest centres of one six-arc, with one diagonal `S6`
correspondence and an independent `PGL_2` gauge on each quotient line.  Work over an arbitrary
finite field and retain characteristic-two formulas.  Import the generic-degree obstruction in
`notes/2026-07-22-c482-generic-degree-preflight.md`.

## Target

Prove that two and three abstract coherent projections have generic residual dimensions two and
one, then derive the simultaneous compatibility equations and an explicit rational reconstruction
map from four coherently matched projected sextics to the parent-centre configuration on a stated
nondegenerate open locus.

## Work package

1. Choose gauge-free variables for the quotient-line `PGL_2` identifications.
2. Express the condition that corresponding projection rays meet in six common ambient points.
3. Prove the exact generic differential ranks for two, three, and four centres in every
   characteristic, including separability rather than relying only on the preflight witnesses.
4. Eliminate the four fibre gauges, produce a rational inverse, and isolate every denominator/minor
   used by the inverse.
5. Prove uniqueness modulo ambient projectivity and one diagonal `S6`; describe the exact
   two- and three-centre residual families.

## Acceptance

A theorem and replayable symbolic identity package proving the four-centre inverse on an explicit
open locus, with the positive-dimensional two/three-centre fibres and all excluded factors
recorded for C483.  Report:
`notes/2026-07-22-c482-three-centre-synchronization.md`.

## Boundaries

Do not classify the excluded divisor, claim an all-field global theorem, or import modular
language.
