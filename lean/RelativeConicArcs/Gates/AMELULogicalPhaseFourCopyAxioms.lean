import RelativeConicArcs.Gates.AMELULogicalPhaseFourCopy

/-!
# Axiom audit for the logical phase and four-copy separator

This audit prints the dependencies of the diagonal-block algebra, the
fixed-party kernel dichotomy, the matching-map construction, and the final
q=13 local-unitary separation implication.
-/

open RelativeConicArcs.AMELU

#print axioms isSplitTorusBlock_of_specialLinear_of_offDiagonal_eq_zero
#print axioms fixedPartyKernel_eq_specialLinear_or_splitTorus
#print axioms generatedWord_add
#print axioms contractionMatchingRank_normalizeContractionPattern
#print axioms contractionRankOrbitSum_permuteContractionPattern
#print axioms q13_zFour_not_locallyUnitaryEquivalent_zTwelve
