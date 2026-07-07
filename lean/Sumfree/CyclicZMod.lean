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

/-- In an even nonzero cyclic group, `n / 2` is the nonzero order-two element. -/
theorem half_mem_nonzeroOrderTwoElements_of_even {n : ℕ} [NeZero n] (hn : Even n) :
    ((n / 2 : ℕ) : ZMod n) ∈ NonzeroOrderTwoElements (G := ZMod n) := by
  refine (mem_nonzeroOrderTwoElements (G := ZMod n) (v := ((n / 2 : ℕ) : ZMod n))).2
    ⟨?_, ?_⟩
  · have htwon : 2 * (n / 2) = n := Nat.two_mul_div_two_of_even hn
    have hcast : (((2 * (n / 2) : ℕ) : ZMod n) = 0) := by
      rw [htwon, ZMod.natCast_self]
    simpa [Nat.cast_mul, two_mul] using hcast
  · intro hzero
    have hdiv : n ∣ n / 2 := (ZMod.natCast_eq_zero_iff (n / 2) n).1 hzero
    have htwon : 2 * (n / 2) = n := Nat.two_mul_div_two_of_even hn
    have hhalf_pos : 0 < n / 2 := by
      by_contra hnot
      have hzero' : n / 2 = 0 := Nat.eq_zero_of_not_pos hnot
      have hnzero : n = 0 := by
        rw [← htwon, hzero', mul_zero]
      exact (NeZero.ne n) hnzero
    have hnpos : 0 < n := Nat.pos_iff_ne_zero.2 (NeZero.ne n)
    have hhalf_lt : n / 2 < n := Nat.div_lt_self hnpos (by decide : 1 < 2)
    exact (Nat.not_dvd_of_pos_of_lt hhalf_pos hhalf_lt) hdiv

/-- In an even nonzero cyclic group, every nonzero order-two element is `n / 2`. -/
theorem eq_half_of_mem_nonzeroOrderTwoElements {n : ℕ} [NeZero n] {x : ZMod n}
    (hx : x ∈ NonzeroOrderTwoElements (G := ZMod n)) :
    x = ((n / 2 : ℕ) : ZMod n) := by
  rcases (mem_nonzeroOrderTwoElements (G := ZMod n) (v := x)).1 hx with ⟨hx2, hx0⟩
  have hxneg : -x = x := by
    have h := congrArg (fun t => -x + t) hx2
    simpa [add_assoc] using h.symm
  rcases (ZMod.neg_eq_self_iff x).1 hxneg with hxzero | hxval
  · exact (hx0 hxzero).elim
  · have hxval' : x.val = n / 2 := by omega
    calc
      x = (x.val : ZMod n) := (ZMod.natCast_zmod_val x).symm
      _ = ((n / 2 : ℕ) : ZMod n) := by rw [hxval']

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

/--
The even cyclic, no-3-torsion cases of the mod-6 theorem: if `n` is even and
`3 ∤ n`, opening the unique order-two element wins.
-/
theorem initial_win_of_even_of_not_three_dvd {n : ℕ}
    [NeZero n] (hn : Even n) (h3 : ¬ 3 ∣ n) :
    Game.Win (∅ : Finset (ZMod n)) :=
  initial_win_of_unique_orderTwo_no_nonzero_orderThree
    (G := ZMod n)
    (m := ((n / 2 : ℕ) : ZMod n))
    (half_mem_nonzeroOrderTwoElements_of_even hn)
    (fun hx => eq_half_of_mem_nonzeroOrderTwoElements hx)
    (nonzeroOrderThreeElements_card_eq_zero_of_not_three_dvd h3)

end CyclicZMod
end Sumfree
