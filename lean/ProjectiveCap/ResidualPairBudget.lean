import ProjectiveCap.GridGame
import Mathlib.Data.Finset.Powerset

/-!
# Pair budgets for linear residual-gadget families

Overloaded load-zero lines in a projective residual form a linear family:
two distinct lines cannot contain the same pair of legal points.  This module
isolates the resulting pair-count argument from the game-semantic module.
-/

namespace ProjectiveCap
namespace ResidualHypergraph

variable {α : Type*} [DecidableEq α]

/--
A linear family of subsets spends disjoint unordered pairs: no two members of
the family contain the same two-element subset.
-/
def PairSupportsDisjoint (family : Finset (Finset α)) : Prop :=
  (family : Set (Finset α)).PairwiseDisjoint
    fun A => A.powersetCard 2

/--
Pair budget for a linear family.  If every member of `family` lies in `V` and
distinct members share no two-element subset, the sum of their pair counts is
at most the number of pairs in `V`.
-/
theorem pairBudget
    (V : Finset α) (family : Finset (Finset α))
    (hsub : ∀ A ∈ family, A ⊆ V)
    (hdisjoint : PairSupportsDisjoint family) :
    ∑ A ∈ family, Nat.choose A.card 2 ≤ Nat.choose V.card 2 := by
  calc
    ∑ A ∈ family, Nat.choose A.card 2 =
        ∑ A ∈ family, (A.powersetCard 2).card := by simp
    _ = (family.biUnion fun A => A.powersetCard 2).card := by
      exact (Finset.card_biUnion hdisjoint).symm
    _ ≤ (V.powersetCard 2).card := by
      apply Finset.card_le_card
      intro P hP
      rcases Finset.mem_biUnion.mp hP with ⟨A, hAfamily, hPA⟩
      exact Finset.powersetCard_mono (hsub A hAfamily) hPA
    _ = Nat.choose V.card 2 := Finset.card_powersetCard 2 V

/--
If every member of a linear family contains at least three vertices, three
times the number of members is bounded by the ambient pair budget.
-/
theorem three_mul_card_le_pairBudget
    (V : Finset α) (family : Finset (Finset α))
    (hsub : ∀ A ∈ family, A ⊆ V)
    (hdisjoint : PairSupportsDisjoint family)
    (hlarge : ∀ A ∈ family, 3 ≤ A.card) :
    3 * family.card ≤ Nat.choose V.card 2 := by
  calc
    3 * family.card = ∑ A ∈ family, 3 := by simp [mul_comm]
    _ ≤ ∑ A ∈ family, Nat.choose A.card 2 := by
      apply Finset.sum_le_sum
      intro A hA
      have hmono := Nat.choose_le_choose 2 (hlarge A hA)
      norm_num at hmono
      exact hmono
    _ ≤ Nat.choose V.card 2 := pairBudget V family hsub hdisjoint

/-- Division form of `three_mul_card_le_pairBudget`. -/
theorem card_le_pairBudget_div_three
    (V : Finset α) (family : Finset (Finset α))
    (hsub : ∀ A ∈ family, A ⊆ V)
    (hdisjoint : PairSupportsDisjoint family)
    (hlarge : ∀ A ∈ family, 3 ≤ A.card) :
    family.card ≤ Nat.choose V.card 2 / 3 := by
  apply (Nat.le_div_iff_mul_le (by omega : 0 < 3)).2
  simpa [mul_comm] using
    three_mul_card_le_pairBudget V family hsub hdisjoint hlarge

/--
Large members of a linear family are rare: their count, multiplied by the
number of pairs in an `r`-set, is at most the ambient pair budget.
-/
theorem choose_mul_largeMembers_card_le_pairBudget
    (V : Finset α) (family : Finset (Finset α)) (r : ℕ)
    (hsub : ∀ A ∈ family, A ⊆ V)
    (hdisjoint : PairSupportsDisjoint family) :
    Nat.choose r 2 * (family.filter fun A => r ≤ A.card).card ≤
      Nat.choose V.card 2 := by
  let large := family.filter fun A => r ≤ A.card
  have hlargeSub : ∀ A ∈ large, A ⊆ V := by
    intro A hA
    exact hsub A (Finset.mem_filter.mp hA).1
  have hlargeDisjoint : PairSupportsDisjoint large := by
    intro A hA B hB hAB
    exact hdisjoint (Finset.mem_filter.mp hA).1 (Finset.mem_filter.mp hB).1 hAB
  calc
    Nat.choose r 2 * large.card =
        ∑ A ∈ large, Nat.choose r 2 := by simp [mul_comm]
    _ ≤ ∑ A ∈ large, Nat.choose A.card 2 := by
      apply Finset.sum_le_sum
      intro A hA
      exact Nat.choose_le_choose 2 (Finset.mem_filter.mp hA).2
    _ ≤ Nat.choose V.card 2 :=
      pairBudget V large hlargeSub hlargeDisjoint

/-- Division form of the large-member bound. -/
theorem largeMembers_card_le_pairBudget_div_choose
    (V : Finset α) (family : Finset (Finset α)) (r : ℕ)
    (hr : 2 ≤ r)
    (hsub : ∀ A ∈ family, A ⊆ V)
    (hdisjoint : PairSupportsDisjoint family) :
    (family.filter fun A => r ≤ A.card).card ≤
      Nat.choose V.card 2 / Nat.choose r 2 := by
  apply (Nat.le_div_iff_mul_le (Nat.choose_pos hr)).2
  simpa [mul_comm] using
    choose_mul_largeMembers_card_le_pairBudget V family r hsub hdisjoint

/--
Each overloaded member spends at least three pairs for every unit of excess
over two vertices.
-/
theorem three_mul_sub_two_le_choose_two (n : ℕ) (hn : 3 ≤ n) :
    3 * (n - 2) ≤ Nat.choose n 2 := by
  obtain ⟨m, rfl⟩ := Nat.exists_eq_add_of_le hn
  induction m with
  | zero => norm_num
  | succ m ih =>
      rw [Nat.add_succ, Nat.choose_succ_left _ 2 (by omega)]
      norm_num [Nat.choose_one_right]
      omega

/--
The total overload `sum (|A|-2)` of a linear family is controlled by one
third of the ambient pair budget, stated without natural-number division.
-/
theorem three_mul_totalOverload_le_pairBudget
    (V : Finset α) (family : Finset (Finset α))
    (hsub : ∀ A ∈ family, A ⊆ V)
    (hdisjoint : PairSupportsDisjoint family)
    (hlarge : ∀ A ∈ family, 3 ≤ A.card) :
    3 * (∑ A ∈ family, (A.card - 2)) ≤ Nat.choose V.card 2 := by
  calc
    3 * (∑ A ∈ family, (A.card - 2)) =
        ∑ A ∈ family, 3 * (A.card - 2) := by
          simp [Finset.mul_sum]
    _ ≤ ∑ A ∈ family, Nat.choose A.card 2 := by
      apply Finset.sum_le_sum
      intro A hA
      exact three_mul_sub_two_le_choose_two A.card (hlarge A hA)
    _ ≤ Nat.choose V.card 2 := pairBudget V family hsub hdisjoint

/-- Division form of the total-overload bound. -/
theorem totalOverload_le_pairBudget_div_three
    (V : Finset α) (family : Finset (Finset α))
    (hsub : ∀ A ∈ family, A ⊆ V)
    (hdisjoint : PairSupportsDisjoint family)
    (hlarge : ∀ A ∈ family, 3 ≤ A.card) :
    (∑ A ∈ family, (A.card - 2)) ≤ Nat.choose V.card 2 / 3 := by
  apply (Nat.le_div_iff_mul_le (by omega : 0 < 3)).2
  simpa [mul_comm] using
    three_mul_totalOverload_le_pairBudget V family hsub hdisjoint hlarge

end ResidualHypergraph
end ProjectiveCap

#print axioms ProjectiveCap.ResidualHypergraph.totalOverload_le_pairBudget_div_three
