import RelativeConicArcs.ClebschDetectingModuleVanishings
import Mathlib.Data.ZMod.Basic

/-!
# Divided-power coefficients in the nested symmetric top slices

For a binary divided-power module of degree `d`, lowering one leaf by `r` contributes
`d.choose r`.  The quadratic target is the second symmetric square of a second symmetric square,
so its top vector has four leaves.  This module records the two coproduct distributions used by
the detecting arguments:

* lowering two selected leaves by `m` and `m-2`; and
* in characteristic three, lowering both leaves in either outer factor by three.

The latter has two outer placements, producing the coefficient `2 * (d.choose 3)^2`.  All
calculations are kernel reduction in `ZMod p`; no representation decomposition is assumed.
-/

namespace RelativeConicArcs.ClebschDividedPowerTopSlices

open ClebschDetectingModuleVanishings

/-- Coefficient of a fixed two-leaf coproduct distribution. -/
def twoLeafCoefficient (p d r s : ℕ) : ZMod p :=
  (Nat.choose d r : ZMod p) * Nat.choose d s

/-- Coefficient obtained by lowering both leaves in either of the two identical outer factors. -/
def eitherOuterPairCoefficient (p d r : ℕ) : ZMod p :=
  2 * (Nat.choose d r : ZMod p) ^ 2

/-- The two outer placements account for the factor two in the characteristic-three target
coefficient. -/
theorem eitherOuterPairCoefficient_eq (p d r : ℕ) :
    eitherOuterPairCoefficient p d r =
      (Nat.choose d r : ZMod p) ^ 2 + (Nat.choose d r : ZMod p) ^ 2 := by
  simp [eitherOuterPairCoefficient, two_mul]

/-- For `p=2m+3` and lowest digit `d₀=m`, the fixed distribution `(m,m-2)` has nonzero
coefficient modulo `p`.  Its total lowering order is `p-5`. -/
theorem twoLeafCoefficient_ne_zero
    {p m d tail : ℕ} (hp : p.Prime) (hpForm : p = 2 * m + 3)
    (hm : 2 ≤ m) (hd : d = m + p * tail) :
    twoLeafCoefficient p d m (m - 2) ≠ 0 := by
  subst p
  subst d
  have hm_lt : m < 2 * m + 3 := by omega
  have hsmall : m - 2 ≤ m := Nat.sub_le m 2
  have hfirstMod := choose_low_digit_modEq_one hp hm_lt (r := tail)
  have hfirst : (Nat.choose (m + (2 * m + 3) * tail) m : ZMod (2 * m + 3)) = 1 := by
    exact (ZMod.natCast_eq_natCast_iff _ _ _).2 hfirstMod
  have hsecondCoprime : (2 * m + 3).Coprime (Nat.choose m (m - 2)) :=
    choose_low_digit_coprime hp hm_lt hsmall
  letI : Fact (2 * m + 3).Prime := ⟨hp⟩
  have hsecondLucas := Choose.choose_modEq_choose_mod_mul_choose_div_nat
    (n := m + (2 * m + 3) * tail) (k := m - 2) (p := 2 * m + 3)
  have hsecondCast :
      (Nat.choose (m + (2 * m + 3) * tail) (m - 2) : ZMod (2 * m + 3)) =
        Nat.choose m (m - 2) := by
    apply (ZMod.natCast_eq_natCast_iff _ _ _).2
    simpa [Nat.mod_eq_of_lt hm_lt, Nat.div_eq_of_lt hm_lt,
        Nat.mod_eq_of_lt (lt_of_le_of_lt hsmall hm_lt),
        Nat.div_eq_of_lt (lt_of_le_of_lt hsmall hm_lt)] using hsecondLucas
  rw [twoLeafCoefficient, hfirst, one_mul, hsecondCast]
  rw [ne_eq, ZMod.natCast_eq_zero_iff]
  exact (hp.coprime_iff_not_dvd).1 hsecondCoprime

/-- The two selected lowering orders add to `p-5`. -/
theorem selected_lowering_orders_sum
    {p m : ℕ} (hpForm : p = 2 * m + 3) (hm : 2 ≤ m) :
    m + (m - 2) = p - 5 := by
  omega

/-- If the degree has base-three digits ending in `10`, then `d.choose 3` is one modulo three. -/
theorem choose_three_eq_one_in_characteristic_three (tail : ℕ) :
    (Nat.choose (3 + 9 * tail) 3 : ZMod 3) = 1 := by
  have hp : Nat.Prime 3 := by norm_num
  letI : Fact (Nat.Prime 3) := ⟨hp⟩
  have h := Choose.choose_modEq_choose_mod_mul_choose_div_nat
    (n := 3 + 9 * tail) (k := 3) (p := 3)
  have hdiv : (9 * tail) / 3 = 3 * tail := by omega
  have h' : Nat.choose (3 + 9 * tail) 3 ≡ Nat.choose (1 + 3 * tail) 1 [MOD 3] := by
    simpa [hdiv] using h
  have hlow := Choose.choose_modEq_choose_mod_mul_choose_div_nat
    (n := 1 + 3 * tail) (k := 1) (p := 3)
  have hlow' : Nat.choose (1 + 3 * tail) 1 ≡ 1 [MOD 3] := by
    simp at hlow ⊢
  exact (ZMod.natCast_eq_natCast_iff _ _ _).2 (h'.trans hlow')

/-- The characteristic-three outer-pair coefficient is exactly two and hence nonzero. -/
theorem eitherOuterPairCoefficient_characteristic_three (tail : ℕ) :
    eitherOuterPairCoefficient 3 (3 + 9 * tail) 3 = 2 := by
  rw [eitherOuterPairCoefficient, choose_three_eq_one_in_characteristic_three]
  norm_num

/-- The characteristic-three divided-power coefficient used by the detector does not vanish. -/
theorem eitherOuterPairCoefficient_characteristic_three_ne_zero (tail : ℕ) :
    eitherOuterPairCoefficient 3 (3 + 9 * tail) 3 ≠ 0 := by
  rw [eitherOuterPairCoefficient_characteristic_three]
  decide

end RelativeConicArcs.ClebschDividedPowerTopSlices
