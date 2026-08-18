import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Applications.CubicPacketFormula
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.CubicSmallEvenBlockReduction

/-!
# The cubic packet from the small even block reduction

The primitive-sixth multiplicity of a smooth cubic threefold was previously
derived from a supplied characteristic polynomial for its framed formal
monodromy.  This module replaces that premise by the weaker one that framed
monodromy is the one-turn exponential of the exponents of the reduced system:
the two exponents of the modified rank-two zero block, and the two unit
factors coming from the rank-one blocks at the nonzero Euler eigenvalues.

Which exponents those are is no longer assumed.  They are the roots of the
characteristic polynomial of the residue of the canonical elementary
modification, and that residue, its trace `-1`, and its determinant `5 / 36`
are computed in
`TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.CubicSmallEvenBlockReduction`
from the displayed small even connection matrices by exact matrix arithmetic.

What remains external is the passage from a regular-singular residue to framed
formal monodromy, which is the content of the supplied premise.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Applications

open Polynomial

/-- Primitive-sixth multiplicity of a smooth cubic threefold, from the exponents
of the reduced small even system.  The premise supplies only that framed
monodromy has the characteristic polynomial obtained by exponentiating the two
exponents of the rank-two block and adjoining two unit factors; which exponents
occur is proved from the block reduction. -/
theorem cubicPacket_sixthMultiplicity_eq_two_of_block_exponents
    {Cubic : Type*} (geometry : CubicPacketGeometry Cubic)
    (exponentMonodromy : ∀ cubic, geometry.isSmoothCubicThreefold cubic →
      ∀ firstExponent secondExponent : ℚ,
        Quantum.cubicIndicialPolynomial =
            (X - C firstExponent) * (X - C secondExponent) →
          (geometry.framedMonodromy cubic).operator.charpoly =
            (X - C (Complex.exp (2 * (Real.pi : ℂ) * Complex.I * (firstExponent : ℂ)))) *
              (X - C (Complex.exp (2 * (Real.pi : ℂ) * Complex.I * (secondExponent : ℂ)))) *
                (X - C 1) ^ 2) :
    ∀ cubic, geometry.isSmoothCubicThreefold cubic →
      (geometry.framedMonodromy cubic).sixthMultiplicity = 2 := by
  refine cubicThreefold_sixthMultiplicity_eq_two_of_charpoly geometry ?_
  intro cubic smooth
  have supplied := exponentMonodromy cubic smooth (-1 / 6) (-5 / 6)
    Quantum.cubicIndicialPolynomial_factorization
  have castFirst : ((-1 / 6 : ℚ) : ℂ) = (-1 / 6 : ℂ) := by norm_num
  have castSecond : ((-5 / 6 : ℚ) : ℂ) = (-5 / 6 : ℂ) := by norm_num
  rw [supplied, castFirst, castSecond, Quantum.cubicExponent_neg_one_sixth,
    Quantum.cubicExponent_neg_five_sixths]
  unfold cubicPacketCharacteristicPolynomial
  ring

end Applications

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
