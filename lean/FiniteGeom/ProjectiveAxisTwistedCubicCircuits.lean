import FiniteGeom.AxisTwistedCubicCircuits
import FiniteGeom.ProjectiveAxisTwistedCubic

/-!
# Circuits through projective twisted-cubic infinity

The affine circuit module classifies three finite cubic points and their unique axis completion.
This module supplies the missing projective boundary case: two distinct finite cubic points at
parameters `s,t`, cubic infinity, and the finite axis point at `s+t` form a four-circuit.  No other
axis point completes that cubic triple.
-/

namespace FiniteGeom

open Matrix

variable {𝔽 : Type*} [Field 𝔽]

/-- Two finite cubic columns, cubic infinity, and one normalized axis column. -/
def twoFiniteCubicInfinityAxisFamily (s t : 𝔽) (y : 𝔽 ⊕ Unit) :
    Fin 4 → (Fin 4 → 𝔽) :=
  ![projectiveTwistedCubicPoints 𝔽 (.inl s),
    projectiveTwistedCubicPoints 𝔽 (.inl t),
    projectiveTwistedCubicPoints 𝔽 (.inr Unit.unit),
    axisTwistedCubicPoints 𝔽 (.inr y)]

/-- Two distinct finite cubic points together with cubic infinity are independent. -/
theorem twoFiniteCubicInfinity_linearIndependent {s t : 𝔽} (hst : s ≠ t) :
    LinearIndependent 𝔽 ![
      projectiveTwistedCubicPoints 𝔽 (.inl s),
      projectiveTwistedCubicPoints 𝔽 (.inl t),
      projectiveTwistedCubicPoints 𝔽 (.inr Unit.unit)] := by
  rw [Fintype.linearIndependent_iff]
  intro g hrel
  have h₀ := congrFun hrel (0 : Fin 4)
  have h₁ := congrFun hrel (1 : Fin 4)
  have h₃ := congrFun hrel (3 : Fin 4)
  simp only [Finset.sum_apply, Pi.smul_apply, Pi.zero_apply] at h₀ h₁ h₃
  simp [Fin.sum_univ_three, projectiveTwistedCubicPoints, momentCurve] at h₀ h₁ h₃
  have hprod : g 0 * (s - t) = 0 := by linear_combination h₁ - t * h₀
  have hg₀ : g 0 = 0 := (mul_eq_zero.mp hprod).resolve_right (sub_ne_zero.mpr hst)
  have hg₁ : g 1 = 0 := by linear_combination h₀ - hg₀
  have hg₂ : g 2 = 0 := by linear_combination h₃ - s ^ 3 * hg₀ - t ^ 3 * hg₁
  intro i
  fin_cases i <;> assumption

/-- A finite cubic point, cubic infinity, and any axis point are independent. -/
theorem finiteCubicInfinityAxis_linearIndependent (s : 𝔽) (y : 𝔽 ⊕ Unit) :
    LinearIndependent 𝔽 ![
      projectiveTwistedCubicPoints 𝔽 (.inl s),
      projectiveTwistedCubicPoints 𝔽 (.inr Unit.unit),
      axisTwistedCubicPoints 𝔽 (.inr y)] := by
  rw [Fintype.linearIndependent_iff]
  intro g hrel
  have h₀ := congrFun hrel (0 : Fin 4)
  have h₃ := congrFun hrel (3 : Fin 4)
  simp only [Finset.sum_apply, Pi.smul_apply, Pi.zero_apply] at h₀ h₃
  simp [Fin.sum_univ_three, projectiveTwistedCubicPoints, momentCurve] at h₀ h₃
  have hg₀ : g 0 = 0 := h₀
  have hg₁ : g 1 = 0 := by linear_combination h₃ - s ^ 3 * hg₀
  cases y with
  | inl y =>
      have h₁ := congrFun hrel (1 : Fin 4)
      simp only [Finset.sum_apply, Pi.smul_apply, Pi.zero_apply] at h₁
      simp [Fin.sum_univ_three, projectiveTwistedCubicPoints, momentCurve, hg₀, hg₁] at h₁
      intro i
      fin_cases i <;> assumption
  | inr y =>
      have h₂ := congrFun hrel (2 : Fin 4)
      simp only [Finset.sum_apply, Pi.smul_apply, Pi.zero_apply] at h₂
      simp [Fin.sum_univ_three, projectiveTwistedCubicPoints, momentCurve, hg₀, hg₁] at h₂
      intro i
      fin_cases i <;> assumption

/-- The axis point `s+t` gives a dependent four-family with `s,t`, and cubic infinity. -/
theorem twoFiniteCubicInfinityAxis_dependent (s t : 𝔽) :
    ¬ LinearIndependent 𝔽
      (twoFiniteCubicInfinityAxisFamily s t (.inl (s + t))) := by
  intro hli
  let g : Fin 4 → 𝔽 := ![1, -1, -(s ^ 3 - t ^ 3), -(s - t)]
  have hrel : ∑ i, g i • twoFiniteCubicInfinityAxisFamily s t (.inl (s + t)) i = 0 := by
    funext j
    fin_cases j <;>
      simp [g, twoFiniteCubicInfinityAxisFamily, projectiveTwistedCubicPoints,
        axisTwistedCubicPoints, momentCurve, Fin.sum_univ_four] <;> ring
  have hg := (Fintype.linearIndependent_iff.mp hli) g hrel 0
  simp [g] at hg

/-- Any normalized axis completion of the two-finite-plus-infinity cubic triple is the finite
axis point `s+t`. -/
theorem twoFiniteCubicInfinityAxis_dependent_iff {s t : 𝔽} (hst : s ≠ t) (y : 𝔽 ⊕ Unit) :
    ¬ LinearIndependent 𝔽 (twoFiniteCubicInfinityAxisFamily s t y) ↔ y = .inl (s + t) := by
  constructor
  · intro hdep
    cases y with
    | inl u =>
        by_contra hu
        have hu' : u ≠ s + t := fun h => hu (congrArg Sum.inl h)
        apply hdep
        rw [Fintype.linearIndependent_iff]
        intro g hrel
        have h₀ := congrFun hrel (0 : Fin 4)
        have h₁ := congrFun hrel (1 : Fin 4)
        have h₂ := congrFun hrel (2 : Fin 4)
        have h₃ := congrFun hrel (3 : Fin 4)
        simp only [Finset.sum_apply, Pi.smul_apply, Pi.zero_apply] at h₀ h₁ h₂ h₃
        simp [twoFiniteCubicInfinityAxisFamily, projectiveTwistedCubicPoints,
          axisTwistedCubicPoints, momentCurve, Fin.sum_univ_four] at h₀ h₁ h₂ h₃
        have hprod : g 0 * ((s - t) * (s + t - u)) = 0 := by
          linear_combination h₂ - u * h₁ + (u * t - t ^ 2) * h₀
        have hst0 : s - t ≠ 0 := sub_ne_zero.mpr hst
        have hsum0 : s + t - u ≠ 0 := sub_ne_zero.mpr (Ne.symm hu')
        have hg₀ : g 0 = 0 :=
          (mul_eq_zero.mp hprod).resolve_right (mul_ne_zero hst0 hsum0)
        have hg₁ : g 1 = 0 := by linear_combination h₀ - hg₀
        have hg₃ : g 3 = 0 := by linear_combination h₁ - s * hg₀ - t * hg₁
        have hg₂ : g 2 = 0 := by
          linear_combination h₃ - s ^ 3 * hg₀ - t ^ 3 * hg₁
        intro i
        fin_cases i <;> assumption
    | inr u =>
        exfalso
        apply hdep
        rw [Fintype.linearIndependent_iff]
        intro g hrel
        have h₀ := congrFun hrel (0 : Fin 4)
        have h₁ := congrFun hrel (1 : Fin 4)
        have h₂ := congrFun hrel (2 : Fin 4)
        have h₃ := congrFun hrel (3 : Fin 4)
        simp only [Finset.sum_apply, Pi.smul_apply, Pi.zero_apply] at h₀ h₁ h₂ h₃
        simp [twoFiniteCubicInfinityAxisFamily, projectiveTwistedCubicPoints,
          axisTwistedCubicPoints, momentCurve, Fin.sum_univ_four] at h₀ h₁ h₂ h₃
        have hprod : g 0 * (s - t) = 0 := by linear_combination h₁ - t * h₀
        have hg₀ : g 0 = 0 :=
          (mul_eq_zero.mp hprod).resolve_right (sub_ne_zero.mpr hst)
        have hg₁ : g 1 = 0 := by linear_combination h₀ - hg₀
        have hg₃ : g 3 = 0 := by linear_combination h₂ - s ^ 2 * hg₀ - t ^ 2 * hg₁
        have hg₂ : g 2 = 0 := by
          linear_combination h₃ - s ^ 3 * hg₀ - t ^ 3 * hg₁
        intro i
        fin_cases i <;> assumption
  · rintro rfl
    exact twoFiniteCubicInfinityAxis_dependent s t

/-- The projective-boundary completion is a genuine four-circuit. -/
theorem twoFiniteCubicInfinityAxis_isFourCircuit [CharP 𝔽 3] {s t : 𝔽} (hst : s ≠ t) :
    ¬ LinearIndependent 𝔽 (twoFiniteCubicInfinityAxisFamily s t (.inl (s + t))) ∧
      LinearIndependent 𝔽 ![
        projectiveTwistedCubicPoints 𝔽 (.inl t),
        projectiveTwistedCubicPoints 𝔽 (.inr Unit.unit),
        axisTwistedCubicPoints 𝔽 (.inr (.inl (s + t)))] ∧
      LinearIndependent 𝔽 ![
        projectiveTwistedCubicPoints 𝔽 (.inl s),
        projectiveTwistedCubicPoints 𝔽 (.inr Unit.unit),
        axisTwistedCubicPoints 𝔽 (.inr (.inl (s + t)))] ∧
      LinearIndependent 𝔽 ![
        projectiveTwistedCubicPoints 𝔽 (.inl s),
        projectiveTwistedCubicPoints 𝔽 (.inl t),
        axisTwistedCubicPoints 𝔽 (.inr (.inl (s + t)))] ∧
      LinearIndependent 𝔽 ![
        projectiveTwistedCubicPoints 𝔽 (.inl s),
        projectiveTwistedCubicPoints 𝔽 (.inl t),
        projectiveTwistedCubicPoints 𝔽 (.inr Unit.unit)] := by
  refine ⟨twoFiniteCubicInfinityAxis_dependent s t,
    finiteCubicInfinityAxis_linearIndependent t (.inl (s + t)),
    finiteCubicInfinityAxis_linearIndependent s (.inl (s + t)), ?_,
    twoFiniteCubicInfinity_linearIndependent hst⟩
  convert (twoCubicAxis_linearIndependent (𝔽 := 𝔽) (e₁ := 1) (e₂ := s + t) hst
    (Or.inl one_ne_zero)) using 1
  funext i
  fin_cases i <;>
    simp [projectiveTwistedCubicPoints, twoCubicAxisFamily, twistedCubicAxisVector]

#print axioms twoFiniteCubicInfinityAxis_dependent_iff
#print axioms twoFiniteCubicInfinityAxis_isFourCircuit

end FiniteGeom
