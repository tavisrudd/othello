import WeightedRules.BooleanRules
import WeightedRules.Convergence

/-!
# Axiom audit for ordered inflationary convergence

The terminals cover the generic scalar-count and rule-output bounds over any
ordered inflationary algebra, the two instances (bounded min-plus and Boolean
reachability), the exactness of the Boolean lift into bounded min-plus, and
the kernel-checked transitive-closure certificate. The printed dependencies
distinguish ordinary logical axioms from an admitted or native-execution
proof route.
-/

/-- info: 'WeightedRules.OrderedInflationary.improvement_round_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.OrderedInflationary.improvement_round_le
/-- info: 'WeightedRules.OrderedInflationary.iterate_fixed' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.OrderedInflationary.iterate_fixed
/-- info: 'WeightedRules.OrderedInflationary.iterate_add' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.OrderedInflationary.iterate_add
/-- info: 'WeightedRules.OrderedInflationary.certificate' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.OrderedInflationary.certificate
/-- info: 'WeightedRules.OrderedInflationary.iterate_least' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.OrderedInflationary.iterate_least
/-- info: 'WeightedRules.OrderedInflationary.rule_output_fixed' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.OrderedInflationary.rule_output_fixed
/-- info: 'WeightedRules.OrderedInflationary.ruleOutputCertificate' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.OrderedInflationary.ruleOutputCertificate
/-- info: 'WeightedRules.OrderedInflationary.rule_output_least' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.OrderedInflationary.rule_output_least
/-- info: 'WeightedRules.boundedMinPlus_orderedInflationary' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.boundedMinPlus_orderedInflationary
/-- info: 'WeightedRules.booleanRules_orderedInflationary' depends on axioms: [propext] -/
#guard_msgs in
#print axioms WeightedRules.booleanRules_orderedInflationary
/-- info: 'WeightedRules.booleanRules_zero_stable' does not depend on any axioms -/
#guard_msgs in
#print axioms WeightedRules.booleanRules_zero_stable
/-- info: 'WeightedRules.booleanMinus' does not depend on any axioms -/
#guard_msgs in
#print axioms WeightedRules.booleanMinus
/-- info: 'WeightedRules.booleanRules_iterate_fixed' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.booleanRules_iterate_fixed
/-- info: 'WeightedRules.booleanRules_iterate_least' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.booleanRules_iterate_least
/-- info: 'WeightedRules.booleanRules_rule_output_least' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.booleanRules_rule_output_least
/-- info: 'WeightedRules.boolLift_iterate' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.boolLift_iterate
/-- info: 'WeightedRules.closureCertificate' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.closureCertificate
/-- info: 'WeightedRules.closure_least' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.closure_least
/-- info: 'WeightedRules.closure_values' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.closure_values
