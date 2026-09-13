import WeightedRules.SupportExample
import WeightedRules.SupportChecks

/-!
# Axiom audit for support certificates

The terminals cover the generic support lemma and least-fixedness theorem,
the bounded min-plus checker's soundness, the conversion of a supported
solution to the replay-checked form, the external support witnesses for the
distance programs, and the self-loop controls. Support checks use ordinary
kernel reduction; the external witnesses insert only numeric literals.
-/

/-- info: 'WeightedRules.justified_le' depends on axioms: [propext] -/
#guard_msgs in
#print axioms WeightedRules.justified_le
/-- info: 'WeightedRules.supported_least' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.supported_least
/-- info: 'WeightedRules.checkSupportCertificate_sound' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.checkSupportCertificate_sound
/-- info: 'WeightedRules.SupportedSolution.least' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.SupportedSolution.least
/-- info: 'WeightedRules.SupportedSolution.eq_iterate' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.SupportedSolution.eq_iterate
/-- info: 'WeightedRules.SupportedSolution.values_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.SupportedSolution.values_eq
/-- info: 'WeightedRules.SupportedSolution.toCheckedSolution' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.SupportedSolution.toCheckedSolution
/-- info: 'WeightedRules.supportedDistance' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.supportedDistance
/-- info: 'WeightedRules.supportedDistance_values' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.supportedDistance_values
/-- info: 'WeightedRules.supportedDistance_least' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.supportedDistance_least
/-- info: 'WeightedRules.supportedDistanceChecked' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.supportedDistanceChecked
/-- info: 'WeightedRules.supportedChainDistance' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.supportedChainDistance
/-- info: 'WeightedRules.supportedChainDistance_values' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.supportedChainDistance_values
/-- info: 'WeightedRules.supportedChainDistanceImproved' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.supportedChainDistanceImproved
/-- info: 'WeightedRules.supportedChainDistanceImproved_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.supportedChainDistanceImproved_eq
/-- info: 'WeightedRules.selfLoop_zero_unsupported' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.selfLoop_zero_unsupported
/-- info: 'WeightedRules.selfLoop_infinity_supported' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.selfLoop_infinity_supported
/-- info: 'WeightedRules.selfLoop_replay_rejects' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.selfLoop_replay_rejects
