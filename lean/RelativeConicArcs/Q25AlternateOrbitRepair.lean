import RelativeConicArcs.AlternateOrbitRepair
import RelativeConicArcs.Q25PairResult
import RelativeConicArcs.Q25ProfileFour
import RelativeConicArcs.Q25ProfileZero

/-!
# Alternate-orbit repair in the nonexceptional order-five profiles

The existing profile counts for invariant eight-arcs over a quadratic extension of a five-element
base field give alternate-repair bounds after restoring one deleted orbit is excluded.
-/

namespace RelativeConicArcs
namespace AlternateOrbitRepair

noncomputable section

open Configuration Finset
open FiniteGeom.BaerCompletion
open QuadraticFrobenius QuadraticLineCounting QuadraticForbidden QuadraticGlobalCount
open QuadraticCollision
open Q25Coordinates Q25PairResult FiniteFields

variable (F E : Type) [Field F] [Fintype F] [Field E] [Finite E] [Algebra F E]
  [Algebra.IsAlgebraic F E]

abbrev Q25Point := ProjectiveConjugation.Point E

local instance : Fintype E := Fintype.ofFinite E
local instance : DecidableEq E := Classical.decEq E
local instance : DecidableEq (Q25Point E) := Classical.decEq _
local instance : DecidableEq (FixedProjectivePoint F E) := Classical.decEq _
local instance : DecidableRel fun p l : Q25Point E => p.orthogonal l := Classical.decRel _

/-- Reindex the carrierwise count by the bundled empty-carrier type used by the base-five
profile theorems. -/
theorem card_globalLegalPairs_eq_profileSum (hdeg : Module.finrank F E = 2)
    (C : Finset (Q25Point E)) (hArc : Arc (L := Q25Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C) :
    (globalLegalPairs F E hdeg C).card =
      ∑ m ∈ allEmptyCarrierClasses F E C,
        (conjugateCandidatesOnFixedLine F E hdeg m.1 \
          forbiddenCandidates F E hdeg C hC m).card := by
  rw [globalLegalPairs_eq_carrierwiseLegalPairs F E hdeg C hArc hC]
  unfold carrierwiseLegalPairs
  rw [Finset.card_biUnion (carrierwiseLegal_pairwiseDisjoint F E hdeg C hC)]
  rw [← (emptyFixedLines F E C).sum_attach]
  simp only [allEmptyCarrierClasses, Finset.attach_eq_univ]
  apply Fintype.sum_congr
  intro m
  rw [coordinateForbidden_eq F E hdeg C hC m]

theorem five_le_card_globalLegalPairs_profile_zero (hdeg : Module.finrank F E = 2)
    (hF : Nat.card F = 5) (C : Finset (Q25Point E)) (hArc : Arc (L := Q25Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C)
    (hcard : C.card = 8) (hfixed : (fixedArcPoints F E C).card = 0) :
    5 ≤ (globalLegalPairs F E hdeg C).card := by
  rw [card_globalLegalPairs_eq_profileSum F E hdeg C hArc hC]
  exact Q25ProfileZero.five_le_sum_card_legal_profile_zero
    F E hdeg hF C hArc hC hcard hfixed

theorem four_le_card_globalLegalPairs_profile_four (hdeg : Module.finrank F E = 2)
    (hF : Nat.card F = 5) (C : Finset (Q25Point E)) (hArc : Arc (L := Q25Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C)
    (hcard : C.card = 8) (hfixed : (fixedArcPoints F E C).card = 4) :
    4 ≤ (globalLegalPairs F E hdeg C).card := by
  rw [card_globalLegalPairs_eq_profileSum F E hdeg C hArc hC]
  exact Q25ProfileFour.four_le_sum_card_legal_profile_four
    F E hdeg hF C hArc hC hcard hfixed

theorem thirty_six_le_card_globalLegalPairs_profile_six (hdeg : Module.finrank F E = 2)
    (hF : Nat.card F = 5) (C : Finset (Q25Point E)) (hArc : Arc (L := Q25Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C)
    (hcard : C.card = 8) (hfixed : (fixedArcPoints F E C).card = 6) :
    36 ≤ (globalLegalPairs F E hdeg C).card := by
  have hbound := quadratic_global_pair_lowerBound F E hdeg C hArc hC
    8 6 1 hcard hfixed (by omega)
  have hF' : Fintype.card F = 5 := by
    simpa only [Nat.card_eq_fintype_card] using hF
  norm_num [hF', baerEmptyLineCount, baerNonInvariantSecantOrbits, Nat.choose] at hbound
  exact hbound

theorem one_hundred_ten_le_card_globalLegalPairs_profile_eight
    (hdeg : Module.finrank F E = 2) (hF : Nat.card F = 5)
    (C : Finset (Q25Point E)) (hArc : Arc (L := Q25Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C)
    (hcard : C.card = 8) (hfixed : (fixedArcPoints F E C).card = 8) :
    110 ≤ (globalLegalPairs F E hdeg C).card := by
  have hbound := quadratic_global_pair_lowerBound F E hdeg C hArc hC
    8 8 0 hcard hfixed (by omega)
  have hF' : Fintype.card F = 5 := by
    simpa only [Nat.card_eq_fintype_card] using hF
  norm_num [hF', baerEmptyLineCount, baerNonInvariantSecantOrbits, Nat.choose] at hbound
  exact hbound

theorem f5_card : Nat.card F5 = 5 := by
  rw [Nat.card_eq_fintype_card]
  norm_num [F5]

/-- The strengthened exceptional-profile certificate supplies two distinct semantic legal pairs. -/
theorem two_le_card_globalLegalPairs_profile_two
    (C : Finset Point25) (hArc : Arc (L := Point25) C)
    (hC : IsInvariant (incidence F5 K25 gf25_degree) C)
    (hcard : C.card = 8) (hfixed : (fixedArcPoints F5 K25 C).card = 2) :
    2 ≤ (globalLegalPairs F5 K25 gf25_degree C).card := by
  obtain ⟨q, r, hqr, hq, hr⟩ := f2_two_pair_extension C hArc hC hcard hfixed
  have hpairCard : ({q, r} : Finset (Sym2 Point25)).card = 2 := Finset.card_pair hqr
  rw [← hpairCard]
  apply Finset.card_le_card
  intro x hx
  simp only [Finset.mem_insert, Finset.mem_singleton] at hx
  rcases hx with rfl | rfl
  · exact hq
  · exact hr

/-- Every invariant eight-arc in `PG(2,25)` has at least two semantic legal conjugate pairs. -/
theorem two_le_card_globalLegalPairs_q25
    (C : Finset Point25) (hArc : Arc (L := Point25) C)
    (hC : IsInvariant (incidence F5 K25 gf25_degree) C)
    (hcard : C.card = 8) :
    2 ≤ (globalLegalPairs F5 K25 gf25_degree C).card := by
  classical
  let f := (fixedArcPoints F5 K25 C).card
  let e := Nat.card (ConjugateInvariantArcPair F5 K25 C hC)
  have hprofile : 8 = f + 2 * e := by
    rw [← hcard]
    exact card_eq_fixed_add_two_mul_nonfixedOrbits F5 K25 gf25_degree C hC
  have hfixed : (fixedArcPoints F5 K25 C).card = f := rfl
  have hfle : f ≤ 8 := by omega
  interval_cases f
  · exact (by omega : 2 ≤ 5).trans
      (five_le_card_globalLegalPairs_profile_zero F5 K25 gf25_degree f5_card
        C hArc hC hcard hfixed)
  · omega
  · exact two_le_card_globalLegalPairs_profile_two C hArc hC hcard hfixed
  · omega
  · exact (by omega : 2 ≤ 4).trans
      (four_le_card_globalLegalPairs_profile_four F5 K25 gf25_degree f5_card
        C hArc hC hcard hfixed)
  · omega
  · exact (by omega : 2 ≤ 36).trans
      (thirty_six_le_card_globalLegalPairs_profile_six F5 K25 gf25_degree f5_card
        C hArc hC hcard hfixed)
  · omega
  · exact (by omega : 2 ≤ 110).trans
      (one_hundred_ten_le_card_globalLegalPairs_profile_eight F5 K25 gf25_degree f5_card
        C hArc hC hcard hfixed)

/-- Base-order-five zero-fixed profile: at least four repairs differ from the erased orbit. -/
theorem four_le_alternateLegalPairs_profile_zero (hdeg : Module.finrank F E = 2)
    (hF : Nat.card F = 5) (A : Finset (Q25Point E)) (hArc : Arc (L := Q25Point E) A)
    (hA : IsInvariant (incidence F E hdeg) A) (hcard : A.card = 10)
    (q : Sym2 (Q25Point E)) (hq : IsSelectedNonfixedOrbit F E hdeg A q)
    (hfixed : (fixedArcPoints F E (deleteOrbit E A q)).card = 0) :
    4 ≤ (alternateLegalPairs F E hdeg A q).card := by
  obtain ⟨hArcD, hInvD, hcardD, hqD⟩ :=
    delete_selected_nonfixed_orbit F E hdeg A hArc hA hcard q hq
  apply pred_le_card_alternateLegalPairs F E hdeg hqD
  exact five_le_card_globalLegalPairs_profile_zero F E hdeg hF
    (deleteOrbit E A q) hArcD hInvD hcardD hfixed

/-- Base-order-five four-fixed profile: at least three repairs differ from the erased orbit. -/
theorem three_le_alternateLegalPairs_profile_four (hdeg : Module.finrank F E = 2)
    (hF : Nat.card F = 5) (A : Finset (Q25Point E)) (hArc : Arc (L := Q25Point E) A)
    (hA : IsInvariant (incidence F E hdeg) A) (hcard : A.card = 10)
    (q : Sym2 (Q25Point E)) (hq : IsSelectedNonfixedOrbit F E hdeg A q)
    (hfixed : (fixedArcPoints F E (deleteOrbit E A q)).card = 4) :
    3 ≤ (alternateLegalPairs F E hdeg A q).card := by
  obtain ⟨hArcD, hInvD, hcardD, hqD⟩ :=
    delete_selected_nonfixed_orbit F E hdeg A hArc hA hcard q hq
  apply pred_le_card_alternateLegalPairs F E hdeg hqD
  exact four_le_card_globalLegalPairs_profile_four F E hdeg hF
    (deleteOrbit E A q) hArcD hInvD hcardD hfixed

/-- Base-order-five six-fixed profile: at least thirty-five repairs differ from the erased orbit. -/
theorem thirty_five_le_alternateLegalPairs_profile_six (hdeg : Module.finrank F E = 2)
    (hF : Nat.card F = 5) (A : Finset (Q25Point E)) (hArc : Arc (L := Q25Point E) A)
    (hA : IsInvariant (incidence F E hdeg) A) (hcard : A.card = 10)
    (q : Sym2 (Q25Point E)) (hq : IsSelectedNonfixedOrbit F E hdeg A q)
    (hfixed : (fixedArcPoints F E (deleteOrbit E A q)).card = 6) :
    35 ≤ (alternateLegalPairs F E hdeg A q).card := by
  obtain ⟨hArcD, hInvD, hcardD, hqD⟩ :=
    delete_selected_nonfixed_orbit F E hdeg A hArc hA hcard q hq
  apply pred_le_card_alternateLegalPairs F E hdeg hqD
  exact thirty_six_le_card_globalLegalPairs_profile_six F E hdeg hF
    (deleteOrbit E A q) hArcD hInvD hcardD hfixed

/-- Base-order-five eight-fixed profile: at least 109 repairs differ from the erased orbit. -/
theorem one_hundred_nine_le_alternateLegalPairs_profile_eight
    (hdeg : Module.finrank F E = 2) (hF : Nat.card F = 5)
    (A : Finset (Q25Point E)) (hArc : Arc (L := Q25Point E) A)
    (hA : IsInvariant (incidence F E hdeg) A) (hcard : A.card = 10)
    (q : Sym2 (Q25Point E)) (hq : IsSelectedNonfixedOrbit F E hdeg A q)
    (hfixed : (fixedArcPoints F E (deleteOrbit E A q)).card = 8) :
    109 ≤ (alternateLegalPairs F E hdeg A q).card := by
  obtain ⟨hArcD, hInvD, hcardD, hqD⟩ :=
    delete_selected_nonfixed_orbit F E hdeg A hArc hA hcard q hq
  apply pred_le_card_alternateLegalPairs F E hdeg hqD
  exact one_hundred_ten_le_card_globalLegalPairs_profile_eight F E hdeg hF
    (deleteOrbit E A q) hArcD hInvD hcardD hfixed

/-- **Uniform order-five alternate-orbit repair.**  Deleting any selected nonfixed orbit from an
invariant ten-arc in `PG(2,25)` leaves at least one different legal orbit that repairs the arc. -/
theorem one_le_alternateLegalPairs_q25
    (A : Finset Point25) (hArc : Arc (L := Point25) A)
    (hA : IsInvariant (incidence F5 K25 gf25_degree) A) (hcard : A.card = 10)
    (q : Sym2 Point25) (hq : IsSelectedNonfixedOrbit F5 K25 gf25_degree A q) :
    1 ≤ (alternateLegalPairs F5 K25 gf25_degree A q).card := by
  obtain ⟨hArcD, hInvD, hcardD, hqD⟩ :=
    delete_selected_nonfixed_orbit F5 K25 gf25_degree A hArc hA hcard q hq
  apply pred_le_card_alternateLegalPairs F5 K25 gf25_degree hqD
  exact two_le_card_globalLegalPairs_q25 (deleteOrbit K25 A q) hArcD hInvD hcardD

end
end AlternateOrbitRepair
end RelativeConicArcs
