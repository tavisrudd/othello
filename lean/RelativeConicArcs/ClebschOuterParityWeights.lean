import Mathlib.Tactic

/-!
# Integer weights in the outer-parity channel

Let `q > 1` be an integer.  A torus weight indexed by `j` has the form
`j * (q - 1)`.  If its absolute value is strictly smaller than
`3 * (q - 1)`, then the index has absolute value smaller than three.
An odd index is consequently `1` or `-1`, so an odd-channel weight is
`q - 1` or `1 - q`.

These lemmas contain only the integer arithmetic in this reduction.  They
make no assertion about which weights occur in a representation or how an
outer group element acts on them.
-/

namespace RelativeConicArcs.ClebschOuterParityWeights

/-- Cancelling the positive factor `q - 1` transfers the strict weight bound
from `j * (q - 1)` to the index `j`. -/
theorem abs_index_lt_three {q j : ℤ} (hq : 1 < q)
    (hweight : |j * (q - 1)| < 3 * (q - 1)) :
    |j| < 3 := by
  have hq_sub_one : 0 < q - 1 := by omega
  rw [abs_mul, abs_of_pos hq_sub_one] at hweight
  nlinarith [abs_nonneg j]

/-- The only odd integers with absolute value strictly smaller than three
are `1` and `-1`. -/
theorem odd_eq_one_or_neg_one {j : ℤ} (hodd : Odd j)
    (hbound : |j| < 3) :
    j = 1 ∨ j = -1 := by
  have hj : -3 < j ∧ j < 3 := (abs_lt).mp hbound
  rcases hodd with ⟨k, hk⟩
  omega

/-- Under the strict weight bound, an odd torus-weight index is `1` or
`-1`. -/
theorem odd_index_eq_one_or_neg_one {q j : ℤ} (hq : 1 < q)
    (hweight : |j * (q - 1)| < 3 * (q - 1)) (hodd : Odd j) :
    j = 1 ∨ j = -1 :=
  odd_eq_one_or_neg_one hodd (abs_index_lt_three hq hweight)

/-- A weight of the form `j * (q - 1)` with odd index and absolute value
strictly below `3 * (q - 1)` is one of the two weights `q - 1` and
`1 - q`. -/
theorem odd_weight_eq_q_sub_one_or_one_sub_q {q j weight : ℤ}
    (hq : 1 < q) (hform : weight = j * (q - 1))
    (hbound : |weight| < 3 * (q - 1)) (hodd : Odd j) :
    weight = q - 1 ∨ weight = 1 - q := by
  subst weight
  rcases odd_index_eq_one_or_neg_one hq hbound hodd with hj | hj
  · left
    subst j
    ring
  · right
    subst j
    ring

end RelativeConicArcs.ClebschOuterParityWeights
