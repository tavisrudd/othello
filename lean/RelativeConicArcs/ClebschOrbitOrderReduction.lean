import Mathlib.Tactic

/-!
# Orbit-order reduction for balanced conic-matching sheets

Suppose an odd integer `q ≥ 5` indexes two sheets of size `q` in an action whose point stabilizer
has order `k`.  The orbit--stabilizer calculation in the balanced matching problem gives

`2 * k = q * q - 1`.

If the stabilizer is one of the exceptional projective subgroups, its order is at most `60`.
The equation then leaves only `q = 5, 7, 9, 11`.  Order `40`, required when `q = 9`, is not an
exceptional subgroup order; the other three values force orders `12`, `24`, and `60`.

This module proves only that arithmetic reduction.  Identifying the stabilizer as exceptional and
classifying its invariant matchings are separate group-theoretic statements.
-/

namespace RelativeConicArcs.ClebschOrbitOrderReduction

/-- An odd natural number between five and eleven is one of `5, 7, 9, 11`. -/
theorem odd_interval_candidates {q : ℕ} (hqOdd : Odd q) (hqLower : 5 ≤ q) (hqUpper : q ≤ 11) :
    q = 5 ∨ q = 7 ∨ q = 9 ∨ q = 11 := by
  obtain ⟨r, hr⟩ := hqOdd
  omega

/-- The exceptional-subgroup order bound, together with
`2 * k = q² - 1`, restricts an odd `q ≥ 5` to `5, 7, 9, 11`. -/
theorem exceptional_order_candidates {q k : ℕ} (hqOdd : Odd q) (hqLower : 5 ≤ q)
    (hstabilizer : 2 * k = q * q - 1) (hk : k ≤ 60) :
    q = 5 ∨ q = 7 ∨ q = 9 ∨ q = 11 := by
  have hsq : q * q = 2 * k + 1 := by
    have hqPositive : 0 < q := by omega
    have hpositive : 1 ≤ q * q := Nat.mul_pos hqPositive hqPositive
    calc
      q * q = (q * q - 1) + 1 := (Nat.sub_add_cancel hpositive).symm
      _ = 2 * k + 1 := by rw [← hstabilizer]
  have hqUpper : q ≤ 11 := by
    nlinarith
  exact odd_interval_candidates hqOdd hqLower hqUpper

/-- The four candidate field sizes force stabilizer orders `12`, `24`, `40`, and `60`. -/
theorem candidate_stabilizer_orders {q k : ℕ}
    (hq : q = 5 ∨ q = 7 ∨ q = 9 ∨ q = 11)
    (hstabilizer : 2 * k = q * q - 1) :
    (q = 5 ∧ k = 12) ∨ (q = 7 ∧ k = 24) ∨
      (q = 9 ∧ k = 40) ∨ (q = 11 ∧ k = 60) := by
  rcases hq with rfl | rfl | rfl | rfl <;> omega

/-- Order `40`, required at `q = 9`, is not one of the exceptional orders
`12`, `24`, or `60`. -/
theorem order_forty_not_exceptional (h : 40 = 12 ∨ 40 = 24 ∨ 40 = 60) : False := by
  omega

/-- If a candidate stabilizer has exceptional order `12`, `24`, or `60`, then the `q = 9`
branch is impossible and the three remaining `(q,k)` pairs are forced. -/
theorem exceptional_pairs {q k : ℕ}
    (hq : q = 5 ∨ q = 7 ∨ q = 9 ∨ q = 11)
    (hstabilizer : 2 * k = q * q - 1)
    (hk : k = 12 ∨ k = 24 ∨ k = 60) :
    (q = 5 ∧ k = 12) ∨ (q = 7 ∧ k = 24) ∨ (q = 11 ∧ k = 60) := by
  rcases candidate_stabilizer_orders hq hstabilizer with h | h | h | h
  · exact Or.inl h
  · exact Or.inr (Or.inl h)
  · rcases h with ⟨rfl, rfl⟩
    exact (order_forty_not_exceptional hk).elim
  · exact Or.inr (Or.inr h)

end RelativeConicArcs.ClebschOrbitOrderReduction
