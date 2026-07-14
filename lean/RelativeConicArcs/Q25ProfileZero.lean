import RelativeConicArcs.QuadraticInvisible
import RelativeConicArcs.BaerArithmetic

/-!
# The zero-fixed-point profile over `PG(2,25)`

This file partitions the external points of an invariant arc according to the unique fixed carrier
of each nonfixed point.  It is the geometric bookkeeping layer for the `(f,e)=(0,4)` second-moment
argument.
-/

namespace RelativeConicArcs
namespace Q25ProfileZero

noncomputable section

open Configuration Finset
open FiniteGeom.BaerCompletion
open QuadraticFrobenius QuadraticLineCounting QuadraticForbidden QuadraticCollision
  QuadraticInvisible

variable (F E : Type) [Field F] [Fintype F] [Field E] [Finite E] [Algebra F E]
  [Algebra.IsAlgebraic F E]

abbrev Point := ProjectiveConjugation.Point E

local instance : Fintype E := Fintype.ofFinite E
local instance : DecidableEq E := Classical.decEq E
local instance : DecidableEq (Point E) := Classical.decEq _
local instance : DecidableEq (FixedProjectivePoint F E) := Classical.decEq _
local instance : DecidableRel fun p l : Point E => p.orthogonal l := Classical.decRel _

/-- External points fixed by quadratic Frobenius. -/
noncomputable def fixedExternalPoints
    (hdeg : Module.finrank F E = 2) (C : Finset (Point E)) : Finset (Point E) :=
  (Finset.univ \ C).filter fun x => (incidence F E hdeg).pointConj x = x

/-- External nonfixed points whose unique fixed carrier is occupied by the arc. -/
noncomputable def occupiedNonfixedExternalPoints
    (hdeg : Module.finrank F E = 2) (C : Finset (Point E)) : Finset (Point E) :=
  by
    classical
    exact (Finset.univ \ C).filter fun x =>
      (incidence F E hdeg).pointConj x ≠ x ∧
        ∃ m ∈ occupiedFixedLines F E C, x ∈ m.1

/-- External nonfixed points whose unique fixed carrier is empty. -/
noncomputable def emptyNonfixedExternalPoints
    (hdeg : Module.finrank F E = 2) (C : Finset (Point E)) : Finset (Point E) :=
  by
    classical
    exact (Finset.univ \ C).filter fun x =>
      (incidence F E hdeg).pointConj x ≠ x ∧
        ∃ m ∈ emptyFixedLines F E C, x ∈ m.1

/-- Fixed ambient points incident with an ambient line. -/
noncomputable def fixedPointsOnLineFinset
    (hdeg : Module.finrank F E = 2) (l : Point E) : Finset (Point E) := by
  classical
  exact Finset.univ.filter fun x =>
    (incidence F E hdeg).pointConj x = x ∧ x ∈ l

/-- A nonfixed ambient line contains at most one Frobenius-fixed point. -/
theorem card_fixedPointsOnLineFinset_le_one_of_nonfixed
    (hdeg : Module.finrank F E = 2) (l : Point E)
    (hl : (incidence F E hdeg).lineConj l ≠ l) :
    (fixedPointsOnLineFinset F E hdeg l).card ≤ 1 := by
  classical
  by_contra hcard
  have hlt : 1 < (fixedPointsOnLineFinset F E hdeg l).card := by omega
  obtain ⟨x, hx, y, hy, hxy⟩ := Finset.one_lt_card.mp hlt
  have hx' := Finset.mem_filter.mp hx
  have hy' := Finset.mem_filter.mp hy
  have hxconj : x ∈ (incidence F E hdeg).lineConj l := by
    have hc := ((incidence F E hdeg).incident_conj_iff x l).2 hx'.2.2
    rw [hx'.2.1] at hc
    change x.orthogonal ((incidence F E hdeg).lineConj l) at hc
    exact hc
  have hyconj : y ∈ (incidence F E hdeg).lineConj l := by
    have hc := ((incidence F E hdeg).incident_conj_iff y l).2 hy'.2.2
    rw [hy'.2.1] at hc
    change y.orthogonal ((incidence F E hdeg).lineConj l) at hc
    exact hc
  exact hl ((Configuration.Nondegenerate.eq_or_eq hx'.2.2 hy'.2.2 hxconj hyconj).resolve_left
    hxy).symm

/-- A fixed line over a base field of order five contains exactly six fixed points. -/
theorem card_fixedPointsOnLineFinset_eq_six_of_fixed
    (hdeg : Module.finrank F E = 2) (hF : Nat.card F = 5) (l : Point E)
    (hl : (incidence F E hdeg).lineConj l = l) :
    (fixedPointsOnLineFinset F E hdeg l).card = 6 := by
  classical
  let fl : FixedProjectivePoint F E := ⟨l, hl⟩
  let toFixed : {x // x ∈ fixedPointsOnLineFinset F E hdeg l} →
      FixedPointsOnFixedLine F E fl := fun x =>
    ⟨⟨x.1, (Finset.mem_filter.mp x.2).2.1⟩, (Finset.mem_filter.mp x.2).2.2⟩
  let fromFixed : FixedPointsOnFixedLine F E fl →
      {x // x ∈ fixedPointsOnLineFinset F E hdeg l} := fun x =>
    ⟨x.1.1, Finset.mem_filter.mpr ⟨Finset.mem_univ _, x.1.2, x.2⟩⟩
  let e : {x // x ∈ fixedPointsOnLineFinset F E hdeg l} ≃
      FixedPointsOnFixedLine F E fl :=
    { toFun := toFixed
      invFun := fromFixed
      left_inv := fun _ => rfl
      right_inv := fun _ => rfl }
  rw [← Fintype.card_coe, ← Nat.card_eq_fintype_card, Nat.card_congr e,
    natCard_fixedPointsOnFixedLine F E hdeg fl, hF]

/-- A nonfixed old secant contains exactly its Frobenius-fixed orbit center among the fixed
ambient points. -/
theorem card_fixedPointsOnLineFinset_eq_one_of_nonfixedArcPair
    (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C)
    (a : NonfixedArcPair F E C hC) :
    (fixedPointsOnLineFinset F E hdeg (a.1.line (L := Point E))).card = 1 := by
  classical
  apply Nat.le_antisymm
  · exact card_fixedPointsOnLineFinset_le_one_of_nonfixed F E hdeg _
      (fun hline => a.2
        ((conjugateArcPair_eq_iff_line_fixed F E hdeg C hArc hC a.1).2 hline))
  · apply Finset.card_pos.mpr
    refine ⟨secantOrbitCenter F E hdeg C hArc hC a, Finset.mem_filter.mpr ⟨
      Finset.mem_univ _, secantOrbitCenter_fixed F E hdeg C hArc hC a, ?_⟩⟩
    exact secantOrbitCenter_mem_pairLine F E hdeg C hArc hC a

/-- The invariant endpoint pairs, represented as a finset rather than a subtype. -/
noncomputable def invariantArcPairsFinset
    (hdeg : Module.finrank F E = 2) (C : Finset (Point E))
    (hC : IsInvariant (incidence F E hdeg) C) : Finset (ArcPair C) := by
  classical
  exact Finset.univ.filter fun a => conjugateArcPair F E C hC a = a

theorem card_invariantArcPairsFinset_profile_zero
    (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hC : IsInvariant (incidence F E hdeg) C)
    (hcard : C.card = 8) (hfixed : (fixedArcPoints F E C).card = 0) :
    (invariantArcPairsFinset F E hdeg C hC).card = 4 := by
  classical
  have hnonfixed : Nat.card (NonfixedArcPoint F E C) = 8 := by
    rw [natCard_nonfixedArcPoint F E C, hcard, hfixed]
  have hinvariant := natCard_invariantArcPair F E C hC
  rw [natCard_fixedInvariantArcPair F E C hC,
    natCard_conjugateInvariantArcPair F E C hC 4 hnonfixed, hfixed] at hinvariant
  change ((Finset.univ : Finset (ArcPair C)).filter
    (fun a => conjugateArcPair F E C hC a = a)).card = 4
  rw [← Fintype.card_subtype]
  change Fintype.card (InvariantArcPair F E C hC) = 4
  rw [← Nat.card_eq_fintype_card, hinvariant]
  norm_num

/-- With no fixed selected points, the occupied fixed lines are exactly the four double (mate)
lines. -/
theorem occupiedFixedLines_eq_doubleFixedLines_profile_zero
    (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C)
    (hcard : C.card = 8) (hfixed : (fixedArcPoints F E C).card = 0) :
    occupiedFixedLines F E C = doubleFixedLines F E C := by
  apply Finset.Subset.antisymm
  · have hoccCard : (occupiedFixedLines F E C).card = 4 := by
      rw [card_occupiedFixedLines F E hdeg C hArc hC 0 4 hfixed (by omega)]
      norm_num
    have hdoubleCard : (doubleFixedLines F E C).card = 4 := by
      rw [card_doubleFixedLines F E C hArc hC 0 4 hfixed (by omega)]
      norm_num
    have hsub : doubleFixedLines F E C ⊆ occupiedFixedLines F E C := by
      intro l hl
      have hl' := Finset.mem_filter.mp hl
      apply Finset.mem_filter.mpr
      refine ⟨hl'.1, ?_⟩
      rw [Finset.nonempty_iff_ne_empty]
      intro hempty
      have : (fixedLineTrace F E C l).card = 0 := by simp [hempty]
      omega
    exact Finset.eq_of_subset_of_card_le hsub (by omega) |>.symm.subset
  · intro l hl
    have hl' := Finset.mem_filter.mp hl
    apply Finset.mem_filter.mpr
    refine ⟨hl'.1, ?_⟩
    rw [Finset.nonempty_iff_ne_empty]
    intro hempty
    have : (fixedLineTrace F E C l).card = 0 := by simp [hempty]
    omega

/-- Invariant secants through an external point. -/
noncomputable def invariantPairsThrough
    (hdeg : Module.finrank F E = 2) (C : Finset (Point E))
    (hC : IsInvariant (incidence F E hdeg) C) (x : Point E) : Finset (ArcPair C) :=
  (pairsThrough (L := Point E) C x).filter fun a => conjugateArcPair F E C hC a = a

/-- Nonfixed secants through an external point. -/
noncomputable def nonfixedPairsThrough
    (hdeg : Module.finrank F E = 2) (C : Finset (Point E))
    (hC : IsInvariant (incidence F E hdeg) C) (x : Point E) : Finset (ArcPair C) :=
  (pairsThrough (L := Point E) C x).filter fun a => conjugateArcPair F E C hC a ≠ a

/-- Every occupied external nonfixed point lies on exactly one invariant secant: the mate line
that is its unique fixed carrier. -/
theorem card_invariantPairsThrough_eq_one_profile_zero
    (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C)
    (hcard : C.card = 8) (hfixed : (fixedArcPoints F E C).card = 0)
    (x : Point E) (hx : x ∈ occupiedNonfixedExternalPoints F E hdeg C) :
    (invariantPairsThrough F E hdeg C hC x).card = 1 := by
  classical
  change ((pairsThrough (L := Point E) C x).filter
    (fun a => conjugateArcPair F E C hC a = a)).card = 1
  have hxparts := Finset.mem_filter.mp hx
  obtain ⟨m, hmocc, hxm⟩ := hxparts.2.2
  have hmdouble : m ∈ doubleFixedLines F E C := by
    rw [← occupiedFixedLines_eq_doubleFixedLines_profile_zero
      F E hdeg C hArc hC hcard hfixed]
    exact hmocc
  let dm : {m // m ∈ doubleFixedLines F E C} := ⟨m, hmdouble⟩
  let a : ArcPair C := doubleLineToPair F E C dm
  have hamem : a ∈ (pairsThrough (L := Point E) C x).filter
      (fun b => conjugateArcPair F E C hC b = b) := by
    apply Finset.mem_filter.mpr
    constructor
    · apply mem_pairsThrough.mpr
      rw [doubleLineToPair_line F E C dm]
      exact hxm
    · exact doubleLineToPair_invariant F E C hArc hC dm
  have hall : ∀ b ∈ (pairsThrough (L := Point E) C x).filter
      (fun b => conjugateArcPair F E C hC b = b), b = a := by
    intro b hb
    have hb' := Finset.mem_filter.mp hb
    apply ArcPair.line_injective hArc
    have hbfix := (conjugateArcPair_eq_iff_line_fixed F E hdeg C hArc hC b).1 hb'.2
    have hxb : x ∈ b.line (L := Point E) := mem_pairsThrough.mp hb'.1
    have hlines : b.line (L := Point E) = m.1 := by
      let bl : FixedProjectivePoint F E := ⟨b.line (L := Point E), hbfix⟩
      have hσxm : (incidence F E hdeg).pointConj x ∈ m.1 := by
        have hc := ((incidence F E hdeg).incident_conj_iff x m.1).2 hxm
        change ProjectiveConjugation.projectiveEquiv (frobeniusRingEquiv F E) x ∈
          ProjectiveConjugation.projectiveEquiv (frobeniusRingEquiv F E) m.1 at hc
        rw [m.2] at hc
        exact hc
      have hσxb : (incidence F E hdeg).pointConj x ∈ b.line (L := Point E) := by
        have hc := ((incidence F E hdeg).incident_conj_iff x
          (b.line (L := Point E))).2 hxb
        rw [hbfix] at hc
        change (incidence F E hdeg).pointConj x ∈ b.line (L := Point E) at hc
        exact hc
      exact (Configuration.Nondegenerate.eq_or_eq hxb hσxb hxm hσxm).resolve_left
        (Ne.symm hxparts.2.1)
    rw [hlines, doubleLineToPair_line F E C dm]
  apply Finset.card_eq_one.mpr
  exact ⟨a, by
    ext b
    constructor
    · intro hb
      exact Finset.mem_singleton.mpr (hall b hb)
    · intro hb
      rw [Finset.mem_singleton] at hb
      simpa [hb] using hamem⟩

/-- At an occupied external nonfixed point, the full secant index is one plus the number of
nonfixed secants through it. -/
theorem pointIndex_eq_one_add_card_nonfixedPairsThrough_profile_zero
    (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C)
    (hcard : C.card = 8) (hfixed : (fixedArcPoints F E C).card = 0)
    (x : Point E) (hx : x ∈ occupiedNonfixedExternalPoints F E hdeg C) :
    pointIndex (L := Point E) C x =
      1 + (nonfixedPairsThrough F E hdeg C hC x).card := by
  rw [pointIndex_eq_card_pairsThrough hArc]
  have hpart := Finset.card_filter_add_card_filter_not
    (s := pairsThrough (L := Point E) C x)
    (fun a => conjugateArcPair F E C hC a = a)
  change (invariantPairsThrough F E hdeg C hC x).card +
    (nonfixedPairsThrough F E hdeg C hC x).card =
      (pairsThrough (L := Point E) C x).card at hpart
  rw [card_invariantPairsThrough_eq_one_profile_zero F E hdeg C hArc hC
    hcard hfixed x hx] at hpart
  omega

/-- The unique occupied fixed carrier associated with an occupied external nonfixed point. -/
noncomputable def occupiedCarrierOfExternalNonfixed
    (hdeg : Module.finrank F E = 2) (C : Finset (Point E))
    (x : {x // x ∈ occupiedNonfixedExternalPoints F E hdeg C}) :
    FixedProjectivePoint F E := by
  classical
  exact Classical.choose (Finset.mem_filter.mp x.2).2.2

theorem occupiedCarrierOfExternalNonfixed_mem
    (hdeg : Module.finrank F E = 2) (C : Finset (Point E))
    (x : {x // x ∈ occupiedNonfixedExternalPoints F E hdeg C}) :
    occupiedCarrierOfExternalNonfixed F E hdeg C x ∈ occupiedFixedLines F E C := by
  classical
  exact (Classical.choose_spec (Finset.mem_filter.mp x.2).2.2).1

theorem occupiedCarrierOfExternalNonfixed_incident
    (hdeg : Module.finrank F E = 2) (C : Finset (Point E))
    (x : {x // x ∈ occupiedNonfixedExternalPoints F E hdeg C}) :
    x.1 ∈ (occupiedCarrierOfExternalNonfixed F E hdeg C x).1 := by
  classical
  exact (Classical.choose_spec (Finset.mem_filter.mp x.2).2.2).2

noncomputable def occupiedExternalPointsOnLine
    (hdeg : Module.finrank F E = 2) (C : Finset (Point E)) (l : Point E) :
    Finset (Point E) := by
  classical
  exact (occupiedNonfixedExternalPoints F E hdeg C).filter fun x => x ∈ l

/-- Ambient nonfixed points on one fixed line. -/
noncomputable def nonfixedPointsOnFixedLineAmbient
    (hdeg : Module.finrank F E = 2) (m : FixedProjectivePoint F E) :
    Finset (Point E) := by
  classical
  exact Finset.univ.filter fun x =>
    (incidence F E hdeg).pointConj x ≠ x ∧ x ∈ m.1

theorem card_nonfixedPointsOnFixedLineAmbient
    (hdeg : Module.finrank F E = 2) (hF : Nat.card F = 5)
    (m : FixedProjectivePoint F E) :
    (nonfixedPointsOnFixedLineAmbient F E hdeg m).card = 20 := by
  classical
  let toSub : {x // x ∈ nonfixedPointsOnFixedLineAmbient F E hdeg m} →
      NonfixedPointsOnFixedLine F E m := fun x =>
    ⟨⟨x.1, (Finset.mem_filter.mp x.2).2.2⟩, (Finset.mem_filter.mp x.2).2.1⟩
  let fromSub : NonfixedPointsOnFixedLine F E m →
      {x // x ∈ nonfixedPointsOnFixedLineAmbient F E hdeg m} := fun x =>
    ⟨x.1.1, Finset.mem_filter.mpr ⟨Finset.mem_univ _, x.2, x.1.2⟩⟩
  let e : {x // x ∈ nonfixedPointsOnFixedLineAmbient F E hdeg m} ≃
      NonfixedPointsOnFixedLine F E m :=
    { toFun := toSub
      invFun := fromSub
      left_inv := fun _ => rfl
      right_inv := fun _ => rfl }
  rw [← Fintype.card_coe, ← Nat.card_eq_fintype_card, Nat.card_congr e,
    natCard_nonfixedPointsOnFixedLine F E hdeg m, hF]
  norm_num

/-- Each occupied mate line contains 18 external nonfixed points in the profile-zero case. -/
theorem card_nonfixedExternalOn_occupiedLine_eq_eighteen
    (hdeg : Module.finrank F E = 2) (hF : Nat.card F = 5)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C)
    (hcard : C.card = 8) (hfixed : (fixedArcPoints F E C).card = 0)
    (m : FixedProjectivePoint F E) (hm : m ∈ occupiedFixedLines F E C) :
    (nonfixedPointsOnFixedLineAmbient F E hdeg m \ C).card = 18 := by
  classical
  have htrace : (fixedLineTrace F E C m).card = 2 := by
    have hmDouble : m ∈ doubleFixedLines F E C := by
      rw [← occupiedFixedLines_eq_doubleFixedLines_profile_zero
        F E hdeg C hArc hC hcard hfixed]
      exact hm
    exact (Finset.mem_filter.mp hmDouble).2
  have hfixedEmpty : fixedArcPoints F E C = ∅ := Finset.card_eq_zero.mp hfixed
  have hinter : nonfixedPointsOnFixedLineAmbient F E hdeg m ∩ C =
      fixedLineTrace F E C m := by
    ext x
    simp only [Finset.mem_inter, nonfixedPointsOnFixedLineAmbient, Finset.mem_filter,
      Finset.mem_univ, true_and, fixedLineTrace]
    constructor
    · rintro ⟨⟨_hxnon, hxm⟩, hxC⟩
      exact ⟨hxC, hxm⟩
    · rintro ⟨hxC, hxm⟩
      refine ⟨⟨?_, hxm⟩, hxC⟩
      intro hxfix
      have : x ∈ fixedArcPoints F E C := Finset.mem_filter.mpr ⟨hxC, hxfix⟩
      rw [hfixedEmpty] at this
      simp at this
  rw [Finset.card_sdiff, Finset.inter_comm C, hinter, htrace,
    card_nonfixedPointsOnFixedLineAmbient F E hdeg hF m]

/-- There are exactly `4·18=72` occupied external nonfixed points. -/
theorem card_occupiedNonfixedExternalPoints_eq_seventy_two
    (hdeg : Module.finrank F E = 2) (hF : Nat.card F = 5)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C)
    (hcard : C.card = 8) (hfixed : (fixedArcPoints F E C).card = 0) :
    (occupiedNonfixedExternalPoints F E hdeg C).card = 72 := by
  classical
  let fibers := fun m : FixedProjectivePoint F E =>
    nonfixedPointsOnFixedLineAmbient F E hdeg m \ C
  have hpairwise : ((occupiedFixedLines F E C : Finset (FixedProjectivePoint F E)) :
      Set (FixedProjectivePoint F E)).PairwiseDisjoint fibers := by
    intro m _hm n _hn hmn
    change Disjoint (fibers m) (fibers n)
    rw [Finset.disjoint_left]
    intro x hxm hxn
    have hxm' := Finset.mem_sdiff.mp hxm
    have hxn' := Finset.mem_sdiff.mp hxn
    have hxmParts := Finset.mem_filter.mp hxm'.1
    have hxnParts := Finset.mem_filter.mp hxn'.1
    have hfix := point_fixed_of_mem_two_fixedLines F E hdeg m n
      (fun h => hmn (Subtype.ext h)) x hxmParts.2.2 hxnParts.2.2
    exact hxmParts.2.1 hfix
  have hunion : (occupiedFixedLines F E C).biUnion fibers =
      occupiedNonfixedExternalPoints F E hdeg C := by
    ext x
    constructor
    · intro hx
      obtain ⟨m, hmocc, hxm⟩ := Finset.mem_biUnion.mp hx
      have hparts := Finset.mem_sdiff.mp hxm
      have hnonline := Finset.mem_filter.mp hparts.1
      apply Finset.mem_filter.mpr
      exact ⟨Finset.mem_sdiff.mpr ⟨Finset.mem_univ _, hparts.2⟩,
        hnonline.2.1, m, hmocc, hnonline.2.2⟩
    · intro hx
      have hparts := Finset.mem_filter.mp hx
      obtain ⟨m, hmocc, hxm⟩ := hparts.2.2
      apply Finset.mem_biUnion.mpr
      refine ⟨m, hmocc, Finset.mem_sdiff.mpr ⟨?_, (Finset.mem_sdiff.mp hparts.1).2⟩⟩
      exact Finset.mem_filter.mpr ⟨Finset.mem_univ _, hparts.2.1, hxm⟩
  rw [← hunion, Finset.card_biUnion hpairwise]
  calc
    (∑ m ∈ occupiedFixedLines F E C, (fibers m).card) =
        ∑ _m ∈ occupiedFixedLines F E C, 18 := by
      apply Finset.sum_congr rfl
      intro m hm
      exact card_nonfixedExternalOn_occupiedLine_eq_eighteen
        F E hdeg hF C hArc hC hcard hfixed m hm
    _ = 72 := by
      simp only [Finset.sum_const, smul_eq_mul]
      rw [card_occupiedFixedLines F E hdeg C hArc hC 0 4 hfixed (by omega)]
      norm_num

theorem mem_occupiedExternalPointsOnLine
    (hdeg : Module.finrank F E = 2) (C : Finset (Point E)) (l x : Point E) :
    x ∈ occupiedExternalPointsOnLine F E hdeg C l ↔
      x ∈ occupiedNonfixedExternalPoints F E hdeg C ∧ x ∈ l := by
  classical
  simp [occupiedExternalPointsOnLine]

/-- Intersecting a fixed nonfixed line with occupied fixed carriers is injective on external
nonfixed points. -/
theorem occupiedCarrier_injective_on_line
    (hdeg : Module.finrank F E = 2) (C : Finset (Point E)) (l : Point E)
    (hl : (incidence F E hdeg).lineConj l ≠ l) :
    Function.Injective (fun x : {x // x ∈ occupiedExternalPointsOnLine F E hdeg C l} =>
        occupiedCarrierOfExternalNonfixed F E hdeg C
          ⟨x.1, (mem_occupiedExternalPointsOnLine F E hdeg C l x.1).mp x.2 |>.1⟩) := by
  classical
  intro x y hcarrier
  apply Subtype.ext
  let mx := occupiedCarrierOfExternalNonfixed F E hdeg C
    ⟨x.1, (mem_occupiedExternalPointsOnLine F E hdeg C l x.1).mp x.2 |>.1⟩
  let my := occupiedCarrierOfExternalNonfixed F E hdeg C
    ⟨y.1, (mem_occupiedExternalPointsOnLine F E hdeg C l y.1).mp y.2 |>.1⟩
  have hxl : x.1 ∈ l :=
    ((mem_occupiedExternalPointsOnLine F E hdeg C l x.1).mp x.2).2
  have hyl : y.1 ∈ l :=
    ((mem_occupiedExternalPointsOnLine F E hdeg C l y.1).mp y.2).2
  have hxm : x.1 ∈ mx.1 := occupiedCarrierOfExternalNonfixed_incident F E hdeg C _
  have hym : y.1 ∈ mx.1 := by
    have hy := occupiedCarrierOfExternalNonfixed_incident F E hdeg C
      ⟨y.1, (mem_occupiedExternalPointsOnLine F E hdeg C l y.1).mp y.2 |>.1⟩
    change y.1 ∈ my.1 at hy
    have hv := congrArg Subtype.val hcarrier
    change mx.1 = my.1 at hv
    rw [hv]
    exact hy
  have hlm : l ≠ mx.1 := by
    intro heq
    apply hl
    rw [heq]
    exact mx.2
  exact (Configuration.Nondegenerate.eq_or_eq hxl hyl hxm hym).resolve_right hlm

/-- A nonfixed old secant has external nonfixed intersections with at most two occupied mate
lines: the two mate lines containing its endpoints are excluded. -/
theorem card_occupiedExternalPointsOnLine_le_two_profile_zero
    (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C)
    (hcard : C.card = 8) (hfixed : (fixedArcPoints F E C).card = 0)
    (a : ArcPair C) (haNonfixed : conjugateArcPair F E C hC a ≠ a) :
    (occupiedExternalPointsOnLine F E hdeg C (a.line (L := Point E))).card ≤ 2 := by
  classical
  obtain ⟨p, q, hpq, ha⟩ := a.exists_eq_pair
  have hpA : p ∈ C := a.subset (by simp [ha])
  have hqA : q ∈ C := a.subset (by simp [ha])
  have hfixedEmpty : fixedArcPoints F E C = ∅ := Finset.card_eq_zero.mp hfixed
  have hpnon : (incidence F E hdeg).pointConj p ≠ p := by
    intro hpfix
    have : p ∈ fixedArcPoints F E C := Finset.mem_filter.mpr ⟨hpA, hpfix⟩
    rw [hfixedEmpty] at this
    simp at this
  have hqnon : (incidence F E hdeg).pointConj q ≠ q := by
    intro hqfix
    have : q ∈ fixedArcPoints F E C := Finset.mem_filter.mpr ⟨hqA, hqfix⟩
    rw [hfixedEmpty] at this
    simp at this
  let mp := mateLine F E hdeg p hpnon
  let mq := mateLine F E hdeg q hqnon
  have hpmp : p ∈ mp.1 := mateLine_incident F E hdeg p hpnon
  have hqmq : q ∈ mq.1 := mateLine_incident F E hdeg q hqnon
  have hpmem : mp ∈ occupiedFixedLines F E C := by
    apply Finset.mem_filter.mpr
    refine ⟨Finset.mem_univ _, ?_⟩
    exact ⟨p, Finset.mem_filter.mpr ⟨hpA, hpmp⟩⟩
  have hqmem : mq ∈ occupiedFixedLines F E C := by
    apply Finset.mem_filter.mpr
    refine ⟨Finset.mem_univ _, ?_⟩
    exact ⟨q, Finset.mem_filter.mpr ⟨hqA, hqmq⟩⟩
  have hlineNonfixed : (incidence F E hdeg).lineConj (a.line (L := Point E)) ≠
      a.line (L := Point E) := fun hline =>
    haNonfixed ((conjugateArcPair_eq_iff_line_fixed F E hdeg C hArc hC a).2 hline)
  have hline_ne_mp : a.line (L := Point E) ≠ mp.1 := fun h => hlineNonfixed (by rw [h]; exact mp.2)
  have hline_ne_mq : a.line (L := Point E) ≠ mq.1 := fun h => hlineNonfixed (by rw [h]; exact mq.2)
  have hmpq : mp ≠ mq := by
    intro h
    have hqmp : q ∈ mp.1 := by rw [h]; exact hqmq
    have hline : a.line (L := Point E) = mp.1 := by
      apply ArcPair.line_unique
      intro x hx
      rw [ha] at hx
      simp only [Finset.mem_insert, Finset.mem_singleton] at hx
      rcases hx with rfl | rfl
      · exact hpmp
      · exact hqmp
    exact hline_ne_mp hline
  let target := occupiedFixedLines F E C \ {mp, mq}
  let source := occupiedExternalPointsOnLine F E hdeg C (a.line (L := Point E))
  let carrier : {x // x ∈ source} → FixedProjectivePoint F E := fun x =>
    occupiedCarrierOfExternalNonfixed F E hdeg C
      ⟨x.1, (mem_occupiedExternalPointsOnLine F E hdeg C
        (a.line (L := Point E)) x.1).mp x.2 |>.1⟩
  have hcarrierTarget (x : {x // x ∈ source}) : carrier x ∈ target := by
    apply Finset.mem_sdiff.mpr
    constructor
    · exact occupiedCarrierOfExternalNonfixed_mem F E hdeg C _
    · simp only [Finset.mem_insert, Finset.mem_singleton, not_or]
      constructor
      · intro hcmp
        have hxl := (mem_occupiedExternalPointsOnLine F E hdeg C
          (a.line (L := Point E)) x.1).mp x.2 |>.2
        have hxm := occupiedCarrierOfExternalNonfixed_incident F E hdeg C
          ⟨x.1, (mem_occupiedExternalPointsOnLine F E hdeg C
            (a.line (L := Point E)) x.1).mp x.2 |>.1⟩
        change x.1 ∈ (carrier x).1 at hxm
        have hxmp : x.1 ∈ mp.1 := by rw [← hcmp]; exact hxm
        have hxp := (Configuration.Nondegenerate.eq_or_eq hxl (a.mem_line (by simp [ha]))
          hxmp hpmp).resolve_right hline_ne_mp
        have hxext := Finset.mem_filter.mp
          ((mem_occupiedExternalPointsOnLine F E hdeg C
            (a.line (L := Point E)) x.1).mp x.2).1 |>.1
        exact (Finset.mem_sdiff.mp hxext).2 (hxp ▸ hpA)
      · intro hcmq
        have hxl := (mem_occupiedExternalPointsOnLine F E hdeg C
          (a.line (L := Point E)) x.1).mp x.2 |>.2
        have hxm := occupiedCarrierOfExternalNonfixed_incident F E hdeg C
          ⟨x.1, (mem_occupiedExternalPointsOnLine F E hdeg C
            (a.line (L := Point E)) x.1).mp x.2 |>.1⟩
        change x.1 ∈ (carrier x).1 at hxm
        have hxmq : x.1 ∈ mq.1 := by rw [← hcmq]; exact hxm
        have hxq := (Configuration.Nondegenerate.eq_or_eq hxl (a.mem_line (by simp [ha]))
          hxmq hqmq).resolve_right hline_ne_mq
        have hxext := Finset.mem_filter.mp
          ((mem_occupiedExternalPointsOnLine F E hdeg C
            (a.line (L := Point E)) x.1).mp x.2).1 |>.1
        exact (Finset.mem_sdiff.mp hxext).2 (hxq ▸ hqA)
  let intoTarget : {x // x ∈ source} → {m // m ∈ target} := fun x =>
    ⟨carrier x, hcarrierTarget x⟩
  have hinjective : Function.Injective intoTarget := by
    intro x y hxy
    apply occupiedCarrier_injective_on_line F E hdeg C (a.line (L := Point E))
      hlineNonfixed
    exact congrArg Subtype.val hxy
  have htargetCard : target.card = 2 := by
    have hpqsub : {mp, mq} ⊆ occupiedFixedLines F E C := by
      intro m hm
      simp only [Finset.mem_insert, Finset.mem_singleton] at hm
      rcases hm with rfl | rfl
      · exact hpmem
      · exact hqmem
    rw [Finset.card_sdiff_of_subset hpqsub]
    rw [card_occupiedFixedLines F E hdeg C hArc hC 0 4 hfixed (by omega)]
    simp [hmpq]
  rw [show (occupiedExternalPointsOnLine F E hdeg C (a.line (L := Point E))).card =
      Fintype.card {x // x ∈ source} by simp [source],
    show 2 = Fintype.card {m // m ∈ target} by simp [htargetCard]]
  exact Fintype.card_le_of_injective intoTarget hinjective

theorem card_nonfixedArcPairsFinset_profile_zero
    (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hC : IsInvariant (incidence F E hdeg) C)
    (hcard : C.card = 8) (hfixed : (fixedArcPoints F E C).card = 0) :
    ((Finset.univ : Finset (ArcPair C)).filter fun a =>
      conjugateArcPair F E C hC a ≠ a).card = 24 := by
  classical
  have hpart := Finset.card_filter_add_card_filter_not
    (s := (Finset.univ : Finset (ArcPair C)))
    (fun a => conjugateArcPair F E C hC a = a)
  change (invariantArcPairsFinset F E hdeg C hC).card +
    ((Finset.univ : Finset (ArcPair C)).filter fun a =>
      conjugateArcPair F E C hC a ≠ a).card = Fintype.card (ArcPair C) at hpart
  rw [card_invariantArcPairsFinset_profile_zero F E hdeg C hC hcard hfixed,
    card_arcPair C, hcard] at hpart
  norm_num [Nat.choose] at hpart ⊢
  omega

/-- Across all occupied nonfixed external points, at most 48 nonfixed-secants incidences occur. -/
theorem sum_card_nonfixedPairsThrough_occupied_le_forty_eight
    (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C)
    (hcard : C.card = 8) (hfixed : (fixedArcPoints F E C).card = 0) :
    (∑ x ∈ occupiedNonfixedExternalPoints F E hdeg C,
      (nonfixedPairsThrough F E hdeg C hC x).card) ≤ 48 := by
  classical
  let S := occupiedNonfixedExternalPoints F E hdeg C
  let N := (Finset.univ : Finset (ArcPair C)).filter fun a =>
    conjugateArcPair F E C hC a ≠ a
  have hdouble :
      (∑ x ∈ S, (nonfixedPairsThrough F E hdeg C hC x).card) =
        ∑ a ∈ N, (occupiedExternalPointsOnLine F E hdeg C
          (a.line (L := Point E))).card := by
    calc
      (∑ x ∈ S, (nonfixedPairsThrough F E hdeg C hC x).card) =
          ∑ x ∈ S, ∑ a ∈ N, if x ∈ a.line (L := Point E) then 1 else 0 := by
            apply Finset.sum_congr rfl
            intro x _hx
            have heq : nonfixedPairsThrough F E hdeg C hC x =
                N.filter fun a => x ∈ a.line (L := Point E) := by
              ext a
              simp [nonfixedPairsThrough, pairsThrough, N, and_comm]
            rw [heq, Finset.card_eq_sum_ones, Finset.sum_ite,
              Finset.sum_const_zero, add_zero]
      _ = ∑ a ∈ N, ∑ x ∈ S, if x ∈ a.line (L := Point E) then 1 else 0 := by
            rw [Finset.sum_comm]
      _ = ∑ a ∈ N, (occupiedExternalPointsOnLine F E hdeg C
          (a.line (L := Point E))).card := by
            apply Finset.sum_congr rfl
            intro a _ha
            rw [occupiedExternalPointsOnLine, Finset.card_eq_sum_ones,
              Finset.sum_ite, Finset.sum_const_zero, add_zero]
  rw [hdouble]
  calc
    (∑ a ∈ N, (occupiedExternalPointsOnLine F E hdeg C
        (a.line (L := Point E))).card) ≤ ∑ _a ∈ N, 2 := by
      apply Finset.sum_le_sum
      intro a ha
      exact card_occupiedExternalPointsOnLine_le_two_profile_zero
        F E hdeg C hArc hC hcard hfixed a (Finset.mem_filter.mp ha).2
    _ = 48 := by
      have hN : N.card = 24 :=
        card_nonfixedArcPairsFinset_profile_zero F E hdeg C hC hcard hfixed
      simp [hN]

/-- The occupied nonfixed external points contribute at most 96 to the second secant moment. -/
theorem sum_choose_pointIndex_occupiedNonfixed_le_ninety_six
    (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C)
    (hcard : C.card = 8) (hfixed : (fixedArcPoints F E C).card = 0) :
    (∑ x ∈ occupiedNonfixedExternalPoints F E hdeg C,
      (pointIndex (L := Point E) C x).choose 2) ≤ 96 := by
  classical
  have hlocal : ∀ x ∈ occupiedNonfixedExternalPoints F E hdeg C,
      (pointIndex (L := Point E) C x).choose 2 ≤
        2 * (nonfixedPairsThrough F E hdeg C hC x).card := by
    intro x hx
    have hindex := pointIndex_eq_one_add_card_nonfixedPairsThrough_profile_zero
      F E hdeg C hArc hC hcard hfixed x hx
    have hxext := (Finset.mem_filter.mp hx).1
    have hcap := pointIndex_le_half_card hArc (Finset.mem_sdiff.mp hxext).2
    rw [hcard, hindex] at hcap
    norm_num at hcap
    have hr : (nonfixedPairsThrough F E hdeg C hC x).card ≤ 3 := by omega
    rw [hindex, Nat.add_comm]
    exact choose_two_succ_le_two_mul_of_le_three hr
  calc
    (∑ x ∈ occupiedNonfixedExternalPoints F E hdeg C,
        (pointIndex (L := Point E) C x).choose 2) ≤
        ∑ x ∈ occupiedNonfixedExternalPoints F E hdeg C,
          2 * (nonfixedPairsThrough F E hdeg C hC x).card := by
      apply Finset.sum_le_sum
      intro x hx
      exact hlocal x hx
    _ = 2 * ∑ x ∈ occupiedNonfixedExternalPoints F E hdeg C,
        (nonfixedPairsThrough F E hdeg C hC x).card := by
      rw [Finset.mul_sum]
    _ ≤ 96 := by
      have hsum := sum_card_nonfixedPairsThrough_occupied_le_forty_eight
        F E hdeg C hArc hC hcard hfixed
      omega

/-- In the zero-fixed-point profile, the first secant-index moment over external fixed points is
exactly 48: four fixed secants contribute six fixed points each, and the other 24 secants their
unique fixed orbit center. -/
theorem sum_pointIndex_fixedExternal_eq_forty_eight
    (hdeg : Module.finrank F E = 2) (hF : Nat.card F = 5)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C)
    (hcard : C.card = 8) (hfixed : (fixedArcPoints F E C).card = 0) :
    (∑ x ∈ fixedExternalPoints F E hdeg C, pointIndex (L := Point E) C x) = 48 := by
  classical
  let S := fixedExternalPoints F E hdeg C
  have hfixedEmpty : fixedArcPoints F E C = ∅ := Finset.card_eq_zero.mp hfixed
  have hrewrite :
      (∑ x ∈ S, pointIndex (L := Point E) C x) =
        ∑ e : ArcPair C, (S.filter fun x => x ∈ e.line (L := Point E)).card := by
    calc
      (∑ x ∈ S, pointIndex (L := Point E) C x) =
          ∑ x ∈ S, (pairsThrough (L := Point E) C x).card := by
            apply Finset.sum_congr rfl
            intro x _hx
            exact pointIndex_eq_card_pairsThrough hArc x
      _ = ∑ x ∈ S, ∑ e : ArcPair C,
          if x ∈ e.line (L := Point E) then 1 else 0 := by
            apply Finset.sum_congr rfl
            intro x _hx
            exact card_pairsThrough_eq_sum_indicator (L := Point E) x
      _ = ∑ e : ArcPair C, ∑ x ∈ S,
          if x ∈ e.line (L := Point E) then 1 else 0 := by
            rw [Finset.sum_comm]
      _ = ∑ e : ArcPair C, (S.filter fun x => x ∈ e.line (L := Point E)).card := by
            apply Finset.sum_congr rfl
            intro e _he
            rw [Finset.card_eq_sum_ones, Finset.sum_ite, Finset.sum_const_zero, add_zero]
  rw [hrewrite]
  calc
    (∑ e : ArcPair C, (S.filter fun x => x ∈ e.line (L := Point E)).card) =
        ∑ e : ArcPair C,
          if conjugateArcPair F E C hC e = e then 6 else 1 := by
      apply Finset.sum_congr rfl
      intro e _he
      have hsets : (S.filter fun x => x ∈ e.line (L := Point E)) =
          fixedPointsOnLineFinset F E hdeg (e.line (L := Point E)) := by
        ext x
        simp only [Finset.mem_filter, fixedPointsOnLineFinset, Finset.mem_univ, true_and]
        constructor
        · rintro ⟨hxS, hxline⟩
          exact ⟨(Finset.mem_filter.mp hxS).2, hxline⟩
        · rintro ⟨hxfix, hxline⟩
          refine ⟨Finset.mem_filter.mpr ⟨Finset.mem_sdiff.mpr ⟨Finset.mem_univ _, ?_⟩,
            hxfix⟩, hxline⟩
          intro hxC
          have : x ∈ fixedArcPoints F E C := Finset.mem_filter.mpr ⟨hxC, hxfix⟩
          rw [hfixedEmpty] at this
          simp at this
      rw [hsets]
      split_ifs with he
      · exact card_fixedPointsOnLineFinset_eq_six_of_fixed F E hdeg hF _
          ((conjugateArcPair_eq_iff_line_fixed F E hdeg C hArc hC e).1 he)
      · exact card_fixedPointsOnLineFinset_eq_one_of_nonfixedArcPair
          F E hdeg C hArc hC ⟨e, he⟩
    _ = 48 := by
      let I := invariantArcPairsFinset F E hdeg C hC
      have hI : I.card = 4 :=
        card_invariantArcPairsFinset_profile_zero F E hdeg C hC hcard hfixed
      have htotal : Fintype.card (ArcPair C) = 28 := by
        rw [card_arcPair C, hcard]
        norm_num [Nat.choose]
      simp only [Finset.sum_ite, Finset.sum_const, smul_eq_mul]
      change I.card * 6 +
        ((Finset.univ : Finset (ArcPair C)).filter
          (fun e => ¬conjugateArcPair F E C hC e = e)).card * 1 = 48
      have hcomp := Finset.card_filter_add_card_filter_not
        (s := (Finset.univ : Finset (ArcPair C)))
        (fun e => conjugateArcPair F E C hC e = e)
      change I.card + ((Finset.univ : Finset (ArcPair C)).filter
        (fun e => ¬conjugateArcPair F E C hC e = e)).card =
          (Finset.univ : Finset (ArcPair C)).card at hcomp
      rw [hI] at hcomp
      simp only [Finset.card_univ, htotal] at hcomp
      rw [hI]
      omega

theorem sum_pointIndex_fixedExternal_le_forty_eight
    (hdeg : Module.finrank F E = 2) (hF : Nat.card F = 5)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C)
    (hcard : C.card = 8) (hfixed : (fixedArcPoints F E C).card = 0) :
    (∑ x ∈ fixedExternalPoints F E hdeg C, pointIndex (L := Point E) C x) ≤ 48 :=
  (sum_pointIndex_fixedExternal_eq_forty_eight F E hdeg hF C hArc hC hcard hfixed).le

theorem externalPoints_partition (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) :
    Finset.univ \ C =
      fixedExternalPoints F E hdeg C ∪
        (occupiedNonfixedExternalPoints F E hdeg C ∪
          emptyNonfixedExternalPoints F E hdeg C) := by
  ext x
  simp only [Finset.mem_sdiff, Finset.mem_univ, true_and, Finset.mem_union,
    fixedExternalPoints, occupiedNonfixedExternalPoints, emptyNonfixedExternalPoints,
    Finset.mem_filter]
  constructor
  · intro hx
    by_cases hfix : (incidence F E hdeg).pointConj x = x
    · exact Or.inl ⟨hx, hfix⟩
    · right
      let m := mateLine F E hdeg x hfix
      have hxm : x ∈ m.1 := mateLine_incident F E hdeg x hfix
      by_cases hmocc : m ∈ occupiedFixedLines F E C
      · exact Or.inl ⟨hx, hfix, m, hmocc, hxm⟩
      · exact Or.inr ⟨hx, hfix, m,
          Finset.mem_sdiff.mpr ⟨Finset.mem_univ _, hmocc⟩, hxm⟩
  · rintro (hx | hx | hx)
    · exact hx.1
    · exact hx.1
    · exact hx.1

theorem fixedExternal_disjoint_occupiedNonfixed (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) :
    Disjoint (fixedExternalPoints F E hdeg C)
      (occupiedNonfixedExternalPoints F E hdeg C) := by
  classical
  rw [Finset.disjoint_left]
  intro x hxfix hxnon
  change x ∈ (Finset.univ \ C).filter (fun x => (incidence F E hdeg).pointConj x = x)
    at hxfix
  change x ∈ (Finset.univ \ C).filter (fun x =>
    (incidence F E hdeg).pointConj x ≠ x ∧
      ∃ m ∈ occupiedFixedLines F E C, x ∈ m.1) at hxnon
  exact (Finset.mem_filter.mp hxnon).2.1 (Finset.mem_filter.mp hxfix).2

theorem fixedExternal_disjoint_emptyNonfixed (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) :
    Disjoint (fixedExternalPoints F E hdeg C)
      (emptyNonfixedExternalPoints F E hdeg C) := by
  classical
  rw [Finset.disjoint_left]
  intro x hxfix hxnon
  change x ∈ (Finset.univ \ C).filter (fun x => (incidence F E hdeg).pointConj x = x)
    at hxfix
  change x ∈ (Finset.univ \ C).filter (fun x =>
    (incidence F E hdeg).pointConj x ≠ x ∧
      ∃ m ∈ emptyFixedLines F E C, x ∈ m.1) at hxnon
  exact (Finset.mem_filter.mp hxnon).2.1 (Finset.mem_filter.mp hxfix).2

theorem occupiedNonfixed_disjoint_emptyNonfixed (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) :
    Disjoint (occupiedNonfixedExternalPoints F E hdeg C)
      (emptyNonfixedExternalPoints F E hdeg C) := by
  classical
  rw [Finset.disjoint_left]
  intro x hxocc hxempty
  change x ∈ (Finset.univ \ C).filter (fun x =>
    (incidence F E hdeg).pointConj x ≠ x ∧
      ∃ m ∈ occupiedFixedLines F E C, x ∈ m.1) at hxocc
  change x ∈ (Finset.univ \ C).filter (fun x =>
    (incidence F E hdeg).pointConj x ≠ x ∧
      ∃ m ∈ emptyFixedLines F E C, x ∈ m.1) at hxempty
  obtain ⟨_hxext, hxnon, m, hmocc, hxm⟩ := Finset.mem_filter.mp hxocc
  obtain ⟨_hxext', _hxnon', n, hnempty, hxn⟩ := Finset.mem_filter.mp hxempty
  have hσxm : (incidence F E hdeg).pointConj x ∈ m.1 := by
    have hc := ((incidence F E hdeg).incident_conj_iff x m.1).2 hxm
    change ProjectiveConjugation.projectiveEquiv (frobeniusRingEquiv F E) x ∈
      ProjectiveConjugation.projectiveEquiv (frobeniusRingEquiv F E) m.1 at hc
    rw [m.2] at hc
    exact hc
  have hσxn : (incidence F E hdeg).pointConj x ∈ n.1 := by
    have hc := ((incidence F E hdeg).incident_conj_iff x n.1).2 hxn
    change ProjectiveConjugation.projectiveEquiv (frobeniusRingEquiv F E) x ∈
      ProjectiveConjugation.projectiveEquiv (frobeniusRingEquiv F E) n.1 at hc
    rw [n.2] at hc
    exact hc
  have hmn : m.1 = n.1 := by
    exact (Configuration.Nondegenerate.eq_or_eq hxm hσxm hxn hσxn).resolve_left
      (Ne.symm hxnon)
  have hmneq : m = n := Subtype.ext hmn
  have : n ∈ occupiedFixedLines F E C := hmneq ▸ hmocc
  exact (Finset.mem_sdiff.mp hnempty).2 this

/-- The global second moment splits into the fixed, occupied-nonfixed, and empty-nonfixed parts. -/
theorem second_moment_partition (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) :
    (∑ x ∈ (Finset.univ \ C), (pointIndex (L := Point E) C x).choose 2) =
      (∑ x ∈ fixedExternalPoints F E hdeg C, (pointIndex (L := Point E) C x).choose 2) +
      (∑ x ∈ occupiedNonfixedExternalPoints F E hdeg C,
        (pointIndex (L := Point E) C x).choose 2) +
      (∑ x ∈ emptyNonfixedExternalPoints F E hdeg C,
        (pointIndex (L := Point E) C x).choose 2) := by
  have hfixedDisjoint : Disjoint (fixedExternalPoints F E hdeg C)
      (occupiedNonfixedExternalPoints F E hdeg C ∪
        emptyNonfixedExternalPoints F E hdeg C) := by
    rw [Finset.disjoint_left]
    intro x hx hxu
    rw [Finset.mem_union] at hxu
    rcases hxu with hxo | hxe
    · exact (Finset.disjoint_left.mp
        (fixedExternal_disjoint_occupiedNonfixed F E hdeg C)) hx hxo
    · exact (Finset.disjoint_left.mp
        (fixedExternal_disjoint_emptyNonfixed F E hdeg C)) hx hxe
  rw [externalPoints_partition F E hdeg C]
  rw [Finset.sum_union hfixedDisjoint]
  rw [Finset.sum_union (occupiedNonfixed_disjoint_emptyNonfixed F E hdeg C)]
  simp only [add_assoc]

theorem first_moment_partition (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) :
    (∑ x ∈ (Finset.univ \ C), pointIndex (L := Point E) C x) =
      (∑ x ∈ fixedExternalPoints F E hdeg C, pointIndex (L := Point E) C x) +
      (∑ x ∈ occupiedNonfixedExternalPoints F E hdeg C,
        pointIndex (L := Point E) C x) +
      (∑ x ∈ emptyNonfixedExternalPoints F E hdeg C,
        pointIndex (L := Point E) C x) := by
  have hfixedDisjoint : Disjoint (fixedExternalPoints F E hdeg C)
      (occupiedNonfixedExternalPoints F E hdeg C ∪
        emptyNonfixedExternalPoints F E hdeg C) := by
    rw [Finset.disjoint_left]
    intro x hx hxu
    rw [Finset.mem_union] at hxu
    rcases hxu with hxo | hxe
    · exact (Finset.disjoint_left.mp
        (fixedExternal_disjoint_occupiedNonfixed F E hdeg C)) hx hxo
    · exact (Finset.disjoint_left.mp
        (fixedExternal_disjoint_emptyNonfixed F E hdeg C)) hx hxe
  rw [externalPoints_partition F E hdeg C]
  rw [Finset.sum_union hfixedDisjoint]
  rw [Finset.sum_union (occupiedNonfixed_disjoint_emptyNonfixed F E hdeg C)]
  simp only [add_assoc]

/-- On any external subset of an eight-arc, twice the local second moment is at most three times
the first moment. -/
theorem two_mul_sum_choose_pointIndex_le_three_mul_sum_pointIndex
    (C S : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hcard : C.card = 8) (hS : S ⊆ Finset.univ \ C) :
    2 * (∑ x ∈ S, (pointIndex (L := Point E) C x).choose 2) ≤
      3 * ∑ x ∈ S, pointIndex (L := Point E) C x := by
  rw [Finset.mul_sum, Finset.mul_sum]
  apply Finset.sum_le_sum
  intro x hx
  apply two_mul_choose_two_le_three_mul_of_le_four
  have hxC : x ∉ C := (Finset.mem_sdiff.mp (hS hx)).2
  have hle := pointIndex_le_half_card hArc hxC
  rw [hcard] at hle
  norm_num at hle ⊢
  exact hle

/-- Numerical tail of the three-way second-moment partition for an eight-arc. -/
theorem forty_two_le_empty_second_moment
    {total fixed occupied empty : ℕ}
    (hpartition : total = fixed + occupied + empty)
    (htotal : total = 210) (hfixed : fixed ≤ 72) (hoccupied : occupied ≤ 96) :
    42 ≤ empty := by
  omega

/-- The fixed external points contribute at most 72 to the second secant moment. -/
theorem sum_choose_pointIndex_fixedExternal_le_seventy_two
    (hdeg : Module.finrank F E = 2) (hF : Nat.card F = 5)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C)
    (hcard : C.card = 8) (hfixed : (fixedArcPoints F E C).card = 0) :
    (∑ x ∈ fixedExternalPoints F E hdeg C,
      (pointIndex (L := Point E) C x).choose 2) ≤ 72 := by
  have hsubset : fixedExternalPoints F E hdeg C ⊆ Finset.univ \ C :=
    Finset.filter_subset _ _
  have hcap := two_mul_sum_choose_pointIndex_le_three_mul_sum_pointIndex
    (E := E) (C := C) (S := fixedExternalPoints F E hdeg C) hArc hcard hsubset
  have hfirst := sum_pointIndex_fixedExternal_le_forty_eight
    F E hdeg hF C hArc hC hcard hfixed
  omega

/-- At least 42 units of second secant moment lie on nonfixed points carried by empty fixed
lines. -/
theorem forty_two_le_sum_choose_pointIndex_emptyNonfixed
    (hdeg : Module.finrank F E = 2) (hF : Nat.card F = 5)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C)
    (hcard : C.card = 8) (hfixed : (fixedArcPoints F E C).card = 0) :
    42 ≤ ∑ x ∈ emptyNonfixedExternalPoints F E hdeg C,
      (pointIndex (L := Point E) C x).choose 2 := by
  have htotal := second_secant_moment hArc
  rw [hcard] at htotal
  norm_num [Nat.choose] at htotal
  have hpart := second_moment_partition F E hdeg C
  rw [htotal] at hpart
  have hfix := sum_choose_pointIndex_fixedExternal_le_seventy_two
    F E hdeg hF C hArc hC hcard hfixed
  have hocc := sum_choose_pointIndex_occupiedNonfixed_le_ninety_six
    F E hdeg C hArc hC hcard hfixed
  exact forty_two_le_empty_second_moment hpart rfl hfix hocc

/-- The empty-carrier endpoint first moment is at most 552. -/
theorem sum_pointIndex_emptyNonfixed_le_five_hundred_fifty_two
    (hdeg : Module.finrank F E = 2) (hF : Nat.card F = 5)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C)
    (hcard : C.card = 8) (hfixed : (fixedArcPoints F E C).card = 0) :
    (∑ x ∈ emptyNonfixedExternalPoints F E hdeg C,
      pointIndex (L := Point E) C x) ≤ 552 := by
  classical
  have hE : Nat.card E = 25 := by
    rw [Module.natCard_eq_pow_finrank (K := F) (V := E), hdeg, hF]
    norm_num
  have hE' : Fintype.card E = 25 := by
    rw [← Nat.card_eq_fintype_card, hE]
  have htotal := first_secant_moment hArc
  rw [hcard, ProjectiveBridge.planeOrder_eq_card, hE'] at htotal
  norm_num [Nat.choose] at htotal
  have hpart := first_moment_partition F E hdeg C
  rw [htotal] at hpart
  have hfix := sum_pointIndex_fixedExternal_eq_forty_eight
    F E hdeg hF C hArc hC hcard hfixed
  have hoccupiedCard := card_occupiedNonfixedExternalPoints_eq_seventy_two
    F E hdeg hF C hArc hC hcard hfixed
  have hoccupiedLower : 72 ≤ ∑ x ∈ occupiedNonfixedExternalPoints F E hdeg C,
      pointIndex (L := Point E) C x := by
    rw [← hoccupiedCard, Finset.card_eq_sum_ones]
    apply Finset.sum_le_sum
    intro x hx
    have hindex := pointIndex_eq_one_add_card_nonfixedPairsThrough_profile_zero
      F E hdeg C hArc hC hcard hfixed x hx
    omega
  omega

/-- Conjugation as an equivalence on endpoint pairs of an invariant arc. -/
noncomputable def conjugateArcPairEquiv
    (hdeg : Module.finrank F E = 2) (C : Finset (Point E))
    (hC : IsInvariant (incidence F E hdeg) C) : ArcPair C ≃ ArcPair C where
  toFun := conjugateArcPair F E C hC
  invFun := conjugateArcPair F E C hC
  left_inv := conjugateArcPair_involutive F E hdeg C hC
  right_inv := conjugateArcPair_involutive F E hdeg C hC

theorem map_conjugateArcPair_pairsThrough
    (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hC : IsInvariant (incidence F E hdeg) C) (x : Point E) :
    (pairsThrough (L := Point E) C x).map
      (conjugateArcPairEquiv F E hdeg C hC).toEmbedding =
        pairsThrough (L := Point E) C ((incidence F E hdeg).pointConj x) := by
  classical
  ext b
  constructor
  · intro hb
    obtain ⟨a, ha, hab⟩ := Finset.mem_map.mp hb
    apply mem_pairsThrough.mpr
    rw [← hab]
    change (incidence F E hdeg).pointConj x ∈
      (conjugateArcPair F E C hC a).line (L := Point E)
    rw [line_conjugateArcPair F E C hC a]
    change (incidence F E hdeg).pointConj x ∈
      (incidence F E hdeg).lineConj (a.line (L := Point E))
    have hxa : x ∈ a.line (L := Point E) := mem_pairsThrough.mp ha
    exact ((incidence F E hdeg).incident_conj_iff x (a.line (L := Point E))).2 hxa
  · intro hb
    let a := conjugateArcPair F E C hC b
    have hab : conjugateArcPair F E C hC a = b :=
      conjugateArcPair_involutive F E hdeg C hC b
    apply Finset.mem_map.mpr
    refine ⟨a, ?_, by simpa [conjugateArcPairEquiv] using hab⟩
    apply mem_pairsThrough.mpr
    have hσxb : (incidence F E hdeg).pointConj x ∈ b.line (L := Point E) :=
      mem_pairsThrough.mp hb
    have hc := ((incidence F E hdeg).incident_conj_iff
      ((incidence F E hdeg).pointConj x) (b.line (L := Point E))).2 hσxb
    rw [(incidence F E hdeg).point_involutive x] at hc
    rw [line_conjugateArcPair F E C hC b]
    exact hc

theorem pointIndex_conj (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C) (x : Point E) :
    pointIndex (L := Point E) C ((incidence F E hdeg).pointConj x) =
      pointIndex (L := Point E) C x := by
  rw [pointIndex_eq_card_pairsThrough hArc, pointIndex_eq_card_pairsThrough hArc,
    ← map_conjugateArcPair_pairsThrough F E hdeg C hC x,
    Finset.card_map]

noncomputable def coveredEmptyNonfixedPoints
    (hdeg : Module.finrank F E = 2) (C : Finset (Point E)) : Finset (Point E) := by
  classical
  exact (emptyNonfixedExternalPoints F E hdeg C).filter fun x =>
    Covered (L := Point E) C x

/-- Moment excess forces at least 21 repeated secant incidences on the covered empty-locus
points, leaving at most 531 covered points before parity is used. -/
theorem card_coveredEmptyNonfixedPoints_le_five_hundred_thirty_one
    (hdeg : Module.finrank F E = 2) (hF : Nat.card F = 5)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C)
    (hcard : C.card = 8) (hfixed : (fixedArcPoints F E C).card = 0) :
    (coveredEmptyNonfixedPoints F E hdeg C).card ≤ 531 := by
  classical
  let S := emptyNonfixedExternalPoints F E hdeg C
  let T := coveredEmptyNonfixedPoints F E hdeg C
  let R := ∑ x ∈ T, (pointIndex (L := Point E) C x - 1)
  have hTsub : T ⊆ S := Finset.filter_subset _ _
  have hfirstEq : (∑ x ∈ S, pointIndex (L := Point E) C x) =
      ∑ x ∈ T, pointIndex (L := Point E) C x := by
    symm
    apply Finset.sum_subset hTsub
    intro x hxS hxT
    have hnotCovered : ¬ Covered (L := Point E) C x := by
      intro hcovered
      exact hxT (Finset.mem_filter.mpr ⟨hxS, hcovered⟩)
    simp only [Covered, Nat.not_lt] at hnotCovered
    omega
  have hsecondEq : (∑ x ∈ S, (pointIndex (L := Point E) C x).choose 2) =
      ∑ x ∈ T, (pointIndex (L := Point E) C x).choose 2 := by
    symm
    apply Finset.sum_subset hTsub
    intro x hxS hxT
    have hnotCovered : ¬ Covered (L := Point E) C x := by
      intro hcovered
      exact hxT (Finset.mem_filter.mpr ⟨hxS, hcovered⟩)
    simp only [Covered, Nat.not_lt] at hnotCovered
    have : pointIndex (L := Point E) C x = 0 := by omega
    simp [this]
  have hdecomp : (∑ x ∈ T, pointIndex (L := Point E) C x) = T.card + R := by
    calc
      (∑ x ∈ T, pointIndex (L := Point E) C x) =
          ∑ x ∈ T, (1 + (pointIndex (L := Point E) C x - 1)) := by
        apply Finset.sum_congr rfl
        intro x hx
        have hpos : 0 < pointIndex (L := Point E) C x :=
          (Finset.mem_filter.mp hx).2
        omega
      _ = T.card + R := by
        simp [R, Finset.sum_add_distrib]
  have hsecondLe : (∑ x ∈ T, (pointIndex (L := Point E) C x).choose 2) ≤
      2 * R := by
    change (∑ x ∈ T, (pointIndex (L := Point E) C x).choose 2) ≤
      2 * ∑ x ∈ T, (pointIndex (L := Point E) C x - 1)
    rw [Finset.mul_sum]
    apply Finset.sum_le_sum
    intro x hx
    apply choose_two_le_two_mul_pred_of_le_four
    have hxS := hTsub hx
    have hxext := (Finset.mem_filter.mp hxS).1
    have hcap := pointIndex_le_half_card hArc (Finset.mem_sdiff.mp hxext).2
    rw [hcard] at hcap
    norm_num at hcap ⊢
    exact hcap
  have hfirst := sum_pointIndex_emptyNonfixed_le_five_hundred_fifty_two
    F E hdeg hF C hArc hC hcard hfixed
  have hsecond := forty_two_le_sum_choose_pointIndex_emptyNonfixed
    F E hdeg hF C hArc hC hcard hfixed
  change T.card ≤ 531
  change (∑ x ∈ S, pointIndex (L := Point E) C x) ≤ 552 at hfirst
  change 42 ≤ ∑ x ∈ S, (pointIndex (L := Point E) C x).choose 2 at hsecond
  rw [hfirstEq] at hfirst
  rw [hsecondEq] at hsecond
  omega

theorem pointConj_mem_emptyNonfixedExternalPoints
    (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hC : IsInvariant (incidence F E hdeg) C)
    {x : Point E} (hx : x ∈ emptyNonfixedExternalPoints F E hdeg C) :
    (incidence F E hdeg).pointConj x ∈ emptyNonfixedExternalPoints F E hdeg C := by
  classical
  have hparts := Finset.mem_filter.mp hx
  obtain ⟨m, hmempty, hxm⟩ := hparts.2.2
  apply Finset.mem_filter.mpr
  constructor
  · apply Finset.mem_sdiff.mpr
    refine ⟨Finset.mem_univ _, ?_⟩
    intro hσC
    have hback := mem_of_invariant_conj (incidence F E hdeg) hC hσC
    rw [(incidence F E hdeg).point_involutive x] at hback
    exact (Finset.mem_sdiff.mp hparts.1).2 hback
  · constructor
    · intro hfix
      apply hparts.2.1
      calc
        (incidence F E hdeg).pointConj x =
            (incidence F E hdeg).pointConj
              ((incidence F E hdeg).pointConj x) := by rw [hfix]
        _ = x := (incidence F E hdeg).point_involutive x
    · refine ⟨m, hmempty, ?_⟩
      have hc := ((incidence F E hdeg).incident_conj_iff x m.1).2 hxm
      change ProjectiveConjugation.projectiveEquiv (frobeniusRingEquiv F E) x ∈
        ProjectiveConjugation.projectiveEquiv (frobeniusRingEquiv F E) m.1 at hc
      rw [m.2] at hc
      exact hc

theorem pointConj_mem_coveredEmptyNonfixedPoints
    (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C)
    {x : Point E} (hx : x ∈ coveredEmptyNonfixedPoints F E hdeg C) :
    (incidence F E hdeg).pointConj x ∈ coveredEmptyNonfixedPoints F E hdeg C := by
  classical
  have hparts := Finset.mem_filter.mp hx
  apply Finset.mem_filter.mpr
  refine ⟨pointConj_mem_emptyNonfixedExternalPoints F E hdeg C hC hparts.1, ?_⟩
  change 0 < pointIndex (L := Point E) C ((incidence F E hdeg).pointConj x)
  rw [pointIndex_conj F E hdeg C hArc hC x]
  exact hparts.2

noncomputable def coveredEmptyPointConjEquiv
    (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C) :
    {x // x ∈ coveredEmptyNonfixedPoints F E hdeg C} ≃
      {x // x ∈ coveredEmptyNonfixedPoints F E hdeg C} where
  toFun x := ⟨(incidence F E hdeg).pointConj x.1,
    pointConj_mem_coveredEmptyNonfixedPoints F E hdeg C hArc hC x.2⟩
  invFun x := ⟨(incidence F E hdeg).pointConj x.1,
    pointConj_mem_coveredEmptyNonfixedPoints F E hdeg C hArc hC x.2⟩
  left_inv x := by
    apply Subtype.ext
    exact (incidence F E hdeg).point_involutive x.1
  right_inv x := by
    apply Subtype.ext
    exact (incidence F E hdeg).point_involutive x.1

/-- Frobenius acts without fixed points on the covered empty locus, so its cardinality is even. -/
theorem even_card_coveredEmptyNonfixedPoints
    (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C) :
    Even (coveredEmptyNonfixedPoints F E hdeg C).card := by
  classical
  let X := {x // x ∈ coveredEmptyNonfixedPoints F E hdeg C}
  let τ : X ≃ X := coveredEmptyPointConjEquiv F E hdeg C hArc hC
  let orbit : X → Sym2 X := fun x => s(x, τ x)
  let S : Finset X := Finset.univ
  let T : Finset (Sym2 X) := S.image orbit
  have hnofix (x : X) : x ≠ τ x := by
    intro h
    have hv := congrArg Subtype.val h
    change x.1 = (incidence F E hdeg).pointConj x.1 at hv
    have hxmem : x.1 ∈ coveredEmptyNonfixedPoints F E hdeg C := x.2
    change x.1 ∈ (emptyNonfixedExternalPoints F E hdeg C).filter
      (fun z => Covered (L := Point E) C z) at hxmem
    have hxparts : x.1 ∈ emptyNonfixedExternalPoints F E hdeg C ∧
        Covered (L := Point E) C x.1 := Finset.mem_filter.mp hxmem
    have hxempty : x.1 ∈ Finset.univ \ C ∧
        ((incidence F E hdeg).pointConj x.1 ≠ x.1 ∧
          ∃ m ∈ emptyFixedLines F E C, x.1 ∈ m.1) := by
      simpa [emptyNonfixedExternalPoints] using hxparts.1
    exact hxempty.2.1 hv.symm
  have hττ (x : X) : τ (τ x) = x := τ.left_inv x
  have hfiber : ∀ q ∈ T, (S.filter fun x => orbit x = q).card = 2 := by
    intro q hq
    obtain ⟨x, _hxS, rfl⟩ := Finset.mem_image.mp hq
    have heq : S.filter (fun y => orbit y = orbit x) = {x, τ x} := by
      ext y
      simp only [S, Finset.mem_filter, Finset.mem_univ, true_and,
        Finset.mem_insert, Finset.mem_singleton]
      change s(y, τ y) = s(x, τ x) ↔ y = x ∨ y = τ x
      rw [Sym2.eq_iff]
      constructor
      · rintro (h | h)
        · exact Or.inl h.1
        · exact Or.inr h.1
      · rintro (rfl | rfl)
        · exact Or.inl ⟨rfl, rfl⟩
        · exact Or.inr ⟨rfl, hττ x⟩
    rw [heq]
    simp [hnofix x]
  have hmul := card_eq_card_mul_of_constant_fibers S T orbit 2
    (fun x hx => Finset.mem_image.mpr ⟨x, hx, rfl⟩) hfiber
  refine ⟨T.card, ?_⟩
  calc
    (coveredEmptyNonfixedPoints F E hdeg C).card = S.card := by simp [S, X]
    _ = T.card * 2 := hmul
    _ = T.card + T.card := by omega

/-- Parity sharpens the raw bound 531 to 530 covered empty-locus points. -/
theorem card_coveredEmptyNonfixedPoints_le_five_hundred_thirty
    (hdeg : Module.finrank F E = 2) (hF : Nat.card F = 5)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C)
    (hcard : C.card = 8) (hfixed : (fixedArcPoints F E C).card = 0) :
    (coveredEmptyNonfixedPoints F E hdeg C).card ≤ 530 := by
  have hle := card_coveredEmptyNonfixedPoints_le_five_hundred_thirty_one
    F E hdeg hF C hArc hC hcard hfixed
  obtain ⟨n, hn⟩ := even_card_coveredEmptyNonfixedPoints F E hdeg C hArc hC
  omega

/-- Once one endpoint of a forbidden conjugate candidate is covered, conjugation invariance of
the point index covers the other endpoint as well. -/
theorem covered_of_mem_forbiddenCandidate
    (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C)
    (m : {m // m ∈ emptyFixedLines F E C}) (q : Sym2 (Point E))
    (hq : q ∈ forbiddenCandidates F E hdeg C hC m)
    {p : Point E} (hp : p ∈ q) : Covered (L := Point E) C p := by
  have hqcand := (Finset.mem_filter.mp hq).1
  obtain ⟨z, hzq, hzcovered⟩ := exists_covered_of_mem_forbidden F E hdeg C hC m q hq
  have hqz := candidate_eq_mk_of_mem F E hdeg m.1 q hqcand
    (Sym2.mem_toFinset.mp hzq)
  rw [hqz, ← Sym2.mem_iff_mem, Sym2.mem_iff'] at hp
  rcases hp with rfl | rfl
  · exact hzcovered
  · change 0 < pointIndex (L := Point E) C ((incidence F E hdeg).pointConj z)
    rw [pointIndex_conj F E hdeg C hArc hC z]
    exact hzcovered

abbrev EmptyCarrierClass (C : Finset (Point E)) :=
  {m // m ∈ emptyFixedLines F E C}

abbrev ForbiddenCandidateClass
    (hdeg : Module.finrank F E = 2) (C : Finset (Point E))
    (hC : IsInvariant (incidence F E hdeg) C) (m : EmptyCarrierClass F E C) :=
  {q // q ∈ forbiddenCandidates F E hdeg C hC m}

abbrev ForbiddenEndpointClass
    (hdeg : Module.finrank F E = 2) (C : Finset (Point E))
    (hC : IsInvariant (incidence F E hdeg) C) :=
  Σ m : EmptyCarrierClass F E C,
    Σ q : ForbiddenCandidateClass F E hdeg C hC m, {p // p ∈ q.1.toFinset}

noncomputable def forbiddenEndpointToCovered
    (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C) :
    ForbiddenEndpointClass F E hdeg C hC →
      {p // p ∈ coveredEmptyNonfixedPoints F E hdeg C} := fun z => by
  classical
  obtain ⟨m, q, p⟩ := z
  have hqcand := (Finset.mem_filter.mp q.2).1
  have hpq : p.1 ∈ q.1 := Sym2.mem_toFinset.mp p.2
  have hpdisjoint := candidate_disjoint_arc F E hdeg C m q.1 hqcand
  have hpEmpty : p.1 ∈ emptyNonfixedExternalPoints F E hdeg C := by
    apply Finset.mem_filter.mpr
    refine ⟨Finset.mem_sdiff.mpr ⟨Finset.mem_univ _, ?_⟩, ?_, m.1, m.2, ?_⟩
    · exact fun hpC => (Finset.disjoint_left.mp hpdisjoint) p.2 hpC
    · exact candidate_point_nonfixed F E hdeg m.1 q.1 hqcand hpq
    · exact candidate_mem_fixedLine F E hdeg m.1 q.1 hqcand hpq
  apply Subtype.mk p.1
  apply Finset.mem_filter.mpr
  exact ⟨hpEmpty, covered_of_mem_forbiddenCandidate F E hdeg C hArc hC m q.1 q.2 hpq⟩

theorem forbiddenEndpointToCovered_injective
    (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C) :
    Function.Injective (forbiddenEndpointToCovered F E hdeg C hArc hC) := by
  classical
  rintro ⟨m, q, p⟩ ⟨n, r, s⟩ hps
  have hv : p.1 = s.1 := congrArg Subtype.val hps
  have hqcand := (Finset.mem_filter.mp q.2).1
  have hrcand := (Finset.mem_filter.mp r.2).1
  have hpq : p.1 ∈ q.1 := Sym2.mem_toFinset.mp p.2
  have hsr : s.1 ∈ r.1 := Sym2.mem_toFinset.mp s.2
  have hpm : p.1 ∈ m.1.1 := candidate_mem_fixedLine F E hdeg m.1 q.1 hqcand hpq
  have hsn : s.1 ∈ n.1.1 := candidate_mem_fixedLine F E hdeg n.1 r.1 hrcand hsr
  have hmn : m = n := by
    apply Subtype.ext
    apply Subtype.ext
    by_contra hlines
    have hpfix := point_fixed_of_mem_two_fixedLines F E hdeg m.1 n.1 hlines p.1
      hpm (by rw [hv]; exact hsn)
    exact candidate_point_nonfixed F E hdeg m.1 q.1 hqcand hpq hpfix
  subst n
  have hqrval : q.1 = r.1 := by
    rw [candidate_eq_mk_of_mem F E hdeg m.1 q.1 hqcand hpq,
      candidate_eq_mk_of_mem F E hdeg m.1 r.1 hrcand (hv ▸ hsr), hv]
  have hqr : q = r := Subtype.ext hqrval
  subst r
  have hpr : p = s := Subtype.ext hv
  subst s
  rfl

theorem fintype_card_forbiddenEndpointClass
    (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hC : IsInvariant (incidence F E hdeg) C) :
    Fintype.card (ForbiddenEndpointClass F E hdeg C hC) =
      2 * ∑ m : EmptyCarrierClass F E C,
        (forbiddenCandidates F E hdeg C hC m).card := by
  classical
  rw [Fintype.card_sigma]
  calc
    (∑ m : EmptyCarrierClass F E C,
        Fintype.card (Σ q : ForbiddenCandidateClass F E hdeg C hC m,
          {p // p ∈ q.1.toFinset})) =
        ∑ m : EmptyCarrierClass F E C,
          ∑ _q : ForbiddenCandidateClass F E hdeg C hC m, 2 := by
      apply Finset.sum_congr rfl
      intro m _hm
      rw [Fintype.card_sigma]
      apply Finset.sum_congr rfl
      intro q _hq
      rw [Fintype.card_coe,
        candidate_toFinset_card F E hdeg m.1 q.1 (Finset.mem_filter.mp q.2).1]
    _ = 2 * ∑ m : EmptyCarrierClass F E C,
        (forbiddenCandidates F E hdeg C hC m).card := by
      simp only [Finset.sum_const, smul_eq_mul]
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro m _hm
      rw [Finset.card_univ, Fintype.card_coe]
      omega

theorem two_mul_sum_card_forbidden_le_covered
    (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C) :
    2 * (∑ m ∈ allEmptyCarrierClasses F E C,
      (forbiddenCandidates F E hdeg C hC m).card) ≤
        (coveredEmptyNonfixedPoints F E hdeg C).card := by
  have hinj := Fintype.card_le_of_injective _
    (forbiddenEndpointToCovered_injective F E hdeg C hArc hC)
  rw [fintype_card_forbiddenEndpointClass F E hdeg C hC] at hinj
  simpa [allEmptyCarrierClasses] using hinj

theorem sum_card_forbidden_le_two_hundred_sixty_five
    (hdeg : Module.finrank F E = 2) (hF : Nat.card F = 5)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C)
    (hcard : C.card = 8) (hfixed : (fixedArcPoints F E C).card = 0) :
    (∑ m ∈ allEmptyCarrierClasses F E C,
      (forbiddenCandidates F E hdeg C hC m).card) ≤ 265 := by
  have hdouble := two_mul_sum_card_forbidden_le_covered F E hdeg C hArc hC
  have hcovered := card_coveredEmptyNonfixedPoints_le_five_hundred_thirty
    F E hdeg hF C hArc hC hcard hfixed
  omega

/-- There are at least five legal conjugate-pair extensions in the zero-fixed-point profile. -/
theorem five_le_sum_card_legal_profile_zero
    (hdeg : Module.finrank F E = 2) (hF : Nat.card F = 5)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C)
    (hcard : C.card = 8) (hfixed : (fixedArcPoints F E C).card = 0) :
    5 ≤ ∑ m ∈ allEmptyCarrierClasses F E C,
      (conjugateCandidatesOnFixedLine F E hdeg m.1 \
        forbiddenCandidates F E hdeg C hC m).card := by
  have hforbidden := sum_card_forbidden_le_two_hundred_sixty_five
    F E hdeg hF C hArc hC hcard hfixed
  have hcarriers : (allEmptyCarrierClasses F E C).card = 27 := by
    change Fintype.card {m // m ∈ emptyFixedLines F E C} = 27
    rw [Fintype.card_coe,
      card_emptyFixedLines F E hdeg C hArc hC 0 4 hfixed (by omega), hF]
    norm_num [baerEmptyLineCount]
  have hline (m : EmptyCarrierClass F E C) :
      (conjugateCandidatesOnFixedLine F E hdeg m.1 \
        forbiddenCandidates F E hdeg C hC m).card +
        (forbiddenCandidates F E hdeg C hC m).card = 10 := by
    have hsub : forbiddenCandidates F E hdeg C hC m ⊆
        conjugateCandidatesOnFixedLine F E hdeg m.1 := Finset.filter_subset _ _
    rw [Finset.card_sdiff_add_card_eq_card hsub,
      card_conjugateCandidatesOnFixedLine F E hdeg m.1, hF]
  have hsum :
      (∑ m ∈ allEmptyCarrierClasses F E C,
        (conjugateCandidatesOnFixedLine F E hdeg m.1 \
          forbiddenCandidates F E hdeg C hC m).card) +
      (∑ m ∈ allEmptyCarrierClasses F E C,
        (forbiddenCandidates F E hdeg C hC m).card) = 270 := by
    rw [← Finset.sum_add_distrib]
    calc
      (∑ m ∈ allEmptyCarrierClasses F E C,
          ((conjugateCandidatesOnFixedLine F E hdeg m.1 \
            forbiddenCandidates F E hdeg C hC m).card +
            (forbiddenCandidates F E hdeg C hC m).card)) =
          ∑ _m ∈ allEmptyCarrierClasses F E C, 10 := by
        apply Finset.sum_congr rfl
        intro m _hm
        exact hline m
      _ = 270 := by simp [hcarriers]
  omega

theorem exists_profile_zero_pair_extension
    (hdeg : Module.finrank F E = 2) (hF : Nat.card F = 5)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C)
    (hcard : C.card = 8) (hfixed : (fixedArcPoints F E C).card = 0) :
    ∃ (m : EmptyCarrierClass F E C) (q : Sym2 (Point E)),
      q ∈ conjugateCandidatesOnFixedLine F E hdeg m.1 ∧
        Arc (L := Point E) (C ∪ q.toFinset) := by
  have hpositive : 0 < ∑ m ∈ allEmptyCarrierClasses F E C,
      (conjugateCandidatesOnFixedLine F E hdeg m.1 \
        forbiddenCandidates F E hdeg C hC m).card := by
    have hfive := five_le_sum_card_legal_profile_zero
      F E hdeg hF C hArc hC hcard hfixed
    omega
  rw [Finset.sum_pos_iff] at hpositive
  obtain ⟨m, _hm, hcardpos⟩ := hpositive
  obtain ⟨q, hq⟩ := Finset.card_pos.mp hcardpos
  have hparts := Finset.mem_sdiff.mp hq
  exact ⟨m, q, hparts.1,
    arc_union_candidate_of_not_mem_forbidden F E hdeg C hArc hC m q hparts.1 hparts.2⟩

/-- Paper-facing zero-profile theorem with both new conjugate points explicitly fresh. -/
theorem profile_zero_pair_extension
    (hdeg : Module.finrank F E = 2) (hF : Nat.card F = 5)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C)
    (hcard : C.card = 8) (hfixed : (fixedArcPoints F E C).card = 0) :
    ∃ p : Point E,
      (incidence F E hdeg).pointConj p ≠ p ∧
      p ∉ C ∧ (incidence F E hdeg).pointConj p ∉ C ∧
      Arc (L := Point E) (C ∪ {p, (incidence F E hdeg).pointConj p}) := by
  obtain ⟨m, q, hq, hArcq⟩ :=
    exists_profile_zero_pair_extension F E hdeg hF C hArc hC hcard hfixed
  obtain ⟨p, hpq⟩ := (mem_candidates_iff_exists F E hdeg m.1 q).mp hq
  have hdisjoint := candidate_disjoint_arc F E hdeg C m q hq
  have hpmem : p.1.1 ∈ q.toFinset := by
    rw [← hpq]
    simp [matePair]
  have hmateMem : (incidence F E hdeg).pointConj p.1.1 ∈ q.toFinset := by
    rw [← hpq]
    apply Sym2.mem_toFinset.mpr
    rw [← Sym2.mem_iff_mem, matePair, Sym2.mem_iff']
    right
    rfl
  refine ⟨p.1.1, p.2, ?_, ?_, ?_⟩
  · exact fun hpC => (Finset.disjoint_left.mp hdisjoint) hpmem hpC
  · exact fun hpC => (Finset.disjoint_left.mp hdisjoint) hmateMem hpC
  · rw [← hpq] at hArcq
    change Arc (L := Point E) (C ∪
      {p.1.1, ProjectiveConjugation.projectiveEquiv (frobeniusRingEquiv F E) p.1.1})
    simpa [matePair, nonfixedMate, Sym2.toFinset_mk_eq] using hArcq

end
end Q25ProfileZero
end RelativeConicArcs
