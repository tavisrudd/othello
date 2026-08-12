import Mathlib.LinearAlgebra.Matrix.ToLin
import Mathlib.Tactic

/-!
# The algebraic `6I-J` calculation for five axes

This module verifies the elementary matrix calculation behind the six-axis
polarization discussion.  It does not identify geometric elliptic quotient
axes, a Rosati form, or the family-level kernel.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

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

end GraphLattices

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
