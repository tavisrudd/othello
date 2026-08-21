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

/-- A parameter of the projective line: either a finite field element or the point at infinity. -/
inductive HarmonicParameter (𝔽 : Type*) where
  | finite (t : 𝔽)
  | infinity
  deriving DecidableEq

/-- The quartic normal-rational-curve column at a projective parameter. -/
def harmonicQuarticCurvePoint (t : HarmonicParameter 𝔽) : Fin 5 → 𝔽 :=
  match t with
  | .finite u => FiniteGeom.momentCurve 5 u
  | .infinity => fun i => if i = 4 then 1 else 0

/-- The hyperplane nucleus of the quartic normal rational curve in characteristic three. -/
def harmonicQuarticNucleus : Fin 5 → 𝔽 := fun i => if i = 2 then 1 else 0

/-- Four quartic curve columns followed by the nucleus, arranged as the rows of a square matrix. -/
def harmonicQuarticFamily (a b c d : HarmonicParameter 𝔽) : Matrix (Fin 5) (Fin 5) 𝔽 :=
  ![harmonicQuarticCurvePoint a, harmonicQuarticCurvePoint b,
    harmonicQuarticCurvePoint c, harmonicQuarticCurvePoint d, harmonicQuarticNucleus]

/-- The determinant detecting when four quartic curve points together with the nucleus are
dependent. -/
def harmonicQuarticDeterminant (a b c d : HarmonicParameter 𝔽) : 𝔽 :=
  (harmonicQuarticFamily a b c d).det

/-- The three-parameter Vandermonde product in the row order `a,b,c`. -/
def harmonicVandermondeThree (a b c : 𝔽) : 𝔽 :=
  (b - a) * (c - a) * (c - b)

/-- The four-parameter Vandermonde product in the row order `a,b,c,d`. -/
def harmonicVandermondeFour (a b c d : 𝔽) : 𝔽 :=
  (b - a) * (c - a) * (d - a) * (c - b) * (d - b) * (d - c)

/-- The first elementary symmetric function of three field elements. -/
def harmonicE₁ (a b c : 𝔽) : 𝔽 := a + b + c

/-- The second elementary symmetric function of three field elements. -/
def harmonicE₂ (a b c : 𝔽) : 𝔽 := a * b + a * c + b * c

/-- The second elementary symmetric function of four field elements. -/
def harmonicE₂Four (a b c d : 𝔽) : 𝔽 :=
  a * b + a * c + a * d + b * c + b * d + c * d

/-- Four projective parameters form a harmonic quartic block when the finite parameters satisfy
the second-symmetric equation, or, with exactly one point at infinity, the remaining three sum to
zero.  Tuples with repeated infinity entries are not blocks. -/
def IsHarmonicQuarticBlock :
    HarmonicParameter 𝔽 → HarmonicParameter 𝔽 →
      HarmonicParameter 𝔽 → HarmonicParameter 𝔽 → Prop
  | .finite a, .finite b, .finite c, .finite d => harmonicE₂Four a b c d = 0
  | .infinity, .finite b, .finite c, .finite d => harmonicE₁ b c d = 0
  | .finite a, .infinity, .finite c, .finite d => harmonicE₁ a c d = 0
  | .finite a, .finite b, .infinity, .finite d => harmonicE₁ a b d = 0
  | .finite a, .finite b, .finite c, .infinity => harmonicE₁ a b c = 0
  | _, _, _, _ => False

/-- Coefficients of the monic quartic with roots `a,b,c,d`, ordered from constant to quartic
coefficient. -/
def finiteQuarticHyperplane (a b c d : 𝔽) : Fin 5 → 𝔽 :=
  ![a * b * c * d,
    -(a * b * c + a * b * d + a * c * d + b * c * d),
    harmonicE₂Four a b c d,
    -(a + b + c + d),
    1]

/-- Coefficients of the monic cubic with roots `a,b,c`, padded by a zero quartic coefficient.
This hyperplane contains the quartic point at infinity. -/
def infinityQuarticHyperplane (a b c : 𝔽) : Fin 5 → 𝔽 :=
  ![-(a * b * c), harmonicE₂ a b c, -(harmonicE₁ a b c), 1, 0]

/-- Evaluation of the finite-root hyperplane on a quartic curve point factors into its four root
terms. -/
theorem harmonicQuarticCurvePoint_dot_finiteHyperplane (a b c d t : 𝔽) :
    harmonicQuarticCurvePoint (.finite t) ⬝ᵥ finiteQuarticHyperplane a b c d =
      (t - a) * (t - b) * (t - c) * (t - d) := by
  simp [harmonicQuarticCurvePoint, finiteQuarticHyperplane, harmonicE₂Four,
    dotProduct, Fin.sum_univ_succ]
  ring

/-- Evaluation of the infinity-containing hyperplane on a finite quartic point factors into its
three finite root terms. -/
theorem harmonicQuarticCurvePoint_dot_infinityHyperplane (a b c t : 𝔽) :
    harmonicQuarticCurvePoint (.finite t) ⬝ᵥ infinityQuarticHyperplane a b c =
      (t - a) * (t - b) * (t - c) := by
  simp [harmonicQuarticCurvePoint, infinityQuarticHyperplane, harmonicE₁, harmonicE₂,
    dotProduct, Fin.sum_univ_succ]
  ring

/-- The finite-root hyperplane evaluates at the nucleus to the second elementary symmetric
function of its four roots. -/
theorem harmonicQuarticNucleus_dot_finiteHyperplane (a b c d : 𝔽) :
    harmonicQuarticNucleus ⬝ᵥ finiteQuarticHyperplane a b c d =
      harmonicE₂Four a b c d := by
  simp [harmonicQuarticNucleus, finiteQuarticHyperplane, dotProduct]

/-- The infinity-containing hyperplane evaluates at the nucleus to minus the sum of its three
finite roots. -/
theorem harmonicQuarticNucleus_dot_infinityHyperplane (a b c : 𝔽) :
    harmonicQuarticNucleus ⬝ᵥ infinityQuarticHyperplane a b c = -harmonicE₁ a b c := by
  simp [harmonicQuarticNucleus, infinityQuarticHyperplane, dotProduct]

/-- The padded cubic hyperplane contains the quartic point at infinity. -/
theorem harmonicQuarticInfinity_dot_infinityHyperplane (a b c : 𝔽) :
    harmonicQuarticCurvePoint (.infinity : HarmonicParameter 𝔽) ⬝ᵥ
      infinityQuarticHyperplane a b c = 0 := by
  simp [harmonicQuarticCurvePoint, infinityQuarticHyperplane, dotProduct]

/-- When the sum of three finite parameters is nonzero, their finite harmonic completion. -/
def finiteHarmonicCompletion (a b c : 𝔽) : 𝔽 :=
  -(harmonicE₂ a b c) / harmonicE₁ a b c

/-- The finite harmonic equation is affine-linear in the fourth parameter. -/
theorem harmonicE₂Four_eq_harmonicE₂_add_mul (a b c d : 𝔽) :
    harmonicE₂Four a b c d = harmonicE₂ a b c + d * harmonicE₁ a b c := by
  simp only [harmonicE₂Four, harmonicE₂, harmonicE₁]
  ring

/-- The infinity-block equation has the unique solution `d=-a-b`. -/
theorem harmonicE₁_eq_zero_iff (a b d : 𝔽) :
    harmonicE₁ a b d = 0 ↔ d = -a - b := by
  simp only [harmonicE₁]
  constructor <;> intro h
  · linear_combination h
  · rw [h]
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

/-- A distinct finite triple with nonzero sum has exactly its displayed finite completion. -/
theorem isHarmonicQuarticBlock_finite_nonzero_iff {a b c : 𝔽}
    (hsum : harmonicE₁ a b c ≠ 0) (d : HarmonicParameter 𝔽) :
    IsHarmonicQuarticBlock (.finite a) (.finite b) (.finite c) d ↔
      d = .finite (finiteHarmonicCompletion a b c) := by
  cases d with
  | finite d =>
      simp only [IsHarmonicQuarticBlock, HarmonicParameter.finite.injEq]
      exact harmonicE₂Four_eq_zero_iff hsum
  | infinity => simp [IsHarmonicQuarticBlock, hsum]

/-- In characteristic three, repeating one member of a triple in the harmonic equation leaves the
product of its two differences from the other members. -/
theorem harmonicE₂Four_repeat_first [CharP 𝔽 3] (a b c : 𝔽) :
    harmonicE₂Four a b c a = (a - b) * (a - c) := by
  have h3 : (3 : 𝔽) = 0 := CharP.cast_eq_zero 𝔽 3
  simp only [harmonicE₂Four]
  linear_combination (a * b + a * c) * h3

/-- Repeating the second member gives the product of its differences from the first and third
members. -/
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

/-- A distinct zero-sum finite triple has infinity as its unique harmonic completion. -/
theorem isHarmonicQuarticBlock_finite_zero_iff [CharP 𝔽 3] {a b c : 𝔽}
    (hab : a ≠ b) (hsum : harmonicE₁ a b c = 0) (d : HarmonicParameter 𝔽) :
    IsHarmonicQuarticBlock (.finite a) (.finite b) (.finite c) d ↔ d = .infinity := by
  have he₂ := harmonicE₂_ne_zero_of_harmonicE₁_eq_zero hab hsum
  cases d with
  | finite d =>
      simp only [IsHarmonicQuarticBlock]
      rw [harmonicE₂Four_eq_harmonicE₂_add_mul, hsum, mul_zero, add_zero]
      constructor
      · intro h
        exact (he₂ h).elim
      · intro h
        cases h
  | infinity => simp [IsHarmonicQuarticBlock, hsum]

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

/-- A triple consisting of infinity and two distinct finite parameters has the unique finite
harmonic completion `-a-b`. -/
theorem isHarmonicQuarticBlock_infinity_iff (a b : 𝔽) (d : HarmonicParameter 𝔽) :
    IsHarmonicQuarticBlock .infinity (.finite a) (.finite b) d ↔
      d = .finite (-a - b) := by
  cases d with
  | finite d =>
      simp only [IsHarmonicQuarticBlock, HarmonicParameter.finite.injEq]
      exact harmonicE₁_eq_zero_iff a b d
  | infinity => simp [IsHarmonicQuarticBlock]

/-- The same completion law when infinity is the second prescribed parameter. -/
theorem isHarmonicQuarticBlock_second_infinity_iff (a c : 𝔽) (d : HarmonicParameter 𝔽) :
    IsHarmonicQuarticBlock (.finite a) .infinity (.finite c) d ↔
      d = .finite (-a - c) := by
  cases d with
  | finite d =>
      simp only [IsHarmonicQuarticBlock, HarmonicParameter.finite.injEq]
      exact harmonicE₁_eq_zero_iff a c d
  | infinity => simp [IsHarmonicQuarticBlock]

/-- The same completion law when infinity is the third prescribed parameter. -/
theorem isHarmonicQuarticBlock_third_infinity_iff (a b : 𝔽) (d : HarmonicParameter 𝔽) :
    IsHarmonicQuarticBlock (.finite a) (.finite b) .infinity d ↔
      d = .finite (-a - b) := by
  cases d with
  | finite d =>
      simp only [IsHarmonicQuarticBlock, HarmonicParameter.finite.injEq]
      exact harmonicE₁_eq_zero_iff a b d
  | infinity => simp [IsHarmonicQuarticBlock]

/-- Every ordered triple of distinct projective parameters has a unique fourth parameter, distinct
from the triple, which completes it to a harmonic quartic block.  This is the ordered form of the
Steiner `S(3,4,q+1)` property. -/
theorem existsUnique_harmonicQuarticCompletion [CharP 𝔽 3]
    {a b c : HarmonicParameter 𝔽} (hab : a ≠ b) (hac : a ≠ c) (hbc : b ≠ c) :
    ∃! d : HarmonicParameter 𝔽,
      d ≠ a ∧ d ≠ b ∧ d ≠ c ∧ IsHarmonicQuarticBlock a b c d := by
  cases a with
  | infinity =>
      cases b with
      | infinity => exact (hab rfl).elim
      | finite b =>
          cases c with
          | infinity => exact (hac rfl).elim
          | finite c =>
              have hbc' : b ≠ c := fun h => hbc (congrArg HarmonicParameter.finite h)
              have hne := infinityTripleCompletion_ne hbc'
              refine ⟨.finite (-b - c), ?_, ?_⟩
              · exact ⟨by simp, fun h => hne.1 (HarmonicParameter.finite.inj h),
                  fun h => hne.2 (HarmonicParameter.finite.inj h),
                  (isHarmonicQuarticBlock_infinity_iff b c _).2 rfl⟩
              · intro d hd
                exact (isHarmonicQuarticBlock_infinity_iff b c d).1 hd.2.2.2
  | finite a =>
      cases b with
      | infinity =>
          cases c with
          | infinity => exact (hbc rfl).elim
          | finite c =>
              have hac' : a ≠ c := fun h => hac (congrArg HarmonicParameter.finite h)
              have hne := infinityTripleCompletion_ne hac'
              refine ⟨.finite (-a - c), ?_, ?_⟩
              · exact ⟨fun h => hne.1 (HarmonicParameter.finite.inj h), by simp,
                  fun h => hne.2 (HarmonicParameter.finite.inj h),
                  (isHarmonicQuarticBlock_second_infinity_iff a c _).2 rfl⟩
              · intro d hd
                exact (isHarmonicQuarticBlock_second_infinity_iff a c d).1 hd.2.2.2
      | finite b =>
          cases c with
          | infinity =>
              have hab' : a ≠ b := fun h => hab (congrArg HarmonicParameter.finite h)
              have hne := infinityTripleCompletion_ne hab'
              refine ⟨.finite (-a - b), ?_, ?_⟩
              · exact ⟨fun h => hne.1 (HarmonicParameter.finite.inj h),
                  fun h => hne.2 (HarmonicParameter.finite.inj h), by simp,
                  (isHarmonicQuarticBlock_third_infinity_iff a b _).2 rfl⟩
              · intro d hd
                exact (isHarmonicQuarticBlock_third_infinity_iff a b d).1 hd.2.2.2
          | finite c =>
              have hab' : a ≠ b := fun h => hab (congrArg HarmonicParameter.finite h)
              have hac' : a ≠ c := fun h => hac (congrArg HarmonicParameter.finite h)
              have hbc' : b ≠ c := fun h => hbc (congrArg HarmonicParameter.finite h)
              by_cases hsum : harmonicE₁ a b c = 0
              · refine ⟨.infinity, ?_, ?_⟩
                · exact ⟨by simp, by simp, by simp,
                    (isHarmonicQuarticBlock_finite_zero_iff hab' hsum _).2 rfl⟩
                · intro d hd
                  exact (isHarmonicQuarticBlock_finite_zero_iff hab' hsum d).1 hd.2.2.2
              · have hne := finiteHarmonicCompletion_ne hab' hac' hbc' hsum
                refine ⟨.finite (finiteHarmonicCompletion a b c), ?_, ?_⟩
                · exact ⟨fun h => hne.1 (HarmonicParameter.finite.inj h),
                    fun h => hne.2.1 (HarmonicParameter.finite.inj h),
                    fun h => hne.2.2 (HarmonicParameter.finite.inj h),
                    (isHarmonicQuarticBlock_finite_nonzero_iff hsum _).2 rfl⟩
                · intro d hd
                  exact (isHarmonicQuarticBlock_finite_nonzero_iff hsum d).1 hd.2.2.2

end RepairPorts
