import FiniteGeom.AxisTwistedCubic

/-!
# The projectively completed characteristic-three twisted-cubic–axis code

This module adds the omitted projective point `(0,0,0,1)` to the affine twisted cubic used by
`FiniteGeom.AxisTwistedCubic`.  The resulting point system is the disjointly indexed union of the
full projective twisted cubic and the full common axis `X₀=X₃=0`.

Every nonzero plane containing the axis meets the full cubic in at most one point.  A plane not
containing the axis meets the axis in at most one point and the full cubic in at most three points;
the latter statement treats the projective point explicitly, reducing to a quadratic section when
that point lies in the plane.  Hence the maximum section remains `q+2`, while the length increases
to `2q+2`, giving a `[2q+2,4,q]` code.
-/

namespace FiniteGeom

open Finset Matrix

/-- Projective parameter line for the full twisted cubic. -/
abbrev ProjectiveTwistedCubicIndex (𝔽 : Type*) := 𝔽 ⊕ Unit

/-- Disjoint index for the full projective twisted cubic and the full common axis. -/
abbrev ProjectiveAxisTwistedCubicIndex (𝔽 : Type*) :=
  ProjectiveTwistedCubicIndex 𝔽 ⊕ (𝔽 ⊕ Unit)

@[simp] theorem card_projectiveTwistedCubicIndex (𝔽 : Type*) [Fintype 𝔽] :
    Fintype.card (ProjectiveTwistedCubicIndex 𝔽) = Fintype.card 𝔽 + 1 := by
  simp [ProjectiveTwistedCubicIndex]

@[simp] theorem card_projectiveAxisTwistedCubicIndex (𝔽 : Type*) [Fintype 𝔽] :
    Fintype.card (ProjectiveAxisTwistedCubicIndex 𝔽) = 2 * Fintype.card 𝔽 + 2 := by
  simp only [ProjectiveAxisTwistedCubicIndex, ProjectiveTwistedCubicIndex,
    Fintype.card_sum, Fintype.card_unique]
  omega

/-- The full projective twisted cubic, with its point at infinity represented by `(0,0,0,1)`. -/
def projectiveTwistedCubicPoints (𝔽 : Type*) [Field 𝔽] :
    ProjectiveTwistedCubicIndex 𝔽 → (Fin 4 → 𝔽)
  | .inl t => momentCurve 4 t
  | .inr _ => ![0, 0, 0, 1]

/-- The completed point system: full projective twisted cubic together with the full axis. -/
def projectiveAxisTwistedCubicPoints (𝔽 : Type*) [Field 𝔽] :
    ProjectiveAxisTwistedCubicIndex 𝔽 → (Fin 4 → 𝔽)
  | .inl x => projectiveTwistedCubicPoints 𝔽 x
  | .inr y => axisTwistedCubicPoints 𝔽 (.inr y)

@[simp] theorem projectiveTwistedCubicPoints_finite {𝔽 : Type*} [Field 𝔽] (t : 𝔽) :
    projectiveTwistedCubicPoints 𝔽 (.inl t) = momentCurve 4 t := rfl

@[simp] theorem projectiveTwistedCubicPoints_infinity {𝔽 : Type*} [Field 𝔽] (u : Unit) :
    projectiveTwistedCubicPoints 𝔽 (.inr u) = ![0, 0, 0, 1] := rfl

@[simp] theorem projectiveAxisTwistedCubicPoints_cubic {𝔽 : Type*} [Field 𝔽]
    (x : ProjectiveTwistedCubicIndex 𝔽) :
    projectiveAxisTwistedCubicPoints 𝔽 (.inl x) = projectiveTwistedCubicPoints 𝔽 x := rfl

@[simp] theorem projectiveAxisTwistedCubicPoints_axis {𝔽 : Type*} [Field 𝔽]
    (y : 𝔽 ⊕ Unit) :
    projectiveAxisTwistedCubicPoints 𝔽 (.inr y) =
      axisTwistedCubicPoints 𝔽 (.inr y) := rfl

@[simp] theorem projectiveTwistedCubicPoints_infinity_dot {𝔽 : Type*} [Field 𝔽]
    (u : Unit) (a : Fin 4 → 𝔽) :
    projectiveTwistedCubicPoints 𝔽 (.inr u) ⬝ᵥ a = a 3 := by
  simp [projectiveTwistedCubicPoints, dotProduct, Fin.sum_univ_succ]

/-- In characteristic three, a plane containing the common axis meets the full projective cubic
in at most one point.  The finite/finite case is Frobenius injectivity; a simultaneous finite and
infinite zero would force the plane form itself to vanish. -/
theorem projectiveCubic_section_le_one_of_axis {𝔽 : Type*} [Field 𝔽] [Fintype 𝔽]
    [CharP 𝔽 3] [DecidableEq 𝔽] (a : Fin 4 → 𝔽) (ha : a ≠ 0)
    (h₁ : a 1 = 0) (h₂ : a 2 = 0) :
    #(univ.filter fun x : ProjectiveTwistedCubicIndex 𝔽 =>
        projectiveTwistedCubicPoints 𝔽 x ⬝ᵥ a = 0) ≤ 1 := by
  rw [card_le_one]
  intro x hx y hy
  simp only [mem_filter, mem_univ, true_and] at hx hy
  cases x with
  | inl x =>
      cases y with
      | inl y =>
          simp only [projectiveTwistedCubicPoints_finite, momentCurve_four_dot, h₁, h₂,
            mul_zero, add_zero] at hx hy
          by_cases h₃ : a 3 = 0
          · have h₀ : a 0 ≠ 0 := by
              intro h₀
              apply ha
              funext i
              fin_cases i <;> assumption
            exact (h₀ (by simpa [h₃] using hx)).elim
          · apply congrArg Sum.inl
            have hmul : (x ^ 3 - y ^ 3) * a 3 = 0 := by
              linear_combination hx - hy
            have hcubes : x ^ 3 = y ^ 3 :=
              sub_eq_zero.mp ((mul_eq_zero.mp hmul).resolve_right h₃)
            exact (injective_frobenius 𝔽 3) hcubes
      | inr y =>
          simp only [projectiveTwistedCubicPoints_finite, momentCurve_four_dot, h₁, h₂,
            mul_zero, add_zero] at hx
          simp only [projectiveTwistedCubicPoints_infinity_dot] at hy
          have h₀ : a 0 = 0 := by simpa [hy] using hx
          apply (ha (funext fun i => ?_)).elim
          fin_cases i <;> assumption
  | inr x =>
      cases y with
      | inl y =>
          simp only [projectiveTwistedCubicPoints_infinity_dot] at hx
          simp only [projectiveTwistedCubicPoints_finite, momentCurve_four_dot, h₁, h₂,
            mul_zero, add_zero] at hy
          have h₀ : a 0 = 0 := by simpa [hx] using hy
          apply (ha (funext fun i => ?_)).elim
          fin_cases i <;> assumption
      | inr y => congr

/-- Every nonzero plane containing the common axis meets the full projective cubic in exactly one
point.  If the cubic-infinity coefficient vanishes that point is infinity; otherwise finite-field
Frobenius surjectivity supplies the unique finite root. -/
theorem projectiveCubic_section_eq_one_of_axis {𝔽 : Type*} [Field 𝔽] [Fintype 𝔽]
    [CharP 𝔽 3] [DecidableEq 𝔽] (a : Fin 4 → 𝔽) (ha : a ≠ 0)
    (h₁ : a 1 = 0) (h₂ : a 2 = 0) :
    #(univ.filter fun x : ProjectiveTwistedCubicIndex 𝔽 =>
        projectiveTwistedCubicPoints 𝔽 x ⬝ᵥ a = 0) = 1 := by
  apply Nat.le_antisymm (projectiveCubic_section_le_one_of_axis a ha h₁ h₂)
  apply Finset.card_pos.mpr
  by_cases h₃ : a 3 = 0
  · refine ⟨.inr Unit.unit, ?_⟩
    simp only [mem_filter, mem_univ, true_and,
      projectiveTwistedCubicPoints_infinity_dot]
    exact h₃
  · have hsurj : Function.Surjective (fun t : 𝔽 => t ^ 3) :=
      Finite.injective_iff_surjective.mp (injective_frobenius 𝔽 3)
    obtain ⟨t, ht⟩ := hsurj (-a 0 / a 3)
    refine ⟨.inl t, ?_⟩
    simp only [mem_filter, mem_univ, true_and, projectiveTwistedCubicPoints_finite,
      momentCurve_four_dot, h₁, h₂, mul_zero, add_zero]
    have ht' : t ^ 3 = -a 0 / a 3 := ht
    rw [ht', div_mul_cancel₀ _ h₃]
    simp

/-- If the projective cubic point at infinity lies in a plane, the finite cubic equation has
degree at most two. -/
theorem projectiveCubic_finite_section_le_two_of_infinity {𝔽 : Type*} [Field 𝔽]
    [Fintype 𝔽] [DecidableEq 𝔽] (a : Fin 4 → 𝔽) (ha : a ≠ 0) (h₃ : a 3 = 0) :
    #(univ.filter fun t : 𝔽 => momentCurve 4 t ⬝ᵥ a = 0) ≤ 2 := by
  let b : Fin 3 → 𝔽 := ![a 0, a 1, a 2]
  have hb : b ≠ 0 := by
    intro hb
    apply ha
    funext i
    fin_cases i
    · exact congrFun hb 0
    · exact congrFun hb 1
    · exact congrFun hb 2
    · exact h₃
  let e : 𝔽 ≃ Fin (Fintype.card 𝔽) := Fintype.equivFin 𝔽
  have hcard :
      #(univ.filter fun t : 𝔽 => momentCurve 4 t ⬝ᵥ a = 0) =
        #(univ.filter fun i : Fin (Fintype.card 𝔽) =>
          momentCurve 3 (e.symm i) ⬝ᵥ b = 0) := by
    apply Finset.card_equiv e
    intro t
    have hdot : momentCurve 4 t ⬝ᵥ a = momentCurve 3 t ⬝ᵥ b := by
      simp [momentCurve, dotProduct, Fin.sum_univ_succ, b, h₃]
    simp only [mem_filter, mem_univ, true_and, Equiv.symm_apply_apply]
    rw [hdot]
  rw [hcard]
  simpa using (momentCurve_section_le (n := 3) hb (pts := e.symm) e.symm.injective)

/-- Every plane meets the full projective twisted cubic in at most three points. -/
theorem projectiveCubic_section_le_three {𝔽 : Type*} [Field 𝔽] [Fintype 𝔽]
    [DecidableEq 𝔽] (a : Fin 4 → 𝔽) (ha : a ≠ 0) :
    #(univ.filter fun x : ProjectiveTwistedCubicIndex 𝔽 =>
        projectiveTwistedCubicPoints 𝔽 x ⬝ᵥ a = 0) ≤ 3 := by
  rw [card_filter_sum]
  simp only [projectiveTwistedCubicPoints_finite]
  by_cases h₃ : a 3 = 0
  · have hfinite := projectiveCubic_finite_section_le_two_of_infinity a ha h₃
    have hinfinity :
        #(univ.filter fun u : Unit =>
          projectiveTwistedCubicPoints 𝔽 (.inr u) ⬝ᵥ a = 0) = 1 := by
      simp_rw [projectiveTwistedCubicPoints_infinity_dot]
      simp [h₃]
    rw [hinfinity]
    omega
  · have hfinite := cubic_section_le_three a ha
    have hinfinity :
        #(univ.filter fun u : Unit =>
          projectiveTwistedCubicPoints 𝔽 (.inr u) ⬝ᵥ a = 0) = 0 := by
      simp_rw [projectiveTwistedCubicPoints_infinity_dot]
      simp [h₃]
    rw [hinfinity, add_zero]
    exact hfinite

/-- The completed section count splits into its projective-cubic and axis blocks. -/
theorem sectionCount_projectiveAxisTwistedCubicPoints {𝔽 : Type*} [Field 𝔽] [Fintype 𝔽]
    [DecidableEq 𝔽] (a : Fin 4 → 𝔽) :
    sectionCount (projectiveAxisTwistedCubicPoints 𝔽) a =
      #(univ.filter fun x : ProjectiveTwistedCubicIndex 𝔽 =>
        projectiveTwistedCubicPoints 𝔽 x ⬝ᵥ a = 0) +
      #(univ.filter fun y : 𝔽 ⊕ Unit =>
        axisTwistedCubicPoints 𝔽 (.inr y) ⬝ᵥ a = 0) := by
  exact card_filter_sum (fun j : ProjectiveAxisTwistedCubicIndex 𝔽 =>
    projectiveAxisTwistedCubicPoints 𝔽 j ⬝ᵥ a = 0)

/-- **Maximum-section upper bound.** Every plane meets the completed point system in at most
`q+2` points. -/
theorem projectiveAxisTwistedCubic_section_le {𝔽 : Type*} [Field 𝔽] [Fintype 𝔽]
    [CharP 𝔽 3] [DecidableEq 𝔽] (a : Fin 4 → 𝔽) (ha : a ≠ 0) :
    sectionCount (projectiveAxisTwistedCubicPoints 𝔽) a ≤ Fintype.card 𝔽 + 2 := by
  rw [sectionCount_projectiveAxisTwistedCubicPoints]
  by_cases haxis : a 1 = 0 ∧ a 2 = 0
  · have hcubic := projectiveCubic_section_le_one_of_axis a ha haxis.1 haxis.2
    have hline :
        #(univ.filter fun y : 𝔽 ⊕ Unit =>
          axisTwistedCubicPoints 𝔽 (.inr y) ⬝ᵥ a = 0) ≤ Fintype.card 𝔽 + 1 := by
      calc
        _ ≤ Fintype.card (𝔽 ⊕ Unit) := card_le_univ _
        _ = Fintype.card 𝔽 + 1 := by simp
    omega
  · have hcubic := projectiveCubic_section_le_three a ha
    have hline := axis_section_le_one a (not_and_or.mp haxis)
    obtain ⟨n, _, hcard⟩ := FiniteField.card 𝔽 3
    have hq : 3 ≤ Fintype.card 𝔽 := by
      rw [hcard]
      exact Nat.le_pow n.prop
    omega

/-- The plane `X₃=0` contains the whole axis and the finite cubic point at zero, but not cubic
infinity, so it still attains a section of size `q+2`. -/
def projectiveAxisTwistedCubicMaxForm (𝔽 : Type*) [Field 𝔽] : Fin 4 → 𝔽 :=
  axisTwistedCubicMaxForm 𝔽

theorem projectiveAxisTwistedCubicMaxForm_sectionCount {𝔽 : Type*} [Field 𝔽]
    [Fintype 𝔽] [DecidableEq 𝔽] :
    sectionCount (projectiveAxisTwistedCubicPoints 𝔽)
      (projectiveAxisTwistedCubicMaxForm 𝔽) = Fintype.card 𝔽 + 2 := by
  rw [sectionCount_projectiveAxisTwistedCubicPoints]
  have hcubic :
      #(univ.filter fun x : ProjectiveTwistedCubicIndex 𝔽 =>
        projectiveTwistedCubicPoints 𝔽 x ⬝ᵥ projectiveAxisTwistedCubicMaxForm 𝔽 = 0) = 1 := by
    rw [card_filter_sum]
    have hfinite :
        #(univ.filter fun t : 𝔽 =>
          projectiveTwistedCubicPoints 𝔽 (.inl t) ⬝ᵥ
            projectiveAxisTwistedCubicMaxForm 𝔽 = 0) = 1 := by
      simp_rw [projectiveTwistedCubicPoints_finite, momentCurve_four_dot]
      simp [projectiveAxisTwistedCubicMaxForm, axisTwistedCubicMaxForm]
      rw [show (univ.filter fun t : 𝔽 => t = 0) = {0} by ext t; simp]
      simp
    have hinfinity :
        #(univ.filter fun u : Unit =>
          projectiveTwistedCubicPoints 𝔽 (.inr u) ⬝ᵥ
            projectiveAxisTwistedCubicMaxForm 𝔽 = 0) = 0 := by
      simp [projectiveAxisTwistedCubicMaxForm, axisTwistedCubicMaxForm]
    rw [hfinite, hinfinity]
  have haxis :
      #(univ.filter fun y : 𝔽 ⊕ Unit =>
        axisTwistedCubicPoints 𝔽 (.inr y) ⬝ᵥ
          projectiveAxisTwistedCubicMaxForm 𝔽 = 0) = Fintype.card 𝔽 + 1 := by
    have hall :
        (univ.filter fun y : 𝔽 ⊕ Unit =>
          axisTwistedCubicPoints 𝔽 (.inr y) ⬝ᵥ
            projectiveAxisTwistedCubicMaxForm 𝔽 = 0) = univ := by
      apply filter_eq_self.mpr
      intro y _
      cases y <;> simp [projectiveAxisTwistedCubicMaxForm, axisTwistedCubicMaxForm]
    rw [hall, card_univ, Fintype.card_sum]
    simp
  rw [hcubic, haxis]
  omega

theorem projectiveAxisTwistedCubicMaxForm_pointEval_ne_zero {𝔽 : Type*} [Field 𝔽]
    [Fintype 𝔽] [DecidableEq 𝔽] :
    pointEval (projectiveAxisTwistedCubicPoints 𝔽)
      (projectiveAxisTwistedCubicMaxForm 𝔽) ≠ 0 := by
  intro h
  have h1 := congrFun h (.inl (.inl (1 : 𝔽)))
  change momentCurve 4 1 ⬝ᵥ projectiveAxisTwistedCubicMaxForm 𝔽 = 0 at h1
  rw [momentCurve_four_dot] at h1
  simp [projectiveAxisTwistedCubicMaxForm, axisTwistedCubicMaxForm] at h1

/-- The plane `X₂-X₁=0` is the target-avoiding four-section used for the full repair port at
axis infinity.  It contains finite cubic parameters `0,1`, cubic infinity, and finite axis
parameter `1`, but not axis infinity. -/
def projectiveAxisInfinityAvoidingFourSectionForm (𝔽 : Type*) [Field 𝔽] : Fin 4 → 𝔽 :=
  ![0, -1, 1, 0]

@[simp] theorem projectiveAxisInfinityAvoidingFourSectionForm_axisInfinity_eval
    {𝔽 : Type*} [Field 𝔽] :
    axisTwistedCubicPoints 𝔽 (.inr (.inr Unit.unit)) ⬝ᵥ
      projectiveAxisInfinityAvoidingFourSectionForm 𝔽 = 1 := by
  simp [projectiveAxisInfinityAvoidingFourSectionForm, axisTwistedCubicPoints,
    dotProduct, Fin.sum_univ_succ]

theorem projectiveAxisInfinityAvoidingFourSectionForm_sectionCount
    {𝔽 : Type*} [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽] :
    sectionCount (projectiveAxisTwistedCubicPoints 𝔽)
      (projectiveAxisInfinityAvoidingFourSectionForm 𝔽) = 4 := by
  rw [sectionCount_projectiveAxisTwistedCubicPoints]
  have hfiniteCubic :
      (univ.filter fun t : 𝔽 =>
        projectiveTwistedCubicPoints 𝔽 (.inl t) ⬝ᵥ
          projectiveAxisInfinityAvoidingFourSectionForm 𝔽 = 0) = {0, 1} := by
    ext t
    simp only [mem_filter, mem_univ, true_and, projectiveTwistedCubicPoints_finite,
      momentCurve_four_dot, projectiveAxisInfinityAvoidingFourSectionForm,
      Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two, Matrix.cons_val_three,
      Matrix.head_cons, Matrix.tail_cons, mul_zero, mul_one, add_zero, zero_add,
      mem_insert, mem_singleton]
    constructor
    · intro ht
      have hfactor : t * (t - 1) = 0 := by
        linear_combination ht
      rcases mul_eq_zero.mp hfactor with h0 | h1
      · exact Or.inl h0
      · exact Or.inr (sub_eq_zero.mp h1)
    · rintro (rfl | rfl) <;> simp
  have hcubic :
      #(univ.filter fun x : ProjectiveTwistedCubicIndex 𝔽 =>
        projectiveTwistedCubicPoints 𝔽 x ⬝ᵥ
          projectiveAxisInfinityAvoidingFourSectionForm 𝔽 = 0) = 3 := by
    rw [card_filter_sum, hfiniteCubic]
    have hinfinity :
        #(univ.filter fun u : Unit =>
          projectiveTwistedCubicPoints 𝔽 (.inr u) ⬝ᵥ
            projectiveAxisInfinityAvoidingFourSectionForm 𝔽 = 0) = 1 := by
      simp [projectiveAxisInfinityAvoidingFourSectionForm]
    rw [hinfinity]
    simp
  have hfiniteAxis :
      (univ.filter fun y : 𝔽 =>
        axisTwistedCubicPoints 𝔽 (.inr (.inl y)) ⬝ᵥ
          projectiveAxisInfinityAvoidingFourSectionForm 𝔽 = 0) = {1} := by
    ext y
    simp only [mem_filter, mem_univ, true_and, mem_singleton]
    have hdot :
        axisTwistedCubicPoints 𝔽 (.inr (.inl y)) ⬝ᵥ
          projectiveAxisInfinityAvoidingFourSectionForm 𝔽 = -1 + y := by
      simp [projectiveAxisInfinityAvoidingFourSectionForm, axisTwistedCubicPoints,
        dotProduct, Fin.sum_univ_succ]
    rw [hdot]
    constructor
    · intro h
      exact sub_eq_zero.mp (by simpa [sub_eq_add_neg, add_comm] using h)
    · rintro rfl
      simp
  have haxis :
      #(univ.filter fun y : 𝔽 ⊕ Unit =>
        axisTwistedCubicPoints 𝔽 (.inr y) ⬝ᵥ
          projectiveAxisInfinityAvoidingFourSectionForm 𝔽 = 0) = 1 := by
    rw [card_filter_sum, hfiniteAxis]
    have hinfinity :
        #(univ.filter fun u : Unit =>
          axisTwistedCubicPoints 𝔽 (.inr (.inr u)) ⬝ᵥ
            projectiveAxisInfinityAvoidingFourSectionForm 𝔽 = 0) = 0 := by
      simp [projectiveAxisInfinityAvoidingFourSectionForm, axisTwistedCubicPoints,
        dotProduct, Fin.sum_univ_succ]
    rw [hinfinity]
    simp
  rw [hcubic, haxis]

/-- Four is the largest completed-seed plane section avoiding axis infinity. -/
theorem projectiveAxisInfinity_avoiding_section_le_four
    {𝔽 : Type*} [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽]
    (a : Fin 4 → 𝔽)
    (havoid : axisTwistedCubicPoints 𝔽 (.inr (.inr Unit.unit)) ⬝ᵥ a ≠ 0) :
    sectionCount (projectiveAxisTwistedCubicPoints 𝔽) a ≤ 4 := by
  have ha : a ≠ 0 := by
    intro ha
    subst a
    exact havoid (by simp)
  have ha2 : a 2 ≠ 0 := by
    simpa [axisTwistedCubicPoints, dotProduct, Fin.sum_univ_succ] using havoid
  rw [sectionCount_projectiveAxisTwistedCubicPoints]
  have hcubic := projectiveCubic_section_le_three a ha
  have haxis := axis_section_le_one a (Or.inr ha2)
  omega

/-- The maximum `q+2` section `X₃=0` avoids projective cubic infinity. -/
@[simp] theorem projectiveAxisTwistedCubicMaxForm_cubicInfinity_eval
    {𝔽 : Type*} [Field 𝔽] :
    projectiveTwistedCubicPoints 𝔽 (.inr Unit.unit) ⬝ᵥ
      projectiveAxisTwistedCubicMaxForm 𝔽 = 1 := by
  simp [projectiveAxisTwistedCubicMaxForm, axisTwistedCubicMaxForm]

/-- The completed point system spans `𝔽⁴`; four displayed columns are the standard basis. -/
theorem projectiveAxisTwistedCubic_span {𝔽 : Type*} [Field 𝔽] :
    Submodule.span 𝔽 (Set.range (projectiveAxisTwistedCubicPoints 𝔽)) = ⊤ := by
  let W := Submodule.span 𝔽 (Set.range (projectiveAxisTwistedCubicPoints 𝔽))
  have hp (j : ProjectiveAxisTwistedCubicIndex 𝔽) :
      projectiveAxisTwistedCubicPoints 𝔽 j ∈ W := Submodule.subset_span ⟨j, rfl⟩
  have he0 : (Pi.basisFun 𝔽 (Fin 4)) 0 ∈ W := by
    convert hp (.inl (.inl (0 : 𝔽))) using 1
    ext i
    fin_cases i <;> simp [projectiveAxisTwistedCubicPoints,
      projectiveTwistedCubicPoints, momentCurve]
  have he1 : (Pi.basisFun 𝔽 (Fin 4)) 1 ∈ W := by
    convert hp (.inr (.inl (0 : 𝔽))) using 1
    ext i
    fin_cases i <;> simp [projectiveAxisTwistedCubicPoints]
  have he2 : (Pi.basisFun 𝔽 (Fin 4)) 2 ∈ W := by
    convert hp (.inr (.inr Unit.unit)) using 1
    ext i
    fin_cases i <;> simp [projectiveAxisTwistedCubicPoints]
  have he3 : (Pi.basisFun 𝔽 (Fin 4)) 3 ∈ W := by
    convert hp (.inl (.inr Unit.unit)) using 1
    ext i
    fin_cases i <;> simp [projectiveAxisTwistedCubicPoints,
      projectiveTwistedCubicPoints]
  apply top_unique
  rw [← (Pi.basisFun 𝔽 (Fin 4)).span_eq]
  apply Submodule.span_le.mpr
  rintro _ ⟨i, rfl⟩
  fin_cases i <;> assumption

theorem projectiveAxisTwistedCubic_finrank {𝔽 : Type*} [Field 𝔽] [Fintype 𝔽]
    [DecidableEq 𝔽] :
    Module.finrank 𝔽 (columnCode (projectiveAxisTwistedCubicPoints 𝔽)) = 4 :=
  finrank_columnCode projectiveAxisTwistedCubic_span

theorem projectiveAxisTwistedCubic_minDist {𝔽 : Type*} [Field 𝔽] [Fintype 𝔽]
    [CharP 𝔽 3] [DecidableEq 𝔽] :
    minDist (columnCode (projectiveAxisTwistedCubicPoints 𝔽)) = Fintype.card 𝔽 := by
  have hsec : ∀ a : Fin 4 → 𝔽,
      pointEval (projectiveAxisTwistedCubicPoints 𝔽) a ≠ 0 →
        sectionCount (projectiveAxisTwistedCubicPoints 𝔽) a ≤ Fintype.card 𝔽 + 2 := by
    intro a hpoint
    apply projectiveAxisTwistedCubic_section_le a
    intro ha
    apply hpoint
    subst a
    funext j
    simp [pointEval]
  have hd := columnCode_minDist_eq projectiveAxisTwistedCubicMaxForm_pointEval_ne_zero
    projectiveAxisTwistedCubicMaxForm_sectionCount hsec
  rw [card_projectiveAxisTwistedCubicIndex] at hd
  omega

/-- **Completed uniform code parameters.** Over every finite field of characteristic three, the
full projective twisted cubic together with its common axis gives a `[2q+2,4,q]_q` code. -/
theorem projectiveAxisTwistedCubic_code_parameters {𝔽 : Type*} [Field 𝔽] [Fintype 𝔽]
    [CharP 𝔽 3] [DecidableEq 𝔽] :
    Fintype.card (ProjectiveAxisTwistedCubicIndex 𝔽) = 2 * Fintype.card 𝔽 + 2 ∧
      Module.finrank 𝔽 (columnCode (projectiveAxisTwistedCubicPoints 𝔽)) = 4 ∧
      minDist (columnCode (projectiveAxisTwistedCubicPoints 𝔽)) = Fintype.card 𝔽 :=
  ⟨card_projectiveAxisTwistedCubicIndex 𝔽, projectiveAxisTwistedCubic_finrank,
    projectiveAxisTwistedCubic_minDist⟩

#print axioms projectiveCubic_section_le_three
#print axioms projectiveCubic_section_eq_one_of_axis
#print axioms projectiveAxisTwistedCubic_section_le
#print axioms projectiveAxisInfinityAvoidingFourSectionForm_sectionCount
#print axioms projectiveAxisInfinity_avoiding_section_le_four
#print axioms projectiveAxisTwistedCubic_code_parameters

end FiniteGeom
