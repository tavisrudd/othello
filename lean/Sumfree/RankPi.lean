import Sumfree.RankCounts
import Mathlib.Data.Fintype.Pi

/-!
# Finite product rules for SumFree rank-count predicates

For finite dependent products, the two torsion kernels are the pointwise
products of the component kernels.  This is the product form most directly
compatible with finite direct sums after `DirectSum.addEquivProd`.
-/

namespace Sumfree
namespace Game

variable {ι : Type*} [Fintype ι] [DecidableEq ι]
variable {G : ι → Type*}
  [∀ i, AddCommGroup (G i)] [∀ i, Fintype (G i)] [∀ i, DecidableEq (G i)]

theorem orderTwoKernelElements_pi :
    OrderTwoKernelElements (G := ∀ i, G i) =
      Fintype.piFinset (fun i => OrderTwoKernelElements (G := G i)) := by
  ext x
  rw [mem_orderTwoKernelElements_iff_two_nsmul, Fintype.mem_piFinset]
  constructor
  · intro hx i
    rw [mem_orderTwoKernelElements_iff_two_nsmul]
    simpa using congrFun hx i
  · intro hx
    funext i
    have hi : (2 : ℕ) • x i = 0 :=
      (mem_orderTwoKernelElements_iff_two_nsmul (G := G i)).1 (hx i)
    simpa using hi

theorem orderThreeKernelElements_pi :
    OrderThreeKernelElements (G := ∀ i, G i) =
      Fintype.piFinset (fun i => OrderThreeKernelElements (G := G i)) := by
  ext x
  rw [mem_orderThreeKernelElements_iff_three_nsmul, Fintype.mem_piFinset]
  constructor
  · intro hx i
    rw [mem_orderThreeKernelElements_iff_three_nsmul]
    simpa using congrFun hx i
  · intro hx
    funext i
    have hi : (3 : ℕ) • x i = 0 :=
      (mem_orderThreeKernelElements_iff_three_nsmul (G := G i)).1 (hx i)
    simpa using hi

theorem orderTwoKernelElements_pi_card :
    (OrderTwoKernelElements (G := ∀ i, G i)).card =
      ∏ i, (OrderTwoKernelElements (G := G i)).card := by
  rw [orderTwoKernelElements_pi]
  simp [Fintype.card_piFinset]

theorem orderThreeKernelElements_pi_card :
    (OrderThreeKernelElements (G := ∀ i, G i)).card =
      ∏ i, (OrderThreeKernelElements (G := G i)).card := by
  rw [orderThreeKernelElements_pi]
  simp [Fintype.card_piFinset]

theorem hasTwoRank_pi {s : ι → ℕ}
    (h : ∀ i, HasTwoRank (G i) (s i)) :
    HasTwoRank (∀ i, G i) (∑ i, s i) := by
  unfold HasTwoRank at h ⊢
  rw [orderTwoKernelElements_pi_card]
  simp_rw [h]
  simpa using (Finset.prod_pow_eq_pow_sum (Finset.univ : Finset ι) s 2)

theorem hasThreeRank_pi {r : ι → ℕ}
    (h : ∀ i, HasThreeRank (G i) (r i)) :
    HasThreeRank (∀ i, G i) (∑ i, r i) := by
  unfold HasThreeRank at h ⊢
  rw [orderThreeKernelElements_pi_card]
  simp_rw [h]
  simpa using (Finset.prod_pow_eq_pow_sum (Finset.univ : Finset ι) r 3)

theorem hasRanks_pi {s r : ι → ℕ}
    (h2 : ∀ i, HasTwoRank (G i) (s i))
    (h3 : ∀ i, HasThreeRank (G i) (r i)) :
    HasTwoRank (∀ i, G i) (∑ i, s i) ∧
      HasThreeRank (∀ i, G i) (∑ i, r i) :=
  ⟨hasTwoRank_pi h2, hasThreeRank_pi h3⟩

end Game
end Sumfree
