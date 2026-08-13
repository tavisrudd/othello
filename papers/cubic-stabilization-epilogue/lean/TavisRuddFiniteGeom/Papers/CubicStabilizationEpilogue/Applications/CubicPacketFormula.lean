import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.CubicPacket
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.LowDimensionalVanishingCore

/-!
# Primitive-sixth multiplicity of the cubic packet

This module isolates the exact deduction of the cubic packet from the
framed-monodromy characteristic polynomial supplied by the quantum comparison.
The two rank-one factors at eigenvalue one and the rank-two zero-exponential
factor with exponents `-1/6` and `-5/6` give the displayed four-factor
polynomial.  Lean proves that the two primitive sixth roots occur once each
and that the unit factors contribute nothing, hence the primitive-sixth
multiplicity is two.

The supplied polynomial identity is the consequence used in the manuscript
from J. Cai, *The cubic threefold is symplectically irrational*,
arXiv:2608.01577 (2026), Section 3 and Proposition 6.  Lean does not construct a cubic threefold, its numerical small
even quantum connection, Cai's integral-power loop-coordinate gauge, the
zero-exponential block, the two unit blocks, or their characteristic-polynomial
comparison.  It also does not prove that the cubic threefold's numerical curve
lattice has rank one or that passage to the manuscript's numerical-Novikov
convention preserves Cai's calculation.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Applications

/-- Geometric and framed-monodromy signature for smooth cubic threefolds. -/
structure CubicPacketGeometry (Cubic : Type*) where
  /-- Predicate selecting smooth complex cubic threefolds. -/
  isSmoothCubicThreefold : Cubic → Prop
  /-- Intrinsic framed formal monodromy of the numerical small even quantum
  connection. -/
  framedMonodromy : Cubic → Quantum.FramedMonodromyMatrix

/-- The characteristic polynomial supplied by Cai's four-block description:
one factor for each primitive-sixth eigenvalue and two unit factors. -/
noncomputable def cubicPacketCharacteristicPolynomial : Polynomial ℂ :=
  (Polynomial.X - Polynomial.C Quantum.primitiveSixthRootNegative) *
    (Polynomial.X - Polynomial.C Quantum.primitiveSixthRootPositive) *
      (Polynomial.X - Polynomial.C 1) ^ 2

/-- The positive and negative primitive sixth roots are distinct. -/
theorem primitiveSixthRootPositive_ne_negative :
    Quantum.primitiveSixthRootPositive ≠ Quantum.primitiveSixthRootNegative := by
  intro equality
  have productOne :
      Quantum.primitiveSixthRootPositive * Quantum.primitiveSixthRootNegative = 1 := by
    unfold Quantum.primitiveSixthRootPositive Quantum.primitiveSixthRootNegative
    rw [← Complex.exp_add]
    have exponentZero :
        Real.pi * Complex.I / 3 + -(Real.pi * Complex.I) / 3 = 0 := by ring
    rw [exponentZero, Complex.exp_zero]
  rw [equality] at productOne
  exact Quantum.primitiveSixthRoots_sq_ne_one.2 (by simpa [pow_two] using productOne)

/-- Each primitive sixth root occurs exactly once in the displayed cubic
packet characteristic polynomial. -/
theorem cubicPacketCharacteristicPolynomial_primitive_rootMultiplicities :
    cubicPacketCharacteristicPolynomial.rootMultiplicity
        Quantum.primitiveSixthRootPositive = 1 ∧
      cubicPacketCharacteristicPolynomial.rootMultiplicity
        Quantum.primitiveSixthRootNegative = 1 := by
  have positiveNeOne : Quantum.primitiveSixthRootPositive ≠ 1 := by
    intro equality
    have realEquality := congrArg Complex.re equality
    norm_num [Quantum.primitiveSixthRootPositive_re] at realEquality
  have negativeNeOne : Quantum.primitiveSixthRootNegative ≠ 1 := by
    intro equality
    have realEquality := congrArg Complex.re equality
    norm_num [Quantum.primitiveSixthRootNegative_re] at realEquality
  have distinct := primitiveSixthRootPositive_ne_negative
  have firstNonzero :
      Polynomial.X - Polynomial.C Quantum.primitiveSixthRootNegative ≠ 0 :=
    (Polynomial.monic_X_sub_C _).ne_zero
  have secondNonzero :
      Polynomial.X - Polynomial.C Quantum.primitiveSixthRootPositive ≠ 0 :=
    (Polynomial.monic_X_sub_C _).ne_zero
  have unitNonzero : (Polynomial.X - Polynomial.C (1 : ℂ)) ^ 2 ≠ 0 :=
    pow_ne_zero _ (Polynomial.monic_X_sub_C _).ne_zero
  have pairNonzero :
      (Polynomial.X - Polynomial.C Quantum.primitiveSixthRootNegative) *
          (Polynomial.X - Polynomial.C Quantum.primitiveSixthRootPositive) ≠ 0 :=
    mul_ne_zero firstNonzero secondNonzero
  have totalNonzero : cubicPacketCharacteristicPolynomial ≠ 0 := by
    unfold cubicPacketCharacteristicPolynomial
    exact mul_ne_zero pairNonzero unitNonzero
  have positiveUnitMultiplicity :
      Polynomial.rootMultiplicity Quantum.primitiveSixthRootPositive
          ((Polynomial.X - Polynomial.C (1 : ℂ)) ^ 2) = 0 := by
    apply Polynomial.rootMultiplicity_eq_zero
    have differenceNonzero : Quantum.primitiveSixthRootPositive - 1 ≠ 0 :=
      sub_ne_zero.mpr positiveNeOne
    simpa [Polynomial.IsRoot] using pow_ne_zero 2 differenceNonzero
  have negativeUnitMultiplicity :
      Polynomial.rootMultiplicity Quantum.primitiveSixthRootNegative
          ((Polynomial.X - Polynomial.C (1 : ℂ)) ^ 2) = 0 := by
    apply Polynomial.rootMultiplicity_eq_zero
    have differenceNonzero : Quantum.primitiveSixthRootNegative - 1 ≠ 0 :=
      sub_ne_zero.mpr negativeNeOne
    simpa [Polynomial.IsRoot] using pow_ne_zero 2 differenceNonzero
  constructor
  · unfold cubicPacketCharacteristicPolynomial at totalNonzero ⊢
    rw [Polynomial.rootMultiplicity_mul totalNonzero,
      Polynomial.rootMultiplicity_mul pairNonzero]
    rw [Polynomial.rootMultiplicity_X_sub_C,
      Polynomial.rootMultiplicity_X_sub_C, positiveUnitMultiplicity]
    simp [distinct]
  · unfold cubicPacketCharacteristicPolynomial at totalNonzero ⊢
    rw [Polynomial.rootMultiplicity_mul totalNonzero,
      Polynomial.rootMultiplicity_mul pairNonzero]
    rw [Polynomial.rootMultiplicity_X_sub_C,
      Polynomial.rootMultiplicity_X_sub_C, negativeUnitMultiplicity]
    simp [distinct.symm]

/-- The displayed cubic packet characteristic polynomial has
primitive-sixth multiplicity two. -/
theorem cubicPacketCharacteristicPolynomial_sixthMultiplicity :
    Quantum.sixthMultiplicityPolynomial cubicPacketCharacteristicPolynomial = 2 := by
  rw [Quantum.sixthMultiplicityPolynomial]
  obtain ⟨positive, negative⟩ :=
    cubicPacketCharacteristicPolynomial_primitive_rootMultiplicities
  rw [positive, negative]

/-- Conditional cubic packet theorem: once Cai's integral-loop-power block
comparison supplies the displayed characteristic polynomial, every smooth
cubic threefold has primitive-sixth multiplicity two. -/
theorem cubicThreefold_sixthMultiplicity_eq_two_of_charpoly
    {Cubic : Type*} (geometry : CubicPacketGeometry Cubic)
    (charpolyComparison : ∀ cubic,
      geometry.isSmoothCubicThreefold cubic →
        (geometry.framedMonodromy cubic).operator.charpoly =
          cubicPacketCharacteristicPolynomial) :
    ∀ cubic, geometry.isSmoothCubicThreefold cubic →
      (geometry.framedMonodromy cubic).sixthMultiplicity = 2 := by
  intro cubic smooth
  change Quantum.sixthMultiplicityPolynomial
      (geometry.framedMonodromy cubic).operator.charpoly = 2
  rw [charpolyComparison cubic smooth]
  exact cubicPacketCharacteristicPolynomial_sixthMultiplicity

end Applications

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
