import RelativeConicArcs.Q11A5PointOrbits
import RelativeConicArcs.Q11Coding
import RelativeConicArcs.Q11DecodingSynthesis
import RelativeConicArcs.Q11DyeConsequences
import RelativeConicArcs.Q11RigiditySpine
import RelativeConicArcs.Q11CodeRigidityBridge
import RelativeConicArcs.ClebschChordDefect
import RelativeConicArcs.Q9Sylvester
import RelativeConicArcs.SmallKGeometricBridge
import RelativeConicArcs.PaperIOrientationSpine

/-!
# Trust gate for deep-hole rigidity of the Clebsch hexagon code

This import-only module is the formal verification surface for the rigidity,
decoding, chord-defect, field-uniqueness, small-arc classification, and
support-cubic orientation results used by the focused Clebsch hexagon paper.

The coordinate modules check the displayed finite configuration and decoder
tables by kernel reduction.  The rigidity conclusion additionally depends on
the ten-point Brianchon bound and equality classification in R. H. Dye,
“Hexagons, conics, \(A_5\) and \(\mathrm{PSL}_2(K)\),” *Journal of the
London Mathematical Society* (2) 44 (1991), Theorems 1 and 3, pages 275--278,
doi:10.1112/jlms/s2-44.2.270.  The small-arc bridge reduces the four-, five-,
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

-- The explicit order-sixty action and its point orbits.
#print axioms RelativeConicArcs.Examples.Q11A5PointOrbits.point_orbit_partition
#print axioms RelativeConicArcs.Examples.Q11A5PointOrbits.unique_six_orbit
#print axioms RelativeConicArcs.Examples.Q11A5PointOrbits.unique_twelve_orbit
#print axioms RelativeConicArcs.Examples.Q11A5PointOrbits.brianchon_points_one_orbit

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

-- The symmetry-free rigidity implication and its exact classical seam.
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
#print axioms RelativeConicArcs.PaperIOrientationSymmetry.mem_supportCubicProjectiveStabilizer_iff_cubicLine
#print axioms RelativeConicArcs.PaperIOrientationSymmetry.supportCubic_projectiveStabilizer_equiv_S5
#print axioms RelativeConicArcs.PaperIOrientationSymmetry.mem_orientedSupportCubicStabilizer_iff
#print axioms RelativeConicArcs.PaperIOrientationSymmetry.orientedSupportCubic_stabilizer_equiv_A5
#print axioms RelativeConicArcs.PaperIOrientationSymmetry.orientedSupportCubic_index_two

-- The antipodal cover and signed golden orbital.
#print axioms RelativeConicArcs.PaperIOrientationCover.antipodalQuotient_fiber_card_two
#print axioms RelativeConicArcs.PaperIOrientationCover.fiveOrbitals_selfPaired
#print axioms RelativeConicArcs.PaperIOrientationCover.fiveOrbital_one_mem_each_other_fiber
#print axioms RelativeConicArcs.PaperIOrientationPentagon.signedOrbitalMatrix_sq
#print axioms RelativeConicArcs.PaperIOrientationPentagon.orbitalDifference_sq_eq_ten_one_sub_deck

-- Switching holonomy and the determinant pencil.
#print axioms RelativeConicArcs.PaperIOrientationHolonomy.supportSign_eq_triangleProduct
#print axioms RelativeConicArcs.PaperIOrientationHolonomy.fourPoint_twoGraph_identity
#print axioms RelativeConicArcs.PaperIOrientationHolonomy.pairBalance_iff_sq_five
#print axioms RelativeConicArcs.PaperIOrientationHolonomy.supportCubic_translation_invariant
#print axioms RelativeConicArcs.PaperIOrientationDeterminant.det_signedOrbital_add_diagonal
#print axioms RelativeConicArcs.PaperIOrientationDeterminant.determinantPencil_oddPart_eq_supportCubic

-- Cross-golden trace duality and the six ordinary nodes.
#print axioms RelativeConicArcs.PaperIOrientationTraceDual.det_crossGoldenBlock_eq_neg_supportCubic
#print axioms RelativeConicArcs.PaperIOrientationNodes.derivative_crossGoldenDeterminantLine_eval
#print axioms RelativeConicArcs.PaperIOrientationNodes.singularPoints_crossGoldenDeterminant_eq_axisClasses
#print axioms RelativeConicArcs.PaperIOrientationNodes.supportCubic_singularLocus_eq_frame
#print axioms RelativeConicArcs.PaperIOrientationNodes.supportCubic_framePoints_ordinaryNodes

-- Rational and integral commutants relative to the classical splitting input.
#print axioms RelativeConicArcs.PaperIOrientationCommutant.oddModule_rationalCommutant_eq_adjoin_B
#print axioms RelativeConicArcs.PaperIOrientationCommutant.adjoinGolden_integralPoints_eq_ZsqrtFive
#print axioms RelativeConicArcs.PaperIOrientationCommutant.oddLattice_integralCommutant_eq_ZsqrtFive
