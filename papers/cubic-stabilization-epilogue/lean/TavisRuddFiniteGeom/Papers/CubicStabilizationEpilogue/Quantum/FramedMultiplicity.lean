import Mathlib.Analysis.Complex.Exponential
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic
import Mathlib.LinearAlgebra.Matrix.Charpoly.Coeff
import Mathlib.Algebra.Polynomial.Div

/-!
# Primitive-sixth multiplicity of a framed monodromy matrix

This module formalizes the algebraic-multiplicity definition once the framed
formal-monodromy operator has been supplied as a finite complex matrix.  It
does not construct that matrix from a quantum connection or a
Levelt--Turrittin solution algebra.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Quantum

/-- The primitive sixth root `exp(π i / 3)` used in the manuscript. -/
noncomputable def primitiveSixthRootPositive : ℂ :=
  Complex.exp (Real.pi * Complex.I / 3)

/-- The conjugate primitive sixth root `exp(-π i / 3)` used in the manuscript. -/
noncomputable def primitiveSixthRootNegative : ℂ :=
  Complex.exp (-(Real.pi * Complex.I) / 3)

/-- A framed formal-monodromy operator on a labelled finite-dimensional
complex vector space.  The word "framed" records that this is the operator
for one turn of the original, unramified loop coordinate; the structure does
not construct that operator from a differential module. -/
structure FramedMonodromyMatrix where
  rank : ℕ
  operator : Matrix (Fin rank) (Fin rank) ℂ

/-- The sum of the algebraic multiplicities of the two primitive sixth roots
in the characteristic polynomial of a supplied framed-monodromy matrix. -/
noncomputable def FramedMonodromyMatrix.sixthMultiplicity
    (monodromy : FramedMonodromyMatrix) : ℕ :=
  monodromy.operator.charpoly.rootMultiplicity primitiveSixthRootPositive +
    monodromy.operator.charpoly.rootMultiplicity primitiveSixthRootNegative

/-- Primitive-sixth multiplicity directly for a nonzero characteristic
polynomial. -/
noncomputable def sixthMultiplicityPolynomial (polynomial : Polynomial ℂ) : ℕ :=
  polynomial.rootMultiplicity primitiveSixthRootPositive +
    polynomial.rootMultiplicity primitiveSixthRootNegative

/-- Primitive-sixth multiplicity is additive under multiplication of nonzero
characteristic polynomials, as it is under direct sums of monodromy blocks. -/
theorem sixthMultiplicityPolynomial_mul
    {left right : Polynomial ℂ} (leftNonzero : left ≠ 0) (rightNonzero : right ≠ 0) :
    sixthMultiplicityPolynomial (left * right) =
      sixthMultiplicityPolynomial left + sixthMultiplicityPolynomial right := by
  have productNonzero : left * right ≠ 0 := mul_ne_zero leftNonzero rightNonzero
  simp only [sixthMultiplicityPolynomial]
  rw [Polynomial.rootMultiplicity_mul productNonzero,
    Polynomial.rootMultiplicity_mul productNonzero]
  omega

/-- An `r`-fold repeated nonzero block has `r` times the primitive-sixth
multiplicity of one block. -/
theorem sixthMultiplicityPolynomial_pow
    (polynomial : Polynomial ℂ) (nonzero : polynomial ≠ 0) (rank : ℕ) :
    sixthMultiplicityPolynomial (polynomial ^ rank) =
      rank * sixthMultiplicityPolynomial polynomial := by
  induction rank with
  | zero => simp [sixthMultiplicityPolynomial]
  | succ rank inductionHypothesis =>
      rw [pow_succ,
        sixthMultiplicityPolynomial_mul (pow_ne_zero rank nonzero) nonzero,
        inductionHypothesis]
      simp [Nat.add_mul, Nat.add_comm]

/-- Primitive-sixth multiplicity of a finite product of nonzero block
characteristic polynomials is the sum of the block multiplicities. -/
theorem sixthMultiplicityPolynomial_list_prod
    (polynomials : List (Polynomial ℂ))
    (nonzero : ∀ polynomial ∈ polynomials, polynomial ≠ 0) :
    sixthMultiplicityPolynomial polynomials.prod =
      (polynomials.map sixthMultiplicityPolynomial).sum := by
  induction polynomials with
  | nil => simp [sixthMultiplicityPolynomial]
  | cons head tail inductionHypothesis =>
      have headNonzero : head ≠ 0 := nonzero head (by simp)
      have tailNonzero : ∀ polynomial ∈ tail, polynomial ≠ 0 := by
        intro polynomial membership
        exact nonzero polynomial (by simp [membership])
      have tailProductNonzero : tail.prod ≠ 0 := by
        apply List.prod_ne_zero
        intro zeroMembership
        exact (tailNonzero 0 zeroMembership) rfl
      rw [List.prod_cons,
        sixthMultiplicityPolynomial_mul headNonzero tailProductNonzero,
        inductionHypothesis tailNonzero]
      rfl

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
