import WeightedRules.Oracle
import WeightedRules.ChainDistance

/-!
# Support-certified distance witnesses

The four-vertex distance program and the six-vertex chain are solved by the
external producer and returned as support certificates. The kernel checks
local fixedness and well-founded support in one pass; no iterate is replayed.
The resulting solutions carry the same leastness theorem as the replay-checked
ones, denote the same scalar-count iterate, and convert to the replay-checked
form by proof.
-/

namespace WeightedRules

set_option maxRecDepth 32768
set_option maxHeartbeats 4000000

/-- The four-vertex distances with their derivation support. -/
def supportedDistance : SupportedSolution distanceProgram :=
  ergodis_support_solution distanceProgram from "WeightedRules/fixtures/distance.json"

/-- The support-certified four-vertex distances are `[0, 3, 2, 6]`. -/
theorem supportedDistance_values :
    ((List.finRange 4).map fun i =>
      (listState supportedDistance.values (⟨16 + i.val, by omega⟩ : Fin 21)).val) =
      [0, 3, 2, 6] := by
  decide +kernel

/-- Least fixedness follows from the support check alone. -/
theorem supportedDistance_least :
    IsLeastFixed distanceProgram (listState supportedDistance.values) :=
  supportedDistance.least

/-- The support-certified and replay-certified values coincide. -/
theorem supportedDistance_eq_iterate :
    listState supportedDistance.values = iterate boundedMinPlus distanceProgram 21 :=
  supportedDistance.eq_iterate

/-- Conversion to the replay-checked form is by proof, not by replay. -/
def supportedDistanceChecked : CheckedSolution distanceProgram :=
  supportedDistance.toCheckedSolution

/-- The six-vertex chain with its derivation support. -/
def supportedChainDistance : SupportedSolution chainDistanceProgram :=
  ergodis_support_solution chainDistanceProgram from "WeightedRules/fixtures/chain-distance.json"

/-- The support-certified chain distances are the vertex indices. -/
theorem supportedChainDistance_values :
    ((List.finRange 6).map fun i =>
      (listState supportedChainDistance.values (⟨36 + i.val, by omega⟩ : Fin 43)).val) =
      [0, 1, 2, 3, 4, 5] := by
  decide +kernel

/-- The improved chain, checked from zero by support rather than by warm
replay: a warm witness and a cold witness cost the same to check this way. -/
def supportedChainDistanceImproved : SupportedSolution chainDistanceImprovedProgram :=
  ergodis_support_solution chainDistanceImprovedProgram
    from "WeightedRules/fixtures/chain-distance-improved.json"

/-- The support-certified improved chain agrees with the warm-replay witness. -/
theorem supportedChainDistanceImproved_eq :
    (listState supportedChainDistanceImproved.values : State Cost 43) =
      listState chainDistanceImproved.toCheckedSolution.values :=
  supportedChainDistanceImproved.eq_iterate.trans
    (CheckedSolution.eq_iterate chainDistanceImproved.toCheckedSolution).symm

end WeightedRules
