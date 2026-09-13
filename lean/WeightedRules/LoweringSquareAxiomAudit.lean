import WeightedRules.LoweringSquare

/-!
# Logical dependencies of source-event lowering

These terminals cover finite square checking, trace transport, incompatible-fiber
obstructions, existence and uniqueness under surjectivity, and observation spans over a module.
The existence theorem selects source representatives classically. No terminal
checks an external serialized table or assumes a foreign computation is correct.
-/

#print axioms WeightedRules.EventLowering.square_trace
#print axioms WeightedRules.EventLowering.square_fiber
#print axioms WeightedRules.EventLowering.incompatible_no_square
#print axioms WeightedRules.EventLowering.exists_square_iff
#print axioms WeightedRules.EventLowering.square_unique
#print axioms WeightedRules.EventLowering.checkSquare_sound
#print axioms WeightedRules.EventLowering.observation_span_square
#print axioms WeightedRules.EventLowering.observation_span_trace
