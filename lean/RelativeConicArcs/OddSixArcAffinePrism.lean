import RelativeConicArcs.OddSixArcLineBound
import ProjectiveCap.FrameGridBridge

/-!
# The affine triangular-prism obstruction in odd characteristic

This is the coordinate half of the exceptional equality-case exclusion in the six-arc line bound.
It proves that two affine lines through a common point of the line at infinity have parallel
direction vectors, then applies that fact to the normalized triangular-prism pattern.  The only
remaining C180 seam is projectively normalizing the geometric equality case into this interface.
-/

open scoped LinearAlgebra.Projectivization

namespace RelativeConicArcs
namespace OddSixArcAffinePrism

open ProjectiveCap ProjectiveCap.Projective Projectivization
open ProjectiveCap.Projective.FrameGridBridge.Coordinate

variable {K : Type*} [Field K]

abbrev PlaneVec (K : Type*) := FrameGridBridge.Coordinate.PlaneVec K
abbrev Point (K : Type*) [Field K] := ProjectiveCap.Projective.Point K (PlaneVec K)
abbrev AffinePoint (K : Type*) := GridPoint K

/-- The determinant of the two affine direction vectors `p→q` and `r→s`. -/
def directionDet (p q r s : AffinePoint K) : K :=
  (q.1 - p.1) * (s.2 - r.2) - (q.2 - p.2) * (s.1 - r.1)

/-- If two affine lines pass through the same point at infinity, their direction vectors are
parallel.  This is the reusable projective-to-affine algebra needed by the prism argument. -/
theorem directionDet_eq_zero_of_common_infinity
    (d : Point K) (p q r s : AffinePoint K)
    (hdInf : ProjectiveCap.Projective.Collinear K (PlaneVec K)
      (rowDirection (K := K)) (colDirection (K := K)) d)
    (hdpq : ProjectiveCap.Projective.Collinear K (PlaneVec K) d
      (affinePoint (K := K) p) (affinePoint (K := K) q))
    (hdrs : ProjectiveCap.Projective.Collinear K (PlaneVec K) d
      (affinePoint (K := K) r) (affinePoint (K := K) s)) :
    directionDet p q r s = 0 := by
  induction d using Projectivization.ind with
  | h v hv =>
      have hv2 : v 2 = 0 := by
        change ProjectiveCap.Projective.Collinear K (PlaneVec K)
          (Projectivization.mk K (rowDirectionVec (K := K)) rowDirectionVec_ne_zero)
          (Projectivization.mk K (colDirectionVec (K := K)) colDirectionVec_ne_zero)
          (Projectivization.mk K v hv) at hdInf
        rw [mk_collinear_iff_det_eq_zero rowDirectionVec_ne_zero
          colDirectionVec_ne_zero hv, det_rowDirection_colDirection_vec] at hdInf
        exact hdInf
      have hpq :
          -(v 0) * (q.2 - p.2) + (v 1) * (q.1 - p.1) = 0 := by
        change ProjectiveCap.Projective.Collinear K (PlaneVec K)
          (Projectivization.mk K v hv)
          (Projectivization.mk K (affineVec (K := K) p) (affineVec_ne_zero p))
          (Projectivization.mk K (affineVec (K := K) q) (affineVec_ne_zero q)) at hdpq
        rw [mk_collinear_iff_det_eq_zero hv (affineVec_ne_zero p)
          (affineVec_ne_zero q), Matrix.det_fin_three] at hdpq
        simp only [affineVec, Matrix.cons_val_zero, Matrix.cons_val_one,
          Matrix.cons_val_two, Matrix.head_cons, Matrix.tail_cons] at hdpq
        rw [hv2] at hdpq
        linear_combination hdpq
      have hrs :
          -(v 0) * (s.2 - r.2) + (v 1) * (s.1 - r.1) = 0 := by
        change ProjectiveCap.Projective.Collinear K (PlaneVec K)
          (Projectivization.mk K v hv)
          (Projectivization.mk K (affineVec (K := K) r) (affineVec_ne_zero r))
          (Projectivization.mk K (affineVec (K := K) s) (affineVec_ne_zero s)) at hdrs
        rw [mk_collinear_iff_det_eq_zero hv (affineVec_ne_zero r)
          (affineVec_ne_zero s), Matrix.det_fin_three] at hdrs
        simp only [affineVec, Matrix.cons_val_zero, Matrix.cons_val_one,
          Matrix.cons_val_two, Matrix.head_cons, Matrix.tail_cons] at hdrs
        rw [hv2] at hdrs
        linear_combination hdrs
      by_cases hv0 : v 0 = 0
      · have hv1 : v 1 ≠ 0 := by
          intro hv1
          apply hv
          funext i
          fin_cases i <;> simp [hv0, hv1, hv2]
        have hqx : q.1 - p.1 = 0 := by
          rw [hv0] at hpq
          have hpq' : v 1 * (q.1 - p.1) = 0 := by simpa using hpq
          exact (mul_eq_zero.mp hpq').resolve_left hv1
        have hsx : s.1 - r.1 = 0 := by
          rw [hv0] at hrs
          have hrs' : v 1 * (s.1 - r.1) = 0 := by simpa using hrs
          exact (mul_eq_zero.mp hrs').resolve_left hv1
        simp [directionDet, hqx, hsx]
      · apply (mul_eq_zero.mp ?_).resolve_left hv0
        change v 0 * directionDet p q r s = 0
        dsimp [directionDet]
        linear_combination (s.1 - r.1) * hpq - (q.1 - p.1) * hrs

/-- The normalized triangular prism cannot occur over a field of odd characteristic. -/
theorem normalized_triangularPrism_impossible
    (hodd : (2 : K) ≠ 0) (a b : K) (d : Point K)
    (hdInf : ProjectiveCap.Projective.Collinear K (PlaneVec K)
      (rowDirection (K := K)) (colDirection (K := K)) d)
    (h14 : ProjectiveCap.Projective.Collinear K (PlaneVec K) d
      (affinePoint (K := K) (0, 0)) (affinePoint (K := K) (a, 1)))
    (h26 : ProjectiveCap.Projective.Collinear K (PlaneVec K) d
      (affinePoint (K := K) (1, 0)) (affinePoint (K := K) (a, b)))
    (h35 : ProjectiveCap.Projective.Collinear K (PlaneVec K) d
      (affinePoint (K := K) (0, 1)) (affinePoint (K := K) (1, b))) : False := by
  have h1426 := directionDet_eq_zero_of_common_infinity d
    (0, 0) (a, 1) (1, 0) (a, b) hdInf h14 h26
  have h1435 := directionDet_eq_zero_of_common_infinity d
    (0, 0) (a, 1) (0, 1) (1, b) hdInf h14 h35
  have hminus : a * (b - 1) = -1 := by
    dsimp [directionDet] at h1426
    linear_combination h1426
  have hplus : a * (b - 1) = 1 := by
    dsimp [directionDet] at h1435
    linear_combination h1435
  exact OddSixArcLineBound.triangularPrism_parallelism_contradiction
    hodd a b hminus hplus

#print axioms directionDet_eq_zero_of_common_infinity
#print axioms normalized_triangularPrism_impossible

end OddSixArcAffinePrism
end RelativeConicArcs
