import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.PrincipalGluingPacket
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.AlternatingFiveIdentification
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.SixPointSylowFiveAction

/-!
# The six labels as the projective line over F5

The six labels used by the coefficient-heart model are identified with the
actual projective line over `ZMod 5`.  Under this equivalence, the displayed
translation is induced by `(x,y) ↦ (x,x+y)`, and the displayed inversion is
induced by `(x,y) ↦ (y,-x)`.  Together with the Sylow-normalizer results, this
realizes the concrete six-point packet as the projective-line action on the
six Sylow-five normalizers of `A5`.

The module is purely finite and algebraic.  It does not identify these six
projective points or normalizers with the manuscript's geometrically
constructed elliptic quotients and axes.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace GraphLattices

open scoped LinearAlgebra.Projectivization

/-- The field used for the six-point projective line. -/
abbrev F5 := ZMod 5

/-- The labelling `0,1,2,3,4,∞` as the affine chart of `P¹(F5)`. -/
def sixPointEquivOptionF5 : Fin 6 ≃ Option F5 :=
  { toFun := ![some 0, some 1, some 2, some 3, some 4, none]
    invFun := fun coordinate => coordinate.elim 5 fun value =>
      ⟨value.val, value.val_lt.trans (by norm_num)⟩
    left_inv := by intro label; fin_cases label <;> decide
    right_inv := by
      intro coordinate
      cases coordinate with
      | none => rfl
      | some value => fin_cases value <;> decide }

/-- The six labels as the actual projective line over `F5`. -/
noncomputable def sixPointEquivProjectiveLineF5 :
    Fin 6 ≃ Projectivization F5 (F5 × F5) :=
  sixPointEquivOptionF5.trans (optionEquivProjectiveLine F5)

/-- The determinant-one translation `(x,y) ↦ (x,x+y)`. -/
def f5ProjectiveTranslationLinearEquiv :
    (F5 × F5) ≃ₗ[F5] (F5 × F5) where
  toFun pair := (pair.1, pair.1 + pair.2)
  invFun pair := (pair.1, pair.2 - pair.1)
  left_inv pair := by ext <;> simp
  right_inv pair := by ext <;> simp
  map_add' left right := by ext <;> simp; ring
  map_smul' scalar pair := by ext <;> simp; ring

/-- The determinant-one inversion `(x,y) ↦ (y,-x)`. -/
def f5ProjectiveInversionLinearEquiv :
    (F5 × F5) ≃ₗ[F5] (F5 × F5) where
  toFun pair := (pair.2, -pair.1)
  invFun pair := (-pair.2, pair.1)
  left_inv pair := by ext <;> simp
  right_inv pair := by ext <;> simp
  map_add' left right := by ext <;> simp; ring
  map_smul' scalar pair := by ext <;> simp

/-- Translation on the actual projective line. -/
def f5ProjectiveTranslation :
    Projectivization F5 (F5 × F5) ≃
      Projectivization F5 (F5 × F5) :=
  projectivizationLinearEquiv f5ProjectiveTranslationLinearEquiv

/-- Inversion on the actual projective line. -/
def f5ProjectiveInversion :
    Projectivization F5 (F5 × F5) ≃
      Projectivization F5 (F5 × F5) :=
  projectivizationLinearEquiv f5ProjectiveInversionLinearEquiv

/-- Translation in the affine projective chart. -/
def f5OptionTranslation : Option F5 → Option F5
  | none => none
  | some value => some (value + 1)

/-- Inversion in the affine projective chart. -/
def f5OptionInversion : Option F5 → Option F5
  | none => some 0
  | some value => if value = 0 then none else some (-value⁻¹)

/-- The projective translation has its expected affine-chart formula. -/
theorem f5ProjectiveTranslation_chart (coordinate : Option F5) :
    f5ProjectiveTranslation (projectiveLineChart F5 coordinate) =
      projectiveLineChart F5 (f5OptionTranslation coordinate) := by
  cases coordinate with
  | none => rfl
  | some value =>
      simp [f5ProjectiveTranslation, projectivizationLinearEquiv,
        f5ProjectiveTranslationLinearEquiv, projectiveLineChart,
        f5OptionTranslation, scalarGraphPoint, Projectivization.map_mk,
        add_comm]

/-- The projective inversion has its expected affine-chart formula. -/
theorem f5ProjectiveInversion_chart (coordinate : Option F5) :
    f5ProjectiveInversion (projectiveLineChart F5 coordinate) =
      projectiveLineChart F5 (f5OptionInversion coordinate) := by
  cases coordinate with
  | none => rfl
  | some value =>
      by_cases zero : value = 0
      · subst value
        simp only [f5ProjectiveInversion, projectivizationLinearEquiv,
          f5ProjectiveInversionLinearEquiv, projectiveLineChart,
          f5OptionInversion, scalarGraphPoint, verticalPoint]
        apply (Projectivization.mk_eq_mk_iff' F5 _ _ _ _).2
        exact ⟨-1, by ext <;> simp⟩
      · simp only [f5ProjectiveInversion, projectivizationLinearEquiv,
          f5ProjectiveInversionLinearEquiv, projectiveLineChart,
          f5OptionInversion, scalarGraphPoint, if_neg zero]
        apply (Projectivization.mk_eq_mk_iff' F5 _ _ _ _).2
        exact ⟨value, by ext <;> simp [zero]⟩

/-- The label translation has the expected affine formula. -/
theorem sixPointEquivOptionF5_translation (label : Fin 6) :
    sixPointEquivOptionF5 (sixPointTranslationPermutation label) =
      f5OptionTranslation (sixPointEquivOptionF5 label) := by
  fin_cases label <;> decide

/-- The label inversion has the expected affine formula. -/
theorem sixPointEquivOptionF5_inversion (label : Fin 6) :
    sixPointEquivOptionF5 (sixPointInversionPermutation label) =
      f5OptionInversion (sixPointEquivOptionF5 label) := by
  have neg_inv_two : -(2 : F5)⁻¹ = (2 : F5) := by
    symm
    rw [← one_div, ← neg_div]
    apply (eq_div_iff (by decide)).2
    decide
  have neg_inv_three : -(3 : F5)⁻¹ = (3 : F5) := by
    symm
    rw [← one_div, ← neg_div]
    apply (eq_div_iff (by decide)).2
    decide
  have neg_inv_four : -(4 : F5)⁻¹ = (1 : F5) := by
    symm
    rw [← one_div, ← neg_div]
    apply (eq_div_iff (by decide)).2
    decide
  fin_cases label <;>
    simp [sixPointEquivOptionF5, sixPointInversionPermutation,
      sixPointInversionPreimage, f5OptionInversion, neg_inv_two,
      neg_inv_three, neg_inv_four] <;>
    decide

/-- The displayed six-point translation is the genuine projective translation
on `P¹(F5)`. -/
theorem sixPointEquivProjectiveLineF5_translation (label : Fin 6) :
    sixPointEquivProjectiveLineF5
        (sixPointTranslationPermutation label) =
      f5ProjectiveTranslation (sixPointEquivProjectiveLineF5 label) := by
  change projectiveLineChart F5
      (sixPointEquivOptionF5 (sixPointTranslationPermutation label)) =
    f5ProjectiveTranslation
      (projectiveLineChart F5 (sixPointEquivOptionF5 label))
  rw [sixPointEquivOptionF5_translation]
  exact (f5ProjectiveTranslation_chart _).symm

/-- The displayed six-point inversion is the genuine projective transformation
`[x:y] ↦ [y:-x]` on `P¹(F5)`. -/
theorem sixPointEquivProjectiveLineF5_inversion (label : Fin 6) :
    sixPointEquivProjectiveLineF5
        (sixPointInversionPermutation label) =
      f5ProjectiveInversion (sixPointEquivProjectiveLineF5 label) := by
  change projectiveLineChart F5
      (sixPointEquivOptionF5 (sixPointInversionPermutation label)) =
    f5ProjectiveInversion
      (projectiveLineChart F5 (sixPointEquivOptionF5 label))
  rw [sixPointEquivOptionF5_inversion]
  exact (f5ProjectiveInversion_chart _).symm

/-- The projective-line labels and Sylow-five subgroups are explicitly
equivalent through their common six-label model. -/
noncomputable def f5ProjectiveLineEquivFiveSylow :
    Projectivization F5 (F5 × F5) ≃
      Sylow 5 (alternatingGroup (Fin 5)) :=
  sixPointEquivProjectiveLineF5.symm.trans sixPointFiveSylowEquiv

end GraphLattices

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
