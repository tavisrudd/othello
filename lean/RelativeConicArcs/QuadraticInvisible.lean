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
