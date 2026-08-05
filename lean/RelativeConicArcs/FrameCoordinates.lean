import Mathlib.LinearAlgebra.Determinant
import ProjectiveCap.PlaneTransitivity

/-!
# Coordinates of projective points in a chosen frame

Arguments about configurations in a projective plane are often carried out by choosing three
independent points as a coordinate triangle and reading every other point through its coordinates
in that frame.  This file supplies that dictionary for a three-dimensional vector space over a
field: the coordinates of a projective point are the coordinates of its chosen representative in
the basis determined by an independent triple, and three points are collinear exactly when the
three-by-three determinant of their coordinate rows vanishes.

Coordinates depend on the choice of representative, so they are determined only up to a nonzero
scalar; the determinant criterion is unaffected, since scaling a row scales the determinant.
-/

open scoped LinearAlgebra.Projectivization

namespace RelativeConicArcs
namespace FrameCoordinates

open Matrix Module Projectivization ProjectiveCap.Projective

variable {K V : Type*} [Field K] [AddCommGroup V] [Module K V]

/-- The basis attached to an independent triple in a three-dimensional space. -/
noncomputable def frameBasis (hrank : Module.finrank K V = 3)
    {u : Fin 3 → V} (hu : LinearIndependent K u) : Basis (Fin 3) K V :=
  basisOfLinearIndependentOfCardEqFinrank hu
    (show Fintype.card (Fin 3) = Module.finrank K V by simp [hrank])

theorem coe_frameBasis (hrank : Module.finrank K V = 3)
    {u : Fin 3 → V} (hu : LinearIndependent K u) :
    ⇑(frameBasis hrank hu) = u :=
  coe_basisOfLinearIndependentOfCardEqFinrank _ _

/-- The coordinates of a vector in the frame of an independent triple. -/
noncomputable def coordOf (hrank : Module.finrank K V = 3)
    {u : Fin 3 → V} (hu : LinearIndependent K u) (v : V) : Fin 3 → K :=
  (frameBasis hrank hu).repr v

/-- The coordinates of a projective point in the frame, read off its chosen representative. -/
noncomputable def coord (hrank : Module.finrank K V = 3)
    {u : Fin 3 → V} (hu : LinearIndependent K u) (p : Point K V) : Fin 3 → K :=
  coordOf hrank hu p.rep

/-- The frame coordinates recover the vector. -/
theorem coordOf_spec (hrank : Module.finrank K V = 3)
    {u : Fin 3 → V} (hu : LinearIndependent K u) (v : V) :
    coordOf hrank hu v 0 • u 0 + coordOf hrank hu v 1 • u 1 + coordOf hrank hu v 2 • u 2 = v := by
  have hrepr := (frameBasis hrank hu).sum_repr v
  rw [Fin.sum_univ_three, coe_frameBasis hrank hu] at hrepr
  exact hrepr

/-- Independence of a triple of vectors is the non-vanishing of the determinant of their frame
coordinates. -/
theorem linearIndependent_iff_det_ne_zero (hrank : Module.finrank K V = 3)
    {u : Fin 3 → V} (hu : LinearIndependent K u) (v : Fin 3 → V) :
    LinearIndependent K v ↔
      Matrix.det (Matrix.of ![coordOf hrank hu (v 0), coordOf hrank hu (v 1),
        coordOf hrank hu (v 2)]) ≠ 0 := by
  classical
  set b := frameBasis hrank hu with hb
  have hmat : b.toMatrix v =
      (Matrix.of ![coordOf hrank hu (v 0), coordOf hrank hu (v 1),
        coordOf hrank hu (v 2)])ᵀ := by
    ext i j
    fin_cases j <;>
      simp [Basis.toMatrix_apply, coordOf, hb, Matrix.transpose_apply]
  have hdet : b.det v =
      Matrix.det (Matrix.of ![coordOf hrank hu (v 0), coordOf hrank hu (v 1),
        coordOf hrank hu (v 2)]) := by
    rw [Basis.det_apply, hmat, Matrix.det_transpose]
  constructor
  · intro hli
    have hcard : Fintype.card (Fin 3) = Module.finrank K V := by simp [hrank]
    have hspan : Submodule.span K (Set.range v) = ⊤ := by
      have h := (basisOfLinearIndependentOfCardEqFinrank hli hcard).span_eq
      rwa [coe_basisOfLinearIndependentOfCardEqFinrank] at h
    have hunit : IsUnit (b.det v) := (Basis.is_basis_iff_det b).mp ⟨hli, hspan⟩
    rw [← hdet]
    exact hunit.ne_zero
  · intro hne
    rw [← hdet] at hne
    exact ((Basis.is_basis_iff_det b).mpr (isUnit_iff_ne_zero.mpr hne)).1

/-- Frame coordinates commute with scalar multiplication, entrywise. -/
theorem coordOf_smul_apply (hrank : Module.finrank K V = 3)
    {u : Fin 3 → V} (hu : LinearIndependent K u) (s : K) (v : V) (j : Fin 3) :
    coordOf hrank hu (s • v) j = s * coordOf hrank hu v j := by
  simp [coordOf, map_smul]

/-- Frame coordinates commute with addition, entrywise. -/
theorem coordOf_add_apply (hrank : Module.finrank K V = 3)
    {u : Fin 3 → V} (hu : LinearIndependent K u) (v w : V) (j : Fin 3) :
    coordOf hrank hu (v + w) j = coordOf hrank hu v j + coordOf hrank hu w j := by
  simp [coordOf, map_add]

/-- The frame coordinates of the frame vectors themselves are the standard unit vectors. -/
theorem coordOf_frame_apply (hrank : Module.finrank K V = 3)
    {u : Fin 3 → V} (hu : LinearIndependent K u) (i j : Fin 3) :
    coordOf hrank hu (u i) j = if i = j then 1 else 0 := by
  have hui : u i = frameBasis hrank hu i := (congrFun (coe_frameBasis hrank hu) i).symm
  unfold coordOf
  rw [hui, Basis.repr_self]
  exact Finsupp.single_apply

/-- A projective point has a nonzero coordinate in every frame: its representative is nonzero, and
a vector all of whose frame coordinates vanish is zero. -/
theorem exists_coord_ne_zero (hrank : Module.finrank K V = 3)
    {u : Fin 3 → V} (hu : LinearIndependent K u) (p : Point K V) :
    coord hrank hu p 0 ≠ 0 ∨ coord hrank hu p 1 ≠ 0 ∨ coord hrank hu p 2 ≠ 0 := by
  by_contra hall
  push_neg at hall
  obtain ⟨h0, h1, h2⟩ := hall
  have hrep := coordOf_spec hrank hu p.rep
  rw [show coordOf hrank hu p.rep = coord hrank hu p from rfl, h0, h1, h2] at hrep
  simp only [zero_smul, add_zero, zero_add] at hrep
  exact p.rep_nonzero hrep.symm

/-- Scaling the last row of a three-by-three coordinate matrix scales the determinant. -/
theorem det_smul_row_two (r0 r1 r2 : Fin 3 → K) (s : K) :
    Matrix.det (Matrix.of ![r0, r1, s • r2]) = s * Matrix.det (Matrix.of ![r0, r1, r2]) := by
  rw [Matrix.det_fin_three, Matrix.det_fin_three]
  simp only [Matrix.of_apply, Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two,
    Matrix.head_cons, Matrix.tail_cons, Pi.smul_apply, smul_eq_mul]
  ring

/-- Three projective points are collinear exactly when the determinant of their frame coordinate
rows vanishes. -/
theorem collinear_iff_det_eq_zero (hrank : Module.finrank K V = 3)
    {u : Fin 3 → V} (hu : LinearIndependent K u) (p q r : Point K V) :
    Collinear K V p q r ↔
      Matrix.det (Matrix.of ![coord hrank hu p, coord hrank hu q, coord hrank hu r]) = 0 := by
  classical
  rw [collinear_iff_dependent]
  constructor
  · intro hdep
    by_contra hne
    have hli : LinearIndependent K ![p.rep, q.rep, r.rep] := by
      rw [linearIndependent_iff_det_ne_zero hrank hu]
      simpa [coord] using hne
    exact (independent_iff_not_dependent.mp (independent_triple_iff.mpr hli)) hdep
  · intro hzero
    by_contra hnd
    have hindep : Independent ![p, q, r] := independent_iff_not_dependent.mpr hnd
    have hli := independent_triple_iff.mp hindep
    rw [linearIndependent_iff_det_ne_zero hrank hu] at hli
    exact hli (by simpa [coord] using hzero)

/-- The determinant criterion for collinearity with a point given by an explicit representative
vector: the third row may be taken to be the frame coordinates of that representative rather than
of the chosen representative of its projective class. -/
theorem collinear_mk_of_det_eq_zero (hrank : Module.finrank K V = 3)
    {u : Fin 3 → V} (hu : LinearIndependent K u) (p q : Point K V) {v : V} (hv : v ≠ 0)
    (hdet : Matrix.det
      (Matrix.of ![coord hrank hu p, coord hrank hu q, coordOf hrank hu v]) = 0) :
    Collinear K V p q (Projectivization.mk K v hv) := by
  set z := Projectivization.mk K v hv with hzdef
  have hmk : Projectivization.mk K v hv = Projectivization.mk K z.rep z.rep_nonzero := by
    rw [Projectivization.mk_rep]
  obtain ⟨a, ha⟩ := (Projectivization.mk_eq_mk_iff' K v z.rep hv z.rep_nonzero).mp hmk
  have hane : a ≠ 0 := by
    rintro rfl
    rw [zero_smul] at ha
    exact hv ha.symm
  have hrow : a • coord hrank hu z = coordOf hrank hu v := by
    funext j
    rw [Pi.smul_apply, smul_eq_mul]
    have h1 : coordOf hrank hu (a • z.rep) j = a * coordOf hrank hu z.rep j :=
      coordOf_smul_apply hrank hu a z.rep j
    rw [ha] at h1
    exact h1.symm
  rw [collinear_iff_det_eq_zero hrank hu]
  have hscaled := det_smul_row_two (K := K) (coord hrank hu p) (coord hrank hu q)
    (coord hrank hu z) a
  rw [hrow, hdet] at hscaled
  exact ((mul_eq_zero.mp hscaled.symm).resolve_left hane)

end FrameCoordinates
end RelativeConicArcs
