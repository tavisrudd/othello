import WeightedRules.BoundedMinPlus
import WeightedRules.Relations

/-!
# Axiom audit for finite weighted rule certificates

The imported declarations cover polynomial monotonicity, leastness of finite
convergence certificates, source-lowering commutation, symmetry invariance,
bounded min-plus laws and a 21-coordinate cyclic distance example. The print
commands expose their transitive logical axioms. Concrete certificate checks
use kernel reduction rather than native evaluation or an external oracle.
-/

/-- info: 'WeightedRules.step_mono' does not depend on any axioms -/
#guard_msgs in
#print axioms WeightedRules.step_mono
/-- info: 'WeightedRules.certificate_least' does not depend on any axioms -/
#guard_msgs in
#print axioms WeightedRules.certificate_least
/-- info: 'WeightedRules.certificates_agree' depends on axioms: [Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.certificates_agree
/-- info: 'WeightedRules.lowering_iterate' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.lowering_iterate
/-- info: 'WeightedRules.symmetry_iterate' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.symmetry_iterate
/-- info: 'WeightedRules.boundedMinPlus' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.boundedMinPlus
/-- info: 'WeightedRules.boundedMinPlus_zero_stable' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.boundedMinPlus_zero_stable
/-- info: 'WeightedRules.boundedMinus' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.boundedMinus
/-- info: 'WeightedRules.distanceCertificate' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.distanceCertificate
/-- info: 'WeightedRules.distance_least' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.distance_least
/-- info: 'WeightedRules.distance_values' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.distance_values
/-- info: 'WeightedRules.relational_certificate_least' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.relational_certificate_least
/-- info: 'WeightedRules.distance_signature_count' does not depend on any axioms -/
#guard_msgs in
#print axioms WeightedRules.distance_signature_count
