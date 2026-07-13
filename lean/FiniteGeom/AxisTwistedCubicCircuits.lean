import FiniteGeom.AxisTwistedCubic
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic

/-!
# Small circuits of the characteristic-three twisted-cubic–axis system

This module develops the algebraic hinge of the size-at-most-four circuit classification.  Three
finite cubic points at parameters `s,t,u` together with an arbitrary axis vector `(0,e₁,e₂,0)`
are dependent exactly when

`e₁(st+su+tu) = e₂(s+t+u)`.

Thus the paper's displayed axis point `(0:s+t+u:st+su+tu:0)` always gives a dependent four-set.
For distinct parameters in characteristic three its two axis coordinates cannot both vanish, and
the determinant criterion identifies this as the unique projective axis point completing the
three cubic points to a four-circuit.
-/

namespace FiniteGeom

open Matrix

variable {𝔽 : Type*} [Field 𝔽]

/-- Normalized two-coordinate model of the projective axis. -/
def twistedCubicAxisCoordinates : 𝔽 ⊕ Unit → (Fin 2 → 𝔽)
  | .inl u => ![1, u]
  | .inr _ => ![0, 1]

/-- Linear inclusion of the axis coordinate plane into `𝔽⁴`. -/
def twistedCubicAxisEmbed : (Fin 2 → 𝔽) →ₗ[𝔽] (Fin 4 → 𝔽) where
  toFun x := ![0, x 0, x 1, 0]
  map_add' x y := by ext i; fin_cases i <;> simp
  map_smul' c x := by ext i; fin_cases i <;> simp

@[simp] theorem twistedCubicAxisEmbed_coordinates (y : 𝔽 ⊕ Unit) :
    twistedCubicAxisEmbed (twistedCubicAxisCoordinates y) =
      axisTwistedCubicPoints 𝔽 (.inr y) := by
  cases y with
  | inl u => ext i; fin_cases i <;> simp [twistedCubicAxisEmbed, twistedCubicAxisCoordinates]
  | inr u => ext i; fin_cases i <;> simp [twistedCubicAxisEmbed, twistedCubicAxisCoordinates]

@[simp] theorem axisTwistedCubicPoints_axis_coord_zero (y : 𝔽 ⊕ Unit) :
    axisTwistedCubicPoints 𝔽 (.inr y) 0 = 0 := by cases y <;> rfl

@[simp] theorem axisTwistedCubicPoints_axis_coord_three (y : 𝔽 ⊕ Unit) :
    axisTwistedCubicPoints 𝔽 (.inr y) 3 = 0 := by cases y <;> rfl

/-- Distinct normalized axis points give independent vectors. -/
theorem twistedCubicAxis_pair_linearIndependent {y z : 𝔽 ⊕ Unit} (hyz : y ≠ z) :
    LinearIndependent 𝔽 ![
      axisTwistedCubicPoints 𝔽 (.inr y), axisTwistedCubicPoints 𝔽 (.inr z)] := by
  rw [Fintype.linearIndependent_iff]
  intro g hrel
  have h1 := congrFun hrel (1 : Fin 4)
  have h2 := congrFun hrel (2 : Fin 4)
  simp only [Finset.sum_apply, Pi.smul_apply, Pi.zero_apply] at h1 h2
  cases y with
  | inl y =>
      cases z with
      | inl z =>
          have hyz' : y ≠ z := fun h => hyz (congrArg Sum.inl h)
          simp [Fin.sum_univ_two] at h1 h2
          have hprod : g 0 * (y - z) = 0 := by linear_combination h2 - z * h1
          have hg0 : g 0 = 0 :=
            (mul_eq_zero.mp hprod).resolve_right (sub_ne_zero.mpr hyz')
          have hg1 : g 1 = 0 := by linear_combination h1 - hg0
          intro i
          fin_cases i <;> assumption
      | inr z =>
          simp [Fin.sum_univ_two] at h1 h2
          have hg1 : g 1 = 0 := by linear_combination h2 - y * h1
          intro i
          fin_cases i <;> assumption
  | inr y =>
      cases z with
      | inl z =>
          simp [Fin.sum_univ_two] at h1 h2
          have hg0 : g 0 = 0 := by linear_combination h2 - z * h1
          intro i
          fin_cases i <;> assumption
      | inr z =>
          exact (hyz (by congr)).elim

/-- Any three axis vectors are dependent: after rewriting through the two-dimensional axis
embedding, independence would force three independent vectors in `𝔽²`. -/
theorem twistedCubicAxis_triple_dependent (w : Fin 3 → 𝔽 ⊕ Unit) :
    ¬ LinearIndependent 𝔽 (fun i => axisTwistedCubicPoints 𝔽 (.inr (w i))) := by
  intro hli
  have heq : (fun i => axisTwistedCubicPoints 𝔽 (.inr (w i))) =
      (fun i => twistedCubicAxisEmbed (twistedCubicAxisCoordinates (w i))) := by
    funext i
    exact (twistedCubicAxisEmbed_coordinates (w i)).symm
  rw [heq] at hli
  have hcoords : LinearIndependent 𝔽 (fun i => twistedCubicAxisCoordinates (w i)) :=
    LinearIndependent.of_comp twistedCubicAxisEmbed hli
  have hcard := hcoords.fintype_card_le_finrank
  simp only [Fintype.card_fin, Module.finrank_pi] at hcard
  omega

/-- Three distinct axis points form a three-circuit. -/
theorem twistedCubicAxis_triple_isCircuit {w : Fin 3 → 𝔽 ⊕ Unit}
    (hw : Function.Injective w) :
    ¬ LinearIndependent 𝔽 (fun i => axisTwistedCubicPoints 𝔽 (.inr (w i))) ∧
      LinearIndependent 𝔽 ![
        axisTwistedCubicPoints 𝔽 (.inr (w 1)), axisTwistedCubicPoints 𝔽 (.inr (w 2))] ∧
      LinearIndependent 𝔽 ![
        axisTwistedCubicPoints 𝔽 (.inr (w 0)), axisTwistedCubicPoints 𝔽 (.inr (w 2))] ∧
      LinearIndependent 𝔽 ![
        axisTwistedCubicPoints 𝔽 (.inr (w 0)), axisTwistedCubicPoints 𝔽 (.inr (w 1))] := by
  refine ⟨twistedCubicAxis_triple_dependent w, ?_, ?_, ?_⟩
  · exact twistedCubicAxis_pair_linearIndependent (hw.ne (by decide : (1 : Fin 3) ≠ 2))
  · exact twistedCubicAxis_pair_linearIndependent (hw.ne (by decide : (0 : Fin 3) ≠ 2))
  · exact twistedCubicAxis_pair_linearIndependent (hw.ne (by decide : (0 : Fin 3) ≠ 1))

/-- Two cubic columns followed by two axis columns. -/
def twoCubicTwoAxisFamily (s t : 𝔽) (y z : 𝔽 ⊕ Unit) : Fin 4 → (Fin 4 → 𝔽) :=
  ![momentCurve 4 s, momentCurve 4 t,
    axisTwistedCubicPoints 𝔽 (.inr y), axisTwistedCubicPoints 𝔽 (.inr z)]

/-- Two distinct cubic points and two distinct axis points are independent in characteristic
three.  This excludes the only remaining mixed four-set from the small-circuit list. -/
theorem twoCubicTwoAxis_linearIndependent [CharP 𝔽 3] {s t : 𝔽} {y z : 𝔽 ⊕ Unit}
    (hst : s ≠ t) (hyz : y ≠ z) : LinearIndependent 𝔽 (twoCubicTwoAxisFamily s t y z) := by
  rw [Fintype.linearIndependent_iff]
  intro g hrel
  have h0 := congrFun hrel (0 : Fin 4)
  have h3 := congrFun hrel (3 : Fin 4)
  simp only [Finset.sum_apply, Pi.smul_apply, Pi.zero_apply] at h0 h3
  simp [twoCubicTwoAxisFamily, momentCurve, Fin.sum_univ_four] at h0 h3
  have hcubes : s ^ 3 ≠ t ^ 3 := fun h => hst ((frobenius_inj 𝔽 3) h)
  have hprod : g 0 * (s ^ 3 - t ^ 3) = 0 := by
    linear_combination h3 - t ^ 3 * h0
  have hg0 : g 0 = 0 := (mul_eq_zero.mp hprod).resolve_right (sub_ne_zero.mpr hcubes)
  have hg1 : g 1 = 0 := by linear_combination h0 - hg0
  have haxisrel :
      ∑ i : Fin 2, (![g 2, g 3] : Fin 2 → 𝔽) i •
        (![axisTwistedCubicPoints 𝔽 (.inr y), axisTwistedCubicPoints 𝔽 (.inr z)] :
          Fin 2 → (Fin 4 → 𝔽)) i = 0 := by
    simpa [twoCubicTwoAxisFamily, Fin.sum_univ_four, Fin.sum_univ_two, hg0, hg1] using hrel
  have hcoeff := (Fintype.linearIndependent_iff.mp
    (twistedCubicAxis_pair_linearIndependent (𝔽 := 𝔽) hyz)) ![g 2, g 3] haxisrel
  have hg2 : g 2 = 0 := hcoeff 0
  have hg3 : g 3 = 0 := hcoeff 1
  intro i
  fin_cases i <;> assumption

/-- One cubic column followed by two axis columns. -/
def oneCubicTwoAxisFamily (s : 𝔽) (y z : 𝔽 ⊕ Unit) : Fin 3 → (Fin 4 → 𝔽) :=
  ![momentCurve 4 s, axisTwistedCubicPoints 𝔽 (.inr y), axisTwistedCubicPoints 𝔽 (.inr z)]

/-- One cubic point and two distinct axis points are independent. -/
theorem oneCubicTwoAxis_linearIndependent {s : 𝔽} {y z : 𝔽 ⊕ Unit} (hyz : y ≠ z) :
    LinearIndependent 𝔽 (oneCubicTwoAxisFamily s y z) := by
  rw [Fintype.linearIndependent_iff]
  intro g hrel
  have h0 := congrFun hrel (0 : Fin 4)
  simp only [Finset.sum_apply, Pi.smul_apply, Pi.zero_apply] at h0
  simp [oneCubicTwoAxisFamily, momentCurve, Fin.sum_univ_three] at h0
  have haxisrel :
      ∑ i : Fin 2, (![g 1, g 2] : Fin 2 → 𝔽) i •
        (![axisTwistedCubicPoints 𝔽 (.inr y), axisTwistedCubicPoints 𝔽 (.inr z)] :
          Fin 2 → (Fin 4 → 𝔽)) i = 0 := by
    simpa [oneCubicTwoAxisFamily, Fin.sum_univ_three, Fin.sum_univ_two, h0] using hrel
  have hcoeff := (Fintype.linearIndependent_iff.mp
    (twistedCubicAxis_pair_linearIndependent (𝔽 := 𝔽) hyz)) ![g 1, g 2] haxisrel
  have hg1 : g 1 = 0 := hcoeff 0
  have hg2 : g 2 = 0 := hcoeff 1
  intro i
  fin_cases i <;> assumption

/-- An axis vector on `X₀=X₃=0`, without projective normalization. -/
def twistedCubicAxisVector (e₁ e₂ : 𝔽) : Fin 4 → 𝔽 := ![0, e₁, e₂, 0]

/-- Three cubic columns followed by an arbitrary axis column. -/
def twistedCubicAxisCircuitMatrix (v : Fin 3 → 𝔽) (e₁ e₂ : 𝔽) :
    Matrix (Fin 4) (Fin 4) 𝔽 :=
  !![1, 1, 1, 0;
     v 0, v 1, v 2, e₁;
     (v 0) ^ 2, (v 1) ^ 2, (v 2) ^ 2, e₂;
     (v 0) ^ 3, (v 1) ^ 3, (v 2) ^ 3, 0]

theorem twistedCubicAxisCircuitMatrix_col_cubic (v : Fin 3 → 𝔽) (e₁ e₂ : 𝔽)
    (j : Fin 3) :
    (twistedCubicAxisCircuitMatrix v e₁ e₂).col j.castSucc = momentCurve 4 (v j) := by
  ext i
  fin_cases i <;> fin_cases j <;> simp [twistedCubicAxisCircuitMatrix, momentCurve]

theorem twistedCubicAxisCircuitMatrix_col_axis (v : Fin 3 → 𝔽) (e₁ e₂ : 𝔽) :
    (twistedCubicAxisCircuitMatrix v e₁ e₂).col (Fin.last 3) =
      twistedCubicAxisVector e₁ e₂ := by
  ext i
  fin_cases i <;> simp [twistedCubicAxisCircuitMatrix, twistedCubicAxisVector]

/-- Field-generic determinant formula.  The Vandermonde factor detects repeated cubic parameters;
the final factor is the projectively invariant incidence equation for the axis point. -/
theorem twistedCubicAxisCircuitMatrix_det (v : Fin 3 → 𝔽) (e₁ e₂ : 𝔽) :
    (twistedCubicAxisCircuitMatrix v e₁ e₂).det =
      (v 1 - v 0) * (v 2 - v 0) * (v 2 - v 1) *
        (e₁ * (v 0 * v 1 + v 0 * v 2 + v 1 * v 2) - e₂ * (v 0 + v 1 + v 2)) := by
  let M₁ : Matrix (Fin 3) (Fin 3) 𝔽 :=
    !![1, 1, 1;
       (v 0) ^ 2, (v 1) ^ 2, (v 2) ^ 2;
       (v 0) ^ 3, (v 1) ^ 3, (v 2) ^ 3]
  let M₂ : Matrix (Fin 3) (Fin 3) 𝔽 :=
    !![1, 1, 1;
       v 0, v 1, v 2;
       (v 0) ^ 3, (v 1) ^ 3, (v 2) ^ 3]
  have hr0 : Fin.succAbove (1 : Fin 4) (0 : Fin 3) = 0 := by decide
  have hr1 : Fin.succAbove (1 : Fin 4) (1 : Fin 3) = 2 := by decide
  have hr2 : Fin.succAbove (1 : Fin 4) (2 : Fin 3) = 3 := by decide
  have hs0 : Fin.succAbove (2 : Fin 4) (0 : Fin 3) = 0 := by decide
  have hs1 : Fin.succAbove (2 : Fin 4) (1 : Fin 3) = 1 := by decide
  have hs2 : Fin.succAbove (2 : Fin 4) (2 : Fin 3) = 3 := by decide
  have hc0 : Fin.succAbove (3 : Fin 4) (0 : Fin 3) = 0 := by decide
  have hc1 : Fin.succAbove (3 : Fin 4) (1 : Fin 3) = 1 := by decide
  have hc2 : Fin.succAbove (3 : Fin 4) (2 : Fin 3) = 2 := by decide
  have hsub₁ : (twistedCubicAxisCircuitMatrix v e₁ e₂).submatrix
      (Fin.succAbove (1 : Fin 4)) (Fin.succAbove (3 : Fin 4)) = M₁ := by
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp [twistedCubicAxisCircuitMatrix, M₁, hr0, hr1, hr2, hc0, hc1, hc2]
  have hsub₂ : (twistedCubicAxisCircuitMatrix v e₁ e₂).submatrix
      (Fin.succAbove (2 : Fin 4)) (Fin.succAbove (3 : Fin 4)) = M₂ := by
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp [twistedCubicAxisCircuitMatrix, M₂, hs0, hs1, hs2, hc0, hc1, hc2]
  rw [Matrix.det_succ_column (twistedCubicAxisCircuitMatrix v e₁ e₂) (3 : Fin 4)]
  rw [Fin.sum_univ_four, hsub₁, hsub₂]
  norm_num [twistedCubicAxisCircuitMatrix]
  rw [Matrix.det_fin_three M₁, Matrix.det_fin_three M₂]
  simp [M₁, M₂]
  ring

/-- For distinct cubic parameters, dependence is exactly the axis incidence equation. -/
theorem twistedCubicAxisCircuitMatrix_det_eq_zero_iff {v : Fin 3 → 𝔽}
    (hv : Function.Injective v) (e₁ e₂ : 𝔽) :
    (twistedCubicAxisCircuitMatrix v e₁ e₂).det = 0 ↔
      e₁ * (v 0 * v 1 + v 0 * v 2 + v 1 * v 2) = e₂ * (v 0 + v 1 + v 2) := by
  rw [twistedCubicAxisCircuitMatrix_det, mul_eq_zero]
  have h10 : v 1 - v 0 ≠ 0 := sub_ne_zero.mpr (hv.ne (by decide))
  have h20 : v 2 - v 0 ≠ 0 := sub_ne_zero.mpr (hv.ne (by decide))
  have h21 : v 2 - v 1 ≠ 0 := sub_ne_zero.mpr (hv.ne (by decide))
  simp [h10, h20, h21, sub_eq_zero]

/-- Column-dependence form of the determinant criterion. -/
theorem twistedCubicAxisCircuit_dependent_iff {v : Fin 3 → 𝔽}
    (hv : Function.Injective v) (e₁ e₂ : 𝔽) :
    ¬ LinearIndependent 𝔽 (twistedCubicAxisCircuitMatrix v e₁ e₂).col ↔
      e₁ * (v 0 * v 1 + v 0 * v 2 + v 1 * v 2) = e₂ * (v 0 + v 1 + v 2) := by
  rw [← twistedCubicAxisCircuitMatrix_det_eq_zero_iff hv e₁ e₂]
  constructor
  · exact Matrix.det_eq_zero_of_not_linearIndependent_cols
  · intro hdet hli
    have hunit : IsUnit (twistedCubicAxisCircuitMatrix v e₁ e₂) :=
      Matrix.linearIndependent_cols_iff_isUnit.mp hli
    exact (twistedCubicAxisCircuitMatrix v e₁ e₂).isUnit_iff_isUnit_det.mp hunit |>.ne_zero hdet

/-- Two distinct cubic points together with any nonzero axis vector are independent in
characteristic three.  Projection to coordinates `X₀,X₃` sees `(1,s³),(1,t³),(0,0)`; Frobenius
separates the two cubic parameters, after which either nonzero axis coordinate kills the last
coefficient. -/
def twoCubicAxisFamily (s t e₁ e₂ : 𝔽) : Fin 3 → (Fin 4 → 𝔽) :=
  ![momentCurve 4 s, momentCurve 4 t, twistedCubicAxisVector e₁ e₂]

theorem twoCubicAxis_linearIndependent [CharP 𝔽 3] {s t e₁ e₂ : 𝔽}
    (hst : s ≠ t) (haxis : e₁ ≠ 0 ∨ e₂ ≠ 0) :
    LinearIndependent 𝔽 (twoCubicAxisFamily s t e₁ e₂) := by
  rw [Fintype.linearIndependent_iff]
  intro g hrel
  have h0 := congrFun hrel (0 : Fin 4)
  have h3 := congrFun hrel (3 : Fin 4)
  simp only [Finset.sum_apply, Pi.smul_apply, Pi.zero_apply] at h0 h3
  simp [twoCubicAxisFamily, momentCurve, twistedCubicAxisVector, Fin.sum_univ_three] at h0 h3
  have hcubes : s ^ 3 ≠ t ^ 3 := fun h => hst ((frobenius_inj 𝔽 3) h)
  have hprod : g 0 * (s ^ 3 - t ^ 3) = 0 := by
    linear_combination h3 - t ^ 3 * h0
  have hg0 : g 0 = 0 := (mul_eq_zero.mp hprod).resolve_right (sub_ne_zero.mpr hcubes)
  have hg1 : g 1 = 0 := by linear_combination h0 - hg0
  have hg2 : g 2 = 0 := by
    rcases haxis with he₁ | he₂
    · have h1 := congrFun hrel (1 : Fin 4)
      simp only [Finset.sum_apply, Pi.smul_apply, Pi.zero_apply] at h1
      simp [twoCubicAxisFamily, momentCurve, twistedCubicAxisVector, Fin.sum_univ_three,
        hg0, hg1] at h1
      exact h1.resolve_right he₁
    · have h2 := congrFun hrel (2 : Fin 4)
      simp only [Finset.sum_apply, Pi.smul_apply, Pi.zero_apply] at h2
      simp [twoCubicAxisFamily, momentCurve, twistedCubicAxisVector, Fin.sum_univ_three,
        hg0, hg1] at h2
      exact h2.resolve_right he₂
  intro i
  fin_cases i <;> assumption

/-- The symmetric-coordinate axis vector attached to a cubic triple. -/
def twistedCubicTripleAxis (v : Fin 3 → 𝔽) : Fin 4 → 𝔽 :=
  twistedCubicAxisVector (v 0 + v 1 + v 2)
    (v 0 * v 1 + v 0 * v 2 + v 1 * v 2)

/-- Removing the axis column leaves three independent cubic points. -/
theorem twistedCubicTriple_omitAxis_linearIndependent {v : Fin 3 → 𝔽}
    (hv : Function.Injective v) :
    LinearIndependent 𝔽 (fun j : Fin 3 => axisTwistedCubicPoints 𝔽 (.inl (v j))) := by
  simpa only [axisTwistedCubicPoints_cubic] using
    (momentCurve_linearIndependent_of_card_le (n := 4) hv (by decide))

section Normalized

variable [DecidableEq 𝔽]

/-- The normalized point of the actual axis block selected by a cubic triple. -/
noncomputable def twistedCubicTripleAxisIndex (v : Fin 3 → 𝔽) : 𝔽 ⊕ Unit :=
  if v 0 + v 1 + v 2 = 0 then .inr Unit.unit
  else .inl ((v 0 * v 1 + v 0 * v 2 + v 1 * v 2) / (v 0 + v 1 + v 2))

noncomputable def twistedCubicTripleAxisE₁ (v : Fin 3 → 𝔽) : 𝔽 :=
  if v 0 + v 1 + v 2 = 0 then 0 else 1

noncomputable def twistedCubicTripleAxisE₂ (v : Fin 3 → 𝔽) : 𝔽 :=
  if v 0 + v 1 + v 2 = 0 then 1
  else (v 0 * v 1 + v 0 * v 2 + v 1 * v 2) / (v 0 + v 1 + v 2)

theorem axisTwistedCubicPoints_tripleAxisIndex (v : Fin 3 → 𝔽) :
    axisTwistedCubicPoints 𝔽 (.inr (twistedCubicTripleAxisIndex v)) =
      twistedCubicAxisVector (twistedCubicTripleAxisE₁ v) (twistedCubicTripleAxisE₂ v) := by
  by_cases hsum : v 0 + v 1 + v 2 = 0
  · simp [twistedCubicTripleAxisIndex, twistedCubicTripleAxisE₁,
      twistedCubicTripleAxisE₂, hsum, twistedCubicAxisVector]
  · simp [twistedCubicTripleAxisIndex, twistedCubicTripleAxisE₁,
      twistedCubicTripleAxisE₂, hsum, twistedCubicAxisVector]

theorem twistedCubicTripleAxis_normalized_coordinates_ne_zero (v : Fin 3 → 𝔽) :
    twistedCubicTripleAxisE₁ v ≠ 0 ∨ twistedCubicTripleAxisE₂ v ≠ 0 := by
  by_cases hsum : v 0 + v 1 + v 2 = 0
  · right
    simp [twistedCubicTripleAxisE₂, hsum]
  · left
    simp [twistedCubicTripleAxisE₁, hsum]

/-- The normalized axis point actually present in `S_q` completes the cubic triple to a dependent
four-family. -/
theorem twistedCubicTripleAxis_normalized_det_eq_zero (v : Fin 3 → 𝔽) :
    (twistedCubicAxisCircuitMatrix v (twistedCubicTripleAxisE₁ v)
      (twistedCubicTripleAxisE₂ v)).det = 0 := by
  rw [twistedCubicAxisCircuitMatrix_det]
  by_cases hsum : v 0 + v 1 + v 2 = 0
  · simp [twistedCubicTripleAxisE₁, twistedCubicTripleAxisE₂, hsum]
  · simp only [twistedCubicTripleAxisE₁, twistedCubicTripleAxisE₂, hsum, ↓reduceIte]
    rw [div_mul_cancel₀ _ hsum]
    ring

/-- The actual four columns in `S_q`: three cubic points followed by their normalized completing
axis point. -/
noncomputable def twistedCubicTripleFamily (v : Fin 3 → 𝔽) : Fin 4 → (Fin 4 → 𝔽) :=
  Fin.lastCases (axisTwistedCubicPoints 𝔽 (.inr (twistedCubicTripleAxisIndex v)))
    (fun j => axisTwistedCubicPoints 𝔽 (.inl (v j)))

@[simp] theorem twistedCubicTripleFamily_castSucc (v : Fin 3 → 𝔽) (j : Fin 3) :
    twistedCubicTripleFamily v j.castSucc = momentCurve 4 (v j) := by
  rw [twistedCubicTripleFamily, Fin.lastCases_castSucc]
  rfl

@[simp] theorem twistedCubicTripleFamily_last (v : Fin 3 → 𝔽) :
    twistedCubicTripleFamily v (Fin.last 3) =
      axisTwistedCubicPoints 𝔽 (.inr (twistedCubicTripleAxisIndex v)) := by
  rw [twistedCubicTripleFamily, Fin.lastCases_last]

@[simp] theorem twistedCubicTripleFamily_zero (v : Fin 3 → 𝔽) :
    twistedCubicTripleFamily v 0 = momentCurve 4 (v 0) :=
  twistedCubicTripleFamily_castSucc v 0

@[simp] theorem twistedCubicTripleFamily_one (v : Fin 3 → 𝔽) :
    twistedCubicTripleFamily v 1 = momentCurve 4 (v 1) :=
  twistedCubicTripleFamily_castSucc v 1

@[simp] theorem twistedCubicTripleFamily_two (v : Fin 3 → 𝔽) :
    twistedCubicTripleFamily v 2 = momentCurve 4 (v 2) :=
  twistedCubicTripleFamily_castSucc v 2

@[simp] theorem twistedCubicTripleFamily_three (v : Fin 3 → 𝔽) :
    twistedCubicTripleFamily v 3 =
      axisTwistedCubicPoints 𝔽 (.inr (twistedCubicTripleAxisIndex v)) :=
  twistedCubicTripleFamily_last v

theorem twistedCubicTripleFamily_eq_matrix_col (v : Fin 3 → 𝔽) :
    twistedCubicTripleFamily v =
      (twistedCubicAxisCircuitMatrix v (twistedCubicTripleAxisE₁ v)
        (twistedCubicTripleAxisE₂ v)).col := by
  funext j
  cases j using Fin.lastCases with
  | last =>
      rw [twistedCubicTripleFamily, Fin.lastCases_last,
        twistedCubicAxisCircuitMatrix_col_axis]
      exact axisTwistedCubicPoints_tripleAxisIndex v
  | cast j =>
      rw [twistedCubicTripleFamily, Fin.lastCases_castSucc,
        twistedCubicAxisCircuitMatrix_col_cubic]
      rfl

theorem twistedCubicTripleFamily_dependent (v : Fin 3 → 𝔽) :
    ¬ LinearIndependent 𝔽 (twistedCubicTripleFamily v) := by
  rw [twistedCubicTripleFamily_eq_matrix_col]
  intro hli
  have hunit : IsUnit (twistedCubicAxisCircuitMatrix v (twistedCubicTripleAxisE₁ v)
      (twistedCubicTripleAxisE₂ v)) := Matrix.linearIndependent_cols_iff_isUnit.mp hli
  exact ((twistedCubicAxisCircuitMatrix v (twistedCubicTripleAxisE₁ v)
    (twistedCubicTripleAxisE₂ v)).isUnit_iff_isUnit_det.mp hunit).ne_zero
      (twistedCubicTripleAxis_normalized_det_eq_zero v)

/-- Removing cubic column `0` leaves two distinct cubic points and the nonzero completing axis
point, hence an independent triple. -/
theorem twistedCubicTriple_omitCubic0_linearIndependent [CharP 𝔽 3]
    {v : Fin 3 → 𝔽} (hv : Function.Injective v) :
    LinearIndependent 𝔽 ![
      axisTwistedCubicPoints 𝔽 (.inl (v 1)),
      axisTwistedCubicPoints 𝔽 (.inl (v 2)),
      axisTwistedCubicPoints 𝔽 (.inr (twistedCubicTripleAxisIndex v))] := by
  have h12 : v 1 ≠ v 2 := hv.ne (by decide : (1 : Fin 3) ≠ 2)
  have hli := twoCubicAxis_linearIndependent (𝔽 := 𝔽) h12
    (twistedCubicTripleAxis_normalized_coordinates_ne_zero v)
  have heq : (![
      axisTwistedCubicPoints 𝔽 (.inl (v 1)),
      axisTwistedCubicPoints 𝔽 (.inl (v 2)),
      axisTwistedCubicPoints 𝔽 (.inr (twistedCubicTripleAxisIndex v))] :
        Fin 3 → (Fin 4 → 𝔽)) =
      twoCubicAxisFamily (v 1) (v 2) (twistedCubicTripleAxisE₁ v)
        (twistedCubicTripleAxisE₂ v) := by
    funext i
    fin_cases i
    · rfl
    · rfl
    · exact axisTwistedCubicPoints_tripleAxisIndex v
  rw [heq]
  exact hli

theorem twistedCubicTriple_omitCubic1_linearIndependent [CharP 𝔽 3]
    {v : Fin 3 → 𝔽} (hv : Function.Injective v) :
    LinearIndependent 𝔽 ![
      axisTwistedCubicPoints 𝔽 (.inl (v 0)),
      axisTwistedCubicPoints 𝔽 (.inl (v 2)),
      axisTwistedCubicPoints 𝔽 (.inr (twistedCubicTripleAxisIndex v))] := by
  have h02 : v 0 ≠ v 2 := hv.ne (by decide : (0 : Fin 3) ≠ 2)
  have hli := twoCubicAxis_linearIndependent (𝔽 := 𝔽) h02
    (twistedCubicTripleAxis_normalized_coordinates_ne_zero v)
  have heq : (![
      axisTwistedCubicPoints 𝔽 (.inl (v 0)),
      axisTwistedCubicPoints 𝔽 (.inl (v 2)),
      axisTwistedCubicPoints 𝔽 (.inr (twistedCubicTripleAxisIndex v))] :
        Fin 3 → (Fin 4 → 𝔽)) =
      twoCubicAxisFamily (v 0) (v 2) (twistedCubicTripleAxisE₁ v)
        (twistedCubicTripleAxisE₂ v) := by
    funext i
    fin_cases i
    · rfl
    · rfl
    · exact axisTwistedCubicPoints_tripleAxisIndex v
  rw [heq]
  exact hli

theorem twistedCubicTriple_omitCubic2_linearIndependent [CharP 𝔽 3]
    {v : Fin 3 → 𝔽} (hv : Function.Injective v) :
    LinearIndependent 𝔽 ![
      axisTwistedCubicPoints 𝔽 (.inl (v 0)),
      axisTwistedCubicPoints 𝔽 (.inl (v 1)),
      axisTwistedCubicPoints 𝔽 (.inr (twistedCubicTripleAxisIndex v))] := by
  have h01 : v 0 ≠ v 1 := hv.ne (by decide : (0 : Fin 3) ≠ 1)
  have hli := twoCubicAxis_linearIndependent (𝔽 := 𝔽) h01
    (twistedCubicTripleAxis_normalized_coordinates_ne_zero v)
  have heq : (![
      axisTwistedCubicPoints 𝔽 (.inl (v 0)),
      axisTwistedCubicPoints 𝔽 (.inl (v 1)),
      axisTwistedCubicPoints 𝔽 (.inr (twistedCubicTripleAxisIndex v))] :
        Fin 3 → (Fin 4 → 𝔽)) =
      twoCubicAxisFamily (v 0) (v 1) (twistedCubicTripleAxisE₁ v)
        (twistedCubicTripleAxisE₂ v) := by
    funext i
    fin_cases i
    · rfl
    · rfl
    · exact axisTwistedCubicPoints_tripleAxisIndex v
  rw [heq]
  exact hli

/-- **Cubic-triple four-circuit package.** For three distinct parameters, their normalized
completing axis point gives a dependent four-family, and deleting any one of its four members
leaves an independent triple. -/
theorem twistedCubicTriple_isFourCircuit [CharP 𝔽 3] {v : Fin 3 → 𝔽}
    (hv : Function.Injective v) :
    ¬ LinearIndependent 𝔽 (twistedCubicTripleFamily v) ∧
      LinearIndependent 𝔽 (fun j : Fin 3 => axisTwistedCubicPoints 𝔽 (.inl (v j))) ∧
      LinearIndependent 𝔽 ![
        axisTwistedCubicPoints 𝔽 (.inl (v 1)),
        axisTwistedCubicPoints 𝔽 (.inl (v 2)),
        axisTwistedCubicPoints 𝔽 (.inr (twistedCubicTripleAxisIndex v))] ∧
      LinearIndependent 𝔽 ![
        axisTwistedCubicPoints 𝔽 (.inl (v 0)),
        axisTwistedCubicPoints 𝔽 (.inl (v 2)),
        axisTwistedCubicPoints 𝔽 (.inr (twistedCubicTripleAxisIndex v))] ∧
      LinearIndependent 𝔽 ![
        axisTwistedCubicPoints 𝔽 (.inl (v 0)),
        axisTwistedCubicPoints 𝔽 (.inl (v 1)),
        axisTwistedCubicPoints 𝔽 (.inr (twistedCubicTripleAxisIndex v))] :=
  ⟨twistedCubicTripleFamily_dependent v,
    twistedCubicTriple_omitAxis_linearIndependent hv,
    twistedCubicTriple_omitCubic0_linearIndependent hv,
    twistedCubicTriple_omitCubic1_linearIndependent hv,
    twistedCubicTriple_omitCubic2_linearIndependent hv⟩

set_option maxHeartbeats 800000 in
/-- Every nonzero relation on a cubic-triple circuit uses all four columns.  This coefficient form
is convenient when transporting the circuit into a code's repair hypergraph. -/
theorem twistedCubicTriple_relation_fullSupport [CharP 𝔽 3] {v : Fin 3 → 𝔽}
    (hv : Function.Injective v) {c : Fin 4 → 𝔽}
    (hrel : ∑ j, c j • twistedCubicTripleFamily v j = 0) (hc : c ≠ 0) :
    ∀ j, c j ≠ 0 := by
  intro j hcj
  fin_cases j
  · change c 0 = 0 at hcj
    have hcoeff := Fintype.linearIndependent_iff.mp
      (twistedCubicTriple_omitCubic0_linearIndependent hv)
      ![c 1, c 2, c 3] (by
        simpa [Fin.sum_univ_four, Fin.sum_univ_three, hcj]
          using hrel)
    apply hc
    funext i
    fin_cases i
    · exact hcj
    · exact hcoeff 0
    · exact hcoeff 1
    · exact hcoeff 2
  · change c 1 = 0 at hcj
    have hcoeff := Fintype.linearIndependent_iff.mp
      (twistedCubicTriple_omitCubic1_linearIndependent hv)
      ![c 0, c 2, c 3] (by
        simpa [Fin.sum_univ_four, Fin.sum_univ_three, hcj]
          using hrel)
    apply hc
    funext i
    fin_cases i
    · exact hcoeff 0
    · exact hcj
    · exact hcoeff 1
    · exact hcoeff 2
  · change c 2 = 0 at hcj
    have hcoeff := Fintype.linearIndependent_iff.mp
      (twistedCubicTriple_omitCubic2_linearIndependent hv)
      ![c 0, c 1, c 3] (by
        simpa [Fin.sum_univ_four, Fin.sum_univ_three, hcj]
          using hrel)
    apply hc
    funext i
    fin_cases i
    · exact hcoeff 0
    · exact hcoeff 1
    · exact hcj
    · exact hcoeff 2
  · change c 3 = 0 at hcj
    have hcoeff := Fintype.linearIndependent_iff.mp
      (twistedCubicTriple_omitAxis_linearIndependent hv) (fun i => c i) (by
        simpa [Fin.sum_univ_four, Fin.sum_univ_three, hcj]
          using hrel)
    apply hc
    funext i
    fin_cases i
    · exact hcoeff 0
    · exact hcoeff 1
    · exact hcoeff 2
    · exact hcj

end Normalized

/-- The displayed cubic-triple completion is always dependent (over any field). -/
theorem twistedCubicTripleAxis_det_eq_zero (v : Fin 3 → 𝔽) :
    (twistedCubicAxisCircuitMatrix v (v 0 + v 1 + v 2)
      (v 0 * v 1 + v 0 * v 2 + v 1 * v 2)).det = 0 := by
  rw [twistedCubicAxisCircuitMatrix_det]
  ring

theorem twistedCubicTripleAxis_dependent (v : Fin 3 → 𝔽) :
    ¬ LinearIndependent 𝔽
      (twistedCubicAxisCircuitMatrix v (v 0 + v 1 + v 2)
        (v 0 * v 1 + v 0 * v 2 + v 1 * v 2)).col := by
  intro hli
  have hunit : IsUnit (twistedCubicAxisCircuitMatrix v (v 0 + v 1 + v 2)
      (v 0 * v 1 + v 0 * v 2 + v 1 * v 2)) :=
    Matrix.linearIndependent_cols_iff_isUnit.mp hli
  exact ((twistedCubicAxisCircuitMatrix v (v 0 + v 1 + v 2)
    (v 0 * v 1 + v 0 * v 2 + v 1 * v 2)).isUnit_iff_isUnit_det.mp hunit).ne_zero
      (twistedCubicTripleAxis_det_eq_zero v)

/-- In characteristic three, the symmetric-coordinate axis vector of three *distinct* cubic
parameters is nonzero.  If both symmetric coordinates vanished, then
`(v 0-v 1)²=0`, contradicting injectivity. -/
theorem twistedCubicTripleAxis_coordinates_ne_zero [CharP 𝔽 3] {v : Fin 3 → 𝔽}
    (hv : Function.Injective v) :
    v 0 + v 1 + v 2 ≠ 0 ∨ v 0 * v 1 + v 0 * v 2 + v 1 * v 2 ≠ 0 := by
  by_contra h
  push Not at h
  have hsym : v 0 ^ 2 + v 0 * v 1 + v 1 ^ 2 = 0 := by
    linear_combination (v 0 + v 1) * h.1 - h.2
  have hsq : (v 0 - v 1) ^ 2 = 0 := by
    linear_combination hsym - (v 0 * v 1) * CharP.cast_eq_zero 𝔽 3
  have heq : v 0 = v 1 := sub_eq_zero.mp (eq_zero_of_pow_eq_zero hsq)
  exact hv.ne (by decide) heq

theorem twistedCubicTripleAxis_ne_zero [CharP 𝔽 3] {v : Fin 3 → 𝔽}
    (hv : Function.Injective v) : twistedCubicTripleAxis v ≠ 0 := by
  intro hzero
  have h₁ := congrFun hzero 1
  have h₂ := congrFun hzero 2
  simp only [twistedCubicTripleAxis, twistedCubicAxisVector, Matrix.cons_val_one,
    Matrix.cons_val_zero] at h₁ h₂
  exact (twistedCubicTripleAxis_coordinates_ne_zero hv).elim (fun h => h h₁) (fun h => h h₂)

/-- **Unique projective completion.** In characteristic three, every axis vector completing three
distinct cubic points to a dependent four-set is a scalar multiple of the symmetric-coordinate
axis vector `(0:s+t+u:st+su+tu:0)`. -/
theorem twistedCubicAxisCircuit_projectively_unique [CharP 𝔽 3] {v : Fin 3 → 𝔽}
    (hv : Function.Injective v) {e₁ e₂ : 𝔽}
    (hdet : (twistedCubicAxisCircuitMatrix v e₁ e₂).det = 0) :
    ∃ c : 𝔽,
      e₁ = c * (v 0 + v 1 + v 2) ∧
      e₂ = c * (v 0 * v 1 + v 0 * v 2 + v 1 * v 2) := by
  have hcross := (twistedCubicAxisCircuitMatrix_det_eq_zero_iff hv e₁ e₂).mp hdet
  rcases twistedCubicTripleAxis_coordinates_ne_zero hv with hsum | hpair
  · refine ⟨e₁ / (v 0 + v 1 + v 2), ?_, ?_⟩
    · exact (div_mul_cancel₀ e₁ hsum).symm
    · calc
        e₂ = (e₁ * (v 0 * v 1 + v 0 * v 2 + v 1 * v 2)) /
            (v 0 + v 1 + v 2) := (eq_div_iff hsum).2 hcross.symm
        _ = (e₁ / (v 0 + v 1 + v 2)) *
            (v 0 * v 1 + v 0 * v 2 + v 1 * v 2) := by field_simp
  · refine ⟨e₂ / (v 0 * v 1 + v 0 * v 2 + v 1 * v 2), ?_, ?_⟩
    · calc
        e₁ = (e₂ * (v 0 + v 1 + v 2)) /
            (v 0 * v 1 + v 0 * v 2 + v 1 * v 2) := (eq_div_iff hpair).2 hcross
        _ = (e₂ / (v 0 * v 1 + v 0 * v 2 + v 1 * v 2)) *
            (v 0 + v 1 + v 2) := by field_simp
    · exact (div_mul_cancel₀ e₂ hpair).symm

#print axioms twistedCubicAxisCircuitMatrix_det_eq_zero_iff
#print axioms twistedCubicAxisCircuit_projectively_unique
#print axioms twistedCubicTriple_isFourCircuit
#print axioms twoCubicTwoAxis_linearIndependent

end FiniteGeom
