import RelativeConicArcs.Gates.AMELUStabilizerDictionary

/-!
# Axiom audit for the six-party stabilizer dictionary

The commands below expose the complete Lean axiom dependencies of the
paper-facing terminal statements.  They perform no native evaluation and
consume no generated certificates or external data.
-/

#print axioms RelativeConicArcs.AMELU.tensorWeylAction_apply
#print axioms RelativeConicArcs.AMELU.tensorWeylAction_equalPhaseState_of_mem_cssLabelSpace
#print axioms RelativeConicArcs.AMELU.cssLabelSpace_isPauliLagrangian
#print axioms RelativeConicArcs.AMELU.mem_cssSupportedLabelSpace_iff_support_subset
#print axioms RelativeConicArcs.AMELU.equalPhaseState_hasMinimalComputationalSupport
#print axioms RelativeConicArcs.AMELU.isMDSCode634_of_isAME_equalPhaseState
#print axioms RelativeConicArcs.AMELU.isAME_equalPhaseState_iff_isMDSCode634
