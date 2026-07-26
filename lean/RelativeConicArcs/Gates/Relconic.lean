import RelativeConicArcs.EvaluationDichotomy
import RelativeConicArcs.Results
import RelativeConicArcs.Q9Terminal
import RelativeConicArcs.Q11Residual
import RelativeConicArcs.Q11Coding
import RelativeConicArcs.UncoveredLocusReconstruction
import RelativeConicArcs.MatchingDesignRigidity

/-!
# Relative-conic verification boundary

This import-only module is the transitive kernel-checking boundary for the relative-conic results
and their game and coding-theory applications.  It includes exact uncovered-locus reconstruction,
equivariant stabilizer recovery, secant concurrence decomposition, zero-defect maximum-matching
rigidity, exact centre-count identities, bad-edge stability, and secant-deletion stability.  The
separate order-twenty-five certificate and repair developments are not dependencies of these
results.
-/

#print axioms RelativeConicArcs.linesAboveUncoveredThreshold_eq_secants
#print axioms RelativeConicArcs.verticesOfLineFamily_secants_eq
#print axioms RelativeConicArcs.canonical_reconstruction
#print axioms RelativeConicArcs.eq_of_ordinaryUncovered_eq
#print axioms RelativeConicArcs.stabilizes_iff_stabilizes_ordinaryUncovered
#print axioms RelativeConicArcs.disjoint_arcPairs_existsUnique_concurrence
#print axioms RelativeConicArcs.concurrence_matching_injective
#print axioms RelativeConicArcs.concurrenceCenter_pointIndex_eq_half
#print axioms RelativeConicArcs.concurrenceCenters_card_mul_choose_half
#print axioms RelativeConicArcs.concurrenceCenters_card_eq_quotient
#print axioms RelativeConicArcs.concurrenceCentersOnPair_card_mul_sub_one
#print axioms RelativeConicArcs.concurrenceCentersOnPair_card_eq_quotient
#print axioms RelativeConicArcs.two_mul_badConcurrenceEdgeCount_le
#print axioms RelativeConicArcs.exists_secantDeletionSet
