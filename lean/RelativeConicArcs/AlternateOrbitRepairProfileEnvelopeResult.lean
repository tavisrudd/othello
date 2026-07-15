import RelativeConicArcs.AlternateOrbitRepair
import RelativeConicArcs.AlternateOrbitRepairProfileEnvelope

/-!
# Semantic alternate-repair theorem from the exact profile envelope

This module connects the dependency-light arithmetic envelope to semantic legal conjugate pairs.
-/

namespace RelativeConicArcs
namespace AlternateOrbitRepair

noncomputable section

open FiniteGeom.BaerCompletion
open AlternateOrbitRepairProfileEnvelope QuadraticFrobenius QuadraticGlobalCount
  QuadraticLineCounting

variable (F E : Type) [Field F] [Fintype F] [Field E] [Finite E] [Algebra F E]
  [Algebra.IsAlgebraic F E]

abbrev EnvelopePoint := ProjectiveConjugation.Point E

local instance : Fintype E := Fintype.ofFinite E
local instance : DecidableEq E := Classical.decEq E
local instance : DecidableEq (EnvelopePoint E) := Classical.decEq _
local instance : DecidableEq (FixedProjectivePoint F E) := Classical.decEq _
local instance : DecidableRel fun p l : EnvelopePoint E => p.orthogonal l := Classical.decRel _

/-- The exact five-profile lower envelope bounds the semantic legal-pair count of every invariant
eight-arc. -/
theorem profileEnvelope_le_card_globalLegalPairs_of_card_eight
    (hdeg : Module.finrank F E = 2)
    (C : Finset (EnvelopePoint E)) (hArc : Arc (L := EnvelopePoint E) C)
    (hC : IsInvariant (incidence F E hdeg) C) (hcard : C.card = 8) :
    profileEnvelope (Nat.card F) ≤ (globalLegalPairs F E hdeg C).card := by
  let f := (fixedArcPoints F E C).card
  let e := Nat.card (ConjugateInvariantArcPair F E C hC)
  have hprofile : 8 = f + 2 * e := by
    calc
      8 = C.card := hcard.symm
      _ = (fixedArcPoints F E C).card +
          2 * Nat.card (ConjugateInvariantArcPair F E C hC) :=
        card_eq_fixed_add_two_mul_nonfixedOrbits F E hdeg C hC
      _ = f + 2 * e := rfl
  have henvelope :
      profileEnvelope (Nat.card F) ≤ profileLowerBound (Nat.card F) f e :=
    profileEnvelope_le_profileLowerBound_of_eight hprofile
  have hcount : profileLowerBound (Nat.card F) f e ≤
      (globalLegalPairs F E hdeg C).card :=
    quadratic_global_pair_lowerBound F E hdeg C hArc hC
      8 f e hcard rfl hprofile
  exact henvelope.trans hcount

/-- Every invariant eight-arc over a quadratic base of order at least seven has at least 319 legal
conjugate-pair extensions. -/
theorem three_hundred_nineteen_le_card_globalLegalPairs_of_card_eight
    (hdeg : Module.finrank F E = 2) (hs : 7 ≤ Nat.card F)
    (C : Finset (EnvelopePoint E)) (hArc : Arc (L := EnvelopePoint E) C)
    (hC : IsInvariant (incidence F E hdeg) C) (hcard : C.card = 8) :
    319 ≤ (globalLegalPairs F E hdeg C).card := by
  exact (three_hundred_nineteen_le_profileEnvelope hs).trans
    (profileEnvelope_le_card_globalLegalPairs_of_card_eight F E hdeg C hArc hC hcard)

/-- **Quantitative alternate-orbit repair.**  Deleting any selected nonfixed orbit from an
invariant ten-arc over a quadratic base of order at least seven leaves at least 318 different legal
conjugate orbits that repair the arc. -/
theorem three_hundred_eighteen_le_alternateLegalPairs_of_seven_le
    (hdeg : Module.finrank F E = 2) (hs : 7 ≤ Nat.card F)
    (A : Finset (EnvelopePoint E)) (hArc : Arc (L := EnvelopePoint E) A)
    (hA : IsInvariant (incidence F E hdeg) A) (hcard : A.card = 10)
    (q : Sym2 (EnvelopePoint E)) (hq : IsSelectedNonfixedOrbit F E hdeg A q) :
    318 ≤ (alternateLegalPairs F E hdeg A q).card := by
  obtain ⟨hArcD, hInvD, hcardD, hqD⟩ :=
    delete_selected_nonfixed_orbit F E hdeg A hArc hA hcard q hq
  apply pred_le_card_alternateLegalPairs F E hdeg hqD
  exact three_hundred_nineteen_le_card_globalLegalPairs_of_card_eight
    F E hdeg hs (deleteOrbit E A q) hArcD hInvD hcardD

end
end AlternateOrbitRepair
end RelativeConicArcs
