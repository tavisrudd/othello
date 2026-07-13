import RelativeConicArcs.Q16StepKernel
import RelativeConicArcs.EvaluationObstruction
import ProjectiveCap.PlaneTransitivity

/-!
# Reduction of arbitrary eight-arcs over `GF(16)` to the generated frame classification

This file contains no generated data.  It proves that any eight-point projective cap can be
sent by an explicit projective linear equivalence to an indexed cap containing the standard
four-frame, and that rejection of every classified leaf rules out relative completeness.
-/

open scoped LinearAlgebra.Projectivization

namespace RelativeConicArcs
namespace Q16Classification

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

open Conic FiniteFields ProjectiveBridge Certificate
open Projectivization
open Q16CertificateData
open Module

noncomputable local instance : Fintype Point16 := Fintype.ofFinite _
noncomputable local instance : DecidableEq Point16 := Classical.decEq _

abbrev Frame16 : Finset Idx := {0, 1, 17, 34}

theorem rawCap_mono {S T : Finset Idx} (hST : S ⊆ T) (hT : RawCap T) : RawCap S := by
  intro a ha b hb c hc
  exact hT a (hST ha) b (hST hb) c (hST hc)

/-- The strengthened form of four-cap transitivity needed here: the witness is retained as a
linear equivalence rather than hidden behind an arbitrary point permutation. -/
theorem exists_mapEquiv_of_caps_card_four
    {S T : Finset Point16}
    (hS : ProjectiveCap.Projective.Cap GF16 (Fin 3 → GF16) S)
    (hT : ProjectiveCap.Projective.Cap GF16 (Fin 3 → GF16) T)
    (hScard : S.card = 4) (hTcard : T.card = 4) :
    ∃ g : (Fin 3 → GF16) ≃ₗ[GF16] (Fin 3 → GF16),
      S.map (ProjectiveCap.Projective.mapEquiv g).toEmbedding = T := by
  obtain ⟨p4, S3, hp4, rfl, hS3⟩ := Finset.card_eq_succ.mp hScard
  obtain ⟨p1, p2, p3, h12, h13, h23, rfl⟩ := Finset.card_eq_three.mp hS3
  obtain ⟨q4, T3, hq4, rfl, hT3⟩ := Finset.card_eq_succ.mp hTcard
  obtain ⟨q1, q2, q3, h12', h13', h23', rfl⟩ := Finset.card_eq_three.mp hT3
  simp only [Finset.mem_insert, Finset.mem_singleton, not_or] at hp4 hq4
  have hSset :
      insert p4 ({p1, p2, p3} : Finset Point16) = {p1, p2, p3, p4} := by
    ext z
    simp only [Finset.mem_insert, Finset.mem_singleton]
    tauto
  have hTset :
      insert q4 ({q1, q2, q3} : Finset Point16) = {q1, q2, q3, q4} := by
    ext z
    simp only [Finset.mem_insert, Finset.mem_singleton]
    tauto
  rw [hSset] at hS ⊢
  rw [hTset] at hT ⊢
  obtain ⟨u, hu, ⟨hu0, hp1⟩, ⟨hu1, hp2⟩, ⟨hu2, hp3⟩, husum⟩ :=
    ProjectiveCap.Projective.quad_normal_form (by simp) hS h12 h13
      (fun h => hp4.1 h.symm) h23 (fun h => hp4.2.1 h.symm)
      (fun h => hp4.2.2 h.symm)
  obtain ⟨w, hw, ⟨hw0, hq1⟩, ⟨hw1, hq2⟩, ⟨hw2, hq3⟩, hwsum⟩ :=
    ProjectiveCap.Projective.quad_normal_form (by simp) hT h12' h13'
      (fun h => hq4.1 h.symm) h23' (fun h => hq4.2.1 h.symm)
      (fun h => hq4.2.2 h.symm)
  have hcard3 : Fintype.card (Fin 3) = Module.finrank GF16 (Fin 3 → GF16) := by simp
  let bu := basisOfLinearIndependentOfCardEqFinrank hu hcard3
  let bw := basisOfLinearIndependentOfCardEqFinrank hw hcard3
  let g : (Fin 3 → GF16) ≃ₗ[GF16] (Fin 3 → GF16) := bu.equiv bw (Equiv.refl _)
  have hcoeu : ⇑bu = u := coe_basisOfLinearIndependentOfCardEqFinrank _ _
  have hcoew : ⇑bw = w := coe_basisOfLinearIndependentOfCardEqFinrank _ _
  have hg : ∀ i : Fin 3, g (u i) = w i := by
    intro i
    have happ := Basis.equiv_apply (b := bu) (b' := bw) (e := Equiv.refl (Fin 3))
      (i := i)
    change g (bu i) = bw i at happ
    rwa [show bu i = u i from congrFun hcoeu i,
      show bw i = w i from congrFun hcoew i] at happ
  have hg4 : g p4.rep = q4.rep := by
    have hmap : g (u 0 + u 1 + u 2) = w 0 + w 1 + w 2 := by
      rw [map_add, map_add, hg 0, hg 1, hg 2]
    rwa [husum, hwsum] at hmap
  have e1 : ProjectiveCap.Projective.mapEquiv g p1 = q1 := by
    rw [← hp1, ← hq1]
    exact ProjectiveCap.Projective.mapEquiv_mk_eq_mk hu0 hw0 (hg 0)
  have e2 : ProjectiveCap.Projective.mapEquiv g p2 = q2 := by
    rw [← hp2, ← hq2]
    exact ProjectiveCap.Projective.mapEquiv_mk_eq_mk hu1 hw1 (hg 1)
  have e3 : ProjectiveCap.Projective.mapEquiv g p3 = q3 := by
    rw [← hp3, ← hq3]
    exact ProjectiveCap.Projective.mapEquiv_mk_eq_mk hu2 hw2 (hg 2)
  have e4 : ProjectiveCap.Projective.mapEquiv g p4 = q4 :=
    ProjectiveCap.Projective.mapEquiv_eq_of_rep_eq g hg4
  refine ⟨g, ?_⟩
  rw [Finset.map_insert, Finset.map_insert, Finset.map_insert, Finset.map_singleton,
    show ((ProjectiveCap.Projective.mapEquiv g).toEmbedding p1) =
      ProjectiveCap.Projective.mapEquiv g p1 from rfl,
    show ((ProjectiveCap.Projective.mapEquiv g).toEmbedding p2) =
      ProjectiveCap.Projective.mapEquiv g p2 from rfl,
    show ((ProjectiveCap.Projective.mapEquiv g).toEmbedding p3) =
      ProjectiveCap.Projective.mapEquiv g p3 from rfl,
    show ((ProjectiveCap.Projective.mapEquiv g).toEmbedding p4) =
      ProjectiveCap.Projective.mapEquiv g p4 from rfl,
    e1, e2, e3, e4]

theorem mapEquiv_trans_apply
    (e f : (Fin 3 → GF16) ≃ₗ[GF16] (Fin 3 → GF16)) (p : Point16) :
    ProjectiveCap.Projective.mapEquiv f (ProjectiveCap.Projective.mapEquiv e p) =
      ProjectiveCap.Projective.mapEquiv (e.trans f) p := by
  induction p using Projectivization.ind with
  | h v hv =>
      simp [ProjectiveCap.Projective.mapEquiv_mk, LinearEquiv.trans_apply]

noncomputable def mapConic (C : NonsingularConic (K := GF16))
    (e : (Fin 3 → GF16) ≃ₗ[GF16] (Fin 3 → GF16)) :
    NonsingularConic (K := GF16) where
  coordinateChange := C.coordinateChange.trans e

theorem points_mapConic (C : NonsingularConic (K := GF16))
    (e : (Fin 3 → GF16) ≃ₗ[GF16] (Fin 3 → GF16)) :
    C.points.map (ProjectiveCap.Projective.mapEquiv e).toEmbedding = (mapConic C e).points := by
  rw [NonsingularConic.points_eq_map_standard,
    NonsingularConic.points_eq_map_standard, Finset.map_map]
  congr 1
  ext p
  exact mapEquiv_trans_apply C.coordinateChange e p

theorem completeOutside_mapLinear
    (C : NonsingularConic (K := GF16))
    (e : (Fin 3 → GF16) ≃ₗ[GF16] (Fin 3 → GF16))
    {A : Finset Point16} (hA : CompleteOutside (L := Point16) A C.points) :
    CompleteOutside (L := Point16)
      (A.map (ProjectiveCap.Projective.mapEquiv e).toEmbedding) (mapConic C e).points := by
  rw [← points_mapConic]
  exact completeOutside_map (L := Point16) (ProjectiveCap.Projective.mapEquiv e)
    (fun x a b => by
      rw [ProjectiveBridge.collinear_iff_projective_collinear,
        ProjectiveCap.Projective.collinear_mapEquiv,
        ProjectiveBridge.collinear_iff_projective_collinear]) hA

/-! ## Algebraic form of the leaf obstructions -/

/-- Six checked independent evaluation rows force any homogeneous quadratic coefficient vector
vanishing on them to be zero.  This statement does not assume that the quadratic is nonsingular. -/
theorem FullRankReject.quadratic_eq_zero {r : FullRankReject}
    (hinv : FastInverseValid r) {q : Fin 6 → GF16}
    (hrow : ∀ i, dotProduct (monomial (vec (r.points i))) q = 0) : q = 0 := by
  have hmul : Matrix.mulVec r.matrix q = 0 := by
    funext i
    simpa [Matrix.mulVec, FullRankReject.matrix] using hrow i
  rw [← Matrix.one_mulVec q, ← fastInverseValid_sound hinv,
    ← Matrix.mulVec_mulVec, hmul, Matrix.mulVec_zero]

/-- A checked span relation transfers vanishing on the uncovered evaluation rows to the selected
hit point.  Thus it rejects any quadratic zero set disjoint from the selected arc, singular or
nonsingular. -/
theorem ForcedHitReject.quadratic_vanishes_at_hit {r : ForcedHitReject}
    (hspan : monomial (vec r.hit) =
      ∑ i, GF16.ofNat (r.coeffs i).1 • monomial (vec (r.points i)))
    {q : Fin 6 → GF16}
    (hrow : ∀ i, dotProduct (monomial (vec (r.points i))) q = 0) :
    dotProduct (monomial (vec r.hit)) q = 0 := by
  rw [hspan]
  calc
    dotProduct (∑ i, GF16.ofNat (r.coeffs i).1 • monomial (vec (r.points i))) q =
        ∑ i, GF16.ofNat (r.coeffs i).1 *
          dotProduct (monomial (vec (r.points i))) q := dotProduct_sum_smul _ _ _
    _ = 0 := by simp_rw [hrow, mul_zero]; exact Finset.sum_const_zero

theorem classifiedAt_level8_of_frame
    {S : Finset Idx} (hframe : Frame16 ⊆ S) (hcard : S.card = 8) (hcap : RawCap S)
    {books4 : List (StepBook level5)} {books5 : List (StepBook level6)}
    {books6 : List (StepBook level7)} {books7 : List (StepBook level8)}
    (h4 : StepBooksValid level4 level5 books4)
    (h5 : StepBooksValid level5 level6 books5)
    (h6 : StepBooksValid level6 level7 books6)
    (h7 : StepBooksValid level7 level8 books7) : ClassifiedAt level8 S := by
  have hframeCard : Frame16.card = 4 := by decide
  have hdiffCard : (S \ Frame16).card = 4 := by
    rw [Finset.card_sdiff, Finset.inter_eq_left.mpr hframe, hcard, hframeCard]
  obtain ⟨x1, x2, x3, x4, h12, h13, h14, h23, h24, h34, hdiff⟩ :=
    Finset.card_eq_four.mp hdiffCard
  have hx1d : x1 ∈ S \ Frame16 := by rw [hdiff]; simp
  have hx2d : x2 ∈ S \ Frame16 := by rw [hdiff]; simp
  have hx3d : x3 ∈ S \ Frame16 := by rw [hdiff]; simp
  have hx4d : x4 ∈ S \ Frame16 := by rw [hdiff]; simp
  have hx1F : x1 ∉ Frame16 := (Finset.mem_sdiff.mp hx1d).2
  have hx2F : x2 ∉ Frame16 := (Finset.mem_sdiff.mp hx2d).2
  have hx3F : x3 ∉ Frame16 := (Finset.mem_sdiff.mp hx3d).2
  have hx4F : x4 ∉ Frame16 := (Finset.mem_sdiff.mp hx4d).2
  have hx1 : x1 ∉ Frame16 := hx1F
  have hx2 : x2 ∉ insert x1 Frame16 := by simp [h12.symm, hx2F]
  have hx3 : x3 ∉ insert x2 (insert x1 Frame16) := by
    simp [h13.symm, h23.symm, hx3F]
  have hx4 : x4 ∉ insert x3 (insert x2 (insert x1 Frame16)) := by
    simp [h14.symm, h24.symm, h34.symm, hx4F]
  have hS : S = insert x4 (insert x3 (insert x2 (insert x1 Frame16))) := by
    apply Finset.Subset.antisymm
    · intro x hx
      by_cases hf : x ∈ Frame16
      · exact Finset.mem_insert_of_mem (Finset.mem_insert_of_mem
          (Finset.mem_insert_of_mem (Finset.mem_insert_of_mem hf)))
      · have : x ∈ S \ Frame16 := by simp [hx, hf]
        rw [hdiff] at this
        simp only [Finset.mem_insert, Finset.mem_singleton] at this ⊢
        tauto
    · intro x hx
      simp only [Finset.mem_insert] at hx
      rcases hx with rfl | rfl | rfl | rfl | hx
      · exact (Finset.mem_sdiff.mp (by rw [hdiff]; simp)).1
      · exact (Finset.mem_sdiff.mp (by rw [hdiff]; simp)).1
      · exact (Finset.mem_sdiff.mp (by rw [hdiff]; simp)).1
      · exact (Finset.mem_sdiff.mp (by rw [hdiff]; simp)).1
      · exact hframe (by simpa [Frame16] using hx)
  have hbase : ClassifiedAt level4 Frame16 := by
    refine ⟨Frame16, ?_, rawProjectiveEquiv_refl _⟩
    simp [level4]
  have hs1 : insert x1 Frame16 ⊆ S := by
    rw [hS]
    intro y hy
    simp only [Finset.mem_insert] at hy ⊢
    tauto
  have hs2 : insert x2 (insert x1 Frame16) ⊆ S := by
    rw [hS]
    intro y hy
    simp only [Finset.mem_insert] at hy ⊢
    tauto
  have hs3 : insert x3 (insert x2 (insert x1 Frame16)) ⊆ S := by
    rw [hS]
    intro y hy
    simp only [Finset.mem_insert] at hy ⊢
    tauto
  have c5 := hbase.extendStep h4 hx1 (rawCap_mono hs1 hcap)
  have c6 := c5.extendStep h5 hx2 (rawCap_mono hs2 hcap)
  have c7 := c6.extendStep h6 hx3 (rawCap_mono hs3 hcap)
  have c8 := c7.extendStep h7 hx4 (by simpa [← hS] using hcap)
  simpa [hS] using c8

/-- If the four generated transition layers and all leaves validate, no eight-point relative
complete arc exists over `GF(16)`. -/
theorem no_completeOutside_card_eight
    {books4 : List (StepBook level5)} {books5 : List (StepBook level6)}
    {books6 : List (StepBook level7)} {books7 : List (StepBook level8)}
    {leaves : List RejectedLeaf}
    (h4 : StepBooksValid level4 level5 books4)
    (h5 : StepBooksValid level5 level6 books5)
    (h6 : StepBooksValid level6 level7 books6)
    (h7 : StepBooksValid level7 level8 books7)
    (hleaves : RejectsLevel level8 leaves)
    (C : NonsingularConic (K := GF16)) {A : Finset Point16}
    (hA : CompleteOutside (L := Point16) A C.points) (hcard : A.card = 8) : False := by
  obtain ⟨T, hTA, hTcard⟩ := Finset.exists_subset_card_eq (s := A) (n := 4) (by omega)
  have hcapA : ProjectiveCap.Projective.Cap GF16 (Fin 3 → GF16) A :=
    (ProjectiveBridge.arc_iff_projectiveCap A).mp hA.1
  have hcapT : ProjectiveCap.Projective.Cap GF16 (Fin 3 → GF16) T :=
    ProjectiveCap.Projective.cap_mono hTA hcapA
  have hframeRaw : RawCap Frame16 := by
    intro a ha b hb c hc hab hac hbc
    simp only [Frame16, Finset.mem_insert, Finset.mem_singleton] at ha hb hc
    rcases ha with rfl | rfl | rfl | rfl <;>
      rcases hb with rfl | rfl | rfl | rfl <;>
      rcases hc with rfl | rfl | rfl | rfl <;> simp_all <;> decide
  have hcapFrame : ProjectiveCap.Projective.Cap GF16 (Fin 3 → GF16)
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
  have hcapB : ProjectiveCap.Projective.Cap GF16 (Fin 3 → GF16) B := by
    exact (ProjectiveCap.Projective.cap_map_mapEquiv g A).2 hcapA
  have hcapS : RawCap S := (rawCap_iff_projectiveCap S).2 (by simpa [hpointS] using hcapB)
  obtain ⟨leaf, hleaf, e, he⟩ :=
    classifiedAt_level8_of_frame hframeS hScard hcapS h4 h5 h6 h7
  have hcompleteB := completeOutside_mapLinear C g hA
  have hcompleteS : CompleteOutside (L := Point16) (pointSetIdx S) (mapConic C g).points := by
    simpa [hpointS, B] using hcompleteB
  have hcompleteLeaf := completeOutside_mapLinear (mapConic C g) e hcompleteS
  exact hleaves.not_complete hleaf (mapConic (mapConic C g) e) (by simpa [he] using hcompleteLeaf)

end Q16Classification
end RelativeConicArcs
