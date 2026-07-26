import RelativeConicArcs.EqualityConsequences
import RelativeConicArcs.KleinFourOrbitCongruence
import Mathlib.Algebra.CharP.Two

/-!
# Secant involutions of the standard conic

Let the standard conic in the projective plane over a field `K` be the Veronese image
`[u:v] ↦ [u²:uv:v²]`.  A plane vector `p = (a,b,c)` determines the matrix

`!![b, a; c, b]`.

Its determinant is the conic form `b²-ac`.  Thus a projective point outside the conic determines
an automorphism of the parameter line.  In characteristic two its square is scalar, so the
induced projectivity is an involution.  The image of a conic parameter and the original parameter
lie on a chord through the defining plane point.

The construction includes the conic nucleus: its matrix is scalar and its projectivity is the
identity.  Consequently, statements requiring a nonidentity involution explicitly exclude the
nucleus.
-/

namespace RelativeConicArcs
namespace ConicSecantInvolution

open Conic
open scoped CharTwo LinearAlgebra.Projectivization Matrix

variable {K : Type*} [Field K]

/-- The trace-zero matrix associated with a plane vector `(a,b,c)`. -/
def matrix (p : PlaneSpace K) : Matrix (Fin 2) (Fin 2) K :=
  !![p 1, p 0; p 2, p 1]

/-- The determinant of the secant-involution matrix is the standard conic form. -/
@[simp] theorem matrix_det (p : PlaneSpace K) :
    (matrix p).det = ProjectiveCap.Sym2Bridge.conicForm p := by
  simp [matrix, Matrix.det_fin_two, ProjectiveCap.Sym2Bridge.conicForm, pow_two]

/-- In characteristic two, the square of the secant-involution matrix is its determinant times
the identity matrix. -/
theorem matrix_mul_self [CharP K 2] (p : PlaneSpace K) :
    matrix p * matrix p =
      (ProjectiveCap.Sym2Bridge.conicForm p) • (1 : Matrix (Fin 2) (Fin 2) K) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [matrix, Matrix.mul_apply, Fin.sum_univ_two,
      ProjectiveCap.Sym2Bridge.conicForm, CharTwo.sub_eq_add] <;>
    ring_nf
  all_goals simp

/-- A vector off the conic gives an invertible secant-involution matrix. -/
theorem matrix_det_isUnit {p : PlaneSpace K}
    (hp : ProjectiveCap.Sym2Bridge.conicForm p ≠ 0) :
    IsUnit (matrix p).det := by
  rw [matrix_det]
  exact isUnit_iff_ne_zero.mpr hp

variable [Fintype K] [DecidableEq K]

/-- The representative of a projective point outside the standard conic has nonzero conic form. -/
theorem conicForm_rep_ne_zero {P : Point K} (hP : P ∉ standardConic (K := K)) :
    ProjectiveCap.Sym2Bridge.conicForm P.rep ≠ 0 := by
  intro hzero
  apply hP
  rw [mem_standardConic_iff_onConic]
  exact hzero

/-- The projectivity of the conic parameter line induced by a point outside the standard conic. -/
noncomputable def equiv (P : Point K) (hP : P ∉ standardConic (K := K)) :
    LinePoint K ≃ LinePoint K :=
  ProjectiveCap.Projective.mapEquiv
    (ProjectiveCap.Sym2Bridge.lineEquiv
      (matrix_det_isUnit (conicForm_rep_ne_zero hP)))

/-- An invertible secant-involution matrix does not kill a nonzero parameter vector. -/
theorem matrix_mulVec_ne_zero (P : Point K) (hP : P ∉ standardConic (K := K))
    {v : LineSpace K} (hv : v ≠ 0) :
    matrix P.rep *ᵥ v ≠ 0 := by
  intro hzero
  have heq :
      ProjectiveCap.Sym2Bridge.lineEquiv
          (matrix_det_isUnit (conicForm_rep_ne_zero hP)) v = 0 := by
    rw [ProjectiveCap.Sym2Bridge.lineEquiv_apply]
    exact hzero
  apply hv
  apply (ProjectiveCap.Sym2Bridge.lineEquiv
    (matrix_det_isUnit (conicForm_rep_ne_zero hP))).injective
  simpa using heq

/-- On a representative vector, the secant projectivity is multiplication by its defining
trace-zero matrix. -/
theorem equiv_mk (P : Point K) (hP : P ∉ standardConic (K := K))
    (v : LineSpace K) (hv : v ≠ 0) :
    equiv P hP (Projectivization.mk K v hv) =
      Projectivization.mk K (matrix P.rep *ᵥ v)
        (matrix_mulVec_ne_zero P hP hv) := by
  unfold equiv
  rw [ProjectiveCap.Projective.mapEquiv_mk]
  apply (Projectivization.mk_eq_mk_iff' K _ _ _ _).mpr
  refine ⟨1, ?_⟩
  rw [one_smul, ProjectiveCap.Sym2Bridge.lineEquiv_apply]

omit [Fintype K] [DecidableEq K] in
/-- The defining point, a conic parameter, and its image under the secant projectivity are
collinear after applying the Veronese embedding. -/
theorem determinant_chord [CharP K 2] (p : PlaneSpace K) (v : LineSpace K) :
    Matrix.det ![p, ProjectiveCap.Sym2Bridge.veronese v,
      ProjectiveCap.Sym2Bridge.veronese (matrix p *ᵥ v)] = 0 := by
  rw [Matrix.det_fin_three]
  simp [matrix, ProjectiveCap.Sym2Bridge.veronese, Matrix.mulVec,
    dotProduct, Fin.sum_univ_two]
  ring_nf
  simp

omit [Fintype K] in
private theorem collinear_mk_of_det_eq_zero
    {p q r : PlaneSpace K} (hp : p ≠ 0) (hq : q ≠ 0) (hr : r ≠ 0)
    (hdet : Matrix.det ![p, q, r] = 0) :
    Collinear (L := Point K)
      (Projectivization.mk K p hp)
      (Projectivization.mk K q hq)
      (Projectivization.mk K r hr) := by
  rw [ProjectiveBridge.collinear_iff_projective_collinear,
    ProjectiveCap.Projective.collinear_iff_dependent]
  have hnli : ¬LinearIndependent K ![p, q, r] := by
    intro hli
    let M : Matrix (Fin 3) (Fin 3) K := ![p, q, r]
    have hliM : LinearIndependent K M.row := by
      simpa [M, Matrix.row] using hli
    have hunit : IsUnit M.det :=
      (Matrix.isUnit_iff_isUnit_det M).mp
        ((Matrix.linearIndependent_rows_iff_isUnit (A := M)).mp hliM)
    exact hunit.ne_zero (by simpa [M] using hdet)
  have hraw := Projectivization.Dependent.mk (K := K) (V := PlaneSpace K)
    ![p, q, r] (fun i => by fin_cases i <;> assumption) hnli
  convert hraw using 1
  ext i
  fin_cases i <;> rfl

/-- The defining projective point and the two conic points paired by its secant projectivity are
collinear. -/
theorem collinear_veronese_equiv [CharP K 2]
    (P : Point K) (hP : P ∉ standardConic (K := K))
    (t : LinePoint K) :
    Collinear (L := Point K) P
      (ProjectiveCap.Sym2Bridge.veronesePoint t)
      (ProjectiveCap.Sym2Bridge.veronesePoint (equiv P hP t)) := by
  induction t using Projectivization.ind with
  | h v hv =>
    rw [ProjectiveCap.Sym2Bridge.veronesePoint_mk, equiv_mk,
      ProjectiveCap.Sym2Bridge.veronesePoint_mk]
    have hcol := collinear_mk_of_det_eq_zero P.rep_nonzero
      (ProjectiveCap.Sym2Bridge.veronese_ne_zero hv)
      (ProjectiveCap.Sym2Bridge.veronese_ne_zero
        (matrix_mulVec_ne_zero P hP hv))
      (determinant_chord P.rep v)
    simpa only [Projectivization.mk_rep] using hcol

/-- In characteristic two, the secant projectivity associated with an off-conic point is an
involution of the conic parameter line. -/
theorem equiv_apply_apply [CharP K 2] (P : Point K)
    (hP : P ∉ standardConic (K := K)) (t : LinePoint K) :
    equiv P hP (equiv P hP t) = t := by
  induction t using Projectivization.ind with
  | h v hv =>
    rw [equiv_mk, equiv_mk]
    apply (Projectivization.mk_eq_mk_iff' K _ _ _ _).mpr
    refine ⟨Units.mk0
      (ProjectiveCap.Sym2Bridge.conicForm P.rep)
      (conicForm_rep_ne_zero hP), ?_⟩
    change ProjectiveCap.Sym2Bridge.conicForm P.rep • v =
      matrix P.rep *ᵥ (matrix P.rep *ᵥ v)
    calc
      ProjectiveCap.Sym2Bridge.conicForm P.rep • v =
          (ProjectiveCap.Sym2Bridge.conicForm P.rep •
            (1 : Matrix (Fin 2) (Fin 2) K)) *ᵥ v := by
        rw [Matrix.smul_mulVec, Matrix.one_mulVec]
      _ = (matrix P.rep * matrix P.rep) *ᵥ v := by
        rw [matrix_mul_self]
      _ = matrix P.rep *ᵥ (matrix P.rep *ᵥ v) :=
        (Matrix.mulVec_mulVec _ _ _).symm

end ConicSecantInvolution
end RelativeConicArcs
