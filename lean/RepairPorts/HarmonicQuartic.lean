import FiniteGeom.ColumnCode
import FiniteGeom.MomentCurve
import FiniteGeom.Repair
import Mathlib.FieldTheory.Finite.Basic
import Mathlib.LinearAlgebra.Matrix.NonsingularInverse

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

/-- Projective-line parameters are equivalent to adjoining one point to the field. -/
def optionEquivHarmonicParameter : Option 𝔽 ≃ HarmonicParameter 𝔽 where
  toFun
    | some t => .finite t
    | none => .infinity
  invFun
    | .finite t => some t
    | .infinity => none
  left_inv x := by cases x <;> rfl
  right_inv x := by cases x <;> rfl

noncomputable instance [Fintype 𝔽] : Fintype (HarmonicParameter 𝔽) :=
  Fintype.ofEquiv (Option 𝔽) optionEquivHarmonicParameter

/-- Coordinates of the complete quartic--nucleus point system: a projective curve parameter or
the distinguished nucleus. -/
abbrev HarmonicQuarticIndex (𝔽 : Type*) := HarmonicParameter 𝔽 ⊕ Unit

/-- The quartic normal-rational-curve column at a projective parameter. -/
def harmonicQuarticCurvePoint (t : HarmonicParameter 𝔽) : Fin 5 → 𝔽 :=
  match t with
  | .finite u => FiniteGeom.momentCurve 5 u
  | .infinity => fun i => if i = 4 then 1 else 0

/-- The hyperplane nucleus of the quartic normal rational curve in characteristic three. -/
def harmonicQuarticNucleus : Fin 5 → 𝔽 := fun i => if i = 2 then 1 else 0

/-- The complete quartic--nucleus point system. -/
def harmonicQuarticPoints : HarmonicQuarticIndex 𝔽 → (Fin 5 → 𝔽)
  | .inl t => harmonicQuarticCurvePoint t
  | .inr _ => harmonicQuarticNucleus

/-- Distinct projective parameters give distinct normalized quartic columns. -/
theorem harmonicQuarticCurvePoint_injective :
    Function.Injective (harmonicQuarticCurvePoint (𝔽 := 𝔽)) := by
  intro a b h
  cases a with
  | finite a =>
      cases b with
      | finite b =>
          have h₁ := congrFun h (1 : Fin 5)
          simp [harmonicQuarticCurvePoint, FiniteGeom.momentCurve] at h₁
          exact congrArg HarmonicParameter.finite h₁
      | infinity =>
          have h₀ := congrFun h (0 : Fin 5)
          simp [harmonicQuarticCurvePoint, FiniteGeom.momentCurve] at h₀
  | infinity =>
      cases b with
      | finite b =>
          have h₀ := congrFun h (0 : Fin 5)
          simp [harmonicQuarticCurvePoint, FiniteGeom.momentCurve] at h₀
      | infinity => rfl

/-- The nucleus is distinct from every curve column, so the complete point system is injectively
indexed. -/
theorem harmonicQuarticPoints_injective :
    Function.Injective (harmonicQuarticPoints (𝔽 := 𝔽)) := by
  intro x y h
  cases x with
  | inl x =>
      cases y with
      | inl y => exact congrArg Sum.inl (harmonicQuarticCurvePoint_injective h)
      | inr y =>
          cases x with
          | finite x =>
              have h₀ := congrFun h (0 : Fin 5)
              simp [harmonicQuarticPoints, harmonicQuarticCurvePoint,
                harmonicQuarticNucleus, FiniteGeom.momentCurve] at h₀
          | infinity =>
              have h₄ := congrFun h (4 : Fin 5)
              simp [harmonicQuarticPoints, harmonicQuarticCurvePoint,
                harmonicQuarticNucleus] at h₄
  | inr x =>
      cases y with
      | inl y =>
          cases y with
          | finite y =>
              have h₀ := congrFun h (0 : Fin 5)
              simp [harmonicQuarticPoints, harmonicQuarticCurvePoint,
                harmonicQuarticNucleus, FiniteGeom.momentCurve] at h₀
          | infinity =>
              have h₄ := congrFun h (4 : Fin 5)
              simp [harmonicQuarticPoints, harmonicQuarticCurvePoint,
                harmonicQuarticNucleus] at h₄
      | inr y => congr

/-- The generator matrix whose columns are the quartic--nucleus point system. -/
def harmonicQuarticGenerator : Matrix (Fin 5) (HarmonicQuarticIndex 𝔽) 𝔽 :=
  fun i j => harmonicQuarticPoints j i

/-- The row code of the quartic--nucleus generator matrix. -/
def harmonicQuarticCode [Fintype 𝔽] [DecidableEq 𝔽] :
    Submodule 𝔽 (HarmonicQuarticIndex 𝔽 → 𝔽) :=
  FiniteGeom.rowCode harmonicQuarticGenerator

/-- The row-code and projective evaluation-code descriptions of the quartic--nucleus code agree. -/
theorem harmonicQuarticCode_eq_columnCode [Fintype 𝔽] [DecidableEq 𝔽] :
    harmonicQuarticCode (𝔽 := 𝔽) = FiniteGeom.columnCode harmonicQuarticPoints := by
  unfold harmonicQuarticCode FiniteGeom.rowCode FiniteGeom.columnCode harmonicQuarticGenerator
  let M : Matrix (HarmonicQuarticIndex 𝔽) (Fin 5) 𝔽 :=
    Matrix.of (harmonicQuarticPoints (𝔽 := 𝔽))
  change Submodule.span 𝔽 (Set.range fun i => Mᵀ i) = LinearMap.range M.mulVecLin
  have hlin : M.mulVecLin = Mᵀ.vecMulLinear := by
    exact Matrix.mulVecLin_transpose Mᵀ
  rw [hlin]
  simpa [Matrix.row] using (range_vecMulLinear (R := 𝔽) Mᵀ).symm

omit [Field 𝔽] in
/-- The quartic--nucleus point system has one coordinate for each field element, one curve point
at infinity, and one nucleus coordinate. -/
theorem card_harmonicQuarticIndex [Fintype 𝔽] :
    Fintype.card (HarmonicQuarticIndex 𝔽) = Fintype.card 𝔽 + 2 := by
  change Fintype.card (HarmonicParameter 𝔽 ⊕ Unit) = _
  rw [Fintype.card_sum, Fintype.card_congr optionEquivHarmonicParameter.symm]
  simp

/-- Five distinct finite quartic points span the ambient five-dimensional vector space. -/
theorem finiteHarmonicQuartic_span {v : Fin 5 → 𝔽} (hv : Function.Injective v) :
    Submodule.span 𝔽
      (Set.range fun i : Fin 5 => harmonicQuarticCurvePoint (.finite (v i))) = ⊤ := by
  have hli : LinearIndependent 𝔽
      (fun i : Fin 5 => harmonicQuarticCurvePoint (.finite (v i))) := by
    simpa [harmonicQuarticCurvePoint] using FiniteGeom.momentCurve_linearIndependent hv
  have hcard : Fintype.card (Fin 5) = Module.finrank 𝔽 (Fin 5 → 𝔽) := by
    rw [Module.finrank_pi, Fintype.card_fin]
  have hb := (basisOfLinearIndependentOfCardEqFinrank hli hcard).span_eq
  rwa [coe_basisOfLinearIndependentOfCardEqFinrank] at hb

/-- If the field has at least five elements, the complete quartic--nucleus point system spans the
ambient five-dimensional space. -/
theorem harmonicQuarticPoints_span [Fintype 𝔽] (hcard : 5 ≤ Fintype.card 𝔽) :
    Submodule.span 𝔽 (Set.range (harmonicQuarticPoints (𝔽 := 𝔽))) = ⊤ := by
  let e : 𝔽 ≃ Fin (Fintype.card 𝔽) := Fintype.equivFin 𝔽
  let v : Fin 5 → 𝔽 := fun i => e.symm (Fin.castLE hcard i)
  have hv : Function.Injective v := e.symm.injective.comp (Fin.castLE_injective hcard)
  have hsmall := finiteHarmonicQuartic_span (𝔽 := 𝔽) hv
  apply top_unique
  rw [← hsmall]
  apply Submodule.span_mono
  rintro _ ⟨i, rfl⟩
  exact ⟨Sum.inl (.finite (v i)), rfl⟩

/-- The quartic--nucleus code has dimension five whenever the field has at least five elements. -/
theorem finrank_harmonicQuarticCode [Fintype 𝔽] [DecidableEq 𝔽]
    (hcard : 5 ≤ Fintype.card 𝔽) :
    Module.finrank 𝔽 (harmonicQuarticCode (𝔽 := 𝔽)) = 5 := by
  rw [harmonicQuarticCode_eq_columnCode]
  exact FiniteGeom.finrank_columnCode (harmonicQuarticPoints_span hcard)

/-- Exact parameters of the quartic--nucleus code from the two global geometric inputs used in
the manuscript proof: the sharp five-point hyperplane-section bound and independence of every
set of at most four columns.  The final argument also asks for one displayed weight-five dual
relation, so nontriviality of the dual is explicit rather than hidden in a distance convention. -/
theorem harmonicQuarticCode_parameters_of_global_geometry
    [Fintype 𝔽] [DecidableEq 𝔽] (hcard : 9 ≤ Fintype.card 𝔽)
    (a₀ : Fin 5 → 𝔽)
    (ha₀ : FiniteGeom.pointEval (harmonicQuarticPoints (𝔽 := 𝔽)) a₀ ≠ 0)
    (hmax : FiniteGeom.sectionCount (harmonicQuarticPoints (𝔽 := 𝔽)) a₀ = 5)
    (hsection : ∀ a : Fin 5 → 𝔽,
      FiniteGeom.pointEval (harmonicQuarticPoints (𝔽 := 𝔽)) a ≠ 0 →
      FiniteGeom.sectionCount (harmonicQuarticPoints (𝔽 := 𝔽)) a ≤ 5)
    (hcolumns : ∀ S : Finset (HarmonicQuarticIndex 𝔽), S.card < 5 →
      LinearIndependent 𝔽
        (fun j : S => (harmonicQuarticGenerator (𝔽 := 𝔽)).col j.1))
    (y : HarmonicQuarticIndex 𝔽 → 𝔽)
    (hy : y ∈ FiniteGeom.dualCode (harmonicQuarticCode (𝔽 := 𝔽)))
    (hy₀ : y ≠ 0) (hyweight : hammingNorm y = 5) :
    Fintype.card (HarmonicQuarticIndex 𝔽) = Fintype.card 𝔽 + 2 ∧
      Module.finrank 𝔽 (harmonicQuarticCode (𝔽 := 𝔽)) = 5 ∧
      FiniteGeom.minDist (harmonicQuarticCode (𝔽 := 𝔽)) =
        Fintype.card 𝔽 - 3 ∧
      FiniteGeom.dualDist (harmonicQuarticCode (𝔽 := 𝔽)) = 5 := by
  have hlength := card_harmonicQuarticIndex (𝔽 := 𝔽)
  have hdim := finrank_harmonicQuarticCode (𝔽 := 𝔽) (by omega)
  have hdistance := FiniteGeom.columnCode_minDist_eq ha₀ hmax hsection
  rw [← harmonicQuarticCode_eq_columnCode] at hdistance
  have hdual : FiniteGeom.dualCode (harmonicQuarticCode (𝔽 := 𝔽)) ≠ ⊥ := by
    intro hbot
    rw [hbot] at hy
    exact hy₀ (show y = 0 from hy)
  have hduallo : 5 ≤ FiniteGeom.dualDist (harmonicQuarticCode (𝔽 := 𝔽)) :=
    FiniteGeom.le_dualDist_rowCode_of_column_independent
      (harmonicQuarticGenerator (𝔽 := 𝔽)) 5
      hdual hcolumns
  have hdualhi : FiniteGeom.dualDist (harmonicQuarticCode (𝔽 := 𝔽)) ≤ 5 := by
    rw [← hyweight]
    exact FiniteGeom.dualDist_le_hammingNorm hy hy₀
  refine ⟨hlength, hdim, ?_, Nat.le_antisymm hdualhi hduallo⟩
  rw [hlength] at hdistance
  omega

/-- Every chosen point of an injectively indexed five-circuit has the other four points as a
radius-four repair set.  This is the finite reindexing bridge used below for harmonic blocks. -/
theorem fiveCircuit_repairPort {ι : Type*} [Fintype ι] [DecidableEq ι]
    [DecidableEq 𝔽] {G : Matrix (Fin 5) ι 𝔽}
    (f : Fin 5 → ι) (hf : Function.Injective f)
    (hdep : ¬ LinearIndependent 𝔽 (fun j => G.col (f j)))
    (hdelete : ∀ j : Fin 5,
      LinearIndependent 𝔽 (fun i : Fin 4 => G.col (f (j.succAbove i))))
    (j : Fin 5) :
    (Finset.univ.erase j).image f ∈
      FiniteGeom.repairHypergraph (FiniteGeom.rowCode G) (f j) 4 := by
  let R : Finset ι := (Finset.univ.erase j).image f
  have hsub : R ⊆ Finset.univ.erase (f j) := by
    intro x hx
    obtain ⟨i, hi, rfl⟩ := Finset.mem_image.mp hx
    exact Finset.mem_erase.mpr ⟨fun h => (Finset.mem_erase.mp hi).1 (hf h),
      Finset.mem_univ _⟩
  have hcard : R.card = 4 := by
    rw [Finset.card_image_of_injective _ hf, Finset.card_erase_of_mem (Finset.mem_univ j),
      Finset.card_univ, Fintype.card_fin]
  let e₀ : Fin 5 → ↥(insert (f j) R) := fun i => ⟨f i, by
    by_cases hij : i = j
    · simp [hij]
    · exact Finset.mem_insert.mpr (Or.inr (Finset.mem_image.mpr
        ⟨i, Finset.mem_erase.mpr ⟨hij, Finset.mem_univ i⟩, rfl⟩))⟩
  have he₀ : Function.Bijective e₀ := by
    refine ⟨fun i k hik => hf (congrArg Subtype.val hik), ?_⟩
    rintro ⟨x, hx⟩
    rcases Finset.mem_insert.mp hx with rfl | hx
    · exact ⟨j, Subtype.ext rfl⟩
    · obtain ⟨i, -, rfl⟩ := Finset.mem_image.mp hx
      exact ⟨i, Subtype.ext rfl⟩
  let e : Fin 5 ≃ ↥(insert (f j) R) := Equiv.ofBijective e₀ he₀
  apply FiniteGeom.mem_repairHypergraph_of_reindexed_circuit hsub hcard e
  · simpa [e, e₀] using hdep
  · intro k
    have hk : LinearIndependent 𝔽
        (fun i : {i : Fin 5 // i ≠ k} => G.col (f i.1)) := by
      exact (linearIndependent_equiv' (R := 𝔽) (M := Fin 5 → 𝔽)
        (finSuccAboveEquiv k)
        (f := fun i : {i : Fin 5 // i ≠ k} => G.col (f i.1))
        (g := fun i : Fin 4 => G.col (f (k.succAbove i))) (by
          funext i
          rfl)).1 (hdelete k)
    simpa [e, e₀] using hk

/-- The nucleus followed by four quartic curve columns, arranged as the rows of a square matrix. -/
def harmonicQuarticFamily (a b c d : HarmonicParameter 𝔽) : Matrix (Fin 5) (Fin 5) 𝔽 :=
  ![harmonicQuarticNucleus, harmonicQuarticCurvePoint a, harmonicQuarticCurvePoint b,
    harmonicQuarticCurvePoint c, harmonicQuarticCurvePoint d]

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

/-- The four-by-four minor left after expanding a finite quartic--nucleus family along the nucleus
row. -/
def finiteHarmonicQuarticMinor (a b c d : 𝔽) : Matrix (Fin 4) (Fin 4) 𝔽 :=
  ![![1, a, a ^ 3, a ^ 4], ![1, b, b ^ 3, b ^ 4],
    ![1, c, c ^ 3, c ^ 4], ![1, d, d ^ 3, d ^ 4]]

/-- The analogous minor when the fourth projective parameter is infinity. -/
def infinityHarmonicQuarticMinor (a b c : 𝔽) : Matrix (Fin 4) (Fin 4) 𝔽 :=
  ![![1, a, a ^ 3, a ^ 4], ![1, b, b ^ 3, b ^ 4],
    ![1, c, c ^ 3, c ^ 4], ![0, 0, 0, 1]]

/-- The finite minor is the four-parameter Vandermonde product times the harmonic condition. -/
theorem finiteHarmonicQuarticMinor_det (a b c d : 𝔽) :
    (finiteHarmonicQuarticMinor a b c d).det =
      harmonicVandermondeFour a b c d * harmonicE₂Four a b c d := by
  simp (disch := decide) [finiteHarmonicQuarticMinor, harmonicVandermondeFour, harmonicE₂Four,
    Matrix.det_succ_row_zero, Fin.sum_univ_succ, Fin.succAbove]
  ring

/-- The infinity minor is the three-parameter Vandermonde product times the finite-parameter sum. -/
theorem infinityHarmonicQuarticMinor_det (a b c : 𝔽) :
    (infinityHarmonicQuarticMinor a b c).det =
      harmonicVandermondeThree a b c * harmonicE₁ a b c := by
  simp (disch := decide) [infinityHarmonicQuarticMinor, harmonicVandermondeThree, harmonicE₁,
    Matrix.det_succ_row_zero, Fin.sum_univ_succ, Fin.succAbove]
  ring

/-- The determinant of four finite quartic points with the nucleus factors into the Vandermonde
product and the harmonic second-symmetric condition. -/
theorem harmonicQuarticDeterminant_finite (a b c d : 𝔽) :
    harmonicQuarticDeterminant (.finite a) (.finite b) (.finite c) (.finite d) =
      harmonicVandermondeFour a b c d * harmonicE₂Four a b c d := by
  rw [← finiteHarmonicQuarticMinor_det]
  unfold harmonicQuarticDeterminant harmonicQuarticFamily
  rw [Matrix.det_succ_row_zero]
  simp [harmonicQuarticCurvePoint, harmonicQuarticNucleus]
  congr 1
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.submatrix_apply, finiteHarmonicQuarticMinor, Fin.succAbove]

/-- With infinity among the four curve points, the quartic--nucleus determinant factors into the
three-parameter Vandermonde product and the sum of the finite parameters. -/
theorem harmonicQuarticDeterminant_infinity (a b c : 𝔽) :
    harmonicQuarticDeterminant (.finite a) (.finite b) (.finite c) .infinity =
      harmonicVandermondeThree a b c * harmonicE₁ a b c := by
  rw [← infinityHarmonicQuarticMinor_det]
  unfold harmonicQuarticDeterminant harmonicQuarticFamily
  rw [Matrix.det_succ_row_zero]
  simp [harmonicQuarticCurvePoint, harmonicQuarticNucleus]
  congr 1
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.submatrix_apply, infinityHarmonicQuarticMinor, Fin.succAbove]

/-- For a square family over a field, row independence is equivalent to nonvanishing of the
determinant. -/
theorem harmonicQuarticFamily_linearIndependent_iff (a b c d : HarmonicParameter 𝔽) :
    LinearIndependent 𝔽 (harmonicQuarticFamily a b c d) ↔
      harmonicQuarticDeterminant a b c d ≠ 0 := by
  constructor
  · intro hli
    have hu : IsUnit (harmonicQuarticFamily a b c d) :=
      Matrix.linearIndependent_rows_iff_isUnit.mp hli
    exact ((Matrix.isUnit_iff_isUnit_det _).mp hu).ne_zero
  · exact Matrix.linearIndependent_rows_of_det_ne_zero

/-- Distinct finite parameters have a nonzero four-parameter Vandermonde product. -/
theorem harmonicVandermondeFour_ne_zero {a b c d : 𝔽}
    (hab : a ≠ b) (hac : a ≠ c) (had : a ≠ d)
    (hbc : b ≠ c) (hbd : b ≠ d) (hcd : c ≠ d) :
    harmonicVandermondeFour a b c d ≠ 0 := by
  unfold harmonicVandermondeFour
  exact mul_ne_zero
    (mul_ne_zero
      (mul_ne_zero
        (mul_ne_zero
          (mul_ne_zero (sub_ne_zero.mpr hab.symm) (sub_ne_zero.mpr hac.symm))
          (sub_ne_zero.mpr had.symm))
        (sub_ne_zero.mpr hbc.symm))
      (sub_ne_zero.mpr hbd.symm))
    (sub_ne_zero.mpr hcd.symm)

/-- Distinct finite parameters have a nonzero three-parameter Vandermonde product. -/
theorem harmonicVandermondeThree_ne_zero {a b c : 𝔽}
    (hab : a ≠ b) (hac : a ≠ c) (hbc : b ≠ c) :
    harmonicVandermondeThree a b c ≠ 0 := by
  unfold harmonicVandermondeThree
  exact mul_ne_zero
    (mul_ne_zero (sub_ne_zero.mpr hab.symm) (sub_ne_zero.mpr hac.symm))
    (sub_ne_zero.mpr hbc.symm)

/-- Four distinct finite curve points together with the nucleus are independent exactly when they
do not form a harmonic block. -/
theorem harmonicQuarticFamily_finite_linearIndependent_iff {a b c d : 𝔽}
    (hab : a ≠ b) (hac : a ≠ c) (had : a ≠ d)
    (hbc : b ≠ c) (hbd : b ≠ d) (hcd : c ≠ d) :
    LinearIndependent 𝔽
      (harmonicQuarticFamily (.finite a) (.finite b) (.finite c) (.finite d)) ↔
      ¬IsHarmonicQuarticBlock (.finite a) (.finite b) (.finite c) (.finite d) := by
  rw [harmonicQuarticFamily_linearIndependent_iff, harmonicQuarticDeterminant_finite]
  have hv := harmonicVandermondeFour_ne_zero hab hac had hbc hbd hcd
  simp [IsHarmonicQuarticBlock, hv]

/-- Three distinct finite curve points, infinity, and the nucleus are independent exactly when
they do not form a harmonic block. -/
theorem harmonicQuarticFamily_infinity_linearIndependent_iff {a b c : 𝔽}
    (hab : a ≠ b) (hac : a ≠ c) (hbc : b ≠ c) :
    LinearIndependent 𝔽
      (harmonicQuarticFamily (.finite a) (.finite b) (.finite c) .infinity) ↔
      ¬IsHarmonicQuarticBlock (.finite a) (.finite b) (.finite c) .infinity := by
  rw [harmonicQuarticFamily_linearIndependent_iff, harmonicQuarticDeterminant_infinity]
  have hv := harmonicVandermondeThree_ne_zero hab hac hbc
  simp [IsHarmonicQuarticBlock, hv]

/-- Restricting a finite vector family to any square coordinate minor with nonzero determinant
proves independence of the original vectors. -/
theorem linearIndependent_of_coordinateMinor_det_ne_zero {m n : ℕ}
    (v : Fin m → (Fin n → 𝔽)) (cols : Fin m → Fin n)
    (hdet : Matrix.det (fun i j => v i (cols j)) ≠ 0) :
    LinearIndependent 𝔽 v := by
  have hminor : LinearIndependent 𝔽 (fun i j => v i (cols j)) :=
    Matrix.linearIndependent_rows_of_det_ne_zero hdet
  rw [Fintype.linearIndependent_iff] at hminor ⊢
  intro g hrel
  apply hminor g
  funext j
  have hj := congrFun hrel (cols j)
  simpa only [Finset.sum_apply, Pi.smul_apply, Pi.zero_apply] using hj

/-- The nucleus followed by three finite quartic points. -/
def nucleusFiniteTripleFamily (a b c : 𝔽) : Fin 4 → (Fin 5 → 𝔽) :=
  ![harmonicQuarticNucleus, harmonicQuarticCurvePoint (.finite a),
    harmonicQuarticCurvePoint (.finite b), harmonicQuarticCurvePoint (.finite c)]

/-- The nucleus, two finite quartic points, and the quartic point at infinity. -/
def nucleusFiniteInfinityFamily (a b : 𝔽) : Fin 4 → (Fin 5 → 𝔽) :=
  ![harmonicQuarticNucleus, harmonicQuarticCurvePoint (.finite a),
    harmonicQuarticCurvePoint (.finite b), harmonicQuarticCurvePoint .infinity]

/-- The complete symmetric polynomial of degree two in three variables. -/
def harmonicH₂ (a b c : 𝔽) : 𝔽 :=
  a ^ 2 + b ^ 2 + c ^ 2 + a * b + a * c + b * c

/-- The first useful coordinate minor of a nucleus and three finite curve points. -/
theorem nucleusFiniteTriple_minor₀₁₂₃_det (a b c : 𝔽) :
    Matrix.det (fun i j => nucleusFiniteTripleFamily a b c i (![0, 1, 2, 3] j)) =
        harmonicVandermondeThree a b c * harmonicE₁ a b c := by
  simp (disch := decide) [nucleusFiniteTripleFamily, harmonicQuarticNucleus,
    harmonicQuarticCurvePoint, harmonicVandermondeThree, harmonicE₁,
    Matrix.det_succ_row_zero, Fin.sum_univ_succ, Fin.succAbove]
  ring

/-- The complementary coordinate minor detects the zero-sum branch. -/
theorem nucleusFiniteTriple_minor₀₁₂₄_det (a b c : 𝔽) :
    Matrix.det (fun i j => nucleusFiniteTripleFamily a b c i (![0, 1, 2, 4] j)) =
        harmonicVandermondeThree a b c * harmonicH₂ a b c := by
  simp (disch := decide) [nucleusFiniteTripleFamily, harmonicQuarticNucleus,
    harmonicQuarticCurvePoint, harmonicVandermondeThree, harmonicH₂,
    Matrix.det_succ_row_zero, Fin.sum_univ_succ, Fin.succAbove]
  ring

/-- If the prescribed triple has zero sum, its degree-two complete symmetric polynomial is minus
its second elementary symmetric function. -/
theorem harmonicH₂_eq_neg_harmonicE₂_of_harmonicE₁_eq_zero {a b c : 𝔽}
    (hsum : harmonicE₁ a b c = 0) : harmonicH₂ a b c = -harmonicE₂ a b c := by
  simp only [harmonicH₂, harmonicE₁, harmonicE₂] at hsum ⊢
  linear_combination (a + b + c) * hsum

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

/-- A nucleus and three distinct finite quartic points are linearly independent in characteristic
three. -/
theorem nucleusFiniteTriple_linearIndependent [CharP 𝔽 3] {a b c : 𝔽}
    (hab : a ≠ b) (hac : a ≠ c) (hbc : b ≠ c) :
    LinearIndependent 𝔽 (nucleusFiniteTripleFamily a b c) := by
  have hv := harmonicVandermondeThree_ne_zero hab hac hbc
  by_cases hsum : harmonicE₁ a b c = 0
  · have he₂ := harmonicE₂_ne_zero_of_harmonicE₁_eq_zero hab hsum
    apply linearIndependent_of_coordinateMinor_det_ne_zero
      (nucleusFiniteTripleFamily a b c) ![0, 1, 2, 4]
    rw [nucleusFiniteTriple_minor₀₁₂₄_det,
      harmonicH₂_eq_neg_harmonicE₂_of_harmonicE₁_eq_zero hsum]
    exact mul_ne_zero hv (neg_ne_zero.mpr he₂)
  · apply linearIndependent_of_coordinateMinor_det_ne_zero
      (nucleusFiniteTripleFamily a b c) ![0, 1, 2, 3]
    rw [nucleusFiniteTriple_minor₀₁₂₃_det]
    exact mul_ne_zero hv hsum

/-- The coordinate minor of a nucleus, two finite curve points, and infinity is their finite
parameter difference. -/
theorem nucleusFiniteInfinity_minor_det (a b : 𝔽) :
    Matrix.det (fun i j => nucleusFiniteInfinityFamily a b i (![0, 1, 2, 4] j)) = b - a := by
  simp (disch := decide) [nucleusFiniteInfinityFamily, harmonicQuarticNucleus,
    harmonicQuarticCurvePoint, Matrix.det_succ_row_zero, Fin.sum_univ_succ, Fin.succAbove]
  ring

/-- A nucleus, two distinct finite quartic points, and the point at infinity are linearly
independent. -/
theorem nucleusFiniteInfinity_linearIndependent {a b : 𝔽} (hab : a ≠ b) :
    LinearIndependent 𝔽 (nucleusFiniteInfinityFamily a b) := by
  apply linearIndependent_of_coordinateMinor_det_ne_zero
    (nucleusFiniteInfinityFamily a b) ![0, 1, 2, 4]
  rw [nucleusFiniteInfinity_minor_det]
  exact sub_ne_zero.mpr hab.symm

/-- The nucleus and any three distinct projective quartic points are independent. -/
theorem nucleusProjectiveTriple_linearIndependent [CharP 𝔽 3]
    {a b c : HarmonicParameter 𝔽} (hab : a ≠ b) (hac : a ≠ c) (hbc : b ≠ c) :
    LinearIndependent 𝔽 ![harmonicQuarticNucleus,
      harmonicQuarticCurvePoint a, harmonicQuarticCurvePoint b,
      harmonicQuarticCurvePoint c] := by
  cases a with
  | finite a =>
      cases b with
      | finite b =>
          cases c with
          | finite c =>
              exact nucleusFiniteTriple_linearIndependent
                (fun h => hab (congrArg HarmonicParameter.finite h))
                (fun h => hac (congrArg HarmonicParameter.finite h))
                (fun h => hbc (congrArg HarmonicParameter.finite h))
          | infinity =>
              exact nucleusFiniteInfinity_linearIndependent
                (fun h => hab (congrArg HarmonicParameter.finite h))
      | infinity =>
          cases c with
          | finite c =>
              have hli := nucleusFiniteInfinity_linearIndependent (𝔽 := 𝔽)
                (fun h => hac (congrArg HarmonicParameter.finite h))
              have hs₀ : Equiv.swap (2 : Fin 4) 3 0 = 0 := by decide
              have hs₁ : Equiv.swap (2 : Fin 4) 3 1 = 1 := by decide
              have hs₂ : Equiv.swap (2 : Fin 4) 3 2 = 3 := by decide
              have hs₃ : Equiv.swap (2 : Fin 4) 3 3 = 2 := by decide
              exact (linearIndependent_equiv' (Equiv.swap (2 : Fin 4) 3) (by
                funext i
                fin_cases i <;> simp [nucleusFiniteInfinityFamily, hs₀, hs₁, hs₂, hs₃])).2 hli
          | infinity => exact (hbc rfl).elim
  | infinity =>
      cases b with
      | finite b =>
          cases c with
          | finite c =>
              have hli := nucleusFiniteInfinity_linearIndependent (𝔽 := 𝔽)
                (fun h => hbc (congrArg HarmonicParameter.finite h))
              let e : Fin 4 ≃ Fin 4 :=
                (Equiv.swap (2 : Fin 4) 3).trans (Equiv.swap (1 : Fin 4) 3)
              have he₀ : e 0 = 0 := by decide
              have he₁ : e 1 = 3 := by decide
              have he₂ : e 2 = 1 := by decide
              have he₃ : e 3 = 2 := by decide
              exact (linearIndependent_equiv' e (by
                funext i
                fin_cases i <;> simp [nucleusFiniteInfinityFamily, he₀, he₁, he₂, he₃])).2 hli
          | infinity => exact (hac rfl).elim
      | infinity => exact (hab rfl).elim

/-- Four distinct finite quartic curve points are linearly independent. -/
theorem fourFiniteHarmonicQuarticCurve_linearIndependent {a b c d : 𝔽}
    (hab : a ≠ b) (hac : a ≠ c) (had : a ≠ d)
    (hbc : b ≠ c) (hbd : b ≠ d) (hcd : c ≠ d) :
    LinearIndependent 𝔽 ![
      harmonicQuarticCurvePoint (.finite a), harmonicQuarticCurvePoint (.finite b),
      harmonicQuarticCurvePoint (.finite c), harmonicQuarticCurvePoint (.finite d)] := by
  let v : Fin 4 → 𝔽 := ![a, b, c, d]
  have hv : Function.Injective v := by
    have hba := hab.symm
    have hca := hac.symm
    have hda := had.symm
    have hcb := hbc.symm
    have hdb := hbd.symm
    have hdc := hcd.symm
    intro i j
    fin_cases i <;> fin_cases j <;> simp_all [v]
  have hli := FiniteGeom.momentCurve_linearIndependent_of_card_le (n := 5) hv (by decide)
  have heq : (fun i : Fin 4 => FiniteGeom.momentCurve 5 (v i)) = ![
      harmonicQuarticCurvePoint (.finite a), harmonicQuarticCurvePoint (.finite b),
      harmonicQuarticCurvePoint (.finite c), harmonicQuarticCurvePoint (.finite d)] := by
    funext i
    fin_cases i <;> rfl
  rwa [heq] at hli

/-- The `0,1,2,4` coordinate minor of three finite quartic points and infinity is their
three-parameter Vandermonde product. -/
theorem finiteTripleInfinityCurve_minor_det (a b c : 𝔽) :
    Matrix.det (fun i j => (![
      harmonicQuarticCurvePoint (.finite a), harmonicQuarticCurvePoint (.finite b),
      harmonicQuarticCurvePoint (.finite c), harmonicQuarticCurvePoint .infinity] :
        Fin 4 → (Fin 5 → 𝔽)) i (![0, 1, 2, 4] j)) = harmonicVandermondeThree a b c := by
  simp (disch := decide) [harmonicQuarticCurvePoint, harmonicVandermondeThree,
    Matrix.det_succ_row_zero, Fin.sum_univ_succ, Fin.succAbove]
  ring

/-- Three distinct finite quartic points together with the point at infinity are linearly
independent. -/
theorem finiteTripleInfinityCurve_linearIndependent {a b c : 𝔽}
    (hab : a ≠ b) (hac : a ≠ c) (hbc : b ≠ c) :
    LinearIndependent 𝔽 ![
      harmonicQuarticCurvePoint (.finite a), harmonicQuarticCurvePoint (.finite b),
      harmonicQuarticCurvePoint (.finite c), harmonicQuarticCurvePoint .infinity] := by
  let v : Fin 4 → (Fin 5 → 𝔽) := ![
    harmonicQuarticCurvePoint (.finite a), harmonicQuarticCurvePoint (.finite b),
    harmonicQuarticCurvePoint (.finite c), harmonicQuarticCurvePoint .infinity]
  let cols : Fin 4 → Fin 5 := ![0, 1, 2, 4]
  apply linearIndependent_of_coordinateMinor_det_ne_zero v cols
  have hv := harmonicVandermondeThree_ne_zero hab hac hbc
  rw [show Matrix.det (fun i j => v i (cols j)) = harmonicVandermondeThree a b c by
    simpa [v, cols] using finiteTripleInfinityCurve_minor_det a b c]
  exact hv

/-- Any four distinct projective quartic-curve points are linearly independent. -/
theorem projectiveQuarticFour_linearIndependent
    {a b c d : HarmonicParameter 𝔽}
    (hab : a ≠ b) (hac : a ≠ c) (had : a ≠ d)
    (hbc : b ≠ c) (hbd : b ≠ d) (hcd : c ≠ d) :
    LinearIndependent 𝔽 ![harmonicQuarticCurvePoint a, harmonicQuarticCurvePoint b,
      harmonicQuarticCurvePoint c, harmonicQuarticCurvePoint d] := by
  cases a with
  | finite a =>
      cases b with
      | finite b =>
          cases c with
          | finite c =>
              cases d with
              | finite d =>
                  exact fourFiniteHarmonicQuarticCurve_linearIndependent
                    (fun h => hab (congrArg HarmonicParameter.finite h))
                    (fun h => hac (congrArg HarmonicParameter.finite h))
                    (fun h => had (congrArg HarmonicParameter.finite h))
                    (fun h => hbc (congrArg HarmonicParameter.finite h))
                    (fun h => hbd (congrArg HarmonicParameter.finite h))
                    (fun h => hcd (congrArg HarmonicParameter.finite h))
              | infinity =>
                  exact finiteTripleInfinityCurve_linearIndependent
                    (fun h => hab (congrArg HarmonicParameter.finite h))
                    (fun h => hac (congrArg HarmonicParameter.finite h))
                    (fun h => hbc (congrArg HarmonicParameter.finite h))
          | infinity =>
              cases d with
              | finite d =>
                  have hli := finiteTripleInfinityCurve_linearIndependent (𝔽 := 𝔽)
                    (fun h => hab (congrArg HarmonicParameter.finite h))
                    (fun h => had (congrArg HarmonicParameter.finite h))
                    (fun h => hbd (congrArg HarmonicParameter.finite h))
                  have hs₀ : Equiv.swap (2 : Fin 4) 3 0 = 0 := by decide
                  have hs₁ : Equiv.swap (2 : Fin 4) 3 1 = 1 := by decide
                  have hs₂ : Equiv.swap (2 : Fin 4) 3 2 = 3 := by decide
                  have hs₃ : Equiv.swap (2 : Fin 4) 3 3 = 2 := by decide
                  exact (linearIndependent_equiv' (Equiv.swap (2 : Fin 4) 3) (by
                    funext i
                    fin_cases i <;> simp [hs₀, hs₁, hs₂, hs₃])).2 hli
              | infinity => exact (hcd rfl).elim
      | infinity =>
          cases c with
          | finite c =>
              cases d with
              | finite d =>
                  have hli := finiteTripleInfinityCurve_linearIndependent (𝔽 := 𝔽)
                    (fun h => hac (congrArg HarmonicParameter.finite h))
                    (fun h => had (congrArg HarmonicParameter.finite h))
                    (fun h => hcd (congrArg HarmonicParameter.finite h))
                  let e₀ : Fin 4 → Fin 4 := ![0, 3, 1, 2]
                  let e : Fin 4 ≃ Fin 4 := Equiv.ofBijective e₀ (by decide)
                  exact (linearIndependent_equiv' e (by
                    funext i
                    fin_cases i <;> rfl)).2 hli
              | infinity => exact (hbd rfl).elim
          | infinity => exact (hbc rfl).elim
  | infinity =>
      cases b with
      | finite b =>
          cases c with
          | finite c =>
              cases d with
              | finite d =>
                  have hli := finiteTripleInfinityCurve_linearIndependent (𝔽 := 𝔽)
                    (fun h => hbc (congrArg HarmonicParameter.finite h))
                    (fun h => hbd (congrArg HarmonicParameter.finite h))
                    (fun h => hcd (congrArg HarmonicParameter.finite h))
                  let e₀ : Fin 4 → Fin 4 := ![3, 0, 1, 2]
                  let e : Fin 4 ≃ Fin 4 := Equiv.ofBijective e₀ (by decide)
                  exact (linearIndependent_equiv' e (by
                    funext i
                    fin_cases i <;> rfl)).2 hli
              | infinity => exact (had rfl).elim
          | infinity => exact (hac rfl).elim
      | infinity => exact (hab rfl).elim

/-- Every four-element subset of the quartic--nucleus point system is independent in
characteristic three. -/
theorem harmonicQuartic_fourSet_linearIndependent [Fintype 𝔽] [DecidableEq 𝔽]
    [CharP 𝔽 3] {T : Finset (HarmonicQuarticIndex 𝔽)} (hT : T.card = 4) :
    LinearIndependent 𝔽 (fun j : T => harmonicQuarticPoints j.1) := by
  classical
  let N : HarmonicQuarticIndex 𝔽 := .inr ()
  by_cases hN : N ∈ T
  · let U := T.erase N
    have hUcard : U.card = 3 := by
      simp [U, hN, hT]
    let eU : Fin 3 ≃ U := (Finset.equivFinOfCardEq hUcard).symm
    let v : Fin 3 → HarmonicParameter 𝔽 := fun i =>
      match (eU i).1 with
      | .inl t => t
      | .inr _ => .infinity
    have hleft (i : Fin 3) : (.inl (v i) : HarmonicQuarticIndex 𝔽) = (eU i).1 := by
      generalize hx : (eU i).1 = x
      cases x with
      | inl x => simp [v, hx]
      | inr x =>
          exfalso
          have hne := (Finset.mem_erase.mp (eU i).property).1
          cases x
          exact hne hx
    have hv : Function.Injective v := by
      intro i k hik
      apply eU.injective
      apply Subtype.ext
      rw [← hleft i, ← hleft k, hik]
    have hbase := nucleusProjectiveTriple_linearIndependent (𝔽 := 𝔽)
      (hv.ne (by decide : (0 : Fin 3) ≠ 1))
      (hv.ne (by decide : (0 : Fin 3) ≠ 2))
      (hv.ne (by decide : (1 : Fin 3) ≠ 2))
    let g : Fin 4 → HarmonicQuarticIndex 𝔽 :=
      Fin.cons N (fun i => (eU i).1)
    have hg : Function.Injective g := by
      apply Fin.cons_injective_of_injective
      · rintro ⟨i, hi⟩
        have hne := (Finset.mem_erase.mp (eU i).property).1
        exact hne hi
      · exact fun i k hik => eU.injective (Subtype.ext hik)
    let f₀ : Fin 4 → T := fun i => ⟨g i, by
      refine Fin.cases hN (fun k => ?_) i
      exact Finset.mem_of_mem_erase (eU k).property⟩
    have hf₀ : Function.Bijective f₀ :=
      (Fintype.bijective_iff_injective_and_card f₀).2 ⟨
        fun i k hik => hg (congrArg Subtype.val hik), by simp [hT]⟩
    let f : Fin 4 ≃ T := Equiv.ofBijective f₀ hf₀
    apply (linearIndependent_equiv f).mp
    have heq : ((fun j : T => harmonicQuarticPoints j.1) ∘ f) = ![
        harmonicQuarticNucleus, harmonicQuarticCurvePoint (v 0),
        harmonicQuarticCurvePoint (v 1), harmonicQuarticCurvePoint (v 2)] := by
      have harr : (![
          harmonicQuarticNucleus, harmonicQuarticCurvePoint (v 0),
          harmonicQuarticCurvePoint (v 1), harmonicQuarticCurvePoint (v 2)] :
          Fin 4 → (Fin 5 → 𝔽)) =
          Fin.cons harmonicQuarticNucleus (fun k => harmonicQuarticCurvePoint (v k)) := by
        funext i
        fin_cases i <;> rfl
      rw [harr]
      funext i
      change harmonicQuarticPoints (g i) = _
      refine Fin.cases rfl (fun k => ?_) i
      simp only [g, Fin.cons_succ]
      rw [← hleft k]
      rfl
    rw [heq]
    exact hbase
  · let e : Fin 4 ≃ T := (Finset.equivFinOfCardEq hT).symm
    let v : Fin 4 → HarmonicParameter 𝔽 := fun i =>
      match (e i).1 with
      | .inl t => t
      | .inr _ => .infinity
    have hleft (i : Fin 4) : (.inl (v i) : HarmonicQuarticIndex 𝔽) = (e i).1 := by
      generalize hx : (e i).1 = x
      cases x with
      | inl x => simp [v, hx]
      | inr x =>
          exfalso
          cases x
          have hmem := (e i).property
          rw [hx] at hmem
          exact hN hmem
    have hv : Function.Injective v := by
      intro i k hik
      apply e.injective
      apply Subtype.ext
      rw [← hleft i, ← hleft k, hik]
    have hbase := projectiveQuarticFour_linearIndependent (𝔽 := 𝔽)
      (hv.ne (by decide : (0 : Fin 4) ≠ 1))
      (hv.ne (by decide : (0 : Fin 4) ≠ 2))
      (hv.ne (by decide : (0 : Fin 4) ≠ 3))
      (hv.ne (by decide : (1 : Fin 4) ≠ 2))
      (hv.ne (by decide : (1 : Fin 4) ≠ 3))
      (hv.ne (by decide : (2 : Fin 4) ≠ 3))
    apply (linearIndependent_equiv e).mp
    have heq : ((fun j : T => harmonicQuarticPoints j.1) ∘ e) = ![
        harmonicQuarticCurvePoint (v 0), harmonicQuarticCurvePoint (v 1),
        harmonicQuarticCurvePoint (v 2), harmonicQuarticCurvePoint (v 3)] := by
      have harr : (![
          harmonicQuarticCurvePoint (v 0), harmonicQuarticCurvePoint (v 1),
          harmonicQuarticCurvePoint (v 2), harmonicQuarticCurvePoint (v 3)] :
          Fin 4 → (Fin 5 → 𝔽)) = fun i => harmonicQuarticCurvePoint (v i) := by
        funext i
        fin_cases i <;> rfl
      rw [harr]
      funext i
      change harmonicQuarticPoints ((e i).1) = harmonicQuarticCurvePoint (v i)
      rw [← hleft i]
      rfl
    rw [heq]
    exact hbase

/-- Every selected family of at most four quartic--nucleus columns is independent. -/
theorem harmonicQuartic_selected_linearIndependent_of_card_le_four
    [Fintype 𝔽] [DecidableEq 𝔽] [CharP 𝔽 3]
    {S : Finset (HarmonicQuarticIndex 𝔽)} (hS : S.card ≤ 4)
    (hambient : 4 ≤ Fintype.card (HarmonicQuarticIndex 𝔽)) :
    LinearIndependent 𝔽 (fun j : S => harmonicQuarticPoints j.1) := by
  classical
  obtain ⟨T, hST, hT⟩ := Finset.exists_superset_card_eq hS hambient
  have hli := harmonicQuartic_fourSet_linearIndependent (𝔽 := 𝔽) hT
  let e : S ↪ T := ⟨fun j => ⟨j.1, hST j.2⟩,
    fun i j hij => by
      apply Subtype.ext
      exact congrArg (fun z : T => z.1) hij⟩
  exact hli.comp e e.injective

/-- Uniform small-column independence for the quartic--nucleus generator. -/
theorem harmonicQuarticGenerator_smallColumnIndependent
    [Fintype 𝔽] [DecidableEq 𝔽] [CharP 𝔽 3]
    (hcard : 9 ≤ Fintype.card 𝔽) (S : Finset (HarmonicQuarticIndex 𝔽))
    (hS : S.card < 5) :
    LinearIndependent 𝔽
      (fun j : S => (harmonicQuarticGenerator (𝔽 := 𝔽)).col j.1) := by
  have hambient : 4 ≤ Fintype.card (HarmonicQuarticIndex 𝔽) := by
    rw [card_harmonicQuarticIndex]
    omega
  have hli := harmonicQuartic_selected_linearIndependent_of_card_le_four (𝔽 := 𝔽)
    (S := S) (by omega) hambient
  convert hli using 1
  funext j i
  rfl

/-- One genuine four-helper repair, together with uniform four-column independence, pins the dual
distance of the quartic--nucleus code to five. -/
theorem harmonicQuarticCode_dualDist_eq_five_of_repair
    [Fintype 𝔽] [DecidableEq 𝔽] [CharP 𝔽 3]
    (hcard : 9 ≤ Fintype.card 𝔽) {x : HarmonicQuarticIndex 𝔽}
    {R : Finset (HarmonicQuarticIndex 𝔽)}
    (hR : R ∈ FiniteGeom.repairHypergraph (harmonicQuarticCode (𝔽 := 𝔽)) x 4)
    (hRcard : R.card = 4) :
    FiniteGeom.dualDist (harmonicQuarticCode (𝔽 := 𝔽)) = 5 := by
  obtain ⟨hsub, -, y, hy, hyx, hsupp⟩ := FiniteGeom.mem_repairHypergraph.mp hR
  have hy₀ : y ≠ 0 := by
    intro hzero
    exact hyx (congrFun hzero x)
  have hdual : FiniteGeom.dualCode (harmonicQuarticCode (𝔽 := 𝔽)) ≠ ⊥ := by
    intro hbot
    rw [hbot] at hy
    exact hy₀ (show y = 0 from hy)
  have hlo : 5 ≤ FiniteGeom.dualDist (harmonicQuarticCode (𝔽 := 𝔽)) :=
    FiniteGeom.le_dualDist_rowCode_of_column_independent
      (harmonicQuarticGenerator (𝔽 := 𝔽)) 5 hdual
      (harmonicQuarticGenerator_smallColumnIndependent hcard)
  have hxR : x ∉ R := by
    intro hx
    exact (Finset.mem_erase.mp (hsub hx)).1 rfl
  have hweight : hammingNorm y = 5 := by
    rw [← FiniteGeom.card_wordSupport, hsupp, Finset.card_insert_of_notMem hxR, hRcard]
  have hhi : FiniteGeom.dualDist (harmonicQuarticCode (𝔽 := 𝔽)) ≤ 5 := by
    rw [← hweight]
    exact FiniteGeom.dualDist_le_hammingNorm hy hy₀
  exact Nat.le_antisymm hhi hlo

/-- A finite harmonic block together with the nucleus is a five-circuit: the full family is
dependent and deleting any one member leaves an independent four-family. -/
theorem finiteHarmonicBlock_isFiveCircuit [CharP 𝔽 3] {a b c d : 𝔽}
    (hab : a ≠ b) (hac : a ≠ c) (had : a ≠ d)
    (hbc : b ≠ c) (hbd : b ≠ d) (hcd : c ≠ d)
    (hblock : IsHarmonicQuarticBlock (.finite a) (.finite b) (.finite c) (.finite d)) :
    ¬LinearIndependent 𝔽
        (harmonicQuarticFamily (.finite a) (.finite b) (.finite c) (.finite d)) ∧
      LinearIndependent 𝔽 ![
        harmonicQuarticCurvePoint (.finite a), harmonicQuarticCurvePoint (.finite b),
        harmonicQuarticCurvePoint (.finite c), harmonicQuarticCurvePoint (.finite d)] ∧
      LinearIndependent 𝔽 (nucleusFiniteTripleFamily b c d) ∧
      LinearIndependent 𝔽 (nucleusFiniteTripleFamily a c d) ∧
      LinearIndependent 𝔽 (nucleusFiniteTripleFamily a b d) ∧
      LinearIndependent 𝔽 (nucleusFiniteTripleFamily a b c) := by
  refine ⟨?_, fourFiniteHarmonicQuarticCurve_linearIndependent hab hac had hbc hbd hcd,
    nucleusFiniteTriple_linearIndependent hbc hbd hcd,
    nucleusFiniteTriple_linearIndependent hac had hcd,
    nucleusFiniteTriple_linearIndependent hab had hbd,
    nucleusFiniteTriple_linearIndependent hab hac hbc⟩
  intro hli
  exact (harmonicQuarticFamily_finite_linearIndependent_iff hab hac had hbc hbd hcd).1 hli hblock

/-- A harmonic block containing infinity together with the nucleus is likewise a five-circuit. -/
theorem infinityHarmonicBlock_isFiveCircuit [CharP 𝔽 3] {a b c : 𝔽}
    (hab : a ≠ b) (hac : a ≠ c) (hbc : b ≠ c)
    (hblock : IsHarmonicQuarticBlock (.finite a) (.finite b) (.finite c) .infinity) :
    ¬LinearIndependent 𝔽
        (harmonicQuarticFamily (.finite a) (.finite b) (.finite c) .infinity) ∧
      LinearIndependent 𝔽 ![
        harmonicQuarticCurvePoint (.finite a), harmonicQuarticCurvePoint (.finite b),
        harmonicQuarticCurvePoint (.finite c), harmonicQuarticCurvePoint .infinity] ∧
      LinearIndependent 𝔽 (nucleusFiniteInfinityFamily b c) ∧
      LinearIndependent 𝔽 (nucleusFiniteInfinityFamily a c) ∧
      LinearIndependent 𝔽 (nucleusFiniteInfinityFamily a b) ∧
      LinearIndependent 𝔽 (nucleusFiniteTripleFamily a b c) := by
  refine ⟨?_, finiteTripleInfinityCurve_linearIndependent hab hac hbc,
    nucleusFiniteInfinity_linearIndependent hbc,
    nucleusFiniteInfinity_linearIndependent hac,
    nucleusFiniteInfinity_linearIndependent hab,
    nucleusFiniteTriple_linearIndependent hab hac hbc⟩
  intro hli
  exact (harmonicQuarticFamily_infinity_linearIndependent_iff hab hac hbc).1 hli hblock

/-- Coordinate indices of the nucleus followed by four prescribed curve parameters. -/
def harmonicQuarticBlockIndex (a b c d : HarmonicParameter 𝔽) :
    Fin 5 → HarmonicQuarticIndex 𝔽 :=
  ![.inr (), .inl a, .inl b, .inl c, .inl d]

/-- A finite harmonic block gives all five pointed radius-four ports: choosing any one of its
nucleus-plus-block coordinates as target leaves the other four as helpers. -/
theorem finiteHarmonicBlock_repairPort [Fintype 𝔽] [DecidableEq 𝔽] [CharP 𝔽 3]
    {a b c d : 𝔽}
    (hab : a ≠ b) (hac : a ≠ c) (had : a ≠ d)
    (hbc : b ≠ c) (hbd : b ≠ d) (hcd : c ≠ d)
    (hblock : IsHarmonicQuarticBlock (.finite a) (.finite b) (.finite c) (.finite d))
    (j : Fin 5) :
    (Finset.univ.erase j).image
        (harmonicQuarticBlockIndex (.finite a) (.finite b) (.finite c) (.finite d)) ∈
      FiniteGeom.repairHypergraph (harmonicQuarticCode (𝔽 := 𝔽))
        (harmonicQuarticBlockIndex (.finite a) (.finite b) (.finite c) (.finite d) j) 4 := by
  let f := harmonicQuarticBlockIndex (.finite a) (.finite b) (.finite c) (.finite d)
  have hf : Function.Injective f := by
    intro i k hik
    fin_cases i <;> fin_cases k <;> simp_all [f, harmonicQuarticBlockIndex]
  have hc := finiteHarmonicBlock_isFiveCircuit hab hac had hbc hbd hcd hblock
  apply fiveCircuit_repairPort (G := harmonicQuarticGenerator (𝔽 := 𝔽)) f hf
  · have heq : (fun i => (harmonicQuarticGenerator (𝔽 := 𝔽)).col (f i)) =
        harmonicQuarticFamily (.finite a) (.finite b) (.finite c) (.finite d) := by
      funext i x
      fin_cases i <;> rfl
    rw [heq]
    exact hc.1
  · intro k
    fin_cases k
    · convert hc.2.1 using 1
      funext i x
      fin_cases i <;> rfl
    · convert hc.2.2.1 using 1
      funext i x
      fin_cases i <;> rfl
    · convert hc.2.2.2.1 using 1
      funext i x
      fin_cases i <;> rfl
    · convert hc.2.2.2.2.1 using 1
      funext i x
      fin_cases i <;> rfl
    · convert hc.2.2.2.2.2 using 1
      funext i x
      fin_cases i <;> rfl

/-- The same five pointed ports for a harmonic block whose normalized fourth parameter is the
point at infinity. -/
theorem infinityHarmonicBlock_repairPort [Fintype 𝔽] [DecidableEq 𝔽] [CharP 𝔽 3]
    {a b c : 𝔽} (hab : a ≠ b) (hac : a ≠ c) (hbc : b ≠ c)
    (hblock : IsHarmonicQuarticBlock (.finite a) (.finite b) (.finite c) .infinity)
    (j : Fin 5) :
    (Finset.univ.erase j).image
        (harmonicQuarticBlockIndex (.finite a) (.finite b) (.finite c) .infinity) ∈
      FiniteGeom.repairHypergraph (harmonicQuarticCode (𝔽 := 𝔽))
        (harmonicQuarticBlockIndex (.finite a) (.finite b) (.finite c) .infinity j) 4 := by
  let f := harmonicQuarticBlockIndex (.finite a) (.finite b) (.finite c) .infinity
  have hf : Function.Injective f := by
    intro i k hik
    fin_cases i <;> fin_cases k <;> simp_all [f, harmonicQuarticBlockIndex]
  have hc := infinityHarmonicBlock_isFiveCircuit hab hac hbc hblock
  apply fiveCircuit_repairPort (G := harmonicQuarticGenerator (𝔽 := 𝔽)) f hf
  · have heq : (fun i => (harmonicQuarticGenerator (𝔽 := 𝔽)).col (f i)) =
        harmonicQuarticFamily (.finite a) (.finite b) (.finite c) .infinity := by
      funext i x
      fin_cases i <;> rfl
    rw [heq]
    exact hc.1
  · intro k
    fin_cases k
    · convert hc.2.1 using 1
      funext i x
      fin_cases i <;> rfl
    · convert hc.2.2.1 using 1
      funext i x
      fin_cases i <;> rfl
    · convert hc.2.2.2.1 using 1
      funext i x
      fin_cases i <;> rfl
    · convert hc.2.2.2.2.1 using 1
      funext i x
      fin_cases i <;> rfl
    · convert hc.2.2.2.2.2 using 1
      funext i x
      fin_cases i <;> rfl

/-- The normalized block `{0,1,-1,∞}` supplies a concrete four-helper repair over every
field of characteristic three. -/
theorem exists_harmonicQuartic_fourHelperRepair
    [Fintype 𝔽] [DecidableEq 𝔽] [CharP 𝔽 3] :
    ∃ (x : HarmonicQuarticIndex 𝔽) (R : Finset (HarmonicQuarticIndex 𝔽)),
      R ∈ FiniteGeom.repairHypergraph (harmonicQuarticCode (𝔽 := 𝔽)) x 4 ∧
        R.card = 4 := by
  have hone : (1 : 𝔽) ≠ -1 := by
    intro h
    have hthree : (3 : 𝔽) = 0 := CharP.cast_eq_zero 𝔽 3
    have htwo : (2 : 𝔽) = 0 := by linear_combination h
    have hzero : (1 : 𝔽) = 0 := by linear_combination hthree - htwo
    exact one_ne_zero hzero
  let f := harmonicQuarticBlockIndex
    (.finite (0 : 𝔽)) (.finite 1) (.finite (-1)) .infinity
  let R : Finset (HarmonicQuarticIndex 𝔽) := (Finset.univ.erase (0 : Fin 5)).image f
  have hf : Function.Injective f := by
    intro i k hik
    fin_cases i <;> fin_cases k <;> simp_all [f, harmonicQuarticBlockIndex]
  have hblock : IsHarmonicQuarticBlock
      (.finite (0 : 𝔽)) (.finite 1) (.finite (-1)) .infinity := by
    simp [IsHarmonicQuarticBlock, harmonicE₁]
  refine ⟨f 0, R, ?_, ?_⟩
  · exact infinityHarmonicBlock_repairPort (zero_ne_one) (by simp) hone hblock 0
  · rw [Finset.card_image_of_injective _ hf,
      Finset.card_erase_of_mem (Finset.mem_univ (0 : Fin 5)), Finset.card_univ,
      Fintype.card_fin]

/-- The quartic--nucleus code has dual distance five uniformly in characteristic three once the
field has at least nine elements. -/
theorem dualDist_harmonicQuarticCode [Fintype 𝔽] [DecidableEq 𝔽] [CharP 𝔽 3]
    (hcard : 9 ≤ Fintype.card 𝔽) :
    FiniteGeom.dualDist (harmonicQuarticCode (𝔽 := 𝔽)) = 5 := by
  obtain ⟨x, R, hR, hRcard⟩ := exists_harmonicQuartic_fourHelperRepair (𝔽 := 𝔽)
  exact harmonicQuarticCode_dualDist_eq_five_of_repair hcard hR hRcard

/-- Paper-facing exact code parameters.  The sole exposed global input is the sharp five-point
hyperplane-section statement; rank, small-circuit exclusion, and the weight-five dual witness are
proved above from the displayed coordinates. -/
theorem harmonicQuarticCode_parameters_of_sharp_section
    [Fintype 𝔽] [DecidableEq 𝔽] [CharP 𝔽 3]
    (hcard : 9 ≤ Fintype.card 𝔽) (a₀ : Fin 5 → 𝔽)
    (ha₀ : FiniteGeom.pointEval (harmonicQuarticPoints (𝔽 := 𝔽)) a₀ ≠ 0)
    (hmax : FiniteGeom.sectionCount (harmonicQuarticPoints (𝔽 := 𝔽)) a₀ = 5)
    (hsection : ∀ a : Fin 5 → 𝔽,
      FiniteGeom.pointEval (harmonicQuarticPoints (𝔽 := 𝔽)) a ≠ 0 →
      FiniteGeom.sectionCount (harmonicQuarticPoints (𝔽 := 𝔽)) a ≤ 5) :
    Fintype.card (HarmonicQuarticIndex 𝔽) = Fintype.card 𝔽 + 2 ∧
      Module.finrank 𝔽 (harmonicQuarticCode (𝔽 := 𝔽)) = 5 ∧
      FiniteGeom.minDist (harmonicQuarticCode (𝔽 := 𝔽)) =
        Fintype.card 𝔽 - 3 ∧
      FiniteGeom.dualDist (harmonicQuarticCode (𝔽 := 𝔽)) = 5 := by
  have hlength := card_harmonicQuarticIndex (𝔽 := 𝔽)
  have hdim := finrank_harmonicQuarticCode (𝔽 := 𝔽) (by omega)
  have hdistance := FiniteGeom.columnCode_minDist_eq ha₀ hmax hsection
  rw [← harmonicQuarticCode_eq_columnCode, hlength] at hdistance
  refine ⟨hlength, hdim, ?_, dualDist_harmonicQuarticCode hcard⟩
  omega

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

/-! ### Abstract harmonic and port closure -/

/-- Least closure of a curve-parameter set under completing three members of a harmonic block. -/
inductive HarmonicDesignClosure (S : Set (HarmonicParameter 𝔽)) :
    HarmonicParameter 𝔽 → Prop
  | base {x} (hx : x ∈ S) : HarmonicDesignClosure S x
  | complete {a b c d}
      (hblock : IsHarmonicQuarticBlock a b c d)
      (ha : HarmonicDesignClosure S a) (hb : HarmonicDesignClosure S b)
      (hc : HarmonicDesignClosure S c) : HarmonicDesignClosure S d

/-- Least closure of a quartic--nucleus coordinate set under the radius-four harmonic repair
rules: a complete block repairs the nucleus, while the nucleus and three block points repair the
fourth curve point. -/
inductive HarmonicPortClosure (A : Set (HarmonicQuarticIndex 𝔽)) :
    HarmonicQuarticIndex 𝔽 → Prop
  | base {x} (hx : x ∈ A) : HarmonicPortClosure A x
  | nucleus {a b c d}
      (hblock : IsHarmonicQuarticBlock a b c d)
      (ha : HarmonicPortClosure A (.inl a)) (hb : HarmonicPortClosure A (.inl b))
      (hc : HarmonicPortClosure A (.inl c)) (hd : HarmonicPortClosure A (.inl d)) :
      HarmonicPortClosure A (.inr ())
  | curve {a b c d}
      (hblock : IsHarmonicQuarticBlock a b c d)
      (hN : HarmonicPortClosure A (.inr ()))
      (ha : HarmonicPortClosure A (.inl a)) (hb : HarmonicPortClosure A (.inl b))
      (hc : HarmonicPortClosure A (.inl c)) : HarmonicPortClosure A (.inl d)

/-- The curve coordinates belonging to a parameter set. -/
def harmonicCurveCoordinateSet (S : Set (HarmonicParameter 𝔽)) :
    Set (HarmonicQuarticIndex 𝔽) := Sum.inl '' S

/-- The initial coordinate set consisting of the nucleus and a prescribed curve set. -/
def harmonicCurveCoordinateSetWithNucleus (S : Set (HarmonicParameter 𝔽)) :
    Set (HarmonicQuarticIndex 𝔽) :=
  insert (.inr ()) (harmonicCurveCoordinateSet S)

/-- With the nucleus initially present, port closure is exactly harmonic completion on the curve
coordinates, together with the nucleus itself. -/
theorem harmonicPortClosure_withNucleus_iff (S : Set (HarmonicParameter 𝔽))
    (x : HarmonicQuarticIndex 𝔽) :
    HarmonicPortClosure (harmonicCurveCoordinateSetWithNucleus S) x ↔
      match x with
      | .inl t => HarmonicDesignClosure S t
      | .inr _ => True := by
  constructor
  · intro hx
    induction hx with
    | @base y hy =>
        cases y with
        | inl t =>
            apply HarmonicDesignClosure.base
            simpa [harmonicCurveCoordinateSetWithNucleus, harmonicCurveCoordinateSet] using hy
        | inr u => trivial
    | nucleus hblock ha hb hc hd iha ihb ihc ihd => trivial
    | curve hblock hN ha hb hc ihN iha ihb ihc =>
        exact HarmonicDesignClosure.complete hblock iha ihb ihc
  · cases x with
    | inr u =>
        intro _
        cases u
        exact HarmonicPortClosure.base (by simp [harmonicCurveCoordinateSetWithNucleus])
    | inl t =>
        intro ht
        induction ht with
        | base hx =>
            exact HarmonicPortClosure.base
              (by simp [harmonicCurveCoordinateSetWithNucleus, harmonicCurveCoordinateSet, hx])
        | complete hblock ha hb hc iha ihb ihc =>
            exact HarmonicPortClosure.curve hblock
              (HarmonicPortClosure.base (by simp [harmonicCurveCoordinateSetWithNucleus]))
              iha ihb ihc

/-- If the initial curve set contains a harmonic block, its radius-four port closure consists of
the nucleus and exactly the harmonic design closure of the curve set. -/
theorem harmonicPortClosure_of_containsBlock_iff
    {S : Set (HarmonicParameter 𝔽)}
    (hcontains : ∃ a b c d,
      IsHarmonicQuarticBlock a b c d ∧ a ∈ S ∧ b ∈ S ∧ c ∈ S ∧ d ∈ S)
    (x : HarmonicQuarticIndex 𝔽) :
    HarmonicPortClosure (harmonicCurveCoordinateSet S) x ↔
      match x with
      | .inl t => HarmonicDesignClosure S t
      | .inr _ => True := by
  obtain ⟨a, b, c, d, hblock, ha, hb, hc, hd⟩ := hcontains
  have hN : HarmonicPortClosure (harmonicCurveCoordinateSet S) (.inr ()) :=
    HarmonicPortClosure.nucleus hblock
      (HarmonicPortClosure.base ⟨a, ha, rfl⟩)
      (HarmonicPortClosure.base ⟨b, hb, rfl⟩)
      (HarmonicPortClosure.base ⟨c, hc, rfl⟩)
      (HarmonicPortClosure.base ⟨d, hd, rfl⟩)
  constructor
  · intro hx
    induction hx with
    | base hx =>
        rcases hx with ⟨t, ht, rfl⟩
        exact HarmonicDesignClosure.base ht
    | nucleus hblock ha hb hc hd iha ihb ihc ihd => trivial
    | curve hblock hN' ha hb hc ihN iha ihb ihc =>
        exact HarmonicDesignClosure.complete hblock iha ihb ihc
  · cases x with
    | inr u =>
        intro _
        cases u
        exact hN
    | inl t =>
        intro ht
        induction ht with
        | base hx => exact HarmonicPortClosure.base ⟨_, hx, rfl⟩
        | complete hblock ha hb hc iha ihb ihc =>
            exact HarmonicPortClosure.curve hblock hN iha ihb ihc

/-- If the initial curve set contains no complete harmonic block, no radius-four repair rule can
fire and its port closure is the initial set itself. -/
theorem harmonicPortClosure_of_containsNoBlock_iff
    {S : Set (HarmonicParameter 𝔽)}
    (hfree : ¬∃ a b c d,
      IsHarmonicQuarticBlock a b c d ∧ a ∈ S ∧ b ∈ S ∧ c ∈ S ∧ d ∈ S)
    (x : HarmonicQuarticIndex 𝔽) :
    HarmonicPortClosure (harmonicCurveCoordinateSet S) x ↔ x ∈ harmonicCurveCoordinateSet S := by
  constructor
  · intro hx
    induction hx with
    | base hx => exact hx
    | @nucleus a b c d hblock ha hb hc hd iha ihb ihc ihd =>
        exfalso
        apply hfree
        have haS : a ∈ S := by simpa [harmonicCurveCoordinateSet] using iha
        have hbS : b ∈ S := by simpa [harmonicCurveCoordinateSet] using ihb
        have hcS : c ∈ S := by simpa [harmonicCurveCoordinateSet] using ihc
        have hdS : d ∈ S := by simpa [harmonicCurveCoordinateSet] using ihd
        exact ⟨a, b, c, d, hblock, haS, hbS, hcS, hdS⟩
    | @curve a b c d hblock hN ha hb hc ihN iha ihb ihc =>
        have hfalse := ihN
        simp [harmonicCurveCoordinateSet] at hfalse
  · exact HarmonicPortClosure.base

end RepairPorts
