import RelativeConicArcs.Gates.AMELUDictionary

/-!
# Axiom audit for the six-party arc--MDS--AME dictionary

This audit prints the axiom dependencies of the six manuscript-facing
coherence terminals.  The module imports only the dictionary gate and
performs no computation.
-/

open RelativeConicArcs.AMELU

#print axioms isMDSCode634_arcKernel
#print axioms isAME_equalPhaseState
#print axioms isAME_equalPhaseState_arcKernel
#print axioms ConventionDictionary.state_isAME
#print axioms projectivelyEquivalent_arcKernel_monomiallyEquivalent
#print axioms projectivelyEquivalent_equalPhaseState_locallyCliffordEquivalent
