import WeightedRules.OutputConvergenceChecks

/-!
# Axiom audit for the rule-output convergence bound

The terminals cover the improving-coordinate witness, the capped structural
bound, leastness, reflective conversion, symbolic sharpness, concrete
distance witnesses, and the externally obtained six-vertex chain baseline with
its warm replay. All finite controls use ordinary kernel reduction; the chain
witnesses insert only numeric literals returned by the external producer.
-/

/-- info: 'WeightedRules.chainDistanceBaseline' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.chainDistanceBaseline
/-- info: 'WeightedRules.chainDistanceBaseline_values' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.chainDistanceBaseline_values
/-- info: 'WeightedRules.chainDistanceImproved' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.chainDistanceImproved
/-- info: 'WeightedRules.chainDistanceImproved_values' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.chainDistanceImproved_values
/-- info: 'WeightedRules.boundedMinPlus_step_improvement' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.boundedMinPlus_step_improvement
/-- info: 'WeightedRules.boundedMinPlus_iterate_succ_cost' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.boundedMinPlus_iterate_succ_cost
/-- info: 'WeightedRules.boundedMinPlus_rule_output_fixed' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.boundedMinPlus_rule_output_fixed
/-- info: 'WeightedRules.boundedMinPlus_rule_output_least' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.boundedMinPlus_rule_output_least
/-- info: 'WeightedRules.ruleOutput_iterate_eq_scalar' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.ruleOutput_iterate_eq_scalar
/-- info: 'WeightedRules.iterateFrom_rule_output_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.iterateFrom_rule_output_bound
/-- info: 'WeightedRules.improved_iterateFrom_rule_output_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.improved_iterateFrom_rule_output_bound
/-- info: 'WeightedRules.ruleOutputCertificate' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.ruleOutputCertificate
/-- info: 'WeightedRules.ruleOutputCheckedSolution' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.ruleOutputCheckedSolution
/-- info: 'WeightedRules.CheckedSolution.withRuleOutputBound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.CheckedSolution.withRuleOutputBound
/-- info: 'WeightedRules.CheckedImprovement.toRuleOutputSolution' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.CheckedImprovement.toRuleOutputSolution
/-- info: 'WeightedRules.zeroChain_rule_output_sharp' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.zeroChain_rule_output_sharp
/-- info: 'WeightedRules.outputChain_output_count' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.outputChain_output_count
/-- info: 'WeightedRules.outputChain_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.outputChain_bound
/-- info: 'WeightedRules.outputChain_requires_extra_round' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.outputChain_requires_extra_round
/-- info: 'WeightedRules.rule_output_extra_round_needed' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.rule_output_extra_round_needed
/-- info: 'WeightedRules.distance_rule_output_bounds' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.distance_rule_output_bounds
/-- info: 'WeightedRules.improved_distance_output_conversion' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.improved_distance_output_conversion
/-- info: 'WeightedRules.improved_distance_output_least' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.improved_distance_output_least
