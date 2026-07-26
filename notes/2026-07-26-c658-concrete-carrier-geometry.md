# C658 concrete projective carrier geometry

**Lane:** `relconic`

## Result

The rank-three square-root carrier argument now has a coordinate-chart
formalization from projective incidence through the cardinality bound.

For a homogeneous parametrization \(M:K^2\to K^3\), Lean defines its normal
as the cross product of its two columns and proves

\[
 \det(AM,BM)=\det(\operatorname{normal}(M),A,B).
\]

If \(\operatorname{normal}(M)=\lambda x\), with \(\lambda\ne0\), then
noncollinearity of \(x,A,B\) makes the two restricted binary factors
relatively prime.  For a carrier family, distinctness supplies nonzero
restricted line equations and no-three-collinearity supplies all pairwise
restricted determinants.

The canonical binary zero of the equation of a second carrier line maps to
an exact plane representative of the intersection.  A coordinate chart on
the second line recovers a binary preimage of that same vector.  Hence the
two ambient restrictions are compared at literally equal plane vectors;
there is no untracked projective transition scalar.

These facts discharge the divisibility premise in the interpolation
induction.  If an ambient homogeneous form restricts to \(g_x^2\) on every
charted carrier line, the product of all preceding line equations divides
the next residual.  Ordinary quotient-lift correction gives a plane
polynomial correction.

The correction initially need not be homogeneous.  Lean proves that
line restriction commutes with extraction of a homogeneous component.
Replacing each correction by its degree-\(m\) component therefore preserves
all old zero restrictions and the new prescribed restriction.  The
induction produces one homogeneous degree-\(m\) ambient form \(G\) with
\(G|_{L_x}=g_x\) on the whole finite carrier family.

Finally, if the original ambient form \(F\) is homogeneous of degree \(2m\)
and is not a square, then

\[
 \boxed{\lvert Y\rvert\le 2m}
\]

for every finite charted carrier family \(Y\) satisfying the displayed
distinctness and no-three-collinearity hypotheses.  This is the formal
rank-three carrier inequality from the C626 argument.

## Coordinate-chart interface

`RelativeConicArcs.PlaneLineCoordinateChart` records:

- a nonzero plane representative for the carrier center;
- a homogeneous \(3\times2\) line parametrization;
- the nonzero scalar relating its column cross product to the center;
- coordinate functionals which are a left inverse to the parametrization;
- exact reconstruction of every incident plane vector; and
- the principal-kernel identity saying restriction vanishes exactly on
  multiples of the line equation.

The coordinate functionals lift every binary polynomial to a plane
polynomial, and Lean proves that this lift is a right inverse to restriction.
Thus both point-level exact preimages and polynomial-level surjectivity are
part of one checkable chart object.

## Main Lean declarations

The new module `RelativeConicArcs.ProjectiveCarrierGeometry` contains:

- `binaryLinearCoefficientDeterminant_restrictions_eq_planeVectorDeterminant_normal`;
- `pairwise_restrictedDeterminant_ne_zero_of_normal_eq_scale`;
- `planeLineRestriction_center_eq_zero_of_normal_eq_scale`;
- `exists_binaryPreimage_of_restrictedCovectorProjectiveZero`;
- `MvPolynomial.IsHomogeneous.planeLineRestriction`;
- `planeLineRestriction_homogeneousComponent`;
- `PlaneLineCoordinateChart.planeLineRestriction_surjective`;
- `PlaneLineCoordinateChart.lineEquation_isRelPrime_of_restricted_ne_zero`;
- `planeLineRestriction_finsetLineProduct_dvd_root_sub_restriction`;
- `exists_finset_homogeneous_carrierRoot_extension_of_coordinateCharts`;
- `card_le_two_mul_degree_of_coordinateCharts_carrierRoots`; and
- `fintype_card_le_two_mul_degree_of_coordinateCharts_carrierRoots`.

The finite-type terminal imposes hypotheses only on the indexed carrier
family; it does not require a surrounding ambient point type with global
incidence conditions.

## Formal boundary

Lean checks the complete implication from charted carrier data to the
\(2m\) bound.  It does not construct the chart family from mathlib
projectivization, identify an arbitrary projective arc's representative
product with the ambient dual Chow form, or prove the square-restriction
criterion for maximum-index centers.  Those are the remaining
projectivization-to-coordinate and arc-to-Chow correspondence statements,
not gaps in the carrier interpolation or detection argument.

No manuscript file was edited.  The theorem is suitable for the paper only
when those correspondence statements are supplied in the paper's chosen
projective formalism.

## Verification

- Warning-free single-file elaboration of
  `RelativeConicArcs/ProjectiveCarrierGeometry.lean`: **PASS**.
- Exact build of
  `RelativeConicArcs.Gates.ProjectiveCarrierGeometry`: **PASS**,
  6.84 seconds, maximum resident set size 1,391,640 KiB.
- Exact-current trace-only aggregate replay: **PASS**.
- The gate audits eighteen public terminals.  The audited declarations use
  only `propext`, `Classical.choice`, and `Quot.sound`.

## Extra-juice and Tao closeout

The main closeout gain is the homogeneous-component projection.  A direct
attempt to prove that every quotient in the interpolation induction is
homogeneous would require unnecessary graded-factor algebra.  Projecting an
ordinary correction to degree \(m\) is enough because restriction preserves
the grading.  This both shortens the proof and strengthens the reusable API:
any surjective chart restriction now yields degree-preserving interpolation.

The finite-type corollary removes another artificial degree of freedom.
Every incidence hypothesis is now quantified only over the carrier family
being bounded.

## Mystery ledger

- **Settled — determinant nonvanishing.**  It is exactly the plane
  noncollinearity determinant multiplied by the nonzero chart-normal scalar.
- **Settled — transition scalars.**  Exact reconstruction in the coordinate
  chart chooses binary preimages of one equal plane intersection vector.
- **Settled — degree preservation.**  Homogeneous-component projection turns
  arbitrary quotient-lift corrections into degree-\(m\) corrections without
  changing any required restriction.
- **Settled — interpolation/detection connection.**  The charted roots extend
  homogeneously, and line-product detection plus nonsquareness gives the
  \(2m\) bound.
- **Open — projectivization bridge.**  The exact `Projectivization` points and
  dual lines used by the arc model must be equipped with these coordinate
  charts.
- **Open — dual Chow correspondence.**  The representative product,
  maximum-index square criterion, and nonsquareness hypotheses must be
  connected to the concrete arc data.

No unexplained algebraic freedom remains inside the charted carrier theorem.
