import RelativeConicArcs.Gates.PassantCodeQ13

/-!
# Axiom audit for the shared q=13 passant-code semantics

The commands print the axiom dependencies of the cardinality, rank transport, tangent-graph, and
reconstruction-interface terminals exported by `RelativeConicArcs.Gates.PassantCodeQ13`.
-/

#print axioms RelativeConicArcs.PassantCodeQ13.internalPoint_card
#print axioms RelativeConicArcs.PassantCodeQ13.passantLine_card
#print axioms RelativeConicArcs.PassantCodeQ13.passantCode_finrank_eq_thirtySix
#print axioms RelativeConicArcs.PassantCodeQ13.WeightEight.fourCliques_length
#print axioms RelativeConicArcs.PassantCodeQ13.WeightEight.fourClique_unique_extension_check
#print axioms RelativeConicArcs.PassantCodeQ13.WeightEight.fiveCliqueCodes_length
#print axioms RelativeConicArcs.PassantCodeQ13.WeightEight.fiveClique_maximality_check
#print axioms RelativeConicArcs.PassantCodeQ13.reconstructedRows_eq_passantRows
#print axioms RelativeConicArcs.Gates.PassantCodeQ13.weightTen_profile_reduction
#print axioms RelativeConicArcs.PassantCodeQ13.LogicalSpine.association_kernel_rigidity
#print axioms RelativeConicArcs.PassantCodeQ13.LogicalSpine.relationOnKernel_surjective
#print axioms RelativeConicArcs.PassantCodeQ13.LogicalSpine.relation_range_eq_kernel
#print axioms RelativeConicArcs.PassantCodeQ13.LogicalSpine.factorization_forces_orbit_span
#print axioms RelativeConicArcs.PassantCodeQ13.LogicalSpine.four_anchor_rigidity
