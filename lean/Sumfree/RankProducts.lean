import Sumfree.RankCounts

/-!
# Product rules for SumFree rank-count predicates

The rank-count interface is intentionally stated as cardinalities of concrete
torsion kernels.  This file records the direct-product behavior needed to build
finite-abelian examples compositionally.
-/

namespace Sumfree
namespace Game

variable {G H : Type*}
  [AddCommGroup G] [Fintype G] [DecidableEq G]
  [AddCommGroup H] [Fintype H] [DecidableEq H]

theorem orderTwoKernelElements_prod :
    OrderTwoKernelElements (G := G × H) =
      (OrderTwoKernelElements (G := G)).product
        (OrderTwoKernelElements (G := H)) := by
  ext x
  simp only [OrderTwoKernelElements, Finset.mem_filter, Finset.mem_univ, true_and,
    Finset.product_eq_sprod, Finset.mem_product]
  constructor
  · intro hx
    exact ⟨by simpa using congrArg Prod.fst hx, by simpa using congrArg Prod.snd hx⟩
  · intro hx
    ext <;> simp [hx.1, hx.2]

theorem orderThreeKernelElements_prod :
    OrderThreeKernelElements (G := G × H) =
      (OrderThreeKernelElements (G := G)).product
        (OrderThreeKernelElements (G := H)) := by
  ext x
  simp only [OrderThreeKernelElements, Finset.mem_filter, Finset.mem_univ, true_and,
    Finset.product_eq_sprod, Finset.mem_product]
  constructor
  · intro hx
    exact ⟨by simpa using congrArg Prod.fst hx, by simpa using congrArg Prod.snd hx⟩
  · intro hx
    ext <;> simp [hx.1, hx.2]

theorem orderTwoKernelElements_prod_card :
    (OrderTwoKernelElements (G := G × H)).card =
      (OrderTwoKernelElements (G := G)).card *
        (OrderTwoKernelElements (G := H)).card := by
  rw [orderTwoKernelElements_prod]
  simp [Finset.product_eq_sprod, Finset.card_product]

theorem orderThreeKernelElements_prod_card :
    (OrderThreeKernelElements (G := G × H)).card =
      (OrderThreeKernelElements (G := G)).card *
        (OrderThreeKernelElements (G := H)).card := by
  rw [orderThreeKernelElements_prod]
  simp [Finset.product_eq_sprod, Finset.card_product]

theorem hasTwoRank_prod {s t : ℕ}
    (hG : HasTwoRank G s) (hH : HasTwoRank H t) :
    HasTwoRank (G × H) (s + t) := by
  unfold HasTwoRank at hG hH ⊢
  rw [orderTwoKernelElements_prod_card, hG, hH, pow_add]

theorem hasThreeRank_prod {r u : ℕ}
    (hG : HasThreeRank G r) (hH : HasThreeRank H u) :
    HasThreeRank (G × H) (r + u) := by
  unfold HasThreeRank at hG hH ⊢
  rw [orderThreeKernelElements_prod_card, hG, hH, pow_add]

theorem hasRanks_prod {s t r u : ℕ}
    (h2G : HasTwoRank G s) (h2H : HasTwoRank H t)
    (h3G : HasThreeRank G r) (h3H : HasThreeRank H u) :
    HasTwoRank (G × H) (s + t) ∧ HasThreeRank (G × H) (r + u) :=
  ⟨hasTwoRank_prod h2G h2H, hasThreeRank_prod h3G h3H⟩

end Game
end Sumfree
