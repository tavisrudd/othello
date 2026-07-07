import Sumfree.CyclicRanks
import Sumfree.RankEquiv
import Sumfree.RankPi
import Mathlib.GroupTheory.FiniteAbelian.Basic

/-!
# Rank-count predicates from the finite abelian structure theorem

This file connects the abstract `HasTwoRank`/`HasThreeRank` interface to
mathlib's structure theorem for finite abelian groups.  The theorem here does
not try to choose canonical invariant factors; it uses the cyclic factors
returned by `AddCommGroup.equiv_directSum_zmod_of_finite'`.
-/

namespace Sumfree
namespace Game

open scoped DirectSum

variable (G : Type*) [AddCommGroup G] [Fintype G] [DecidableEq G]

/--
Every finite abelian group admits cyclic factors whose elementary cyclic
rank-counts assemble to the rank-count predicates for `G`.

The returned `n : ι -> ℕ` are the nontrivial cyclic moduli supplied by mathlib's
finite-abelian structure theorem.
-/
theorem exists_cyclic_factor_rank_counts :
    ∃ (ι : Type) (_ : Fintype ι) (n : ι → ℕ),
      (∀ i, 1 < n i) ∧
        HasTwoRank G (∑ i, CyclicZMod.zmodTwoRank (n i)) ∧
          HasThreeRank G (∑ i, CyclicZMod.zmodThreeRank (n i)) := by
  classical
  obtain ⟨ι, hι, n, hn, ⟨e⟩⟩ := AddCommGroup.equiv_directSum_zmod_of_finite' G
  letI : Fintype ι := hι
  letI : DecidableEq ι := Classical.decEq ι
  haveI : ∀ i, NeZero (n i) := fun i => ⟨by
    exact Nat.ne_of_gt (lt_trans Nat.zero_lt_one (hn i))⟩
  let ePi : G ≃+ (∀ i, ZMod (n i)) :=
    e.trans (DirectSum.addEquivProd fun i => ZMod (n i))
  have h2Pi :
      HasTwoRank (∀ i, ZMod (n i)) (∑ i, CyclicZMod.zmodTwoRank (n i)) :=
    hasTwoRank_pi (G := fun i => ZMod (n i)) (fun i => CyclicZMod.hasTwoRank_zmod (n := n i))
  have h3Pi :
      HasThreeRank (∀ i, ZMod (n i)) (∑ i, CyclicZMod.zmodThreeRank (n i)) :=
    hasThreeRank_pi (G := fun i => ZMod (n i)) (fun i => CyclicZMod.hasThreeRank_zmod (n := n i))
  refine ⟨ι, hι, n, hn, ?_, ?_⟩
  · exact (hasTwoRank_addEquiv_iff ePi).1 h2Pi
  · exact (hasThreeRank_addEquiv_iff ePi).1 h3Pi

end Game
end Sumfree
