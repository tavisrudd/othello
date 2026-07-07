import Sumfree.RankCounts

/-!
# Additive-equivalence invariance for SumFree rank-count predicates

The finite-abelian structure theorem provides additive equivalences to products
or direct sums of cyclic groups.  This file records that the rank-count
predicates used by the game layer are invariant under those equivalences.
-/

namespace Sumfree
namespace Game

variable {G H : Type*}
  [AddCommGroup G] [Fintype G] [DecidableEq G]
  [AddCommGroup H] [Fintype H] [DecidableEq H]

theorem orderTwoKernelElements_eq_map_addEquiv (e : G ≃+ H) :
    OrderTwoKernelElements (G := H) =
      (OrderTwoKernelElements (G := G)).map e.toEquiv.toEmbedding := by
  ext y
  constructor
  · intro hy
    refine Finset.mem_map.mpr ?_
    refine ⟨e.symm y, ?_, by simp⟩
    rw [mem_orderTwoKernelElements] at hy ⊢
    simpa using congrArg e.symm hy
  · intro hy
    rcases Finset.mem_map.mp hy with ⟨x, hx, rfl⟩
    rw [mem_orderTwoKernelElements] at hx ⊢
    simpa using congrArg e hx

theorem orderThreeKernelElements_eq_map_addEquiv (e : G ≃+ H) :
    OrderThreeKernelElements (G := H) =
      (OrderThreeKernelElements (G := G)).map e.toEquiv.toEmbedding := by
  ext y
  constructor
  · intro hy
    refine Finset.mem_map.mpr ?_
    refine ⟨e.symm y, ?_, by simp⟩
    rw [mem_orderThreeKernelElements] at hy ⊢
    simpa using congrArg e.symm hy
  · intro hy
    rcases Finset.mem_map.mp hy with ⟨x, hx, rfl⟩
    rw [mem_orderThreeKernelElements] at hx ⊢
    simpa using congrArg e hx

theorem orderTwoKernelElements_card_eq_of_addEquiv (e : G ≃+ H) :
    (OrderTwoKernelElements (G := H)).card =
      (OrderTwoKernelElements (G := G)).card := by
  rw [orderTwoKernelElements_eq_map_addEquiv e, Finset.card_map]

theorem orderThreeKernelElements_card_eq_of_addEquiv (e : G ≃+ H) :
    (OrderThreeKernelElements (G := H)).card =
      (OrderThreeKernelElements (G := G)).card := by
  rw [orderThreeKernelElements_eq_map_addEquiv e, Finset.card_map]

theorem hasTwoRank_of_addEquiv {s : ℕ} (e : G ≃+ H)
    (h : HasTwoRank G s) :
    HasTwoRank H s := by
  unfold HasTwoRank at h ⊢
  rw [orderTwoKernelElements_card_eq_of_addEquiv e, h]

theorem hasThreeRank_of_addEquiv {r : ℕ} (e : G ≃+ H)
    (h : HasThreeRank G r) :
    HasThreeRank H r := by
  unfold HasThreeRank at h ⊢
  rw [orderThreeKernelElements_card_eq_of_addEquiv e, h]

theorem hasTwoRank_addEquiv_iff {s : ℕ} (e : G ≃+ H) :
    HasTwoRank H s ↔ HasTwoRank G s :=
  ⟨hasTwoRank_of_addEquiv e.symm, hasTwoRank_of_addEquiv e⟩

theorem hasThreeRank_addEquiv_iff {r : ℕ} (e : G ≃+ H) :
    HasThreeRank H r ↔ HasThreeRank G r :=
  ⟨hasThreeRank_of_addEquiv e.symm, hasThreeRank_of_addEquiv e⟩

end Game
end Sumfree
