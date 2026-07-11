import Mathlib.LinearAlgebra.Vandermonde
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic
import Mathlib.LinearAlgebra.FiniteDimensional.Lemmas

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

end FiniteGeom
