import Mathlib

/-!
# Modular dihedral Schreier actions

This file formalizes the arithmetic core of the reflection-stabilized templates in
Section 7 of `notes/2026-07-12-dihedral-schreier-node-kayles-submission.md`.

The cosets of a reflection subgroup are labelled by `ZMod (2 * n)`. The three generators
act by the central half-turn, a reflection, and a shifted reflection. The paper's deleted
vertices are exactly the fixed points of the two products involving the central
half-turn; the product of the two reflections is translation by `d`.
-/

namespace DihedralSchreier

namespace Modular

/-- The central half-turn `j ↦ j + n` on `Z/(2n)`. -/
def central (n : ℕ) (j : ZMod (2 * n)) : ZMod (2 * n) :=
  j + n

/-- The reflection `j ↦ e - j`. -/
def reflection (e j : ZMod (2 * n)) : ZMod (2 * n) :=
  e - j

/-- The second reflection `j ↦ e - d - j`. -/
def shiftedReflection (e d j : ZMod (2 * n)) : ZMod (2 * n) :=
  e - d - j

/-- Translation by the reflection difference `d`. -/
def translation (d j : ZMod (2 * n)) : ZMod (2 * n) :=
  j + d

/-- The half-turn has order two on `Z/(2n)`. -/
theorem central_involutive : Function.Involutive (central n) := by
  intro j
  simp only [central]
  have hn : ((2 * n : ℕ) : ZMod (2 * n)) = 0 := ZMod.natCast_self (2 * n)
  push_cast at hn
  linear_combination hn

theorem reflection_involutive (e : ZMod (2 * n)) :
    Function.Involutive (reflection (n := n) e) := by
  intro j
  simp [reflection]

theorem shiftedReflection_involutive (e d : ZMod (2 * n)) :
    Function.Involutive (shiftedReflection (n := n) e d) := by
  intro j
  simp [shiftedReflection]

/-- Applying the first reflection after the second translates by `d`. -/
theorem reflection_comp_shiftedReflection (e d j : ZMod (2 * n)) :
    reflection (n := n) e (shiftedReflection (n := n) e d j) = translation d j := by
  simp [reflection, shiftedReflection, translation]
  abel

/-- Applying the second reflection after the first translates by `-d`. -/
theorem shiftedReflection_comp_reflection (e d j : ZMod (2 * n)) :
    shiftedReflection (n := n) e d (reflection (n := n) e j) = translation (-d) j := by
  simp [reflection, shiftedReflection, translation]
  abel

/-- The first pair-product fixed points satisfy the first congruence in (7.2). -/
theorem central_reflection_fixed_iff (e j : ZMod (2 * n)) :
    central n (reflection (n := n) e j) = j ↔ 2 * j = e + n := by
  simp only [central, reflection]
  constructor <;> intro h
  · linear_combination -h
  · linear_combination -h

/-- The second pair-product fixed points satisfy the second congruence in (7.2). -/
theorem central_shiftedReflection_fixed_iff (e d j : ZMod (2 * n)) :
    central n (shiftedReflection (n := n) e d j) = j ↔ 2 * j = e - d + n := by
  simp only [central, shiftedReflection]
  constructor <;> intro h
  · linear_combination -h
  · linear_combination -h

/-- The reflection pair has a fixed point exactly when translation by `d` does. -/
theorem reflection_pair_fixed_iff (e d j : ZMod (2 * n)) :
    reflection (n := n) e (shiftedReflection (n := n) e d j) = j ↔ d = 0 := by
  rw [reflection_comp_shiftedReflection]
  simp [translation]

/-- The exact deleted-vertex predicate for the three-generator coset action. -/
def Deleted (n : ℕ) (e d j : ZMod (2 * n)) : Prop :=
  central n (reflection (n := n) e j) = j ∨
    central n (shiftedReflection (n := n) e d j) = j ∨
      reflection (n := n) e (shiftedReflection (n := n) e d j) = j

/-- Under the generating-case hypothesis `d ≠ 0`, deletion is exactly the two displayed
congruences of equation (7.2). -/
theorem deleted_iff (d : ZMod (2 * n)) (hd : d ≠ 0) (e j : ZMod (2 * n)) :
    Deleted n e d j ↔ 2 * j = e + n ∨ 2 * j = e - d + n := by
  rw [Deleted, central_reflection_fixed_iff, central_shiftedReflection_fixed_iff,
    reflection_pair_fixed_iff]
  constructor
  · rintro (h | h | h)
    · exact Or.inl h
    · exact Or.inr h
    · exact (hd h).elim
  · rintro (h | h)
    · exact Or.inl h
    · exact Or.inr (Or.inl h)

/-- Deletion is invariant under the central half-turn. Thus deleted vertices occur in
the `z`-pairs used by the quotient-path proof of Theorem 7.1. -/
theorem deleted_central_iff (d : ZMod (2 * n)) (hd : d ≠ 0)
    (e j : ZMod (2 * n)) : Deleted n e d (central n j) ↔ Deleted n e d j := by
  rw [deleted_iff d hd, deleted_iff d hd]
  have hn : ((2 * n : ℕ) : ZMod (2 * n)) = 0 := ZMod.natCast_self (2 * n)
  push_cast at hn
  simp only [central]
  constructor
  · rintro (h | h)
    · left
      linear_combination h - hn
    · right
      linear_combination h - hn
  · rintro (h | h)
    · left
      linear_combination h + hn
    · right
      linear_combination h + hn

end Modular

end DihedralSchreier
