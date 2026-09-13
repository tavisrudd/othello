import WeightedRules.IncrementalChecks
import WeightedRules.IncrementalOracleRejections

/-!
# Axiom audit for incremental replay

The terminals cover source monotonicity, universal warm convergence, early
fixedness, typed incremental soundness, conversion to the existing certificate,
finite rejection controls and actual externally returned distance witnesses.
Their transitive dependencies delimit the proof route for the complete example.
-/

/-- info: 'WeightedRules.iterate_le_of_improves' does not depend on any axioms -/
#guard_msgs in
#print axioms WeightedRules.iterate_le_of_improves
/-- info: 'WeightedRules.iterateFrom_scalar_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.iterateFrom_scalar_bound
/-- info: 'WeightedRules.iterateFrom_eq_of_fixed' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.iterateFrom_eq_of_fixed
/-- info: 'WeightedRules.improved_iterateFrom_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.improved_iterateFrom_bound
/-- info: 'WeightedRules.improved_iterateFrom_fixed' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.improved_iterateFrom_fixed
/-- info: 'WeightedRules.checkImprovementCertificate_sound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.checkImprovementCertificate_sound
/-- info: 'WeightedRules.CheckedImprovement.toCheckedSolution' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.CheckedImprovement.toCheckedSolution
/-- info: 'WeightedRules.iteratedImprovement' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.iteratedImprovement
/-- info: 'WeightedRules.zero_round_improvement' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.zero_round_improvement
/-- info: 'WeightedRules.retraction_rejected' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.retraction_rejected
/-- info: 'WeightedRules.incremental_rejection_controls' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.incremental_rejection_controls
/-- info: 'WeightedRules.unchecked_seed_boundary' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.unchecked_seed_boundary
/-- info: 'WeightedRules.chained_improvement_least' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.chained_improvement_least
/-- info: 'WeightedRules.oracleImprovedDistance' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.oracleImprovedDistance
/-- info: 'WeightedRules.oracleTwiceImprovedDistance' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.oracleTwiceImprovedDistance
/-- info: 'WeightedRules.oracleDistanceNoop' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.oracleDistanceNoop
/-- info: 'WeightedRules.oracleImprovedDistance_values' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.oracleImprovedDistance_values
/-- info: 'WeightedRules.oracleTwiceImprovedDistance_values' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.oracleTwiceImprovedDistance_values
/-- info: 'WeightedRules.oracleTwiceImprovedDistance_least' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.oracleTwiceImprovedDistance_least
/-- info: 'WeightedRules.oracle_incremental_round_counts' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.oracle_incremental_round_counts
