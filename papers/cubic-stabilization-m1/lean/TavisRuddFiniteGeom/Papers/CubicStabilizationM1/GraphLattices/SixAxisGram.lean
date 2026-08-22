import Mathlib.LinearAlgebra.Matrix.ToLin
import Mathlib.Tactic

/-!
# The algebraic `6I-J` calculation for five axes

This module verifies the elementary matrix calculation behind the six-axis
polarization discussion.  It does not identify geometric elliptic quotient
axes, a Rosati form, or the family-level kernel.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace GraphLattices

open scoped BigOperators

/-- The five-by-five matrix `6I-J`: diagonal entries are five and
off-diagonal entries are minus one. -/
def sixAxisGram (R : Type*) [CommRing R] : Matrix (Fin 5) (Fin 5) R :=
  fun row column ↦ 6 * (if row = column then 1 else 0) - 1

/-- Multiplication by `6I-J` is six times the vector minus its coordinate
sum in every coordinate. -/
theorem sixAxisGram_mulVec
    {R : Type*} [CommRing R] (vector : Fin 5 → R) (row : Fin 5) :
    Matrix.mulVec (sixAxisGram R) vector row =
      6 * vector row - ∑ column, vector column := by
  classical
  simp only [Matrix.mulVec, dotProduct, sixAxisGram]
  simp_rw [sub_mul]
  rw [Finset.sum_sub_distrib]
  simp

/-- The constant vector is the unit-eigenvalue line of `6I-J`. -/
theorem sixAxisGram_mulVec_one
    {R : Type*} [CommRing R] :
    Matrix.mulVec (sixAxisGram R) (fun _ : Fin 5 ↦ (1 : R)) =
      fun _ ↦ 1 := by
  funext row
  rw [sixAxisGram_mulVec]
  simp
  ring

/-- Every vector in the augmentation hyperplane (coordinate sum zero) is an
eigenvector of `6I-J` with eigenvalue six. -/
theorem sixAxisGram_mulVec_of_sum_zero
    {R : Type*} [CommRing R] (vector : Fin 5 → R)
    (sumZero : (∑ column, vector column) = 0) :
    Matrix.mulVec (sixAxisGram R) vector = fun row ↦ 6 * vector row := by
  funext row
  rw [sixAxisGram_mulVec, sumZero, sub_zero]

/-- The integral row operation fixing row zero and subtracting it from every
other row. -/
def sixAxisSmithLeft : Matrix (Fin 5) (Fin 5) ℤ :=
  fun row column ↦
    if row = 0 then
      if row = column then 1 else 0
    else
      (if row = column then 1 else 0) - (if column = 0 then 1 else 0)

/-- The inverse integral row operation, adding row zero to every other row. -/
def sixAxisSmithLeftInverse : Matrix (Fin 5) (Fin 5) ℤ :=
  fun row column ↦
    if row = 0 then
      if row = column then 1 else 0
    else
      (if row = column then 1 else 0) + (if column = 0 then 1 else 0)

/-- The integral column operation that first replaces column zero by the sum
of all columns and then adds that new column zero to every other column. -/
def sixAxisSmithRight : Matrix (Fin 5) (Fin 5) ℤ :=
  fun row column ↦
    if column = 0 then 1 else (if row = column then 1 else 0) + 1

/-- The inverse of `sixAxisSmithRight`. -/
def sixAxisSmithRightInverse : Matrix (Fin 5) (Fin 5) ℤ :=
  fun row column ↦
    if row = 0 then
      if column = 0 then 5 else -1
    else if column = 0 then
      -1
    else if row = column then 1 else 0

/-- The diagonal matrix with Smith entries `(1,6,6,6,6)`. -/
def sixAxisSmithDiagonal : Matrix (Fin 5) (Fin 5) ℤ :=
  fun row column ↦
    if row = column then if row = 0 then 1 else 6 else 0

/-- The displayed left row operation has the displayed integral inverse. -/
theorem sixAxisSmithLeft_mul_inverse :
    sixAxisSmithLeft * sixAxisSmithLeftInverse = 1 := by
  ext row column
  fin_cases row <;> fin_cases column <;>
    norm_num [sixAxisSmithLeft, sixAxisSmithLeftInverse, Matrix.mul_apply,
      Fin.sum_univ_succ] <;> decide

/-- The inverse left operation is also a left inverse. -/
theorem sixAxisSmithLeft_inverse_mul :
    sixAxisSmithLeftInverse * sixAxisSmithLeft = 1 := by
  ext row column
  fin_cases row <;> fin_cases column <;>
    norm_num [sixAxisSmithLeft, sixAxisSmithLeftInverse, Matrix.mul_apply,
      Fin.sum_univ_succ] <;> decide

/-- The displayed right column operation has the displayed integral inverse. -/
theorem sixAxisSmithRight_mul_inverse :
    sixAxisSmithRight * sixAxisSmithRightInverse = 1 := by
  ext row column
  fin_cases row <;> fin_cases column <;>
    norm_num [sixAxisSmithRight, sixAxisSmithRightInverse, Matrix.mul_apply,
      Fin.sum_univ_succ] <;> decide

/-- The inverse right operation is also a left inverse. -/
theorem sixAxisSmithRight_inverse_mul :
    sixAxisSmithRightInverse * sixAxisSmithRight = 1 := by
  ext row column
  fin_cases row <;> fin_cases column <;>
    norm_num [sixAxisSmithRight, sixAxisSmithRightInverse, Matrix.mul_apply,
      Fin.sum_univ_succ] <;> decide

/-- Explicit integral Smith reduction of `6I-J` to
`diag(1,6,6,6,6)`. -/
theorem sixAxisGram_smith_reduction :
    sixAxisSmithLeft * sixAxisGram ℤ * sixAxisSmithRight =
      sixAxisSmithDiagonal := by
  ext row column
  fin_cases row <;> fin_cases column <;>
    norm_num [sixAxisSmithLeft, sixAxisGram, sixAxisSmithRight,
      sixAxisSmithDiagonal, Matrix.mul_apply, Fin.sum_univ_succ] <;> decide

/-- The four non-unit Smith entries have exact valuation one at both two and
three: they are divisible by the prime but not by its square. -/
theorem sixAxisSmith_depth_one_at_two_and_three :
    ((2 : ℤ) ∣ 6 ∧ ¬ (4 : ℤ) ∣ 6) ∧
      ((3 : ℤ) ∣ 6 ∧ ¬ (9 : ℤ) ∣ 6) := by
  norm_num

/-- Every nonzero-index diagonal entry in the Smith form is six, whereas the
zero-index entry is the unit one. -/
theorem sixAxisSmithDiagonal_entries :
    sixAxisSmithDiagonal 0 0 = 1 ∧
      ∀ index : Fin 5, index ≠ 0 → sixAxisSmithDiagonal index index = 6 := by
  constructor
  · simp [sixAxisSmithDiagonal]
  · intro index nonzero
    simp [sixAxisSmithDiagonal, nonzero]

end GraphLattices

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
