import RelativeConicArcs.ClebschTwoGraph
import RelativeConicArcs.ClebschMiddleExteriorSquare
import RelativeConicArcs.ClebschMiddleExteriorDiagonal
import RelativeConicArcs.ClebschMiddleExteriorSupport
import RelativeConicArcs.ClebschGoldenDescent
import RelativeConicArcs.ClebschOperatorShadows
import RelativeConicArcs.ConferenceCutSpectrum

/-!
# Trust gate for the golden conference and middle-exterior return

This gate imports the formal package for the order-six golden conference
matrix, its triangle cubic and two-graph reconstruction, the fixed
middle-exterior return, and the restriction-of-scalars comparison.
The commutator-Pfaffian bridge identifies the matching expansion of the
fixed conference matrix with four times its triangle cubic.
The three-vertex principal-block identity gives the formal algebraic core of
the order-six balanced exchange-spectrum calculation.  The higher-order
inclusion-rank and Ramsey exclusion remains a human proof.

Symbolic ring arguments prove switching, pair balance, augmentation descent,
two-graph reconstruction, and the generic companion identities.  No compiled
evaluation enters this gate: every terminal printed below depends only on
`propext`, `Classical.choice` and `Quot.sound`.

The explicit integral conference matrix is kernel-checked by three methods.
Its symmetry and its square are `Matrix.ext` followed by `decide` on each of
the thirty-six index pairs; its twenty oriented triangle signs are one
`decide` on the conjunction over the increasing triples; and its translation
invariance is not finite at all, holding for an arbitrary commutative ring,
argument and shift.  The middle-exterior return is decided row by row, with
its diagonal, parity criterion and common-neighbour counts; the conference
intertwining identity is decided over the thirty-six index pairs, and the
degree-ten comparison determinant falls to cofactor expansion.  Middle-degree
Hodge complementation squaring to minus the identity is proved structurally
rather than decided: the matrix carries one nonzero entry per row, so the
product collapses to a single term whose sign is `hodgeSign_mul_complement`.
That sign identity is in turn a parity computation.  The displayed
complementation table is proved to be set complement on the underlying
three-element subsets, and to be characterized by that property; the displayed
sign table is proved to be minus one to the number of inversions of the map
concatenating a triple with its increasing complement.  That map is proved to
be a permutation of the six labels, and minus one to an inversion count is a
permutation sign by the standard inversion formula, but no comparison with a
library permutation-sign function is formalized.  The inversion count is three
less than the sum of the triple's labels, complementary label sums add to
fifteen, and the product of the two signs is therefore `(-1)^17`.

Each link in that chain is itself a kernel decision, over the twenty labels
for set complement, the inversion-count identification, the inversion count
against the label sum, and the complementary label sums; over the four hundred
ordered pairs of labels for distinctness of their subsets; and over the seven
hundred and twenty label-position-pair triples for injectivity of the
concatenation map.  The exhaustive checking that the sign table previously
carried has moved to these statements about the tables rather than
disappeared, but each is verifiable by a reader directly from the displayed
data.  No generated certificate or externally supplied matrix is imported.
-/

#print axioms RelativeConicArcs.ClebschGoldenConference.conferenceMatrix_sq
#print axioms RelativeConicArcs.ClebschGoldenConference.conferenceMatrix_transpose
#print axioms RelativeConicArcs.ClebschGoldenConference.conferenceMatrixOver_sq
#print axioms RelativeConicArcs.ClebschGoldenConference.conference_triangleSigns
#print axioms RelativeConicArcs.ClebschGoldenConference.triangleSign_switch
#print axioms RelativeConicArcs.ClebschGoldenConference.triangleSign_four_point
#print axioms RelativeConicArcs.ClebschGoldenConference.pairTriangleSum_eq_zero
#print axioms RelativeConicArcs.ClebschGoldenConference.conference_triangleCubic_translate

#print axioms RelativeConicArcs.ClebschTwoGraph.switch_eq_reconstructed_triangleSign
#print axioms RelativeConicArcs.ClebschTwoGraph.reconstructed_triangle_root
#print axioms RelativeConicArcs.ClebschTwoGraph.reconstructed_triangle_nonroot

#print axioms RelativeConicArcs.ClebschMiddleExterior.tripleSet_complementIndex
#print axioms RelativeConicArcs.ClebschMiddleExterior.eq_complementIndex_iff
#print axioms RelativeConicArcs.ClebschMiddleExterior.concatenation_bijective
#print axioms RelativeConicArcs.ClebschMiddleExterior.hodgeSign_eq_neg_one_pow_inversions
#print axioms RelativeConicArcs.ClebschMiddleExterior.hodgeSign_mul_complement
#print axioms RelativeConicArcs.ClebschMiddleExterior.hodgeMatrix_sq
#print axioms RelativeConicArcs.ClebschMiddleExterior.hodgeMatrix_complement_entry
#print axioms RelativeConicArcs.ClebschMiddleExterior.middleExterior_eq_hodge_mul
#print axioms RelativeConicArcs.ClebschMiddleExterior.middleExterior_sq
#print axioms RelativeConicArcs.ClebschMiddleExterior.middleExterior_diagonal
#print axioms RelativeConicArcs.ClebschMiddleExterior.middleExterior_mod_two_eq_one_iff
#print axioms RelativeConicArcs.ClebschMiddleExterior.complementIndex_involutive
#print axioms RelativeConicArcs.ClebschMiddleExterior.commonIntersectionOneNeighbors_eq
#print axioms RelativeConicArcs.ClebschMiddleExterior.commonIntersectionOneNeighbors_eq_zero_iff

#print axioms RelativeConicArcs.ClebschGoldenDescent.goldenCompanion_sq
#print axioms RelativeConicArcs.ClebschGoldenDescent.goldenCompanion_mul_descendedCoefficient
#print axioms RelativeConicArcs.ClebschGoldenDescent.conference_mul_degreeTenComparison
#print axioms RelativeConicArcs.ClebschGoldenDescent.degreeTenComparison_det
#print axioms RelativeConicArcs.ClebschGoldenDescent.normalizedReturnScalar

#print axioms RelativeConicArcs.ClebschOperatorShadows.matchingEvaluation_conferenceMatrix_eq_triangleCubic
#print axioms RelativeConicArcs.ClebschOperatorShadows.pfaffianSix_conferenceBracket_eq_four_triangleCubic

#print axioms RelativeConicArcs.ConferenceCutSpectrum.signedTriangle_sq
