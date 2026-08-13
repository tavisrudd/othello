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

/-- Frobenius on the chosen model of `F4` is the squaring map. -/
def f4Frobenius (a : F4) : F4 := a ^ 2

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
