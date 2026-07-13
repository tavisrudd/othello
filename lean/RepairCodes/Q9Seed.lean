import RepairCodes.OuterDual
import FiniteGeom.MomentCurve
import FiniteGeom.ColumnCode
import FiniteGeom.Repair
import Mathlib.FieldTheory.Finite.GaloisField
import Mathlib.LinearAlgebra.Matrix.ToLin

/-!
# The concrete `𝔽₉` inner seed and the transfer-interface consistency witness

Plan §5 decision 1 requires both a real code-backed instance and a small shape witness. This file
now supplies the intended `𝔽₉` inner code and encoder equivalence, followed by the original
**consistency witness**, which establishes that the abstract hypotheses are jointly satisfiable
and that the single-block conclusion can have card `= 1`, not merely `0`.

Two notes for a reviewer:

* Any instance satisfying the hypotheses necessarily has every block inner-dual —
  that is exactly `transfer_blockwise`. So a *satisfying* witness cannot exercise
  the `exfalso` branch of `transfer_blockwise`: that branch characterizes
  configurations the hypotheses rule out, not ones a witness can realize.
* `innerDual` / `blockWt` in the final toy witness are a stand-in over `ℕ`, not the `𝔽₉` code;
  the witness tests the interface's shape, not any coding-theoretic content.

## The real `q = 9` inner code

This file now defines the intended inner seed `C₀ = C_{3,2}` over
`𝔽₉ = GaloisField 3 2`: its generator columns are the nine finite twisted-cubic points
`(1,t,t²,t³)` and the distinguished column `e₂`.  A four-column Vandermonde minor proves that
the generator rows are independent, yielding an explicit encoder equivalence
`𝔽₉⁴ ≃ₗ[𝔽₉] C₀`.  Consequently `blockFunctional_eq_zero_iff` discharges coefficient
faithfulness for this actual code without trace coordinates.

This file proves the full `[10,4,6]₉` parameters and exact dual distance `d(C₀⊥)=4`.
Every sub-four column family is independent, while the columns at `0,1,-1` and `e₂` form a
weight-four circuit. The primal distance comes from the maximum four-point hyperplane section,
attained by `T³-T`. `q9Inner_transfer_ofOuterCode` proves the outer-dual step directly in the
functional alphabet, so no trace-decomposition import remains. The complete radius-three repair
hypergraph at `e₂` is derived from actual dual supports and is nonempty with every edge of size
three; identifying all its edges and proving `ν=3, τ=5` is the next combinatorial layer.
-/

namespace RepairCodes

open Finset Matrix FiniteGeom

noncomputable section

local instance : Fact (Nat.Prime 3) := ⟨by decide⟩

/-- The concrete target field `𝔽₉`. -/
abbrev GF9 := GaloisField 3 2

local instance : Fintype GF9 := Fintype.ofFinite GF9
local instance : DecidableEq GF9 := Classical.decEq _
local instance : DecidableEq (Module.Dual GF9 (Fin 4 → GF9)) := Classical.decEq _

/-- A fixed enumeration of all nine elements of `𝔽₉`.  The construction is noncanonical, but all
code statements below use only its bijectivity. -/
noncomputable def gf9ParamEquiv : Fin 9 ≃ GF9 :=
  (Fintype.equivFinOfCardEq (α := GF9) (by
    rw [← Nat.card_eq_fintype_card]
    simpa using (GaloisField.card (p := 3) (n := 2) (by decide)))).symm

/-- The ten columns of the Roth–Lempel seed `C_{3,2}`: nine finite twisted-cubic points followed
by the distinguished coordinate `e₂ = (0,0,1,0)`. -/
noncomputable def q9SeedColumn (j : Fin 10) : Fin 4 → GF9 :=
  if h : (j : ℕ) < 9 then
    momentCurve 4 (gf9ParamEquiv ⟨j, h⟩)
  else
    fun i => if (i : ℕ) = 2 then 1 else 0

/-- Generator matrix of the concrete `[10,4,6]₉` seed (the distance is proved separately). -/
noncomputable def q9SeedGenerator : Matrix (Fin 4) (Fin 10) GF9 :=
  fun i j => q9SeedColumn j i

/-- The concrete inner code `C₀`, not a toy model. -/
noncomputable def q9InnerCode : Submodule GF9 (Fin 10 → GF9) :=
  rowCode q9SeedGenerator

/-- Evaluating the point system against a message is right multiplication by the generator
matrix. The apparent order reversal in the dot product disappears over the commutative field. -/
theorem q9PointEval_eq_encoder (a : Fin 4 → GF9) :
    pointEval q9SeedColumn a = q9SeedGenerator.vecMulLinear a := by
  funext j
  simp only [pointEval, Matrix.vecMulLinear_apply, Matrix.vecMul, dotProduct, q9SeedGenerator]
  apply Finset.sum_congr rfl
  intro i _
  exact mul_comm _ _

/-- The row-space presentation used by `RepairCodes` is the same code as the projective-system
`columnCode` presentation used by the hyperplane-section distance bridge. -/
theorem q9InnerCode_eq_columnCode : q9InnerCode = columnCode q9SeedColumn := by
  have hrow : q9InnerCode = LinearMap.range q9SeedGenerator.vecMulLinear := by
    change Submodule.span GF9 (Set.range q9SeedGenerator.row) =
      LinearMap.range q9SeedGenerator.vecMulLinear
    exact (range_vecMulLinear q9SeedGenerator).symm
  have hmap : q9SeedGenerator.vecMulLinear = (Matrix.of q9SeedColumn).mulVecLin := by
    apply LinearMap.ext
    intro a
    exact (q9PointEval_eq_encoder a).symm.trans (pointEval_eq_mulVecLin _ _)
  rw [hrow, columnCode, hmap]

/-- Embed the first four finite-coordinate positions into the ten seed coordinates. -/
def q9FirstFour (j : Fin 4) : Fin 10 := ⟨j, by omega⟩

/-- The distinguished tenth coordinate, whose generator column is `e₂`. -/
def q9Axis : Fin 10 := ⟨9, by decide⟩

/-- The four parameters used for the Vandermonde minor are distinct. -/
theorem q9FirstFour_params_injective :
    Function.Injective (fun j : Fin 4 => gf9ParamEquiv ⟨j, by omega⟩) := by
  intro i j h
  have hh : (⟨i, by omega⟩ : Fin 9) = ⟨j, by omega⟩ := gf9ParamEquiv.injective h
  have hv : (i : ℕ) = (j : ℕ) := congrArg (fun x : Fin 9 => (x : ℕ)) hh
  exact Fin.ext hv

/-- The four generator rows are independent.  Restricting them to the first four finite columns
gives the transpose of a Vandermonde matrix on four distinct `𝔽₉` parameters. -/
theorem q9SeedGenerator_rows_linearIndependent :
    LinearIndependent GF9 q9SeedGenerator.row := by
  let v : Fin 4 → GF9 := fun j => gf9ParamEquiv ⟨j, by omega⟩
  let A : Matrix (Fin 4) (Fin 4) GF9 := fun i j => q9SeedGenerator i (q9FirstFour j)
  have hv : Function.Injective v := q9FirstFour_params_injective
  have hA : A = (vandermonde v)ᵀ := by
    ext i j
    have hj9 : (j : ℕ) < 9 := lt_trans j.isLt (by decide)
    simp [A, q9SeedGenerator, q9SeedColumn, q9FirstFour, v, hj9]
  have hdet : A.det ≠ 0 := by
    rw [hA, det_transpose]
    exact det_vandermonde_ne_zero_iff.mpr hv
  have hrows : LinearIndependent GF9 A.row := linearIndependent_rows_of_det_ne_zero hdet
  let restrict : (Fin 10 → GF9) →ₗ[GF9] (Fin 4 → GF9) :=
    LinearMap.funLeft GF9 GF9 q9FirstFour
  apply LinearIndependent.of_comp restrict
  have heq : restrict ∘ q9SeedGenerator.row = A.row := by
    funext i j
    rfl
  rw [heq]
  exact hrows

/-- Any at-most-four family of finite (non-axis) seed columns is independent.  After rewriting
those columns as moment-curve points, this is `momentCurve_linearIndependent_of_card_le`. -/
theorem q9Seed_finite_columns_linearIndependent (S : Finset (Fin 10))
    (hfinite : ∀ j ∈ S, (j : ℕ) < 9) (hcard : S.card ≤ 4) :
    LinearIndependent GF9 (fun j : S => q9SeedColumn j) := by
  let v : S → GF9 := fun j => gf9ParamEquiv ⟨j, hfinite j j.property⟩
  have hv : Function.Injective v := by
    intro i j hij
    have hh : (⟨(i : Fin 10), hfinite i i.property⟩ : Fin 9) =
        ⟨(j : Fin 10), hfinite j j.property⟩ := gf9ParamEquiv.injective hij
    apply Subtype.ext
    exact Fin.ext (congrArg (fun x : Fin 9 => (x : ℕ)) hh)
  have hli := momentCurve_linearIndependent_of_card_le (n := 4) hv (by
    simpa only [Fintype.card_coe] using hcard)
  have heq : (fun j : S => q9SeedColumn j) = (fun j : S => momentCurve 4 (v j)) := by
    funext j i
    simp [q9SeedColumn, v, hfinite j j.property]
  rw [heq]
  exact hli

/-- Four-column matrix with three finite cubic points and the axis point `e₂`. -/
def q9CircuitMatrix (v : Fin 3 → GF9) : Matrix (Fin 4) (Fin 4) GF9 :=
  !![1, 1, 1, 0;
     v 0, v 1, v 2, 0;
     (v 0) ^ 2, (v 1) ^ 2, (v 2) ^ 2, 1;
     (v 0) ^ 3, (v 1) ^ 3, (v 2) ^ 3, 0]

/-- Generalized Vandermonde determinant for three cubic points plus `e₂`. Up to the displayed
nonzero Vandermonde factor, the determinant is the sum of the three parameters. -/
theorem q9CircuitMatrix_det (v : Fin 3 → GF9) :
    (q9CircuitMatrix v).det =
      -((v 1 - v 0) * (v 2 - v 0) * (v 2 - v 1) * (v 0 + v 1 + v 2)) := by
  let M : Matrix (Fin 3) (Fin 3) GF9 :=
    !![1, 1, 1;
       v 0, v 1, v 2;
       (v 0) ^ 3, (v 1) ^ 3, (v 2) ^ 3]
  have hr0 : Fin.succAbove (2 : Fin 4) (0 : Fin 3) = 0 := by decide
  have hr1 : Fin.succAbove (2 : Fin 4) (1 : Fin 3) = 1 := by decide
  have hr2 : Fin.succAbove (2 : Fin 4) (2 : Fin 3) = 3 := by decide
  have hc0 : Fin.succAbove (3 : Fin 4) (0 : Fin 3) = 0 := by decide
  have hc1 : Fin.succAbove (3 : Fin 4) (1 : Fin 3) = 1 := by decide
  have hc2 : Fin.succAbove (3 : Fin 4) (2 : Fin 3) = 2 := by decide
  have hsub : (q9CircuitMatrix v).submatrix
      (Fin.succAbove (2 : Fin 4)) (Fin.succAbove (3 : Fin 4)) = M := by
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp [q9CircuitMatrix, M, hr0, hr1, hr2, hc0, hc1, hc2]
  rw [Matrix.det_succ_column (q9CircuitMatrix v) (3 : Fin 4)]
  rw [Fin.sum_univ_four]
  rw [hsub]
  norm_num [q9CircuitMatrix]
  rw [Matrix.det_fin_three M]
  simp [M]
  ring

theorem q9CircuitMatrix_det_eq_zero_iff {v : Fin 3 → GF9} (hv : Function.Injective v) :
    (q9CircuitMatrix v).det = 0 ↔ v 0 + v 1 + v 2 = 0 := by
  rw [q9CircuitMatrix_det, neg_eq_zero, mul_eq_zero]
  have h10 : v 1 - v 0 ≠ 0 := sub_ne_zero.mpr (hv.ne (by decide))
  have h20 : v 2 - v 0 ≠ 0 := sub_ne_zero.mpr (hv.ne (by decide))
  have h21 : v 2 - v 1 ≠ 0 := sub_ne_zero.mpr (hv.ne (by decide))
  simp [h10, h20, h21]

/-- Every family of fewer than four columns of the q=9 seed generator is independent.  If the
axis column is absent this is Vandermonde general position.  If it is present, projecting to the
first two coordinates leaves at most two distinct points `(1,t)`; their coefficients vanish, and
the `X²` coordinate then kills the remaining axis coefficient. -/
theorem q9Seed_small_columns_linearIndependent (S : Finset (Fin 10)) (hcard : S.card < 4) :
    LinearIndependent GF9 (fun j : S => q9SeedGenerator.col j) := by
  have hcol : (fun j : S => q9SeedGenerator.col j) = (fun j : S => q9SeedColumn j) := by
    rfl
  rw [hcol]
  by_cases haxis : q9Axis ∈ S
  · let a : S := ⟨q9Axis, haxis⟩
    let T : Finset S := univ.erase a
    have hTfinite : ∀ j : T, ((j : S) : Fin 10).val < 9 := by
      intro j
      have hne : (j : S) ≠ a := (Finset.mem_erase.mp j.property).1
      have hne9 : (((j : S) : Fin 10) : ℕ) ≠ 9 := by
        intro hj
        apply hne
        apply Subtype.ext
        exact Fin.ext hj
      omega
    have hTcard : Fintype.card T ≤ 2 := by
      simp only [Fintype.card_coe]
      dsimp only [T]
      rw [Finset.card_erase_of_mem (Finset.mem_univ a), Finset.card_univ,
        Fintype.card_coe]
      omega
    let v : T → GF9 := fun j => gf9ParamEquiv
      ⟨(((j : T) : S) : Fin 10), hTfinite j⟩
    have hv : Function.Injective v := by
      intro i j hij
      have hh := gf9ParamEquiv.injective hij
      apply Subtype.ext
      apply Subtype.ext
      exact Fin.ext (congrArg (fun x : Fin 9 => (x : ℕ)) hh)
    have hli : LinearIndependent GF9 (fun j : T => momentCurve 2 (v j)) :=
      momentCurve_linearIndependent_of_card_le hv hTcard
    rw [Fintype.linearIndependent_iff]
    intro g hrel
    let restrict : (Fin 4 → GF9) →ₗ[GF9] (Fin 2 → GF9) :=
      LinearMap.funLeft GF9 GF9 (Fin.castLE (by decide))
    have hproj : ∑ j : S, g j • restrict (q9SeedColumn j) = 0 := by
      simpa using congrArg (fun z => restrict z) hrel
    have haxis_zero : restrict (q9SeedColumn a) = 0 := by
      funext i
      simp [restrict, a, q9Axis, q9SeedColumn]
      omega
    have herase : ∑ j ∈ T, g j • restrict (q9SeedColumn j) = 0 := by
      have h := hproj
      rw [← Finset.sum_erase_add univ (fun j : S => g j • restrict (q9SeedColumn j))
        (Finset.mem_univ a)] at h
      simpa [T, haxis_zero] using h
    have herase' : ∑ j : T, g j • restrict (q9SeedColumn j) = 0 := by
      calc
        (∑ j : T, g j • restrict (q9SeedColumn j)) =
            ∑ j ∈ T, g j • restrict (q9SeedColumn j) := by
          rw [← T.sum_attach]
          rfl
        _ = 0 := herase
    have hcurve : ∑ j : T, g j • momentCurve 2 (v j) = 0 := by
      convert herase' using 1
      · apply Finset.sum_congr rfl
        intro j _
        congr 1
        funext i
        simp [restrict, q9SeedColumn, v, hTfinite j]
    have hcoeffT := (Fintype.linearIndependent_iff.mp hli) (fun j : T => g j) hcurve
    have hothers : ∀ j : S, j ≠ a → g j = 0 := by
      intro j hj
      have hjT : j ∈ T := by simp [T, hj]
      exact hcoeffT ⟨j, hjT⟩
    have hga : g a = 0 := by
      have hi := congrFun hrel (2 : Fin 4)
      simp only [Finset.sum_apply, Pi.smul_apply, Pi.zero_apply] at hi
      rw [Fintype.sum_eq_single a (fun j hj => by simp [hothers j hj])] at hi
      simpa [a, q9Axis, q9SeedColumn] using hi
    intro j
    by_cases hj : j = a
    · simpa [hj] using hga
    · exact hothers j hj
  · apply q9Seed_finite_columns_linearIndependent S
    · intro j hj
      have hjne : j ≠ q9Axis := fun h => haxis (h ▸ hj)
      have hjne9 : (j : ℕ) ≠ 9 := by
        intro h
        apply hjne
        exact Fin.ext h
      omega
    · omega

/-- Coordinate of the finite twisted-cubic point with parameter `t`. -/
noncomputable def q9FiniteIndex (t : GF9) : Fin 10 :=
  Fin.castLE (by decide) (gf9ParamEquiv.symm t)

/-- Parameter attached to a seed coordinate. Its axis value is irrelevant; repair helper sets
never contain the axis. -/
noncomputable def q9IndexParam (j : Fin 10) : GF9 :=
  if h : (j : ℕ) < 9 then gf9ParamEquiv ⟨j, h⟩ else 0

theorem q9IndexParam_eq {j : Fin 10} (h : (j : ℕ) < 9) :
    q9IndexParam j = gf9ParamEquiv ⟨j, h⟩ := by
  simp [q9IndexParam, h]

@[simp]
theorem q9IndexParam_finiteIndex (t : GF9) : q9IndexParam (q9FiniteIndex t) = t := by
  simp [q9IndexParam, q9FiniteIndex]

theorem q9FiniteIndex_indexParam {j : Fin 10} (h : (j : ℕ) < 9) :
    q9FiniteIndex (q9IndexParam j) = j := by
  apply Fin.ext
  simp [q9FiniteIndex, q9IndexParam, h]

theorem q9FiniteIndex_injective : Function.Injective q9FiniteIndex := by
  intro s t h
  apply gf9ParamEquiv.symm.injective
  exact Fin.ext (congrArg (fun j : Fin 10 => (j : ℕ)) h)

theorem q9FiniteIndex_ne_axis (t : GF9) : q9FiniteIndex t ≠ q9Axis := by
  intro h
  have hv := congrArg (fun j : Fin 10 => (j : ℕ)) h
  simp [q9FiniteIndex, q9Axis] at hv
  exact (Nat.ne_of_lt (gf9ParamEquiv.symm t).isLt) hv

@[simp]
theorem q9SeedColumn_finiteIndex (t : GF9) :
    q9SeedColumn (q9FiniteIndex t) = momentCurve 4 t := by
  funext i
  simp [q9SeedColumn, q9FiniteIndex]

/-- Every hyperplane meets the ten-point seed system in at most four points: at most three of the
nine finite twisted-cubic points, plus the distinguished axis point. -/
theorem q9Seed_sectionCount_le (a : Fin 4 → GF9) (ha : a ≠ 0) :
    sectionCount q9SeedColumn a ≤ 4 := by
  let Z : Finset (Fin 10) := univ.filter fun j => q9SeedColumn j ⬝ᵥ a = 0
  let Zf : Finset (Fin 10) := Z.erase q9Axis
  let R : Finset (Fin 9) := univ.filter fun j => momentCurve 4 (gf9ParamEquiv j) ⬝ᵥ a = 0
  have hR : R.card ≤ 3 := by
    simpa only [R] using
      (momentCurve_section_le (n := 4) (m := 9) ha gf9ParamEquiv.injective)
  have hZfR : Zf.card ≤ R.card := by
    let f : Zf → R := fun j => by
      have hjZ : (j : Fin 10) ∈ Z := (Finset.mem_erase.mp j.property).2
      have hjne : (j : Fin 10) ≠ q9Axis := (Finset.mem_erase.mp j.property).1
      have hjlt : ((j : Fin 10) : ℕ) < 9 := by
        have hjne9 : ((j : Fin 10) : ℕ) ≠ 9 := by
          intro h
          apply hjne
          exact Fin.ext h
        omega
      refine ⟨⟨(j : Fin 10), hjlt⟩, ?_⟩
      have hz : q9SeedColumn (j : Fin 10) ⬝ᵥ a = 0 := by simpa [Z] using hjZ
      simpa [R, q9SeedColumn, hjlt] using hz
    have hf : Function.Injective f := by
      intro i j hij
      apply Subtype.ext
      apply Fin.ext
      exact congrArg (fun x : R => (((x : Fin 9) : ℕ))) hij
    have hc := Fintype.card_le_of_injective f hf
    simpa only [Fintype.card_coe] using hc
  have hZZf : Z.card ≤ Zf.card + 1 := by
    dsimp only [Zf]
    by_cases hax : q9Axis ∈ Z
    · rw [Finset.card_erase_of_mem hax]
      omega
    · rw [Finset.erase_eq_of_notMem hax]
      omega
  change Z.card ≤ 4
  omega

/-- The four columns at parameters `0,1,-1` together with the axis column sum to zero.  This is
the characteristic-three circuit underlying the distinguished coordinate's locality three. -/
theorem q9Seed_four_column_relation :
    q9SeedColumn (q9FiniteIndex 0) + q9SeedColumn (q9FiniteIndex 1) +
        q9SeedColumn (q9FiniteIndex (-1)) + q9SeedColumn q9Axis = 0 := by
  simp only [q9SeedColumn_finiteIndex]
  funext i
  fin_cases i <;> norm_num [q9SeedColumn, q9Axis, momentCurve] <;>
    linear_combination CharP.cast_eq_zero GF9 3

theorem q9_one_ne_neg_one : (1 : GF9) ≠ -1 := by
  intro h
  have h2 : (2 : GF9) = 0 := by linear_combination h
  have hdvd : 3 ∣ 2 := (CharP.cast_eq_zero_iff GF9 3 2).mp h2
  norm_num at hdvd

/-- Support of the explicit weight-four dual word. -/
noncomputable def q9DualWitnessSupport : Finset (Fin 10) :=
  {q9FiniteIndex 0, q9FiniteIndex 1, q9FiniteIndex (-1), q9Axis}

/-- The indicator of the four-column circuit. -/
noncomputable def q9DualWitness : Fin 10 → GF9 := fun j =>
  if j ∈ q9DualWitnessSupport then 1 else 0

theorem q9DualWitnessSupport_card : q9DualWitnessSupport.card = 4 := by
  have h01 : (0 : GF9) ≠ 1 := zero_ne_one
  have h0n : (0 : GF9) ≠ -1 := by norm_num
  have h1n : (1 : GF9) ≠ -1 := q9_one_ne_neg_one
  simp [q9DualWitnessSupport, q9FiniteIndex_ne_axis,
    q9FiniteIndex_injective.ne h01, q9FiniteIndex_injective.ne h0n,
    q9FiniteIndex_injective.ne h1n]

theorem q9DualWitness_hammingNorm : hammingNorm q9DualWitness = 4 := by
  unfold hammingNorm
  have hfilter : (univ.filter fun j => q9DualWitness j ≠ 0) = q9DualWitnessSupport := by
    ext j
    simp [q9DualWitness]
  rw [hfilter, q9DualWitnessSupport_card]

theorem q9DualWitness_wordSupport : wordSupport q9DualWitness = q9DualWitnessSupport := by
  ext j
  simp [wordSupport, q9DualWitness]

/-- The explicit four-column relation is a nonzero word of `C₀⊥`. -/
theorem q9DualWitness_mem : q9DualWitness ∈ dualCode q9InnerCode := by
  rw [q9InnerCode, mem_dualCode_rowCode_iff_mulVec]
  funext i
  simp only [Matrix.mulVec, dotProduct, Pi.zero_apply]
  calc
    (∑ j, q9SeedGenerator i j * q9DualWitness j) =
        ∑ j ∈ q9DualWitnessSupport, q9SeedGenerator i j := by
      simp [q9DualWitness]
    _ = (q9SeedColumn (q9FiniteIndex 0) + q9SeedColumn (q9FiniteIndex 1) +
          q9SeedColumn (q9FiniteIndex (-1)) + q9SeedColumn q9Axis) i := by
      have h01 : (0 : GF9) ≠ 1 := zero_ne_one
      have h0n : (0 : GF9) ≠ -1 := by norm_num
      have h1n : (1 : GF9) ≠ -1 := q9_one_ne_neg_one
      simp [q9DualWitnessSupport, q9SeedGenerator, q9FiniteIndex_ne_axis,
        q9FiniteIndex_injective.ne h01, q9FiniteIndex_injective.ne h0n,
        q9FiniteIndex_injective.ne h1n, add_comm, add_left_comm, add_assoc]
    _ = 0 := congrFun q9Seed_four_column_relation i

theorem q9DualWitness_ne_zero : q9DualWitness ≠ 0 := by
  intro h
  have hw := q9DualWitness_hammingNorm
  rw [h, hammingNorm_zero] at hw
  omega

/-- **Exact dual distance of the real inner seed:** `d(C₀⊥)=4`.  The lower bound is the
small-column independence theorem; the upper bound is the explicit four-column circuit. -/
theorem q9InnerCode_dualDist : dualDist q9InnerCode = 4 := by
  have hdual : dualCode q9InnerCode ≠ ⊥ :=
    (Submodule.ne_bot_iff (dualCode q9InnerCode)).mpr
      ⟨q9DualWitness, q9DualWitness_mem, q9DualWitness_ne_zero⟩
  have hlower : 4 ≤ dualDist q9InnerCode := by
    simpa only [q9InnerCode] using
      le_dualDist_rowCode_of_column_independent q9SeedGenerator 4 hdual
        q9Seed_small_columns_linearIndependent
  have hupper : dualDist q9InnerCode ≤ 4 := by
    simpa only [q9DualWitness_hammingNorm] using
      dualDist_le_hammingNorm q9DualWitness_mem q9DualWitness_ne_zero
  omega

/-! ### The concrete repair hypergraph at the distinguished axis coordinate -/

/-- Complete locality-three repair hypergraph of the real code `C₀` at `e₂`, derived from all
dual-word supports of size at most four. -/
noncomputable def q9AxisRepairHypergraph : Finset (Finset (Fin 10)) :=
  repairHypergraph q9InnerCode q9Axis 3

/-- Helper set of the explicit `{0,1,-1,e₂}` dual circuit. -/
noncomputable def q9AxisHelpers : Finset (Fin 10) :=
  (wordSupport q9DualWitness).erase q9Axis

theorem q9Axis_mem_dualWitnessSupport : q9Axis ∈ wordSupport q9DualWitness := by
  rw [q9DualWitness_wordSupport]
  simp [q9DualWitnessSupport]

theorem q9AxisHelpers_card : q9AxisHelpers.card = 3 := by
  rw [q9AxisHelpers, Finset.card_erase_of_mem q9Axis_mem_dualWitnessSupport,
    card_wordSupport, q9DualWitness_hammingNorm]

/-- The explicit characteristic-three circuit is a genuine edge of the code-derived repair
hypergraph, so this is not merely an abstract or combinatorial witness. -/
theorem q9AxisHelpers_mem_repairHypergraph : q9AxisHelpers ∈ q9AxisRepairHypergraph := by
  rw [q9AxisRepairHypergraph, mem_repairHypergraph]
  refine ⟨?_, by rw [q9AxisHelpers_card], q9DualWitness, q9DualWitness_mem, ?_, ?_⟩
  · intro j hj
    have hj' := (Finset.mem_erase.mp hj)
    exact Finset.mem_erase.mpr ⟨hj'.1, Finset.mem_univ _⟩
  · exact mem_wordSupport.mp q9Axis_mem_dualWitnessSupport
  · exact (Finset.insert_erase q9Axis_mem_dualWitnessSupport).symm

/-- Every edge of the q=9 axis repair hypergraph has exactly three helpers, because
`d(C₀⊥)=4`. -/
theorem q9AxisRepair_edge_card {R : Finset (Fin 10)} (hR : R ∈ q9AxisRepairHypergraph) :
    R.card = 3 := by
  apply repair_edge_card_eq_of_dualDist (C := q9InnerCode) (x := q9Axis)
    (r := 3) (R := R) (by rw [q9InnerCode_dualDist])
  exact hR

theorem q9AxisRepair_edge_nonempty {R : Finset (Fin 10)} (hR : R ∈ q9AxisRepairHypergraph) :
    R.Nonempty := by
  have hc := q9AxisRepair_edge_card hR
  exact Finset.card_pos.mp (by omega)

theorem q9AxisRepairHypergraph_nonempty : q9AxisRepairHypergraph.Nonempty :=
  ⟨q9AxisHelpers, q9AxisHelpers_mem_repairHypergraph⟩

/-- Reindex three non-axis helpers followed by the axis so that the resulting generator submatrix
is the canonical four-column circuit matrix. -/
theorem q9AxisSupport_reindex {R : Finset (Fin 10)} (hxR : q9Axis ∉ R)
    (hc : R.card = 3) (er : Fin 3 ≃ R) :
    ∃ es : Fin 4 ≃ ↥(insert q9Axis R),
      (fun i j => q9SeedGenerator i (es j)) =
        q9CircuitMatrix (fun j => q9IndexParam (er j)) := by
  classical
  have hfinite (i : Fin 3) : (((er i : R) : Fin 10) : ℕ) < 9 := by
    have hne : ((er i : R) : Fin 10) ≠ q9Axis := fun h => hxR (h ▸ (er i).property)
    have hne9 : ((((er i : R) : Fin 10) : ℕ)) ≠ 9 := by
      intro h
      apply hne
      exact Fin.ext h
    omega
  let f : Fin 4 → Fin 10 := Fin.lastCases q9Axis (fun i => er i)
  have flast : f (Fin.last 3) = q9Axis := by rfl
  have fcast (i : Fin 3) : f i.castSucc = er i := by simp [f]
  have hfmem (j : Fin 4) : f j ∈ insert q9Axis R := by
    cases j using Fin.lastCases with
    | last =>
        rw [flast]
        exact Finset.mem_insert_self _ _
    | cast i =>
        rw [fcast]
        exact Finset.mem_insert_of_mem (er i).property
  have hfinj : Function.Injective f := by
    intro i j hij
    cases i using Fin.lastCases with
    | last =>
      cases j using Fin.lastCases with
      | last => rfl
      | cast j =>
        change f (Fin.last 3) = f j.castSucc at hij
        rw [flast, fcast] at hij
        have heq : q9Axis = (er j : R) := hij
        exact (hxR (heq ▸ (er j).property)).elim
    | cast i =>
      cases j using Fin.lastCases with
      | last =>
        change f i.castSucc = f (Fin.last 3) at hij
        rw [fcast, flast] at hij
        have heq : (er i : R) = q9Axis := hij
        exact (hxR (heq ▸ (er i).property)).elim
      | cast j =>
        apply Fin.ext
        have heq : er i = er j := Subtype.ext (by simpa [fcast] using hij)
        exact congrArg (fun z : Fin 3 => z.castSucc.val) (er.injective heq)
  let es : Fin 4 ≃ ↥(insert q9Axis R) := Equiv.ofBijective
    (fun j => ⟨f j, hfmem j⟩) ((Fintype.bijective_iff_injective_and_card _).2 ⟨by
      intro i j hij
      exact hfinj (congrArg Subtype.val hij), by
      rw [Fintype.card_fin, Fintype.card_coe]
      rw [Finset.card_insert_of_notMem hxR, hc]⟩)
  have hes (j : Fin 4) : (es j : Fin 10) = f j := rfl
  refine ⟨es, ?_⟩
  ext i j
  cases j using Fin.lastCases with
  | last =>
      rw [hes, flast]
      fin_cases i <;> simp [q9SeedGenerator, q9SeedColumn, q9Axis, q9CircuitMatrix]
  | cast j =>
      rw [hes, fcast]
      fin_cases j <;> fin_cases i <;>
        simp [q9SeedGenerator, q9SeedColumn, q9CircuitMatrix, q9IndexParam_eq, hfinite]

/-- Every axis repair edge, in any enumeration of its three helpers, has distinct parameters
whose sum is zero. This is the algebraic-line characterization in the direction needed for the
upper bounds on the repair hypergraph invariants. -/
theorem q9AxisRepair_edge_zeroSum {R : Finset (Fin 10)}
    (hR : R ∈ q9AxisRepairHypergraph) :
    ∃ e : Fin 3 ≃ R, Function.Injective (fun i => q9IndexParam (e i)) ∧
      q9IndexParam (e 0) + q9IndexParam (e 1) + q9IndexParam (e 2) = 0 := by
  classical
  have hc : R.card = 3 := q9AxisRepair_edge_card hR
  have hmem := (mem_repairHypergraph.mp hR).1
  have hxR : q9Axis ∉ R := by
    intro hx
    exact (Finset.mem_erase.mp (hmem hx)).1 rfl
  let er : Fin 3 ≃ R := (R.equivFinOfCardEq hc).symm
  have hfinite (i : Fin 3) : (((er i : R) : Fin 10) : ℕ) < 9 := by
    have hne : ((er i : R) : Fin 10) ≠ q9Axis := fun h => hxR (h ▸ (er i).property)
    have hne9 : ((((er i : R) : Fin 10) : ℕ)) ≠ 9 := by
      intro h
      apply hne
      exact Fin.ext h
    omega
  let v : Fin 3 → GF9 := fun i => q9IndexParam (er i)
  have hv : Function.Injective v := by
    intro i j hij
    have hp : gf9ParamEquiv
          ⟨((er i : R) : Fin 10), hfinite i⟩ =
        gf9ParamEquiv ⟨((er j : R) : Fin 10), hfinite j⟩ := by
      simpa [v, q9IndexParam_eq (hfinite i), q9IndexParam_eq (hfinite j)] using hij
    have heq := gf9ParamEquiv.injective hp
    apply er.injective
    apply Subtype.ext
    exact Fin.ext (congrArg (fun z : Fin 9 => (z : ℕ)) heq)
  obtain ⟨es, hmatrix⟩ := q9AxisSupport_reindex hxR hc er
  have hdet : Matrix.det (fun i j => q9SeedGenerator i (es j)) = 0 := by
    apply repair_edge_reindexed_det_eq_zero (G := q9SeedGenerator) hR es
  change (fun i j => q9SeedGenerator i (es j)) = q9CircuitMatrix v at hmatrix
  rw [hmatrix] at hdet
  have hsum := (q9CircuitMatrix_det_eq_zero_iff hv).mp hdet
  exact ⟨er, hv, hsum⟩

/-- A three-helper set away from the axis whose parameters sum to zero is an actual repair edge.
The determinant supplies dependence, and exact dual distance four forces the corresponding dual
relation to have full support. -/
theorem q9AxisRepair_edge_of_zeroSum {R : Finset (Fin 10)}
    (hsub : R ⊆ univ.erase q9Axis) (hc : R.card = 3) (er : Fin 3 ≃ R)
    (hsum : q9IndexParam (er 0) + q9IndexParam (er 1) + q9IndexParam (er 2) = 0) :
    R ∈ q9AxisRepairHypergraph := by
  classical
  have hxR : q9Axis ∉ R := by
    intro hx
    exact (Finset.mem_erase.mp (hsub hx)).1 rfl
  obtain ⟨es, hmatrix⟩ := q9AxisSupport_reindex hxR hc er
  let A : Matrix (Fin 4) (Fin 4) GF9 := fun i j => q9SeedGenerator i (es j)
  have hdetCircuit : (q9CircuitMatrix (fun j => q9IndexParam (er j))).det = 0 := by
    rw [q9CircuitMatrix_det, hsum]
    ring
  have hdetA : A.det = 0 := by
    change Matrix.det (fun i j => q9SeedGenerator i (es j)) = 0
    rw [hmatrix]
    exact hdetCircuit
  rw [q9AxisRepairHypergraph]
  apply mem_repairHypergraph_of_columns_dependent hsub hc (by
    have hd : 4 ≤ dualDist q9InnerCode := by rw [q9InnerCode_dualDist]
    simpa only [q9InnerCode] using hd)
  intro hli
  have hliA : LinearIndependent GF9 A.col := by
    have hcomp := hli.comp es es.injective
    have heq : ((fun j : ↥(insert q9Axis R) => q9SeedGenerator.col j) ∘ es) = A.col := by
      funext j
      ext i
      simp [A, Matrix.col]
    simpa only [heq] using hcomp
  have hunitA : IsUnit A := Matrix.linearIndependent_cols_iff_isUnit.mp hliA
  have hunit : IsUnit A.det := A.isUnit_iff_isUnit_det.mp hunitA
  exact hunit.ne_zero hdetA

/-- Exact characterization of the q=9 axis repair hypergraph: its edges are precisely the
three-element non-axis sets whose (necessarily distinct) field parameters sum to zero. -/
theorem q9AxisRepair_edge_iff_zeroSum {R : Finset (Fin 10)} :
    R ∈ q9AxisRepairHypergraph ↔
      R ⊆ univ.erase q9Axis ∧
        ∃ e : Fin 3 ≃ R, Function.Injective (fun i => q9IndexParam (e i)) ∧
          q9IndexParam (e 0) + q9IndexParam (e 1) + q9IndexParam (e 2) = 0 := by
  constructor
  · intro hR
    exact ⟨(mem_repairHypergraph.mp hR).1, q9AxisRepair_edge_zeroSum hR⟩
  · rintro ⟨hsub, e, -, hsum⟩
    have hc : R.card = 3 := by
      simpa only [Fintype.card_fin, Fintype.card_coe] using (Fintype.card_congr e).symm
    exact q9AxisRepair_edge_of_zeroSum hsub hc e hsum

/-- The seed encoder (right multiplication by the generator matrix) is injective. -/
theorem q9SeedEncoder_injective : Function.Injective q9SeedGenerator.vecMulLinear := by
  simpa only [Matrix.coe_vecMulLinear] using
    (Matrix.vecMul_injective_iff.mpr q9SeedGenerator_rows_linearIndependent)

/-- The actual seed encoder as an equivalence from message space `𝔽₉⁴` onto `C₀`. -/
noncomputable def q9SeedEncoder : (Fin 4 → GF9) ≃ₗ[GF9] q9InnerCode :=
  (LinearEquiv.ofInjective q9SeedGenerator.vecMulLinear q9SeedEncoder_injective).trans
    (LinearEquiv.ofEq (LinearMap.range q9SeedGenerator.vecMulLinear) q9InnerCode (by
      change LinearMap.range q9SeedGenerator.vecMulLinear =
        Submodule.span GF9 (Set.range q9SeedGenerator.row)
      exact range_vecMulLinear q9SeedGenerator))

/-- The concrete inner code has dimension four.  Together with its ten-coordinate ambient space,
this pins the `[10,4]` part of the intended `[10,4,6]₉` parameters without computation. -/
theorem q9InnerCode_finrank : Module.finrank GF9 q9InnerCode = 4 := by
  have h := LinearEquiv.finrank_eq q9SeedEncoder
  rw [Module.finrank_pi, Fintype.card_fin] at h
  omega

/-- Coefficient vector of `T³-T`; its hyperplane contains the three finite points
`t=0,1,-1` and the axis point `e₂`. -/
def q9DistanceForm : Fin 4 → GF9 := ![0, -1, 0, 1]

theorem q9DistanceForm_ne_zero : q9DistanceForm ≠ 0 := by
  intro h
  have hi : (1 : GF9) = 0 := by
    calc
      1 = q9DistanceForm (3 : Fin 4) := rfl
      _ = 0 := congrFun h (3 : Fin 4)
  exact one_ne_zero hi

theorem q9DistanceForm_pointEval_ne_zero : pointEval q9SeedColumn q9DistanceForm ≠ 0 := by
  intro h
  have henc : q9SeedGenerator.vecMulLinear q9DistanceForm = 0 := by
    rw [← q9PointEval_eq_encoder]
    exact h
  apply q9DistanceForm_ne_zero
  apply q9SeedEncoder_injective
  simpa using henc

/-- The `T³-T` hyperplane attains the maximum four-point section. -/
theorem q9DistanceForm_sectionCount : sectionCount q9SeedColumn q9DistanceForm = 4 := by
  have hsub : q9DualWitnessSupport ⊆
      (univ.filter fun j => q9SeedColumn j ⬝ᵥ q9DistanceForm = 0) := by
    intro j hj
    simp only [q9DualWitnessSupport, Finset.mem_insert, Finset.mem_singleton] at hj
    rcases hj with h | h | h | h
    · subst j
      simp [q9DistanceForm, dotProduct, momentCurve, Fin.sum_univ_four]
    · subst j
      simp [q9DistanceForm, dotProduct, momentCurve, Fin.sum_univ_four]
    · subst j
      simp [q9DistanceForm, dotProduct, momentCurve, Fin.sum_univ_four]
      ring
    · subst j
      norm_num [q9SeedColumn, q9Axis, q9DistanceForm, dotProduct, Fin.sum_univ_four]
      rfl
  have hlo : 4 ≤ sectionCount q9SeedColumn q9DistanceForm := by
    calc
      4 = q9DualWitnessSupport.card := q9DualWitnessSupport_card.symm
      _ ≤ (univ.filter fun j => q9SeedColumn j ⬝ᵥ q9DistanceForm = 0).card :=
        Finset.card_le_card hsub
      _ = sectionCount q9SeedColumn q9DistanceForm := rfl
  have hhi := q9Seed_sectionCount_le q9DistanceForm q9DistanceForm_ne_zero
  omega

/-- **Exact primal distance of the q=9 inner seed:** `d(C₀)=6`.  The maximum hyperplane section
has four of the ten generator points, so the projective-system distance bridge gives `10-4=6`. -/
theorem q9InnerCode_minDist : minDist q9InnerCode = 6 := by
  rw [q9InnerCode_eq_columnCode]
  have hsec : ∀ a, pointEval q9SeedColumn a ≠ 0 → sectionCount q9SeedColumn a ≤ 4 := by
    intro a ha
    apply q9Seed_sectionCount_le a
    intro ha0
    apply ha
    subst a
    funext j
    simp [pointEval]
  have h := columnCode_minDist_eq q9DistanceForm_pointEval_ne_zero
    q9DistanceForm_sectionCount hsec
  norm_num at h ⊢
  exact h

/-- The concrete seed has the advertised `[10,4,6]₉` parameters and dual distance four. -/
theorem q9InnerCode_parameters :
    Module.finrank GF9 q9InnerCode = 4 ∧ minDist q9InnerCode = 6 ∧
      dualDist q9InnerCode = 4 :=
  ⟨q9InnerCode_finrank, q9InnerCode_minDist, q9InnerCode_dualDist⟩

/-- The bounded-weight transfer lemma instantiated with the actual `𝔽₉` inner seed and its
encoder.  Coefficient faithfulness is no longer a hypothesis: the only structural input is the
outer-dual alternative for the vector of canonical block functionals. -/
theorem q9Inner_transfer {ι : Type*} [Fintype ι]
    (w : ι → (Fin 10 → GF9)) (dO s : ℕ)
    (houter : (∀ j, blockFunctional q9InnerCode q9SeedEncoder (w j) = 0) ∨
      dO ≤ (univ.filter (fun j => blockFunctional q9InnerCode q9SeedEncoder (w j) ≠ 0)).card)
    (htot : (∑ j, hammingNorm (w j)) ≤ s)
    (hsO : s < dO) (hsI : s < 2 * dualDist q9InnerCode) :
    (∀ j, w j ∈ dualCode q9InnerCode) ∧
      (univ.filter (fun j => w j ≠ 0)).card ≤ 1 :=
  transfer_ofInnerCodeFunctional q9InnerCode q9SeedEncoder w dO s houter htot hsO hsI

/-- Radius-four transfer for the actual q=9 inner code with the intended outer dual-distance
gate `d(O⊥) ≥ 5`. Both numeric inequalities are discharged (`4 < 5`, `4 < 2·4`); only the
outer-dual decomposition and the word's weight budget remain hypotheses. -/
theorem q9Inner_transfer_radiusFour {ι : Type*} [Fintype ι]
    (w : ι → (Fin 10 → GF9))
    (houter : (∀ j, blockFunctional q9InnerCode q9SeedEncoder (w j) = 0) ∨
      5 ≤ (univ.filter (fun j => blockFunctional q9InnerCode q9SeedEncoder (w j) ≠ 0)).card)
    (htot : (∑ j, hammingNorm (w j)) ≤ 4) :
    (∀ j, w j ∈ dualCode q9InnerCode) ∧
      (univ.filter (fun j => w j ≠ 0)).card ≤ 1 := by
  apply q9Inner_transfer w 5 4 houter htot (by decide)
  rw [q9InnerCode_dualDist]
  decide

/-- **Concrete q=9 transfer from an outer code.** If `w` annihilates the ordinary concatenation
of an outer `𝔽₉`-linear code `O ≤ (ι → 𝔽₉⁴)` through `q9SeedEncoder`, and the coordinate-free
functional dual of `O` has distance at least five, then every radius-four dual word is confined
to one inner block. The outer-dual alternative is proved internally by
`blockFunctional_outerAlternative`; no trace decomposition or imported axiom remains. -/
theorem q9Inner_transfer_ofOuterCode {ι : Type*} [Fintype ι]
    (O : Submodule GF9 (ι → (Fin 4 → GF9)))
    (w : ι → (Fin 10 → GF9))
    (horth : IsOrthogonalToConcatenation q9InnerCode q9SeedEncoder O w)
    (hdist : HasFunctionalDualDistanceAtLeast O 5)
    (htot : (∑ j, hammingNorm (w j)) ≤ 4) :
    (∀ j, w j ∈ dualCode q9InnerCode) ∧
      (univ.filter (fun j => w j ≠ 0)).card ≤ 1 := by
  classical
  have halt := blockFunctional_outerAlternative q9InnerCode q9SeedEncoder O w 5 horth hdist
  apply q9Inner_transfer_radiusFour w
  · rcases halt with hz | hw
    · exact Or.inl hz
    · exact Or.inr (by simpa only [functionalWeight] using hw)
  · exact htot

/-- Toy two-block consistency witness for `ConcatDualWord`: block `0` is a
nonzero weight-`4` inner-dual word, block `1` is zero. Here
`innerDual b := b = 0 ∨ 4 ≤ b` stands in for "`b` is `0` or has weight `≥ d(I⊥)`",
`dI = 4`, `dO = 5`, budget `s = 4`. Both `4 < 5` and `4 < 8` hold. -/
def q9SeedToy : ConcatDualWord (Fin 2) ℕ ℕ where
  w := ![4, 0]
  beta := fun _ => 0
  blockWt := id
  innerDual := fun b => b = 0 ∨ 4 ≤ b
  dI := 4
  dO := 5
  s := 4
  innerDual_zero := Or.inl rfl
  blockWt_eq_zero := fun _ => Iff.rfl
  hbeta := by intro j; fin_cases j <;> simp
  houter := Or.inl (fun _ => rfl)
  hdist := by intro b hb hb0; show 4 ≤ b; rcases hb with h | h <;> omega
  htot := by decide
  hsO := by decide

/-- The interface is inhabited and the transfer conclusion is nontrivial: the
witness has every block inner-dual and exactly one nonzero block (card `= 1`). -/
example :
    (∀ j, q9SeedToy.innerDual (q9SeedToy.w j)) ∧
      (univ.filter (fun j => q9SeedToy.w j ≠ 0)).card ≤ 1 :=
  transfer_lemma q9SeedToy (by decide)

end
end RepairCodes
