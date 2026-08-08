import RelativeConicArcs.FaceAxisHarmonicGram

/-!
# Cubic restriction of the icosahedral degree-six field

The normalized mean in this module is the explicitly defined polynomial
functional of `RelativeConicArcs.SphericalMomentFunctional`; no statement here
is a statement about a surface integral.  The symmetric tetrahedral harmonic
below is written in the squared coordinate variables.  Its cubic moment is one
of the two explicit degree-eighteen evaluations needed for the restriction of
the icosahedral cubic to the sum-zero five-label module.
-/

namespace RelativeConicArcs.SphericalCubicRestriction

open MvPolynomial
open RelativeConicArcs.SphericalMomentFunctional

/-- The square of the `i`-th coordinate variable. -/
noncomputable def squaredCoordinate (i : Fin 3) : MvPolynomial (Fin 3) ℝ := X i ^ 2

/-- The coordinate-transposition-even tetrahedral harmonic in the squared
variables `u = x₀²`, `v = x₁²`, and `w = x₂²`:
`u³ + v³ + w³ - (15/2)Σ_sym u²v + 90uvw`. -/
noncomputable def tetrahedralEvenHarmonic : MvPolynomial (Fin 3) ℝ :=
  let u := squaredCoordinate 0
  let v := squaredCoordinate 1
  let w := squaredCoordinate 2
  u ^ 3 + v ^ 3 + w ^ 3 - C (15 / 2) *
    (u ^ 2 * v + v ^ 2 * w + w ^ 2 * u + u * v ^ 2 + v * w ^ 2 + w * u ^ 2) +
    C 90 * (u * v * w)

/-- The normalized degree-eighteen moment of the cube of the even tetrahedral
harmonic is `-1280/46189`.  The proof expands its fifty-five monomials and
applies the defining Gaussian monomial moment formula. -/
theorem normalizedMean_tetrahedralEvenHarmonic_cube :
    normalizedMean 18 (tetrahedralEvenHarmonic ^ 3) = -1280 / 46189 := by
  rw [normalizedMean]
  norm_num [tetrahedralEvenHarmonic, squaredCoordinate, gaussianMoment, momentWeight,
    momentFactor]

end RelativeConicArcs.SphericalCubicRestriction
