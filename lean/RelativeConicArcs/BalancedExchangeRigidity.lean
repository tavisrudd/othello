import RelativeConicArcs.ConferenceCutBlocks

/-!
# Cut dependence of the fourth trace of a conference matrix

Let `C` be a symmetric matrix with zero diagonal and off-diagonal entries
squaring to one, on a label set of size `N`, and suppose `C * C = q • 1`.  For
a set `Y` of labels the sum

```
Σ_{i, j, k, l ∈ Y} C i j * C j k * C k l * C l i
```

is the fourth trace of the principal block of `C` on `Y`, the quantity whose
`Y`-dependence controls the second exchange moment of the cut at `Y`.

This module proves that for `N = 2d` with `4 ≤ d` that sum is *not* the same
for every balanced half `Y`.  The route is arithmetic rather than
combinatorial.  If the fourth traces of all balanced halves agreed, then the
four-subset sums of the closed four-walk weights would agree, so by the
inclusion-sum swap descent every four-set of labels would carry the same weight
`w`.  Summing the support-sorted fourth trace over all labels then pins `w`:
the diagonal of `C * C = q • 1` forces `q = N - 1`, the fourth trace is
`N (N-1)²`, and comparing it with `N(N-1) + 12·C(N,3) + C(N,4)·w` gives
`(N - 3) w = -24`.  Since a four-set weight is `24` or `-8`, that leaves
`N = 2` or `N = 6`, and `N = 2d ≥ 8` is excluded.

The exponent `-8` at `N = 6` is not an accident: the order-six symmetric
conference matrix has no aligned four-set, all fifteen of its four-sets carry
weight `-8`, and `(6 - 3)·(-8) = -24`.  The argument above is therefore sharp
at the one order it does not exclude.

Replacing the switching normalization and the bound `R(3,3) = 6` by this
counting step is a change of proof, not of statement; the Ramsey bound is
proved independently in `RelativeConicArcs.AlignedTwoGraph`.
-/

namespace RelativeConicArcs.BalancedExchangeRigidity

open Finset RelativeConicArcs.ConferenceCutBlocks

variable {R : Type*} [CommRing R] [CharZero R] [NoZeroDivisors R]
  {n : Type*} [Fintype n] [DecidableEq n]

/-- The fourth trace of the principal block of a symmetric conference matrix on
a balanced half is not independent of the half, once each half has at least
four labels.  Equivalently, the second exchange moment of the cut is
cut-dependent for every order `2d` with `4 ≤ d`. -/
theorem not_forall_sum_walkTerm_eq (C : Matrix n n R) (hdiag : ∀ i, C i i = 0)
    (hsym : ∀ i j, C j i = C i j) (hsq : ∀ i j, i ≠ j → C i j * C i j = 1)
    {q : R} (hCC : C * C = q • 1) {d : ℕ} (hd : 4 ≤ d)
    (hn : Fintype.card n = 2 * d) (c : R) :
    ¬ ∀ Y ⊆ (univ : Finset n), Y.card = d →
      (∑ i ∈ Y, ∑ j ∈ Y, ∑ k ∈ Y, ∑ l ∈ Y, C i j * C j k * C k l * C l i) = c := by
  intro hconst
  have hone : ∀ i j : n, i ≠ j → C i j * C j i = 1 := by
    intro i j hij
    rw [hsym i j]
    exact hsq i j hij
  have hNpos : 8 ≤ Fintype.card n := by omega
  -- the four-subset weight sums agree on balanced halves
  have hweights : ∀ Y ⊆ (univ : Finset n), Y.card = d →
      ∑ K ∈ Y.powersetCard 4, closedFourWalkSum C K
        = c - ((d : R) * ((d : R) - 1) + 12 * (d.choose 3 : R)) := by
    intro Y hY hYc
    have hsum := sum_walkTerm_eq_add_sum_powersetCard C hdiag hone Y
    rw [hconst Y hY hYc, hYc] at hsum
    linear_combination -hsum
  -- every four-set carries the same weight
  obtain ⟨K₀, hK₀sub, hK₀card⟩ :=
    Finset.exists_subset_card_eq (s := (univ : Finset n)) (n := 4)
      (by rw [Finset.card_univ]; omega)
  have hallw : ∀ K ∈ (univ : Finset n).powersetCard 4,
      closedFourWalkSum C K = closedFourWalkSum C K₀ := by
    intro K hK
    exact closedFourWalkSum_eq_of_sum_eq C hd hn hweights K
      (Finset.mem_powersetCard.mp hK).1 (Finset.mem_powersetCard.mp hK).2 K₀ hK₀sub hK₀card
  -- the fourth trace over all labels
  have hcast_ne : ∀ k : ℕ, k ≠ Fintype.card n → (Fintype.card n : R) - (k : R) ≠ 0 := by
    intro k hk hzero
    apply hk
    have hc : ((k : ℕ) : R) = ((Fintype.card n : ℕ) : R) := by linear_combination -hzero
    exact_mod_cast hc
  have hN0 : (Fintype.card n : R) ≠ 0 := by simpa using hcast_ne 0 (by omega)
  have hN1 : (Fintype.card n : R) - 1 ≠ 0 := by simpa using hcast_ne 1 (by omega)
  have hN2 : (Fintype.card n : R) - 2 ≠ 0 := by
    have h := hcast_ne 2 (by omega)
    push_cast at h
    exact h
  have hN6 : (Fintype.card n : R) - 6 ≠ 0 := by
    have h := hcast_ne 6 (by omega)
    push_cast at h
    exact h
  have hqval : q = (Fintype.card n : R) - 1 := by
    have h1 : Matrix.trace (C * C) = (Fintype.card n : R) * ((Fintype.card n : R) - 1) :=
      trace_mul_self C hdiag hone
    rw [hCC, Matrix.trace_smul, Matrix.trace_one, smul_eq_mul] at h1
    have hfac : (Fintype.card n : R) * (q - ((Fintype.card n : R) - 1)) = 0 := by
      linear_combination h1
    rcases mul_eq_zero.mp hfac with h | h
    · exact absurd h hN0
    · linear_combination h
  have htrace : Matrix.trace (C * C * C * C) = (Fintype.card n : R) * (q * q) := by
    have hsq4 : C * C * C * C = (q * q) • (1 : Matrix n n R) := by
      calc C * C * C * C = (C * C) * (C * C) := by rw [mul_assoc]
        _ = (q • (1 : Matrix n n R)) * (q • (1 : Matrix n n R)) := by rw [hCC]
        _ = (q * q) • (1 : Matrix n n R) := by
            simp [smul_smul]
    rw [hsq4, Matrix.trace_smul, Matrix.trace_one, smul_eq_mul, mul_comm]
  -- the support-sorted fourth trace pins the common weight
  have hcount : ∑ K ∈ (univ : Finset n).powersetCard 4, closedFourWalkSum C K
      = ((Fintype.card n).choose 4 : R) * closedFourWalkSum C K₀ := by
    rw [Finset.sum_congr rfl hallw, Finset.sum_const, Finset.card_powersetCard,
      Finset.card_univ, nsmul_eq_mul]
  have heq : (Fintype.card n : R) * (((Fintype.card n : R) - 1) * ((Fintype.card n : R) - 1))
      = (Fintype.card n : R) * ((Fintype.card n : R) - 1)
        + 12 * ((Fintype.card n).choose 3 : R)
        + ((Fintype.card n).choose 4 : R) * closedFourWalkSum C K₀ := by
    have := trace_pow_four C hdiag hone
    rw [htrace, hqval, hcount] at this
    linear_combination this
  -- the two binomial coefficients as polynomials in the number of labels
  have hc3 : 12 * ((Fintype.card n).choose 3 : R)
      = 2 * (Fintype.card n : R) * ((Fintype.card n : R) - 1) * ((Fintype.card n : R) - 2) := by
    have hnat : 12 * (Fintype.card n).choose 3
        = 2 * (Fintype.card n * ((Fintype.card n - 1) * (Fintype.card n - 2))) := by
      have hfac : (Fintype.card n).descFactorial 3 = 6 * (Fintype.card n).choose 3 := by
        rw [Nat.descFactorial_eq_factorial_mul_choose]
        norm_num [Nat.factorial]
      have hval : (Fintype.card n).descFactorial 3
          = (Fintype.card n - 2) * ((Fintype.card n - 1) * Fintype.card n) := by
        simp [Nat.descFactorial]
      calc 12 * (Fintype.card n).choose 3
          = 2 * (6 * (Fintype.card n).choose 3) := by ring
        _ = 2 * ((Fintype.card n - 2) * ((Fintype.card n - 1) * Fintype.card n)) := by
            rw [← hfac, hval]
        _ = 2 * (Fintype.card n * ((Fintype.card n - 1) * (Fintype.card n - 2))) := by ring
    have hcast := congrArg (fun m : ℕ => (m : R)) hnat
    push_cast [Nat.cast_sub (show 1 ≤ Fintype.card n by omega),
      Nat.cast_sub (show 2 ≤ Fintype.card n by omega)] at hcast
    linear_combination hcast
  have hc4 : 24 * ((Fintype.card n).choose 4 : R)
      = (Fintype.card n : R) * ((Fintype.card n : R) - 1) * ((Fintype.card n : R) - 2)
        * ((Fintype.card n : R) - 3) := by
    have hnat : 24 * (Fintype.card n).choose 4
        = Fintype.card n * ((Fintype.card n - 1) * ((Fintype.card n - 2)
            * (Fintype.card n - 3))) := by
      have hfac : (Fintype.card n).descFactorial 4 = 24 * (Fintype.card n).choose 4 := by
        rw [Nat.descFactorial_eq_factorial_mul_choose]
        norm_num [Nat.factorial]
      have hval : (Fintype.card n).descFactorial 4
          = (Fintype.card n - 3) * ((Fintype.card n - 2)
              * ((Fintype.card n - 1) * Fintype.card n)) := by
        simp [Nat.descFactorial]
      calc 24 * (Fintype.card n).choose 4
          = (Fintype.card n).descFactorial 4 := hfac.symm
        _ = (Fintype.card n - 3) * ((Fintype.card n - 2)
              * ((Fintype.card n - 1) * Fintype.card n)) := hval
        _ = Fintype.card n * ((Fintype.card n - 1) * ((Fintype.card n - 2)
              * (Fintype.card n - 3))) := by ring
    have hcast := congrArg (fun m : ℕ => (m : R)) hnat
    push_cast [Nat.cast_sub (show 1 ≤ Fintype.card n by omega),
      Nat.cast_sub (show 2 ≤ Fintype.card n by omega),
      Nat.cast_sub (show 3 ≤ Fintype.card n by omega)] at hcast
    linear_combination hcast
  have hfactor : (Fintype.card n : R) * ((Fintype.card n : R) - 1) * ((Fintype.card n : R) - 2)
      * ((((Fintype.card n : R) - 3) * closedFourWalkSum C K₀) + 24) = 0 := by
    linear_combination (-24 : R) * heq + (-24 : R) * hc3 +
      (-(closedFourWalkSum C K₀)) * hc4
  have hpin : (((Fintype.card n : R) - 3) * closedFourWalkSum C K₀) + 24 = 0 := by
    rcases mul_eq_zero.mp hfactor with h | h
    · rcases mul_eq_zero.mp h with h' | h'
      · rcases mul_eq_zero.mp h' with h'' | h''
        · exact absurd h'' hN0
        · exact absurd h'' hN1
      · exact absurd h' hN2
    · exact h
  -- a four-set weight is 24 or -8, and neither is compatible with the pin
  have hdich : (closedFourWalkSum C K₀ - 24) * (closedFourWalkSum C K₀ + 8) = 0 :=
    closedFourWalkSum_eq_twentyFour_or_neg_eight C hsym hsq hK₀card
  rcases mul_eq_zero.mp hdich with h | h
  · have hw : closedFourWalkSum C K₀ = 24 := by linear_combination h
    rw [hw] at hpin
    have h24 : (24 : R) * ((Fintype.card n : R) - 2) = 0 := by linear_combination hpin
    rcases mul_eq_zero.mp h24 with hz | hz
    · norm_num at hz
    · exact hN2 hz
  · have hw : closedFourWalkSum C K₀ = -8 := by linear_combination h
    rw [hw] at hpin
    have h8 : (8 : R) * ((Fintype.card n : R) - 6) = 0 := by linear_combination -hpin
    rcases mul_eq_zero.mp h8 with hz | hz
    · norm_num at hz
    · exact hN6 hz

end RelativeConicArcs.BalancedExchangeRigidity
