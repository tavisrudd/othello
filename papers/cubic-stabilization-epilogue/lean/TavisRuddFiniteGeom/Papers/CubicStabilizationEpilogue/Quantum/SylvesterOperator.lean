import Mathlib.LinearAlgebra.Matrix.NonsingularInverse
import Mathlib.RingTheory.Nilpotent.Basic
import Mathlib.RingTheory.Nilpotent.Lemmas
import Mathlib.Tactic

/-!
# The Sylvester operator of two separated leading operators

Let `R` be a commutative ring and let `U` and `V` be square matrices over `R`,
on possibly different finite coordinate types, of the form

  `U = λ • 1 + N`,  `V = μ • 1 + M`

with `N` and `M` nilpotent and `λ - μ` invertible in `R`.  The *Sylvester
operator* of the pair is the `R`-linear endomorphism

  `X ↦ U * X - X * V`

of the module of rectangular matrices with the row coordinates of `U` and the
column coordinates of `V`.

This module proves that the operator is invertible, so that the equation
`U * X - X * V = Y` has exactly one solution for every right-hand side `Y`.
The argument is the standard one: left multiplication by `N` and right
multiplication by `M` are commuting nilpotent endomorphisms, so their
difference is nilpotent, and the Sylvester operator is the sum of the
invertible scalar `λ - μ` with that nilpotent endomorphism.

The invertibility is what makes an order-by-order gauge recursion between two
blocks with separated spectra well posed: at each order the unknown
off-diagonal coefficient is the unique solution of such an equation.  A
degenerate special case, where only the vanishing of solutions is used and the
right-hand side is zero, is proved separately for the pairing of two spectral
factors; here both the existence and the uniqueness of a solution are needed.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Quantum

open Matrix

variable {R : Type*} [CommRing R] {rowIndex columnIndex : Type*}

/-- Left multiplication by a square matrix on the row coordinates, as a linear
endomorphism of the rectangular matrices. -/
def leftMultiplication [Fintype rowIndex] (U : Matrix rowIndex rowIndex R) :
    Module.End R (Matrix rowIndex columnIndex R) where
  toFun X := U * X
  map_add' X Y := Matrix.mul_add U X Y
  map_smul' scalar X := by
    simp [Matrix.mul_smul]

/-- Right multiplication by a square matrix on the column coordinates, as a
linear endomorphism of the rectangular matrices. -/
def rightMultiplication [Fintype columnIndex] (V : Matrix columnIndex columnIndex R) :
    Module.End R (Matrix rowIndex columnIndex R) where
  toFun X := X * V
  map_add' X Y := Matrix.add_mul X Y V
  map_smul' scalar X := by
    simp [Matrix.smul_mul]

@[simp]
theorem leftMultiplication_apply [Fintype rowIndex] (U : Matrix rowIndex rowIndex R)
    (X : Matrix rowIndex columnIndex R) : leftMultiplication U X = U * X := rfl

@[simp]
theorem rightMultiplication_apply [Fintype columnIndex] (V : Matrix columnIndex columnIndex R)
    (X : Matrix rowIndex columnIndex R) : rightMultiplication V X = X * V := rfl

/-- Left multiplication is additive in the multiplying matrix. -/
theorem leftMultiplication_sub [Fintype rowIndex] (U U' : Matrix rowIndex rowIndex R) :
    (leftMultiplication (U - U') : Module.End R (Matrix rowIndex columnIndex R))
      = leftMultiplication U - leftMultiplication U' := by
  ext X i j
  simp [Matrix.sub_mul]

/-- Right multiplication is additive in the multiplying matrix. -/
theorem rightMultiplication_sub [Fintype columnIndex] (V V' : Matrix columnIndex columnIndex R) :
    (rightMultiplication (V - V') : Module.End R (Matrix rowIndex columnIndex R))
      = rightMultiplication V - rightMultiplication V' := by
  ext X i j
  simp [Matrix.mul_sub]

/-- Left multiplication by a scalar matrix is that scalar acting on the module. -/
theorem leftMultiplication_smul_one [Fintype rowIndex] [DecidableEq rowIndex] (scalar : R) :
    (leftMultiplication (scalar • (1 : Matrix rowIndex rowIndex R)) :
        Module.End R (Matrix rowIndex columnIndex R))
      = scalar • (1 : Module.End R (Matrix rowIndex columnIndex R)) := by
  ext X
  simp [leftMultiplication]

/-- Right multiplication by a scalar matrix is that scalar acting on the module. -/
theorem rightMultiplication_smul_one [Fintype columnIndex] [DecidableEq columnIndex]
    (scalar : R) :
    (rightMultiplication (scalar • (1 : Matrix columnIndex columnIndex R)) :
        Module.End R (Matrix rowIndex columnIndex R))
      = scalar • (1 : Module.End R (Matrix rowIndex columnIndex R)) := by
  ext X
  simp [rightMultiplication]

/-- Powers of left multiplication multiply on the left by the corresponding
power. -/
theorem leftMultiplication_pow [Fintype rowIndex] [DecidableEq rowIndex]
    (U : Matrix rowIndex rowIndex R) (exponent : ℕ) :
    (leftMultiplication U : Module.End R (Matrix rowIndex columnIndex R)) ^ exponent
      = leftMultiplication (U ^ exponent) := by
  induction exponent with
  | zero =>
      ext X
      simp [leftMultiplication]
  | succ exponent inductionHypothesis =>
      ext X
      rw [pow_succ, Module.End.mul_apply, inductionHypothesis]
      simp [leftMultiplication, pow_succ, Matrix.mul_assoc]

/-- Powers of right multiplication multiply on the right by the corresponding
power. -/
theorem rightMultiplication_pow [Fintype columnIndex] [DecidableEq columnIndex]
    (V : Matrix columnIndex columnIndex R) (exponent : ℕ) :
    (rightMultiplication V : Module.End R (Matrix rowIndex columnIndex R)) ^ exponent
      = rightMultiplication (V ^ exponent) := by
  induction exponent with
  | zero =>
      ext X
      simp [rightMultiplication]
  | succ exponent inductionHypothesis =>
      refine LinearMap.ext fun X => ?_
      rw [pow_succ, Module.End.mul_apply, inductionHypothesis]
      show X * V * V ^ exponent = X * V ^ (exponent + 1)
      rw [Matrix.mul_assoc, ← pow_succ']

/-- Left multiplication by a nilpotent matrix is a nilpotent endomorphism. -/
theorem isNilpotent_leftMultiplication [Fintype rowIndex] [DecidableEq rowIndex]
    {U : Matrix rowIndex rowIndex R}
    (nilpotent : IsNilpotent U) :
    IsNilpotent (leftMultiplication U : Module.End R (Matrix rowIndex columnIndex R)) := by
  obtain ⟨exponent, vanishing⟩ := nilpotent
  refine ⟨exponent, ?_⟩
  ext X i j
  simp [leftMultiplication_pow, vanishing]

/-- Right multiplication by a nilpotent matrix is a nilpotent endomorphism. -/
theorem isNilpotent_rightMultiplication [Fintype columnIndex] [DecidableEq columnIndex]
    {V : Matrix columnIndex columnIndex R}
    (nilpotent : IsNilpotent V) :
    IsNilpotent (rightMultiplication V : Module.End R (Matrix rowIndex columnIndex R)) := by
  obtain ⟨exponent, vanishing⟩ := nilpotent
  refine ⟨exponent, ?_⟩
  ext X i j
  simp [rightMultiplication_pow, vanishing]

/-- Left and right multiplication commute, by associativity of matrix
multiplication. -/
theorem commute_leftMultiplication_rightMultiplication [Fintype rowIndex] [Fintype columnIndex]
    (U : Matrix rowIndex rowIndex R)
    (V : Matrix columnIndex columnIndex R) :
    Commute (leftMultiplication U : Module.End R (Matrix rowIndex columnIndex R))
      (rightMultiplication V) := by
  unfold Commute SemiconjBy
  ext X i j
  simp [Module.End.mul_apply, Matrix.mul_assoc]

/-- Left multiplication is additive in the multiplying matrix. -/
theorem leftMultiplication_add [Fintype rowIndex] (U U' : Matrix rowIndex rowIndex R) :
    (leftMultiplication (U + U') : Module.End R (Matrix rowIndex columnIndex R))
      = leftMultiplication U + leftMultiplication U' := by
  ext X i j
  simp [Matrix.add_mul]

/-- Right multiplication is additive in the multiplying matrix. -/
theorem rightMultiplication_add [Fintype columnIndex] (V V' : Matrix columnIndex columnIndex R) :
    (rightMultiplication (V + V') : Module.End R (Matrix rowIndex columnIndex R))
      = rightMultiplication V + rightMultiplication V' := by
  ext X i j
  simp [Matrix.mul_add]

/-- Left multiplication turns a product of matrices into a composition, in the
same order. -/
theorem leftMultiplication_mul [Fintype rowIndex] (U U' : Matrix rowIndex rowIndex R) :
    (leftMultiplication (U * U') : Module.End R (Matrix rowIndex columnIndex R))
      = leftMultiplication U * leftMultiplication U' := by
  refine LinearMap.ext fun X => ?_
  rw [Module.End.mul_apply]
  show U * U' * X = U * (U' * X)
  rw [Matrix.mul_assoc]

/-- Right multiplication turns a product of matrices into a composition, in the
opposite order. -/
theorem rightMultiplication_mul [Fintype columnIndex] (V V' : Matrix columnIndex columnIndex R) :
    (rightMultiplication (V * V') : Module.End R (Matrix rowIndex columnIndex R))
      = rightMultiplication V' * rightMultiplication V := by
  refine LinearMap.ext fun X => ?_
  rw [Module.End.mul_apply]
  show X * (V * V') = X * V * V'
  rw [Matrix.mul_assoc]

/-- The Sylvester operator `X ↦ U * X - X * V` of two leading operators. -/
def sylvesterOperator [Fintype rowIndex] [Fintype columnIndex]
    (U : Matrix rowIndex rowIndex R) (V : Matrix columnIndex columnIndex R) :
    Module.End R (Matrix rowIndex columnIndex R) :=
  leftMultiplication U - rightMultiplication V

@[simp]
theorem sylvesterOperator_apply [Fintype rowIndex] [Fintype columnIndex]
    (U : Matrix rowIndex rowIndex R)
    (V : Matrix columnIndex columnIndex R) (X : Matrix rowIndex columnIndex R) :
    sylvesterOperator U V X = U * X - X * V := rfl

/-- The Sylvester operator is additive in the pair of leading operators. -/
theorem sylvesterOperator_add [Fintype rowIndex] [Fintype columnIndex]
    (U U' : Matrix rowIndex rowIndex R) (V V' : Matrix columnIndex columnIndex R) :
    (sylvesterOperator (U + U') (V + V') : Module.End R (Matrix rowIndex columnIndex R))
      = sylvesterOperator U V + sylvesterOperator U' V' := by
  rw [sylvesterOperator, sylvesterOperator, sylvesterOperator, leftMultiplication_add,
    rightMultiplication_add]
  abel

/-- The Sylvester operator of two nilpotent matrices is nilpotent: left and
right multiplication are commuting nilpotent endomorphisms. -/
theorem isNilpotent_sylvesterOperator [Fintype rowIndex] [DecidableEq rowIndex]
    [Fintype columnIndex] [DecidableEq columnIndex] {U : Matrix rowIndex rowIndex R}
    {V : Matrix columnIndex columnIndex R} (leftNilpotent : IsNilpotent U)
    (rightNilpotent : IsNilpotent V) :
    IsNilpotent (sylvesterOperator U V : Module.End R (Matrix rowIndex columnIndex R)) :=
  Commute.isNilpotent_sub (commute_leftMultiplication_rightMultiplication _ _)
    (isNilpotent_leftMultiplication leftNilpotent)
    (isNilpotent_rightMultiplication rightNilpotent)

/-- The Sylvester operators of two commuting matrices commute.  This is the
statement that the adjoint action of a matrix algebra is a homomorphism of Lie
algebras, in the case needed for a leading operator split into its scalar and
nilpotent parts. -/
theorem commute_sylvesterOperator_of_commute [Fintype rowIndex]
    {U U' : Matrix rowIndex rowIndex R} (commuting : U * U' = U' * U) :
    Commute (sylvesterOperator U U : Module.End R (Matrix rowIndex rowIndex R))
      (sylvesterOperator U' U') := by
  unfold Commute SemiconjBy
  rw [sylvesterOperator, sylvesterOperator, sub_mul, sub_mul, mul_sub, mul_sub, mul_sub, mul_sub,
    ← leftMultiplication_mul, ← leftMultiplication_mul, ← rightMultiplication_mul,
    ← rightMultiplication_mul, commuting,
    (commute_leftMultiplication_rightMultiplication U U').eq,
    (commute_leftMultiplication_rightMultiplication U' U).eq]
  abel

/-- The Sylvester operator of two separated leading operators is invertible.
Writing `U = λ • 1 + N` and `V = μ • 1 + M` with `N` and `M` nilpotent, the
operator is the sum of the invertible scalar `λ - μ` and the difference of the
commuting nilpotent endomorphisms given by left multiplication by `N` and right
multiplication by `M`. -/
theorem isUnit_sylvesterOperator [Fintype rowIndex] [DecidableEq rowIndex]
    [Fintype columnIndex] [DecidableEq columnIndex] {U : Matrix rowIndex rowIndex R}
    {V : Matrix columnIndex columnIndex R} {leftScalar rightScalar : R}
    (separated : IsUnit (leftScalar - rightScalar))
    (leftNilpotent : IsNilpotent (U - leftScalar • 1))
    (rightNilpotent : IsNilpotent (V - rightScalar • 1)) :
    IsUnit (sylvesterOperator U V : Module.End R (Matrix rowIndex columnIndex R)) := by
  set nilpotentPart :
      Module.End R (Matrix rowIndex columnIndex R) :=
    leftMultiplication (U - leftScalar • 1) - rightMultiplication (V - rightScalar • 1)
    with nilpotentPartDefinition
  have scalarUnit :
      IsUnit ((leftScalar - rightScalar) •
        (1 : Module.End R (Matrix rowIndex columnIndex R))) := by
    have mapped := separated.map (algebraMap R (Module.End R (Matrix rowIndex columnIndex R)))
    rwa [Algebra.algebraMap_eq_smul_one] at mapped
  have decomposition : sylvesterOperator U V
      = (leftScalar - rightScalar) • (1 : Module.End R (Matrix rowIndex columnIndex R))
        + nilpotentPart := by
    rw [nilpotentPartDefinition, sylvesterOperator, leftMultiplication_sub,
      rightMultiplication_sub, leftMultiplication_smul_one, rightMultiplication_smul_one]
    ext X
    simp [sub_smul]
    ring
  have nilpotent : IsNilpotent nilpotentPart := by
    rw [nilpotentPartDefinition]
    exact isNilpotent_sylvesterOperator leftNilpotent rightNilpotent
  have commuting : Commute nilpotentPart
      ((leftScalar - rightScalar) • (1 : Module.End R (Matrix rowIndex columnIndex R))) := by
    unfold Commute SemiconjBy
    ext X
    simp
  rw [decomposition]
  exact nilpotent.isUnit_add_left_of_commute scalarUnit commuting

/-- The Sylvester equation of two separated leading operators has exactly one
solution for every right-hand side. -/
theorem existsUnique_sylvester_solution [Fintype rowIndex] [DecidableEq rowIndex]
    [Fintype columnIndex] [DecidableEq columnIndex] {U : Matrix rowIndex rowIndex R}
    {V : Matrix columnIndex columnIndex R} {leftScalar rightScalar : R}
    (separated : IsUnit (leftScalar - rightScalar))
    (leftNilpotent : IsNilpotent (U - leftScalar • 1))
    (rightNilpotent : IsNilpotent (V - rightScalar • 1))
    (target : Matrix rowIndex columnIndex R) :
    ∃! solution : Matrix rowIndex columnIndex R, U * solution - solution * V = target := by
  obtain ⟨operator, operatorEquality⟩ :=
    isUnit_sylvesterOperator separated leftNilpotent rightNilpotent
  have mulInverse :
      (operator : Module.End R (Matrix rowIndex columnIndex R)) * ↑operator⁻¹ = 1 :=
    operator.mul_inv
  have inverseMul :
      (↑operator⁻¹ : Module.End R (Matrix rowIndex columnIndex R)) * ↑operator = 1 :=
    operator.inv_mul
  refine ⟨(↑operator⁻¹ : Module.End R (Matrix rowIndex columnIndex R)) target, ?_, ?_⟩
  · have applied := congrArg
      (fun endomorphism : Module.End R (Matrix rowIndex columnIndex R) => endomorphism target)
      mulInverse
    simp only [Module.End.mul_apply, Module.End.one_apply] at applied
    rw [operatorEquality, sylvesterOperator_apply] at applied
    exact applied
  · intro candidate candidateEquation
    have applied := congrArg
      (fun endomorphism : Module.End R (Matrix rowIndex columnIndex R) => endomorphism candidate)
      inverseMul
    simp only [Module.End.mul_apply, Module.End.one_apply] at applied
    rw [operatorEquality, sylvesterOperator_apply, candidateEquation] at applied
    exact applied.symm

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
