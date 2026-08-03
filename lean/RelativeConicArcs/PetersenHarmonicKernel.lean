import RelativeConicArcs.KneserPairEigenspace

/-!
# The degree-six Petersen kernel

This module studies the algebraic operator obtained from the two orbit values
`-65/243` and `47/243` on pairs of two-subsets.  When an external geometric
identification supplies the ten labelled icosahedral face axes and their two
squared angles, the normalized degree-six Legendre polynomial gives those
values and the resulting kernel operator is

`(196 I + 47 J - 112 A) / 243`,

where `A` is Petersen adjacency.  Its restriction to the pair-sum
four-space is scalar because that space is the `-2` eigenspace and has zero
total sum.  The normalized spherical Gram scalar there is `140/1053`.

The proofs below start from this displayed algebraic operator and use symbolic
Kneser eigenspace theorems; they do not formalize the face-axis identification
or the spherical addition theorem, and no ten-by-ten diagonalization is
performed.
-/

namespace RelativeConicArcs.PetersenHarmonicKernel

open RelativeConicArcs.KneserPairEigenspace

/-- The degree-six Legendre polynomial with `P₆(1)=1`. -/
def legendreSix (s : ℚ) : ℚ :=
  (231 * s ^ 6 - 315 * s ^ 4 + 105 * s ^ 2 - 5) / 16

/-- The chosen degree-six Legendre normalization takes the value one at one. -/
@[simp]
theorem legendreSix_one : legendreSix 1 = 1 := by
  norm_num [legendreSix]

/-- The degree-six kernel value on disjoint Petersen labels; only the
squared angle `5/9` enters because `P₆` is even. -/
theorem legendreSix_of_sq_five_ninth {s : ℚ} (hs : s ^ 2 = 5 / 9) :
    legendreSix s = -65 / 243 := by
  rw [legendreSix]
  have hs4 : s ^ 4 = (5 / 9 : ℚ) ^ 2 := by rw [show s ^ 4 = (s ^ 2) ^ 2 by ring, hs]
  have hs6 : s ^ 6 = (5 / 9 : ℚ) ^ 3 := by rw [show s ^ 6 = (s ^ 2) ^ 3 by ring, hs]
  rw [hs, hs4, hs6]
  norm_num

/-- The degree-six kernel value on intersecting Petersen labels; only the
squared angle `1/9` enters. -/
theorem legendreSix_of_sq_one_ninth {s : ℚ} (hs : s ^ 2 = 1 / 9) :
    legendreSix s = 47 / 243 := by
  rw [legendreSix]
  have hs4 : s ^ 4 = (1 / 9 : ℚ) ^ 2 := by rw [show s ^ 4 = (s ^ 2) ^ 2 by ring, hs]
  have hs6 : s ^ 6 = (1 / 9 : ℚ) ^ 3 := by rw [show s ^ 6 = (s ^ 2) ^ 3 by ring, hs]
  rw [hs, hs4, hs6]
  norm_num

/-- The algebraic kernel operator encoded by the two Petersen pair-orbit
values.  Its identification with a geometric reproducing kernel is external. -/
def kernelOperator (x : Pair 5 → ℚ) (p : Pair 5) : ℚ :=
  (196 * x p + 47 * totalPairSum x - 112 * adjacency x p) / 243

/-- The algebraic Gram normalization obtained by dividing the kernel operator
by thirteen.  Interpreting thirteen as `dim ℋ₆` and this operator as a
spherical Gram matrix uses the external addition-theorem identification. -/
def gramOperator (x : Pair 5 → ℚ) (p : Pair 5) : ℚ :=
  kernelOperator x p / 13

/-- The kernel matrix coefficients are exactly diagonal `1`, Petersen-edge
`-65/243`, and nonedge `47/243`; the integers `196,47,112` merely repackage
these three values. -/
theorem kernel_coefficients :
    (196 + 47 : ℚ) / 243 = 1 ∧ (47 - 112 : ℚ) / 243 = -65 / 243 := by
  norm_num

/-- Pair sums of sum-zero vertex weights have total pair weight zero. -/
theorem totalPairSum_pairSum_eq_zero (y : Fin 5 → ℚ) (hy : ∑ i, y i = 0) :
    totalPairSum (pairSum y) = 0 := by
  simpa [totalPairSum, pairSum, hy] using sum_pairSums y

/-- The reproducing kernel acts on the Petersen pair-sum four-space by the
scalar `140/81`. -/
theorem kernelOperator_pairSum (y : Fin 5 → ℚ) (hy : ∑ i, y i = 0)
    (p : Pair 5) :
    kernelOperator (pairSum y) p = (140 / 81 : ℚ) * pairSum y p := by
  rw [kernelOperator, totalPairSum_pairSum_eq_zero y hy,
    adjacency_pairSum_of_sum_eq_zero (by omega : 3 ≤ 5) y hy p]
  norm_num
  ring

/-- After the addition-theorem factor `1/13`, the spherical Gram operator
acts on the Petersen pair-sum four-space by `140/1053`. -/
theorem gramOperator_pairSum (y : Fin 5 → ℚ) (hy : ∑ i, y i = 0)
    (p : Pair 5) :
    gramOperator (pairSum y) p = (140 / 1053 : ℚ) * pairSum y p := by
  rw [gramOperator, kernelOperator_pairSum y hy p]
  norm_num
  ring

/-- On the sum-zero module for `K(n,2)`, the pair-sum map multiplies the
standard quadratic norm by `n-2`.  The Petersen factor three is the case
`n=5`, not an independent normalization. -/
theorem pairSum_norm_sq_general {n : ℕ} (hn : 2 ≤ n)
    (y : Fin n → ℚ) (hy : ∑ i, y i = 0) :
    ∑ p : Pair n, pairSum y p ^ 2 = (n - 2 : ℕ) • ∑ i, y i ^ 2 := by
  classical
  calc
    ∑ p : Pair n, pairSum y p ^ 2 =
        ∑ i, y i * incidenceSum (pairSum y) i := by
      symm
      calc
        ∑ i, y i * incidenceSum (pairSum y) i =
            ∑ i : Fin n, ∑ p : Pair n,
              if i ∈ p.vertices then y i * pairSum y p else 0 := by
          apply Finset.sum_congr rfl
          intro i _
          simp only [incidenceSum, incidentPairs]
          rw [Finset.mul_sum]
          rw [← Finset.sum_filter]
        _ = ∑ p : Pair n, ∑ i : Fin n,
              if i ∈ p.vertices then y i * pairSum y p else 0 := by
          rw [Finset.sum_comm]
        _ = ∑ p : Pair n, ∑ i ∈ p.vertices, y i * pairSum y p := by
          apply Finset.sum_congr rfl
          intro p _
          rw [← Finset.sum_filter]
          simp
        _ = ∑ p : Pair n, pairSum y p ^ 2 := by
          apply Finset.sum_congr rfl
          intro p _
          rw [← Finset.sum_mul]
          simp only [pairSum, pow_two]
    _ = ∑ i, y i * ((n - 2 : ℕ) • y i) := by
      apply Finset.sum_congr rfl
      intro i _
      rw [incidenceSum_pairSum hn, hy, add_zero]
    _ = (n - 2 : ℕ) • ∑ i, y i ^ 2 := by
      rw [Finset.smul_sum]
      apply Finset.sum_congr rfl
      intro i _
      simp only [nsmul_eq_mul]
      ring

/-- The Petersen pair-sum map multiplies the standard quadratic norm by
three. -/
theorem pairSum_norm_sq (y : Fin 5 → ℚ) (hy : ∑ i, y i = 0) :
    ∑ p : Pair 5, pairSum y p ^ 2 = 3 * ∑ i, y i ^ 2 := by
  simpa using pairSum_norm_sq_general (by omega : 2 ≤ 5) y hy

/-- The Gram scalar on the pair-sum four-space is nonzero. -/
theorem gramScalar_ne_zero : (140 / 1053 : ℚ) ≠ 0 := by
  norm_num

end RelativeConicArcs.PetersenHarmonicKernel
