import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Applications.ProjectiveProductMultiplicity
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.BirationalDeduction

/-!
# The framed-monodromy route to one-step irrationality

The manuscript's framed proof that the product of a smooth cubic threefold with
a projective line is not rational runs as follows.  The product formula gives
the framed sixth-root count four for that product and zero for projective
four-space; birational invariance of the count in dimension at most four then
excludes rationality, since a rational fourfold is birational to projective
four-space.

This module assembles that route on the product-formula signature.  Three
numerical facts that the earlier assembly of this route assumed are now derived
instead: the count of the cubic threefold, which comes from the small even block
reduction; the doubling of the count under multiplication by a projective line;
and the vanishing of the count on projective four-space.  What remains supplied
is the product formula itself, involutivity of the framed monodromy of a point,
the passage from the exponents of the reduced small even system to framed formal
monodromy, weak factorization with vanishing center contributions in the form of
the birational input, the dimension bound on the stabilized fourfold, and the
birational comparison furnished by rationality.

Lean constructs no variety, product, projective space, quantum connection, or
framed monodromy, and proves none of the cited comparison theorems.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace Applications

variable {Variety : Type*}

/-- Packet data assembled from the product-formula signature, a supplied
dimension function, and the framed sixth-root count.  The two bundle fields
record the trivial projective bundle of a supplied fibre rank, that is, the
product with the projective space of dimension one less; only fibre rank two
occurs in the deduction below. -/
noncomputable def framedProductPacketData (geometry : ProjectiveProductGeometry Variety)
    (dimension : Variety → ℕ) : Quantum.PacketData Variety where
  multiplicity object := (geometry.framedMonodromy object).sixthMultiplicity
  dimension := dimension
  productProjective base rank :=
    geometry.productWithProjectiveSpace base (rank - 1)
  projectiveBundle base rank :=
    geometry.productWithProjectiveSpace base (rank - 1)

/-- The framed route to one-step irrationality of a smooth cubic threefold.
The count two for the cubic, its doubling under multiplication by a projective
line, and the vanishing of the count on projective four-space are all proved
here; the product formula, the point comparison, the exponent-to-monodromy
passage, the birational input, the dimension bound, and the birational
comparison supplied by rationality remain premises. -/
theorem cubicThreefold_oneStep_not_rational_of_framed_product_inputs
    (geometry : ProjectiveProductGeometry Variety)
    (input : ProjectiveProductInput geometry)
    (dimension : Variety → ℕ)
    (birationalInput :
      Quantum.DimensionFourBirationalInput (framedProductPacketData geometry dimension))
    (Rational : Variety → Prop)
    (exponentMonodromy : ∀ cubic, geometry.isSmoothCubicThreefold cubic →
      ∀ firstExponent secondExponent : ℚ,
        Quantum.cubicIndicialPolynomial =
            (Polynomial.X - Polynomial.C firstExponent) *
              (Polynomial.X - Polynomial.C secondExponent) →
          (geometry.framedMonodromy cubic).operator.charpoly =
            (Polynomial.X -
                Polynomial.C
                  (Complex.exp (2 * (Real.pi : ℂ) * Complex.I * (firstExponent : ℂ)))) *
              (Polynomial.X -
                Polynomial.C
                  (Complex.exp (2 * (Real.pi : ℂ) * Complex.I * (secondExponent : ℂ)))) *
                (Polynomial.X - Polynomial.C 1) ^ 2)
    {cubic : Variety} (smooth : geometry.isSmoothCubicThreefold cubic)
    (stabilizedDimension :
      dimension (geometry.productWithProjectiveSpace cubic 1) ≤ 4)
    (rationalComparison : Rational (geometry.productWithProjectiveSpace cubic 1) →
      birationalInput.birational (geometry.productWithProjectiveSpace cubic 1)
        (geometry.projectiveSpace 4)) :
    ¬ Rational (geometry.productWithProjectiveSpace cubic 1) := by
  have cubicCount : (geometry.framedMonodromy cubic).sixthMultiplicity = 2 :=
    cubicPacket_sixthMultiplicity_eq_two_of_block_exponents
      geometry.toCubicPacketGeometry exponentMonodromy cubic smooth
  refine Quantum.rankTwoStabilization_not_rational
    (framedProductPacketData geometry dimension) birationalInput Rational
    (base := cubic) ?_ stabilizedDimension ?_ ?_ rationalComparison
  · show (geometry.framedMonodromy
        (geometry.productWithProjectiveSpace cubic 1)).sixthMultiplicity =
      2 * (geometry.framedMonodromy cubic).sixthMultiplicity
    simpa using input.productFormula cubic 1
  · show (geometry.framedMonodromy cubic).sixthMultiplicity ≠ 0
    rw [cubicCount]
    omega
  · show (geometry.framedMonodromy (geometry.projectiveSpace 4)).sixthMultiplicity = 0
    exact projectiveSpace_sixthMultiplicity_eq_zero geometry input 4

end Applications

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
