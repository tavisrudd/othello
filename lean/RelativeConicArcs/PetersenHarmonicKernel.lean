import RelativeConicArcs.KneserPairEigenspace

/-!
# The degree-six Petersen kernel

The degree-six zonal kernel on the ten labelled icosahedral face axes has
only two off-diagonal values, because pairs of two-subsets either are
disjoint or meet in one point.  Evaluating the normalized Legendre polynomial
at the two squared angles gives `-65/243` and `47/243`.  Hence the whole
kernel operator is

`(196 I + 47 J - 112 A) / 243`,

where `A` is Petersen adjacency.  Its restriction to the pair-sum
four-space is scalar because that space is the `-2` eigenspace and has zero
total sum.  The normalized spherical Gram scalar there is `140/1053`.

The proofs below use the two orbit values and the symbolic Kneser eigenspace
theorems; no ten-by-ten diagonalization is performed.
-/

namespace RelativeConicArcs.PetersenHarmonicKernel

open RelativeConicArcs.KneserPairEigenspace

/-- The degree-six Legendre polynomial with `P₆(1)=1`. -/
def legendreSix (s : ℚ) : ℚ :=
  (231 * s ^ 6 - 315 * s ^ 4 + 105 * s ^ 2 - 5) / 16

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

/-- The reproducing-kernel operator encoded by the two Petersen pair orbits. -/
def kernelOperator (x : Pair 5 → ℚ) (p : Pair 5) : ℚ :=
  (196 * x p + 47 * totalPairSum x - 112 * adjacency x p) / 243

/-- The probability-normalized spherical Gram operator is the kernel
operator divided by `dim ℋ₆ = 13`. -/
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

/-- The pair-sum map multiplies the standard quadratic norm by three. -/
theorem pairSum_norm_sq (y : Fin 5 → ℚ) (hy : ∑ i, y i = 0) :
    ∑ p : Pair 5, pairSum y p ^ 2 = 3 * ∑ i, y i ^ 2 := by
  classical
  calc
    ∑ p : Pair 5, pairSum y p ^ 2 =
        ∑ i, y i * incidenceSum (pairSum y) i := by
      symm
      calc
        ∑ i, y i * incidenceSum (pairSum y) i =
            ∑ i : Fin 5, ∑ p : Pair 5,
              if i ∈ p.vertices then y i * pairSum y p else 0 := by
          apply Finset.sum_congr rfl
          intro i _
          simp only [incidenceSum, incidentPairs]
          rw [Finset.mul_sum]
          rw [← Finset.sum_filter]
        _ = ∑ p : Pair 5, ∑ i : Fin 5,
              if i ∈ p.vertices then y i * pairSum y p else 0 := by
          rw [Finset.sum_comm]
        _ = ∑ p : Pair 5, ∑ i ∈ p.vertices, y i * pairSum y p := by
          apply Finset.sum_congr rfl
          intro p _
          rw [← Finset.sum_filter]
          simp
        _ = ∑ p : Pair 5, pairSum y p ^ 2 := by
          apply Finset.sum_congr rfl
          intro p _
          rw [← Finset.sum_mul]
          simp only [pairSum, pow_two]
    _ = ∑ i, y i * (3 * y i) := by
      apply Finset.sum_congr rfl
      intro i _
      rw [incidenceSum_pairSum (by omega : 2 ≤ 5), hy, add_zero]
      norm_num
    _ = 3 * ∑ i, y i ^ 2 := by
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro i _
      ring

/-- The Gram scalar on the pair-sum four-space is nonzero. -/
theorem gramScalar_ne_zero : (140 / 1053 : ℚ) ≠ 0 := by
  norm_num

end RelativeConicArcs.PetersenHarmonicKernel
