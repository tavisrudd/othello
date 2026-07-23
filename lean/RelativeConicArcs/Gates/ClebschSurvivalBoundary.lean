import RelativeConicArcs.ClebschSurvivalBoundary

/-!
# Import gate for finite survival and erasure boundaries

This gate exposes the complete four-companion/four-reduction incidence check, the zero-kernel
lower-moment witness for all descended companion weights, exact rational inverses for the four
cross-sheet incidence matrices, the frozen five-space/relative-cubic intersection test, and the
conditional modulo-forty residue partition.

All positive and negative conclusions are restricted to the displayed finite candidate families
and matrices.  Ordinary-character labels, Weil terminology, the identification of the frozen
five-space columns, and the arithmetic interpretation of the two residue predicates are inputs,
not conclusions.  No universal nonexistence theorem, integral cubic impossibility, parent
construction, common quadratic-character carrier, or prime-density statement is exported.
-/

#print axioms RelativeConicArcs.ClebschSurvivalBoundary.companion_sheet_hit_bijection
#print axioms RelativeConicArcs.ClebschSurvivalBoundary.companion_conjugation_has_no_fixed_candidate
#print axioms RelativeConicArcs.ClebschSurvivalBoundary.four_companions_fail_unique_stop_condition
#print axioms RelativeConicArcs.ClebschSurvivalBoundary.descended_companion_lowerMoment_kernel_zero
#print axioms RelativeConicArcs.ClebschSurvivalBoundary.no_nonzero_descended_weight_passes_lowerMoment_gate
#print axioms RelativeConicArcs.ClebschSurvivalBoundary.crossSheet_gram_identities
#print axioms RelativeConicArcs.ClebschSurvivalBoundary.seven_crossSheet_maps_injective
#print axioms RelativeConicArcs.ClebschSurvivalBoundary.eleven_crossSheet_maps_injective
#print axioms RelativeConicArcs.ClebschSurvivalBoundary.relativeCubic_quotient_injective
#print axioms RelativeConicArcs.ClebschSurvivalBoundary.tested_fiveSpace_cubics_have_zero_quotient
#print axioms RelativeConicArcs.ClebschSurvivalBoundary.tested_fiveSpace_relativeCubic_intersection_zero
#print axioms RelativeConicArcs.ClebschSurvivalBoundary.exact_mod40_residue_partition
#print axioms RelativeConicArcs.ClebschSurvivalBoundary.mod40_residue_partition_complete
#print axioms RelativeConicArcs.ClebschSurvivalBoundary.mod40_prediction_of_frozen_hypotheses
