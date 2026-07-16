import RelativeConicArcs.Q16QuadraticAvoidance
import RelativeConicArcs.Q16CertificateData

/-!
# Coordinate transport for arbitrary quadratic forms over GF(16)

This is the algebraic bridge used when a general eight-arc is normalized to a certified leaf.
-/

namespace RelativeConicArcs.Q16Classification

open Certificate FiniteFields Matrix Q16CertificateData

private abbrev K := GF16

noncomputable local instance : Fintype Point16 := Fintype.ofFinite _
noncomputable local instance : DecidableEq Point16 := Classical.decEq _

/-- Pull a quadratic coefficient vector back through a linear coordinate matrix. -/
def pullbackQuadratic (M : Matrix (Fin 3) (Fin 3) K) (q : Fin 6 → K) : Fin 6 → K :=
  fun k =>
    let c (j : Fin 3) : Vec K := fun i => M i j
    match k with
    | 0 => dotProduct (monomial (c 0)) q
    | 1 => dotProduct (monomial (c 1)) q
    | 2 => dotProduct (monomial (c 2)) q
    | 3 => dotProduct (monomial (c 0 + c 1)) q +
        dotProduct (monomial (c 0)) q + dotProduct (monomial (c 1)) q
    | 4 => dotProduct (monomial (c 0 + c 2)) q +
        dotProduct (monomial (c 0)) q + dotProduct (monomial (c 2)) q
    | 5 => dotProduct (monomial (c 1 + c 2)) q +
        dotProduct (monomial (c 1)) q + dotProduct (monomial (c 2)) q

/-- Evaluation commutes with the explicit coefficient pullback. -/
theorem eval_pullbackQuadratic (M : Matrix (Fin 3) (Fin 3) K) (q : Fin 6 → K)
    (v : Vec K) :
    dotProduct (monomial v) (pullbackQuadratic M q) =
      dotProduct (monomial (M *ᵥ v)) q := by
  simp [pullbackQuadratic, monomial, dotProduct, Matrix.mulVec, Fin.sum_univ_succ]
  ring_nf
  simp [show (2 : K) = 0 by decide]

theorem quadratic_eq_zero_of_eval_zero {q : Fin 6 → K}
    (h : ∀ v : Vec K, dotProduct (monomial v) q = 0) : q = 0 := by
  funext i
  fin_cases i
  · simpa [monomial, dotProduct, Fin.sum_univ_succ] using h ![1, 0, 0]
  · simpa [monomial, dotProduct, Fin.sum_univ_succ] using h ![0, 1, 0]
  · simpa [monomial, dotProduct, Fin.sum_univ_succ] using h ![0, 0, 1]
  · have h0 := h ![1, 0, 0]
    have h1 := h ![0, 1, 0]
    have h01 := h ![1, 1, 0]
    simp [monomial, dotProduct, Fin.sum_univ_succ] at h0 h1 h01
    change q 3 = 0
    linear_combination h01 - h0 - h1
  · have h0 := h ![1, 0, 0]
    have h2 := h ![0, 0, 1]
    have h02 := h ![1, 0, 1]
    simp [monomial, dotProduct, Fin.sum_univ_succ] at h0 h2 h02
    change q 4 = 0
    linear_combination h02 - h0 - h2
  · have h1 := h ![0, 1, 0]
    have h2 := h ![0, 0, 1]
    have h12 := h ![0, 1, 1]
    simp [monomial, dotProduct, Fin.sum_univ_succ] at h1 h2 h12
    change q 5 = 0
    linear_combination h12 - h1 - h2

/-- An invertible coordinate change cannot turn a nonzero quadratic into zero. -/
theorem pullbackQuadratic_ne_zero {M : Matrix (Fin 3) (Fin 3) K}
    (hM : IsUnit M.det) {q : Fin 6 → K} (hq : q ≠ 0) : pullbackQuadratic M q ≠ 0 := by
  intro hpull
  apply hq
  apply quadratic_eq_zero_of_eval_zero
  intro w
  let e : (Fin 3 → K) ≃ₗ[K] (Fin 3 → K) :=
    M.toLinearEquiv' (Matrix.invertibleOfIsUnitDet _ hM)
  obtain ⟨v, rfl⟩ := e.surjective w
  have he (v : Vec K) : e v = M *ᵥ v := by
    have h := LinearMap.congr_fun
      (Matrix.toLinearEquiv'_apply M (Matrix.invertibleOfIsUnitDet _ hM)) v
    rw [Matrix.toLin'_apply] at h
    exact h
  rw [he, ← eval_pullbackQuadratic, hpull]
  simp [dotProduct]

/-- Ordinary uncoveredness stated directly in projective incidence language. -/
def ProjectiveOrdinaryUncovered (A : Finset Point16) (p : Point16) : Prop :=
  p ∉ A ∧ ∀ a ∈ A, ∀ b ∈ A, a ≠ b →
    ¬ProjectiveCap.Projective.Collinear K (Fin 3 → K) p a b

/-- Vanishing of a homogeneous quadratic on a projective point. -/
def ProjectiveQuadraticZero (q : Fin 6 → K) (p : Point16) : Prop :=
  dotProduct (monomial p.rep) q = 0

/-- The paper's singular-or-nonsingular quadratic-avoidance property. -/
def ProjectiveQuadraticAvoidance (A : Finset Point16) : Prop :=
  ∀ q : Fin 6 → K,
    (∀ p, ProjectiveOrdinaryUncovered A p → ProjectiveQuadraticZero q p) →
      q = 0 ∨ ∃ p ∈ A, ProjectiveQuadraticZero q p

private theorem fastDet3_eq_zero_iff_collinear (i a b : Idx) :
    fastDet3 (vecCode i) (vecCode a) (vecCode b) = 0 ↔
      ProjectiveCap.Projective.Collinear K (Fin 3 → K) (point i) (point a) (point b) := by
  rw [← decode16_eq_zero_iff, decode16_fastDet3,
    decode16_vecCode, decode16_vecCode, decode16_vecCode]
  rw [det3_eq_det]
  simpa [point, rawPoint, Certificate.toPoint] using
    (ProjectiveCap.Projective.FrameGridBridge.Coordinate.mk_collinear_iff_det_eq_zero
      (vec_ne_zero i) (vec_ne_zero a) (vec_ne_zero b)).symm

theorem ordinaryUncovered_iff_projective {S : Finset Idx} {i : Idx} :
    OrdinaryUncovered S i ↔ ProjectiveOrdinaryUncovered (pointSetIdx S) (point i) := by
  constructor
  · intro hi
    refine ⟨?_, ?_⟩
    · intro hip
      obtain ⟨j, hjS, hji⟩ := Finset.mem_map.mp hip
      exact hi.1 (point_injective (by simpa using hji.symm) ▸ hjS)
    · intro pa hpa pb hpb hpab hcol
      obtain ⟨a, haS, rfl⟩ := Finset.mem_map.mp hpa
      obtain ⟨b, hbS, rfl⟩ := Finset.mem_map.mp hpb
      have hab : a ≠ b := fun h => hpab (h ▸ rfl)
      exact hi.2 a haS b hbS hab (fastDet3_eq_zero_iff_collinear i a b |>.mpr hcol)
  · intro hi
    refine ⟨?_, ?_⟩
    · intro hiS
      exact hi.1 (Finset.mem_map.mpr ⟨i, hiS, rfl⟩)
    · intro a haS b hbS hab hdet
      exact hi.2 (point a) (Finset.mem_map.mpr ⟨a, haS, rfl⟩)
        (point b) (Finset.mem_map.mpr ⟨b, hbS, rfl⟩)
        (fun hp => hab (point_injective hp))
        (fastDet3_eq_zero_iff_collinear i a b |>.mp hdet)

theorem eval_mk_zero_iff (q : Fin 6 → K) (v : Vec K) (hv : v ≠ 0) :
    ProjectiveQuadraticZero q (Projectivization.mk K v hv) ↔
      dotProduct (monomial v) q = 0 := by
  obtain ⟨a, ha⟩ := Projectivization.exists_smul_eq_mk_rep K v hv
  have ha0 : (a : K) ^ 2 ≠ 0 := pow_ne_zero 2 a.ne_zero
  unfold ProjectiveQuadraticZero
  rw [← ha]
  change dotProduct (monomial ((a : K) • v)) q = 0 ↔ _
  rw [dotProduct_monomial_smul]
  exact mul_eq_zero_iff_left ha0

noncomputable def linearEquivMatrix (e : (Fin 3 → K) ≃ₗ[K] (Fin 3 → K)) :
    Matrix (Fin 3) (Fin 3) K :=
  LinearMap.toMatrix (Pi.basisFun K (Fin 3)) (Pi.basisFun K (Fin 3)) e.toLinearMap

theorem linearEquivMatrix_mulVec (e : (Fin 3 → K) ≃ₗ[K] (Fin 3 → K)) (v : Vec K) :
    linearEquivMatrix e *ᵥ v = e v := by
  simp [linearEquivMatrix]

theorem linearEquivMatrix_isUnit_det (e : (Fin 3 → K) ≃ₗ[K] (Fin 3 → K)) :
    IsUnit (linearEquivMatrix e).det := by
  exact e.isUnit_det (Pi.basisFun K (Fin 3)) (Pi.basisFun K (Fin 3))

theorem projectiveZero_pullback (e : (Fin 3 → K) ≃ₗ[K] (Fin 3 → K))
    (q : Fin 6 → K) (p : Point16) :
    ProjectiveQuadraticZero (pullbackQuadratic (linearEquivMatrix e) q) p ↔
      ProjectiveQuadraticZero q (ProjectiveCap.Projective.mapEquiv e p) := by
  rw [← Projectivization.mk_rep p]
  rw [ProjectiveCap.Projective.mapEquiv_mk]
  rw [eval_mk_zero_iff, eval_mk_zero_iff]
  rw [eval_pullbackQuadratic, linearEquivMatrix_mulVec]

theorem projectiveOrdinaryUncovered_mapEquiv
    (e : (Fin 3 → K) ≃ₗ[K] (Fin 3 → K)) (A : Finset Point16) (p : Point16) :
    ProjectiveOrdinaryUncovered
        (A.map (ProjectiveCap.Projective.mapEquiv e).toEmbedding)
        (ProjectiveCap.Projective.mapEquiv e p) ↔
      ProjectiveOrdinaryUncovered A p := by
  constructor
  · rintro ⟨hp, hsec⟩
    refine ⟨?_, ?_⟩
    · intro hpA
      exact hp (Finset.mem_map.mpr ⟨p, hpA, rfl⟩)
    · intro a ha b hb hab hcol
      apply hsec (ProjectiveCap.Projective.mapEquiv e a) (Finset.mem_map.mpr ⟨a, ha, rfl⟩)
        (ProjectiveCap.Projective.mapEquiv e b) (Finset.mem_map.mpr ⟨b, hb, rfl⟩)
        (fun h => hab ((ProjectiveCap.Projective.mapEquiv e).injective h))
      exact (ProjectiveCap.Projective.collinear_mapEquiv e).mpr hcol
  · rintro ⟨hp, hsec⟩
    refine ⟨?_, ?_⟩
    · intro hpA
      obtain ⟨x, hxA, hxp⟩ := Finset.mem_map.mp hpA
      have hxp' : x = p := (ProjectiveCap.Projective.mapEquiv e).injective hxp
      exact hp (hxp' ▸ hxA)
    · intro a ha b hb hab hcol
      obtain ⟨a', ha', rfl⟩ := Finset.mem_map.mp ha
      obtain ⟨b', hb', rfl⟩ := Finset.mem_map.mp hb
      exact hsec a' ha' b' hb' (fun h => hab (congrArg (ProjectiveCap.Projective.mapEquiv e) h))
        ((ProjectiveCap.Projective.collinear_mapEquiv e).mp hcol)

theorem raw_eval_zero_iff_projective_point (q : Fin 6 → K) (i : Idx) :
    dotProduct (monomial (vec i)) q = 0 ↔ ProjectiveQuadraticZero q (point i) := by
  simpa [point, rawPoint, Certificate.toPoint] using (eval_mk_zero_iff q (vec i) (vec_ne_zero i)).symm

theorem level8_projectiveQuadraticAvoidance {S : Finset Idx} (hS : S ∈ level8) :
    ProjectiveQuadraticAvoidance (pointSetIdx S) := by
  intro q hvanish
  rcases level8_quadraticAvoidance hS q (fun i hi =>
    (raw_eval_zero_iff_projective_point q i).mpr
      (hvanish (point i) ((ordinaryUncovered_iff_projective).mp hi))) with hq | ⟨i, hiS, hiq⟩
  · exact Or.inl hq
  · exact Or.inr ⟨point i, Finset.mem_map.mpr ⟨i, hiS, rfl⟩,
      (raw_eval_zero_iff_projective_point q i).mp hiq⟩

private theorem projectiveQuadraticAvoidance_map
    (e : (Fin 3 → K) ≃ₗ[K] (Fin 3 → K)) {A : Finset Point16}
    (hA : ProjectiveQuadraticAvoidance A) :
    ProjectiveQuadraticAvoidance
      (A.map (ProjectiveCap.Projective.mapEquiv e).toEmbedding) := by
  intro q hvanish
  let q' := pullbackQuadratic (linearEquivMatrix e) q
  rcases hA q' (fun p hp => (projectiveZero_pullback e q p).mpr
    (hvanish (ProjectiveCap.Projective.mapEquiv e p)
      ((projectiveOrdinaryUncovered_mapEquiv e A p).mpr hp))) with hq | ⟨p, hpA, hpq⟩
  · left
    by_contra hq0
    exact pullbackQuadratic_ne_zero (linearEquivMatrix_isUnit_det e) hq0 hq
  · right
    exact ⟨ProjectiveCap.Projective.mapEquiv e p,
      Finset.mem_map.mpr ⟨p, hpA, rfl⟩, (projectiveZero_pullback e q p).mp hpq⟩

theorem projectiveQuadraticAvoidance_mapEquiv
    (e : (Fin 3 → K) ≃ₗ[K] (Fin 3 → K)) (A : Finset Point16) :
    ProjectiveQuadraticAvoidance
        (A.map (ProjectiveCap.Projective.mapEquiv e).toEmbedding) ↔
      ProjectiveQuadraticAvoidance A := by
  constructor
  · intro hmap
    have hback := projectiveQuadraticAvoidance_map e.symm hmap
    have hset :
        (A.map (ProjectiveCap.Projective.mapEquiv e).toEmbedding).map
            (ProjectiveCap.Projective.mapEquiv e.symm).toEmbedding = A := by
      ext p
      simp [Finset.mem_map_equiv]
    rwa [hset] at hback
  · exact projectiveQuadraticAvoidance_map e

/-- Every abstract eight-arc enters the checked classification through explicit projective
maps: first to a frame-containing indexed arc, then to a certified level-eight leaf. -/
theorem arbitrary_eight_arc_classification_chain
    {A : Finset Point16}
    (hcapA : ProjectiveCap.Projective.Cap K (Fin 3 → K) A) (hcard : A.card = 8) :
    ∃ S leaf : Finset Idx, Frame16 ⊆ S ∧ S.card = 8 ∧ RawCap S ∧ leaf ∈ level8 ∧
      ∃ g : (Fin 3 → K) ≃ₗ[K] (Fin 3 → K),
        A.map (ProjectiveCap.Projective.mapEquiv g).toEmbedding = pointSetIdx S ∧
          RawProjectiveEquiv S leaf := by
  obtain ⟨T, hTA, hTcard⟩ := Finset.exists_subset_card_eq (s := A) (n := 4) (by omega)
  have hcapT : ProjectiveCap.Projective.Cap K (Fin 3 → K) T :=
    ProjectiveCap.Projective.cap_mono hTA hcapA
  have hframeRaw : RawCap Frame16 := by
    intro a ha b hb c hc hab hac hbc
    simp only [Frame16, Finset.mem_insert, Finset.mem_singleton] at ha hb hc
    rcases ha with rfl | rfl | rfl | rfl <;>
      rcases hb with rfl | rfl | rfl | rfl <;>
      rcases hc with rfl | rfl | rfl | rfl <;> simp_all <;> decide
  have hcapFrame : ProjectiveCap.Projective.Cap K (Fin 3 → K)
      (pointSetIdx Frame16) := (rawCap_iff_projectiveCap Frame16).mp hframeRaw
  obtain ⟨g, hgT⟩ := exists_mapEquiv_of_caps_card_four hcapT hcapFrame hTcard (by
    change (Frame16.map canonicalPointEquiv.toEmbedding).card = 4
    rw [Finset.card_map]
    decide)
  let B := A.map (ProjectiveCap.Projective.mapEquiv g).toEmbedding
  let S := B.map canonicalPointEquiv.symm.toEmbedding
  have hpointS : pointSetIdx S = B := by
    ext p
    simp [S, pointSetIdx, Finset.mem_map_equiv]
  have hframeS : Frame16 ⊆ S := by
    intro i hi
    have hip : canonicalPointEquiv i ∈ pointSetIdx Frame16 :=
      Finset.mem_map.mpr ⟨i, hi, rfl⟩
    rw [← hgT] at hip
    have hiB : canonicalPointEquiv i ∈ B :=
      Finset.mem_of_subset (Finset.map_subset_map.mpr hTA) hip
    have his : canonicalPointEquiv.symm (canonicalPointEquiv i) ∈ S :=
      Finset.mem_map.mpr ⟨canonicalPointEquiv i, hiB, rfl⟩
    rw [Equiv.symm_apply_apply] at his
    exact his
  have hScard : S.card = 8 := by simp [S, B, hcard]
  have hcapB : ProjectiveCap.Projective.Cap K (Fin 3 → K) B :=
    (ProjectiveCap.Projective.cap_map_mapEquiv g A).2 hcapA
  have hcapS : RawCap S :=
    (rawCap_iff_projectiveCap S).2 (by simpa [hpointS] using hcapB)
  obtain ⟨leaf, hleaf, hSleaf⟩ :=
    classifiedAt_level8_of_frame hframeS hScard hcapS
      books4_valid books5_valid books6_valid books7_valid
  refine ⟨S, leaf, hframeS, hScard, hcapS, hleaf, g, ?_, hSleaf⟩
  exact hpointS.symm

/-- End-to-end formalization of the manuscript's quadratic-avoidance theorem for every
eight-arc in `PG(2,16)`, including singular quadratic forms. -/
theorem arbitrary_eight_arc_projectiveQuadraticAvoidance
    {A : Finset Point16}
    (hcapA : ProjectiveCap.Projective.Cap K (Fin 3 → K) A) (hcard : A.card = 8) :
    ProjectiveQuadraticAvoidance A := by
  obtain ⟨S, leaf, _hframe, _hScard, _hcapS, hleaf, g, hg, hSleaf⟩ :=
    arbitrary_eight_arc_classification_chain hcapA hcard
  obtain ⟨f, hf⟩ := hSleaf
  have hleafAvoid : ProjectiveQuadraticAvoidance (pointSetIdx leaf) :=
    level8_projectiveQuadraticAvoidance hleaf
  have hSAvoid : ProjectiveQuadraticAvoidance (pointSetIdx S) := by
    have h := (projectiveQuadraticAvoidance_mapEquiv f (pointSetIdx S)).mp (by simpa [hf] using hleafAvoid)
    exact h
  have hA := (projectiveQuadraticAvoidance_mapEquiv g A).mp (by simpa [hg] using hSAvoid)
  exact hA

#print axioms eval_pullbackQuadratic
#print axioms pullbackQuadratic_ne_zero
#print axioms arbitrary_eight_arc_classification_chain
#print axioms arbitrary_eight_arc_projectiveQuadraticAvoidance

end RelativeConicArcs.Q16Classification
