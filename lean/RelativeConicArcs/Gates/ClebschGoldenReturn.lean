import RelativeConicArcs.ClebschTwoGraph
import RelativeConicArcs.ClebschMiddleExteriorSquare
import RelativeConicArcs.ClebschMiddleExteriorDiagonal
import RelativeConicArcs.ClebschMiddleExteriorSupport
import RelativeConicArcs.ClebschGoldenDescent
import RelativeConicArcs.ClebschOperatorShadows
import RelativeConicArcs.GoldenCommutatorDeterminant
import RelativeConicArcs.ClebschOuterSegreRelations
import RelativeConicArcs.ClebschOuterJoubertFrame
import RelativeConicArcs.ClebschOuterMatchingFrame
import RelativeConicArcs.SegreIgusaPolar
import RelativeConicArcs.CrossGoldenDeterminant
import RelativeConicArcs.ConferenceCutSpectrum
import RelativeConicArcs.ConferenceCutBlocks
import RelativeConicArcs.BalancedExchangeRigidity
import RelativeConicArcs.BalancedExchangeSpectrum
import RelativeConicArcs.BalancedExchangeEigenvalues
import RelativeConicArcs.BalancedExchangeHalfCut

/-!
# Trust gate for the golden conference and middle-exterior return

This gate imports the formal package for the order-six golden conference
matrix, its triangle cubic and two-graph reconstruction, the fixed
middle-exterior return, and the restriction-of-scalars comparison.
The commutator-Pfaffian bridge identifies the matching expansion of the
fixed conference matrix with four times its triangle cubic, and the
determinant of an order-six skew-symmetric matrix with vanishing diagonal is
the square of that Pfaffian, so the determinant of the fixed conference
bracket matrix is sixteen times the square of the triangle cubic.  Both
determinant statements are polynomial identities over an arbitrary commutative
ring.  The six signed translates of the triangle cubic under the reorderings
fixing the first three labels sum to zero and have cubes summing to zero, so
they satisfy the two equations of the Segre cubic threefold.

That map is identified with the coloured-triangle construction.  Renaming the
six labels along the inverse of each reordering carries the fixed conference
matrix to a conference matrix of its own, again symmetric with vanishing
diagonal, unit off-diagonal squares and square `5 • 1`; negating it when the
reordering is odd makes its twenty triangle products the twenty coefficients of
the corresponding translate, and the resulting six sign words are displayed, are
pairwise distinct, and each obeys the four-point two-graph identity.  The same
six words are the complementary triangle colourings of one-factorizations of the
complete graph on the six labels: for a triple and its complement, the three
matchings meeting the triple in an edge also meet the complement in an edge,
which is a bijection between the two triples, and its sign, corrected by the sign
of the listing of the triple before its complement, is the coefficient.  A
one-factorization is formalized as a colour-indexed family of five perfect
matchings, so renaming its five colours gives the same colouring; every such
family agrees with one of six displayed families after a renaming, and the six
give six distinct words, so there are exactly six colourings.  That converse is
decided over the normalized candidates after the colours are listed by the label
they use at a fixed root.

The two further constructions on the Segre cubic are also here.  If one
coordinate of a point of the Segre cubic vanishes then the remaining five
coordinates have vanishing sum and vanishing cube sum; the identification of the
locus those two equations cut out with a cubic surface in a projective
three-space is not formalized.  The centered squares of a point of the Segre
cubic, taken in the denominator-free normalization `6 z² - ∑ z²`, sum to zero
and satisfy the Igusa quartic relation `(∑ V²)² = 4 ∑ V⁴`; this is proved
through the characteristic polynomial of the six coordinates and Newton's
identities in degrees two, three and four rather than by a certificate, and it
reduces to the power-sum identity
`48 p₈ = 12 p₄² - 12 p₂² p₄ + p₂⁴ + 32 p₂ p₆`.  Sixteen times the centered
square of the six outer cubics is the centered family of the six
commutator-bracket determinants.

Over a commutative ring in which two is invertible and which carries an
invertible square root `s` of five, the two golden projectors `(1 ± s⁻¹ C)/2` are
symmetric, sum to the identity and are idempotent, and the commutator of the
diagonal matrix of the coordinates with the conference matrix is `2 s` times the
antisymmetric part of the cross-golden block `P₋ Dₓ P₊`.  Taking determinants of
that order-six identity turns `det = 16 Z²` into `Z² = 500 det (B - Bᵀ)`, and
since `B - Bᵀ` is skew-symmetric with vanishing diagonal its determinant is the
square of its Pfaffian.  The Pfaffian itself is pinned exactly and with no sign
ambiguity: `B - Bᵀ` is `(2 s)⁻¹` times the commutator, an order-six Pfaffian
scales by the cube of a scalar, and the Pfaffian of the commutator is `4 Z`, so
`Z = 10 s Pf (B - Bᵀ)`.  Using the other square root of five negates the
Pfaffian and the factor `10 s` together, so the identity does not depend on that
choice.  No basis is chosen for either spectral space, and since `B` has rank at
most three its own determinant carries no information; the comparison of the
Pfaffian with the determinant of a three-by-three matrix representing the induced
map in a chosen pair of orthonormal frames is not formalized, and an orientation
of the two determinant lines would enter only there.
The three-vertex principal-block identity gives the formal algebraic core of
the order-six balanced exchange-spectrum calculation.  For a cut of arbitrary
size, the cross block of a matrix squaring to a scalar satisfies
`B * Bᵀ = q • 1 - A * A` on the chosen subset, the trace of the square of a
zero-diagonal sign matrix is the number of ordered pairs of distinct indices,
and the three signed Hamilton-cycle products of any four-set sum to `3` or
`-1`.  The fourth trace is sorted by the support of the closed four-walks it
counts: it is `d(d-1) + 12·C(d,3)` plus the four-set weights, each of which is
`24` or `-8`, that is eight times `3` or `-1`.  Equal four-subset sums of those
weights over all balanced halves of a `2d`-element label set with `4 ≤ d` force
the weight to be constant on four-sets, by the one-element swap descent for
inclusion sums rather than by the rank formula for inclusion matrices.  Summing
the support-sorted trace over all labels then pins that common weight: for a
symmetric conference matrix of order `N` the diagonal of `C * C = q • 1` gives `q = N - 1`, and comparing
`N(N-1)²` with `N(N-1) + 12·C(N,3) + C(N,4)·w` forces `(N-3)w = -24`.  With
`w ∈ {24, -8}` only `N = 2` and `N = 6` survive, so for every order `2d` with
`4 ≤ d` the fourth trace of the principal block does depend on the balanced
half.  That counting step replaces the switching normalization and the bound
`R(3,3) = 6` used elsewhere; the Ramsey bound itself is proved independently.
The exchange operator of a balanced cut is here in
characteristic-polynomial rather than eigenvalue form.  Normalize a
symmetric matrix `C` with `C * C = q • 1` by an element `s` with
`s * s = q`, take the sign involution `D` of the cut, and compress
`D (1 - Q)/2 D` to the fixed space of `Q = s⁻¹ • C` along an isometry `U`,
that is, a matrix with `Uᵀ U = 1` and `U Uᵀ = (1 + Q)/2`.  That compression
has the characteristic polynomial and every power trace of `1 - q⁻¹ A²`,
for `A` the principal block on the chosen half.  The proof uses only the
antisymmetry of the commutator `D Q - Q D` and its anticommutation with
`Q`: no eigenvalue, singular value, diagonalization or square-root
operation enters, and the statements hold over any field of
characteristic zero.  The first exchange moment is `d²/q` and the second
is `(d q² - 2 q d(d-1) + d(d-1) + 12·C(d,3) - 8·C(d,4) + 32 c)/q²`, where
`c` counts the aligned four-sets of the half, the four-subsets of
Hamilton-cycle weight `3`.  That count is not the same for every balanced
half once `4 ≤ d`, so the second moment depends on the cut, and with it
every spectrum reading that determines the moment: the characteristic
polynomial, or the eigenvalues with multiplicity.  What the gate states is
the failure at the level of the moment.  The bound `4 ≤ d` is what the swap
descent needs, `4 + d ≤ 2d`; whether a matrix satisfying the hypotheses
exists at a given order is a separate question the gate does not address.
When a half has at most three labels the
characteristic polynomial is computed outright and does not depend on the
half: it is `X - 1` on one label, `(X - 2v)²` with `3 v = 1` on two, and
`(X - 1/5)(X - 4/5)²` at order six, where the product of the three edge
signs of the half enters `A * A = 2 • 1 + τ • A` but cancels from the
characteristic polynomial.  The same fourth-trace count excludes order
four outright: no symmetric matrix with zero diagonal and entries
squaring to one on four labels has a scalar square, because its only
four-set would have to carry closed four-walk weight `-24`.  The
compression theorems above are stated relative to a
supplied isometry onto each spectral space.  Over the real numbers both
isometries exist, so those statements are conditional on nothing: a real
symmetric matrix squaring to `1` has an orthonormal eigenbasis with
eigenvalues `±1`, the eigenvectors of eigenvalue `1` are the columns of
an isometry onto the fixed space, and a vanishing trace — which a
vanishing diagonal supplies — makes the two eigenspaces equally large, so
each can be indexed by a half of the cut.  Over the reals the
characteristic polynomial is also read as a spectrum: that of
`1 - q⁻¹ A²` is `∏ (X - (1 - αᵢ²/q))` over the eigenvalues `αᵢ` of the
principal block, which is the manuscript's spectral formula.

The cut statements above are about a matrix already presented in block
form on a sum type, while the cut-dependence statement is about a matrix
`C` on a single label set and a subset `Y` of it.  Relabelling `C` along
`Equiv.sumCompl (· ∈ Y)` reconciles the two: it lists the labels of `Y`
first, its upper-left block is the submatrix of `C` on `Y`, and symmetry
of `C` makes its lower-left block the transpose of the cross block, so
the square `q • 1` is carried across unchanged.  Two invariants of that
principal block are read on `Y` itself.  Its fourth trace is the fourfold
sum over `Y` of the closed four-walk weights, which is the quantity the
counting argument above shows to depend on the half.  Its aligned
four-sets correspond to the aligned four-subsets of `Y` under the
inclusion of `Y` into the label set, since relabelling along an injection
preserves the closed four-walk weight of a four-set; hence the two counts
agree.  Consequently the second exchange moment of the cut at a half is
the displayed expression in the number of aligned four-subsets of that
half, and for a real symmetric matrix with zero diagonal and entries
squaring to one on `2d` labels with `4 ≤ d` whose square is `q • 1`, no
real number is that second moment for every balanced half.  In the same
language, the exchange spectrum at a half is `∏ (X - (1 - αᵢ²/q))` over
the eigenvalues of the submatrix on that half, and at order six it is
`(X - 1/5)(X - 4/5)²` for every three-element subset, so the exceptional
order and the failure above are statements of the same kind.

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
#print axioms RelativeConicArcs.GoldenCommutatorDeterminant.det_eq_pfaffianSix_sq
#print axioms RelativeConicArcs.GoldenCommutatorDeterminant.det_conferenceBracket_eq_sixteen_triangleCubic_sq

#print axioms RelativeConicArcs.ClebschOuterSegreRelations.sum_outerCubic
#print axioms RelativeConicArcs.ClebschOuterSegreRelations.sum_outerCubic_cube

#print axioms RelativeConicArcs.ClebschOuterJoubertFrame.outerConference_transpose
#print axioms RelativeConicArcs.ClebschOuterJoubertFrame.outerConference_apply_self
#print axioms RelativeConicArcs.ClebschOuterJoubertFrame.outerConference_apply_sq
#print axioms RelativeConicArcs.ClebschOuterJoubertFrame.outerConference_sq
#print axioms RelativeConicArcs.ClebschOuterJoubertFrame.tripleLabel_strictMono
#print axioms RelativeConicArcs.ClebschOuterJoubertFrame.tripleLabel_injective
#print axioms RelativeConicArcs.ClebschOuterJoubertFrame.outerColouring_sq
#print axioms RelativeConicArcs.ClebschOuterJoubertFrame.outerColouring_eq_smul_triangleSign
#print axioms RelativeConicArcs.ClebschOuterJoubertFrame.outerColouring_eq_triangleSign_outerConference
#print axioms RelativeConicArcs.ClebschOuterJoubertFrame.outerColouring_injective
#print axioms RelativeConicArcs.ClebschOuterJoubertFrame.outerColouring_four_point
#print axioms RelativeConicArcs.ClebschOuterJoubertFrame.outerCubic_eq_colouringCubic

#print axioms RelativeConicArcs.ClebschOuterMatchingFrame.existsUnique_of_isOneFactorization
#print axioms RelativeConicArcs.ClebschOuterMatchingFrame.complementLabel_disjoint
#print axioms RelativeConicArcs.ClebschOuterMatchingFrame.isOneFactorization_oneFactorization
#print axioms RelativeConicArcs.ClebschOuterMatchingFrame.matchingColouring_oneFactorization
#print axioms RelativeConicArcs.ClebschOuterMatchingFrame.oneFactorization_injective
#print axioms RelativeConicArcs.ClebschOuterMatchingFrame.exists_eq_matchingThrough
#print axioms RelativeConicArcs.ClebschOuterMatchingFrame.matchingColouring_comp
#print axioms RelativeConicArcs.ClebschOuterMatchingFrame.exists_perm_eq_oneFactorization
#print axioms RelativeConicArcs.ClebschOuterMatchingFrame.existsUnique_outerColouring_of_isOneFactorization
#print axioms RelativeConicArcs.ClebschOuterMatchingFrame.outerCubic_eq_matchingColouringCubic

#print axioms RelativeConicArcs.SegreIgusaPolar.powerSum_eight_of_segre
#print axioms RelativeConicArcs.SegreIgusaPolar.sum_centeredSquare
#print axioms RelativeConicArcs.SegreIgusaPolar.igusa_relation_of_segre
#print axioms RelativeConicArcs.SegreIgusaPolar.sum_erase_eq_zero_of_apply_eq_zero
#print axioms RelativeConicArcs.SegreIgusaPolar.sum_pow_three_erase_eq_zero_of_apply_eq_zero
#print axioms RelativeConicArcs.SegreIgusaPolar.igusa_relation_outerCubic
#print axioms RelativeConicArcs.SegreIgusaPolar.outerCubic_diagonal_section
#print axioms RelativeConicArcs.SegreIgusaPolar.det_bracket_outerReindex
#print axioms RelativeConicArcs.SegreIgusaPolar.sixteen_mul_centeredSquare_outerCubic

#print axioms RelativeConicArcs.CrossGoldenDeterminant.goldenProjector_transpose
#print axioms RelativeConicArcs.CrossGoldenDeterminant.goldenProjector_add_neg
#print axioms RelativeConicArcs.CrossGoldenDeterminant.goldenProjector_mul_self
#print axioms RelativeConicArcs.CrossGoldenDeterminant.bracketMatrix_eq_smul_sub_transpose
#print axioms RelativeConicArcs.CrossGoldenDeterminant.triangleCubic_sq_eq_five_hundred_mul_det
#print axioms RelativeConicArcs.CrossGoldenDeterminant.triangleCubic_sq_eq_pfaffian_sq
#print axioms RelativeConicArcs.CrossGoldenDeterminant.pfaffianSix_smul
#print axioms RelativeConicArcs.CrossGoldenDeterminant.crossGoldenBlock_sub_transpose_eq
#print axioms RelativeConicArcs.CrossGoldenDeterminant.triangleCubic_eq_ten_mul_pfaffian

#print axioms RelativeConicArcs.ConferenceCutSpectrum.signedTriangle_sq

#print axioms RelativeConicArcs.ConferenceCutBlocks.mul_transpose_eq_of_sq_smul
#print axioms RelativeConicArcs.ConferenceCutBlocks.trace_mul_self
#print axioms RelativeConicArcs.ConferenceCutBlocks.fourSetWeight_eq_three_or_neg_one
#print axioms RelativeConicArcs.ConferenceCutBlocks.sum_closedFourWalkWeight_eq_add_sum_powersetCard
#print axioms RelativeConicArcs.ConferenceCutBlocks.trace_pow_four
#print axioms RelativeConicArcs.ConferenceCutBlocks.closedFourWalkSum_labelled
#print axioms RelativeConicArcs.ConferenceCutBlocks.closedFourWalkSum_eq_eight_mul_fourSetWeight
#print axioms RelativeConicArcs.ConferenceCutBlocks.closedFourWalkSum_eq_twentyFour_or_neg_eight
#print axioms RelativeConicArcs.ConferenceCutBlocks.closedFourWalkSum_eq_of_sum_eq

#print axioms RelativeConicArcs.SubsetInclusionSums.sum_powersetCard_insert
#print axioms RelativeConicArcs.SubsetInclusionSums.eq_of_swap_invariant
#print axioms RelativeConicArcs.SubsetInclusionSums.eq_zero_of_sum_powersetCard_eq_zero
#print axioms RelativeConicArcs.SubsetInclusionSums.eq_of_sum_powersetCard_eq

#print axioms RelativeConicArcs.BalancedExchangeRigidity.not_forall_sum_closedFourWalkWeight_eq

#print axioms RelativeConicArcs.BalancedExchangeSpectrum.exchangeCompression_eq
#print axioms RelativeConicArcs.BalancedExchangeSpectrum.trace_exchangeCompression_pow
#print axioms RelativeConicArcs.BalancedExchangeSpectrum.charpoly_compression_eq
#print axioms RelativeConicArcs.BalancedExchangeSpectrum.charpoly_compression_mul
#print axioms RelativeConicArcs.BalancedExchangeSpectrum.exchangeOperator_cut
#print axioms RelativeConicArcs.BalancedExchangeSpectrum.charpoly_exchangeCompression_cut
#print axioms RelativeConicArcs.BalancedExchangeSpectrum.trace_exchangeCompression_pow_cut
#print axioms RelativeConicArcs.BalancedExchangeSpectrum.trace_exchangeCompression_cut
#print axioms RelativeConicArcs.BalancedExchangeSpectrum.sum_closedFourWalkSum_eq_alignedFourSetCount
#print axioms RelativeConicArcs.BalancedExchangeSpectrum.trace_pow_two_exchangeCompression_cut
#print axioms RelativeConicArcs.BalancedExchangeSpectrum.not_forall_alignedFourSetCount_eq
#print axioms RelativeConicArcs.BalancedExchangeSpectrum.charpoly_one_sub_smul_mul_self_of_card_one
#print axioms RelativeConicArcs.BalancedExchangeSpectrum.charpoly_one_sub_smul_mul_self_of_card_two
#print axioms RelativeConicArcs.BalancedExchangeSpectrum.charpoly_one_sub_smul_mul_self_of_card_three
#print axioms RelativeConicArcs.BalancedExchangeSpectrum.charpoly_exchangeCompression_cut_card_three
#print axioms RelativeConicArcs.BalancedExchangeSpectrum.ne_smul_one_of_card_four

#print axioms RelativeConicArcs.BalancedExchangeEigenvalues.charpoly_one_sub_smul_mul_self_eq_prod
#print axioms RelativeConicArcs.BalancedExchangeEigenvalues.exists_isometry_fixedProjection
#print axioms RelativeConicArcs.BalancedExchangeEigenvalues.exists_isometry_antifixedProjection
#print axioms RelativeConicArcs.BalancedExchangeEigenvalues.exists_isometries_cut
#print axioms RelativeConicArcs.BalancedExchangeEigenvalues.exists_isometry_charpoly_exchangeCompression_cut
#print axioms RelativeConicArcs.BalancedExchangeEigenvalues.exists_isometry_trace_pow_two_exchangeCompression_cut
#print axioms RelativeConicArcs.BalancedExchangeEigenvalues.exists_isometry_charpoly_exchangeCompression_cut_card_three

#print axioms RelativeConicArcs.BalancedExchangeHalfCut.cutMatrix_eq_submatrix
#print axioms RelativeConicArcs.BalancedExchangeHalfCut.cutMatrix_mul_self
#print axioms RelativeConicArcs.BalancedExchangeHalfCut.trace_pow_four_principalBlock
#print axioms RelativeConicArcs.BalancedExchangeHalfCut.closedFourWalkSum_map
#print axioms RelativeConicArcs.BalancedExchangeHalfCut.alignedFourSetCount_principalBlock
#print axioms RelativeConicArcs.BalancedExchangeHalfCut.exists_isometry_trace_pow_two_exchangeCompression_half
#print axioms RelativeConicArcs.BalancedExchangeHalfCut.exists_isometry_charpoly_exchangeCompression_half
#print axioms RelativeConicArcs.BalancedExchangeHalfCut.exists_isometry_charpoly_exchangeCompression_half_card_three
#print axioms RelativeConicArcs.BalancedExchangeHalfCut.not_forall_trace_pow_two_exchangeCompression_half_eq
