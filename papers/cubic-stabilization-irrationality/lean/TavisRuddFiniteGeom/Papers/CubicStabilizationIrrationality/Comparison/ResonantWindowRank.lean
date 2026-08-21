import Mathlib.Data.Nat.Choose.Sum

/-!
# The resonant rank of an alternating window transition

Špenko and Van den Bergh, *Perverse schobers and GKZ systems* (2020),
arXiv:2007.04924, Proposition 12.4(2), express a moved window generator as an
alternating sum indexed by the nonempty subsets of a nonempty transition set.
If every output generator has rank one, the rank of that sum is one.  The
theorem below isolates the finite identity responsible for this resonant rank
preservation.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.ResonantWindowRank

/-- The alternating coefficient of all nonempty subsets of a nonempty finite
set is one when the sign is `(-1)^(|I|+1)`. -/
theorem sum_nonempty_powerset_neg_one_pow_succ_card_eq_one
    {ι : Type*} [DecidableEq ι] {transition : Finset ι}
    (transitionNonempty : transition.Nonempty) :
    (∑ subset ∈ transition.powerset.erase ∅,
      (-1 : ℤ) ^ (subset.card + 1)) = 1 := by
  have totalSum :
      (∑ subset ∈ transition.powerset, (-1 : ℤ) ^ subset.card) = 0 :=
    Finset.sum_powerset_neg_one_pow_card_of_nonempty transitionNonempty
  have emptyMem : (∅ : Finset ι) ∈ transition.powerset := by simp
  have nonemptyUnshifted :
      (∑ subset ∈ transition.powerset.erase ∅,
        (-1 : ℤ) ^ subset.card) = -1 := by
    have split := Finset.sum_erase_add transition.powerset
      (fun subset ↦ (-1 : ℤ) ^ subset.card) emptyMem
    simp only [Finset.card_empty, pow_zero] at split
    omega
  calc
    (∑ subset ∈ transition.powerset.erase ∅,
        (-1 : ℤ) ^ (subset.card + 1)) =
        -(∑ subset ∈ transition.powerset.erase ∅,
          (-1 : ℤ) ^ subset.card) := by
      rw [← Finset.sum_neg_distrib]
      apply Finset.sum_congr rfl
      intro subset _
      rw [pow_succ]
      ring
    _ = 1 := by rw [nonemptyUnshifted]; norm_num

end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.ResonantWindowRank
