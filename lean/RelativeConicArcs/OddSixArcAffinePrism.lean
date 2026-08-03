import RelativeConicArcs.OddSixArcLineBound
import RelativeConicArcs.ProjectiveTripleNormalization
import ProjectiveCap.PlaneAffineChart

/-!
# The affine triangular-prism obstruction in odd characteristic

This is the coordinate half of the exceptional equality-case exclusion in the six-arc line bound.
It proves that two affine lines through a common point of the line at infinity have parallel
direction vectors, then applies that fact to the normalized triangular-prism pattern.  The only
input to the final obstruction is the projective incidence pattern of the three prism matchings.
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

/-- A triangular-prism arrangement whose three direction points are collinear cannot be realized
by six distinct projective points off that direction line in odd characteristic.  This is the
projectively invariant interface consumed by the equality-case extraction. -/
theorem triangularPrism_impossible
    (hodd : (2 : K) ≠ 0)
    (p : Fin 6 → Point K) (hp : Function.Injective p)
    (d₀ d₁ d₂ : Point K)
    (hoff : ∀ i, ¬ ProjectiveCap.Projective.Collinear K (PlaneVec K) d₀ d₁ (p i))
    (hinf : ProjectiveCap.Projective.Collinear K (PlaneVec K) d₀ d₁ d₂)
    (h01 : ProjectiveCap.Projective.Collinear K (PlaneVec K) d₀ (p 0) (p 1))
    (h23 : ProjectiveCap.Projective.Collinear K (PlaneVec K) d₀ (p 2) (p 3))
    (h45 : ProjectiveCap.Projective.Collinear K (PlaneVec K) d₀ (p 4) (p 5))
    (h02 : ProjectiveCap.Projective.Collinear K (PlaneVec K) d₁ (p 0) (p 2))
    (h14' : ProjectiveCap.Projective.Collinear K (PlaneVec K) d₁ (p 1) (p 4))
    (h35' : ProjectiveCap.Projective.Collinear K (PlaneVec K) d₁ (p 3) (p 5))
    (h03 : ProjectiveCap.Projective.Collinear K (PlaneVec K) d₂ (p 0) (p 3))
    (h15 : ProjectiveCap.Projective.Collinear K (PlaneVec K) d₂ (p 1) (p 5))
    (h24 : ProjectiveCap.Projective.Collinear K (PlaneVec K) d₂ (p 2) (p 4)) : False := by
  have htarget : ¬ ProjectiveCap.Projective.Collinear K (PlaneVec K)
      (rowDirection (K := K)) (colDirection (K := K))
      (affinePoint (K := K) (0, 0)) :=
    not_collinear_row_col_affine (K := K) (0, 0)
  obtain ⟨g, hgd₀, hgd₁, hgp₀⟩ :=
    ProjectiveTripleNormalization.exists_mapEquiv_ordered_triple
      (V := PlaneVec K) (by simp [PlaneVec]) (hoff 0) htarget
  let P : Fin 6 → Point K := fun i => mapEquiv g (p i)
  have hPoff (i : Fin 6) : ¬ ProjectiveCap.Projective.Collinear K (PlaneVec K)
      (rowDirection (K := K)) (colDirection (K := K)) (P i) := by
    intro h
    apply hoff i
    apply (collinear_mapEquiv g).mp
    simpa [P, hgd₀, hgd₁] using h
  have hPcoords (i : Fin 6) : ∃ z : AffinePoint K, P i = affinePoint (K := K) z :=
    (point_eq_affine_or_collinear_row_col (K := K) (P i)).resolve_right (hPoff i)
  choose c hc using hPcoords
  have hc₀ : c 0 = (0, 0) := by
    apply affinePoint_injective (K := K)
    exact (hc 0).symm.trans (by simpa [P] using hgp₀)
  have mapCol {a b c : Point K}
      (h : ProjectiveCap.Projective.Collinear K (PlaneVec K) a b c) :
      ProjectiveCap.Projective.Collinear K (PlaneVec K)
        (mapEquiv g a) (mapEquiv g b) (mapEquiv g c) :=
    (collinear_mapEquiv g).mpr h
  have rowCol {i j : Fin 6}
      (h : ProjectiveCap.Projective.Collinear K (PlaneVec K) d₀ (p i) (p j)) :
      (c i).2 = (c j).2 := by
    apply (collinear_rowDirection_affine_iff (K := K) (c i) (c j)).mp
    simpa [P, hgd₀, hc i, hc j] using mapCol h
  have colCol {i j : Fin 6}
      (h : ProjectiveCap.Projective.Collinear K (PlaneVec K) d₁ (p i) (p j)) :
      (c i).1 = (c j).1 := by
    apply (collinear_colDirection_affine_iff (K := K) (c i) (c j)).mp
    simpa [P, hgd₁, hc i, hc j] using mapCol h
  have hc₁y : (c 1).2 = 0 := by simpa [hc₀] using (rowCol h01).symm
  have hc₃y : (c 3).2 = (c 2).2 := (rowCol h23).symm
  have hc₅y : (c 5).2 = (c 4).2 := (rowCol h45).symm
  have hc₂x : (c 2).1 = 0 := by simpa [hc₀] using (colCol h02).symm
  have hc₄x : (c 4).1 = (c 1).1 := (colCol h14').symm
  have hc₅x : (c 5).1 = (c 3).1 := (colCol h35').symm
  have hp01 : p 0 ≠ p 1 := by
    intro h
    exact (by decide : (0 : Fin 6) ≠ 1) (hp h)
  have hp02 : p 0 ≠ p 2 := by
    intro h
    exact (by decide : (0 : Fin 6) ≠ 2) (hp h)
  have hc01 : c 0 ≠ c 1 := by
    intro h
    apply hp01
    apply (mapEquiv g).injective
    change P 0 = P 1
    rw [hc 0, hc 1, h]
  have hc02 : c 0 ≠ c 2 := by
    intro h
    apply hp02
    apply (mapEquiv g).injective
    change P 0 = P 2
    rw [hc 0, hc 2, h]
  have hx : (c 1).1 ≠ 0 := by
    intro h
    apply hc01
    apply Prod.ext
    · simpa [hc₀, h]
    · simpa [hc₀, hc₁y]
  have hy : (c 2).2 ≠ 0 := by
    intro h
    apply hc02
    apply Prod.ext
    · simpa [hc₀, hc₂x]
    · simpa [hc₀, h]
  have hd₂Inf : ProjectiveCap.Projective.Collinear K (PlaneVec K)
      (rowDirection (K := K)) (colDirection (K := K)) (mapEquiv g d₂) := by
    simpa [hgd₀, hgd₁] using mapCol hinf
  have d2Col {i j : Fin 6}
      (h : ProjectiveCap.Projective.Collinear K (PlaneVec K) d₂ (p i) (p j)) :
      ProjectiveCap.Projective.Collinear K (PlaneVec K) (mapEquiv g d₂)
        (affinePoint (K := K) (c i)) (affinePoint (K := K) (c j)) := by
    simpa [P, hc i, hc j] using mapCol h
  have h0315 := directionDet_eq_zero_of_common_infinity (mapEquiv g d₂)
    (c 0) (c 3) (c 1) (c 5) hd₂Inf (d2Col h03) (d2Col h15)
  have h0324 := directionDet_eq_zero_of_common_infinity (mapEquiv g d₂)
    (c 0) (c 3) (c 2) (c 4) hd₂Inf (d2Col h03) (d2Col h24)
  dsimp [directionDet] at h0315 h0324
  rw [hc₀, hc₁y, hc₃y, hc₅x, hc₅y] at h0315
  rw [hc₀, hc₂x, hc₃y, hc₄x] at h0324
  simp only [Prod.fst, Prod.snd, sub_zero, zero_sub] at h0315 h0324
  have htwo : (2 : K) * (c 1).1 * (c 2).2 = 0 := by
    linear_combination h0315 - h0324
  have hxy : (c 1).1 * (c 2).2 ≠ 0 := mul_ne_zero hx hy
  have htwo' : (2 : K) * ((c 1).1 * (c 2).2) = 0 := by
    simpa [mul_assoc] using htwo
  exact hodd ((mul_eq_zero.mp htwo').resolve_right hxy)

#print axioms directionDet_eq_zero_of_common_infinity
#print axioms normalized_triangularPrism_impossible
#print axioms triangularPrism_impossible

end OddSixArcAffinePrism
end RelativeConicArcs
