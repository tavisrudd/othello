import Mathlib.Data.Nat.Choose.Dvd
import Mathlib.Data.Nat.Choose.Lucas
import Mathlib.Tactic

/-!
# Arithmetic exclusions for the detecting modules

This module records the weight and coefficient calculations used to exclude the four detecting
sources in the quadratic target.  The first two results compare the Steinberg and prime-field
source heads with the possible target heads.  The remaining results isolate the low Frobenius
digit of the divided-power coefficients used at the `L(q-7)` endpoint.

The declarations prove integer and binomial-coefficient statements.  They do not construct
representations of `SL₂`, identify a tilting decomposition, or identify a divided-power vector
with a vector in a symmetric-power representation.
-/

namespace RelativeConicArcs.ClebschDetectingModuleVanishings

/-- The Steinberg first-Frobenius head lies four weights above the quadratic target ceiling. -/
theorem steinberg_head_above_quadratic_ceiling {q : ℤ} :
    2 * q - 6 < 2 * q - 2 := by
  omega

/-- A prime-field first-Frobenius candidate with lower digit `s+1` cannot equal a restricted
simple socle weight, since the former is at least `p` and the latter is below `p`. -/
theorem upper_prime_candidate_ne_restricted_socle {p s r : ℕ}
    (hr : r < p) :
    p + (s + 1) ≠ r := by
  omega

/-- A prime-field first-Frobenius candidate with lower digit `s-1` cannot equal a restricted
simple socle weight when the detecting weight is at least two. -/
theorem lower_prime_candidate_ne_restricted_socle {p s r : ℕ}
    (hr : r < p) :
    p + (s - 1) ≠ r := by
  omega

/-- The weight `2q-8` is not primitive in the displayed two-dimensional top slice: a raising map
sending its generator to four times the top generator is nonzero away from characteristic two. -/
theorem next_weight_generator_not_primitive {K : Type*} [Field K]
    (hfour : (4 : K) ≠ 0) {X Y : K} (hX : X ≠ 0)
    (raising : K →ₗ[K] K) (hraise : raising Y = 4 * X) :
    raising Y ≠ 0 := by
  rw [hraise]
  exact mul_ne_zero hfour hX

/-- Lucas reduction at the lowest digit: if `d = a + p r` and `a < p`, then `d choose a` is
congruent to one modulo the prime `p`. -/
theorem choose_low_digit_modEq_one {p a r : ℕ} (hp : p.Prime) (ha : a < p) :
    Nat.choose (a + p * r) a ≡ 1 [MOD p] := by
  letI : Fact p.Prime := ⟨hp⟩
  have h := Choose.choose_modEq_choose_mod_mul_choose_div_nat
    (n := a + p * r) (k := a) (p := p)
  simpa [Nat.add_mod, ha, Nat.mod_eq_of_lt ha, Nat.div_eq_of_lt ha] using h

/-- A binomial coefficient wholly inside the lowest base-`p` digit is prime to `p`. -/
theorem choose_low_digit_coprime {p a b : ℕ} (hp : p.Prime)
    (ha : a < p) (hb : b ≤ a) :
    p.Coprime (Nat.choose a b) :=
  hp.coprime_choose_of_lt ha hb

/-- The coefficient used in the characteristic-three endpoint is nonzero once its Lucas value
is known to be one: `2 * C^2` reduces to `2` in `ZMod 3`. -/
theorem characteristic_three_lowering_coefficient
    {c : ZMod 3} (hc : c = 1) :
    2 * c ^ 2 = 2 := by
  subst c
  norm_num

/-- Vanishing of the characteristic-three top coefficient forces its scalar multiplier to
vanish, because that coefficient is exactly two. -/
theorem characteristic_three_scalar_eq_zero {alpha : ZMod 3}
    (h : alpha * 2 = 0) :
    alpha = 0 := by
  have htwo : (2 : ZMod 3) ≠ 0 := by decide
  exact (mul_eq_zero.mp h).resolve_right htwo

end RelativeConicArcs.ClebschDetectingModuleVanishings
