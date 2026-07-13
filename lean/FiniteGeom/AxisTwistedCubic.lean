import FiniteGeom.MomentCurve
import FiniteGeom.ColumnCode
import Mathlib.FieldTheory.Perfect
import Mathlib.FieldTheory.Finite.Basic
import Mathlib.Tactic.FinCases

/-!
# The characteristic-three twisted-cubic–axis code

This module closes the geometric input for the uniform family
`C(S_q) = [2q+1, 4, q-1]_q`.  The point system is the disjoint union of the `q` affine
twisted-cubic points `(1,t,t²,t³)` and the `q+1` points of the axis `X₀=X₃=0`.

For a nonzero plane form, either the axis is not contained in the plane, contributing at most one
point while the cubic contributes at most three, or the axis is contained.  In the latter case the
form has shape `(a₀,0,0,a₃)` and its cubic section has at most one point because Frobenius
`t ↦ t³` is injective in characteristic three.  Thus every section has size at most `q+2`, and the
coordinate form `X₃=0` attains that bound.
-/

namespace FiniteGeom

open Finset Matrix

/-- Natural disjoint index for `q` cubic points, `q` finite axis points, and the axis point at
infinity. -/
abbrev AxisTwistedCubicIndex (𝔽 : Type*) := 𝔽 ⊕ (𝔽 ⊕ Unit)

/-- The length of `S_q` is `2q+1`. -/
@[simp] theorem card_axisTwistedCubicIndex (𝔽 : Type*) [Fintype 𝔽] :
    Fintype.card (AxisTwistedCubicIndex 𝔽) = 2 * Fintype.card 𝔽 + 1 := by
  simp only [AxisTwistedCubicIndex, Fintype.card_sum, Fintype.card_unique, two_mul]
  omega

/-- The characteristic-three point system `S_q = T_q ∪ L_q`. -/
def axisTwistedCubicPoints (𝔽 : Type*) [Field 𝔽] :
    AxisTwistedCubicIndex 𝔽 → (Fin 4 → 𝔽)
  | .inl t => momentCurve 4 t
  | .inr (.inl u) => ![0, 1, u, 0]
  | .inr (.inr _) => ![0, 0, 1, 0]

@[simp] theorem axisTwistedCubicPoints_cubic {𝔽 : Type*} [Field 𝔽] (t : 𝔽) :
    axisTwistedCubicPoints 𝔽 (.inl t) = momentCurve 4 t := rfl

@[simp] theorem axisTwistedCubicPoints_axis {𝔽 : Type*} [Field 𝔽] (u : 𝔽) :
    axisTwistedCubicPoints 𝔽 (.inr (.inl u)) = ![0, 1, u, 0] := rfl

@[simp] theorem axisTwistedCubicPoints_axisInfinity {𝔽 : Type*} [Field 𝔽] (u : Unit) :
    axisTwistedCubicPoints 𝔽 (.inr (.inr u)) = ![0, 0, 1, 0] := rfl

@[simp] theorem axisTwistedCubicPoints_axis_dot {𝔽 : Type*} [Field 𝔽] (u : 𝔽)
    (a : Fin 4 → 𝔽) :
    axisTwistedCubicPoints 𝔽 (.inr (.inl u)) ⬝ᵥ a = a 1 + u * a 2 := by
  simp [axisTwistedCubicPoints, dotProduct, Fin.sum_univ_succ]

@[simp] theorem axisTwistedCubicPoints_axisInfinity_dot {𝔽 : Type*} [Field 𝔽] (u : Unit)
    (a : Fin 4 → 𝔽) :
    axisTwistedCubicPoints 𝔽 (.inr (.inr u)) ⬝ᵥ a = a 2 := by
  simp [axisTwistedCubicPoints, dotProduct, Fin.sum_univ_succ]

@[simp] theorem momentCurve_four_dot {𝔽 : Type*} [Field 𝔽] (t : 𝔽) (a : Fin 4 → 𝔽) :
    momentCurve 4 t ⬝ᵥ a = a 0 + t * a 1 + t ^ 2 * a 2 + t ^ 3 * a 3 := by
  simp [momentCurve, dotProduct, Fin.sum_univ_succ]
  ring

/-- A filtered universal finset over a sum splits into its two tagged blocks. -/
theorem card_filter_sum {α β : Type*} [Fintype α] [Fintype β]
    (p : α ⊕ β → Prop) [DecidablePred p] :
    #(univ.filter p) =
      #(univ.filter fun x : α => p (.inl x)) + #(univ.filter fun y : β => p (.inr y)) := by
  have hsplit : (univ.filter p : Finset (α ⊕ β)) =
      (univ.filter fun x : α => p (.inl x)).disjSum
        (univ.filter fun y : β => p (.inr y)) := by
    ext x
    cases x <;> simp
  rw [hsplit, card_disjSum]

/-- A plane not containing the axis meets it in at most one point.  In coordinates, containment
means exactly that both axis coefficients `a₁,a₂` vanish. -/
theorem axis_section_le_one {𝔽 : Type*} [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽]
    (a : Fin 4 → 𝔽) (haxis : a 1 ≠ 0 ∨ a 2 ≠ 0) :
    #(univ.filter fun y : 𝔽 ⊕ Unit =>
        axisTwistedCubicPoints 𝔽 (.inr y) ⬝ᵥ a = 0) ≤ 1 := by
  rw [card_le_one]
  intro x hx y hy
  simp only [mem_filter, mem_univ, true_and] at hx hy
  cases x with
  | inl x =>
      cases y with
      | inl y =>
          simp only [axisTwistedCubicPoints_axis_dot] at hx hy
          by_cases h₂ : a 2 = 0
          · have h₁ : a 1 ≠ 0 := haxis.resolve_right (fun h => h h₂)
            exact (h₁ (by simpa [h₂] using hx)).elim
          · apply congrArg Sum.inl
            have hmul : (x - y) * a 2 = 0 := by
              linear_combination hx - hy
            exact sub_eq_zero.mp ((mul_eq_zero.mp hmul).resolve_right h₂)
      | inr y =>
          simp only [axisTwistedCubicPoints_axis_dot] at hx
          simp only [axisTwistedCubicPoints_axisInfinity_dot] at hy
          have h₁ : a 1 = 0 := by simpa [hy] using hx
          exact (haxis.elim (fun h => h h₁) (fun h => h hy)).elim
  | inr x =>
      cases y with
      | inl y =>
          simp only [axisTwistedCubicPoints_axisInfinity_dot] at hx
          simp only [axisTwistedCubicPoints_axis_dot] at hy
          have h₁ : a 1 = 0 := by simpa [hx] using hy
          exact (haxis.elim (fun h => h h₁) (fun h => h hx)).elim
      | inr y =>
          congr

/-- In characteristic three, a plane containing the axis meets the affine twisted cubic in at
most one point.  Its equation on the cubic is `a₀+a₃t³=0`, and `t ↦ t³` is Frobenius. -/
theorem cubic_section_le_one_of_axis {𝔽 : Type*} [Field 𝔽] [Fintype 𝔽] [CharP 𝔽 3]
    [DecidableEq 𝔽] (a : Fin 4 → 𝔽) (ha : a ≠ 0) (h₁ : a 1 = 0) (h₂ : a 2 = 0) :
    #(univ.filter fun t : 𝔽 => momentCurve 4 t ⬝ᵥ a = 0) ≤ 1 := by
  rw [card_le_one]
  intro x hx y hy
  simp only [mem_filter, mem_univ, true_and, momentCurve_four_dot, h₁, h₂, mul_zero,
    add_zero] at hx hy
  by_cases h₃ : a 3 = 0
  · have h₀ : a 0 ≠ 0 := by
      intro h₀
      apply ha
      funext i
      fin_cases i <;> assumption
    exact (h₀ (by simpa [h₃] using hx)).elim
  · have hmul : (x ^ 3 - y ^ 3) * a 3 = 0 := by
      linear_combination hx - hy
    have hcubes : x ^ 3 = y ^ 3 :=
      sub_eq_zero.mp ((mul_eq_zero.mp hmul).resolve_right h₃)
    exact (injective_frobenius 𝔽 3) hcubes

/-- Reindexed form of the general cubic-section bound, for the full finite field as parameter
set. -/
theorem cubic_section_le_three {𝔽 : Type*} [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽]
    (a : Fin 4 → 𝔽) (ha : a ≠ 0) :
    #(univ.filter fun t : 𝔽 => momentCurve 4 t ⬝ᵥ a = 0) ≤ 3 := by
  let e : 𝔽 ≃ Fin (Fintype.card 𝔽) := Fintype.equivFin 𝔽
  have hcard :
      #(univ.filter fun t : 𝔽 => momentCurve 4 t ⬝ᵥ a = 0) =
        #(univ.filter fun i : Fin (Fintype.card 𝔽) =>
          momentCurve 4 (e.symm i) ⬝ᵥ a = 0) := by
    apply Finset.card_equiv e
    intro t
    simp [e]
  rw [hcard]
  simpa using (momentCurve_section_le (n := 4) ha (pts := e.symm) e.symm.injective)

/-- The section count of `S_q` is the cubic-block count plus the axis-block count. -/
theorem sectionCount_axisTwistedCubicPoints {𝔽 : Type*} [Field 𝔽] [Fintype 𝔽]
    [DecidableEq 𝔽] (a : Fin 4 → 𝔽) :
    sectionCount (axisTwistedCubicPoints 𝔽) a =
      #(univ.filter fun t : 𝔽 => momentCurve 4 t ⬝ᵥ a = 0) +
      #(univ.filter fun y : 𝔽 ⊕ Unit =>
        axisTwistedCubicPoints 𝔽 (.inr y) ⬝ᵥ a = 0) := by
  exact card_filter_sum (fun j : AxisTwistedCubicIndex 𝔽 =>
    axisTwistedCubicPoints 𝔽 j ⬝ᵥ a = 0)

/-- **Maximum-section upper bound.** Every plane meets `S_q` in at most `q+2` points. -/
theorem axisTwistedCubic_section_le {𝔽 : Type*} [Field 𝔽] [Fintype 𝔽] [CharP 𝔽 3]
    [DecidableEq 𝔽] (a : Fin 4 → 𝔽) (ha : a ≠ 0) :
    sectionCount (axisTwistedCubicPoints 𝔽) a ≤ Fintype.card 𝔽 + 2 := by
  rw [sectionCount_axisTwistedCubicPoints]
  by_cases haxis : a 1 = 0 ∧ a 2 = 0
  · have hcubic := cubic_section_le_one_of_axis a ha haxis.1 haxis.2
    have hline :
        #(univ.filter fun y : 𝔽 ⊕ Unit =>
          axisTwistedCubicPoints 𝔽 (.inr y) ⬝ᵥ a = 0) ≤ Fintype.card 𝔽 + 1 := by
      calc
        _ ≤ Fintype.card (𝔽 ⊕ Unit) := card_le_univ _
        _ = Fintype.card 𝔽 + 1 := by simp
    omega
  · have hcubic := cubic_section_le_three a ha
    have hline := axis_section_le_one a (not_and_or.mp haxis)
    obtain ⟨n, _, hcard⟩ := FiniteField.card 𝔽 3
    have hq : 3 ≤ Fintype.card 𝔽 := by
      rw [hcard]
      exact Nat.le_pow n.prop
    omega

/-- The plane `X₃=0` attains the `q+2` section: it contains the whole axis and only the cubic
point at `t=0`. -/
def axisTwistedCubicMaxForm (𝔽 : Type*) [Field 𝔽] : Fin 4 → 𝔽 := ![0, 0, 0, 1]

theorem axisTwistedCubicMaxForm_sectionCount {𝔽 : Type*} [Field 𝔽] [Fintype 𝔽]
    [DecidableEq 𝔽] :
    sectionCount (axisTwistedCubicPoints 𝔽) (axisTwistedCubicMaxForm 𝔽) =
      Fintype.card 𝔽 + 2 := by
  rw [sectionCount_axisTwistedCubicPoints]
  have hcubic :
      #(univ.filter fun t : 𝔽 =>
        momentCurve 4 t ⬝ᵥ axisTwistedCubicMaxForm 𝔽 = 0) = 1 := by
    simp_rw [momentCurve_four_dot]
    simp [axisTwistedCubicMaxForm]
    rw [show (univ.filter fun t : 𝔽 => t = 0) = {0} by
      ext t
      simp]
    simp
  have haxis :
      #(univ.filter fun y : 𝔽 ⊕ Unit =>
        axisTwistedCubicPoints 𝔽 (.inr y) ⬝ᵥ axisTwistedCubicMaxForm 𝔽 = 0) =
        Fintype.card 𝔽 + 1 := by
    have hall : (univ.filter fun y : 𝔽 ⊕ Unit =>
        axisTwistedCubicPoints 𝔽 (.inr y) ⬝ᵥ axisTwistedCubicMaxForm 𝔽 = 0) = univ := by
      apply filter_eq_self.mpr
      intro y _
      cases y <;> simp [axisTwistedCubicMaxForm]
    rw [hall, card_univ, Fintype.card_sum]
    simp
  rw [hcubic, haxis]
  omega

theorem axisTwistedCubicMaxForm_pointEval_ne_zero {𝔽 : Type*} [Field 𝔽] [Fintype 𝔽]
    [DecidableEq 𝔽] :
    pointEval (axisTwistedCubicPoints 𝔽) (axisTwistedCubicMaxForm 𝔽) ≠ 0 := by
  intro h
  have h1 := congrFun h (.inl (1 : 𝔽))
  change momentCurve 4 1 ⬝ᵥ axisTwistedCubicMaxForm 𝔽 = 0 at h1
  rw [momentCurve_four_dot] at h1
  simp [axisTwistedCubicMaxForm] at h1

/-- The point system spans `𝔽⁴`.  This proof works even for `q=3`, where the cubic block alone has
only three points: cubic parameters `0,1` and two axis points generate the four coordinate
directions. -/
theorem axisTwistedCubic_span {𝔽 : Type*} [Field 𝔽] :
    Submodule.span 𝔽 (Set.range (axisTwistedCubicPoints 𝔽)) = ⊤ := by
  let W := Submodule.span 𝔽 (Set.range (axisTwistedCubicPoints 𝔽))
  have hp (j : AxisTwistedCubicIndex 𝔽) : axisTwistedCubicPoints 𝔽 j ∈ W :=
    Submodule.subset_span ⟨j, rfl⟩
  have he0 : (Pi.basisFun 𝔽 (Fin 4)) 0 ∈ W := by
    convert hp (.inl (0 : 𝔽)) using 1
    ext i
    fin_cases i <;> simp [axisTwistedCubicPoints, momentCurve]
  have he1 : (Pi.basisFun 𝔽 (Fin 4)) 1 ∈ W := by
    convert hp (.inr (.inl (0 : 𝔽))) using 1
    ext i
    fin_cases i <;> simp [axisTwistedCubicPoints]
  have he2 : (Pi.basisFun 𝔽 (Fin 4)) 2 ∈ W := by
    convert hp (.inr (.inr Unit.unit)) using 1
    ext i
    fin_cases i <;> simp [axisTwistedCubicPoints]
  have he3 : (Pi.basisFun 𝔽 (Fin 4)) 3 ∈ W := by
    have hcomb := W.sub_mem (W.sub_mem (W.sub_mem (hp (.inl (1 : 𝔽))) he0) he1) he2
    convert hcomb using 1
    ext i
    fin_cases i <;> simp [axisTwistedCubicPoints, momentCurve]
  apply top_unique
  rw [← (Pi.basisFun 𝔽 (Fin 4)).span_eq]
  apply Submodule.span_le.mpr
  rintro _ ⟨i, rfl⟩
  fin_cases i <;> assumption

/-- The uniform characteristic-three code has dimension four. -/
theorem axisTwistedCubic_finrank {𝔽 : Type*} [Field 𝔽] [Fintype 𝔽]
    [DecidableEq 𝔽] :
    Module.finrank 𝔽 (columnCode (axisTwistedCubicPoints 𝔽)) = 4 :=
  finrank_columnCode axisTwistedCubic_span

/-- The uniform characteristic-three code has minimum distance `q-1`. -/
theorem axisTwistedCubic_minDist {𝔽 : Type*} [Field 𝔽] [Fintype 𝔽] [CharP 𝔽 3]
    [DecidableEq 𝔽] :
    minDist (columnCode (axisTwistedCubicPoints 𝔽)) = Fintype.card 𝔽 - 1 := by
  have hsec : ∀ a : Fin 4 → 𝔽,
      pointEval (axisTwistedCubicPoints 𝔽) a ≠ 0 →
        sectionCount (axisTwistedCubicPoints 𝔽) a ≤ Fintype.card 𝔽 + 2 := by
    intro a hpoint
    apply axisTwistedCubic_section_le a
    intro ha
    apply hpoint
    subst a
    funext j
    simp [pointEval]
  have hd := columnCode_minDist_eq axisTwistedCubicMaxForm_pointEval_ne_zero
    axisTwistedCubicMaxForm_sectionCount hsec
  rw [card_axisTwistedCubicIndex] at hd
  have hq : 0 < Fintype.card 𝔽 := Fintype.card_pos
  omega

/-- **Uniform code parameters.** Over every finite field of characteristic three, the
twisted-cubic–axis projective system gives a linear `[2q+1,4,q-1]_q` code. -/
theorem axisTwistedCubic_code_parameters {𝔽 : Type*} [Field 𝔽] [Fintype 𝔽] [CharP 𝔽 3]
    [DecidableEq 𝔽] :
    Fintype.card (AxisTwistedCubicIndex 𝔽) = 2 * Fintype.card 𝔽 + 1 ∧
      Module.finrank 𝔽 (columnCode (axisTwistedCubicPoints 𝔽)) = 4 ∧
      minDist (columnCode (axisTwistedCubicPoints 𝔽)) = Fintype.card 𝔽 - 1 :=
  ⟨card_axisTwistedCubicIndex 𝔽, axisTwistedCubic_finrank, axisTwistedCubic_minDist⟩

#print axioms axisTwistedCubic_section_le
#print axioms axisTwistedCubic_code_parameters

end FiniteGeom
