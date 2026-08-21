import FiniteGeom.MomentCurve
import Mathlib.FieldTheory.Finite.Basic

/-!
# Harmonic quartic blocks in characteristic three

This module develops the coordinate core of the quartic normal-rational-curve point system with
its hyperplane nucleus.  A finite quartic point has coordinates
`(1,t,t^2,t^3,t^4)`, the point at infinity is the last coordinate vector, and the nucleus is the
middle coordinate vector.  Four curve points and the nucleus are dependent precisely when the
four parameters form a harmonic block.

The first layer below proves unique harmonic completion directly in characteristic three.  It uses
no finite enumeration or externally generated data.
-/

namespace RepairPorts

open Finset Matrix

variable {𝔽 : Type*} [Field 𝔽]

/-- The first elementary symmetric function of three field elements. -/
def harmonicE₁ (a b c : 𝔽) : 𝔽 := a + b + c

/-- The second elementary symmetric function of three field elements. -/
def harmonicE₂ (a b c : 𝔽) : 𝔽 := a * b + a * c + b * c

/-- The second elementary symmetric function of four field elements. -/
def harmonicE₂Four (a b c d : 𝔽) : 𝔽 :=
  a * b + a * c + a * d + b * c + b * d + c * d

/-- When the sum of three finite parameters is nonzero, their finite harmonic completion. -/
def finiteHarmonicCompletion (a b c : 𝔽) : 𝔽 :=
  -(harmonicE₂ a b c) / harmonicE₁ a b c

/-- The finite harmonic equation is affine-linear in the fourth parameter. -/
theorem harmonicE₂Four_eq_harmonicE₂_add_mul (a b c d : 𝔽) :
    harmonicE₂Four a b c d = harmonicE₂ a b c + d * harmonicE₁ a b c := by
  simp only [harmonicE₂Four, harmonicE₂, harmonicE₁]
  ring

/-- Substituting the finite completion makes the four-point harmonic equation vanish. -/
theorem harmonicE₂Four_finiteHarmonicCompletion_eq_zero {a b c : 𝔽}
    (hsum : harmonicE₁ a b c ≠ 0) :
    harmonicE₂Four a b c (finiteHarmonicCompletion a b c) = 0 := by
  rw [harmonicE₂Four_eq_harmonicE₂_add_mul]
  unfold finiteHarmonicCompletion
  rw [div_mul_cancel₀ _ hsum]
  ring

/-- A finite harmonic completion is unique whenever the sum of the prescribed triple is nonzero. -/
theorem harmonicE₂Four_eq_zero_iff {a b c d : 𝔽} (hsum : harmonicE₁ a b c ≠ 0) :
    harmonicE₂Four a b c d = 0 ↔ d = finiteHarmonicCompletion a b c := by
  rw [harmonicE₂Four_eq_harmonicE₂_add_mul]
  constructor
  · intro h
    rw [finiteHarmonicCompletion, eq_div_iff hsum]
    linear_combination h
  · rintro rfl
    rw [← harmonicE₂Four_eq_harmonicE₂_add_mul]
    exact harmonicE₂Four_finiteHarmonicCompletion_eq_zero hsum

/-- In characteristic three, repeating one member of a triple in the harmonic equation leaves the
product of its two differences from the other members. -/
theorem harmonicE₂Four_repeat_first [CharP 𝔽 3] (a b c : 𝔽) :
    harmonicE₂Four a b c a = (a - b) * (a - c) := by
  have h3 : (3 : 𝔽) = 0 := CharP.cast_eq_zero 𝔽 3
  simp only [harmonicE₂Four]
  linear_combination (a * b + a * c) * h3

/-- The two analogous repeated-parameter identities. -/
theorem harmonicE₂Four_repeat_second [CharP 𝔽 3] (a b c : 𝔽) :
    harmonicE₂Four a b c b = (b - a) * (b - c) := by
  have h3 : (3 : 𝔽) = 0 := CharP.cast_eq_zero 𝔽 3
  simp only [harmonicE₂Four]
  linear_combination (a * b + b * c) * h3

/-- Repeating the third member gives the product of its differences from the first two members. -/
theorem harmonicE₂Four_repeat_third [CharP 𝔽 3] (a b c : 𝔽) :
    harmonicE₂Four a b c c = (c - a) * (c - b) := by
  have h3 : (3 : 𝔽) = 0 := CharP.cast_eq_zero 𝔽 3
  simp only [harmonicE₂Four]
  linear_combination (a * c + b * c) * h3

/-- The finite harmonic completion of three distinct parameters is different from each of them. -/
theorem finiteHarmonicCompletion_ne [CharP 𝔽 3] {a b c : 𝔽}
    (hab : a ≠ b) (hac : a ≠ c) (hbc : b ≠ c) (hsum : harmonicE₁ a b c ≠ 0) :
    finiteHarmonicCompletion a b c ≠ a ∧
      finiteHarmonicCompletion a b c ≠ b ∧
        finiteHarmonicCompletion a b c ≠ c := by
  have hzero := harmonicE₂Four_finiteHarmonicCompletion_eq_zero hsum
  constructor
  · intro ha
    rw [ha, harmonicE₂Four_repeat_first] at hzero
    exact mul_ne_zero (sub_ne_zero.mpr hab) (sub_ne_zero.mpr hac) hzero
  constructor
  · intro hb
    rw [hb, harmonicE₂Four_repeat_second] at hzero
    exact mul_ne_zero (sub_ne_zero.mpr hab.symm) (sub_ne_zero.mpr hbc) hzero
  · intro hc
    rw [hc, harmonicE₂Four_repeat_third] at hzero
    exact mul_ne_zero (sub_ne_zero.mpr hac.symm) (sub_ne_zero.mpr hbc.symm) hzero

/-- If a distinct finite triple has zero sum in characteristic three, its second elementary
symmetric function is nonzero.  Hence no finite fourth parameter completes it harmonically. -/
theorem harmonicE₂_ne_zero_of_harmonicE₁_eq_zero [CharP 𝔽 3] {a b c : 𝔽}
    (hab : a ≠ b) (hsum : harmonicE₁ a b c = 0) : harmonicE₂ a b c ≠ 0 := by
  have hc : c = -a - b := by
    simp only [harmonicE₁] at hsum
    linear_combination hsum
  rw [hc]
  have h3 : (3 : 𝔽) = 0 := CharP.cast_eq_zero 𝔽 3
  have hid : harmonicE₂ a b (-a - b) = -(a - b) ^ 2 := by
    simp only [harmonicE₂]
    linear_combination (-a * b) * h3
  rw [hid]
  exact neg_ne_zero.mpr (pow_ne_zero 2 (sub_ne_zero.mpr hab))

/-- For a triple containing the point at infinity, the unique finite harmonic completion is
`-a-b`; characteristic three makes it distinct from the prescribed finite parameters. -/
theorem infinityTripleCompletion_ne [CharP 𝔽 3] {a b : 𝔽} (hab : a ≠ b) :
    -a - b ≠ a ∧ -a - b ≠ b := by
  have h3 : (3 : 𝔽) = 0 := CharP.cast_eq_zero 𝔽 3
  constructor
  · intro h
    apply hab
    linear_combination h + a * h3
  · intro h
    apply hab
    linear_combination -h - b * h3

end RepairPorts
