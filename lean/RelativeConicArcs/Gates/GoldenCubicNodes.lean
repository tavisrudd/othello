import RelativeConicArcs.GoldenCubicFrameCarrier
import RelativeConicArcs.GoldenCubicNodeHessians
import RelativeConicArcs.GoldenCubicNodes
import RelativeConicArcs.GoldenMatchingCarrier

/-!
# Trust gate for the Golden cubic nodes and frame carrier

This gate audits the exact characteristic-zero formalization of the centered
Golden triangle cubic.  The imported modules identify its coordinate gradient,
classify its nonzero gradient-zero vectors as six projective lines, check a
nondegenerate dehomogenized Hessian at each node, and establish the
five-dimensional squarefree cubic system double at a six-point projective
frame together with its fifteen base edges.  The five centered matching forms
are independently proved linearly independent and double at that node frame.

The elimination identities are generated, but Lean rechecks them with
polynomial normalization.  The gate imports no external computer-algebra
certificate, native decision procedure, or additional axiom.  It does not
construct a scheme-theoretic primary decomposition or formalize the
determinantal Milnor-number theorem.
-/

#print axioms RelativeConicArcs.GoldenCubicNodesBase.cubic_eq_conference_triangleCubic
#print axioms RelativeConicArcs.GoldenCubicNodesBase.derivative_coordinatePolynomial_eval

#print axioms RelativeConicArcs.GoldenCubicNodes.gradient_smul
#print axioms RelativeConicArcs.GoldenCubicNodes.gradient_eq_zero_iff_smul_centeredNode
#print axioms RelativeConicArcs.GoldenCubicNodes.nonzero_gradient_zero_iff_projective_centeredNode
#print axioms RelativeConicArcs.GoldenCubicNodes.smul_centeredNode_injective

#print axioms RelativeConicArcs.GoldenCubicNodeHessians.det_chartHessian_chartNode
#print axioms RelativeConicArcs.GoldenCubicNodeHessians.det_chartHessian_chartNode_ne_zero
#print axioms RelativeConicArcs.GoldenCubicNodeHessians.derivative_gradientCoordinatePolynomial_chart

#print axioms RelativeConicArcs.GoldenCubicFrameCarrier.centeredNode_castSucc_linearIndependent
#print axioms RelativeConicArcs.GoldenCubicFrameCarrier.sum_centeredNode_eq_zero
#print axioms RelativeConicArcs.GoldenCubicFrameCarrier.incidence_incidenceRightInverse
#print axioms RelativeConicArcs.GoldenCubicFrameCarrier.finrank_frameDoubleCarrier
#print axioms RelativeConicArcs.GoldenCubicFrameCarrier.eval_line_standardFramePoint_eq_zero

#print axioms RelativeConicArcs.GoldenMatchingCarrier.matchingForm_linearIndependent
#print axioms RelativeConicArcs.GoldenMatchingCarrier.matchingForm_centeredNode
#print axioms RelativeConicArcs.GoldenMatchingCarrier.derivative_matchingCoordinatePolynomial_centeredNode
