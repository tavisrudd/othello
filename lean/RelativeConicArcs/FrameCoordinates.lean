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

end FrameCoordinates
end RelativeConicArcs
