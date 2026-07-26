import Mathlib

/-!
# Splitting an involutive algebra by an odd unit

Let `κ` be an involutive automorphism of a commutative ring in which two is
invertible.  Averaging with `κ` decomposes every element into invariant and
anti-invariant parts.  If an anti-invariant element `c` is a unit, multiplication
by `c` identifies the invariant part with the anti-invariant part, so every
element has a unique expression `a + c * b` with `a` and `b` invariant.

The final theorem applies this mechanism after localizing away from `c ^ 2`.
The localization and its involution are hypotheses; no construction of an
involution by a localization universal property is used.
-/

namespace RelativeConicArcs.InvolutiveOddUnit

variable {R : Type*} [CommRing R]

/-- The elements fixed by a ring automorphism. -/
def Invariant (κ : R ≃+* R) := {x : R // κ x = x}

/-- The elements negated by a ring automorphism. -/
def AntiInvariant (κ : R ≃+* R) := {x : R // κ x = -x}

variable (κ : R ≃+* R) (hκ : Function.Involutive κ)

/-- Averaging an element with its image under the involution gives its even
part. -/
noncomputable def evenPart [Invertible (2 : R)] (x : R) : R :=
  ⅟ (2 : R) * (x + κ x)

/-- Subtracting the involute and dividing by two gives the odd part. -/
noncomputable def oddPart [Invertible (2 : R)] (x : R) : R :=
  ⅟ (2 : R) * (x - κ x)

section Projections

variable [Invertible (2 : R)]
include hκ

/-- The even projection is fixed by the involution. -/
theorem map_evenPart (x : R) : κ (evenPart κ x) = evenPart κ x := by
  simp only [evenPart, map_mul, map_add]
  rw [show κ (⅟ (2 : R)) = ⅟ (2 : R) by
    apply (isUnit_of_invertible (2 : R)).mul_left_cancel
    calc
      (2 : R) * κ (⅟ (2 : R)) =
          κ (2 : R) * κ (⅟ (2 : R)) := by rw [map_ofNat]
      _ = κ ((2 : R) * ⅟ (2 : R)) := (map_mul κ _ _).symm
      _ = κ 1 := by rw [mul_invOf_self]
      _ = 1 := map_one κ
      _ = (2 : R) * ⅟ (2 : R) := (mul_invOf_self (2 : R)).symm]
  simp [hκ x, add_comm]

/-- The odd projection is negated by the involution. -/
theorem map_oddPart (x : R) : κ (oddPart κ x) = -oddPart κ x := by
  simp only [oddPart, map_mul, map_sub]
  rw [show κ (⅟ (2 : R)) = ⅟ (2 : R) by
    apply (isUnit_of_invertible (2 : R)).mul_left_cancel
    calc
      (2 : R) * κ (⅟ (2 : R)) =
          κ (2 : R) * κ (⅟ (2 : R)) := by rw [map_ofNat]
      _ = κ ((2 : R) * ⅟ (2 : R)) := (map_mul κ _ _).symm
      _ = κ 1 := by rw [mul_invOf_self]
      _ = 1 := map_one κ
      _ = (2 : R) * ⅟ (2 : R) := (mul_invOf_self (2 : R)).symm]
  rw [hκ x]
  ring

omit hκ in
/-- The even and odd projections add to the original element. -/
theorem evenPart_add_oddPart (x : R) :
    evenPart κ x + oddPart κ x = x := by
  simp only [evenPart, oddPart]
  rw [← mul_add]
  have htwo : (⅟ (2 : R)) * 2 = 1 := invOf_mul_self (2 : R)
  calc
    ⅟ (2 : R) * ((x + κ x) + (x - κ x)) = (⅟ (2 : R) * 2) * x := by ring
    _ = x := by rw [htwo, one_mul]

omit hκ in
/-- An element that is both invariant and anti-invariant is zero. -/
theorem invariant_eq_zero_of_antiInvariant {x : R}
    (heven : κ x = x) (hodd : κ x = -x) : x = 0 := by
  have htwo : (2 : R) * x = 0 := by
    calc
      (2 : R) * x = x + x := by ring
      _ = κ x + x := by rw [heven]
      _ = -x + x := by rw [hodd]
      _ = 0 := neg_add_cancel x
  apply (isUnit_of_invertible (2 : R)).mul_left_cancel
  simpa using htwo

end Projections

/-- Multiplication by an anti-invariant unit maps invariant elements
bijectively onto anti-invariant elements. -/
noncomputable def oddMulEquiv {c : R} (hcodd : κ c = -c) (hc : IsUnit c) :
    Invariant κ ≃ AntiInvariant κ := by
  let f : Invariant κ → AntiInvariant κ := fun x =>
    ⟨c * x.1, by
      rw [map_mul, hcodd, x.property]
      ring⟩
  refine Equiv.ofBijective f ⟨?_, ?_⟩
  · intro x y hxy
    apply Subtype.ext
    have hv := congrArg (fun z : AntiInvariant κ => z.1) hxy
    dsimp [f] at hv
    exact hc.mul_left_cancel hv
  · intro y
    let u : Rˣ := hc.unit
    let b : R := ((u⁻¹ : Rˣ) : R) * y.1
    have hmul : c * b = y.1 := by
      change c * (((u⁻¹ : Rˣ) : R) * y.1) = y.1
      rw [← hc.unit_spec]
      change (u : R) * (((u⁻¹ : Rˣ) : R) * y.1) = y.1
      simp
    have hb : κ b = b := by
      apply hc.mul_left_cancel
      calc
        c * κ b = -(κ c * κ b) := by
          rw [hcodd]
          ring
        _ = -κ (c * b) := congrArg Neg.neg (map_mul κ c b).symm
        _ = -κ y.1 := by rw [hmul]
        _ = y.1 := by rw [y.property, neg_neg]
        _ = c * b := hmul.symm
    refine ⟨⟨b, hb⟩, ?_⟩
    apply Subtype.ext
    dsimp [f]
    exact hmul

section Decomposition

variable [Invertible (2 : R)]
include hκ

omit hκ [Invertible (2 : R)] in
/-- An anti-invariant element whose square is a unit is itself a unit. -/
theorem isUnit_of_square_isUnit {c : R} (hc2 : IsUnit (c ^ 2)) : IsUnit c :=
  (isUnit_pow_iff (by norm_num : (2 : ℕ) ≠ 0)).mp hc2

/-- Every element has an invariant-plus-odd-times-invariant expression once
the chosen odd element has unit square. -/
theorem exists_invariant_add_mul_invariant {c x : R}
    (hcodd : κ c = -c) (hc2 : IsUnit (c ^ 2)) :
    ∃ a b : R, κ a = a ∧ κ b = b ∧ x = a + c * b := by
  let a : Invariant κ := ⟨evenPart κ x, map_evenPart κ hκ x⟩
  let xo : AntiInvariant κ := ⟨oddPart κ x, map_oddPart κ hκ x⟩
  let e := oddMulEquiv κ hcodd
    (isUnit_of_square_isUnit hc2)
  let b : Invariant κ := e.symm xo
  refine ⟨a.1, b.1, a.property, b.property, ?_⟩
  rw [← evenPart_add_oddPart κ x]
  change a.1 + xo.1 = a.1 + c * b.1
  rw [show xo.1 = c * b.1 by
    exact congrArg Subtype.val (e.apply_symm_apply xo).symm]

omit hκ in
/-- The invariant-plus-odd-times-invariant expression is unique. -/
theorem invariant_add_mul_invariant_unique {c x a b a' b' : R}
    (hcodd : κ c = -c) (hc2 : IsUnit (c ^ 2))
    (ha : κ a = a) (hb : κ b = b)
    (ha' : κ a' = a') (hb' : κ b' = b')
    (hx : x = a + c * b) (hx' : x = a' + c * b') :
    a = a' ∧ b = b' := by
  have hsum : a - a' = -(c * (b - b')) := by
    rw [hx] at hx'
    linear_combination hx'
  have heven : κ (a - a') = a - a' := by simp [ha, ha']
  have hodd : κ (a - a') = -(a - a') := by
    rw [hsum]
    simp [map_mul, hcodd, hb, hb']
  have haeq : a = a' := sub_eq_zero.mp
    (invariant_eq_zero_of_antiInvariant κ heven hodd)
  subst a'
  have hcb : c * b = c * b' := by
    rw [hx] at hx'
    exact add_left_cancel hx'
  exact ⟨rfl,
    (isUnit_of_square_isUnit hc2).mul_left_cancel hcb⟩

/-- Every element has a unique invariant-plus-odd-times-invariant
expression. -/
theorem existsUnique_invariant_add_mul_invariant {c x : R}
    (hcodd : κ c = -c) (hc2 : IsUnit (c ^ 2)) :
    ∃! ab : R × R,
      κ ab.1 = ab.1 ∧ κ ab.2 = ab.2 ∧ x = ab.1 + c * ab.2 := by
  obtain ⟨a, b, ha, hb, hx⟩ :=
    exists_invariant_add_mul_invariant κ hκ hcodd hc2
  refine ⟨(a, b), ⟨ha, hb, hx⟩, ?_⟩
  intro ab hab
  rcases hab with ⟨ha', hb', hx'⟩
  rcases invariant_add_mul_invariant_unique κ hcodd hc2
    ha' hb' ha hb hx' hx with ⟨rfl, rfl⟩
  rfl

end Decomposition

section Localization

variable {S : Type*} [CommRing S] [Algebra R S]
variable (κS : S ≃+* S) (hκS : Function.Involutive κS)
variable [Invertible (2 : S)]
include hκS

/-- Localizing away from the square of an odd element makes its image an odd
unit, and hence gives the unique invariant-plus-odd-times-invariant
decomposition in the localized ring. -/
theorem localized_existsUnique_invariant_add_mul_invariant {c : R}
    (hcodd : κ c = -c)
    (hequiv : ∀ r, κS (algebraMap R S r) = algebraMap R S (κ r))
    [IsLocalization.Away (c ^ 2) S] (x : S) :
    ∃! ab : S × S,
      κS ab.1 = ab.1 ∧ κS ab.2 = ab.2 ∧
        x = ab.1 + algebraMap R S c * ab.2 := by
  have hcSodd : κS (algebraMap R S c) = -algebraMap R S c := by
    rw [hequiv, hcodd, map_neg]
  have hcS2 : IsUnit ((algebraMap R S c) ^ 2) := by
    rw [← map_pow]
    exact IsLocalization.map_units S ⟨c ^ 2, Submonoid.mem_powers _⟩
  exact existsUnique_invariant_add_mul_invariant κS hκS hcSodd hcS2

end Localization

end RelativeConicArcs.InvolutiveOddUnit
