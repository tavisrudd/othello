import RelativeConicArcs.Q11Coding
import RelativeConicArcs.Q11DecodingSynthesis
import RelativeConicArcs.Q11DyeConsequences
import RelativeConicArcs.Q11RigiditySpine
import RelativeConicArcs.Q11CodeRigidityBridge
import RelativeConicArcs.ClebschChordDefect
import RelativeConicArcs.Q9Sylvester
import RelativeConicArcs.SmallKGeometricBridge
import RelativeConicArcs.SupportOrientationSpine

/-!
# Trust gate for deep-hole rigidity of the Clebsch hexagon code

This import-only module is the formal verification surface for the rigidity,
decoding, chord-defect, field-uniqueness, small-arc classification, and
support-cubic orientation results used by the focused Clebsch hexagon paper.

The coordinate modules check the displayed finite configuration and decoder
tables by kernel reduction.  The order-sixty projective action of the
icosahedral group, its seven point orbits, the dictionary between canonical
point indices and the projective points they denote, and the exhaustive
per-row verification behind them are not checked here: they are the payload of
the separately versioned order-eleven certificate library, whose own
import-only gate checks them and whose published trust fact this repository
consumes by hash, pinned in `lean/trust/certificate-packages.toml`.  The
rigidity conclusion uses the ten-point
Brianchon bound and the equality classification of six-arcs attaining it; both
are kernel-checked theorems of this repository and neither is assumed.  The
same two statements appear as Theorems 1 and 3, pages 275--278 of R. H. Dye,
“Hexagons, conics, \(A_5\) and \(\mathrm{PSL}_2(K)\),” *Journal of the
London Mathematical Society* (2) 44 (1991), doi:10.1112/jlms/s2-44.2.270, which
is cited as the antecedent.  The small-arc bridge reduces the four-, five-,
and seven-arc cases to exact secant moments; separate executable certificates
discharge the finite geometric exclusions not covered by those symbolic
reductions.

The orientation spine constructs the antipodal cover, golden orbital,
switching class, determinant pencil, trace dual, six ordinary nodes, and the
`S₅/A₅` symmetry boundary.  Its final commutant equalities are conditional on
the proposition-valued classical `3+3'` splitting interface printed below;
golden equivariance, the reverse rational containment, and the integral
coefficient test are kernel checked.  No native execution enters these
terminals.
-/

-- The code--arc dictionary and syndrome conic.
#print axioms RelativeConicArcs.Examples.Q11Coding.witness_mds_columns
#print axioms RelativeConicArcs.Examples.Q11Coding.projective_distanceThreeDirections_eq_standardConic
#print axioms RelativeConicArcs.Examples.Q11Coding.witness_code_coveringRadius_three

-- The exact decoder and Brianchon leader supports.
#print axioms RelativeConicArcs.Examples.Q11Coding.totalSyndromeDistance_exact
#print axioms RelativeConicArcs.Examples.Q11Coding.ambiguity_strata_sound
#print axioms RelativeConicArcs.Examples.Q11Coding.ambiguity_strata_counts
#print axioms RelativeConicArcs.Examples.Q11Coding.brianchonDirectionIndices_eq_indexThree
#print axioms RelativeConicArcs.Examples.Q11Coding.brianchon_weightTwo_leaderSupports

-- The symmetry-free rigidity implication and its six-arc concurrence inputs.
#print axioms RelativeConicArcs.ClebschDye.sixArc_uncovered_add_brianchon_card
#print axioms RelativeConicArcs.ClebschDye.sixArc_twelve_le_uncovered_card
#print axioms RelativeConicArcs.ClebschDye.sixArc_cards_of_uncovered_subset_conic
#print axioms RelativeConicArcs.ClebschDye.isClebschHexagon_of_uncovered_subset_conic

-- The causal containing-quadratic rigidity spine and code-language bridge.
#print axioms RelativeConicArcs.OddSixArcPrismExtraction.sixArc_uncoveredOnLine_card_le_order_sub_five
#print axioms RelativeConicArcs.ClebschDye.sixArc_uncovered_card_le_twelve_of_subset_planeQuadraticLocus
#print axioms RelativeConicArcs.ClebschDye.isClebschHexagon_of_uncovered_subset_planeConic
#print axioms RelativeConicArcs.ClebschDye.deepHoleLocus_rigidifies_witnessCode

-- Chord moments and the field-order boundary.
#print axioms RelativeConicArcs.ClebschChordDefect.chordDefect_identity_of_moments
#print axioms RelativeConicArcs.ClebschChordDefect.clebsch_uncovered_formula
#print axioms RelativeConicArcs.ClebschChordDefect.orders_of_clebsch_uncovered_conic_card
#print axioms RelativeConicArcs.Q9Sylvester.distanceTwo_clique_number_five

-- Universal small-arc moment consequences.
#print axioms RelativeConicArcs.SmallKGeometricBridge.fourArc_uncovered_card
#print axioms RelativeConicArcs.SmallKGeometricBridge.fourArc_conic_card_order
#print axioms RelativeConicArcs.SmallKGeometricBridge.fiveArc_not_conic_card
#print axioms RelativeConicArcs.SmallKGeometricBridge.sevenArc_primePower_conic_card_spectra

-- The support-cubic line stabilizer and its oriented index-two subgroup.
#print axioms RelativeConicArcs.SupportOrientationSymmetry.mem_supportCubicProjectiveStabilizer_iff_cubicLine
#print axioms RelativeConicArcs.SupportOrientationSymmetry.supportCubic_projectiveStabilizer_equiv_S5
#print axioms RelativeConicArcs.SupportOrientationSymmetry.mem_orientedSupportCubicStabilizer_iff
#print axioms RelativeConicArcs.SupportOrientationSymmetry.orientedSupportCubic_stabilizer_equiv_A5
#print axioms RelativeConicArcs.SupportOrientationSymmetry.orientedSupportCubic_index_two

-- The antipodal cover and signed golden orbital.
#print axioms RelativeConicArcs.SupportOrientationCover.antipodalQuotient_fiber_card_two
#print axioms RelativeConicArcs.SupportOrientationCover.fiveOrbitals_selfPaired
#print axioms RelativeConicArcs.SupportOrientationCover.fiveOrbital_one_mem_each_other_fiber
#print axioms RelativeConicArcs.SupportOrientationPentagon.signedOrbitalMatrix_sq
#print axioms RelativeConicArcs.SupportOrientationPentagon.orbitalDifference_sq_eq_ten_one_sub_deck

-- Switching holonomy and the determinant pencil.
#print axioms RelativeConicArcs.SupportOrientationHolonomy.supportSign_eq_triangleProduct
#print axioms RelativeConicArcs.SupportOrientationHolonomy.fourPoint_twoGraph_identity
#print axioms RelativeConicArcs.SupportOrientationHolonomy.pairBalance_iff_sq_five
#print axioms RelativeConicArcs.SupportOrientationHolonomy.supportCubic_translation_invariant
#print axioms RelativeConicArcs.SupportOrientationDeterminant.det_signedOrbital_add_diagonal
#print axioms RelativeConicArcs.SupportOrientationDeterminant.determinantPencil_oddPart_eq_supportCubic

-- Cross-golden trace duality and the six ordinary nodes.
#print axioms RelativeConicArcs.SupportOrientationTraceDual.det_crossGoldenBlock_eq_neg_supportCubic
#print axioms RelativeConicArcs.SupportOrientationNodes.derivative_crossGoldenDeterminantLine_eval
#print axioms RelativeConicArcs.SupportOrientationNodes.singularPoints_crossGoldenDeterminant_eq_axisClasses
#print axioms RelativeConicArcs.SupportOrientationNodes.supportCubic_singularLocus_eq_frame
#print axioms RelativeConicArcs.SupportOrientationNodes.supportCubic_framePoints_ordinaryNodes

-- Rational and integral commutants relative to the classical splitting input.
#print axioms RelativeConicArcs.SupportOrientationCommutant.oddModule_rationalCommutant_eq_adjoinGoldenOperator
#print axioms RelativeConicArcs.SupportOrientationCommutant.adjoinGolden_integralPoints_eq_ZsqrtFive
#print axioms RelativeConicArcs.SupportOrientationCommutant.oddLattice_integralCommutant_eq_ZsqrtFive
