import WeightedRules.LoweringSquare

/-!
# Logical dependencies of source-event lowering

These terminals cover finite square checking, trace transport, incompatible-fiber
obstructions, existence and uniqueness under surjectivity, and observation spans over a module.
The existence theorem selects source representatives classically. No terminal
checks an external serialized table or assumes a foreign computation is correct.
-/

/-- info: 'WeightedRules.EventLowering.square_trace' depends on axioms: [propext] -/
#guard_msgs in
#print axioms WeightedRules.EventLowering.square_trace
/-- info: 'WeightedRules.EventLowering.square_fiber' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.EventLowering.square_fiber
/-- info: 'WeightedRules.EventLowering.incompatible_no_square' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.EventLowering.incompatible_no_square
/-- info: 'WeightedRules.EventLowering.exists_square_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.EventLowering.exists_square_iff
/-- info: 'WeightedRules.EventLowering.square_unique' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.EventLowering.square_unique
/-- info: 'WeightedRules.EventLowering.checkSquare_sound' does not depend on any axioms -/
#guard_msgs in
#print axioms WeightedRules.EventLowering.checkSquare_sound
/-- info: 'WeightedRules.EventLowering.observation_span_square' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.EventLowering.observation_span_square
/-- info: 'WeightedRules.EventLowering.observation_span_trace' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeightedRules.EventLowering.observation_span_trace
