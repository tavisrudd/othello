import Sumfree.CyclicRanks
import Sumfree.RankProducts

/-!
# Outcome wrappers for `ZMod 3 x ZMod n`

These are outcome-level corollaries of the rank-count classification.  They do
not assert the stronger Grundy/nimber statements from the compute notes.
-/

namespace Sumfree
namespace Game

open Sumfree.CyclicZMod

/-- `ZMod 3 x ZMod n` has no nonzero order-two obstruction when `n` is odd. -/
theorem hasTwoRank_zmod3_prod_zmod_of_odd {n : ℕ} [NeZero n] (hn : Odd n) :
    HasTwoRank (ZMod 3 × ZMod n) 0 := by
  have h3 : HasTwoRank (ZMod 3) 0 := by
    exact hasTwoRank_zmod_of_odd (n := 3) (by decide)
  have hn2 : HasTwoRank (ZMod n) 0 := hasTwoRank_zmod_of_odd hn
  simpa using hasTwoRank_prod (G := ZMod 3) (H := ZMod n) h3 hn2

/-- `ZMod 3 x ZMod n` has one order-two rank when `n` is even. -/
theorem hasTwoRank_zmod3_prod_zmod_of_even {n : ℕ} [NeZero n] (hn : Even n) :
    HasTwoRank (ZMod 3 × ZMod n) 1 := by
  have h3 : HasTwoRank (ZMod 3) 0 := by
    exact hasTwoRank_zmod_of_odd (n := 3) (by decide)
  have hn2 : HasTwoRank (ZMod n) 1 := hasTwoRank_zmod_of_even hn
  simpa using hasTwoRank_prod (G := ZMod 3) (H := ZMod n) h3 hn2

/-- `ZMod 3 x ZMod n` has one order-three rank when `3` does not divide `n`. -/
theorem hasThreeRank_zmod3_prod_zmod_of_not_three_dvd {n : ℕ} [NeZero n]
    (hn3 : ¬ 3 ∣ n) :
    HasThreeRank (ZMod 3 × ZMod n) 1 := by
  have h3 : HasThreeRank (ZMod 3) 1 := by
    simpa using hasThreeRank_zmod_one_of_three_mul (k := 1)
  have hn : HasThreeRank (ZMod n) 0 := hasThreeRank_zmod_zero_of_not_three_dvd hn3
  simpa using hasThreeRank_prod (G := ZMod 3) (H := ZMod n) h3 hn

/-- Odd `n` with `3 ∤ n`: the initial `ZMod 3 x ZMod n` game is N. -/
theorem initial_win_zmod3_prod_zmod_of_odd_not_three_dvd {n : ℕ} [NeZero n]
    (hn : Odd n) (hn3 : ¬ 3 ∣ n) :
    Win (∅ : Finset (ZMod 3 × ZMod n)) := by
  exact initial_win_of_rank_count_N_cases
    (G := ZMod 3 × ZMod n)
    (hasTwoRank_zmod3_prod_zmod_of_odd (n := n) hn)
    (hasThreeRank_zmod3_prod_zmod_of_not_three_dvd (n := n) hn3)
    (Or.inr ⟨rfl, rfl⟩)

/-- Even `n` with `3 ∤ n`: the initial `ZMod 3 x ZMod n` game is P. -/
theorem initial_isP_zmod3_prod_zmod_of_even_not_three_dvd {n : ℕ} [NeZero n]
    (hn : Even n) (hn3 : ¬ 3 ∣ n) :
    IsP (∅ : Finset (ZMod 3 × ZMod n)) := by
  exact initial_isP_of_rank_count_P_cases
    (G := ZMod 3 × ZMod n)
    (hasTwoRank_zmod3_prod_zmod_of_even (n := n) hn)
    (hasThreeRank_zmod3_prod_zmod_of_not_three_dvd (n := n) hn3)
    (Or.inr (Or.inr ⟨rfl, rfl⟩))

/-- Outcome-level warm-up: for `3 ∤ n`, the product is N exactly when `n` is odd. -/
theorem initial_win_zmod3_prod_zmod_iff_odd_of_not_three_dvd {n : ℕ} [NeZero n]
    (hn3 : ¬ 3 ∣ n) :
    Win (∅ : Finset (ZMod 3 × ZMod n)) ↔ Odd n := by
  constructor
  · intro hW
    by_cases hn : Even n
    · exact False.elim ((initial_isP_zmod3_prod_zmod_of_even_not_three_dvd
        (n := n) hn hn3) hW)
    · exact Nat.not_even_iff_odd.1 hn
  · intro hn
    exact initial_win_zmod3_prod_zmod_of_odd_not_three_dvd (n := n) hn hn3

/-- Outcome-level warm-up: for `3 ∤ n`, the product is P exactly when `n` is even. -/
theorem initial_isP_zmod3_prod_zmod_iff_even_of_not_three_dvd {n : ℕ} [NeZero n]
    (hn3 : ¬ 3 ∣ n) :
    IsP (∅ : Finset (ZMod 3 × ZMod n)) ↔ Even n := by
  constructor
  · intro hP
    by_cases hn : Even n
    · exact hn
    · exact False.elim (hP
        (initial_win_zmod3_prod_zmod_of_odd_not_three_dvd
          (n := n) (Nat.not_even_iff_odd.1 hn) hn3))
  · intro hn
    exact initial_isP_zmod3_prod_zmod_of_even_not_three_dvd (n := n) hn hn3

end Game
end Sumfree
