import RelativeConicArcs.EvaluationDichotomy
import RelativeConicArcs.Results
import RelativeConicArcs.Q9Terminal
import RelativeConicArcs.Q11Residual
import RelativeConicArcs.Q11Coding
import RelativeConicArcs.UncoveredLocusReconstruction
import RelativeConicArcs.MatchingDesignRigidity
import RelativeConicArcs.KleinFourOrbitCongruence
import RelativeConicArcs.EqualityConsequences
import RelativeConicArcs.TangentPairFourGroup

/-!
# Relative-conic verification boundary

This import-only module is the transitive kernel-checking boundary for the relative-conic results
and their game and coding-theory applications.  It includes exact uncovered-locus reconstruction,
equivariant stabilizer recovery, secant concurrence decomposition, zero-defect maximum-matching
rigidity, exact centre-count identities, bad-edge stability, secant-deletion stability, and the
finite-group unique-fixed-point congruence with its order-four specialization.  It also checks the
standard-conic exclusion of the entire upper even characteristic-two equality branch via
tangent-pair involutions, the discrete defect gap, affine and odd equality spectra, the
characteristic-two odd-order reduction, and the specialized `(4096,92)` secant-type split.  The
separate order-twenty-five certificate, repair, and other developments are not dependencies of
these results.
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
#print axioms RelativeConicArcs.card_mod_group_order_eq_one_of_unique_fixed_point_action
#print axioms RelativeConicArcs.card_mod_four_eq_one_of_unique_fixed_point_action
#print axioms RelativeConicArcs.no_unique_fixed_point_four_group_action_on_card_ninety_one
#print axioms RelativeConicArcs.scaledDefect_eq_zero_or_half_sub_two_le
#print axioms RelativeConicArcs.completeAffine_equality_order
#print axioms RelativeConicArcs.odd_completeOutside_zeroDefect_order_spectrum
#print axioms RelativeConicArcs.odd_standardConic_zeroDefect_charTwo_order
#print axioms RelativeConicArcs.exceptional_candidate_secant_type_cards
#print axioms RelativeConicArcs.upper_even_equality_branch_holeIncidence
#print axioms RelativeConicArcs.TangentPairFourGroup.no_upper_even_equality_branch
#print axioms RelativeConicArcs.TangentPairFourGroup.no_exceptional_candidate_standardConic
