import Sumfree.FiniteAbelianRanks

/-!
# Canonical finite-abelian rank names

`HasTwoRank` and `HasThreeRank` are the transparent cardinality predicates used
by the game proofs.  This file packages them into canonical finite-abelian rank
names by choosing the unique witnesses whose existence follows from the finite
abelian structure theorem.
-/

namespace Sumfree
namespace Game

variable {G : Type*} [AddCommGroup G] [Fintype G] [DecidableEq G]

/-- The `HasTwoRank` witness is unique. -/
theorem hasTwoRank_unique {s t : ℕ} (hs : HasTwoRank G s) (ht : HasTwoRank G t) :
    s = t := by
  unfold HasTwoRank at hs ht
  exact (Nat.pow_right_injective (by decide : 2 ≤ (2 : ℕ))) (hs.symm.trans ht)

/-- The `HasThreeRank` witness is unique. -/
theorem hasThreeRank_unique {r u : ℕ} (hr : HasThreeRank G r) (hu : HasThreeRank G u) :
    r = u := by
  unfold HasThreeRank at hr hu
  exact (Nat.pow_right_injective (by decide : 2 ≤ (3 : ℕ))) (hr.symm.trans hu)

/-- Every finite abelian group has a two-rank witness. -/
theorem exists_twoRank (G : Type*) [AddCommGroup G] [Fintype G] [DecidableEq G] :
    ∃ s : ℕ, HasTwoRank G s := by
  classical
  obtain ⟨ι, hι, n, _hn, h2, _h3⟩ := exists_cyclic_factor_rank_counts G
  letI : Fintype ι := hι
  exact ⟨∑ i, CyclicZMod.zmodTwoRank (n i), h2⟩

/-- Every finite abelian group has a three-rank witness. -/
theorem exists_threeRank (G : Type*) [AddCommGroup G] [Fintype G] [DecidableEq G] :
    ∃ r : ℕ, HasThreeRank G r := by
  classical
  obtain ⟨ι, hι, n, _hn, _h2, h3⟩ := exists_cyclic_factor_rank_counts G
  letI : Fintype ι := hι
  exact ⟨∑ i, CyclicZMod.zmodThreeRank (n i), h3⟩

/-- The canonical two-rank of a finite abelian group for this game. -/
noncomputable def twoRank (G : Type*) [AddCommGroup G] [Fintype G] [DecidableEq G] : ℕ :=
  Classical.choose (exists_twoRank G)

/-- The canonical three-rank of a finite abelian group for this game. -/
noncomputable def threeRank (G : Type*) [AddCommGroup G] [Fintype G] [DecidableEq G] : ℕ :=
  Classical.choose (exists_threeRank G)

/-- The chosen `twoRank` satisfies the transparent rank-count predicate. -/
theorem hasTwoRank_twoRank (G : Type*) [AddCommGroup G] [Fintype G] [DecidableEq G] :
    HasTwoRank G (twoRank G) :=
  Classical.choose_spec (exists_twoRank G)

/-- The chosen `threeRank` satisfies the transparent rank-count predicate. -/
theorem hasThreeRank_threeRank (G : Type*) [AddCommGroup G] [Fintype G] [DecidableEq G] :
    HasThreeRank G (threeRank G) :=
  Classical.choose_spec (exists_threeRank G)

/-- Any transparent two-rank witness is the canonical `twoRank`. -/
theorem eq_twoRank_of_hasTwoRank {s : ℕ} (h : HasTwoRank G s) :
    s = twoRank G :=
  hasTwoRank_unique h (hasTwoRank_twoRank G)

/-- Any transparent three-rank witness is the canonical `threeRank`. -/
theorem eq_threeRank_of_hasThreeRank {r : ℕ} (h : HasThreeRank G r) :
    r = threeRank G :=
  hasThreeRank_unique h (hasThreeRank_threeRank G)

/-- Transparent two-rank witnesses are equivalent to equality with `twoRank`. -/
theorem hasTwoRank_iff_eq_twoRank {s : ℕ} :
    HasTwoRank G s ↔ s = twoRank G := by
  constructor
  · exact eq_twoRank_of_hasTwoRank
  · intro hs
    rw [hs]
    exact hasTwoRank_twoRank G

/-- Transparent three-rank witnesses are equivalent to equality with `threeRank`. -/
theorem hasThreeRank_iff_eq_threeRank {r : ℕ} :
    HasThreeRank G r ↔ r = threeRank G := by
  constructor
  · exact eq_threeRank_of_hasThreeRank
  · intro hr
    rw [hr]
    exact hasThreeRank_threeRank G

/-- Canonical-rank form of the proved `r_3 <= 1` P criterion. -/
theorem initial_isP_iff_rank_P_cases_of_threeRank_le_one
    (hr : threeRank G ≤ 1) :
    IsP (∅ : Finset G) ↔
      2 ≤ twoRank G ∨
        (twoRank G = 0 ∧ threeRank G = 0) ∨
        (twoRank G = 1 ∧ threeRank G = 1) :=
  initial_isP_iff_rank_count_P_cases_of_threeRank_le_one
    (G := G) (hasTwoRank_twoRank G) (hasThreeRank_threeRank G) hr

/-- Canonical-rank form of the proved `r_3 <= 1` N criterion. -/
theorem initial_win_iff_rank_N_cases_of_threeRank_le_one
    (hr : threeRank G ≤ 1) :
    Win (∅ : Finset G) ↔
      (twoRank G = 1 ∧ threeRank G = 0) ∨
      (twoRank G = 0 ∧ threeRank G = 1) :=
  initial_win_iff_rank_count_N_cases_of_threeRank_le_one
    (G := G) (hasTwoRank_twoRank G) (hasThreeRank_threeRank G) hr

end Game
end Sumfree
