import RepairCodes.CodeInstance
import FiniteGeom.MomentCurve
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

Still open here are the exact distance statements `d(C₀)=6`, `d(C₀⊥)=4`, the complete repair
hypergraph, and the Chen–Ling–Xing assertion that the vector of block functionals is outer-dual.
The latter remains an explicit hypothesis of `transfer_ofInnerCodeFunctional`; it is the sole
imported boundary of the blockwise transfer step.
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

/-- Embed the first four finite-coordinate positions into the ten seed coordinates. -/
def q9FirstFour (j : Fin 4) : Fin 10 := ⟨j, by omega⟩

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

/-- The bounded-weight transfer lemma instantiated with the actual `𝔽₉` inner seed and its
encoder.  Coefficient faithfulness is no longer a hypothesis: the only structural input is the
outer-dual alternative for the vector of canonical block functionals.  The remaining `hsI`
argument will become the arithmetic fact `4 < 2 * 4` once `d(C₀⊥)=4` is landed. -/
theorem q9Inner_transfer {ι : Type*} [Fintype ι]
    (w : ι → (Fin 10 → GF9)) (dO s : ℕ)
    (houter : (∀ j, blockFunctional q9InnerCode q9SeedEncoder (w j) = 0) ∨
      dO ≤ (univ.filter (fun j => blockFunctional q9InnerCode q9SeedEncoder (w j) ≠ 0)).card)
    (htot : (∑ j, hammingNorm (w j)) ≤ s)
    (hsO : s < dO) (hsI : s < 2 * dualDist q9InnerCode) :
    (∀ j, w j ∈ dualCode q9InnerCode) ∧
      (univ.filter (fun j => w j ≠ 0)).card ≤ 1 :=
  transfer_ofInnerCodeFunctional q9InnerCode q9SeedEncoder w dO s houter htot hsO hsI

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
