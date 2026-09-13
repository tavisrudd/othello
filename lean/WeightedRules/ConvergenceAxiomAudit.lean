import WeightedRules.ConvergenceChecks

/-!
# Axiom audit for scalar-round convergence

The terminals cover the universal round bound, fixedness and leastness,
reflective certificate completeness and uniqueness, sharpness for every positive
scalar count, and finite boundary controls. The printed dependencies distinguish
ordinary logical axioms from an admitted or native-execution proof route.
-/

/-- info: 'WeightedRules.boundedMinPlus_improvement_round_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.boundedMinPlus_improvement_round_le
/-- info: 'WeightedRules.boundedMinPlus_iterate_fixed' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.boundedMinPlus_iterate_fixed
/-- info: 'WeightedRules.boundedMinPlus_iterate_add' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.boundedMinPlus_iterate_add
/-- info: 'WeightedRules.boundedMinPlus_iterate_least' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.boundedMinPlus_iterate_least
/-- info: 'WeightedRules.boundedMinPlusCertificate' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.boundedMinPlusCertificate
/-- info: 'WeightedRules.checkCertificate_complete' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.checkCertificate_complete
/-- info: 'WeightedRules.CheckedSolution.eq_iterate' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.CheckedSolution.eq_iterate
/-- info: 'WeightedRules.iteratedCheckedSolution' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.iteratedCheckedSolution
/-- info: 'WeightedRules.zeroChain_iterate' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.zeroChain_iterate
/-- info: 'WeightedRules.zeroChain_requires_scalar_rounds' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.zeroChain_requires_scalar_rounds
/-- info: 'WeightedRules.empty_certificate_accepted' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.empty_certificate_accepted
/-- info: 'WeightedRules.unsupported_cycle_controls' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.unsupported_cycle_controls
/-- info: 'WeightedRules.repeated_factor_controls' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.repeated_factor_controls
/-- info: 'WeightedRules.saturation_controls' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.saturation_controls
