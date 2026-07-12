import Mathlib.LinearAlgebra.Vandermonde
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic
import Mathlib.LinearAlgebra.FiniteDimensional.Lemmas
import FiniteGeom.EvalCode

/-!
# The moment curve / normal rational curve: general position via Vandermonde (`FiniteGeom`)

The self-contained algebraic core of the `q = 3^h` uniform distance theorem
([`notes/2026-07-11-codex-coding-mds-cross-field-sweep.md`](../notes) §1.5.1,
`C(S_q) = [2q+1, 4, q-1]_q`) and, more broadly, of the NRC/twisted-cubic lane of `RepairCodes`.

The generator system of that family has as columns the `q` finite twisted-cubic points
`(1, t, t², t³)` together with the axis line. The distance argument turns on two facts about the
cubic: it spans `𝔽_q^4` (so the code has dimension `4`) and **no four of its points are coplanar**
— equivalently any `4` distinct-parameter points are linearly independent. Both are the same
Vandermonde statement, proved here in full generality for the `n`-dimensional **moment curve**
`t ↦ (1, t, …, t^{n-1})` (the affine normal rational curve of `PG(n-1, q)`):

* `momentCurve_linearIndependent` — `n` points at distinct parameters are linearly independent;
* `twistedCubic_linearIndependent` — the `n = 4` specialization used by the `q = 3^h` family;
* `twistedCubic_span` — four distinct-parameter twisted-cubic points span `𝔽^4`.

The matrix of the `n` points *is* `Matrix.vandermonde v`, whose determinant `∏_{i<j}(v j - v i)`
is nonzero exactly when `v` is injective (`Matrix.det_vandermonde_ne_zero_iff`). Plan §5 decision 3
lists this "Vandermonde independence" as an elementary *prove-don't-import* input; no imported
content enters. `#print axioms`-clean.
-/

namespace FiniteGeom

open Matrix

variable {n : ℕ} {𝔽 : Type*} [Field 𝔽]

/-- The `n`-dimensional **moment-curve** point at parameter `t`: `(1, t, t², …, t^{n-1})`. For
`n = 4` this is the twisted cubic `(1, t, t², t³)`; its image over a finite field is the affine
normal rational curve of `PG(n-1, q)`. This is definitionally the `i`-th row of the Vandermonde
matrix at `v i = t`. -/
def momentCurve (n : ℕ) (t : 𝔽) : Fin n → 𝔽 := fun j => t ^ (j : ℕ)

@[simp] theorem momentCurve_apply (n : ℕ) (t : 𝔽) (j : Fin n) :
    momentCurve n t j = t ^ (j : ℕ) := rfl

/-- **General position of the moment curve (Vandermonde).** Any `n` moment-curve points at
*distinct* parameters `v : Fin n → 𝔽` are linearly independent — the projective reading being
that no hyperplane of `PG(n-1, q)` meets the normal rational curve in more than `n-1` points. The
`n × n` matrix of the points is exactly `Matrix.vandermonde v`; its determinant
`∏_{i<j}(v j - v i)` is nonzero iff `v` is injective, and a square matrix over a field with nonzero
determinant has independent rows. -/
theorem momentCurve_linearIndependent {v : Fin n → 𝔽} (hv : Function.Injective v) :
    LinearIndependent 𝔽 (fun i : Fin n => momentCurve n (v i)) := by
  have hdet : (vandermonde v).det ≠ 0 := det_vandermonde_ne_zero_iff.mpr hv
  -- rows of `vandermonde v` are definitionally the moment-curve points at the `v i`.
  exact linearIndependent_rows_of_det_ne_zero hdet

/-- **General-position form for a smaller family.** Any finite family of distinct moment-curve
points in `𝔽ⁿ` is linearly independent when its cardinality is at most `n`.

Reindex the family by `Fin (card ι)` and project `𝔽ⁿ` to its first `card ι` coordinates. The
projected points form a square Vandermonde family, so they are independent by
`momentCurve_linearIndependent`; independence of the images implies independence upstairs. -/
theorem momentCurve_linearIndependent_of_card_le {ι : Type*} [Fintype ι]
    {v : ι → 𝔽} (hv : Function.Injective v) (hcard : Fintype.card ι ≤ n) :
    LinearIndependent 𝔽 (fun i => momentCurve n (v i)) := by
  classical
  let e : ι ≃ Fin (Fintype.card ι) := Fintype.equivFin ι
  let inc : Fin (Fintype.card ι) → Fin n := Fin.castLE hcard
  let restrict : (Fin n → 𝔽) →ₗ[𝔽] (Fin (Fintype.card ι) → 𝔽) :=
    LinearMap.funLeft 𝔽 𝔽 inc
  have hv' : Function.Injective (fun j : Fin (Fintype.card ι) => v (e.symm j)) :=
    hv.comp e.symm.injective
  have hsmall : LinearIndependent 𝔽
      (fun j : Fin (Fintype.card ι) => momentCurve (Fintype.card ι) (v (e.symm j))) :=
    momentCurve_linearIndependent hv'
  have hrestricted : LinearIndependent 𝔽
      (fun j : Fin (Fintype.card ι) => restrict (momentCurve n (v (e.symm j)))) := by
    have heq : (fun j : Fin (Fintype.card ι) => restrict (momentCurve n (v (e.symm j)))) =
        (fun j : Fin (Fintype.card ι) => momentCurve (Fintype.card ι) (v (e.symm j))) := by
      funext j i
      rfl
    rw [heq]
    exact hsmall
  have hreindexed : LinearIndependent 𝔽
      (fun j : Fin (Fintype.card ι) => momentCurve n (v (e.symm j))) :=
    LinearIndependent.of_comp restrict hrestricted
  simpa [e, Function.comp_def] using hreindexed.comp e e.injective

/-- **Twisted cubic in general position** (`n = 4`): any four twisted-cubic points
`(1, tᵢ, tᵢ², tᵢ³)` at distinct parameters are linearly independent — no four are coplanar. This
is the dimension-`4` / "≤ 3 cubic points per plane" input of the `q = 3^h` distance theorem. -/
theorem twistedCubic_linearIndependent {v : Fin 4 → 𝔽} (hv : Function.Injective v) :
    LinearIndependent 𝔽 (fun i : Fin 4 => momentCurve 4 (v i)) :=
  momentCurve_linearIndependent hv

/-- Four twisted-cubic points at distinct parameters **span** `𝔽^4`: they are `4 = dim (Fin 4 → 𝔽)`
linearly independent vectors, hence a basis. This is why the `q = 3^h` code `C(S_q)` has
dimension exactly `4`. -/
theorem twistedCubic_span {v : Fin 4 → 𝔽} (hv : Function.Injective v) :
    Submodule.span 𝔽 (Set.range fun i : Fin 4 => momentCurve 4 (v i)) = ⊤ := by
  have hli := twistedCubic_linearIndependent hv
  have hcard : Fintype.card (Fin 4) = Module.finrank 𝔽 (Fin 4 → 𝔽) := by
    rw [Module.finrank_pi, Fintype.card_fin]
  have hb := (basisOfLinearIndependentOfCardEqFinrank hli hcard).span_eq
  rwa [coe_basisOfLinearIndependentOfCardEqFinrank] at hb

/-! ### Hyperplane sections of the moment curve

A hyperplane `a^⊥` (`a : 𝔽^n` nonzero, viewed as a linear form) meets the moment curve in at most
`n - 1` points: pairing `a` with `momentCurve n t` is the evaluation at `t` of the coefficient
polynomial `∑ⱼ aⱼ Xʲ` (degree `< n`, nonzero when `a ≠ 0`), which has at most `n - 1` roots. For
`n = 4` this is the sharp "a plane meets the twisted cubic in `≤ 3` points" bound — the `T_q` half
of the `q = 3^h` max-section computation (`sectionCount` of the cubic block). Reuses
`FiniteGeom.card_eval_zero_le_natDegree`. -/

open Polynomial Matrix Finset

/-- The coefficient polynomial `∑ⱼ aⱼ Xʲ` of a linear form `a : 𝔽^n`. Pairing `a` with a
moment-curve point is evaluating this polynomial (`formPoly_eval`). -/
noncomputable def formPoly (a : Fin n → 𝔽) : 𝔽[X] := ∑ j : Fin n, C (a j) * X ^ (j : ℕ)

theorem formPoly_eval (a : Fin n → 𝔽) (t : 𝔽) :
    (formPoly a).eval t = momentCurve n t ⬝ᵥ a := by
  simp only [formPoly, dotProduct, momentCurve_apply, eval_finsetSum, eval_mul, eval_C, eval_pow,
    eval_X]
  exact Finset.sum_congr rfl fun j _ => mul_comm _ _

theorem formPoly_coeff (a : Fin n → 𝔽) (i : Fin n) : (formPoly a).coeff (i : ℕ) = a i := by
  simp only [formPoly, finsetSum_coeff, coeff_C_mul, coeff_X_pow]
  rw [Finset.sum_eq_single i]
  · rw [if_pos rfl, mul_one]
  · intro j _ hji; rw [if_neg (fun h => hji (Fin.ext h.symm)), mul_zero]
  · intro h; exact absurd (Finset.mem_univ i) h

theorem formPoly_ne_zero {a : Fin n → 𝔽} (ha : a ≠ 0) : formPoly a ≠ 0 := by
  intro h
  refine ha (funext fun i => ?_)
  rw [← formPoly_coeff a i, h, coeff_zero, Pi.zero_apply]

theorem formPoly_natDegree_le (a : Fin n → 𝔽) : (formPoly a).natDegree ≤ n - 1 := by
  unfold formPoly
  apply natDegree_sum_le_of_forall_le
  intro j _
  calc (C (a j) * X ^ (j : ℕ)).natDegree
      ≤ (X ^ (j : ℕ) : 𝔽[X]).natDegree := natDegree_C_mul_le _ _
    _ = (j : ℕ) := natDegree_X_pow _
    _ ≤ n - 1 := Nat.le_sub_one_of_lt j.isLt

/-- **Hyperplane section of the moment curve.** A nonzero linear form `a` vanishes on at most
`n - 1` moment-curve points among any set of distinct parameters `pts` — equivalently, no
hyperplane of `PG(n-1, q)` meets the normal rational curve in more than `n - 1` points. For
`n = 4`: any plane meets the twisted cubic in `≤ 3` points. -/
theorem momentCurve_section_le [DecidableEq 𝔽] {m : ℕ} {a : Fin n → 𝔽} (ha : a ≠ 0)
    {pts : Fin m → 𝔽} (hpts : Function.Injective pts) :
    #(Finset.univ.filter fun i => momentCurve n (pts i) ⬝ᵥ a = 0) ≤ n - 1 := by
  have hfilter : (Finset.univ.filter fun i => momentCurve n (pts i) ⬝ᵥ a = 0)
      = (Finset.univ.filter fun i => (formPoly a).eval (pts i) = 0) :=
    Finset.filter_congr fun i _ => by rw [formPoly_eval]
  rw [hfilter]
  exact le_trans (card_eval_zero_le_natDegree (formPoly_ne_zero ha) hpts) (formPoly_natDegree_le a)

end FiniteGeom
