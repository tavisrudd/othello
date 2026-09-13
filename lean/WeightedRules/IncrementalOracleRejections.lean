import WeightedRules.IncrementalExample

/-!
# Rejection controls for externally proposed incremental witnesses

The native provider returns valid witnesses for the named source fixtures.
Elaboration must nevertheless reject insufficient or excessive replay counts,
a candidate for different new equations, and a retraction supplied as an
improvement. Each rejection is checked against the exact expected diagnostic.
-/

namespace WeightedRules

set_option maxRecDepth 16384

/-- error: Ergodis incremental certificate failed kernel replay -/
#guard_msgs in
example : CheckedImprovement oracleDistance improvedDistanceProgram :=
  ergodis_improvement oracleDistance to improvedDistanceProgram
    from "WeightedRules/fixtures/distance-improved.json" replay 2

/-- error: Ergodis incremental certificate failed kernel replay -/
#guard_msgs in
example : CheckedImprovement oracleDistance improvedDistanceProgram :=
  ergodis_improvement oracleDistance to improvedDistanceProgram
    from "WeightedRules/fixtures/distance-improved.json" replay 22

/-- error: Ergodis incremental certificate failed kernel replay -/
#guard_msgs in
example : CheckedImprovement oracleDistance improvedDistanceProgram :=
  ergodis_improvement oracleDistance to improvedDistanceProgram
    from "WeightedRules/fixtures/distance-improved-twice.json" replay 3

/-- error: Ergodis incremental certificate failed kernel replay -/
#guard_msgs in
example : CheckedImprovement oracleImprovedDistance.toCheckedSolution distanceProgram :=
  ergodis_improvement oracleImprovedDistance.toCheckedSolution to distanceProgram
    from "WeightedRules/fixtures/distance.json" replay 21

end WeightedRules
