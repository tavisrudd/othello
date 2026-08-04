# C855 — formalizing the Dye triple-point bound and retiring the first Dye axiom

**Date:** 2026-08-04
**Lane:** `clebsch` (Paper I stream)
**Task:** C855, checklist item "Eliminate the two ad hoc Dye axioms".
**Plan:** `notes/2026-08-04-c855-dye-axiom-elimination-plan.md`.

## What landed

Two new Lean modules formalize the ten-point bound of the Paper I Dye boundary, following the
paper-grade proof in `notes/2026-08-03-c855-structural-exclusions.md`. The proof is uniform in the
field: it holds in the projective plane over any finite field in which two is invertible, not only
at order eleven.

`lean/RelativeConicArcs/QuadrangleDiagonal.lean` proves
`RelativeConicArcs.QuadrangleDiagonal.not_collinear_diagonalPoints`: the three diagonal points of a
complete quadrangle are not collinear when two is invertible. A diagonal point is described by the
two collinearity conditions that define it rather than by a construction, so the statement applies
to any point lying on both of a pair of opposite sides. The proof normalizes the quadrangle through
the existing four-point normal form, in which scaled representatives of three of its points form a
basis whose coordinate sum represents the fourth; the three diagonal points are then represented by
the three pairwise sums of the basis vectors, and those are independent exactly when two is
invertible. In characteristic two they are dependent, which is the Fano configuration.

`lean/RelativeConicArcs/SixArcConcurrence.lean` develops the incidence side, for an arbitrary
projective plane in Mathlib's configuration vocabulary and with no coordinates:

- `triplePoints`, the off-arc points lying on three secants of the arc;
- `exists_pair_through`, that through such a point every arc point of a six-arc has a joining
  secant, because the three chords through the point partition the six arc points;
- `exists_partner_off_secant`, the same statement relative to a fixed secant, with the partner
  again off that secant;
- `not_collinear_common_chord`, that two distinct triple-concurrence points on a secant cannot
  share a chord, since the shared chord would then meet the secant twice;
- `collinear_complement`, that once one chord of such a point is known, its remaining chord joins
  the two remaining arc points off the secant; and
- `card_triplePoints_le_ten_of_secant_bound`, the incidence count: a six-arc has fifteen secants
  and each triple-concurrence point lies on three of them, so a bound of two such points per secant
  bounds their number by ten.

`lean/RelativeConicArcs/SixArcConcurrenceBound.lean` supplies the missing per-secant bound in the
coordinate plane and concludes `card_triplePoints_le_ten`. A third triple-concurrence point on a
secant would give the quadrangle off that secant a third pairing, making all three of its diagonal
points collinear on that secant.

`lean/RelativeConicArcs/Q11DyeAxioms.lean` now derives `dye1991_brianchon_bound` from that general
theorem instead of declaring it. The statement is unchanged, so its consumers in
`Q11DyeConsequences` and `Q11RigiditySpine` are untouched.

## Validation state

`QuadrangleDiagonal` and `SixArcConcurrence` elaborate cleanly through the guarded single-file
entry point, and the quadrangle theorem's axiom print shows only `propext`, `Classical.choice`, and
`Quot.sound`. Single-file elaboration against last-built dependencies is a smoke test, not a gate.

`SixArcConcurrenceBound` and the rewritten `Q11DyeAxioms` are written but not yet elaborated: they
import a module that has no compiled artifact, and compiling one requires the build window, which
the order-16 certificate cold fill currently holds. The gate
`RelativeConicArcs.Gates.ClebschRigidityTrust` and its axiom audit are the acceptance evidence and
run in that window.

## What remains for the second axiom

`dye1991_equality_classification` is still declared. Its paper-grade proof is in
`notes/2026-08-03-c855-dye-orbit-uniqueness.md`, and formalizing it needs the concurrence relation
on the six one-factorizations, the double-perspective identity that makes it transitive, the
resulting five-plus-one partition at equality, the golden normal form, and the finite check that
the order-eleven normal form is projectively the displayed witness. That is a substantially larger
piece of work than the bound.
