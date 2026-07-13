import RelativeConicArcs.QuadraticPairExtension

/-!
# Nonfixed secant orbits and forbidden quadratic candidates

This module formalizes the second coordinate gate in the quadratic pair-extension theorem.  The
first layer counts nonfixed old secants modulo Frobenius.  The second layer charges every locally
forbidden conjugate candidate on an empty fixed line to one such secant orbit.
-/

namespace RelativeConicArcs
namespace QuadraticForbidden

noncomputable section

open Configuration Finset
open FiniteGeom.BaerCompletion QuadraticFrobenius QuadraticLineCounting

variable (F E : Type) [Field F] [Fintype F] [Field E] [Finite E] [Algebra F E]
  [Algebra.IsAlgebraic F E]

abbrev Point := ProjectiveConjugation.Point E
abbrev FixedLine := FixedProjectivePoint F E

local instance : Fintype E := Fintype.ofFinite E
local instance : DecidableEq E := Classical.decEq E
local instance : DecidableEq (Point E) := Classical.decEq _
local instance : DecidableEq (FixedLine F E) := Classical.decEq _
local instance : DecidableRel fun p l : Point E => p.orthogonal l := Classical.decRel _

/-- Conjugation is involutive on unordered endpoint pairs of an invariant set. -/
theorem conjugateArcPair_involutive (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hC : IsInvariant (incidence F E hdeg) C) :
    Function.Involutive (conjugateArcPair F E C hC) := by
  intro a
  apply Subtype.ext
  ext p
  simp only [conjugateArcPair, Finset.mem_map, Equiv.toEmbedding_apply]
  constructor
  · rintro ⟨q, ⟨r, hra, hrq⟩, hqp⟩
    change (incidence F E hdeg).pointConj r = q at hrq
    change (incidence F E hdeg).pointConj q = p at hqp
    subst q
    rw [(incidence F E hdeg).point_involutive r] at hqp
    simpa [hqp] using hra
  · intro hp
    refine ⟨(incidence F E hdeg).pointConj p, ?_,
      (incidence F E hdeg).point_involutive p⟩
    exact ⟨p, hp, rfl⟩

/-- A secant endpoint pair is invariant exactly when its joining line is fixed. -/
theorem conjugateArcPair_eq_iff_line_fixed (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C) (a : ArcPair C) :
    conjugateArcPair F E C hC a = a ↔
      (incidence F E hdeg).lineConj (a.line (L := Point E)) = a.line (L := Point E) := by
  constructor
  · exact line_fixed_of_conjugateArcPair_eq F E C hArc hC a
  · intro hline
    apply ArcPair.line_injective hArc
    rw [line_conjugateArcPair F E C hC, hline]

/-- Old secants whose joining line is not fixed. -/
abbrev NonfixedArcPair (C : Finset (Point E))
    (hC : IsInvariant (incidence F E hdeg) C) :=
  {a : ArcPair C // conjugateArcPair F E C hC a ≠ a}

/-- Conjugation on nonfixed old secants. -/
noncomputable def nonfixedSecantMate (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hC : IsInvariant (incidence F E hdeg) C) :
    NonfixedArcPair F E C hC ≃ NonfixedArcPair F E C hC where
  toFun a := ⟨conjugateArcPair F E C hC a.1, by
    intro hfix
    exact a.2 (hfix.symm.trans (conjugateArcPair_involutive F E hdeg C hC a.1))⟩
  invFun a := ⟨conjugateArcPair F E C hC a.1, by
    intro hfix
    exact a.2 (hfix.symm.trans (conjugateArcPair_involutive F E hdeg C hC a.1))⟩
  left_inv a := by apply Subtype.ext; exact conjugateArcPair_involutive F E hdeg C hC a.1
  right_inv a := by apply Subtype.ext; exact conjugateArcPair_involutive F E hdeg C hC a.1

/-- The unordered conjugate orbit of a nonfixed old secant. -/
noncomputable def secantOrbit (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hC : IsInvariant (incidence F E hdeg) C)
    (a : NonfixedArcPair F E C hC) : Sym2 (ArcPair C) :=
  s(a.1, (nonfixedSecantMate F E hdeg C hC a).1)

noncomputable def nonfixedArcPairs (C : Finset (Point E))
    (hC : IsInvariant (incidence F E hdeg) C) : Finset (NonfixedArcPair F E C hC) :=
  Finset.univ

noncomputable def nonfixedSecantOrbits (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hC : IsInvariant (incidence F E hdeg) C) :
    Finset (Sym2 (ArcPair C)) :=
  (nonfixedArcPairs F E C hC).image (secantOrbit F E hdeg C hC)

theorem secantOrbit_eq_iff (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hC : IsInvariant (incidence F E hdeg) C)
    (a b : NonfixedArcPair F E C hC) :
    secantOrbit F E hdeg C hC a = secantOrbit F E hdeg C hC b ↔
      a = b ∨ a = nonfixedSecantMate F E hdeg C hC b := by
  constructor
  · intro h
    rw [secantOrbit, secantOrbit, Sym2.eq_iff] at h
    rcases h with h | h
    · left; exact Subtype.ext h.1
    · right; exact Subtype.ext h.1
  · rintro (rfl | rfl)
    · rfl
    · rw [secantOrbit, secantOrbit, Sym2.eq_iff]
      right
      exact ⟨rfl, congrArg Subtype.val ((nonfixedSecantMate F E hdeg C hC).left_inv b)⟩

noncomputable def secantOrbitFiber (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hC : IsInvariant (incidence F E hdeg) C)
    (a : NonfixedArcPair F E C hC) : Finset (NonfixedArcPair F E C hC) :=
  (nonfixedArcPairs F E C hC).filter fun b =>
    secantOrbit F E hdeg C hC b = secantOrbit F E hdeg C hC a

theorem secantOrbit_fiber_card (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hC : IsInvariant (incidence F E hdeg) C)
    (a : NonfixedArcPair F E C hC) :
    (secantOrbitFiber F E hdeg C hC a).card = 2 := by
  classical
  have hne : a ≠ nonfixedSecantMate F E hdeg C hC a := by
    intro h
    have hv := congrArg Subtype.val h
    change a.1 = conjugateArcPair F E C hC a.1 at hv
    exact a.2 hv.symm
  have heq : secantOrbitFiber F E hdeg C hC a =
      {a, nonfixedSecantMate F E hdeg C hC a} := by
    ext b
    simp only [secantOrbitFiber, nonfixedArcPairs, Finset.mem_filter, Finset.mem_univ,
      true_and, Finset.mem_insert, Finset.mem_singleton]
    exact secantOrbit_eq_iff F E hdeg C hC b a
  rw [heq]
  simp [hne]

/-- The number of nonfixed old secants is the total number of secants minus the fixed secants. -/
theorem natCard_nonfixedArcPair (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hC : IsInvariant (incidence F E hdeg) C) :
    Nat.card (NonfixedArcPair F E C hC) =
      Nat.choose C.card 2 - Nat.card (InvariantArcPair F E C hC) := by
  classical
  let pred : ArcPair C → Prop := fun a => conjugateArcPair F E C hC a = a
  have hcomp := Fintype.card_subtype_compl pred
  change Nat.card {a : ArcPair C // ¬ pred a} = _
  rw [Nat.card_eq_fintype_card, hcomp]
  have htotal : Fintype.card (ArcPair C) = Nat.choose C.card 2 := card_arcPair C
  rw [htotal]
  congr 1
  rw [← Nat.card_eq_fintype_card]

/-- **Exact nonfixed-secant orbit count.** For an invariant arc with profile
`k=f+2e`, conjugation has exactly `(choose(k,2)-(choose(f,2)+e))/2` nonfixed secant
orbits. -/
theorem card_nonfixedSecantOrbits (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C) (k f e : ℕ)
    (hkcard : C.card = k) (hf : (fixedArcPoints F E C).card = f)
    (horbit : k = f + 2 * e) :
    (nonfixedSecantOrbits F E hdeg C hC).card =
      baerNonInvariantSecantOrbits k f e := by
  classical
  have hnonpoints : Nat.card (NonfixedArcPoint F E C) = 2 * e := by
    rw [natCard_nonfixedArcPoint F E C, hf, hkcard, horbit]
    omega
  have hinvariant : Nat.card (InvariantArcPair F E C hC) = f.choose 2 + e := by
    rw [natCard_invariantArcPair F E C hC,
      natCard_fixedInvariantArcPair F E C hC,
      natCard_conjugateInvariantArcPair F E C hC e hnonpoints, hf]
  let S := nonfixedArcPairs F E C hC
  let T := nonfixedSecantOrbits F E hdeg C hC
  have hfiber : ∀ q ∈ T,
      (S.filter fun a => secantOrbit F E hdeg C hC a = q).card = 2 := by
    intro q hq
    obtain ⟨a, ha, rfl⟩ := Finset.mem_image.mp hq
    exact secantOrbit_fiber_card F E hdeg C hC a
  have hmul := card_eq_card_mul_of_constant_fibers S T
    (secantOrbit F E hdeg C hC) 2
    (fun a ha => Finset.mem_image.mpr ⟨a, ha, rfl⟩) hfiber
  have hS : S.card = k.choose 2 - (f.choose 2 + e) := by
    rw [show S.card = Nat.card (NonfixedArcPair F E C hC) by
      simp [S, nonfixedArcPairs, Nat.card_eq_fintype_card]]
    rw [natCard_nonfixedArcPair F E hdeg C hC, hkcard, hinvariant]
  rw [hS] at hmul
  unfold baerNonInvariantSecantOrbits
  change T.card = _
  omega

/-- An empty fixed line has empty selected trace. -/
theorem fixedLineTrace_eq_empty_of_mem_emptyFixedLines
    (C : Finset (Point E)) (m : {m // m ∈ emptyFixedLines F E C}) :
    fixedLineTrace F E C m.1 = ∅ := by
  classical
  apply Finset.not_nonempty_iff_eq_empty.mp
  intro hne
  have hmocc : m.1 ∈ occupiedFixedLines F E C :=
    Finset.mem_filter.mpr ⟨Finset.mem_univ _, hne⟩
  exact (Finset.mem_sdiff.mp m.2).2 hmocc

/-- A nonfixed old secant cannot equal an empty fixed line. -/
theorem arcPairLine_ne_emptyFixedLine
    (C : Finset (Point E)) (m : {m // m ∈ emptyFixedLines F E C}) (a : ArcPair C) :
    a.line (L := Point E) ≠ m.1.1 := by
  intro heq
  obtain ⟨p, q, hpq, ha⟩ := a.exists_eq_pair
  have hp : p ∈ a.1 := by simp [ha]
  have hpC := a.subset hp
  have hpline := a.mem_line (L := Point E) hp
  have hporth : p.orthogonal m.1.1 := by
    change p.orthogonal (a.line (L := Point E)) at hpline
    simpa [heq] using hpline
  have hptrace : p ∈ fixedLineTrace F E C m.1 :=
    Finset.mem_filter.mpr ⟨hpC, hporth⟩
  rw [fixedLineTrace_eq_empty_of_mem_emptyFixedLines F E C m] at hptrace
  simp at hptrace

/-- A nonfixed old secant cannot equal an empty fixed line. -/
theorem pairLine_ne_emptyFixedLine (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hC : IsInvariant (incidence F E hdeg) C)
    (m : {m // m ∈ emptyFixedLines F E C}) (a : NonfixedArcPair F E C hC) :
    a.1.line (L := Point E) ≠ m.1.1 := by
  exact arcPairLine_ne_emptyFixedLine F E C m a.1

/-- Intersection of a nonfixed old secant with an empty fixed line. -/
noncomputable def secantIntersection (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hC : IsInvariant (incidence F E hdeg) C)
    (m : {m // m ∈ emptyFixedLines F E C}) (a : NonfixedArcPair F E C hC) : Point E :=
  Configuration.HasPoints.mkPoint (pairLine_ne_emptyFixedLine F E hdeg C hC m a)

theorem secantIntersection_mem_pairLine (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hC : IsInvariant (incidence F E hdeg) C)
    (m : {m // m ∈ emptyFixedLines F E C}) (a : NonfixedArcPair F E C hC) :
    secantIntersection F E hdeg C hC m a ∈ a.1.line (L := Point E) :=
  (Configuration.HasPoints.mkPoint_ax
    (pairLine_ne_emptyFixedLine F E hdeg C hC m a)).1

theorem secantIntersection_mem_emptyLine (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hC : IsInvariant (incidence F E hdeg) C)
    (m : {m // m ∈ emptyFixedLines F E C}) (a : NonfixedArcPair F E C hC) :
    secantIntersection F E hdeg C hC m a ∈ m.1.1 :=
  (Configuration.HasPoints.mkPoint_ax
    (pairLine_ne_emptyFixedLine F E hdeg C hC m a)).2

/-- The candidate pair cut out on `m` by a nonfixed secant orbit. -/
noncomputable def secantIntersectionCandidate (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hC : IsInvariant (incidence F E hdeg) C)
    (m : {m // m ∈ emptyFixedLines F E C}) (a : NonfixedArcPair F E C hC) :
    Sym2 (Point E) :=
  s(secantIntersection F E hdeg C hC m a,
    (incidence F E hdeg).pointConj (secantIntersection F E hdeg C hC m a))

/-- Conjugate secants cut out the same conjugate candidate pair on a fixed line. -/
theorem secantIntersectionCandidate_mate (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C)
    (m : {m // m ∈ emptyFixedLines F E C}) (a : NonfixedArcPair F E C hC) :
    secantIntersectionCandidate F E hdeg C hC m
      (nonfixedSecantMate F E hdeg C hC a) =
        secantIntersectionCandidate F E hdeg C hC m a := by
  let σ : Point E ≃ Point E := (incidence F E hdeg).pointConj
  let x := secantIntersection F E hdeg C hC m a
  let b := nonfixedSecantMate F E hdeg C hC a
  let y := secantIntersection F E hdeg C hC m b
  have hlineb : b.1.line (L := Point E) =
      (incidence F E hdeg).lineConj (a.1.line (L := Point E)) :=
    line_conjugateArcPair F E C hC a.1
  have hσxline : σ x ∈ b.1.line (L := Point E) := by
    have hx := secantIntersection_mem_pairLine F E hdeg C hC m a
    have hxG : (incidence F E hdeg).incident x (a.1.line (L := Point E)) := by
      change x.orthogonal (a.1.line (L := Point E))
      exact hx
    have hc := ((incidence F E hdeg).incident_conj_iff
      x (a.1.line (L := Point E))).2 hxG
    change (incidence F E hdeg).incident ((incidence F E hdeg).pointConj x)
      (b.1.line (L := Point E))
    rw [hlineb]
    exact hc
  have hσxm : σ x ∈ m.1.1 := by
    have hx := secantIntersection_mem_emptyLine F E hdeg C hC m a
    have hxG : (incidence F E hdeg).incident x m.1.1 := by
      change x.orthogonal m.1.1
      exact hx
    have hc := ((incidence F E hdeg).incident_conj_iff x m.1.1).2 hxG
    change (incidence F E hdeg).incident ((incidence F E hdeg).pointConj x) m.1.1
    rw [← m.1.2]
    exact hc
  have hy : y = σ x := by
    apply (Configuration.HasPoints.existsUnique_point (P := Point E) (L := Point E)
      (b.1.line (L := Point E)) m.1.1
      (pairLine_ne_emptyFixedLine F E hdeg C hC m b)).unique
    exact ⟨secantIntersection_mem_pairLine F E hdeg C hC m b,
      secantIntersection_mem_emptyLine F E hdeg C hC m b⟩
    exact ⟨hσxline, hσxm⟩
  rw [secantIntersectionCandidate, secantIntersectionCandidate]
  change s(y, σ y) = s(x, σ x)
  rw [hy, (incidence F E hdeg).point_involutive x]
  rw [Sym2.eq_iff]
  exact Or.inr ⟨rfl, rfl⟩

/-- Candidate pairs on `m` cut out by at least one nonfixed old secant orbit. -/
noncomputable def forbiddenCandidates (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hC : IsInvariant (incidence F E hdeg) C)
    (m : {m // m ∈ emptyFixedLines F E C}) : Finset (Sym2 (Point E)) := by
  classical
  exact (conjugateCandidatesOnFixedLine F E hdeg m.1).filter fun q =>
    ∃ a : NonfixedArcPair F E C hC,
      secantIntersectionCandidate F E hdeg C hC m a = q

/-- A chosen old-secant witness for a forbidden candidate. -/
noncomputable def forbiddenWitness (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hC : IsInvariant (incidence F E hdeg) C)
    (m : {m // m ∈ emptyFixedLines F E C})
    (q : {q // q ∈ forbiddenCandidates F E hdeg C hC m}) :
    NonfixedArcPair F E C hC :=
  Classical.choose (Finset.mem_filter.mp q.2).2

theorem forbiddenWitness_spec (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hC : IsInvariant (incidence F E hdeg) C)
    (m : {m // m ∈ emptyFixedLines F E C})
    (q : {q // q ∈ forbiddenCandidates F E hdeg C hC m}) :
    secantIntersectionCandidate F E hdeg C hC m
      (forbiddenWitness F E hdeg C hC m q) = q.1 :=
  Classical.choose_spec (Finset.mem_filter.mp q.2).2

/-- Charge a forbidden candidate to the conjugation orbit of a witnessing old secant. -/
noncomputable def forbiddenCharge (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hC : IsInvariant (incidence F E hdeg) C)
    (m : {m // m ∈ emptyFixedLines F E C})
    (q : {q // q ∈ forbiddenCandidates F E hdeg C hC m}) :
    {o // o ∈ nonfixedSecantOrbits F E hdeg C hC} := by
  let a := forbiddenWitness F E hdeg C hC m q
  exact ⟨secantOrbit F E hdeg C hC a,
    Finset.mem_image.mpr ⟨a, Finset.mem_univ _, rfl⟩⟩

theorem forbiddenCharge_injective (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C)
    (m : {m // m ∈ emptyFixedLines F E C}) :
    Function.Injective (forbiddenCharge F E hdeg C hC m) := by
  intro q r hqr
  let a := forbiddenWitness F E hdeg C hC m q
  let b := forbiddenWitness F E hdeg C hC m r
  have horbit : secantOrbit F E hdeg C hC a = secantOrbit F E hdeg C hC b :=
    congrArg Subtype.val hqr
  have hab := (secantOrbit_eq_iff F E hdeg C hC a b).mp horbit
  apply Subtype.ext
  rw [← forbiddenWitness_spec F E hdeg C hC m q,
    ← forbiddenWitness_spec F E hdeg C hC m r]
  change secantIntersectionCandidate F E hdeg C hC m a =
    secantIntersectionCandidate F E hdeg C hC m b
  rcases hab with hab | hab
  · rw [hab]
  · rw [hab]
    exact secantIntersectionCandidate_mate F E hdeg C hArc hC m b

/-- **Forbidden-candidate charging bound.** Each forbidden candidate on an empty fixed line
charges injectively to a nonfixed old-secant orbit. -/
theorem card_forbiddenCandidates_le (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C)
    (m : {m // m ∈ emptyFixedLines F E C}) :
    (forbiddenCandidates F E hdeg C hC m).card ≤
      (nonfixedSecantOrbits F E hdeg C hC).card := by
  rw [← Fintype.card_coe, ← Fintype.card_coe]
  exact Fintype.card_le_of_injective _
    (forbiddenCharge_injective F E hdeg C hArc hC m)

/-- Arithmetic form of the forbidden bound required by `QuadraticBaerPairExtensionData`. -/
theorem card_forbiddenCandidates_le_baer (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C) (k f e : ℕ)
    (hkcard : C.card = k) (hf : (fixedArcPoints F E C).card = f)
    (horbit : k = f + 2 * e)
    (m : {m // m ∈ emptyFixedLines F E C}) :
    (forbiddenCandidates F E hdeg C hC m).card ≤
      baerNonInvariantSecantOrbits k f e := by
  rw [← card_nonfixedSecantOrbits F E hdeg C hArc hC k f e hkcard hf horbit]
  exact card_forbiddenCandidates_le F E hdeg C hArc hC m

/-- Membership in the coordinate candidate finset exposes a nonfixed point representative. -/
theorem mem_candidates_iff_exists (hdeg : Module.finrank F E = 2)
    (m : FixedLine F E) (q : Sym2 (Point E)) :
    q ∈ conjugateCandidatesOnFixedLine F E hdeg m ↔
      ∃ p : NonfixedPointsOnFixedLine F E m, matePair F E hdeg m p = q := by
  classical
  simp [conjugateCandidatesOnFixedLine, nonfixedPointsOnFixedLineFinset]

/-- Every endpoint of a coordinate candidate lies on its fixed line. -/
theorem candidate_mem_fixedLine (hdeg : Module.finrank F E = 2)
    (m : FixedLine F E) (q : Sym2 (Point E))
    (hq : q ∈ conjugateCandidatesOnFixedLine F E hdeg m)
    {p : Point E} (hp : p ∈ q) : p.orthogonal m.1 := by
  obtain ⟨x, rfl⟩ := (mem_candidates_iff_exists F E hdeg m q).mp hq
  rw [← Sym2.mem_iff_mem, matePair, Sym2.mem_iff'] at hp
  rcases hp with rfl | rfl
  · exact x.1.2
  · exact (nonfixedMate F E hdeg m x).1.2

/-- Candidate endpoints are nonfixed. -/
theorem candidate_point_nonfixed (hdeg : Module.finrank F E = 2)
    (m : FixedLine F E) (q : Sym2 (Point E))
    (hq : q ∈ conjugateCandidatesOnFixedLine F E hdeg m)
    {p : Point E} (hp : p ∈ q) :
    (incidence F E hdeg).pointConj p ≠ p := by
  obtain ⟨x, rfl⟩ := (mem_candidates_iff_exists F E hdeg m q).mp hq
  rw [← Sym2.mem_iff_mem, matePair, Sym2.mem_iff'] at hp
  rcases hp with rfl | rfl
  · exact x.2
  · exact (nonfixedMate F E hdeg m x).2

/-- Coordinate candidates contain two distinct points. -/
theorem candidate_toFinset_card (hdeg : Module.finrank F E = 2)
    (m : FixedLine F E) (q : Sym2 (Point E))
    (hq : q ∈ conjugateCandidatesOnFixedLine F E hdeg m) :
    q.toFinset.card = 2 := by
  obtain ⟨x, rfl⟩ := (mem_candidates_iff_exists F E hdeg m q).mp hq
  rw [matePair, Sym2.toFinset_mk_eq]
  have hne : x.1.1 ≠ (nonfixedMate F E hdeg m x).1.1 := by
    intro h
    exact x.2 h.symm
  simp [hne]

/-- A candidate on an empty fixed line is disjoint from the old selected set. -/
theorem candidate_disjoint_arc (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (m : {m // m ∈ emptyFixedLines F E C})
    (q : Sym2 (Point E)) (hq : q ∈ conjugateCandidatesOnFixedLine F E hdeg m.1) :
    Disjoint q.toFinset C := by
  rw [Finset.disjoint_left]
  intro p hpq hpC
  have hpm := candidate_mem_fixedLine F E hdeg m.1 q hq (Sym2.mem_toFinset.mp hpq)
  have hptrace : p ∈ fixedLineTrace F E C m.1 := Finset.mem_filter.mpr ⟨hpC, hpm⟩
  rw [fixedLineTrace_eq_empty_of_mem_emptyFixedLines F E C m] at hptrace
  simp at hptrace

/-- Two distinct fixed lines have a fixed intersection point. -/
theorem point_fixed_of_mem_two_fixedLines (hdeg : Module.finrank F E = 2)
    (l m : FixedLine F E) (hlm : l.1 ≠ m.1) (p : Point E)
    (hpl : p ∈ l.1) (hpm : p ∈ m.1) :
    (incidence F E hdeg).pointConj p = p := by
  let G := incidence F E hdeg
  have hσpl : G.pointConj p ∈ l.1 := by
    have hpG : G.incident p l.1 := by exact hpl
    have hc := (G.incident_conj_iff p l.1).2 hpG
    change (incidence F E hdeg).incident ((incidence F E hdeg).pointConj p)
      ((incidence F E hdeg).lineConj l.1) at hc
    have hlfix : (incidence F E hdeg).lineConj l.1 = l.1 := l.2
    rw [hlfix] at hc
    exact hc
  have hσpm : G.pointConj p ∈ m.1 := by
    have hpG : G.incident p m.1 := by exact hpm
    have hc := (G.incident_conj_iff p m.1).2 hpG
    change (incidence F E hdeg).incident ((incidence F E hdeg).pointConj p)
      ((incidence F E hdeg).lineConj m.1) at hc
    have hmfix : (incidence F E hdeg).lineConj m.1 = m.1 := m.2
    rw [hmfix] at hc
    exact hc
  exact (Configuration.HasPoints.existsUnique_point (P := Point E) (L := Point E)
    l.1 m.1 hlm).unique ⟨hpl, hpm⟩ ⟨hσpl, hσpm⟩ |>.symm

/-- A candidate is the unordered pair of any one of its endpoints and that endpoint's conjugate. -/
theorem candidate_eq_mk_of_mem (hdeg : Module.finrank F E = 2)
    (m : FixedLine F E) (q : Sym2 (Point E))
    (hq : q ∈ conjugateCandidatesOnFixedLine F E hdeg m)
    {p : Point E} (hp : p ∈ q) :
    q = s(p, (incidence F E hdeg).pointConj p) := by
  obtain ⟨x, rfl⟩ := (mem_candidates_iff_exists F E hdeg m q).mp hq
  rw [← Sym2.mem_iff_mem, matePair, Sym2.mem_iff'] at hp
  rcases hp with rfl | rfl
  · rfl
  · rw [matePair]
    have hv : (nonfixedMate F E hdeg m x).1.1 =
        (incidence F E hdeg).pointConj x.1.1 := rfl
    rw [hv, (incidence F E hdeg).point_involutive x.1.1]
    exact Sym2.eq_swap

/-- The joining line of an arc endpoint pair is a secant. -/
theorem arcPair_line_secant (C : Finset (Point E)) (a : ArcPair C) :
    Secant C (a.line (L := Point E)) := by
  obtain ⟨p, q, hpq, ha⟩ := a.exists_eq_pair
  exact ⟨p, a.subset (by simp [ha]), q, a.subset (by simp [ha]), hpq,
    a.mem_line (L := Point E) (by simp [ha]), a.mem_line (L := Point E) (by simp [ha])⟩

/-- A candidate endpoint covered by an old secant is charged to that secant's nonfixed orbit. -/
theorem candidate_mem_forbidden_of_covered (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C)
    (m : {m // m ∈ emptyFixedLines F E C}) (q : Sym2 (Point E))
    (hq : q ∈ conjugateCandidatesOnFixedLine F E hdeg m.1)
    {p : Point E} (hpq : p ∈ q) (hpcovered : Covered (L := Point E) C p) :
    q ∈ forbiddenCandidates F E hdeg C hC m := by
  obtain ⟨l, hlsec, hpl⟩ := covered_iff_exists_secant.mp hpcovered
  have hlmem : l ∈ secants (L := Point E) C := mem_secants.mpr hlsec
  rw [secants_eq_image_pairLine (L := Point E)] at hlmem
  obtain ⟨a, hauniv, hal⟩ := Finset.mem_image.mp hlmem
  have hal' : a.line (L := Point E) = l := hal
  have hpm : p ∈ m.1.1 := by
    change p.orthogonal m.1.1
    exact candidate_mem_fixedLine F E hdeg m.1 q hq hpq
  have hpairm : a.line (L := Point E) ≠ m.1.1 :=
    arcPairLine_ne_emptyFixedLine F E C m a
  have hlineNonfixed :
      (incidence F E hdeg).lineConj (a.line (L := Point E)) ≠ a.line (L := Point E) := by
    intro hfixed
    let fl : FixedLine F E := ⟨a.line (L := Point E), hfixed⟩
    have hpfix := point_fixed_of_mem_two_fixedLines F E hdeg fl m.1 hpairm p
      (by change p ∈ a.line (L := Point E); rw [hal']; exact hpl) hpm
    exact candidate_point_nonfixed F E hdeg m.1 q hq hpq hpfix
  have hainv : conjugateArcPair F E C hC a ≠ a := by
    intro ha
    exact hlineNonfixed ((conjugateArcPair_eq_iff_line_fixed F E hdeg C hArc hC a).1 ha)
  let na : NonfixedArcPair F E C hC := ⟨a, hainv⟩
  have hinter : secantIntersection F E hdeg C hC m na = p := by
    apply (Configuration.HasPoints.existsUnique_point (P := Point E) (L := Point E)
      (a.line (L := Point E)) m.1.1 hpairm).unique
    exact ⟨secantIntersection_mem_pairLine F E hdeg C hC m na,
      secantIntersection_mem_emptyLine F E hdeg C hC m na⟩
    exact ⟨by simpa [hal'] using hpl, hpm⟩
  have hcand : secantIntersectionCandidate F E hdeg C hC m na = q := by
    rw [secantIntersectionCandidate, hinter]
    exact (candidate_eq_mk_of_mem F E hdeg m.1 q hq hpq).symm
  exact Finset.mem_filter.mpr ⟨hq, ⟨na, hcand⟩⟩

/-- A charged candidate has an endpoint covered by an old secant. -/
theorem exists_covered_of_mem_forbidden (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hC : IsInvariant (incidence F E hdeg) C)
    (m : {m // m ∈ emptyFixedLines F E C}) (q : Sym2 (Point E))
    (hq : q ∈ forbiddenCandidates F E hdeg C hC m) :
    ∃ p ∈ q.toFinset, Covered (L := Point E) C p := by
  obtain ⟨a, ha⟩ := (Finset.mem_filter.mp hq).2
  let p := secantIntersection F E hdeg C hC m a
  have hpPair : p ∈ secantIntersectionCandidate F E hdeg C hC m a := by
    rw [secantIntersectionCandidate, ← Sym2.mem_iff_mem, Sym2.mem_iff']
    exact Or.inl rfl
  have hpq : p ∈ q := by simpa [ha] using hpPair
  refine ⟨p, Sym2.mem_toFinset.mpr hpq, ?_⟩
  exact covered_iff_exists_secant.mpr
    ⟨a.1.line (L := Point E), arcPair_line_secant (E := E) C a.1,
      secantIntersection_mem_pairLine F E hdeg C hC m a⟩

/-- Semantic characterization: the charged set is exactly the candidates with an endpoint on an
old secant. -/
theorem mem_forbiddenCandidates_iff_exists_covered (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C)
    (m : {m // m ∈ emptyFixedLines F E C}) (q : Sym2 (Point E))
    (hq : q ∈ conjugateCandidatesOnFixedLine F E hdeg m.1) :
    q ∈ forbiddenCandidates F E hdeg C hC m ↔
      ∃ p ∈ q.toFinset, Covered (L := Point E) C p := by
  constructor
  · exact exists_covered_of_mem_forbidden F E hdeg C hC m q
  · rintro ⟨p, hpq, hpcover⟩
    exact candidate_mem_forbidden_of_covered F E hdeg C hArc hC m q hq
      (Sym2.mem_toFinset.mp hpq) hpcover

/-- After inserting one endpoint of a pair on an empty line, the other endpoint remains
uncovered provided neither endpoint was covered by the old arc. -/
theorem not_covered_insert_of_emptyLine
    (C : Finset (Point E)) (m : {m // m ∈ emptyFixedLines F E C})
    {x y : Point E} (hxy : x ≠ y) (hxm : x ∈ m.1.1) (hym : y ∈ m.1.1)
    (hx : ¬ Covered (L := Point E) C x) (hy : ¬ Covered (L := Point E) C y) :
    ¬ Covered (L := Point E) (insert x C) y := by
  intro hyins
  obtain ⟨l, ⟨a, ha, b, hb, hab, hal, hbl⟩, hyl⟩ :=
    covered_iff_exists_secant.mp hyins
  simp only [Finset.mem_insert] at ha hb
  rcases ha with rfl | haC
  · rcases hb with rfl | hbC
    · exact hab rfl
    · have hlm : l = m.1.1 :=
        (Configuration.Nondegenerate.eq_or_eq hal hyl hxm hym).resolve_left hxy
      have hbm : b.orthogonal m.1.1 := by
        change b ∈ m.1.1
        rw [← hlm]
        exact hbl
      have hbtrace : b ∈ fixedLineTrace F E C m.1 :=
        Finset.mem_filter.mpr ⟨hbC, hbm⟩
      rw [fixedLineTrace_eq_empty_of_mem_emptyFixedLines F E C m] at hbtrace
      simp at hbtrace
  · rcases hb with rfl | hbC
    · have hlm : l = m.1.1 :=
        (Configuration.Nondegenerate.eq_or_eq hbl hyl hxm hym).resolve_left hxy
      have ham : a.orthogonal m.1.1 := by
        change a ∈ m.1.1
        rw [← hlm]
        exact hal
      have hatrace : a ∈ fixedLineTrace F E C m.1 :=
        Finset.mem_filter.mpr ⟨haC, ham⟩
      rw [fixedLineTrace_eq_empty_of_mem_emptyFixedLines F E C m] at hatrace
      simp at hatrace
    · apply hy
      exact covered_iff_exists_secant.mpr
        ⟨l, ⟨a, haC, b, hbC, hab, hal, hbl⟩, hyl⟩

/-- **Semantic extension theorem.** Every uncharged coordinate candidate on an empty fixed line
actually extends the old arc. -/
theorem arc_union_candidate_of_not_mem_forbidden (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C)
    (m : {m // m ∈ emptyFixedLines F E C}) (q : Sym2 (Point E))
    (hq : q ∈ conjugateCandidatesOnFixedLine F E hdeg m.1)
    (hlegal : q ∉ forbiddenCandidates F E hdeg C hC m) :
    Arc (L := Point E) (C ∪ q.toFinset) := by
  obtain ⟨x, hxq⟩ := (mem_candidates_iff_exists F E hdeg m.1 q).mp hq
  let p := x.1.1
  let y := (nonfixedMate F E hdeg m.1 x).1.1
  have hqeq : q = s(p, y) := hxq.symm.trans rfl
  have hpq : p ∈ q := by rw [hqeq, ← Sym2.mem_iff_mem, Sym2.mem_iff']; exact Or.inl rfl
  have hyq : y ∈ q := by rw [hqeq, ← Sym2.mem_iff_mem, Sym2.mem_iff']; exact Or.inr rfl
  have hnotcov : ¬ ∃ z ∈ q.toFinset, Covered (L := Point E) C z := by
    exact fun h => hlegal ((mem_forbiddenCandidates_iff_exists_covered
      F E hdeg C hArc hC m q hq).2 h)
  have hpnot : ¬ Covered (L := Point E) C p := by
    intro hp
    exact hnotcov ⟨p, Sym2.mem_toFinset.mpr hpq, hp⟩
  have hynot : ¬ Covered (L := Point E) C y := by
    intro hy
    exact hnotcov ⟨y, Sym2.mem_toFinset.mpr hyq, hy⟩
  have hpne : p ≠ y := by
    intro h
    exact x.2 h.symm
  have hpm : p ∈ m.1.1 := by exact x.1.2
  have hym : y ∈ m.1.1 := by exact (nonfixedMate F E hdeg m.1 x).1.2
  have hArc1 : Arc (L := Point E) (insert p C) := arc_insert_of_not_covered hArc hpnot
  have hynot' : ¬ Covered (L := Point E) (insert p C) y :=
    not_covered_insert_of_emptyLine F E C m hpne hpm hym hpnot hynot
  have hArc2 : Arc (L := Point E) (insert y (insert p C)) :=
    arc_insert_of_not_covered hArc1 hynot'
  simpa [hqeq, Sym2.toFinset_mk_eq, Finset.union_comm, Finset.union_left_comm,
    Finset.union_assoc, Finset.insert_comm] using hArc2

/-- Total forbidden-set function, empty away from the selected empty fixed lines. -/
noncomputable def coordinateForbidden (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hC : IsInvariant (incidence F E hdeg) C)
    (l : FixedLine F E) : Finset (Sym2 (Point E)) := by
  classical
  by_cases hl : l ∈ emptyFixedLines F E C
  · exact forbiddenCandidates F E hdeg C hC ⟨l, hl⟩
  · exact ∅

theorem coordinateForbidden_eq (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hC : IsInvariant (incidence F E hdeg) C)
    (m : {m // m ∈ emptyFixedLines F E C}) :
    coordinateForbidden F E hdeg C hC m.1 = forbiddenCandidates F E hdeg C hC m := by
  classical
  unfold coordinateForbidden
  simp only [m.2, dif_pos]

/-- Fully instantiated coordinate quadratic pair-extension data. All three geometric fields are
now discharged: empty-line count, candidate count, and forbidden-orbit bound. -/
noncomputable def coordinateQuadraticExtensionData (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C) (k f e : ℕ)
    (hkcard : C.card = k) (hf : (fixedArcPoints F E C).card = f)
    (horbit : k = f + 2 * e) :
    QuadraticBaerPairExtensionData (FixedLine F E) (Sym2 (Point E))
      (Nat.card F) k f e := by
  classical
  exact
    { toPairExtensionData :=
        { emptyLines := emptyFixedLines F E C
          candidates := conjugateCandidatesOnFixedLine F E hdeg
          forbidden := coordinateForbidden F E hdeg C hC }
      emptyLine_count := card_emptyFixedLines F E hdeg C hArc hC f e hf (by omega)
      candidate_count := fun l _ => card_conjugateCandidatesOnFixedLine F E hdeg l
      forbidden_bound := fun l hl => by
        let m : {m // m ∈ emptyFixedLines F E C} := ⟨l, hl⟩
        rw [show coordinateForbidden F E hdeg C hC l =
            forbiddenCandidates F E hdeg C hC m by
          exact coordinateForbidden_eq F E hdeg C hC m]
        exact card_forbiddenCandidates_le_baer F E hdeg C hArc hC k f e
          hkcard hf horbit m }

/-- **End-to-end quadratic extension theorem.** Under the two explicit strict inequalities, an
invariant coordinate arc has a genuine legal conjugate-pair extension on an empty fixed line. -/
theorem exists_quadratic_pair_extension (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C) (k f e : ℕ)
    (hkcard : C.card = k) (hf : (fixedArcPoints F E C).card = f)
    (horbit : k = f + 2 * e)
    (hE : 0 < baerEmptyLineCount (Nat.card F) f e)
    (hM : baerNonInvariantSecantOrbits k f e <
      (Nat.card F * Nat.card F - Nat.card F) / 2) :
    ∃ m : FixedLine F E, ∃ q : Sym2 (Point E),
      m ∈ emptyFixedLines F E C ∧
      q ∈ conjugateCandidatesOnFixedLine F E hdeg m ∧
      Arc (L := Point E) (C ∪ q.toFinset) := by
  let D := coordinateQuadraticExtensionData F E hdeg C hArc hC k f e hkcard hf horbit
  obtain ⟨m, hm, q, hq⟩ := quadraticBaer_exists_pair D hE hM
  change m ∈ emptyFixedLines F E C at hm
  change q ∈ conjugateCandidatesOnFixedLine F E hdeg m \
    coordinateForbidden F E hdeg C hC m at hq
  have hqcand : q ∈ conjugateCandidatesOnFixedLine F E hdeg m :=
    (Finset.mem_sdiff.mp hq).1
  have hqlegal : q ∉ coordinateForbidden F E hdeg C hC m :=
    (Finset.mem_sdiff.mp hq).2
  let mm : {m // m ∈ emptyFixedLines F E C} := ⟨m, hm⟩
  have hqlegal' : q ∉ forbiddenCandidates F E hdeg C hC mm := by
    rw [← coordinateForbidden_eq F E hdeg C hC mm]
    exact hqlegal
  exact ⟨m, q, hm, hqcand,
    arc_union_candidate_of_not_mem_forbidden F E hdeg C hArc hC mm q hqcand hqlegal'⟩

end
end QuadraticForbidden
end RelativeConicArcs
