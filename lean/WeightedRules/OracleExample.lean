import WeightedRules.Oracle

/-!
# A recursive distance witness obtained through the external ABI

The source fixture `WeightedRules/fixtures/distance.json` describes the same
four-vertex equations as `distanceProgram`. The oracle returns all 21 scalar
values. Kernel reduction checks their finite replay and fixedness against that
formal program, independently of the external parser and grounding. The resulting
theorem states leastness in information order, and the distance readout is
zero, three, two and six. No foreign result or native decision axiom is trusted.
-/

namespace WeightedRules

set_option maxRecDepth 16384 in
/-- External witness with kernel-checked replay against the formal distance equations. -/
def oracleDistance : CheckedSolution distanceProgram :=
  ergodis_solution distanceProgram from "WeightedRules/fixtures/distance.json"

/-- The externally proposed valuation is the least fixed solution of the distance equations. -/
theorem oracleDistance_least : IsLeastFixed distanceProgram (listState oracleDistance.values) :=
  oracleDistance.least

/-- The checked witness converges in four synchronous rounds. -/
theorem oracleDistance_rounds : oracleDistance.rounds = 4 := by rfl

/-- Reading the four distance coordinates gives costs zero, three, two and six. -/
theorem oracleDistance_values :
    ((oracleDistance.values.drop 16).take 4).map Fin.val = [0, 3, 2, 6] := by rfl

/-- The external witness agrees with the independently defined finite-iteration certificate. -/
theorem oracleDistance_agrees :
    listState oracleDistance.values = iterate boundedMinPlus distanceProgram 4 := by
  funext i
  exact info_antisymm boundedMinPlus
    (oracleDistance.least.2 _ distance_least.1 i)
    (distance_least.2 _ oracleDistance.least.1 i)

end WeightedRules
