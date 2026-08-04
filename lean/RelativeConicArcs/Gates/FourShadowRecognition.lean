import RelativeConicArcs.FourShadowRecognition

/-!
# Gate: triangle and commutator-Pfaffian recognition

This import-only gate exposes the order-six weighted converse, the structural
pentagon classification for normalized sign matrices, and the oriented
six-test recognition packet.  The weighted converse and the implication from
five balances to the conference square are symbolic kernel proofs.

The orientation classifier is symbolic as well.  The five root-pair balances
are five linear equations in the ten edge signs; a proved sign lemma settles
the four edges at the first non-root vertex, and the remaining six Boolean edge
parameters are then enumerated against the four remaining equations, leaving
the twelve labelled pentagons.  Each of them gives one polynomial identity
between the two cubics and one integer coefficient comparison, both proved by
kernel normalization.  The scalar-sign conclusions remain root-normalized and
do not include switching reduction or uniqueness modulo switching and
permutation.  The rank-fourteen rational Jacobian calculation for local
weighted rigidity is external.  No compiled evaluation, external certificate,
or generated source is used by the declarations printed here.
-/

#print axioms RelativeConicArcs.GoldenCommutatorPfaffian.pfaffianSix_bracketMatrix_eq_matchingEvaluation
#print axioms RelativeConicArcs.GoldenCommutatorPfaffian.matchingEvaluation_translate
#print axioms RelativeConicArcs.ClebschGoldenConference.pairTriangleSum_eq_mul_mulApply
#print axioms RelativeConicArcs.FourShadowRecognition.cubicsProportional_smul_iff
#print axioms RelativeConicArcs.FourShadowRecognition.triangleCubic_translate_of_proportional
#print axioms RelativeConicArcs.FourShadowRecognition.triangleMixedDifference_eq_pairTriangleSum
#print axioms RelativeConicArcs.FourShadowRecognition.pairTriangleSum_eq_zero_of_triangleCubic_translate
#print axioms RelativeConicArcs.FourShadowRecognition.pairTriangleSum_eq_zero_of_cubicsProportional
#print axioms RelativeConicArcs.FourShadowRecognition.exists_scalar_mul_self_of_offDiagonal_zero
#print axioms RelativeConicArcs.FourShadowRecognition.exists_mul_self_eq_scalar_of_cubicsProportional
#print axioms RelativeConicArcs.FourShadowRecognition.pentagonGauge_of_firstRowBalanced
#print axioms RelativeConicArcs.FourShadowRecognition.normalizedSignMatrix_sq_of_firstRowBalanced
#print axioms RelativeConicArcs.FourShadowRecognition.cubicsProportional_four_of_sixTests
#print axioms RelativeConicArcs.FourShadowRecognition.cubicsProportional_neg_four_of_sixTests
#print axioms RelativeConicArcs.FourShadowRecognition.exists_nonzero_cubicsProportional_iff_conferenceSquare
#print axioms RelativeConicArcs.FourShadowRecognition.exists_nonzero_cubicsProportional_smul_iff_conferenceSquare
#print axioms RelativeConicArcs.FourShadowRecognition.pentagon_bit_classification
#print axioms RelativeConicArcs.FourShadowRecognition.pentagon_bits_balanced
