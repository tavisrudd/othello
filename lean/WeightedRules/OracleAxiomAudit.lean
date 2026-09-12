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

#print axioms WeightedRules.checkCertificate_sound
#print axioms WeightedRules.CheckedSolution.least
#print axioms WeightedRules.CheckedSolution.cost_order
#print axioms WeightedRules.oracleDistance
#print axioms WeightedRules.oracleDistance_least
#print axioms WeightedRules.oracleDistance_rounds
#print axioms WeightedRules.oracleDistance_values
#print axioms WeightedRules.oracleDistance_agrees
