import WeightedRules.IncrementalChecks
import WeightedRules.IncrementalOracleRejections

/-!
# Axiom audit for incremental replay

The terminals cover source monotonicity, universal warm convergence, early
fixedness, typed incremental soundness, conversion to the existing certificate,
finite rejection controls and actual externally returned distance witnesses.
Their transitive dependencies delimit the proof route for the complete example.
-/

#print axioms WeightedRules.iterate_le_of_improves
#print axioms WeightedRules.iterateFrom_scalar_bound
#print axioms WeightedRules.iterateFrom_eq_of_fixed
#print axioms WeightedRules.improved_iterateFrom_bound
#print axioms WeightedRules.improved_iterateFrom_fixed
#print axioms WeightedRules.checkImprovementCertificate_sound
#print axioms WeightedRules.CheckedImprovement.toCheckedSolution
#print axioms WeightedRules.iteratedImprovement
#print axioms WeightedRules.zero_round_improvement
#print axioms WeightedRules.retraction_rejected
#print axioms WeightedRules.incremental_rejection_controls
#print axioms WeightedRules.unchecked_seed_boundary
#print axioms WeightedRules.chained_improvement_least
#print axioms WeightedRules.oracleImprovedDistance
#print axioms WeightedRules.oracleTwiceImprovedDistance
#print axioms WeightedRules.oracleDistanceNoop
#print axioms WeightedRules.oracleImprovedDistance_values
#print axioms WeightedRules.oracleTwiceImprovedDistance_values
#print axioms WeightedRules.oracleTwiceImprovedDistance_least
#print axioms WeightedRules.oracle_incremental_round_counts
