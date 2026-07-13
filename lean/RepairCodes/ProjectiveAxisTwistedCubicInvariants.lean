import RepairCodes.AxisTwistedCubicInvariants
import RepairCodes.ProjectiveAxisTwistedCubic

/-!
# Invariants of the projectively completed cubic--axis seed

This module begins the exact repair-port layer.  Its first structural map is projective shifted
inversion on the cubic parameter line.  For a finite axis target `a`, it extends the affine map
`s ↦ (s+a)⁻¹` by sending `s=-a` to projective infinity and cubic infinity to zero.  This is
the parameter permutation needed to compare every finite completion fiber with the zero-sum fiber
at axis infinity.
-/

namespace RepairCodes

open FiniteGeom

variable {𝔽 : Type*} [Field 𝔽]

/-- Ambient coordinate change inducing projective shifted inversion. -/
def projectiveShiftInvLinearMap (a : 𝔽) : (Fin 4 → 𝔽) →ₗ[𝔽] (Fin 4 → 𝔽) where
  toFun x := ![a ^ 3 * x 0 + x 3, a ^ 2 * x 0 - a * x 1 + x 2, a * x 0 + x 1, x 0]
  map_add' x y := by
    ext i
    fin_cases i <;> simp <;> ring
  map_smul' c x := by
    ext i
    fin_cases i <;> simp <;> ring

theorem projectiveShiftInvLinearMap_injective (a : 𝔽) :
    Function.Injective (projectiveShiftInvLinearMap a) := by
  intro x y hxy
  have hz : projectiveShiftInvLinearMap a (x - y) = 0 := by
    rw [map_sub, hxy, sub_self]
  have h₀ := congrFun hz (0 : Fin 4)
  have h₁ := congrFun hz (1 : Fin 4)
  have h₂ := congrFun hz (2 : Fin 4)
  have h₃ := congrFun hz (3 : Fin 4)
  change a ^ 3 * (x - y) 0 + (x - y) 3 = 0 at h₀
  change a ^ 2 * (x - y) 0 - a * (x - y) 1 + (x - y) 2 = 0 at h₁
  change a * (x - y) 0 + (x - y) 1 = 0 at h₂
  change (x - y) 0 = 0 at h₃
  have hx₀ : (x - y) 0 = 0 := h₃
  have hx₁ : (x - y) 1 = 0 := by linear_combination h₂ - a * hx₀
  have hx₂ : (x - y) 2 = 0 := by linear_combination h₁ - a ^ 2 * hx₀ + a * hx₁
  have hx₃ : (x - y) 3 = 0 := by linear_combination h₀ - a ^ 3 * hx₀
  apply sub_eq_zero.mp
  funext i
  fin_cases i <;> assumption

/-- The ambient shifted-inversion coordinate change is invertible. -/
noncomputable def projectiveShiftInvLinearEquiv (a : 𝔽) :
    (Fin 4 → 𝔽) ≃ₗ[𝔽] (Fin 4 → 𝔽) :=
  LinearEquiv.ofInjectiveEndo (projectiveShiftInvLinearMap a)
    (projectiveShiftInvLinearMap_injective a)

@[simp] theorem projectiveShiftInvLinearEquiv_apply (a : 𝔽) (x : Fin 4 → 𝔽) :
    projectiveShiftInvLinearEquiv a x = projectiveShiftInvLinearMap a x := rfl

/-- Direct homogeneous action on a finite cubic point. -/
theorem projectiveShiftInvLinearMap_cubic_finite [CharP 𝔽 3] (a s : 𝔽) :
    projectiveShiftInvLinearMap a (projectiveTwistedCubicPoints 𝔽 (.inl s)) =
      ![(s + a) ^ 3, (s + a) ^ 2, s + a, 1] := by
  ext i
  fin_cases i
  · simp [projectiveShiftInvLinearMap, projectiveTwistedCubicPoints, momentCurve,
      add_pow_char, add_comm]
  · simp [projectiveShiftInvLinearMap, projectiveTwistedCubicPoints, momentCurve, add_comm]
    linear_combination -(a * s) * CharP.cast_eq_zero 𝔽 3
  · simp [projectiveShiftInvLinearMap, projectiveTwistedCubicPoints, momentCurve, add_comm]
  · simp [projectiveShiftInvLinearMap, projectiveTwistedCubicPoints, momentCurve]

/-- Away from the pole, the ambient action is the normalized shifted-inversion cubic point up to
the displayed nonzero projective scale. -/
theorem projectiveShiftInvLinearMap_cubic_finite_of_ne [CharP 𝔽 3] (a s : 𝔽)
    (hs : s + a ≠ 0) :
    projectiveShiftInvLinearMap a (projectiveTwistedCubicPoints 𝔽 (.inl s)) =
      (s + a) ^ 3 • projectiveTwistedCubicPoints 𝔽 (.inl ((s + a)⁻¹)) := by
  rw [projectiveShiftInvLinearMap_cubic_finite]
  ext i
  fin_cases i <;>
    simp [projectiveTwistedCubicPoints, momentCurve, Pi.smul_apply] <;> field_simp

@[simp] theorem projectiveShiftInvLinearMap_cubic_pole [CharP 𝔽 3] (a : 𝔽) :
    projectiveShiftInvLinearMap a (projectiveTwistedCubicPoints 𝔽 (.inl (-a))) =
      projectiveTwistedCubicPoints 𝔽 (.inr Unit.unit) := by
  rw [projectiveShiftInvLinearMap_cubic_finite]
  ext i
  fin_cases i <;> simp [projectiveTwistedCubicPoints]

@[simp] theorem projectiveShiftInvLinearMap_cubic_infinity (a : 𝔽) :
    projectiveShiftInvLinearMap a (projectiveTwistedCubicPoints 𝔽 (.inr Unit.unit)) =
      projectiveTwistedCubicPoints 𝔽 (.inl 0) := by
  ext i
  fin_cases i <;>
    simp [projectiveShiftInvLinearMap, projectiveTwistedCubicPoints, momentCurve]

/-- Direct homogeneous action on a finite normalized axis point. -/
theorem projectiveShiftInvLinearMap_axis_finite (a y : 𝔽) :
    projectiveShiftInvLinearMap a (axisTwistedCubicPoints 𝔽 (.inr (.inl y))) =
      ![0, y - a, 1, 0] := by
  ext i
  fin_cases i <;> simp [projectiveShiftInvLinearMap, axisTwistedCubicPoints] <;> ring

theorem projectiveShiftInvLinearMap_axis_finite_of_ne (a y : 𝔽) (hy : y - a ≠ 0) :
    projectiveShiftInvLinearMap a (axisTwistedCubicPoints 𝔽 (.inr (.inl y))) =
      (y - a) • axisTwistedCubicPoints 𝔽 (.inr (.inl ((y - a)⁻¹))) := by
  rw [projectiveShiftInvLinearMap_axis_finite]
  ext i
  fin_cases i <;> simp [axisTwistedCubicPoints, Pi.smul_apply] <;> field_simp

@[simp] theorem projectiveShiftInvLinearMap_axis_target (a : 𝔽) :
    projectiveShiftInvLinearMap a (axisTwistedCubicPoints 𝔽 (.inr (.inl a))) =
      axisTwistedCubicPoints 𝔽 (.inr (.inr Unit.unit)) := by
  rw [projectiveShiftInvLinearMap_axis_finite]
  ext i
  fin_cases i <;> simp [axisTwistedCubicPoints]

@[simp] theorem projectiveShiftInvLinearMap_axis_infinity (a : 𝔽) :
    projectiveShiftInvLinearMap a (axisTwistedCubicPoints 𝔽 (.inr (.inr Unit.unit))) =
      axisTwistedCubicPoints 𝔽 (.inr (.inl 0)) := by
  ext i
  fin_cases i <;> simp [projectiveShiftInvLinearMap, axisTwistedCubicPoints]

variable [DecidableEq 𝔽]

/-- Projective extension of shifted inversion on the cubic parameter line. -/
def projectiveAxisShiftInvEquiv (a : 𝔽) :
    ProjectiveTwistedCubicIndex 𝔽 ≃ ProjectiveTwistedCubicIndex 𝔽 where
  toFun
    | .inl s => if s + a = 0 then .inr Unit.unit else .inl (s + a)⁻¹
    | .inr _ => .inl 0
  invFun
    | .inl r => if r = 0 then .inr Unit.unit else .inl (r⁻¹ - a)
    | .inr _ => .inl (-a)
  left_inv := by
    intro x
    cases x with
    | inl s =>
        by_cases hs : s + a = 0
        · have hsa : s = -a := by linear_combination hs
          simp [hsa]
        · have hinv : (s + a)⁻¹ ≠ 0 := inv_ne_zero hs
          simp [hs, hinv, inv_inv]
    | inr u => simp
  right_inv := by
    intro x
    cases x with
    | inl r =>
        by_cases hr : r = 0
        · subst r
          simp
        · have hinv : r⁻¹ ≠ 0 := inv_ne_zero hr
          simp [hr, hinv, inv_inv]
    | inr u => simp

@[simp] theorem projectiveAxisShiftInvEquiv_infinity (a : 𝔽) :
    projectiveAxisShiftInvEquiv a (.inr Unit.unit) = .inl 0 := rfl

@[simp] theorem projectiveAxisShiftInvEquiv_neg (a : 𝔽) :
    projectiveAxisShiftInvEquiv a (.inl (-a)) = .inr Unit.unit := by
  simp [projectiveAxisShiftInvEquiv]

theorem projectiveAxisShiftInvEquiv_finite_of_ne (a s : 𝔽) (hs : s + a ≠ 0) :
    projectiveAxisShiftInvEquiv a (.inl s) = .inl ((s + a)⁻¹) := by
  simp [projectiveAxisShiftInvEquiv, hs]

theorem projectiveAxisShiftInvEquiv_finite_iff (a s r : 𝔽) :
    projectiveAxisShiftInvEquiv a (.inl s) = .inl r ↔
      s + a ≠ 0 ∧ r = (s + a)⁻¹ := by
  by_cases hs : s + a = 0
  · simp [projectiveAxisShiftInvEquiv, hs]
  · simp [projectiveAxisShiftInvEquiv, hs, eq_comm]

theorem projectiveAxisShiftInvEquiv_eq_infinity_iff (a : 𝔽)
    (x : ProjectiveTwistedCubicIndex 𝔽) :
    projectiveAxisShiftInvEquiv a x = .inr Unit.unit ↔ x = .inl (-a) := by
  cases x with
  | inl s =>
      by_cases hs : s + a = 0
      · have hsa : s = -a := by linear_combination hs
        simp [projectiveAxisShiftInvEquiv, hsa]
      · have hsa : s ≠ -a := by
          intro h
          apply hs
          rw [h]
          simp
        simp [projectiveAxisShiftInvEquiv, hs, hsa]
  | inr u => simp [projectiveAxisShiftInvEquiv]

#print axioms projectiveAxisShiftInvEquiv
#print axioms projectiveAxisShiftInvEquiv_eq_infinity_iff
#print axioms projectiveShiftInvLinearEquiv
#print axioms projectiveShiftInvLinearMap_cubic_finite_of_ne
#print axioms projectiveShiftInvLinearMap_axis_finite_of_ne

end RepairCodes
