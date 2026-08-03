import RelativeConicArcs.Certificate
import ProjectiveCap.PlaneTransitivityGame

/-!
# The order-five six-arc exclusion

This is a strict-kernel proof that every six-arc in `PG(2,5)` is complete, and hence cannot have
six uncovered points.  Four-cap transitivity sends four selected points to the standard frame.
Only the two remaining selected points and one proposed extension are then enumerated, over the
31 canonical projective points.  The finite leaf uses `decide`, never `native_decide`.
-/

open scoped LinearAlgebra.Projectivization

namespace RelativeConicArcs
namespace Q5SixArcExclusion

open Certificate ProjectiveBridge Projectivization

set_option maxHeartbeats 10000000
set_option maxRecDepth 100000

local instance : Fact (Nat.Prime 5) := ⟨by decide⟩

abbrev K := ZMod 5
abbrev P5Point := ProjectiveCap.Projective.Point K (Fin 3 → K)

/-- The three canonical coordinate charts of `PG(2,5)`. -/
inductive Idx where
  | affine (y z : K)
  | infinity (z : K)
  | vertical
deriving DecidableEq, Fintype

def vec : Idx → Fin 3 → K
  | .affine y z => ![1, y, z]
  | .infinity z => ![0, 1, z]
  | .vertical => ![0, 0, 1]

theorem vec_ne_zero (i : Idx) : vec i ≠ 0 := by
  cases i <;> intro h
  · have := congrFun h 0
    simp [vec] at this
  · have := congrFun h 1
    simp [vec] at this
  · have := congrFun h 2
    simp [vec] at this

def rawPoint (i : Idx) : RawPoint K := ⟨vec i, vec_ne_zero i⟩
def point (i : Idx) : P5Point := toPoint (rawPoint i)

theorem rayEq_vec_iff_eq (i j : Idx) : RayEq (vec i) (vec j) ↔ i = j := by
  constructor
  · rintro ⟨a, ha⟩
    cases i with
    | affine y z =>
        cases j with
        | affine y' z' =>
            have h0 := congrFun ha 0
            have h1 := congrFun ha 1
            have h2 := congrFun ha 2
            simp only [vec, Pi.smul_apply, smul_eq_mul, Matrix.cons_val_zero,
              Matrix.cons_val_one, Matrix.cons_val_two, Matrix.head_cons,
              Matrix.tail_cons] at h0 h1 h2
            have ha1 : a = 1 := by simpa using h0
            subst a
            simp only [one_mul] at h1 h2
            simp [h1, h2]
        | infinity z' =>
            have h0 := congrFun ha 0
            simp [vec] at h0
        | vertical =>
            have h0 := congrFun ha 0
            simp [vec] at h0
    | infinity z =>
        cases j with
        | affine y' z' =>
            have h0 := congrFun ha 0
            have h1 := congrFun ha 1
            simp [vec] at h0
            rw [h0] at h1
            simp [vec] at h1
        | infinity z' =>
            have h1 := congrFun ha 1
            have h2 := congrFun ha 2
            simp only [vec, Pi.smul_apply, smul_eq_mul, Matrix.cons_val_one,
              Matrix.cons_val_two, Matrix.head_cons, Matrix.tail_cons] at h1 h2
            have ha1 : a = 1 := by simpa using h1
            subst a
            simp only [one_mul] at h2
            simp [h2]
        | vertical =>
            have h1 := congrFun ha 1
            simp [vec] at h1
    | vertical =>
        cases j with
        | affine y' z' =>
            have h0 := congrFun ha 0
            have h2 := congrFun ha 2
            simp [vec] at h0
            rw [h0] at h2
            simp [vec] at h2
        | infinity z' =>
            have h1 := congrFun ha 1
            have h2 := congrFun ha 2
            simp [vec] at h1
            rw [h1] at h2
            simp [vec] at h2
        | vertical => rfl
  · rintro rfl
    exact ⟨1, by simp⟩

theorem point_injective : Function.Injective point := by
  intro i j hij
  exact (rayEq_vec_iff_eq i j).mp ((rayEq_iff_mk_eq (rawPoint i) (rawPoint j)).mpr hij)

theorem card_point : Nat.card P5Point = 31 := by
  rw [Projectivization.card_of_finrank K (Fin 3 → K) (n := 3) (by simp)]
  norm_num [Finset.sum_range_succ]

theorem card_idx : Fintype.card Idx = 31 := by decide

noncomputable local instance : Fintype P5Point := Fintype.ofFinite _
noncomputable local instance : DecidableEq P5Point := Classical.decEq _

/-- The canonical charts exhaust the abstract projective plane. -/
noncomputable def pointEquiv : Idx ≃ P5Point :=
  Equiv.ofBijective point ((Fintype.bijective_iff_injective_and_card point).2
    ⟨point_injective, by rw [card_idx, ← Nat.card_eq_fintype_card, card_point]⟩)

@[simp] theorem pointEquiv_apply (i : Idx) : pointEquiv i = point i := rfl

noncomputable def pointSetIdx (S : Finset Idx) : Finset P5Point :=
  S.map pointEquiv.toEmbedding

/-- Coordinate cap validity on canonical representatives. -/
def RawCap (S : Finset Idx) : Prop :=
  ∀ a ∈ S, ∀ b ∈ S, ∀ c ∈ S,
    a ≠ b → a ≠ c → b ≠ c → Matrix.det ![vec a, vec b, vec c] ≠ 0

instance (S : Finset Idx) : Decidable (RawCap S) := by
  unfold RawCap
  infer_instance

theorem rawCap_iff_projectiveCap (S : Finset Idx) :
    RawCap S ↔ ProjectiveCap.Projective.Cap K (Fin 3 → K) (pointSetIdx S) := by
  let xs := S.toList.map rawPoint
  have hpoint : pointSet xs = pointSetIdx S := by
    classical
    ext p
    rw [mem_pointSet]
    constructor
    · rintro ⟨v, hv, rfl⟩
      obtain ⟨i, hi, rfl⟩ := List.mem_map.mp hv
      exact Finset.mem_map.mpr ⟨i, by simpa using hi, rfl⟩
    · intro hp
      obtain ⟨i, hi, hip⟩ := Finset.mem_map.mp hp
      exact ⟨rawPoint i, List.mem_map.mpr ⟨i, by simpa using hi, rfl⟩, hip⟩
  have hraw : RawArc xs ↔ RawCap S := by
    classical
    unfold RawArc RawCap xs
    simp only [List.mem_map, Finset.mem_toList]
    constructor
    · intro h a ha b hb c hc hab hac hbc
      exact h (rawPoint a) ⟨a, ha, rfl⟩ (rawPoint b) ⟨b, hb, rfl⟩
        (rawPoint c) ⟨c, hc, rfl⟩
        ((rayEq_eq_false_iff _ _).2 (fun hr => hab ((rayEq_vec_iff_eq a b).1 hr)))
        ((rayEq_eq_false_iff _ _).2 (fun hr => hac ((rayEq_vec_iff_eq a c).1 hr)))
        ((rayEq_eq_false_iff _ _).2 (fun hr => hbc ((rayEq_vec_iff_eq b c).1 hr)))
    · intro h va hva vb hvb vc hvc hab hac hbc
      obtain ⟨a, ha, rfl⟩ := hva
      obtain ⟨b, hb, rfl⟩ := hvb
      obtain ⟨c, hc, rfl⟩ := hvc
      exact h a ha b hb c hc
        (fun e => by subst b; exact (rayEq_eq_false_iff _ _).1 hab ⟨1, by simp⟩)
        (fun e => by subst c; exact (rayEq_eq_false_iff _ _).1 hac ⟨1, by simp⟩)
        (fun e => by subst c; exact (rayEq_eq_false_iff _ _).1 hbc ⟨1, by simp⟩)
  rw [← hpoint, ← rawArc_iff_projectiveCap, hraw]

/-- The standard projective four-frame. -/
def frame : Finset Idx :=
  {.affine 0 0, .infinity 0, .vertical, .affine 1 1}

theorem frame_card : frame.card = 4 := by decide
theorem frame_rawCap : RawCap frame := by decide

/-- The only exhaustive computation: two points extending the standard frame, followed by one
proposed seventh point. -/
theorem normalized_six_cap_has_no_extension :
    ∀ x y z : Idx,
      (insert x (insert y frame)).card = 6 →
      RawCap (insert x (insert y frame)) →
      z ∉ insert x (insert y frame) →
      ¬ RawCap (insert z (insert x (insert y frame))) := by
  decide

theorem frame_six_cap_has_no_extension
    {S : Finset Idx} (hframe : frame ⊆ S) (hcard : S.card = 6)
    (hcap : RawCap S) {z : Idx} (hz : z ∉ S) :
    ¬ RawCap (insert z S) := by
  have hdiffcard : (S \ frame).card = 2 := by
    rw [Finset.card_sdiff_of_subset hframe, hcard, frame_card]
  obtain ⟨x, y, hxy, hdiff⟩ := Finset.card_eq_two.mp hdiffcard
  have hS : S = insert x (insert y frame) := by
    calc
      S = (S \ frame) ∪ frame := (Finset.sdiff_union_of_subset hframe).symm
      _ = ({x, y} : Finset Idx) ∪ frame := by rw [hdiff]
      _ = insert x (insert y frame) := by ext i; simp
  rw [hS] at hcard hcap hz ⊢
  exact normalized_six_cap_has_no_extension x y z hcard hcap hz

/-- Every six-point projective cap over `ZMod 5` is maximal. -/
theorem six_projectiveCap_order_five_maximal
    {A : Finset P5Point} (hA : ProjectiveCap.Projective.Cap K (Fin 3 → K) A)
    (hcard : A.card = 6) {p : P5Point} (hp : p ∉ A) :
    ¬ ProjectiveCap.Projective.Cap K (Fin 3 → K) (insert p A) := by
  obtain ⟨T, hTA, hTcard⟩ := Finset.exists_subset_card_eq (s := A) (n := 4) (by omega)
  have hTcap := ProjectiveCap.Projective.cap_mono hTA hA
  have hFrameCap : ProjectiveCap.Projective.Cap K (Fin 3 → K) (pointSetIdx frame) :=
    (rawCap_iff_projectiveCap frame).mp frame_rawCap
  obtain ⟨e, hecap, heT⟩ :=
    ProjectiveCap.Projective.capTransitiveStatement_four (K := K) (V := Fin 3 → K)
      (S := T) (T := pointSetIdx frame) (by simp) hTcap hFrameCap hTcard (by
        change (frame.map pointEquiv.toEmbedding).card = 4
        rw [Finset.card_map, frame_card])
  let B := A.map e.toEmbedding
  let S := B.map pointEquiv.symm.toEmbedding
  have hpointS : pointSetIdx S = B := by
    ext q
    simp [S, pointSetIdx, Finset.mem_map_equiv]
  have hframeS : frame ⊆ S := by
    intro i hi
    have hip : pointEquiv i ∈ pointSetIdx frame := Finset.mem_map.mpr ⟨i, hi, rfl⟩
    rw [← heT] at hip
    have hiB : pointEquiv i ∈ B :=
      Finset.mem_of_subset (Finset.map_subset_map.mpr hTA) hip
    have his : pointEquiv.symm (pointEquiv i) ∈ S :=
      Finset.mem_map.mpr ⟨pointEquiv i, hiB, rfl⟩
    rw [pointEquiv.symm_apply_apply] at his
    exact his
  have hScard : S.card = 6 := by simp [S, B, hcard]
  have hBcap : ProjectiveCap.Projective.Cap K (Fin 3 → K) B := (hecap A).2 hA
  have hScap : RawCap S := (rawCap_iff_projectiveCap S).2 (by simpa [hpointS] using hBcap)
  have hep : e p ∉ B := by simp [B, hp]
  have heps : pointEquiv.symm (e p) ∉ S := by simp [S, hep]
  have hnot := frame_six_cap_has_no_extension hframeS hScard hScap heps
  intro hins
  apply hnot
  apply (rawCap_iff_projectiveCap _).2
  have hpointsInsert :
      pointSetIdx (insert (pointEquiv.symm (e p)) S) = insert (e p) B := by
    rw [pointSetIdx, Finset.map_insert]
    change insert (pointEquiv (pointEquiv.symm (e p)))
      (S.map pointEquiv.toEmbedding) = insert (e p) B
    rw [Equiv.apply_symm_apply]
    change insert (e p) (pointSetIdx S) = insert (e p) B
    rw [hpointS]
  rw [hpointsInsert]
  have hcap := (hecap (insert p A)).2 hins
  simpa [B, Finset.map_insert] using hcap

/-- **Order-five exclusion.** The ordinary uncovered locus of every six-arc in `PG(2,5)` is
empty.  In particular it cannot have conic cardinality six. -/
theorem six_arc_order_five_uncovered_empty
    {A : Finset P5Point} (hA : Arc (L := P5Point) A) (hcard : A.card = 6) :
    uncovered (L := P5Point) A ∅ = ∅ := by
  have hcomplete : CompleteOutside (L := P5Point) A ∅ := by
    refine ⟨hA, by simp, ?_⟩
    intro p hp _
    by_contra hcovered
    have hinsertArc : Arc (L := P5Point) (insert p A) :=
      arc_insert_of_not_covered hA hcovered
    exact six_projectiveCap_order_five_maximal
      ((ProjectiveBridge.arc_iff_projectiveCap A).mp hA) hcard hp
      ((ProjectiveBridge.arc_iff_projectiveCap (insert p A)).mp hinsertArc)
  exact ((completeOutside_iff_uncovered_eq_empty (L := P5Point)).mp hcomplete).2.2

theorem no_six_arc_order_five_with_six_uncovered
    {A : Finset P5Point} (hA : Arc (L := P5Point) A) (hcard : A.card = 6) :
    (uncovered (L := P5Point) A ∅).card ≠ 6 := by
  rw [six_arc_order_five_uncovered_empty hA hcard]
  decide

#print axioms normalized_six_cap_has_no_extension
#print axioms six_arc_order_five_uncovered_empty

end Q5SixArcExclusion
end RelativeConicArcs
