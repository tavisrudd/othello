import Mathlib.LinearAlgebra.Matrix.NonsingularInverse
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic
import Mathlib.RingTheory.Nilpotent.Basic

/-!
# Block diagonality of a horizontal pairing on separated spectral factors

Let two local factors of an `F`-bundle have leading Euler operators `U₁` and
`U₂` whose single eigenvalues `λ₁` and `λ₂` are distinct, so that `U₁ - λ₁` and
`U₂ - λ₂` are nilpotent.  Horizontality of the pairing gives, at the leading
order, the Sylvester equation

  `U₁ᵀ * X - X * U₂ = 0`

for the off-diagonal block `X` of the leading pairing coefficient, and at each
later order the same equation with a right-hand side built from strictly
earlier off-diagonal coefficients.

This module proves the two algebraic facts behind that argument.  First, the
Sylvester equation with separated eigenvalues has only the zero solution: the
shifted matrix `U₁ᵀ - λ₂` is a unit plus a nilpotent, hence a unit, while `X`
intertwines its powers with the powers of the nilpotent matrix `U₂ - λ₂`, which
vanish.  Second, an order-by-order system whose right-hand side vanishes once
all strictly earlier coefficients vanish has only the zero solution, by strong
induction.

The nondegeneracy consequence is also recorded: a block matrix with vanishing
off-diagonal blocks has determinant the product of the two diagonal
determinants, so an invertible pairing restricts to invertible pairings on both
factors.

Lean does not construct the `F`-bundle, the spectral splitting, the connection,
or the pairing, and does not derive the displayed order-by-order equations from
horizontality; those supply the hypotheses.  The refinement to the even part of
a factor, which uses that the Poincare pairing pairs only equal parities, is
not formalized.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Quantum

open Matrix

variable {K : Type*} [Field K] {leftRank rightRank : ℕ}

/-- The transpose of a nilpotent square matrix is nilpotent. -/
theorem isNilpotent_transpose {M : Matrix (Fin leftRank) (Fin leftRank) K}
    (nilpotent : IsNilpotent M) : IsNilpotent Mᵀ := by
  obtain ⟨exponent, vanishing⟩ := nilpotent
  exact ⟨exponent, by rw [← Matrix.transpose_pow, vanishing, Matrix.transpose_zero]⟩

/-- A nonzero scalar multiple of the identity matrix is a unit. -/
theorem isUnit_smul_one {scalar : K} (nonzero : scalar ≠ 0) :
    IsUnit (scalar • (1 : Matrix (Fin leftRank) (Fin leftRank) K)) := by
  refine ⟨⟨scalar • 1, scalar⁻¹ • 1, ?_, ?_⟩, rfl⟩
  · rw [Matrix.smul_mul, Matrix.mul_smul, Matrix.one_mul, smul_smul,
      mul_inv_cancel₀ nonzero, one_smul]
  · rw [Matrix.smul_mul, Matrix.mul_smul, Matrix.one_mul, smul_smul,
      inv_mul_cancel₀ nonzero, one_smul]

/-- The Sylvester equation for two leading operators with distinct eigenvalues
has only the zero solution.  Here `U₁` and `U₂` are the leading operators, each
the sum of a scalar and a nilpotent matrix, and `X` is the off-diagonal block of
a pairing coefficient. -/
theorem sylvester_eq_zero_of_separated_eigenvalues
    {leftOperator : Matrix (Fin leftRank) (Fin leftRank) K}
    {rightOperator : Matrix (Fin rightRank) (Fin rightRank) K}
    {leftEigenvalue rightEigenvalue : K}
    (separated : leftEigenvalue ≠ rightEigenvalue)
    (leftNilpotent : IsNilpotent (leftOperator - leftEigenvalue • 1))
    (rightNilpotent : IsNilpotent (rightOperator - rightEigenvalue • 1))
    {block : Matrix (Fin leftRank) (Fin rightRank) K}
    (sylvester : leftOperatorᵀ * block = block * rightOperator) :
    block = 0 := by
  set shiftedLeft := leftOperatorᵀ - rightEigenvalue • (1 : Matrix (Fin leftRank) (Fin leftRank) K)
    with shiftedLeftDefinition
  set shiftedRight := rightOperator - rightEigenvalue • (1 : Matrix (Fin rightRank) (Fin rightRank) K)
    with shiftedRightDefinition
  have shifted : shiftedLeft * block = block * shiftedRight := by
    rw [shiftedLeftDefinition, shiftedRightDefinition, Matrix.sub_mul, Matrix.mul_sub,
      sylvester, Matrix.smul_mul, Matrix.mul_smul, Matrix.one_mul, Matrix.mul_one]
  have powers : ∀ exponent : ℕ,
      shiftedLeft ^ exponent * block = block * shiftedRight ^ exponent := by
    intro exponent
    induction exponent with
    | zero => simp
    | succ exponent inductionHypothesis =>
        calc shiftedLeft ^ (exponent + 1) * block
            = shiftedLeft * (shiftedLeft ^ exponent * block) := by
              rw [pow_succ', Matrix.mul_assoc]
          _ = shiftedLeft * (block * shiftedRight ^ exponent) := by
              rw [inductionHypothesis]
          _ = (shiftedLeft * block) * shiftedRight ^ exponent := by
              rw [Matrix.mul_assoc]
          _ = (block * shiftedRight) * shiftedRight ^ exponent := by rw [shifted]
          _ = block * shiftedRight ^ (exponent + 1) := by
              rw [Matrix.mul_assoc, ← pow_succ']
  obtain ⟨exponent, rightVanishing⟩ := rightNilpotent
  have blockVanishing : shiftedLeft ^ exponent * block = 0 := by
    rw [powers exponent, shiftedRightDefinition, rightVanishing, Matrix.mul_zero]
  have shiftedLeftDecomposition :
      shiftedLeft = (leftEigenvalue - rightEigenvalue) • (1 : Matrix (Fin leftRank) (Fin leftRank) K) +
        (leftOperator - leftEigenvalue • 1)ᵀ := by
    rw [shiftedLeftDefinition, Matrix.transpose_sub, Matrix.transpose_smul,
      Matrix.transpose_one, sub_smul]
    abel
  have nilpotentPart : IsNilpotent ((leftOperator - leftEigenvalue • 1)ᵀ) :=
    isNilpotent_transpose leftNilpotent
  have scalarUnit : IsUnit ((leftEigenvalue - rightEigenvalue) •
      (1 : Matrix (Fin leftRank) (Fin leftRank) K)) :=
    isUnit_smul_one (sub_ne_zero.mpr separated)
  have commuting : Commute ((leftOperator - leftEigenvalue • 1)ᵀ)
      ((leftEigenvalue - rightEigenvalue) • (1 : Matrix (Fin leftRank) (Fin leftRank) K)) := by
    unfold Commute SemiconjBy
    rw [Matrix.mul_smul, Matrix.smul_mul, Matrix.mul_one, Matrix.one_mul]
  have shiftedLeftUnit : IsUnit shiftedLeft := by
    rw [shiftedLeftDecomposition]
    exact nilpotentPart.isUnit_add_left_of_commute scalarUnit commuting
  obtain ⟨unitMatrix, unitEquality⟩ := shiftedLeftUnit.pow exponent
  have inverseEquation :
      (↑unitMatrix⁻¹ : Matrix (Fin leftRank) (Fin leftRank) K) *
        (↑unitMatrix : Matrix (Fin leftRank) (Fin leftRank) K) = 1 := unitMatrix.inv_mul
  calc block = ((↑unitMatrix⁻¹ : Matrix (Fin leftRank) (Fin leftRank) K) *
        (↑unitMatrix : Matrix (Fin leftRank) (Fin leftRank) K)) * block := by
        rw [inverseEquation, Matrix.one_mul]
    _ = (↑unitMatrix⁻¹ : Matrix (Fin leftRank) (Fin leftRank) K) *
        ((↑unitMatrix : Matrix (Fin leftRank) (Fin leftRank) K) * block) := by
        rw [Matrix.mul_assoc]
    _ = (↑unitMatrix⁻¹ : Matrix (Fin leftRank) (Fin leftRank) K) *
        (0 : Matrix (Fin leftRank) (Fin rightRank) K) := by
        rw [unitEquality, blockVanishing]
    _ = 0 := Matrix.mul_zero _

/-- An order-by-order Sylvester system whose right-hand side vanishes as soon as
all strictly earlier coefficients vanish has only the zero solution.  This is
the induction the manuscript performs on the coefficients of the off-diagonal
pairing block. -/
theorem offDiagonalCoefficients_eq_zero
    {leftOperator : Matrix (Fin leftRank) (Fin leftRank) K}
    {rightOperator : Matrix (Fin rightRank) (Fin rightRank) K}
    {leftEigenvalue rightEigenvalue : K}
    (separated : leftEigenvalue ≠ rightEigenvalue)
    (leftNilpotent : IsNilpotent (leftOperator - leftEigenvalue • 1))
    (rightNilpotent : IsNilpotent (rightOperator - rightEigenvalue • 1))
    (coefficient rightHandSide : ℕ → Matrix (Fin leftRank) (Fin rightRank) K)
    (system : ∀ order, leftOperatorᵀ * coefficient order -
      coefficient order * rightOperator = rightHandSide order)
    (earlierOrders : ∀ order,
      (∀ smaller, smaller < order → coefficient smaller = 0) →
        rightHandSide order = 0) :
    ∀ order, coefficient order = 0 := by
  intro order
  induction order using Nat.strong_induction_on with
  | _ order inductionHypothesis =>
      have vanishing : rightHandSide order = 0 :=
        earlierOrders order fun smaller less => inductionHypothesis smaller less
      have sylvester : leftOperatorᵀ * coefficient order =
          coefficient order * rightOperator := by
        have equation := system order
        rw [vanishing, sub_eq_zero] at equation
        exact equation
      exact sylvester_eq_zero_of_separated_eigenvalues separated leftNilpotent
        rightNilpotent sylvester

/-- A pairing with vanishing off-diagonal blocks is invertible exactly when both
diagonal restrictions are.  This is the nondegeneracy consequence of block
diagonality. -/
theorem blockDiagonal_det_ne_zero_iff
    (leftBlock : Matrix (Fin leftRank) (Fin leftRank) K)
    (rightBlock : Matrix (Fin rightRank) (Fin rightRank) K) :
    (Matrix.fromBlocks leftBlock 0 0 rightBlock).det ≠ 0 ↔
      leftBlock.det ≠ 0 ∧ rightBlock.det ≠ 0 := by
  rw [Matrix.det_fromBlocks_zero₂₁]
  constructor
  · intro nonzero
    exact ⟨fun zero => nonzero (by rw [zero, zero_mul]),
      fun zero => nonzero (by rw [zero, mul_zero])⟩
  · rintro ⟨leftNonzero, rightNonzero⟩
    exact mul_ne_zero leftNonzero rightNonzero

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
