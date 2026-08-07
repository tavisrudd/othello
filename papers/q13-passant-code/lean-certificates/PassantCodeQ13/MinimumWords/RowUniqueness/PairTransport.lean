import PassantCodeQ13.MinimumWords.RowUniqueness.Base
import PassantCodeQ13.WeightTen.PencilTransport

/-!
# Indexed passant-join transport

The executable passant-join test on displayed internal-point indices scans the displayed passant
indices and evaluates the incidence form.  The relation `HasPassantJoin` asserts the existence of a
passant line incident to both points.  The two agree because the displayed passant indices exhaust
the passant lines and the incidence test is the incidence relation on the corresponding normalized
triples; no finite search is performed here.
-/

namespace PassantCodeQ13.MinimumWords.RowUniqueness

open RelativeConicArcs.PassantCodeQ13
open PassantCodeQ13.WeightTen

/-- At displayed indices, the executable passant-join test is the existence of a common passant. -/
theorem hasPassantJoin_eq_true_iff (first second : Fin 78) :
    hasPassantJoin first.1 second.1 = true ↔
      HasPassantJoin (internalPointAt first) (internalPointAt second) := by
  rw [hasPassantJoin, List.any_eq_true]
  constructor
  · rintro ⟨line, line_mem, incident⟩
    have line_lt : line < 78 := List.mem_range.mp line_mem
    have incidences := Bool.and_eq_true .. |>.mp incident
    exact ⟨passantLineAt ⟨line, line_lt⟩,
      (PencilTransport.incidentAt_iff ⟨line, line_lt⟩ first).mp incidences.1,
      (PencilTransport.incidentAt_iff ⟨line, line_lt⟩ second).mp incidences.2⟩
  · rintro ⟨line, first_incident, second_incident⟩
    obtain ⟨index, rfl⟩ := passantLineAt_bijective.surjective line
    refine ⟨index.1, List.mem_range.mpr index.2, ?_⟩
    rw [(PencilTransport.incidentAt_iff index first).mpr first_incident,
      (PencilTransport.incidentAt_iff index second).mpr second_incident]
    rfl

/-- Indexed passant joins are exactly semantic passant joins. -/
theorem indexedPassantJoin_eq_true_iff (first second : InternalPoint) :
    indexedPassantJoin first second = true ↔ HasPassantJoin first second := by
  obtain ⟨firstIndex, rfl⟩ := internalPointAt_bijective.surjective first
  obtain ⟨secondIndex, rfl⟩ := internalPointAt_bijective.surjective second
  rw [indexedPassantJoin, internalPointIndex_internalPointAt, internalPointIndex_internalPointAt]
  exact hasPassantJoin_eq_true_iff firstIndex secondIndex

end PassantCodeQ13.MinimumWords.RowUniqueness
