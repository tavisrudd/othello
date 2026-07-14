import RelativeConicArcs.QuadraticCollision

/-!
# Geometric interpretation of invisible quadratic secant orbits

This file identifies the center of a nonfixed old-secant orbit: the unique intersection of a
secant with its Frobenius conjugate.  The center is a fixed projective point.  These lemmas are the
geometric input for lower bounds on the aggregate invisible term in `QuadraticCollision`.
-/

namespace RelativeConicArcs
namespace QuadraticInvisible

noncomputable section

open Configuration Finset
open FiniteGeom.BaerCompletion
open QuadraticFrobenius QuadraticLineCounting QuadraticForbidden QuadraticCollision

variable (F E : Type) [Field F] [Fintype F] [Field E] [Finite E] [Algebra F E]
  [Algebra.IsAlgebraic F E]

abbrev Point := ProjectiveConjugation.Point E

local instance : Fintype E := Fintype.ofFinite E
local instance : DecidableEq E := Classical.decEq E
local instance : DecidableEq (Point E) := Classical.decEq _
local instance : DecidableRel fun p l : Point E => p.orthogonal l := Classical.decRel _
local instance : DecidablePred (IsFrobeniusNonfixed F E) := Classical.decPred _

/-- A nonfixed old secant and its conjugate have distinct joining lines. -/
theorem pairLine_ne_mateLine (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C)
    (a : NonfixedArcPair F E C hC) :
    a.1.line (L := Point E) ≠
      (nonfixedSecantMate F E hdeg C hC a).1.line (L := Point E) := by
  intro hlines
  apply a.2
  apply ArcPair.line_injective hArc
  exact hlines.symm

/-- The center of a nonfixed old-secant orbit is the intersection of its two conjugate lines. -/
noncomputable def secantOrbitCenter (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C)
    (a : NonfixedArcPair F E C hC) : Point E :=
  Configuration.HasPoints.mkPoint
    (pairLine_ne_mateLine F E hdeg C hArc hC a)

theorem secantOrbitCenter_mem_pairLine (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C)
    (a : NonfixedArcPair F E C hC) :
    secantOrbitCenter F E hdeg C hArc hC a ∈ a.1.line (L := Point E) :=
  (Configuration.HasPoints.mkPoint_ax
    (pairLine_ne_mateLine F E hdeg C hArc hC a)).1

theorem secantOrbitCenter_mem_mateLine (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C)
    (a : NonfixedArcPair F E C hC) :
    secantOrbitCenter F E hdeg C hArc hC a ∈
      (nonfixedSecantMate F E hdeg C hC a).1.line (L := Point E) :=
  (Configuration.HasPoints.mkPoint_ax
    (pairLine_ne_mateLine F E hdeg C hArc hC a)).2

/-- The intersection of conjugate secants is fixed by Frobenius. -/
theorem secantOrbitCenter_fixed (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C)
    (a : NonfixedArcPair F E C hC) :
    (incidence F E hdeg).pointConj (secantOrbitCenter F E hdeg C hArc hC a) =
      secantOrbitCenter F E hdeg C hArc hC a := by
  let G := incidence F E hdeg
  let b := nonfixedSecantMate F E hdeg C hC a
  let x := secantOrbitCenter F E hdeg C hArc hC a
  have hxa : x ∈ a.1.line (L := Point E) :=
    secantOrbitCenter_mem_pairLine F E hdeg C hArc hC a
  have hxb : x ∈ b.1.line (L := Point E) :=
    secantOrbitCenter_mem_mateLine F E hdeg C hArc hC a
  have hlineb : b.1.line (L := Point E) = G.lineConj (a.1.line (L := Point E)) :=
    line_conjugateArcPair F E C hC a.1
  have hlinea : a.1.line (L := Point E) = G.lineConj (b.1.line (L := Point E)) := by
    rw [hlineb, G.line_involutive]
  have hGxa : G.pointConj x ∈ a.1.line (L := Point E) := by
    have hc := (G.incident_conj_iff x (b.1.line (L := Point E))).2 hxb
    change G.pointConj x ∈ G.lineConj (b.1.line (L := Point E)) at hc
    simpa only [hlinea] using hc
  have hGxb : G.pointConj x ∈ b.1.line (L := Point E) := by
    have hc := (G.incident_conj_iff x (a.1.line (L := Point E))).2 hxa
    change G.pointConj x ∈ G.lineConj (a.1.line (L := Point E)) at hc
    simpa only [hlineb] using hc
  exact (Configuration.HasPoints.existsUnique_point (P := Point E) (L := Point E)
    (a.1.line (L := Point E)) (b.1.line (L := Point E))
    (pairLine_ne_mateLine F E hdeg C hArc hC a)).unique
      ⟨hGxa, hGxb⟩ ⟨hxa, hxb⟩

/-- Cross-pair secant orbits are those whose two conjugate endpoint pairs are disjoint. -/
def IsCrossPairOrbit (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hC : IsInvariant (incidence F E hdeg) C)
    (a : NonfixedArcPair F E C hC) : Prop :=
  Disjoint a.1.1 (nonfixedSecantMate F E hdeg C hC a).1.1

theorem mate_isCrossPairOrbit (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hC : IsInvariant (incidence F E hdeg) C)
    (a : NonfixedArcPair F E C hC) (ha : IsCrossPairOrbit F E hdeg C hC a) :
    IsCrossPairOrbit F E hdeg C hC (nonfixedSecantMate F E hdeg C hC a) := by
  unfold IsCrossPairOrbit at ha ⊢
  have hmate := (nonfixedSecantMate F E hdeg C hC).left_inv a
  change nonfixedSecantMate F E hdeg C hC
    (nonfixedSecantMate F E hdeg C hC a) = a at hmate
  rw [hmate]
  exact ha.symm

theorem representative_isCrossPairOrbit_of_classOfPair
    (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hC : IsInvariant (incidence F E hdeg) C)
    (a : NonfixedArcPair F E C hC) (ha : IsCrossPairOrbit F E hdeg C hC a) :
    IsCrossPairOrbit F E hdeg C hC
      (secantOrbitRepresentative F E hdeg C hC
        (secantOrbitClassOfPair F E hdeg C hC a)) := by
  let b := secantOrbitRepresentative F E hdeg C hC
    (secantOrbitClassOfPair F E hdeg C hC a)
  have horbit : secantOrbit F E hdeg C hC b = secantOrbit F E hdeg C hC a :=
    secantOrbitRepresentative_spec F E hdeg C hC _
  change IsCrossPairOrbit F E hdeg C hC b
  rcases (secantOrbit_eq_iff F E hdeg C hC b a).mp horbit with hab | hab
  · rw [hab]
    exact ha
  · rw [hab]
    exact mate_isCrossPairOrbit F E hdeg C hC a ha

/-- The four endpoints of a cross-pair orbit are selected nonfixed points. -/
theorem crossPair_endpoints_subset_nonfixed (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hC : IsInvariant (incidence F E hdeg) C)
    (a : NonfixedArcPair F E C hC) (ha : IsCrossPairOrbit F E hdeg C hC a) :
    a.1.1 ∪ (nonfixedSecantMate F E hdeg C hC a).1.1 ⊆
      C.filter (IsFrobeniusNonfixed F E) := by
  intro p hp
  rw [Finset.mem_union] at hp
  apply Finset.mem_filter.mpr
  constructor
  · rcases hp with hp | hp
    · exact a.1.subset hp
    · exact (nonfixedSecantMate F E hdeg C hC a).1.subset hp
  · intro hpfix
    rcases hp with hp | hp
    · apply (Finset.disjoint_left.mp ha) hp
      change p ∈ (conjugateArcPair F E C hC a.1).1
      exact Finset.mem_map.mpr ⟨p, hp, hpfix⟩
    · apply (Finset.disjoint_left.mp ha) ?_ hp
      change p ∈ (conjugateArcPair F E C hC a.1).1 at hp
      obtain ⟨q, hqa, hqp⟩ := Finset.mem_map.mp hp
      change (incidence F E hdeg).pointConj q = p at hqp
      have : q = p := by
        rw [← hpfix, ← hqp]
        exact ((incidence F E hdeg).point_involutive q).symm
      simpa [this] using hqa

/-- A cross-pair center is external to the old arc. -/
theorem secantOrbitCenter_not_mem_arc_of_crossPair (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C)
    (a : NonfixedArcPair F E C hC) (ha : IsCrossPairOrbit F E hdeg C hC a) :
    secantOrbitCenter F E hdeg C hArc hC a ∉ C := by
  intro hzC
  have hza : secantOrbitCenter F E hdeg C hArc hC a ∈ a.1.1 :=
    a.1.mem_of_mem_arc_of_mem_line hArc hzC
      (secantOrbitCenter_mem_pairLine F E hdeg C hArc hC a)
  have hzb : secantOrbitCenter F E hdeg C hArc hC a ∈
      (nonfixedSecantMate F E hdeg C hC a).1.1 :=
    (nonfixedSecantMate F E hdeg C hC a).1.mem_of_mem_arc_of_mem_line hArc hzC
      (secantOrbitCenter_mem_mateLine F E hdeg C hArc hC a)
  exact (Finset.disjoint_left.mp ha) hza hzb

/-- In the `(f,e)=(4,2)` profile, the four endpoints of any cross-pair secant orbit are exactly
all selected nonfixed points. -/
theorem crossPair_endpoints_eq_nonfixed_of_profile_four
    (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hC : IsInvariant (incidence F E hdeg) C)
    (hcard : C.card = 8) (hfixed : (fixedArcPoints F E C).card = 4)
    (a : NonfixedArcPair F E C hC) (ha : IsCrossPairOrbit F E hdeg C hC a) :
    a.1.1 ∪ (nonfixedSecantMate F E hdeg C hC a).1.1 =
      C.filter (IsFrobeniusNonfixed F E) := by
  have hsubset := crossPair_endpoints_subset_nonfixed F E hdeg C hC a ha
  apply Finset.eq_of_subset_of_card_le hsubset
  have hunion :
      (a.1.1 ∪ (nonfixedSecantMate F E hdeg C hC a).1.1).card = 4 := by
    rw [Finset.card_union_of_disjoint ha, a.1.card,
      (nonfixedSecantMate F E hdeg C hC a).1.card]
  have hnonfixedCard : (C.filter (IsFrobeniusNonfixed F E)).card = 4 := by
    have hnat := natCard_nonfixedArcPoint F E C
    have hequiv := Nat.card_congr (nonfixedArcPointEquiv F E C)
    rw [hnat, hcard, hfixed] at hequiv
    rw [← Fintype.card_coe, ← Nat.card_eq_fintype_card]
    simpa only [Finset.mem_filter] using hequiv.symm
  rw [hnonfixedCard, hunion]

/-- Choose an old arc point on an occupied fixed line. -/
noncomputable def occupiedLinePoint
    (C : Finset (Point E))
    (m : {m // m ∈ occupiedFixedLines F E C}) : Point E :=
  Classical.choose (Finset.mem_filter.mp m.2).2

theorem occupiedLinePoint_mem_arc
    (C : Finset (Point E)) (m : {m // m ∈ occupiedFixedLines F E C}) :
    occupiedLinePoint F E C m ∈ C :=
  (Finset.mem_filter.mp (Classical.choose_spec (Finset.mem_filter.mp m.2).2)).1

theorem occupiedLinePoint_mem_line
    (C : Finset (Point E)) (m : {m // m ∈ occupiedFixedLines F E C}) :
    occupiedLinePoint F E C m ∈ m.1.1 :=
  (Finset.mem_filter.mp (Classical.choose_spec (Finset.mem_filter.mp m.2).2)).2

/-- In the profile-four case, every occupied fixed line through a cross-pair center contains a
selected fixed point. -/
theorem occupiedLinePoint_fixed_of_crossPair_profile_four
    (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C)
    (hcard : C.card = 8) (hfixed : (fixedArcPoints F E C).card = 4)
    (a : NonfixedArcPair F E C hC) (ha : IsCrossPairOrbit F E hdeg C hC a)
    (m : {m // m ∈ occupiedFixedLines F E C})
    (hzm : secantOrbitCenter F E hdeg C hArc hC a ∈ m.1.1) :
    (incidence F E hdeg).pointConj (occupiedLinePoint F E C m) =
      occupiedLinePoint F E C m := by
  let z := secantOrbitCenter F E hdeg C hArc hC a
  let p := occupiedLinePoint F E C m
  by_contra hp
  have hpfilter : p ∈ C.filter (IsFrobeniusNonfixed F E) :=
    Finset.mem_filter.mpr ⟨occupiedLinePoint_mem_arc F E C m, hp⟩
  have hpends : p ∈ a.1.1 ∪ (nonfixedSecantMate F E hdeg C hC a).1.1 := by
    rw [crossPair_endpoints_eq_nonfixed_of_profile_four F E hdeg C hC hcard hfixed a ha]
    exact hpfilter
  have hpz : p ≠ z := by
    intro hpzeq
    apply hp
    change (incidence F E hdeg).pointConj p = p
    rw [hpzeq]
    exact secantOrbitCenter_fixed F E hdeg C hArc hC a
  have hpm : p ∈ m.1.1 := occupiedLinePoint_mem_line F E C m
  rw [Finset.mem_union] at hpends
  rcases hpends with hpa | hpb
  · have hza := secantOrbitCenter_mem_pairLine F E hdeg C hArc hC a
    have hpaLine := a.1.mem_line (L := Point E) hpa
    have hlines : a.1.line (L := Point E) = m.1.1 :=
      (Configuration.Nondegenerate.eq_or_eq hza hpaLine hzm hpm).resolve_left hpz.symm
    apply a.2
    exact (conjugateArcPair_eq_iff_line_fixed F E hdeg C hArc hC a.1).2
      (by rw [hlines]; exact m.1.2)
  · let b := nonfixedSecantMate F E hdeg C hC a
    have hzb := secantOrbitCenter_mem_mateLine F E hdeg C hArc hC a
    have hpbLine := b.1.mem_line (L := Point E) hpb
    have hlines : b.1.line (L := Point E) = m.1.1 :=
      (Configuration.Nondegenerate.eq_or_eq hzb hpbLine hzm hpm).resolve_left hpz.symm
    apply b.2
    exact (conjugateArcPair_eq_iff_line_fixed F E hdeg C hArc hC b.1).2
      (by rw [hlines]; exact m.1.2)

/-- Charge each occupied fixed line through a profile-four cross-pair center to a selected fixed
point on that line. -/
noncomputable def occupiedCenterFixedPoint
    (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C)
    (hcard : C.card = 8) (hfixed : (fixedArcPoints F E C).card = 4)
    (a : NonfixedArcPair F E C hC) (ha : IsCrossPairOrbit F E hdeg C hC a)
    (m : {m // m ∈ (occupiedFixedLines F E C) ∩ fixedLinesThroughFinset F E
      (secantOrbitCenter F E hdeg C hArc hC a)}) :
    {p // p ∈ fixedArcPoints F E C} := by
  let mo : {m // m ∈ occupiedFixedLines F E C} :=
    ⟨m.1, (Finset.mem_inter.mp m.2).1⟩
  refine ⟨occupiedLinePoint F E C mo, Finset.mem_filter.mpr ⟨
    occupiedLinePoint_mem_arc F E C mo, ?_⟩⟩
  exact occupiedLinePoint_fixed_of_crossPair_profile_four F E hdeg C hArc hC
    hcard hfixed a ha mo (Finset.mem_filter.mp (Finset.mem_inter.mp m.2).2).2

theorem occupiedCenterFixedPoint_injective
    (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C)
    (hcard : C.card = 8) (hfixed : (fixedArcPoints F E C).card = 4)
    (a : NonfixedArcPair F E C hC) (ha : IsCrossPairOrbit F E hdeg C hC a) :
    Function.Injective
      (occupiedCenterFixedPoint F E hdeg C hArc hC hcard hfixed a ha) := by
  intro m n hmn
  apply Subtype.ext
  apply Subtype.ext
  let z := secantOrbitCenter F E hdeg C hArc hC a
  let mo : {m // m ∈ occupiedFixedLines F E C} :=
    ⟨m.1, (Finset.mem_inter.mp m.2).1⟩
  let no : {m // m ∈ occupiedFixedLines F E C} :=
    ⟨n.1, (Finset.mem_inter.mp n.2).1⟩
  let p := occupiedLinePoint F E C mo
  have hpC : p ∈ C := occupiedLinePoint_mem_arc F E C mo
  have hzC : z ∉ C := secantOrbitCenter_not_mem_arc_of_crossPair F E hdeg C hArc hC a ha
  have hzp : z ≠ p := fun h => hzC (h ▸ hpC)
  have hzm : z ∈ m.1.1 := (Finset.mem_filter.mp (Finset.mem_inter.mp m.2).2).2
  have hzn : z ∈ n.1.1 := (Finset.mem_filter.mp (Finset.mem_inter.mp n.2).2).2
  have hpm : p ∈ m.1.1 := occupiedLinePoint_mem_line F E C mo
  have hpn : p ∈ n.1.1 := by
    have hv := congrArg Subtype.val hmn
    change occupiedLinePoint F E C mo = occupiedLinePoint F E C no at hv
    change occupiedLinePoint F E C mo ∈ n.1.1
    rw [hv]
    exact occupiedLinePoint_mem_line F E C no
  exact (Configuration.Nondegenerate.eq_or_eq hzm hpm hzn hpn).resolve_left hzp

/-- A cross-pair center in the `(4,2)` profile is incident with at most the four fixed-point star
lines. -/
theorem card_occupied_through_crossPair_center_le_four
    (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C)
    (hcard : C.card = 8) (hfixed : (fixedArcPoints F E C).card = 4)
    (a : NonfixedArcPair F E C hC) (ha : IsCrossPairOrbit F E hdeg C hC a) :
    ((occupiedFixedLines F E C) ∩ fixedLinesThroughFinset F E
      (secantOrbitCenter F E hdeg C hArc hC a)).card ≤ 4 := by
  rw [← hfixed, ← Fintype.card_coe, ← Fintype.card_coe]
  exact Fintype.card_le_of_injective _
    (occupiedCenterFixedPoint_injective F E hdeg C hArc hC hcard hfixed a ha)

theorem secantIntersection_eq_center_of_center_mem (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C)
    (m : {m // m ∈ emptyFixedLines F E C}) (a : NonfixedArcPair F E C hC)
    (hcenter : secantOrbitCenter F E hdeg C hArc hC a ∈ m.1.1) :
    secantIntersection F E hdeg C hC m a =
      secantOrbitCenter F E hdeg C hArc hC a := by
  apply (Configuration.HasPoints.existsUnique_point (P := Point E) (L := Point E)
    (a.1.line (L := Point E)) m.1.1
    (pairLine_ne_emptyFixedLine F E hdeg C hC m a)).unique
  · exact ⟨secantIntersection_mem_pairLine F E hdeg C hC m a,
      secantIntersection_mem_emptyLine F E hdeg C hC m a⟩
  · exact ⟨secantOrbitCenter_mem_pairLine F E hdeg C hArc hC a, hcenter⟩

/-- A secant-orbit charge is invisible exactly when its fixed center lies on the carrier. -/
theorem orbitIntersectionCandidate_not_mem_iff_center_mem (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C)
    (m : {m // m ∈ emptyFixedLines F E C})
    (o : SecantOrbitClass F E hdeg C hC) :
    orbitIntersectionCandidate F E hdeg C hC m o ∉
        conjugateCandidatesOnFixedLine F E hdeg m.1 ↔
      secantOrbitCenter F E hdeg C hArc hC
        (secantOrbitRepresentative F E hdeg C hC o) ∈ m.1.1 := by
  let a := secantOrbitRepresentative F E hdeg C hC o
  let x := secantIntersection F E hdeg C hC m a
  let z := secantOrbitCenter F E hdeg C hArc hC a
  constructor
  · intro hinvisible
    by_contra hz
    have hxnonfixed : (incidence F E hdeg).pointConj x ≠ x := by
      intro hxfix
      have hxa : x ∈ a.1.line (L := Point E) :=
        secantIntersection_mem_pairLine F E hdeg C hC m a
      have hxb : x ∈ (nonfixedSecantMate F E hdeg C hC a).1.line (L := Point E) := by
        have hc := ((incidence F E hdeg).incident_conj_iff
          x (a.1.line (L := Point E))).2 hxa
        change (incidence F E hdeg).pointConj x ∈
          (incidence F E hdeg).lineConj (a.1.line (L := Point E)) at hc
        rw [hxfix, ← line_conjugateArcPair F E C hC a.1] at hc
        exact hc
      have hxz : x = z := by
        apply (Configuration.HasPoints.existsUnique_point (P := Point E) (L := Point E)
          (a.1.line (L := Point E))
          ((nonfixedSecantMate F E hdeg C hC a).1.line (L := Point E))
          (pairLine_ne_mateLine F E hdeg C hArc hC a)).unique
        · exact ⟨hxa, hxb⟩
        · exact ⟨secantOrbitCenter_mem_pairLine F E hdeg C hArc hC a,
            secantOrbitCenter_mem_mateLine F E hdeg C hArc hC a⟩
      apply hz
      change z ∈ m.1.1
      change x = z at hxz
      rw [← hxz]
      exact secantIntersection_mem_emptyLine F E hdeg C hC m a
    apply hinvisible
    rw [mem_candidates_iff_exists F E hdeg m.1]
    let p : NonfixedPointsOnFixedLine F E m.1 :=
      ⟨⟨x, secantIntersection_mem_emptyLine F E hdeg C hC m a⟩, hxnonfixed⟩
    refine ⟨p, ?_⟩
    rfl
  · intro hcenter hcand
    have hxz := secantIntersection_eq_center_of_center_mem F E hdeg C hArc hC m a hcenter
    have hxmem : x ∈ orbitIntersectionCandidate F E hdeg C hC m o := by
      simp [orbitIntersectionCandidate, secantIntersectionCandidate, a, x]
    have hxnonfixed := candidate_point_nonfixed F E hdeg m.1
      (orbitIntersectionCandidate F E hdeg C hC m o) hcand hxmem
    apply hxnonfixed
    change x = z at hxz
    rw [hxz]
    exact secantOrbitCenter_fixed F E hdeg C hArc hC a

/-- Membership in the combinatorial invisible set has the geometric center-on-carrier meaning. -/
theorem mem_invisibleSecantOrbitClasses_iff_center_mem (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C)
    (m : {m // m ∈ emptyFixedLines F E C})
    (o : SecantOrbitClass F E hdeg C hC) :
    o ∈ invisibleSecantOrbitClasses F E hdeg C hC m ↔
      secantOrbitCenter F E hdeg C hArc hC
        (secantOrbitRepresentative F E hdeg C hC o) ∈ m.1.1 := by
  rw [invisibleSecantOrbitClasses, Finset.mem_sdiff]
  simp only [allSecantOrbitClasses, Finset.mem_univ, true_and,
    visibleSecantOrbitClasses, Finset.mem_filter]
  exact orbitIntersectionCandidate_not_mem_iff_center_mem F E hdeg C hArc hC m o

/-- Empty fixed carriers through the center of a bundled secant orbit. -/
noncomputable def emptyCarriersThroughOrbitCenter (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C)
    (o : SecantOrbitClass F E hdeg C hC) :
    Finset {m // m ∈ emptyFixedLines F E C} := by
  classical
  exact (allEmptyCarrierClasses F E C).filter fun m =>
    secantOrbitCenter F E hdeg C hArc hC
      (secantOrbitRepresentative F E hdeg C hC o) ∈ m.1.1

theorem card_emptyCarriersThroughOrbitCenter_eq_filter (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C)
    (o : SecantOrbitClass F E hdeg C hC) :
    (emptyCarriersThroughOrbitCenter F E hdeg C hArc hC o).card =
      ((emptyFixedLines F E C) ∩ fixedLinesThroughFinset F E
        (secantOrbitCenter F E hdeg C hArc hC
          (secantOrbitRepresentative F E hdeg C hC o))).card := by
  classical
  let z := secantOrbitCenter F E hdeg C hArc hC
    (secantOrbitRepresentative F E hdeg C hC o)
  let p : QuadraticLineCounting.FixedLine F E → Prop := fun m => z ∈ m.1
  rw [emptyCarriersThroughOrbitCenter, allEmptyCarrierClasses]
  change (((emptyFixedLines F E C).attach.filter fun m => p m.1).card) = _
  rw [Finset.filter_attach p, Finset.card_map, Finset.card_attach]
  congr 1
  ext m
  simp only [Finset.mem_filter, Finset.mem_inter, fixedLinesThroughFinset,
    allFixedLines, Finset.mem_univ, true_and, p, z]
  rfl

/-- Over `GF(5)`, a fixed secant-orbit center incident with at most four occupied fixed lines lies
on at least two empty fixed carriers. -/
theorem two_le_card_emptyCarriersThroughOrbitCenter_of_occupied_le_four
    (hdeg : Module.finrank F E = 2) (hF : Nat.card F = 5)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C)
    (o : SecantOrbitClass F E hdeg C hC)
    (hoccupied :
      ((occupiedFixedLines F E C) ∩ fixedLinesThroughFinset F E
        (secantOrbitCenter F E hdeg C hArc hC
          (secantOrbitRepresentative F E hdeg C hC o))).card ≤ 4) :
    2 ≤ (emptyCarriersThroughOrbitCenter F E hdeg C hArc hC o).card := by
  let z := secantOrbitCenter F E hdeg C hArc hC
    (secantOrbitRepresentative F E hdeg C hC o)
  have hzfixed : (incidence F E hdeg).pointConj z = z :=
    secantOrbitCenter_fixed F E hdeg C hArc hC
      (secantOrbitRepresentative F E hdeg C hC o)
  have hthrough : (fixedLinesThroughFinset F E z).card = 6 := by
    rw [card_fixedLinesThroughFinset F E z,
      natCard_fixedLinesThrough_fixed F E hdeg z hzfixed, hF]
  have hset :
      (emptyFixedLines F E C) ∩ fixedLinesThroughFinset F E z =
        fixedLinesThroughFinset F E z \ occupiedFixedLines F E C := by
    ext m
    simp [emptyFixedLines, allFixedLines, and_comm]
  have hoccupiedZ :
      ((occupiedFixedLines F E C) ∩ fixedLinesThroughFinset F E z).card ≤ 4 := by
    simpa only [z] using hoccupied
  rw [card_emptyCarriersThroughOrbitCenter_eq_filter F E hdeg C hArc hC o,
    show secantOrbitCenter F E hdeg C hArc hC
      (secantOrbitRepresentative F E hdeg C hC o) = z by rfl,
    hset, Finset.card_sdiff]
  rw [hthrough]
  omega

/-- Aggregate invisibility is the incidence count obtained by summing, over secant orbits, the
number of empty fixed carriers through their centers. -/
theorem sum_card_invisible_eq_sum_card_emptyCarriersThroughOrbitCenter
    (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C) :
    (∑ m ∈ allEmptyCarrierClasses F E C,
        (invisibleSecantOrbitClasses F E hdeg C hC m).card) =
      ∑ o ∈ allSecantOrbitClasses F E hdeg C hC,
        (emptyCarriersThroughOrbitCenter F E hdeg C hArc hC o).card := by
  classical
  have hinvisible (m : {m // m ∈ emptyFixedLines F E C}) :
      invisibleSecantOrbitClasses F E hdeg C hC m =
        (allSecantOrbitClasses F E hdeg C hC).filter fun o =>
          secantOrbitCenter F E hdeg C hArc hC
            (secantOrbitRepresentative F E hdeg C hC o) ∈ m.1.1 := by
    ext o
    simp only [Finset.mem_filter, allSecantOrbitClasses, Finset.mem_univ, true_and]
    exact mem_invisibleSecantOrbitClasses_iff_center_mem F E hdeg C hArc hC m o
  simp_rw [hinvisible]
  simp_rw [emptyCarriersThroughOrbitCenter]
  simp_rw [Finset.card_eq_sum_ones]
  simp_rw [Finset.sum_filter]
  rw [Finset.sum_comm]

/-- Any family of secant orbits whose centers each lie on at least `n` empty carriers contributes
at least `|S| n` to aggregate invisibility. -/
theorem card_mul_le_sum_card_invisible_of_center_capacity
    (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C)
    (S : Finset (SecantOrbitClass F E hdeg C hC)) (n : ℕ)
    (hS : S ⊆ allSecantOrbitClasses F E hdeg C hC)
    (hcapacity : ∀ o ∈ S,
      n ≤ (emptyCarriersThroughOrbitCenter F E hdeg C hArc hC o).card) :
    S.card * n ≤
      ∑ m ∈ allEmptyCarrierClasses F E C,
        (invisibleSecantOrbitClasses F E hdeg C hC m).card := by
  rw [sum_card_invisible_eq_sum_card_emptyCarriersThroughOrbitCenter
    F E hdeg C hArc hC]
  calc
    S.card * n = ∑ _o ∈ S, n := by simp
    _ ≤ ∑ o ∈ S,
        (emptyCarriersThroughOrbitCenter F E hdeg C hArc hC o).card := by
      exact Finset.sum_le_sum fun o ho => hcapacity o ho
    _ ≤ ∑ o ∈ allSecantOrbitClasses F E hdeg C hC,
        (emptyCarriersThroughOrbitCenter F E hdeg C hArc hC o).card := by
      exact Finset.sum_le_sum_of_subset hS

end
end QuadraticInvisible
end RelativeConicArcs
