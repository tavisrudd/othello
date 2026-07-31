import RelativeConicArcs.ClebschMiddleExterior

/-!
# Mod-two support recovery for the middle-exterior return

This leaf checks the parity graph and the common-neighbor characterization of
complementation on the twenty increasing triples.  Native decision evaluates
the determinant-defined return and the finite incidence relations.  No stored
graph or generated certificate is imported.
-/

namespace RelativeConicArcs
namespace ClebschMiddleExterior

set_option maxRecDepth 10000

/-- Modulo two, an entry of the middle-exterior return is odd exactly when
the two triples meet in one label. -/
theorem middleExterior_mod_two_eq_one_iff (S T : Fin 20) :
    middleExterior S T % 2 = 1 ↔ intersectionSize S T = 1 := by
  native_decide +revert

/-- Complementation is an involution on the triple basis. -/
theorem complementIndex_involutive : Function.Involutive complementIndex := by
  intro S
  fin_cases S <;> rfl

/-- Common-neighbor counts distinguish equality, complementation, and the two
nontrivial intersection relations. -/
theorem commonIntersectionOneNeighbors_eq (S T : Fin 20) :
    commonIntersectionOneNeighbors S T =
      if S = T then 9 else if T = complementIndex S then 0 else 4 := by
  native_decide +revert

/-- Among labels distinct from `S`, its complement is characterized by having
no common intersection-one neighbor with `S`. -/
theorem commonIntersectionOneNeighbors_eq_zero_iff (S T : Fin 20)
    (hST : S ≠ T) :
    commonIntersectionOneNeighbors S T = 0 ↔ T = complementIndex S := by
  native_decide +revert

end ClebschMiddleExterior
end RelativeConicArcs
