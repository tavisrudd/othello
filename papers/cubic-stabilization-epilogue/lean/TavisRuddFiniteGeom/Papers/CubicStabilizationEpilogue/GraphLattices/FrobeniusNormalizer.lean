import Mathlib.GroupTheory.Perm.Sign
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.AlternatingFiveIdentification
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.FrobeniusPacket

/-!
# The abstract Frobenius normalizer of the exceptional `A5`

This module transports arithmetic Frobenius on the affine chart
`Option F4` to the five-point projective action.  It proves that the resulting
permutation is a transposition, hence odd, and that conjugation by it preserves
the alternating group.  It does not identify this permutation with a geometric
normalizer element in the six-axis family.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace GraphLattices

noncomputable section

local instance : Fintype F4 := Fintype.ofFinite F4
local instance : DecidableEq F4 := Classical.decEq F4

/-- Arithmetic Frobenius as a permutation of the affine-chart packet. -/
def f4ProjectiveFrobeniusEquiv : Equiv.Perm (Option F4) where
  toFun := f4ProjectiveFrobenius
  invFun := f4ProjectiveFrobenius
  left_inv := f4ProjectiveFrobenius_involutive
  right_inv := f4ProjectiveFrobenius_involutive

/-- Arithmetic Frobenius moves exactly two of the five projective points. -/
theorem f4ProjectiveFrobeniusEquiv_support_card :
    f4ProjectiveFrobeniusEquiv.support.card = 2 := by
  classical
  have supportDescription :
      f4ProjectiveFrobeniusEquiv.support =
        Finset.univ.filter fun point : Option F4 ↦
          ¬ (point = none ∨ point = some 0 ∨ point = some 1) := by
    ext point
    simp only [Equiv.Perm.mem_support, Finset.mem_filter, Finset.mem_univ, true_and]
    change f4ProjectiveFrobenius point ≠ point ↔ _
    exact not_congr (f4ProjectiveFrobenius_fixed_iff point)
  rw [supportDescription]
  have packetCard : Fintype.card (Option F4) = 5 := by
    simpa [Nat.card_eq_fintype_card] using f4_option_card
  have fixedCard :
      (Finset.univ.filter fun point : Option F4 ↦
        point = none ∨ point = some 0 ∨ point = some 1).card = 3 := by
    have fixedSet :
        (Finset.univ.filter fun point : Option F4 ↦
          point = none ∨ point = some 0 ∨ point = some 1) =
          {none, some 0, some 1} := by
      ext point
      simp
    rw [fixedSet]
    simp
  have partition := Finset.card_filter_add_card_filter_not
    (s := (Finset.univ : Finset (Option F4)))
    (p := fun point ↦ point = none ∨ point = some 0 ∨ point = some 1)
  simp only [Finset.card_univ, packetCard, fixedCard] at partition
  omega

/-- Arithmetic Frobenius is the unique transposition of its two non-prime
projective points. -/
theorem f4ProjectiveFrobeniusEquiv_isSwap :
    f4ProjectiveFrobeniusEquiv.IsSwap := by
  classical
  rw [← Equiv.Perm.card_support_eq_two]
  exact f4ProjectiveFrobeniusEquiv_support_card

/-- Arithmetic Frobenius transported to the fixed five-letter labelling. -/
def f4FrobeniusPermutation : Equiv.Perm (Fin 5) :=
  (Equiv.symm f4OptionEquivFinFive).trans
    (f4ProjectiveFrobeniusEquiv.trans f4OptionEquivFinFive)

/-- The transported Frobenius permutation is a transposition. -/
theorem f4FrobeniusPermutation_isSwap : f4FrobeniusPermutation.IsSwap := by
  rcases f4ProjectiveFrobeniusEquiv_isSwap with ⟨first, second, distinct, equality⟩
  refine ⟨f4OptionEquivFinFive first, f4OptionEquivFinFive second,
    f4OptionEquivFinFive.injective.ne distinct, ?_⟩
  unfold f4FrobeniusPermutation
  rw [equality]
  exact Equiv.symm_trans_swap_trans first second f4OptionEquivFinFive

/-- The Frobenius permutation is odd. -/
theorem f4FrobeniusPermutation_sign :
    Equiv.Perm.sign f4FrobeniusPermutation = -1 :=
  f4FrobeniusPermutation_isSwap.sign_eq

/-- Conjugation by Frobenius preserves the exceptional alternating subgroup. -/
theorem f4FrobeniusPermutation_conjugate_mem_alternating
    (permutation : alternatingGroup (Fin 5)) :
    f4FrobeniusPermutation * permutation * f4FrobeniusPermutation⁻¹ ∈
      alternatingGroup (Fin 5) := by
  rw [Equiv.Perm.mem_alternatingGroup]
  rw [map_mul, map_mul, map_inv, f4FrobeniusPermutation_sign,
    Equiv.Perm.mem_alternatingGroup.mp permutation.property]
  norm_num

end

end GraphLattices

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
