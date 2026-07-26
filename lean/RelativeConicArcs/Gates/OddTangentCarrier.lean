import RelativeConicArcs.OddTangentCarrier

/-!
# Odd tangent-carrier verification boundary

This import-only module checks the characteristic-two factor/root algebra, the zeroth-conductor
obstruction, the finite ordered-pair count, the complete multipartite tangent-fiber compatibility
graph, and the common-factor transfer for the first conductor.

It does not claim a formal construction of the dual Chow product, a projective identification of
the regular oval and its tangent fibers, the geometric cross-fiber triple count, or the global
extension of compatible roots to a plane form.
-/

#print axioms RelativeConicArcs.sq_injective_charTwo
#print axioms RelativeConicArcs.oddTangentFactorization_rescale
#print axioms RelativeConicArcs.oddZerothConductorSq_ne_zero
#print axioms RelativeConicArcs.tangentConductorPartner_involutive
#print axioms RelativeConicArcs.tangentConductorPartner_ne_self
#print axioms RelativeConicArcs.tangentConductorPartner_ne_zero
#print axioms RelativeConicArcs.excludedTangentParametersEquivOrderedPairs
#print axioms RelativeConicArcs.card_nonzeroOrderedConductorPairs
#print axioms RelativeConicArcs.tangentFiberCompatibilityGraph_adj_iff
#print axioms RelativeConicArcs.tangentFiberCompatibilityGraph_isClique_iff_injOn
#print axioms RelativeConicArcs.tangentFiberCompatibilityGraph_clique_card_le
#print axioms RelativeConicArcs.exists_tangentFiberCompatibilityGraph_clique_card_eq
#print axioms RelativeConicArcs.ordinaryGlobalizes_iff_of_transversal_arc_criteria
#print axioms RelativeConicArcs.oddCarrierConductor_mul_commonFactor
#print axioms RelativeConicArcs.oddCarrierConductor_mul_commonFactor_ne_zero_iff
