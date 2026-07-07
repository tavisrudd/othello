import Sumfree.Game
import Mathlib.Data.ZMod.Basic
import Mathlib.Tactic

/-!
# Cyclic `ZMod n` sum-free game bridges

This file records concrete cyclic consequences of the abstract mirror theorems
in `Sumfree.Game`.  It is intentionally partial: the full mod-6 theorem still
needs the order-three extra-reply cases.
-/

namespace Sumfree
namespace CyclicZMod

open Sumfree.Game

/-- Odd cyclic groups have no nonzero order-two obstruction. -/
theorem nonzeroOrderTwoElements_card_eq_zero_of_odd {n : ℕ} [NeZero n] (hn : Odd n) :
    (NonzeroOrderTwoElements (G := ZMod n)).card = 0 := by
  apply Finset.card_eq_zero.mpr
  ext x
  constructor
  · intro hx
    rcases (mem_nonzeroOrderTwoElements (G := ZMod n) (v := x)).1 hx with ⟨hx2, hx0⟩
    exact (hx0 ((ZMod.add_self_eq_zero_iff_eq_zero hn).mp hx2)).elim
  · intro hx
    simp at hx

/-- If `3 ∤ n`, the cyclic order-three obstruction forces `x = 0`. -/
theorem eq_zero_of_orderThree_obstruction_of_not_three_dvd {n : ℕ}
    (h3 : ¬ 3 ∣ n) {x : ZMod n} (hx3 : x + x = -x) :
    x = 0 := by
  have hsum : x + x + x = 0 := by
    rw [hx3]
    simp
  have hmul : ((3 : ℕ) : ZMod n) * x = 0 := by
    calc
      ((3 : ℕ) : ZMod n) * x = ((2 : ZMod n) + 1) * x := by norm_num
      _ = (2 : ZMod n) * x + 1 * x := by rw [add_mul]
      _ = x + x + x := by rw [two_mul, one_mul]
      _ = 0 := hsum
  let u : (ZMod n)ˣ :=
    ZMod.unitOfCoprime 3 ((Nat.Prime.coprime_iff_not_dvd Nat.prime_three).2 h3)
  rw [← ZMod.coe_unitOfCoprime 3 ((Nat.Prime.coprime_iff_not_dvd Nat.prime_three).2 h3)] at hmul
  rw [mul_comm] at hmul
  exact (Units.mul_left_eq_zero u).mp hmul

/-- Cyclic groups with `3 ∤ n` have no nonzero order-three obstruction. -/
theorem nonzeroOrderThreeElements_card_eq_zero_of_not_three_dvd {n : ℕ} [NeZero n]
    (h3 : ¬ 3 ∣ n) :
    (NonzeroOrderThreeElements (G := ZMod n)).card = 0 := by
  apply Finset.card_eq_zero.mpr
  ext x
  constructor
  · intro hx
    rcases (mem_nonzeroOrderThreeElements (G := ZMod n) (v := x)).1 hx with ⟨hx3, hx0⟩
    exact (hx0 (eq_zero_of_orderThree_obstruction_of_not_three_dvd h3 hx3)).elim
  · intro hx
    simp at hx

/--
The odd cyclic, no-3-torsion cases of the mod-6 theorem: if `n` is odd and
`3 ∤ n`, the empty sum-free game on `ZMod n` is P.
-/
theorem initial_isP_of_odd_of_not_three_dvd {n : ℕ}
    [NeZero n] (hn : Odd n) (h3 : ¬ 3 ∣ n) :
    Game.IsP (∅ : Finset (ZMod n)) :=
  initial_isP_of_no_nonzero_orderTwo_or_three
    (G := ZMod n)
    (nonzeroOrderTwoElements_card_eq_zero_of_odd hn)
    (nonzeroOrderThreeElements_card_eq_zero_of_not_three_dvd h3)

end CyclicZMod
end Sumfree
