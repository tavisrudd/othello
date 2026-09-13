import WeightedRules.ConvergenceChecks

/-!
# Axiom audit for scalar-round convergence

The terminals cover the universal round bound, fixedness and leastness,
reflective certificate completeness and uniqueness, sharpness for every positive
scalar count, and finite boundary controls. The printed dependencies distinguish
ordinary logical axioms from an admitted or native-execution proof route.
-/

#print axioms WeightedRules.boundedMinPlus_improvement_round_le
#print axioms WeightedRules.boundedMinPlus_iterate_fixed
#print axioms WeightedRules.boundedMinPlus_iterate_add
#print axioms WeightedRules.boundedMinPlus_iterate_least
#print axioms WeightedRules.checkCertificate_complete
#print axioms WeightedRules.CheckedSolution.eq_iterate
#print axioms WeightedRules.zeroChain_iterate
#print axioms WeightedRules.zeroChain_requires_scalar_rounds
#print axioms WeightedRules.empty_certificate_accepted
#print axioms WeightedRules.unsupported_cycle_controls
#print axioms WeightedRules.repeated_factor_controls
#print axioms WeightedRules.saturation_controls
