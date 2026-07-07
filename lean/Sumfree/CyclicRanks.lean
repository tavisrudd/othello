import Sumfree.CyclicZMod
import Sumfree.RankCounts

/-!
# Rank-count wrappers for cyclic groups

`Sumfree.CyclicZMod` proves the cyclic mod-six outcome theorem directly from
concrete obstruction counts.  This file exposes the same elementary cyclic
arithmetic through the shared `HasTwoRank`/`HasThreeRank` predicates.
-/

namespace Sumfree
namespace CyclicZMod

open Sumfree.Game

theorem nonzeroOrderTwoElements_card_eq_one_of_even {n : ℕ} [NeZero n] (hn : Even n) :
    (NonzeroOrderTwoElements (G := ZMod n)).card = 1 := by
  apply Finset.card_eq_one.mpr
  refine ⟨((n / 2 : ℕ) : ZMod n), ?_⟩
  ext x
  constructor
  · intro hx
    simpa using eq_half_of_mem_nonzeroOrderTwoElements hx
  · intro hx
    have hxEq : x = ((n / 2 : ℕ) : ZMod n) := by
      simpa using hx
    rw [hxEq]
    exact half_mem_nonzeroOrderTwoElements_of_even hn

theorem hasTwoRank_zmod_of_odd {n : ℕ} [NeZero n] (hn : Odd n) :
    HasTwoRank (ZMod n) 0 := by
  unfold HasTwoRank
  rw [orderTwoKernelElements_card, nonzeroOrderTwoElements_card_eq_zero_of_odd hn]
  norm_num

theorem hasTwoRank_zmod_of_even {n : ℕ} [NeZero n] (hn : Even n) :
    HasTwoRank (ZMod n) 1 := by
  unfold HasTwoRank
  rw [orderTwoKernelElements_card, nonzeroOrderTwoElements_card_eq_one_of_even hn]
  norm_num

theorem hasThreeRank_zmod_zero_of_not_three_dvd {n : ℕ} [NeZero n] (h3 : ¬ 3 ∣ n) :
    HasThreeRank (ZMod n) 0 := by
  unfold HasThreeRank
  rw [orderThreeKernelElements_card, nonzeroOrderThreeElements_card_eq_zero_of_not_three_dvd h3]
  norm_num

theorem third_ne_neg_third {k : ℕ} [NeZero (3 * k)] :
    (k : ZMod (3 * k)) ≠ -(k : ZMod (3 * k)) := by
  intro h
  have ht0 : (k : ZMod (3 * k)) ≠ 0 := third_ne_zero (k := k)
  have ht2zero : (k : ZMod (3 * k)) + (k : ZMod (3 * k)) = 0 := by
    have hleft := congrArg (fun z => z + (k : ZMod (3 * k))) h
    exact hleft.trans (by simp)
  have htnegzero : -(k : ZMod (3 * k)) = 0 := by
    simpa [third_add_self_eq_neg (k := k)] using ht2zero
  exact ht0 (by simpa using congrArg Neg.neg htnegzero)

theorem neg_third_add_self_eq_neg {k : ℕ} :
    (-(k : ZMod (3 * k))) + (-(k : ZMod (3 * k))) =
      -(-(k : ZMod (3 * k))) := by
  calc
    (-(k : ZMod (3 * k))) + (-(k : ZMod (3 * k))) =
        -((k : ZMod (3 * k)) + (k : ZMod (3 * k))) := by abel
    _ = -(-(k : ZMod (3 * k))) := by rw [third_add_self_eq_neg (k := k)]

theorem neg_third_ne_zero {k : ℕ} [NeZero (3 * k)] :
    -(k : ZMod (3 * k)) ≠ 0 := by
  intro h
  exact third_ne_zero (k := k) (by simpa using congrArg Neg.neg h)

theorem nonzeroOrderThreeElements_eq_pair_of_three_mul {k : ℕ} [NeZero (3 * k)] :
    NonzeroOrderThreeElements (G := ZMod (3 * k)) =
      {((k : ℕ) : ZMod (3 * k)), -((k : ℕ) : ZMod (3 * k))} := by
  ext x
  constructor
  · intro hx
    rcases (mem_nonzeroOrderThreeElements (G := ZMod (3 * k)) (v := x)).1 hx with ⟨hx3, hx0⟩
    rcases eq_zero_or_eq_third_or_eq_neg_third_of_orderThree (k := k) hx3 with
      hxzero | hxthird | hxneg
    · exact (hx0 hxzero).elim
    · simp [hxthird]
    · simp [hxneg]
  · intro hx
    simp only [Finset.mem_insert, Finset.mem_singleton] at hx
    rcases hx with hxthird | hxneg
    · rw [hxthird]
      exact (mem_nonzeroOrderThreeElements
        (G := ZMod (3 * k)) (v := ((k : ℕ) : ZMod (3 * k)))).2
        ⟨third_add_self_eq_neg (k := k), third_ne_zero (k := k)⟩
    · rw [hxneg]
      exact (mem_nonzeroOrderThreeElements
        (G := ZMod (3 * k)) (v := -((k : ℕ) : ZMod (3 * k)))).2
        ⟨neg_third_add_self_eq_neg (k := k), neg_third_ne_zero (k := k)⟩

theorem nonzeroOrderThreeElements_card_eq_two_of_three_mul {k : ℕ} [NeZero (3 * k)] :
    (NonzeroOrderThreeElements (G := ZMod (3 * k))).card = 2 := by
  rw [nonzeroOrderThreeElements_eq_pair_of_three_mul]
  simp [third_ne_neg_third (k := k)]

theorem hasThreeRank_zmod_one_of_three_mul {k : ℕ} [NeZero (3 * k)] :
    HasThreeRank (ZMod (3 * k)) 1 := by
  unfold HasThreeRank
  rw [orderThreeKernelElements_card, nonzeroOrderThreeElements_card_eq_two_of_three_mul]
  norm_num

end CyclicZMod
end Sumfree
