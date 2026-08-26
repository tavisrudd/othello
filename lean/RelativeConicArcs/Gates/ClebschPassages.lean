import RelativeConicArcs.QuadraticPinching
import RelativeConicArcs.SplitQuadraticPinching
import RelativeConicArcs.InvolutiveOddUnit
import RelativeConicArcs.GoldenQuadraticCharacters
import RelativeConicArcs.TightFrameConference
import RelativeConicArcs.SignedEquiangularGram
import RelativeConicArcs.ClebschGoldenConference
import RelativeConicArcs.MarkedClebschBridge
import RelativeConicArcs.KneserPairEigenspace
import RelativeConicArcs.PetersenHarmonicKernel
import RelativeConicArcs.ClebschInvariantCubic
import RelativeConicArcs.AlignedTwoGraph
import RelativeConicArcs.AlignedFamilyFaithfulness
import RelativeConicArcs.AlignedQueryFamily
import RelativeConicArcs.AlignedQueryFaithfulness
import RelativeConicArcs.SeidelPrincipalMinors
import RelativeConicArcs.ClebschPassagesCorrespondence
import RelativeConicArcs.SphereIntegralMoments
import RelativeConicArcs.TraceSplitQuadraticAlgebra
import RelativeConicArcs.ClebschGoldenSteinChart
import RelativeConicArcs.SpinorSquareClass
import RelativeConicArcs.NormalizedMarkedIncidence

/-!
# Gate: structural Clebsch passages

This is the public replay surface for the algebraic mechanisms used in the
current Clebsch paper.  The pinching, eigenspace, tight-frame, switching,
aligned-design faithfulness, and scalar-factor arguments are symbolic.
No compiled evaluation enters this gate.  Every terminal printed below
depends only on `propext`, `Classical.choice` and `Quot.sound`, and six
depend on no axiom at all.  The order-six conference matrix is kernel-checked
in `ClebschGoldenConference`; both bounds behind the triangle Ramsey equality
on six labelled points, and the aligned anchor they produce, are proved here.
Aligned-design faithfulness is proved for every two-graph on a finite point set
with at least seven points: the aligned four-sets determine the two-graph up to
one global complement bit.  The four-sets meeting one aligned four-point anchor
in at least two points already suffice for that conclusion, which is the
sufficiency statement accompanying the count of those tests.  For a Seidel
matrix — symmetric, vanishing diagonal, off-diagonal entries `1` or `-1` — the
principal four-by-four minor on four distinct labels is `-3` exactly on the
aligned four-sets of its two-graph and is `5` otherwise, so its
determinant-`(-3)` family determines its signing up to diagonal switching and
one global sign.

The finite steps use three methods.  Kernel `decide` takes the displayed
reflection matrices entrywise, the finite-field nonsquare witness over the
eleven residues, and the two aligned two-graph classifiers over their 16,384
and eight cases.  `norm_num` takes the marked fixed vector sum, its third
elementary symmetric value, the two reflection-vector norms and the
identification of each displayed integral reflection with the rational
reflection formula; these are rewriting procedures producing kernel-checked
terms, not evaluations of a `Decidable` instance.  One determinant falls to
cofactor expansion.  The third-outside-point elimination, the normalization of
an arbitrary two-graph onto that classifier, the extension from seven points to
larger point sets, the count of the tests meeting a fixed four-point anchor in
at least two points and their sufficiency, and the identification of the
determinant-`(-3)` family of a Seidel matrix with its aligned family are
symbolic.

The gate deliberately does not assert the geometric correspondence between
Hitchin's spaces and these algebraic models, nor the integral
Mukai--Umemura comparison.  Those inputs remain outside the formal trust
claim.  It does expose the complete formal consequences now used around that
boundary: normalized integration of every even homogeneous polynomial on the
two-sphere, the trace-split quadratic chart and its golden specialization, the
spinor square class of the marked exchanger, and the deck-equivariance packet
for normalized marked incidence data.
-/

#print axioms RelativeConicArcs.QuadraticPinching.conductor_eq_ker
#print axioms RelativeConicArcs.QuadraticPinching.exists_pinching_add_alpha_mul
#print axioms RelativeConicArcs.SplitQuadraticPinching.conductor_eq_branchIdeal
#print axioms RelativeConicArcs.SplitQuadraticPinching.algebra_isIntegral
#print axioms RelativeConicArcs.SplitQuadraticPinching.splitPinching_eq_top_of_isUnit
#print axioms RelativeConicArcs.InvolutiveOddUnit.existsUnique_invariant_add_mul_invariant
#print axioms RelativeConicArcs.InvolutiveOddUnit.square_invariant_of_antiInvariant
#print axioms RelativeConicArcs.GoldenQuadraticCharacters.exists_goldenRoot_iff_exists_sqrtFive
#print axioms RelativeConicArcs.GoldenQuadraticCharacters.exchanger_eq_reflection_mul
#print axioms RelativeConicArcs.GoldenQuadraticCharacters.exchanger_reflection_factorization
#print axioms RelativeConicArcs.GoldenQuadraticCharacters.two_not_square_zmod11
#print axioms RelativeConicArcs.TightFrameConference.conference_sq_of_gram
#print axioms RelativeConicArcs.SignedEquiangularGram.golden_det_positive
#print axioms RelativeConicArcs.SignedEquiangularGram.golden_det_negative
#print axioms RelativeConicArcs.ClebschGoldenConference.conferenceMatrixOver_sq
#print axioms RelativeConicArcs.ClebschGoldenConference.triangleCubic_switch
#print axioms RelativeConicArcs.MarkedClebschBridge.sheetTriangleCubic_not
#print axioms RelativeConicArcs.MarkedClebschBridge.sheetPairSum_not
#print axioms RelativeConicArcs.MarkedClebschBridge.chartLift_smul
#print axioms RelativeConicArcs.KneserPairEigenspace.existsUnique_pairSum_of_petersenEigen
#print axioms RelativeConicArcs.KneserPairEigenspace.finrank_petersenNegTwoEigenspace
#print axioms RelativeConicArcs.PetersenHarmonicKernel.gramOperator_pairSum
#print axioms RelativeConicArcs.PetersenHarmonicKernel.pairSum_norm_sq_general
#print axioms RelativeConicArcs.PetersenHarmonicKernel.pairSum_norm_sq
#print axioms RelativeConicArcs.ClebschInvariantCubic.exists_smul_markedFixedVector
#print axioms RelativeConicArcs.ClebschInvariantCubic.eq_gauntCoefficient_mul_sigmaThree
#print axioms RelativeConicArcs.ClebschInvariantCubic.gauntCoefficient_factorization
#print axioms RelativeConicArcs.AlignedTwoGraph.aligned_complement_iff
#print axioms RelativeConicArcs.AlignedTwoGraph.triangle_eq_rooted_xor
#print axioms RelativeConicArcs.AlignedTwoGraph.alignedAnchor_of_ramseyTriple
#print axioms RelativeConicArcs.AlignedTwoGraph.exists_monochromatic_triple
#print axioms RelativeConicArcs.AlignedTwoGraph.no_monochromatic_triple_five
#print axioms RelativeConicArcs.AlignedTwoGraph.exists_alignedAnchor
#print axioms RelativeConicArcs.AlignedTwoGraph.anchorSignature_eq_false_iff_balanced
#print axioms RelativeConicArcs.AlignedTwoGraph.pairSignature_classification
#print axioms RelativeConicArcs.AlignedTwoGraph.threePairOutcomes_eliminate_swaps
#print axioms RelativeConicArcs.AlignedTwoGraph.normalizedSevenSignature_injective
#print axioms RelativeConicArcs.AlignedTwoGraph.global_agreement_of_common_seven_restrictions
#print axioms RelativeConicArcs.AlignedTwoGraph.calibratedTriangle_forces_no_complement
#print axioms RelativeConicArcs.AlignedTwoGraph.signing_eq_up_to_switching_and_negation
#print axioms RelativeConicArcs.AlignedTwoGraph.det_fourSigningMatrix_eq_three_sub_two_cycleSum
#print axioms RelativeConicArcs.AlignedTwoGraph.selectedQueryCount_eq
#print axioms RelativeConicArcs.AlignedTwoGraph.sixPointAnchor_testCount
#print axioms RelativeConicArcs.AlignedTwoGraph.aligned_xorBit_iff
#print axioms RelativeConicArcs.AlignedTwoGraph.normalizedAnchor_of_aligned
#print axioms RelativeConicArcs.AlignedTwoGraph.sevenPoint_agreement
#print axioms RelativeConicArcs.AlignedTwoGraph.exists_complementBit_on_seven
#print axioms RelativeConicArcs.AlignedTwoGraph.exists_complementBit_of_alignedFamily_eq
#print axioms RelativeConicArcs.AlignedTwoGraph.card_selectedQueryFamily
#print axioms RelativeConicArcs.AlignedTwoGraph.exists_distinct_alignedAnchor
#print axioms RelativeConicArcs.AlignedTwoGraph.exists_complementBit_on_seven_of_anchor
#print axioms RelativeConicArcs.AlignedTwoGraph.exists_complementBit_of_selectedQuery_eq
#print axioms RelativeConicArcs.AlignedTwoGraph.exists_complementBit_of_selectedQueryFamily_eq
#print axioms RelativeConicArcs.AlignedTwoGraph.seidelTriangleBit_eq_decide
#print axioms RelativeConicArcs.AlignedTwoGraph.aligned_iff_triangleSign_eq
#print axioms RelativeConicArcs.AlignedTwoGraph.det_submatrix_eq_neg_three_iff_aligned
#print axioms RelativeConicArcs.AlignedTwoGraph.det_submatrix_eq_neg_three_or_five
#print axioms RelativeConicArcs.AlignedTwoGraph.exists_switching_of_det_family_eq
#print axioms RelativeConicArcs.ClebschPassagesCorrespondence.chartBranch_square
#print axioms RelativeConicArcs.ClebschPassagesCorrespondence.chartConductor_eq_branchIdeal
#print axioms RelativeConicArcs.ClebschPassagesCorrespondence.goldenRoot_structural_package
#print axioms RelativeConicArcs.ClebschPassagesCorrespondence.petersenPullback_scalar
#print axioms RelativeConicArcs.ClebschPassagesCorrespondence.normalizedMarked_chart_value
#print axioms RelativeConicArcs.ClebschPassagesCorrespondence.markedValue_determines_gauntCoefficient
#print axioms RelativeConicArcs.ClebschPassagesCorrespondence.gauntCoefficient_has_two_structural_factors
#print axioms RelativeConicArcs.SphereIntegralMoments.normalizedSphereIntegral_eq_normalizedMean_even
#print axioms RelativeConicArcs.TraceSplitQuadraticAlgebra.splitComparison_surjective
#print axioms RelativeConicArcs.ClebschSteinChart.Data.branchCoefficient_eq_root_sq
#print axioms RelativeConicArcs.GoldenResidueAlgebra.relation_irreducible
#print axioms RelativeConicArcs.GoldenResidueAlgebra.deck_sqrtFive
#print axioms RelativeConicArcs.ClebschGoldenSteinChart.canonicalData_root
#print axioms RelativeConicArcs.ClebschGoldenSteinChart.deck_canonicalData_root
#print axioms RelativeConicArcs.SpinorSquareClass.exchanger_spinorClass
#print axioms RelativeConicArcs.NormalizedMarkedIncidence.oddValue_deck
#print axioms RelativeConicArcs.NormalizedMarkedIncidence.conference_deck
#print axioms RelativeConicArcs.NormalizedMarkedIncidence.pairCoefficients_deck
#print axioms RelativeConicArcs.NormalizedMarkedIncidence.chartLift_deck
