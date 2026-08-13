import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.PrincipalGluingPacket

/-!
# Frobenius on the four-element gluing packet

This module isolates the finite-field calculation used by the principal
gluing argument.  It does not identify any geometric or group-theoretic
normalizer action with Frobenius.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace GraphLattices

noncomputable section

local instance : Fact (Nat.Prime 2) := ⟨by norm_num⟩

/-- Frobenius on the chosen model of `F4` is the squaring map. -/
def f4Frobenius (a : F4) : F4 := a ^ 2

/-- The squaring map is the canonical Frobenius field automorphism. -/
noncomputable def f4FrobeniusRingEquiv : F4 ≃+* F4 :=
  letI : Algebra (ZMod 2) F4 :=
    FiniteField.instAlgebraExtension (ZMod 2) 2 2
  (FiniteField.Extension.frob (ZMod 2) 2 2).toRingEquiv

/-- The canonical field automorphism acts by squaring. -/
@[simp]
theorem f4FrobeniusRingEquiv_apply (a : F4) :
    f4FrobeniusRingEquiv a = f4Frobenius a := by
  simp [f4FrobeniusRingEquiv, f4Frobenius]

/-- The elements fixed by Frobenius are exactly the prime-field elements
`0` and `1`. -/
theorem f4Frobenius_fixed_iff (a : F4) :
    f4Frobenius a = a ↔ a = 0 ∨ a = 1 := by
  constructor
  · intro fixed
    have fixedPower : a ^ 2 = a := by
      simpa [f4Frobenius] using fixed
    have factored : a * (a - 1) = 0 := by
      rw [mul_sub, mul_one, ← pow_two, fixedPower, sub_self]
    rcases mul_eq_zero.mp factored with zero | one
    · exact Or.inl zero
    · exact Or.inr (sub_eq_zero.mp one)
  · rintro (rfl | rfl) <;> simp [f4Frobenius]

/-- Frobenius has order dividing two on `F4`. -/
theorem f4Frobenius_involutive : Function.Involutive f4Frobenius := by
  intro a
  letI : Fintype F4 := Fintype.ofFinite F4
  have cardinality : Fintype.card F4 = 4 := by
    simpa [Nat.card_eq_fintype_card] using natCard_F4
  simpa [f4Frobenius, ← pow_mul, cardinality] using
    (FiniteField.pow_card a)

/-- Every element outside the prime field is moved by Frobenius and is
exchanged with its distinct Frobenius conjugate. -/
theorem f4Frobenius_exchanges_nonPrimeElement (a : F4)
    (notZero : a ≠ 0) (notOne : a ≠ 1) :
    f4Frobenius a ≠ a ∧ f4Frobenius (f4Frobenius a) = a := by
  refine ⟨?_, f4Frobenius_involutive a⟩
  simpa [f4Frobenius_fixed_iff] using not_or_intro notZero notOne

/-- Frobenius acts on the affine-chart presentation of the projective
packet, fixing the vertical point. -/
def f4ProjectiveFrobenius : Option F4 → Option F4
  | none => none
  | some a => some (f4Frobenius a)

/-- In the affine chart, projective Frobenius is coefficientwise application
of the canonical Frobenius field automorphism, with the vertical point fixed. -/
theorem f4ProjectiveFrobenius_eq_option_map (point : Option F4) :
    f4ProjectiveFrobenius point = point.map f4FrobeniusRingEquiv := by
  cases point <;> simp [f4ProjectiveFrobenius]

/-- In affine-chart coordinates, the fixed projective points are precisely
the vertical point and the scalar graphs of `0` and `1`. -/
theorem f4ProjectiveFrobenius_fixed_iff (point : Option F4) :
    f4ProjectiveFrobenius point = point ↔
      point = none ∨ point = some 0 ∨ point = some 1 := by
  cases point with
  | none => simp [f4ProjectiveFrobenius]
  | some a => simp [f4ProjectiveFrobenius, f4Frobenius_fixed_iff]

/-- Projective Frobenius is an involution. -/
theorem f4ProjectiveFrobenius_involutive :
    Function.Involutive f4ProjectiveFrobenius := by
  intro point
  cases point with
  | none => rfl
  | some a => simp [f4ProjectiveFrobenius, f4Frobenius_involutive a]

end

end GraphLattices

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
