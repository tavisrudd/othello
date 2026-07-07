import Sumfree.FiniteAbelianRanks

/-!
# Finite abelian outcome wrappers for the proved rank range

`Sumfree.FiniteAbelianRanks` extracts noncanonical cyclic-factor rank counts
from mathlib's finite-abelian structure theorem.  This file combines those
counts with the currently proved SumFree game classification for the range
where the 3-rank is at most one.
-/

namespace Sumfree
namespace Game

variable (G : Type*) [AddCommGroup G] [Fintype G] [DecidableEq G]

/--
Every finite abelian group has cyclic factors whose extracted rank counts give
the exact initial P/N criteria in the proved `r_3 <= 1` range.

The cyclic factors are the noncanonical factors returned by mathlib's finite
abelian structure theorem; no canonical invariant-factor API is asserted here.
-/
theorem exists_cyclic_factor_rank_counts_with_outcome_of_threeRank_le_one :
    ∃ (ι : Type) (_ : Fintype ι) (n : ι → ℕ),
      (∀ i, 1 < n i) ∧
        HasTwoRank G (∑ i, CyclicZMod.zmodTwoRank (n i)) ∧
          HasThreeRank G (∑ i, CyclicZMod.zmodThreeRank (n i)) ∧
            ((∑ i, CyclicZMod.zmodThreeRank (n i)) ≤ 1 →
              (IsP (∅ : Finset G) ↔
                2 ≤ (∑ i, CyclicZMod.zmodTwoRank (n i)) ∨
                  ((∑ i, CyclicZMod.zmodTwoRank (n i)) = 0 ∧
                    (∑ i, CyclicZMod.zmodThreeRank (n i)) = 0) ∨
                  ((∑ i, CyclicZMod.zmodTwoRank (n i)) = 1 ∧
                    (∑ i, CyclicZMod.zmodThreeRank (n i)) = 1))) ∧
              ((∑ i, CyclicZMod.zmodThreeRank (n i)) ≤ 1 →
                (Win (∅ : Finset G) ↔
                  ((∑ i, CyclicZMod.zmodTwoRank (n i)) = 1 ∧
                    (∑ i, CyclicZMod.zmodThreeRank (n i)) = 0) ∨
                  ((∑ i, CyclicZMod.zmodTwoRank (n i)) = 0 ∧
                    (∑ i, CyclicZMod.zmodThreeRank (n i)) = 1))) := by
  classical
  obtain ⟨ι, hι, n, hn, h2, h3⟩ := exists_cyclic_factor_rank_counts G
  refine ⟨ι, hι, n, hn, h2, h3, ?_, ?_⟩
  · intro hr
    exact initial_isP_iff_rank_count_P_cases_of_threeRank_le_one
      (G := G) h2 h3 hr
  · intro hr
    exact initial_win_iff_rank_count_N_cases_of_threeRank_le_one
      (G := G) h2 h3 hr

end Game
end Sumfree
