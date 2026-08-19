import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Applications.CubicPacketFormula
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.RankTwoClusterGermRigidity
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.SimpleEulerBlock

/-!
# Persistence of the cubic packet over the formal even bulk germ

At the small hyperplane point of a smooth cubic threefold, after extending the
Novikov coefficient field so that the square root of three times the line
variable is a unit, Euler multiplication on the small even quantum connection has
three clusters: two of rank one at the two nonzero eigenvalues, and one of rank
two at the eigenvalue zero, whose nilpotent part is a single nonzero Jordan
block.  The primitive-sixth multiplicity is two at that point.

This module assembles the deduction that the multiplicity stays two over the
whole formal germ from three inputs, each of which is the conclusion of a
statement proved elsewhere in the package.  The framed characteristic polynomial
at every point of the germ splits as the polynomial of the exponents of the
rank-two cluster times a power of `X - 1` contributed by the rank-one clusters;
the exponent polynomial of the rank-two cluster does not vary over the germ;
and at the closed point the framed characteristic polynomial is the displayed
four-factor polynomial of the cubic packet.

Primitive-sixth multiplicity is additive over the factorization, the unit power
contributes nothing, and the rank-two factor is the same polynomial at every
point as at the closed point, where the multiplicity is two.

The germ itself is not constructed: its points are an arbitrary type with a
distinguished element, and the assignment of a framed monodromy matrix and a
multiset of exponents to a point is data.  Rigidity of that multiset is the
matrix statement proved for a formal power-series germ in
`TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.RankTwoClusterGermRigidity`,
whose identification with this exponent assignment is not formalized; the unit
contribution of a rank-one cluster is the spectral statement proved in
`TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.SimpleEulerBlock`.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Applications

open Polynomial

/-- Framed spectral data of the small even quantum connection of a smooth cubic
threefold over a formal even bulk germ.  A point of the germ carries a framed
formal-monodromy matrix and the multiset of formal exponents of the rank-two
zero cluster; `simpleClusterRank` is the total rank of the clusters at the
nonzero Euler eigenvalues. -/
structure CubicFormalGermPacket (Point : Type*) where
  /-- The closed point of the formal germ, that is, the small hyperplane point. -/
  closedPoint : Point
  /-- Framed formal monodromy of the small even connection at a point of the
  germ. -/
  framedMonodromy : Point → Quantum.FramedMonodromyMatrix
  /-- Formal exponents of the rank-two zero cluster at a point of the germ. -/
  zeroClusterExponents : Point → Multiset ℂ
  /-- Total rank of the clusters at the nonzero Euler eigenvalues. -/
  simpleClusterRank : ℕ

/-- Persistence of the cubic packet over the formal even bulk germ.  Given the
splitting of the framed characteristic polynomial into the exponential
polynomial of the rank-two zero cluster and the unit power contributed by the
rank-one clusters, rigidity of the zero cluster's exponent polynomial over the
germ, and the displayed cubic packet polynomial at the closed point, the
primitive-sixth multiplicity equals two at every point of the germ. -/
theorem cubicFormalGerm_sixthMultiplicity_eq_two
    {Point : Type*} (germ : CubicFormalGermPacket Point)
    (factorization : ∀ point,
      (germ.framedMonodromy point).operator.charpoly
        = Quantum.splitMonicPolynomial
            ((germ.zeroClusterExponents point).map Quantum.framedEigenvalue)
          * (X - C (1 : ℂ)) ^ germ.simpleClusterRank)
    (rigidity : ∀ point,
      Quantum.splitMonicPolynomial (germ.zeroClusterExponents point)
        = Quantum.splitMonicPolynomial (germ.zeroClusterExponents germ.closedPoint))
    (closedPointPacket :
      (germ.framedMonodromy germ.closedPoint).operator.charpoly
        = cubicPacketCharacteristicPolynomial) :
    ∀ point, (germ.framedMonodromy point).sixthMultiplicity = 2 := by
  have unitNonzero : ((X - C (1 : ℂ)) ^ germ.simpleClusterRank) ≠ 0 :=
    pow_ne_zero _ (Polynomial.monic_X_sub_C (1 : ℂ)).ne_zero
  have blockCount : ∀ point,
      (germ.framedMonodromy point).sixthMultiplicity
        = Quantum.sixthMultiplicityPolynomial
          (Quantum.splitMonicPolynomial
            ((germ.zeroClusterExponents point).map Quantum.framedEigenvalue)) := by
    intro point
    change Quantum.sixthMultiplicityPolynomial
      (germ.framedMonodromy point).operator.charpoly = _
    rw [factorization point,
      Quantum.sixthMultiplicityPolynomial_mul
        (Quantum.splitMonicPolynomial_ne_zero _) unitNonzero,
      Quantum.sixthMultiplicityPolynomial_unitPower_eq_zero, add_zero]
  have closedCount :
      Quantum.sixthMultiplicityPolynomial
          (Quantum.splitMonicPolynomial
            ((germ.zeroClusterExponents germ.closedPoint).map Quantum.framedEigenvalue))
        = 2 := by
    rw [← blockCount germ.closedPoint]
    change Quantum.sixthMultiplicityPolynomial
      (germ.framedMonodromy germ.closedPoint).operator.charpoly = 2
    rw [closedPointPacket]
    exact cubicPacketCharacteristicPolynomial_sixthMultiplicity
  intro point
  rw [blockCount point,
    Quantum.sixthMultiplicity_eq_of_exponent_polynomial_eq (rigidity point), closedCount]

end Applications

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
