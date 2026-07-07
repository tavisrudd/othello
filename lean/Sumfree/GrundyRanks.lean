import Sumfree.Grundy
import Sumfree.CanonicalRanks

/-!
# Grundy corollaries of the proved rank-count P criteria

The rank-count files prove P/N outcomes.  This file records the exact
zero-Grundy consequences for the P branches, using the generic
`isP_iff_grundy_eq_zero` bridge.
-/

namespace Sumfree
namespace Game

variable {G : Type*} [AddCommGroup G] [Fintype G] [DecidableEq G]

/-- Rank-count P branches have root Grundy value zero. -/
theorem initial_grundy_eq_zero_of_rank_count_P_cases {s r : ℕ}
    (h2 : HasTwoRank G s) (h3 : HasThreeRank G r)
    (h :
      2 ≤ s ∨
        (s = 0 ∧ r = 0) ∨
        (s = 1 ∧ r = 1)) :
    Grundy (∅ : Finset G) = 0 :=
  isP_iff_grundy_eq_zero.1
    (initial_isP_of_rank_count_P_cases (G := G) h2 h3 h)

/-- Rank-count form of the proved `r_3 <= 1` zero-Grundy criterion. -/
theorem initial_grundy_eq_zero_iff_rank_count_P_cases_of_threeRank_le_one {s r : ℕ}
    (h2 : HasTwoRank G s) (h3 : HasThreeRank G r) (hr : r ≤ 1) :
    Grundy (∅ : Finset G) = 0 ↔
      2 ≤ s ∨ (s = 0 ∧ r = 0) ∨ (s = 1 ∧ r = 1) := by
  rw [← isP_iff_grundy_eq_zero]
  exact initial_isP_iff_rank_count_P_cases_of_threeRank_le_one
    (G := G) h2 h3 hr

/-- Canonical-rank form of the proved `r_3 <= 1` zero-Grundy criterion. -/
theorem initial_grundy_eq_zero_iff_rank_P_cases_of_threeRank_le_one
    (hr : threeRank G ≤ 1) :
    Grundy (∅ : Finset G) = 0 ↔
      2 ≤ twoRank G ∨
        (twoRank G = 0 ∧ threeRank G = 0) ∨
        (twoRank G = 1 ∧ threeRank G = 1) := by
  rw [← isP_iff_grundy_eq_zero]
  exact initial_isP_iff_rank_P_cases_of_threeRank_le_one (G := G) hr

end Game
end Sumfree
