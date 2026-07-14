import RelativeConicArcs.QuadraticInvisible
import RelativeConicArcs.BaerArithmetic

/-!
# The four-fixed-point profile over `PG(2,25)`

This file constructs the two cross-pair secant orbits of an invariant eight-arc with four fixed
points and feeds their center capacities into the exact collision balance.
-/

namespace RelativeConicArcs
namespace Q25ProfileFour

noncomputable section

set_option maxHeartbeats 5000000

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
local instance : DecidableRel fun p l : Point E => p.orthogonal l := Classical.decRel _

/-- The secant joining representatives of two different selected conjugate point-orbits. -/
noncomputable def crossSecant (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hC : IsInvariant (incidence F E hdeg) C)
    (p q : NonfixedArcPoint F E C)
    (hpq : selectedOrbitPair F E C hC p ≠ selectedOrbitPair F E C hC q) :
    NonfixedArcPair F E C hC := by
  have hpq' : p.1 ≠ q.1 := by
    intro h
    apply hpq
    exact congrArg (selectedOrbitPair F E C hC) (Subtype.ext h)
  let a : ArcPair C := ⟨{p.1, q.1}, Finset.mem_powersetCard.mpr ⟨by
    intro x hx
    simp only [Finset.mem_insert, Finset.mem_singleton] at hx
    rcases hx with rfl | rfl
    · exact p.2.1
    · exact q.2.1, by simp [hpq']⟩⟩
  refine ⟨a, ?_⟩
  intro hainv
  have hpconj : p.1 ∈ (conjugateArcPair F E C hC a).1 := by
    rw [hainv]
    simp [a]
  obtain ⟨r, hra, hrp⟩ := Finset.mem_map.mp hpconj
  simp only [a, Finset.mem_insert, Finset.mem_singleton] at hra
  rcases hra with rfl | rfl
  · exact p.2.2 hrp
  · apply hpq
    rw [selectedOrbitPair_eq_iff F E C hC]
    right
    apply Subtype.ext
    exact hrp.symm

theorem crossSecant_val (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hC : IsInvariant (incidence F E hdeg) C)
    (p q : NonfixedArcPoint F E C)
    (hpq : selectedOrbitPair F E C hC p ≠ selectedOrbitPair F E C hC q) :
    (crossSecant F E hdeg C hC p q hpq).1.1 = {p.1, q.1} := rfl

theorem crossSecant_isCross (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hC : IsInvariant (incidence F E hdeg) C)
    (p q : NonfixedArcPoint F E C)
    (hpq : selectedOrbitPair F E C hC p ≠ selectedOrbitPair F E C hC q) :
    IsCrossPairOrbit F E hdeg C hC (crossSecant F E hdeg C hC p q hpq) := by
  rw [IsCrossPairOrbit, Finset.disjoint_left]
  intro x hxa hxb
  change x ∈ (conjugateArcPair F E C hC
    (crossSecant F E hdeg C hC p q hpq).1).1 at hxb
  obtain ⟨y, hya, hyx⟩ := Finset.mem_map.mp hxb
  rw [crossSecant_val F E hdeg C hC p q hpq] at hxa hya
  simp only [Finset.mem_insert, Finset.mem_singleton] at hxa hya
  rcases hxa with rfl | rfl <;> rcases hya with rfl | rfl
  · exact p.2.2 hyx
  · apply hpq
    rw [selectedOrbitPair_eq_iff F E C hC]
    right
    apply Subtype.ext
    exact hyx.symm
  · apply hpq
    rw [selectedOrbitPair_eq_iff F E C hC]
    right
    apply Subtype.ext
    change p.1 = (incidence F E hdeg).pointConj q.1
    rw [← hyx]
    change p.1 = (incidence F E hdeg).pointConj
      ((incidence F E hdeg).pointConj p.1)
    exact ((incidence F E hdeg).point_involutive p.1).symm
  · exact q.2.2 hyx

/-- Two different selected conjugate point-orbits determine the two different cross-pair
secant-orbit orientations. -/
theorem exists_two_crossSecants_of_distinct_selectedOrbits
    (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hC : IsInvariant (incidence F E hdeg) C)
    (p q : NonfixedArcPoint F E C)
    (hpq : selectedOrbitPair F E C hC p ≠ selectedOrbitPair F E C hC q) :
    ∃ a b : NonfixedArcPair F E C hC,
      IsCrossPairOrbit F E hdeg C hC a ∧
      IsCrossPairOrbit F E hdeg C hC b ∧
      secantOrbit F E hdeg C hC a ≠ secantOrbit F E hdeg C hC b := by
  let q' := selectedMate F E C hC q
  have hpq' : selectedOrbitPair F E C hC p ≠ selectedOrbitPair F E C hC q' := by
    intro h
    apply hpq
    exact h.trans ((selectedOrbitPair_eq_iff F E C hC q' q).2 (Or.inr rfl))
  let a := crossSecant F E hdeg C hC p q hpq
  let b := crossSecant F E hdeg C hC p q' hpq'
  refine ⟨a, b, crossSecant_isCross F E hdeg C hC p q hpq,
    crossSecant_isCross F E hdeg C hC p q' hpq', ?_⟩
  intro horbit
  rcases (secantOrbit_eq_iff F E hdeg C hC a b).mp horbit with hab | hab
  · have hv := congrArg (fun r : NonfixedArcPair F E C hC => r.1.1) hab
    have hqmem : q.1 ∈ b.1.1 := by
      rw [← hv]
      simp [a, crossSecant_val]
    rw [show b.1.1 = {p.1, q'.1} by rfl] at hqmem
    simp only [Finset.mem_insert, Finset.mem_singleton] at hqmem
    rcases hqmem with hqp | hqq'
    · apply hpq
      exact congrArg (selectedOrbitPair F E C hC) (Subtype.ext hqp.symm)
    · exact q.2.2 hqq'.symm
  · have hpmem : p.1 ∈ (nonfixedSecantMate F E hdeg C hC b).1.1 := by
      rw [← hab]
      simp [a, crossSecant_val]
    change p.1 ∈ (conjugateArcPair F E C hC b.1).1 at hpmem
    obtain ⟨y, hyb, hyp⟩ := Finset.mem_map.mp hpmem
    rw [show b.1.1 = {p.1, q'.1} by rfl] at hyb
    simp only [Finset.mem_insert, Finset.mem_singleton] at hyb
    rcases hyb with rfl | rfl
    · exact p.2.2 hyp
    · apply hpq
      rw [selectedOrbitPair_eq_iff F E C hC]
      left
      apply Subtype.ext
      change p.1 = q.1
      rw [← hyp]
      exact (incidence F E hdeg).point_involutive q.1

/-- The `(4,2)` profile contains two distinct cross-pair secant orbits. -/
theorem exists_two_crossSecants_profile_four
    (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hC : IsInvariant (incidence F E hdeg) C)
    (hcard : C.card = 8) (hfixed : (fixedArcPoints F E C).card = 4) :
    ∃ a b : NonfixedArcPair F E C hC,
      IsCrossPairOrbit F E hdeg C hC a ∧
      IsCrossPairOrbit F E hdeg C hC b ∧
      secantOrbit F E hdeg C hC a ≠ secantOrbit F E hdeg C hC b := by
  have hnonfixed : Nat.card (NonfixedArcPoint F E C) = 4 := by
    rw [natCard_nonfixedArcPoint F E C, hcard, hfixed]
  have horbits : Nat.card (ConjugateInvariantArcPair F E C hC) = 2 := by
    exact natCard_conjugateInvariantArcPair F E C hC 2 (by simpa using hnonfixed)
  have hcardOrbits : Fintype.card (ConjugateInvariantArcPair F E C hC) = 2 := by
    rw [← Nat.card_eq_fintype_card]
    exact horbits
  have hpos : 0 < Fintype.card (ConjugateInvariantArcPair F E C hC) := by omega
  let u : ConjugateInvariantArcPair F E C hC :=
    Classical.choice (Fintype.card_pos_iff.mp hpos)
  obtain ⟨v, hvu⟩ := Fintype.exists_ne_of_one_lt_card (by omega) u
  obtain ⟨p, hp⟩ := selectedOrbitPair_surjective F E C hC u
  obtain ⟨q, hq⟩ := selectedOrbitPair_surjective F E C hC v
  have hpq : selectedOrbitPair F E C hC p ≠ selectedOrbitPair F E C hC q := by
    intro heq
    apply hvu
    rw [← hp, ← hq]
    exact heq.symm
  exact exists_two_crossSecants_of_distinct_selectedOrbits F E hdeg C hC p q hpq

/-- The two cross-pair centers contribute at least four aggregate invisible incidences over
`GF(5)`. -/
theorem four_le_sum_card_invisible_profile_four
    (hdeg : Module.finrank F E = 2) (hF : Nat.card F = 5)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C)
    (hcard : C.card = 8) (hfixed : (fixedArcPoints F E C).card = 4) :
    4 ≤ ∑ m ∈ allEmptyCarrierClasses F E C,
      (invisibleSecantOrbitClasses F E hdeg C hC m).card := by
  obtain ⟨a, b, ha, hb, hab⟩ :=
    exists_two_crossSecants_profile_four F E hdeg C hC hcard hfixed
  let oa := secantOrbitClassOfPair F E hdeg C hC a
  let ob := secantOrbitClassOfPair F E hdeg C hC b
  have hoab : oa ≠ ob := by
    intro h
    apply hab
    exact congrArg Subtype.val h
  let S : Finset (SecantOrbitClass F E hdeg C hC) := {oa, ob}
  have hScard : S.card = 2 := by simp [S, hoab]
  have hSsubset : S ⊆ allSecantOrbitClasses F E hdeg C hC := by
    intro o ho
    exact Finset.mem_univ _
  have hcapacity : ∀ o ∈ S,
      2 ≤ (emptyCarriersThroughOrbitCenter F E hdeg C hArc hC o).card := by
    intro o ho
    simp only [S, Finset.mem_insert, Finset.mem_singleton] at ho
    rcases ho with rfl | rfl
    · apply two_le_card_emptyCarriersThroughOrbitCenter_of_occupied_le_four
        F E hdeg hF C hArc hC oa
      exact card_occupied_through_crossPair_center_le_four F E hdeg C hArc hC
        hcard hfixed _
        (representative_isCrossPairOrbit_of_classOfPair F E hdeg C hC a ha)
    · apply two_le_card_emptyCarriersThroughOrbitCenter_of_occupied_le_four
        F E hdeg hF C hArc hC ob
      exact card_occupied_through_crossPair_center_le_four F E hdeg C hArc hC
        hcard hfixed _
        (representative_isCrossPairOrbit_of_classOfPair F E hdeg C hC b hb)
  have hbound := card_mul_le_sum_card_invisible_of_center_capacity
    F E hdeg C hArc hC S 2 hSsubset hcapacity
  rw [hScard] at hbound
  norm_num at hbound ⊢
  exact hbound

/-- The exact balance contains at least four legal conjugate-pair extensions in the `(4,2)`
profile over `GF(5)`. -/
theorem four_le_sum_card_legal_profile_four
    (hdeg : Module.finrank F E = 2) (hF : Nat.card F = 5)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C)
    (hcard : C.card = 8) (hfixed : (fixedArcPoints F E C).card = 4) :
    4 ≤ ∑ m ∈ allEmptyCarrierClasses F E C,
      (conjugateCandidatesOnFixedLine F E hdeg m.1 \
        forbiddenCandidates F E hdeg C hC m).card := by
  have hk : C.card = 4 + 2 * 2 := by omega
  have hcarriers : (allEmptyCarrierClasses F E C).card = 11 := by
    rw [show (allEmptyCarrierClasses F E C).card = (emptyFixedLines F E C).card by
      simp [allEmptyCarrierClasses]]
    rw [card_emptyFixedLines F E hdeg C hArc hC 4 2 hfixed hk, hF]
    norm_num [baerEmptyLineCount, Nat.choose]
  have horbits : (allSecantOrbitClasses F E hdeg C hC).card = 10 := by
    rw [show (allSecantOrbitClasses F E hdeg C hC).card =
        (nonfixedSecantOrbits F E hdeg C hC).card by
      simp [allSecantOrbitClasses]]
    rw [card_nonfixedSecantOrbits F E hdeg C hArc hC 8 4 2 hcard hfixed (by omega)]
    norm_num [baerNonInvariantSecantOrbits, Nat.choose]
  have hcandidates (m : {m // m ∈ emptyFixedLines F E C}) :
      (conjugateCandidatesOnFixedLine F E hdeg m.1).card = 10 := by
    rw [card_conjugateCandidatesOnFixedLine F E hdeg m.1, hF]
  have hbalance :=
    sum_card_legal_add_carriers_mul_orbits_eq_sum_candidates_add_invisible_add_redundancy
      F E hdeg C hArc hC
  simp_rw [hcandidates] at hbalance
  simp [hcarriers, horbits] at hbalance
  exact four_le_legal_of_s5_profile_four_balance hbalance
    (four_le_sum_card_invisible_profile_four F E hdeg hF C hArc hC hcard hfixed)

/-- Every invariant eight-arc with four fixed points over a quadratic extension of `GF(5)` has a
legal conjugate-pair extension. -/
theorem exists_profile_four_pair_extension
    (hdeg : Module.finrank F E = 2) (hF : Nat.card F = 5)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C)
    (hcard : C.card = 8) (hfixed : (fixedArcPoints F E C).card = 4) :
    ∃ (m : {m // m ∈ emptyFixedLines F E C}) (q : Sym2 (Point E)),
      q ∈ conjugateCandidatesOnFixedLine F E hdeg m.1 ∧
        Arc (L := Point E) (C ∪ q.toFinset) := by
  apply exists_arc_extension_of_aggregate_invisible_capacity F E hdeg C hArc hC
  have hk : C.card = 4 + 2 * 2 := by omega
  have hcarriers : (allEmptyCarrierClasses F E C).card = 11 := by
    rw [show (allEmptyCarrierClasses F E C).card = (emptyFixedLines F E C).card by
      simp [allEmptyCarrierClasses]]
    rw [card_emptyFixedLines F E hdeg C hArc hC 4 2 hfixed hk, hF]
    norm_num [baerEmptyLineCount, Nat.choose]
  have horbits : (allSecantOrbitClasses F E hdeg C hC).card = 10 := by
    rw [show (allSecantOrbitClasses F E hdeg C hC).card =
        (nonfixedSecantOrbits F E hdeg C hC).card by
      simp [allSecantOrbitClasses]]
    rw [card_nonfixedSecantOrbits F E hdeg C hArc hC 8 4 2 hcard hfixed (by omega)]
    norm_num [baerNonInvariantSecantOrbits, Nat.choose]
  have hcandidates (m : {m // m ∈ emptyFixedLines F E C}) :
      (conjugateCandidatesOnFixedLine F E hdeg m.1).card = 10 := by
    rw [card_conjugateCandidatesOnFixedLine F E hdeg m.1, hF]
  have hinvisible := four_le_sum_card_invisible_profile_four
    F E hdeg hF C hArc hC hcard hfixed
  simp_rw [hcandidates]
  rw [hcarriers, horbits]
  norm_num
  omega

/-- Paper-facing profile-four theorem with both new conjugate points explicitly fresh. -/
theorem profile_four_pair_extension
    (hdeg : Module.finrank F E = 2) (hF : Nat.card F = 5)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C)
    (hcard : C.card = 8) (hfixed : (fixedArcPoints F E C).card = 4) :
    ∃ p : Point E,
      (incidence F E hdeg).pointConj p ≠ p ∧
      p ∉ C ∧ (incidence F E hdeg).pointConj p ∉ C ∧
      Arc (L := Point E) (C ∪ {p, (incidence F E hdeg).pointConj p}) := by
  obtain ⟨m, q, hq, hArcq⟩ :=
    exists_profile_four_pair_extension F E hdeg hF C hArc hC hcard hfixed
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
end Q25ProfileFour
end RelativeConicArcs
