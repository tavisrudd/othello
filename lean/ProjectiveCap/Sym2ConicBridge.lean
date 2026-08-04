import ProjectiveCap.PlaneTransitivity
import ProjectiveCap.FiniteBuildGame
import Mathlib.LinearAlgebra.Matrix.ToLinearEquiv
import Mathlib.Tactic

/-!
# The Veronese conic and the symmetric-square collineation

Let `K` be a field, `Line K = Fin 2 → K`, and `Plane K = Fin 3 → K`, with
projective points `Projectivization K (Line K)` and `Projectivization K (Plane K)`.

This module builds the degree-two Veronese parametrization of a conic in the
projective plane and shows that it is equivariant for the action of `GL(2, K)`
on the line and the action of its symmetric square on the plane. Concretely,
identifying plane coordinates with the quadratic monomials
`(X, Y, Z) = (u², uv, v²)`:

* `veronese (u, v) = (u², uv, v²)`, the Veronese map `Line K → Plane K`, and its
  projectivization `veronesePoint`, which is injective and lands on the conic;
* `conicForm (X, Y, Z) = Y² − XZ`, whose zero locus `OnConic` is that conic;
* `sym2Mat M`, the `3 × 3` symmetric-square matrix of a `2 × 2` matrix `M`, and
  the induced maps `sym2Equiv hM`, `lineEquiv hM`, and the plane collineation
  `sym2Collineation hM`, defined when `IsUnit M.det`.

Three polynomial identities carry the module, and being identities they hold in
every characteristic:

* `sym2Mat_mulVec_veronese`: `sym2Mat M *ᵥ veronese v = veronese (M *ᵥ v)`;
* `conicForm_sym2Mat_mulVec`: `conicForm (sym2Mat M *ᵥ w) = (M.det)² * conicForm w`,
  so `conicForm` is a relative invariant with multiplier `(det M)²` and the conic
  `{conicForm = 0}` is preserved exactly;
* `sym2Mat_det`: `(sym2Mat M).det = (M.det)³`, so `sym2Mat M` is invertible
  whenever `M` is.

In characteristic two the conic itself is degenerate — its tangent lines are
concurrent — but that does not enter here: `sym2Mat M` is still invertible and
still fixes the zero locus, which is all the statements below use.

The terminal geometric statement is `sym2Collineation_veronesePoint`, the
realization of the Möbius action: the collineation moves the point with conic
parameter `p` to the point with parameter `lineEquiv hM p`. Its consequence
`sym2Collineation_image_veronesePoint` transfers a whole on-conic cap.

Nothing here refers to a game. The transport of cap-game values along
`sym2Collineation` is in `ProjectiveCap.Sym2ConicBridgeGame`.
-/

open scoped LinearAlgebra.Projectivization
open scoped Matrix
open Projectivization

namespace ProjectiveCap
namespace Sym2Bridge

variable {K : Type*} [Field K]

/-- Representative space of the projective line `PG(1,K)`. -/
abbrev Line (K : Type*) := Fin 2 → K

/-- Representative space of the projective plane `PG(2,K)`. -/
abbrev Plane (K : Type*) := Fin 3 → K

/-! ## The Veronese map and the conic form -/

/-- The degree-two Veronese map `(u, v) ↦ (u², uv, v²)`. -/
def veronese (v : Line K) : Plane K :=
  ![v 0 ^ 2, v 0 * v 1, v 1 ^ 2]

/-- The conic form `Y² − XZ` whose zero locus is the Veronese conic. -/
def conicForm (w : Plane K) : K :=
  w 1 ^ 2 - w 0 * w 2

/-- The Veronese image of any line vector satisfies the conic equation: with
`(X, Y, Z) = (u², uv, v²)` one has `Y² - XZ = 0`. This is a polynomial identity, so
it holds in every characteristic. -/
@[simp] theorem conicForm_veronese (v : Line K) : conicForm (veronese v) = 0 := by
  simp only [conicForm, veronese, Matrix.cons_val_zero, Matrix.cons_val_one,
    Matrix.cons_val_two, Matrix.head_cons, Matrix.tail_cons]
  ring

/-- The Veronese map is homogeneous of degree two: `veronese (c • v) = c² • veronese v`.
This is what makes `veronesePoint` well defined on projective points. -/
theorem veronese_smul (c : K) (v : Line K) :
    veronese (c • v) = c ^ 2 • veronese v := by
  funext i
  fin_cases i <;> simp [veronese, Pi.smul_apply, mul_pow]
  all_goals ring

/-- The Veronese image of a nonzero vector is nonzero (uses that `K` has no zero
divisors). -/
theorem veronese_ne_zero {v : Line K} (hv : v ≠ 0) : veronese v ≠ 0 := by
  intro h
  have h0 : veronese v 0 = 0 := by rw [h]; rfl
  have h2 : veronese v 2 = 0 := by rw [h]; rfl
  simp only [veronese, Matrix.cons_val_zero, Matrix.head_cons,
    Matrix.cons_val_two, Matrix.tail_cons] at h0 h2
  have hv0 : v 0 = 0 := by
    have := (pow_eq_zero_iff (n := 2) (by norm_num)).mp h0
    simpa using this
  have hv1 : v 1 = 0 := by
    have := (pow_eq_zero_iff (n := 2) (by norm_num)).mp h2
    simpa using this
  apply hv
  funext i
  fin_cases i
  · exact hv0
  · exact hv1

/-! ## The symmetric-square matrix -/

/-- The symmetric square of a `2×2` matrix `M`, acting on quadratic coordinates.
With `M = !![a, b; c, d]` this is the classical
`!![a², 2ab, b²; ac, ad+bc, bd; c², 2cd, d²]`. -/
def sym2Mat (M : Matrix (Fin 2) (Fin 2) K) : Matrix (Fin 3) (Fin 3) K :=
  !![M 0 0 ^ 2,        2 * (M 0 0 * M 0 1),               M 0 1 ^ 2;
     M 0 0 * M 1 0,    M 0 0 * M 1 1 + M 0 1 * M 1 0,     M 0 1 * M 1 1;
     M 1 0 ^ 2,        2 * (M 1 0 * M 1 1),               M 1 1 ^ 2]

/-- Equivariance: the symmetric square intertwines `M` and the Veronese map. -/
theorem sym2Mat_mulVec_veronese (M : Matrix (Fin 2) (Fin 2) K) (v : Line K) :
    sym2Mat M *ᵥ veronese v = veronese (M *ᵥ v) := by
  funext i
  fin_cases i <;>
    simp [sym2Mat, veronese, Matrix.mulVec, dotProduct, Fin.sum_univ_two,
      Fin.sum_univ_three] <;>
    ring

/-- The conic form is a relative invariant of the symmetric square, with
multiplier `(det M)²`.  Hence the conic `{conicForm = 0}` is preserved exactly. -/
theorem conicForm_sym2Mat_mulVec (M : Matrix (Fin 2) (Fin 2) K) (w : Plane K) :
    conicForm (sym2Mat M *ᵥ w) = M.det ^ 2 * conicForm w := by
  simp only [conicForm, Matrix.det_fin_two]
  simp [sym2Mat, Matrix.mulVec, dotProduct, Fin.sum_univ_three]
  ring

/-- The determinant of the symmetric square is the cube of the determinant. -/
theorem sym2Mat_det (M : Matrix (Fin 2) (Fin 2) K) :
    (sym2Mat M).det = M.det ^ 3 := by
  rw [Matrix.det_fin_three, Matrix.det_fin_two]
  simp [sym2Mat]
  ring

/-- `sym2Mat M` is invertible whenever `M` is. -/
theorem isUnit_sym2Mat_det {M : Matrix (Fin 2) (Fin 2) K} (hM : IsUnit M.det) :
    IsUnit (sym2Mat M).det := by
  rw [sym2Mat_det]
  exact hM.pow 3

/-- The invertible-matrix instance for the symmetric square. -/
@[reducible] noncomputable def sym2Invertible {M : Matrix (Fin 2) (Fin 2) K}
    (hM : IsUnit M.det) : Invertible (sym2Mat M) :=
  Matrix.invertibleOfIsUnitDet _ (isUnit_sym2Mat_det hM)

/-! ## The induced plane collineation -/

/-- The plane linear automorphism `Sym²(M) : Plane ≃ₗ[K] Plane` induced by a line
transformation `M` with `IsUnit M.det`. -/
noncomputable def sym2Equiv {M : Matrix (Fin 2) (Fin 2) K} (hM : IsUnit M.det) :
    Plane K ≃ₗ[K] Plane K :=
  (sym2Mat M).toLinearEquiv' (sym2Invertible hM)

/-- The plane automorphism attached to an invertible `2 × 2` matrix `M` acts by
matrix-vector multiplication by the symmetric-square matrix of `M`. -/
theorem sym2Equiv_apply {M : Matrix (Fin 2) (Fin 2) K} (hM : IsUnit M.det)
    (w : Plane K) : sym2Equiv hM w = sym2Mat M *ᵥ w := by
  have h2 := LinearMap.congr_fun
    (Matrix.toLinearEquiv'_apply (sym2Mat M) (sym2Invertible hM)) w
  rw [Matrix.toLin'_apply] at h2
  exact h2

/-- The line linear automorphism induced by `M` with `IsUnit M.det`. -/
noncomputable def lineEquiv {M : Matrix (Fin 2) (Fin 2) K} (hM : IsUnit M.det) :
    Line K ≃ₗ[K] Line K :=
  M.toLinearEquiv' (Matrix.invertibleOfIsUnitDet _ hM)

/-- The line automorphism attached to an invertible `2 × 2` matrix `M` acts by
matrix-vector multiplication by `M`. -/
theorem lineEquiv_apply {M : Matrix (Fin 2) (Fin 2) K} (hM : IsUnit M.det)
    (v : Line K) : lineEquiv hM v = M *ᵥ v := by
  have h2 := LinearMap.congr_fun
    (Matrix.toLinearEquiv'_apply M (Matrix.invertibleOfIsUnitDet _ hM)) v
  rw [Matrix.toLin'_apply] at h2
  exact h2

/-- The plane collineation on projective points induced by `Sym²(M)`. -/
noncomputable def sym2Collineation {M : Matrix (Fin 2) (Fin 2) K} (hM : IsUnit M.det) :
    Projective.Point K (Plane K) ≃ Projective.Point K (Plane K) :=
  Projective.mapEquiv (sym2Equiv hM)

/-! ## Membership on the conic (projective level) -/

/-- A projective plane point lies on the Veronese conic. Well defined because
`conicForm (c • w) = c² · conicForm w`, so the vanishing is scale-invariant. -/
def OnConic (p : Projective.Point K (Plane K)) : Prop :=
  conicForm p.rep = 0

/-- The conic form `Y² - XZ` is homogeneous of degree two: rescaling a plane vector
by `c` multiplies its value by `c²`. This is why vanishing of the form depends only
on the projective point and not on the chosen representative. -/
theorem conicForm_smul (c : K) (w : Plane K) :
    conicForm (c • w) = c ^ 2 * conicForm w := by
  simp only [conicForm, Pi.smul_apply, smul_eq_mul]
  ring

/-- The Veronese point of a projective line point. -/
noncomputable def veronesePoint (p : Projective.Point K (Line K)) :
    Projective.Point K (Plane K) :=
  Projectivization.mk K (veronese p.rep) (veronese_ne_zero p.rep_nonzero)

/-- Conic membership is scale-invariant, so it can be read off any representative. -/
theorem onConic_mk (w : Plane K) (hw : w ≠ 0) :
    OnConic (Projectivization.mk K w hw) ↔ conicForm w = 0 := by
  unfold OnConic
  obtain ⟨c, hc⟩ := (Projectivization.mk_eq_mk_iff K _ _ _ _).mp
    (Projectivization.mk_rep (Projectivization.mk K w hw))
  -- hc : c • w = (mk K w hw).rep
  rw [← hc, Units.smul_def, conicForm_smul]
  constructor
  · intro h
    rcases mul_eq_zero.mp h with h2 | h2
    · exact absurd (pow_eq_zero_iff (by norm_num) |>.mp h2) (Units.ne_zero c)
    · exact h2
  · intro h; rw [h, mul_zero]

/-- The Veronese point map is well defined: it factors through the projective
class, sending `mk v` to `mk (veronese v)`. -/
theorem veronesePoint_mk (v : Line K) (hv : v ≠ 0) :
    veronesePoint (Projectivization.mk K v hv)
      = Projectivization.mk K (veronese v) (veronese_ne_zero hv) := by
  unfold veronesePoint
  obtain ⟨c, hc⟩ := (Projectivization.mk_eq_mk_iff K _ _ _ _).mp
    (Projectivization.mk_rep (Projectivization.mk K v hv))
  -- hc : c • v = (mk K v hv).rep
  apply (Projectivization.mk_eq_mk_iff K _ _ _ _).mpr
  refine ⟨c ^ 2, ?_⟩
  rw [← hc, Units.smul_def, Units.smul_def, veronese_smul, Units.val_pow_eq_pow_val]

/-- Every Veronese point lies on the conic: the image `[u² : uv : v²]` of a point of
the projective line satisfies `Y² - XZ = 0`. -/
theorem veronesePoint_onConic (p : Projective.Point K (Line K)) :
    OnConic (veronesePoint p) := by
  induction p using Projectivization.ind with
  | h v hv =>
    rw [veronesePoint_mk, onConic_mk]
    exact conicForm_veronese _

/-- The Veronese map is injective on projective points — `[u:v] ↦ [u²:uv:v²]` is a
(closed) embedding of the line into the plane.  Key algebraic fact: the three
component relations force `(v₀w₁ − v₁w₀)² = 0`, so the two representatives are
proportional. -/
theorem veronesePoint_injective :
    Function.Injective (veronesePoint (K := K)) := by
  intro p q hpq
  rw [veronesePoint, veronesePoint, Projectivization.mk_eq_mk_iff] at hpq
  obtain ⟨c, hc⟩ := hpq
  -- component relations `c • veronese q.rep = veronese p.rep`
  have e0 : (c : K) * q.rep 0 ^ 2 = p.rep 0 ^ 2 := by
    simpa [veronese, Units.smul_def] using congrFun hc 0
  have e1 : (c : K) * (q.rep 0 * q.rep 1) = p.rep 0 * p.rep 1 := by
    simpa [veronese, Units.smul_def] using congrFun hc 1
  have e2 : (c : K) * q.rep 1 ^ 2 = p.rep 1 ^ 2 := by
    simpa [veronese, Units.smul_def] using congrFun hc 2
  have hcross : (p.rep 0 * q.rep 1 - p.rep 1 * q.rep 0) ^ 2 = 0 := by
    linear_combination (-q.rep 1 ^ 2) * e0 +
      (2 * (q.rep 0 * q.rep 1)) * e1 - q.rep 0 ^ 2 * e2
  have hcross0 : p.rep 0 * q.rep 1 - p.rep 1 * q.rep 0 = 0 :=
    pow_eq_zero_iff (n := 2) (by norm_num) |>.mp hcross
  -- proportional representatives give the same projective point
  have hpq' : Projectivization.mk K p.rep p.rep_nonzero
      = Projectivization.mk K q.rep q.rep_nonzero := by
    by_cases hw0 : q.rep 0 = 0
    · have hw1 : q.rep 1 ≠ 0 := by
        intro h; exact q.rep_nonzero (by funext i; fin_cases i; exacts [hw0, h])
      have hv0 : p.rep 0 = 0 := by
        have hz : p.rep 0 * q.rep 1 = 0 := by
          have := hcross0; rw [hw0, mul_zero, sub_zero] at this; exact this
        exact (mul_eq_zero.mp hz).resolve_right hw1
      refine (Projectivization.mk_eq_mk_iff' K _ _ _ _).mpr ⟨p.rep 1 / q.rep 1, ?_⟩
      have h0 : p.rep 1 / q.rep 1 * q.rep 0 = p.rep 0 := by rw [hw0, hv0, mul_zero]
      have h1 : p.rep 1 / q.rep 1 * q.rep 1 = p.rep 1 := by field_simp
      funext i; fin_cases i
      exacts [h0, h1]
    · have hv0 : p.rep 0 ≠ 0 := by
        intro h
        refine hw0 ?_
        have hcw : (c : K) * q.rep 0 ^ 2 = 0 := by rw [e0, h]; ring
        exact pow_eq_zero_iff (n := 2) (by norm_num) |>.mp
          ((mul_eq_zero.mp hcw).resolve_left (Units.ne_zero c))
      refine (Projectivization.mk_eq_mk_iff' K _ _ _ _).mpr ⟨p.rep 0 / q.rep 0, ?_⟩
      have h0 : p.rep 0 / q.rep 0 * q.rep 0 = p.rep 0 := by field_simp
      have h1 : p.rep 0 / q.rep 0 * q.rep 1 = p.rep 1 := by
        field_simp
        linear_combination hcross0
      funext i; fin_cases i
      exacts [h0, h1]
  exact (Projectivization.mk_rep p).symm.trans (hpq'.trans (Projectivization.mk_rep q))

/-- `veronesePoint` as an embedding of the projective line into the plane. -/
noncomputable def veronesePointEmb :
    Projective.Point K (Line K) ↪ Projective.Point K (Plane K) :=
  ⟨veronesePoint, veronesePoint_injective⟩

/-- The embedding of the projective line into the projective plane agrees with the
Veronese point map on every point. -/
@[simp] theorem veronesePointEmb_apply (p : Projective.Point K (Line K)) :
    veronesePointEmb p = veronesePoint p := rfl

/-! ## Möbius realization and conic preservation (projective level) -/

/-- **Realizes the Möbius action.** On the Veronese image, the Sym² collineation
is the Veronese of the induced line transformation — i.e. it acts on conic
parameters exactly as `M` acts on `P¹`. -/
theorem sym2Collineation_veronesePoint {M : Matrix (Fin 2) (Fin 2) K}
    (hM : IsUnit M.det) (p : Projective.Point K (Line K)) :
    sym2Collineation hM (veronesePoint p)
      = veronesePoint (Projective.mapEquiv (lineEquiv hM) p) := by
  induction p using Projectivization.ind with
  | h v hv =>
    rw [veronesePoint_mk, Projective.mapEquiv_mk, veronesePoint_mk]
    unfold sym2Collineation
    rw [Projective.mapEquiv_mk]
    -- both sides are `mk` of `veronese (M *ᵥ v)`
    apply (Projectivization.mk_eq_mk_iff' K _ _ _ _).mpr
    refine ⟨1, ?_⟩
    rw [one_smul, sym2Equiv_apply, sym2Mat_mulVec_veronese, lineEquiv_apply]

/-- **Sends the conic to itself.** The Sym² collineation preserves conic
membership in both directions. -/
theorem onConic_sym2Collineation {M : Matrix (Fin 2) (Fin 2) K} (hM : IsUnit M.det)
    (p : Projective.Point K (Plane K)) :
    OnConic (sym2Collineation hM p) ↔ OnConic p := by
  induction p using Projectivization.ind with
  | h v hv =>
    unfold sym2Collineation
    rw [Projective.mapEquiv_mk, onConic_mk, sym2Equiv_apply, conicForm_sym2Mat_mulVec,
      onConic_mk]
    constructor
    · intro h
      rcases mul_eq_zero.mp h with h2 | h2
      · exact absurd ((pow_eq_zero_iff (by norm_num)).mp h2) hM.ne_zero
      · exact h2
    · intro h; rw [h, mul_zero]

variable [Fintype (Projective.Point K (Plane K))]
  [DecidableEq (Projective.Point K (Plane K))]

/-! ## Compatibility of the collineation with the Veronese parametrization

The lemma below is the geometry that makes a full-`PGL(2, K)` line map act on
on-conic caps through its conic parameters: pushing the on-conic cap of a
parameter set through the symmetric-square collineation gives exactly the
on-conic cap of the Möbius-transformed parameter set. -/

variable [DecidableEq (Projective.Point K (Line K))]

omit [Fintype (Projective.Point K (Plane K))] in
/-- The on-conic cap of a parameter set, pushed through the Sym² collineation, is
exactly the on-conic cap of the Möbius-transformed parameter set: the geometry
that makes the transport respect the Veronese conic. -/
theorem sym2Collineation_image_veronesePoint {M : Matrix (Fin 2) (Fin 2) K}
    (hM : IsUnit M.det) (σ : Finset (Projective.Point K (Line K))) :
    (σ.image veronesePoint).map (sym2Collineation hM).toEmbedding =
      (σ.image (Projective.mapEquiv (lineEquiv hM))).image veronesePoint := by
  rw [Finset.map_eq_image, Finset.image_image, Finset.image_image]
  refine Finset.image_congr ?_
  intro p _
  simp only [Function.comp_apply, Equiv.coe_toEmbedding]
  exact sym2Collineation_veronesePoint hM p

omit [Fintype (Projective.Point K (Plane K))]
  [DecidableEq (Projective.Point K (Line K))] in
/-- The Veronese image of a finite set of conic parameters has exactly one point per
parameter: since the Veronese point map is injective, a parameter set of size `k`
yields a set of `k` distinct points on the conic. -/
theorem card_image_veronesePoint (σ : Finset (Projective.Point K (Line K))) :
    (σ.image veronesePoint).card = σ.card :=
  Finset.card_image_of_injective σ veronesePoint_injective

end Sym2Bridge
end ProjectiveCap
