import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.SixAxisGram
import Mathlib.Tactic

/-!
# The exact local orthogonal chart for the six-axis Gram matrix

This module checks the change of basis used in the manuscript at the primes
two and three.  It treats the inverse of five as explicit input, so it makes
no unstated localization claim.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace GraphLattices

variable {R : Type*} [CommRing R]

/-- The first standard vector in the five-axis coefficient lattice. -/
def sixAxisFirstVector : Fin 5 → R :=
  Matrix.vecCons 1 (fun _ : Fin 4 ↦ 0)

/-- The four vectors `e_j + inverseFive * e_0` used in the local chart. -/
def sixAxisComplementVector (inverseFive : R) (column : Fin 4) : Fin 5 → R :=
  Matrix.vecCons inverseFive (fun row ↦ if row = column then 1 else 0)

/-- The bilinear pairing represented by the five-axis Gram matrix. -/
def sixAxisGramPairing (left right : Fin 5 → R) : R :=
  dotProduct left (Matrix.mulVec (sixAxisGram R) right)

/-- The integral four-dimensional unit block `5I-J` occurring after removal
of the first coordinate line. -/
def sixAxisComplementUnitMatrix : Matrix (Fin 4) (Fin 4) ℤ :=
  fun row column ↦ if row = column then 4 else -1

/-- The determinant calculation quoted in the local-chart proof. -/
theorem sixAxisComplementUnitMatrix_det :
    Matrix.det sixAxisComplementUnitMatrix = 125 := by
  norm_num [Matrix.det_apply, sixAxisComplementUnitMatrix]
  decide

/-- The determinant `125` of the complement unit block is prime to both
exceptional primes two and three. -/
theorem sixAxisComplementUnitMatrix_det_prime_to_two_three :
    ¬(2 : ℤ) ∣ Matrix.det sixAxisComplementUnitMatrix ∧
      ¬(3 : ℤ) ∣ Matrix.det sixAxisComplementUnitMatrix := by
  rw [sixAxisComplementUnitMatrix_det]
  norm_num

/-- Closed formula for the pairing represented by `6I-J`. -/
theorem sixAxisGramPairing_eq
    (left right : Fin 5 → R) :
    sixAxisGramPairing left right =
      6 * dotProduct left right - (∑ index, left index) * (∑ index, right index) := by
  unfold sixAxisGramPairing dotProduct
  simp_rw [sixAxisGram_mulVec]
  simp [Finset.mul_sum]
  simp_rw [mul_sub]
  rw [Finset.sum_sub_distrib]
  congr 1
  · apply Finset.sum_congr rfl
    intro index _
    ring
  · rw [← Finset.sum_mul, ← Finset.mul_sum]

/-- Coordinate sum of the first standard vector. -/
theorem sum_sixAxisFirstVector : ∑ index, sixAxisFirstVector (R := R) index = 1 := by
  norm_num [sixAxisFirstVector, Fin.sum_univ_succ]

/-- Coordinate sum of a local complement vector. -/
theorem sum_sixAxisComplementVector (inverseFive : R) (column : Fin 4) :
    ∑ index, sixAxisComplementVector inverseFive column index = inverseFive + 1 := by
  simp [sixAxisComplementVector, Fin.sum_univ_succ]

/-- Dot product of the first vector with a local complement vector. -/
theorem dotProduct_first_complement (inverseFive : R) (column : Fin 4) :
    dotProduct sixAxisFirstVector (sixAxisComplementVector inverseFive column) =
      inverseFive := by
  simp [dotProduct, sixAxisFirstVector, sixAxisComplementVector,
    Fin.sum_univ_succ]

/-- Dot products among the four local complement vectors. -/
theorem dotProduct_complement_complement
    (inverseFive : R) (row column : Fin 4) :
    dotProduct (sixAxisComplementVector inverseFive row)
        (sixAxisComplementVector inverseFive column) =
      inverseFive ^ 2 + if row = column then 1 else 0 := by
  by_cases equality : row = column
  · subst column
    simp [dotProduct, sixAxisComplementVector, Fin.sum_univ_succ]
    ring
  · simp [dotProduct, sixAxisComplementVector, Fin.sum_univ_succ, equality,
      eq_comm]
    ring

/-- The first coordinate line has Gram value five. -/
theorem sixAxisFirstVector_pairing :
    sixAxisGramPairing (R := R) sixAxisFirstVector sixAxisFirstVector = 5 := by
  rw [sixAxisGramPairing_eq, sum_sixAxisFirstVector]
  norm_num [dotProduct, sixAxisFirstVector, Fin.sum_univ_succ]

/-- If `inverseFive` is `1/5`, each displayed complement vector is
orthogonal to the first coordinate line. -/
theorem sixAxisFirstVector_pairing_complement
    (inverseFive : R) (inverse : 5 * inverseFive = 1) (column : Fin 4) :
    sixAxisGramPairing (R := R) sixAxisFirstVector
        (sixAxisComplementVector inverseFive column) = 0 := by
  rw [sixAxisGramPairing_eq, dotProduct_first_complement,
    sum_sixAxisFirstVector, sum_sixAxisComplementVector]
  linear_combination inverse

/-- The complement Gram matrix is exactly `(6/5)(5I-J)`: its diagonal
entries are `24/5` and its off-diagonal entries are `-6/5`. -/
theorem sixAxisComplementVector_pairing
    (inverseFive : R) (inverse : 5 * inverseFive = 1)
    (row column : Fin 4) :
    sixAxisGramPairing (R := R)
        (sixAxisComplementVector inverseFive row)
        (sixAxisComplementVector inverseFive column) =
      6 * inverseFive * (if row = column then 4 else -1) := by
  rw [sixAxisGramPairing_eq, dotProduct_complement_complement,
    sum_sixAxisComplementVector, sum_sixAxisComplementVector]
  split_ifs
  · rw [← sub_eq_zero]
    calc
      _ = (inverseFive - 5) * (5 * inverseFive - 1) := by ring
      _ = 0 := by rw [inverse, sub_self, mul_zero]
  · rw [← sub_eq_zero]
    calc
      _ = (inverseFive + 1) * (5 * inverseFive - 1) := by ring
      _ = 0 := by rw [inverse, sub_self, mul_zero]

/-- The integral arithmetic in the polarization proof uniquely determines
the diagonal and off-diagonal entries once positivity and the vanishing
invariant sum are included. -/
theorem sixAxisGram_parameters_unique
    (diagonal offDiagonal : ℤ)
    (diagonalPositive : 0 < diagonal)
    (invariantSum : diagonal + 5 * offDiagonal = 0)
    (intersection : diagonal ^ 2 - offDiagonal ^ 2 = 24) :
    diagonal = 5 ∧ offDiagonal = -1 := by
  constructor <;> nlinarith

end GraphLattices

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
