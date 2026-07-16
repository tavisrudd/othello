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

#print axioms eval_pullbackQuadratic
#print axioms pullbackQuadratic_ne_zero
#print axioms arbitrary_eight_arc_classification_chain

end RelativeConicArcs.Q16Classification
