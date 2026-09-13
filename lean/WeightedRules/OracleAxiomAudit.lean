import WeightedRules.OracleExample
import WeightedRules.OracleRejections
import WeightedRules.ReflectionChecks

/-!
# Axioms of reflected external witnesses

The audited declarations include the symbolic acceptance theorem and the actual
externally supplied distance witness. The foreign call supplies data during
elaboration; finite acceptance is checked by kernel reduction. Printing these
declarations' transitive axioms distinguishes that proof route from a native
decision oracle. The imported rejection controls cover both pure replay and the
external elaboration entry point.
-/

/-- info: 'WeightedRules.checkCertificate_sound' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.checkCertificate_sound
/-- info: 'WeightedRules.CheckedSolution.least' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.CheckedSolution.least
/-- info: 'WeightedRules.CheckedSolution.cost_order' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.CheckedSolution.cost_order
/-- info: 'WeightedRules.oracleDistance' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.oracleDistance
/-- info: 'WeightedRules.oracleDistance_least' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.oracleDistance_least
/-- info: 'WeightedRules.oracleDistance_rounds' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.oracleDistance_rounds
/-- info: 'WeightedRules.oracleDistance_values' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.oracleDistance_values
/-- info: 'WeightedRules.oracleDistance_agrees' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.oracleDistance_agrees
