import RelativeConicArcs.AlternateOrbitRepair
import RelativeConicArcs.AlternateOrbitRepairPhaseDiagram

/-!
# Parameterized robust equivariant exchange

Deleting a selected nonfixed orbit from an invariant `(k+2)`-arc leaves a `k`-arc.  The phase
inequality from `AlternateOrbitRepairPhaseDiagram` then gives an arbitrary prescribed number of
different legal conjugate-orbit repairs.
-/

namespace RelativeConicArcs
namespace AlternateOrbitRepair

noncomputable section

open Configuration Finset
open FiniteGeom.BaerCompletion
open QuadraticFrobenius QuadraticLineCounting QuadraticForbidden QuadraticGlobalCount
open AlternateOrbitRepairProfileEnvelope AlternateOrbitRepairPhaseDiagram

variable (F E : Type) [Field F] [Fintype F] [Field E] [Finite E] [Algebra F E]
  [Algebra.IsAlgebraic F E]

abbrev ParameterizedPoint := ProjectiveConjugation.Point E

local instance : Fintype E := Fintype.ofFinite E
local instance : DecidableEq E := Classical.decEq E
local instance : DecidableEq (ParameterizedPoint E) := Classical.decEq _
local instance : DecidableEq (FixedProjectivePoint F E) := Classical.decEq _
local instance : DecidableRel fun p l : ParameterizedPoint E => p.orthogonal l := Classical.decRel _

/-- Size-parameterized form of deleting a selected nonfixed orbit. -/
theorem delete_selected_nonfixed_orbit_of_card_add_two
    (hdeg : Module.finrank F E = 2) (k : ℕ)
    (A : Finset (ParameterizedPoint E)) (hArc : Arc (L := ParameterizedPoint E) A)
    (hA : IsInvariant (incidence F E hdeg) A) (hcard : A.card = k + 2)
    (q : Sym2 (ParameterizedPoint E)) (hq : IsSelectedNonfixedOrbit F E hdeg A q) :
    Arc (L := ParameterizedPoint E) (deleteOrbit E A q) ∧
      IsInvariant (incidence F E hdeg) (deleteOrbit E A q) ∧
      (deleteOrbit E A q).card = k ∧
      q ∈ globalLegalPairs F E hdeg (deleteOrbit E A q) := by
  classical
  refine ⟨arc_mono Finset.sdiff_subset hArc,
    invariant_deleteOrbit F E hdeg hA hq.1, ?_, ?_⟩
  · rw [deleteOrbit, Finset.card_sdiff_of_subset hq.2,
      card_orbit_of_isNonfixedFrobeniusOrbit F E hdeg hq.1, hcard]
    omega
  · rw [mem_globalLegalPairs_iff]
    refine ⟨?_, ?_⟩
    · obtain ⟨p, hp, hpq⟩ := hq.1
      refine ⟨p, hp, hpq, ?_⟩
      subst q
      change Disjoint s(p, (incidence F E hdeg).pointConj p).toFinset
        (A \ s(p, (incidence F E hdeg).pointConj p).toFinset)
      exact disjoint_sdiff_self_left.symm
    · unfold deleteOrbit
      rw [Finset.sdiff_union_of_subset hq.2]
      exact hArc

/-- Every invariant `k`-arc in the admissible phase has at least `r+1` semantic legal pairs. -/
theorem add_one_le_card_globalLegalPairs_of_phase
    (hdeg : Module.finrank F E = 2) (hs : 3 ≤ Nat.card F)
    (k r : ℕ) (C : Finset (ParameterizedPoint E))
    (hArc : Arc (L := ParameterizedPoint E) C)
    (hC : IsInvariant (incidence F E hdeg) C) (hcard : C.card = k)
    (hphase : PhaseAdmissible (Nat.card F) k r) :
    r + 1 ≤ (globalLegalPairs F E hdeg C).card := by
  let f := (fixedArcPoints F E C).card
  let e := Nat.card (ConjugateInvariantArcPair F E C hC)
  have hprofile : k = f + 2 * e := by
    calc
      k = C.card := hcard.symm
      _ = (fixedArcPoints F E C).card +
          2 * Nat.card (ConjugateInvariantArcPair F E C hC) :=
        card_eq_fixed_add_two_mul_nonfixedOrbits F E hdeg C hC
      _ = f + 2 * e := rfl
  have harithmetic :
      r + 1 ≤ baerEmptyLineCount (Nat.card F) f e *
        (quadraticCandidateCount (Nat.card F) - baerNonInvariantSecantOrbits k f e) :=
    phase_profile_product_lowerBound hs hprofile hphase
  exact harithmetic.trans (quadratic_global_pair_lowerBound F E hdeg C hArc hC
    k f e hcard rfl hprofile)

/-- **Parameterized robust equivariant exchange.**  Under the exact phase inequality, deleting any
selected nonfixed orbit from an invariant `(k+2)`-arc leaves at least `r` different legal
conjugate-orbit repairs. -/
theorem card_alternateLegalPairs_ge_of_phase
    (hdeg : Module.finrank F E = 2) (hs : 3 ≤ Nat.card F)
    (k r : ℕ) (A : Finset (ParameterizedPoint E))
    (hArc : Arc (L := ParameterizedPoint E) A)
    (hA : IsInvariant (incidence F E hdeg) A) (hcard : A.card = k + 2)
    (q : Sym2 (ParameterizedPoint E)) (hq : IsSelectedNonfixedOrbit F E hdeg A q)
    (hphase : PhaseAdmissible (Nat.card F) k r) :
    r ≤ (alternateLegalPairs F E hdeg A q).card := by
  obtain ⟨hArcD, hInvD, hcardD, hqD⟩ :=
    delete_selected_nonfixed_orbit_of_card_add_two F E hdeg k A hArc hA hcard q hq
  apply pred_le_card_alternateLegalPairs F E hdeg hqD
  exact add_one_le_card_globalLegalPairs_of_phase
    F E hdeg hs k r (deleteOrbit E A q) hArcD hInvD hcardD hphase

end
end AlternateOrbitRepair
end RelativeConicArcs
