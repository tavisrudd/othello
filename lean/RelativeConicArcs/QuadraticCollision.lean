import FiniteGeom.BaerCompletion.CollisionProfile
import RelativeConicArcs.QuadraticForbidden

/-!
# Exact quadratic carrier charge profiles

This file instantiates the abstract collision-accounting identity for the nonfixed secant orbits of
a quadratic-Frobenius invariant arc. It proves an exact decomposition into distinct forbidden
support, invisible secant orbits, and collision redundancy on each empty fixed carrier.

The present visibility predicate is defined by whether the orbit's intersection pair belongs to the
nonfixed candidate set. A later incidence lemma may identify invisibility with the orbit center lying
on the carrier; the exact counting theorem does not depend on that geometric rephrasing.
-/

namespace RelativeConicArcs
namespace QuadraticCollision

noncomputable section

open Configuration Finset
open FiniteGeom.BaerCompletion QuadraticFrobenius QuadraticLineCounting QuadraticForbidden

variable (F E : Type) [Field F] [Fintype F] [Field E] [Finite E] [Algebra F E]
  [Algebra.IsAlgebraic F E]

abbrev Point := ProjectiveConjugation.Point E
abbrev FixedLine := FixedProjectivePoint F E

local instance : Fintype E := Fintype.ofFinite E
local instance : DecidableEq E := Classical.decEq E
local instance : DecidableEq (Point E) := Classical.decEq _
local instance : DecidableEq (FixedLine F E) := Classical.decEq _
local instance : DecidableRel fun p l : Point E => p.orthogonal l := Classical.decRel _

/-- A nonfixed old-secant orbit, bundled with membership in the finite orbit set. -/
abbrev SecantOrbitClass (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hC : IsInvariant (incidence F E hdeg) C) :=
  {o // o ∈ nonfixedSecantOrbits F E hdeg C hC}

/-- All nonfixed old-secant orbits as a finset of the bundled orbit type. -/
noncomputable def allSecantOrbitClasses (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hC : IsInvariant (incidence F E hdeg) C) :
    Finset (SecantOrbitClass F E hdeg C hC) :=
  Finset.univ

/-- A chosen nonfixed old secant representing an orbit class. -/
noncomputable def secantOrbitRepresentative (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hC : IsInvariant (incidence F E hdeg) C)
    (o : SecantOrbitClass F E hdeg C hC) : NonfixedArcPair F E C hC :=
  Classical.choose (Finset.mem_image.mp o.2)

theorem secantOrbitRepresentative_spec (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hC : IsInvariant (incidence F E hdeg) C)
    (o : SecantOrbitClass F E hdeg C hC) :
    secantOrbit F E hdeg C hC (secantOrbitRepresentative F E hdeg C hC o) = o.1 :=
  (Classical.choose_spec (Finset.mem_image.mp o.2)).2

/-- The orbit class containing a chosen nonfixed old secant. -/
noncomputable def secantOrbitClassOfPair (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hC : IsInvariant (incidence F E hdeg) C)
    (a : NonfixedArcPair F E C hC) : SecantOrbitClass F E hdeg C hC :=
  ⟨secantOrbit F E hdeg C hC a,
    Finset.mem_image.mpr ⟨a, Finset.mem_univ _, rfl⟩⟩

/-- Candidate pair cut out on an empty fixed carrier by a nonfixed secant-orbit class. -/
noncomputable def orbitIntersectionCandidate (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hC : IsInvariant (incidence F E hdeg) C)
    (m : {m // m ∈ emptyFixedLines F E C})
    (o : SecantOrbitClass F E hdeg C hC) : Sym2 (Point E) :=
  secantIntersectionCandidate F E hdeg C hC m
    (secantOrbitRepresentative F E hdeg C hC o)

/-- The orbit-class charge agrees with the candidate cut out by every representative. -/
theorem orbitIntersectionCandidate_classOfPair (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C)
    (m : {m // m ∈ emptyFixedLines F E C})
    (a : NonfixedArcPair F E C hC) :
    orbitIntersectionCandidate F E hdeg C hC m
      (secantOrbitClassOfPair F E hdeg C hC a) =
        secantIntersectionCandidate F E hdeg C hC m a := by
  let o := secantOrbitClassOfPair F E hdeg C hC a
  let b := secantOrbitRepresentative F E hdeg C hC o
  have horbit : secantOrbit F E hdeg C hC b = secantOrbit F E hdeg C hC a := by
    have hspec := secantOrbitRepresentative_spec F E hdeg C hC o
    exact hspec
  have hba := (secantOrbit_eq_iff F E hdeg C hC b a).mp horbit
  change secantIntersectionCandidate F E hdeg C hC m b =
    secantIntersectionCandidate F E hdeg C hC m a
  rcases hba with hba | hba
  · rw [hba]
  · rw [hba]
    exact secantIntersectionCandidate_mate F E hdeg C hArc hC m a

/-- Secant-orbit classes whose carrier intersection is a nonfixed conjugate candidate. -/
noncomputable def visibleSecantOrbitClasses (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hC : IsInvariant (incidence F E hdeg) C)
    (m : {m // m ∈ emptyFixedLines F E C}) :
    Finset (SecantOrbitClass F E hdeg C hC) :=
  (allSecantOrbitClasses F E hdeg C hC).filter fun o =>
    orbitIntersectionCandidate F E hdeg C hC m o ∈
      conjugateCandidatesOnFixedLine F E hdeg m.1

/-- Nonfixed secant-orbit classes invisible on this carrier. -/
noncomputable def invisibleSecantOrbitClasses (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hC : IsInvariant (incidence F E hdeg) C)
    (m : {m // m ∈ emptyFixedLines F E C}) :
    Finset (SecantOrbitClass F E hdeg C hC) :=
  allSecantOrbitClasses F E hdeg C hC \
    visibleSecantOrbitClasses F E hdeg C hC m

/-- Collision redundancy of the visible orbit-to-candidate charge on one carrier. -/
noncomputable def secantCollisionRedundancy (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hC : IsInvariant (incidence F E hdeg) C)
    (m : {m // m ∈ emptyFixedLines F E C}) : ℕ :=
  collisionRedundancy (visibleSecantOrbitClasses F E hdeg C hC m)
    (orbitIntersectionCandidate F E hdeg C hC m)

/-- The support of visible secant-orbit charges is exactly the coordinate forbidden-candidate
set. -/
theorem chargeSupport_visible_eq_forbiddenCandidates (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C)
    (m : {m // m ∈ emptyFixedLines F E C}) :
    chargeSupport (visibleSecantOrbitClasses F E hdeg C hC m)
        (orbitIntersectionCandidate F E hdeg C hC m) =
      forbiddenCandidates F E hdeg C hC m := by
  ext q
  constructor
  · intro hq
    obtain ⟨o, ho, hcharge⟩ := Finset.mem_image.mp hq
    have hcand := (Finset.mem_filter.mp ho).2
    apply Finset.mem_filter.mpr
    constructor
    · rw [← hcharge]
      exact hcand
    · refine ⟨secantOrbitRepresentative F E hdeg C hC o, ?_⟩
      simpa [orbitIntersectionCandidate] using hcharge
  · intro hq
    have hparts := Finset.mem_filter.mp hq
    obtain ⟨a, ha⟩ := hparts.2
    let o := secantOrbitClassOfPair F E hdeg C hC a
    have hcharge : orbitIntersectionCandidate F E hdeg C hC m o = q := by
      rw [orbitIntersectionCandidate_classOfPair F E hdeg C hArc hC m a]
      exact ha
    apply Finset.mem_image.mpr
    refine ⟨o, ?_, hcharge⟩
    apply Finset.mem_filter.mpr
    exact ⟨Finset.mem_univ _, hcharge.symm ▸ hparts.1⟩

/-- Exact subtraction-free linewise correction for the quadratic-Frobenius charge. -/
theorem card_legal_add_orbits_eq_candidates_add_invisible_add_redundancy
    (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C)
    (m : {m // m ∈ emptyFixedLines F E C}) :
    (conjugateCandidatesOnFixedLine F E hdeg m.1 \
        forbiddenCandidates F E hdeg C hC m).card +
        (allSecantOrbitClasses F E hdeg C hC).card =
      (conjugateCandidatesOnFixedLine F E hdeg m.1).card +
        (invisibleSecantOrbitClasses F E hdeg C hC m).card +
          secantCollisionRedundancy F E hdeg C hC m := by
  let all := allSecantOrbitClasses F E hdeg C hC
  let visible := visibleSecantOrbitClasses F E hdeg C hC m
  let candidates := conjugateCandidatesOnFixedLine F E hdeg m.1
  let charge := orbitIntersectionCandidate F E hdeg C hC m
  have hvisible : visible ⊆ all := Finset.filter_subset _ _
  have hsupport : chargeSupport visible charge ⊆ candidates := by
    rw [show chargeSupport visible charge = forbiddenCandidates F E hdeg C hC m by
      exact chargeSupport_visible_eq_forbiddenCandidates F E hdeg C hArc hC m]
    exact Finset.filter_subset _ _
  have hbalance :=
    FiniteGeom.BaerCompletion.card_legal_add_orbits_eq_candidates_add_invisible_add_redundancy
      all visible candidates charge hvisible hsupport
  rw [show chargeSupport visible charge = forbiddenCandidates F E hdeg C hC m by
    exact chargeSupport_visible_eq_forbiddenCandidates F E hdeg C hArc hC m] at hbalance
  exact hbalance

/-- All empty fixed carriers as a finset of the bundled carrier type. -/
noncomputable def allEmptyCarrierClasses
    (C : Finset (Point E)) : Finset {m // m ∈ emptyFixedLines F E C} :=
  Finset.univ

/-- Aggregate exact balance over all empty fixed carriers. -/
theorem sum_card_legal_add_carriers_mul_orbits_eq_sum_candidates_add_invisible_add_redundancy
    (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C) :
    (∑ m ∈ allEmptyCarrierClasses F E C,
        (conjugateCandidatesOnFixedLine F E hdeg m.1 \
          forbiddenCandidates F E hdeg C hC m).card) +
        (allEmptyCarrierClasses F E C).card *
          (allSecantOrbitClasses F E hdeg C hC).card =
      (∑ m ∈ allEmptyCarrierClasses F E C,
          (conjugateCandidatesOnFixedLine F E hdeg m.1).card) +
        (∑ m ∈ allEmptyCarrierClasses F E C,
          (invisibleSecantOrbitClasses F E hdeg C hC m).card) +
        ∑ m ∈ allEmptyCarrierClasses F E C,
          secantCollisionRedundancy F E hdeg C hC m := by
  let carriers := allEmptyCarrierClasses F E C
  let orbits := allSecantOrbitClasses F E hdeg C hC
  let visible := fun m : {m // m ∈ emptyFixedLines F E C} =>
    visibleSecantOrbitClasses F E hdeg C hC m
  let candidates := fun m : {m // m ∈ emptyFixedLines F E C} =>
    conjugateCandidatesOnFixedLine F E hdeg m.1
  let charge := fun m : {m // m ∈ emptyFixedLines F E C} =>
    orbitIntersectionCandidate F E hdeg C hC m
  have hvisible : ∀ m ∈ carriers, visible m ⊆ orbits := by
    intro m _hm
    exact Finset.filter_subset _ _
  have hsupport : ∀ m ∈ carriers, chargeSupport (visible m) (charge m) ⊆ candidates m := by
    intro m _hm
    rw [show chargeSupport (visible m) (charge m) = forbiddenCandidates F E hdeg C hC m by
      exact chargeSupport_visible_eq_forbiddenCandidates F E hdeg C hArc hC m]
    exact Finset.filter_subset _ _
  have hbalance :=
    FiniteGeom.BaerCompletion.sum_card_legal_add_carriers_mul_orbits_eq_sum_candidates_add_invisible_add_redundancy
      carriers orbits visible candidates charge hvisible hsupport
  dsimp [carriers, orbits, visible, candidates, charge] at hbalance
  simp_rw [chargeSupport_visible_eq_forbiddenCandidates F E hdeg C hArc hC] at hbalance
  simpa [invisibleSecantOrbitClasses, invisibleOrbits, secantCollisionRedundancy] using hbalance

/-- Aggregate invisibility can force an extension even when the uniform per-carrier inequality
`M < N` fails. -/
theorem exists_arc_extension_of_aggregate_invisible_capacity
    (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C)
    (hcapacity :
      (allEmptyCarrierClasses F E C).card *
          (allSecantOrbitClasses F E hdeg C hC).card <
        (∑ m ∈ allEmptyCarrierClasses F E C,
          (conjugateCandidatesOnFixedLine F E hdeg m.1).card) +
        ∑ m ∈ allEmptyCarrierClasses F E C,
          (invisibleSecantOrbitClasses F E hdeg C hC m).card) :
    ∃ (m : {m // m ∈ emptyFixedLines F E C}) (q : Sym2 (Point E)),
      q ∈ conjugateCandidatesOnFixedLine F E hdeg m.1 ∧
        Arc (L := Point E) (C ∪ q.toFinset) := by
  let carriers := allEmptyCarrierClasses F E C
  let orbits := allSecantOrbitClasses F E hdeg C hC
  let visible := fun m : {m // m ∈ emptyFixedLines F E C} =>
    visibleSecantOrbitClasses F E hdeg C hC m
  let candidates := fun m : {m // m ∈ emptyFixedLines F E C} =>
    conjugateCandidatesOnFixedLine F E hdeg m.1
  let charge := fun m : {m // m ∈ emptyFixedLines F E C} =>
    orbitIntersectionCandidate F E hdeg C hC m
  have hvisible : ∀ m ∈ carriers, visible m ⊆ orbits := by
    intro m _hm
    exact Finset.filter_subset _ _
  have hsupport : ∀ m ∈ carriers, chargeSupport (visible m) (charge m) ⊆ candidates m := by
    intro m _hm
    rw [show chargeSupport (visible m) (charge m) = forbiddenCandidates F E hdeg C hC m by
      exact chargeSupport_visible_eq_forbiddenCandidates F E hdeg C hArc hC m]
    exact Finset.filter_subset _ _
  have hcapacity' : carriers.card * orbits.card <
      (∑ m ∈ carriers, (candidates m).card) +
        ∑ m ∈ carriers, (invisibleOrbits orbits (visible m)).card := by
    simpa [carriers, orbits, visible, candidates, invisibleSecantOrbitClasses,
      invisibleOrbits] using hcapacity
  obtain ⟨m, _hm, hlegal⟩ :=
    FiniteGeom.BaerCompletion.exists_legal_of_carriers_mul_orbits_lt_sum_candidates_add_invisible
      carriers orbits visible candidates charge hvisible hsupport hcapacity'
  obtain ⟨q, hq⟩ := hlegal
  have hparts := Finset.mem_sdiff.mp hq
  have hqforbidden : q ∉ forbiddenCandidates F E hdeg C hC m := by
    intro hforbidden
    apply hparts.2
    rw [chargeSupport_visible_eq_forbiddenCandidates F E hdeg C hArc hC m]
    exact hforbidden
  exact ⟨m, q, hparts.1,
    arc_union_candidate_of_not_mem_forbidden F E hdeg C hArc hC m q hparts.1 hqforbidden⟩

end
end QuadraticCollision
end RelativeConicArcs
