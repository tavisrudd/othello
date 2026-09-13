import WeightedRules.OutputConvergenceChecks

/-!
# Axiom audit for the rule-output convergence bound

The terminals cover the improving-coordinate witness, the capped structural
bound, leastness, reflective conversion, symbolic sharpness and concrete
distance witnesses. All finite controls use ordinary kernel reduction.
-/

#print axioms WeightedRules.boundedMinPlus_step_improvement
#print axioms WeightedRules.boundedMinPlus_iterate_succ_cost
#print axioms WeightedRules.boundedMinPlus_rule_output_fixed
#print axioms WeightedRules.boundedMinPlus_rule_output_least
#print axioms WeightedRules.ruleOutput_iterate_eq_scalar
#print axioms WeightedRules.iterateFrom_rule_output_bound
#print axioms WeightedRules.improved_iterateFrom_rule_output_bound
#print axioms WeightedRules.ruleOutputCheckedSolution
#print axioms WeightedRules.CheckedSolution.withRuleOutputBound
#print axioms WeightedRules.CheckedImprovement.toRuleOutputSolution
#print axioms WeightedRules.zeroChain_rule_output_sharp
#print axioms WeightedRules.outputChain_output_count
#print axioms WeightedRules.outputChain_bound
#print axioms WeightedRules.outputChain_requires_extra_round
#print axioms WeightedRules.rule_output_extra_round_needed
#print axioms WeightedRules.distance_rule_output_bounds
#print axioms WeightedRules.improved_distance_output_conversion
#print axioms WeightedRules.improved_distance_output_least
