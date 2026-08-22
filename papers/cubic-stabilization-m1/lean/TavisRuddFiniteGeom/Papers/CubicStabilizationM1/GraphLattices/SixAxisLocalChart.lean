import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.SixAxisGram
import Mathlib.Tactic

/-!
# The exact local orthogonal chart for the six-axis Gram matrix

This module checks the change of basis used in the manuscript at the primes
two and three.  It treats the inverse of five as explicit input, so it makes
no unstated localization claim.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace GraphLattices

open Matrix

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

/-- The pairing represented by the five-axis Gram matrix is symmetric. -/
theorem sixAxisGramPairing_comm (left right : Fin 5 → R) :
    sixAxisGramPairing left right = sixAxisGramPairing right left := by
  rw [sixAxisGramPairing_eq, sixAxisGramPairing_eq, dotProduct_comm]
  ring

/-- The elementary matrix that adds a multiple of the first coordinate to every
other coordinate. -/
def sixAxisChartShift (inverseFive : R) : Matrix (Fin 5) (Fin 5) R :=
  fun row column ↦ if row = 0 ∧ column ≠ 0 then inverseFive else 0

/-- The chart change of basis: its first column is the first coordinate vector
and its other columns are the displayed complement vectors. -/
def sixAxisChartBasis (inverseFive : R) : Matrix (Fin 5) (Fin 5) R :=
  1 + sixAxisChartShift inverseFive

/-- The inverse chart change of basis, subtracting the same multiple. -/
def sixAxisChartBasisInverse (inverseFive : R) : Matrix (Fin 5) (Fin 5) R :=
  1 - sixAxisChartShift inverseFive

/-- Any two of the elementary shift matrices compose to zero. -/
theorem sixAxisChartShift_mul (first second : R) :
    sixAxisChartShift (R := R) first * sixAxisChartShift second = 0 := by
  ext row column
  rw [Matrix.mul_apply]
  refine Finset.sum_eq_zero fun index _ ↦ ?_
  by_cases first_zero : index = 0
  · simp [sixAxisChartShift, first_zero]
  · simp [sixAxisChartShift, first_zero]

/-- The chart change of basis is invertible over any coefficient ring, with the
displayed inverse. -/
theorem sixAxisChartBasis_mul_inverse (inverseFive : R) :
    sixAxisChartBasis inverseFive * sixAxisChartBasisInverse inverseFive = 1 ∧
      sixAxisChartBasisInverse inverseFive * sixAxisChartBasis inverseFive = 1 := by
  constructor <;>
    simp [sixAxisChartBasis, sixAxisChartBasisInverse, Matrix.add_mul, Matrix.mul_add,
      Matrix.sub_mul, Matrix.mul_sub, sixAxisChartShift_mul]

/-- The first column of the chart change of basis is the first coordinate
vector. -/
theorem sixAxisChartBasis_column_zero (inverseFive : R) :
    (fun index ↦ sixAxisChartBasis inverseFive index 0) =
      sixAxisFirstVector (R := R) := by
  funext index
  fin_cases index <;>
    simp [sixAxisChartBasis, sixAxisChartShift, sixAxisFirstVector]

/-- Every other column of the chart change of basis is the corresponding
complement vector. -/
theorem sixAxisChartBasis_column_succ (inverseFive : R) (column : Fin 4) :
    (fun index ↦ sixAxisChartBasis inverseFive index column.succ) =
      sixAxisComplementVector inverseFive column := by
  funext index
  fin_cases index <;> fin_cases column <;>
    simp [sixAxisChartBasis, sixAxisChartShift, sixAxisComplementVector,
      Fin.succ]

/-- Every congruence entry of a change of basis against the five-axis Gram
matrix is the pairing of the corresponding two columns. -/
theorem congruence_apply_eq_pairing
    (basis : Matrix (Fin 5) (Fin 5) R) (row column : Fin 5) :
    (basisᵀ * sixAxisGram R * basis) row column =
      sixAxisGramPairing (fun index ↦ basis index row)
        (fun index ↦ basis index column) := by
  simp only [Matrix.mul_apply, Matrix.transpose_apply, sixAxisGramPairing, dotProduct,
    Matrix.mulVec, Finset.sum_mul, Finset.mul_sum]
  rw [Finset.sum_comm]
  refine Finset.sum_congr rfl fun first _ ↦ Finset.sum_congr rfl fun second _ ↦ ?_
  ring

/-- The Gram matrix of the chart basis: a unit line of value five, orthogonal to
a four-dimensional block equal to `(6/5)(5I-J)`. -/
def sixAxisChartGram (inverseFive : R) : Matrix (Fin 5) (Fin 5) R :=
  fun row column ↦
    if row = 0 then (if column = 0 then 5 else 0)
    else if column = 0 then 0
    else 6 * inverseFive * (if row = column then 4 else -1)

/-- The exact orthogonal decomposition of the coefficient lattice in the chart
basis: over any coefficient ring in which five has the displayed inverse, the
chart change of basis is invertible and carries the five-axis Gram matrix to the
block matrix with the unit line of value five and the four-dimensional depth-one
block. -/
theorem sixAxisChartBasis_congruence
    (inverseFive : R) (inverse : 5 * inverseFive = 1) :
    (sixAxisChartBasis inverseFive)ᵀ * sixAxisGram R * sixAxisChartBasis inverseFive =
      sixAxisChartGram inverseFive := by
  ext row column
  rw [congruence_apply_eq_pairing]
  induction row using Fin.cases with
  | zero =>
    induction column using Fin.cases with
    | zero =>
      rw [sixAxisChartBasis_column_zero]
      simpa [sixAxisChartGram] using sixAxisFirstVector_pairing (R := R)
    | succ column =>
      rw [sixAxisChartBasis_column_zero, sixAxisChartBasis_column_succ]
      simp [sixAxisChartGram,
        sixAxisFirstVector_pairing_complement inverseFive inverse column]
  | succ row =>
    induction column using Fin.cases with
    | zero =>
      rw [sixAxisChartBasis_column_zero, sixAxisChartBasis_column_succ,
        sixAxisGramPairing_comm]
      simp [sixAxisChartGram, Fin.succ_ne_zero,
        sixAxisFirstVector_pairing_complement inverseFive inverse row]
    | succ column =>
      rw [sixAxisChartBasis_column_succ, sixAxisChartBasis_column_succ,
        sixAxisComplementVector_pairing inverseFive inverse row column]
      simp [sixAxisChartGram, Fin.succ_ne_zero, Fin.succ_inj]

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

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
