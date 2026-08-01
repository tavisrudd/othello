import RelativeConicArcs.ClebschGoldenConference
import RelativeConicArcs.CorankOneAdjugate
import RelativeConicArcs.GoldenCommutatorPfaffian
import RelativeConicArcs.GoldenMatchingJacobian

/-!
# Trust gate for the algebraic Golden proof spine

This gate imports the order-six conference matrix together with four reusable
algebraic mechanisms: affine covariance of noncrossing matching cubics,
symbolic Jacobian-minor identities on three collision charts, Pfaffian
evaluation as a signed sum over perfect matchings, and the outer-product form
of an adjugate with generated one-dimensional left and right kernels.

All declarations audited below are symbolic kernel proofs.  The gate does not
claim the representation-theoretic identification of the matching carrier,
scheme saturation away from the displayed charts, or passage from affine
slices to a geometric quotient.
-/

#print axioms RelativeConicArcs.GoldenMatchingCubics.matchingCubics_affine
#print axioms RelativeConicArcs.GoldenMatchingCubics.matchingCubics_eq_zero_of_threeThree

#print axioms RelativeConicArcs.GoldenMatchingJacobian.selectedMinor_eq_det
#print axioms RelativeConicArcs.GoldenMatchingJacobian.fourOneOne_minor_identity
#print axioms RelativeConicArcs.GoldenMatchingJacobian.fourTwo_minor_identity
#print axioms RelativeConicArcs.GoldenMatchingJacobian.fiveOne_minor_identity

#print axioms RelativeConicArcs.GoldenCommutatorPfaffian.bracketMatrix_transpose
#print axioms RelativeConicArcs.GoldenCommutatorPfaffian.pfaffianSix_bracketMatrix_eq_matchingEvaluation
#print axioms RelativeConicArcs.GoldenCommutatorPfaffian.matchingEvaluation_translate
#print axioms RelativeConicArcs.GoldenCommutatorPfaffian.matchingEvaluation_scale

#print axioms RelativeConicArcs.CorankOneAdjugate.adjugate_eq_smul_outerProduct_of_generated_kernels
