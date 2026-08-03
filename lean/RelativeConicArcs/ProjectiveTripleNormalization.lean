import ProjectiveCap.PlaneAffineChart
import ProjectiveCap.PlaneTransitivity

/-!
# Ordered projective-triple normalization

Two small coordinate utilities used by affine normal-form arguments:

* an ordered version of projective transitivity on noncollinear triples; and
* the diagonal affine rescaling `(X,Y,Z) ↦ (x⁻¹X,y⁻¹Y,Z)`.

The first theorem deliberately records the images of the three points individually.  The existing
`capTransitiveStatement_three` transports the corresponding three-element finsets, which is weaker
when later arguments attach different geometric roles to the three points.
-/

open scoped LinearAlgebra.Projectivization

namespace RelativeConicArcs
namespace ProjectiveTripleNormalization

open Projectivization
open ProjectiveCap.Projective

variable {K V : Type*} [Field K] [AddCommGroup V] [Module K V]

/-- Two ordered noncollinear triples in a projective plane are related by a projective linear
automorphism, with the three images recorded pointwise. -/
theorem exists_mapEquiv_ordered_triple
    (hrank : Module.finrank K V = 3)
    {p₀ p₁ p₂ q₀ q₁ q₂ : Point K V}
    (hp : ¬ Collinear K V p₀ p₁ p₂)
    (hq : ¬ Collinear K V q₀ q₁ q₂) :
    ∃ g : V ≃ₗ[K] V,
      mapEquiv g p₀ = q₀ ∧ mapEquiv g p₁ = q₁ ∧ mapEquiv g p₂ = q₂ := by
  have hliP : LinearIndependent K ![p₀.rep, p₁.rep, p₂.rep] :=
    independent_triple_iff.mp (not_collinear_iff_independent.mp hp)
  have hliQ : LinearIndependent K ![q₀.rep, q₁.rep, q₂.rep] :=
    independent_triple_iff.mp (not_collinear_iff_independent.mp hq)
  have hcard3 : Fintype.card (Fin 3) = Module.finrank K V := by simp [hrank]
  let bP := basisOfLinearIndependentOfCardEqFinrank hliP hcard3
  let bQ := basisOfLinearIndependentOfCardEqFinrank hliQ hcard3
  let g : V ≃ₗ[K] V := bP.equiv bQ (Equiv.refl (Fin 3))
  have hcoeP : ⇑bP = ![p₀.rep, p₁.rep, p₂.rep] := by
    dsimp [bP]
    exact coe_basisOfLinearIndependentOfCardEqFinrank _ _
  have hcoeQ : ⇑bQ = ![q₀.rep, q₁.rep, q₂.rep] := by
    dsimp [bQ]
    exact coe_basisOfLinearIndependentOfCardEqFinrank _ _
  have hg (i : Fin 3) : g (bP i) = bQ i := by
    simp [g]
  have hg₀ : g p₀.rep = q₀.rep := by
    have h := hg 0
    rw [show bP 0 = p₀.rep by rw [hcoeP, Matrix.cons_val_zero],
      show bQ 0 = q₀.rep by rw [hcoeQ, Matrix.cons_val_zero]] at h
    exact h
  have hg₁ : g p₁.rep = q₁.rep := by
    have h := hg 1
    rw [show bP 1 = p₁.rep by rw [hcoeP, Matrix.cons_val_one, Matrix.cons_val_zero],
      show bQ 1 = q₁.rep by rw [hcoeQ, Matrix.cons_val_one, Matrix.cons_val_zero]] at h
    exact h
  have hg₂ : g p₂.rep = q₂.rep := by
    have h := hg 2
    rw [show bP 2 = p₂.rep by
          rw [hcoeP, Matrix.cons_val_two, Matrix.tail_cons, Matrix.head_cons],
      show bQ 2 = q₂.rep by
          rw [hcoeQ, Matrix.cons_val_two, Matrix.tail_cons, Matrix.head_cons]] at h
    exact h
  exact ⟨g, mapEquiv_eq_of_rep_eq g hg₀,
    mapEquiv_eq_of_rep_eq g hg₁, mapEquiv_eq_of_rep_eq g hg₂⟩

namespace Coordinate

open ProjectiveCap
open ProjectiveCap.Projective.FrameGridBridge.Coordinate

variable {K : Type*} [Field K]

/-- Diagonal affine rescaling in homogeneous coordinates.  It fixes the line at infinity and the
affine origin, while sending `(x,0)` and `(0,y)` to `(1,0)` and `(0,1)` respectively. -/
def affineRescale (x y : K) (hx : x ≠ 0) (hy : y ≠ 0) :
    PlaneVec K ≃ₗ[K] PlaneVec K where
  toFun v := ![x⁻¹ * v 0, y⁻¹ * v 1, v 2]
  invFun v := ![x * v 0, y * v 1, v 2]
  left_inv v := by
    ext i
    fin_cases i <;> simp [hx, hy]
  right_inv v := by
    ext i
    fin_cases i <;> simp [hx, hy]
  map_add' u v := by
    ext i
    fin_cases i <;> simp <;> ring
  map_smul' a v := by
    ext i
    fin_cases i <;> simp <;> ring

@[simp] theorem affineRescale_apply (x y : K) (hx : x ≠ 0) (hy : y ≠ 0)
    (v : PlaneVec K) :
    affineRescale x y hx hy v = ![x⁻¹ * v 0, y⁻¹ * v 1, v 2] :=
  rfl

@[simp] theorem affineRescale_rowDirectionVec (x y : K) (hx : x ≠ 0) (hy : y ≠ 0) :
    affineRescale x y hx hy (rowDirectionVec (K := K)) =
      x⁻¹ • rowDirectionVec (K := K) := by
  ext i
  fin_cases i <;> simp [affineRescale, rowDirectionVec]

@[simp] theorem affineRescale_colDirectionVec (x y : K) (hx : x ≠ 0) (hy : y ≠ 0) :
    affineRescale x y hx hy (colDirectionVec (K := K)) =
      y⁻¹ • colDirectionVec (K := K) := by
  ext i
  fin_cases i <;> simp [affineRescale, colDirectionVec]

@[simp] theorem affineRescale_affineVec (x y : K) (hx : x ≠ 0) (hy : y ≠ 0)
    (p : GridPoint K) :
    affineRescale x y hx hy (affineVec (K := K) p) =
      affineVec (K := K) (x⁻¹ * p.1, y⁻¹ * p.2) := by
  ext i
  fin_cases i <;> simp [affineRescale, affineVec]

end Coordinate

#print axioms exists_mapEquiv_ordered_triple

end ProjectiveTripleNormalization
end RelativeConicArcs
