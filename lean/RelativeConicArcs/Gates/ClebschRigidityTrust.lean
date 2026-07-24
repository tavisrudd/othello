import RelativeConicArcs.Q11A5PointOrbits
import RelativeConicArcs.Q11Coding
import RelativeConicArcs.Q11DecodingSynthesis
import RelativeConicArcs.Q11DyeConsequences
import RelativeConicArcs.ClebschChordDefect
import RelativeConicArcs.Q9Sylvester
import RelativeConicArcs.SmallKGeometricBridge

/-!
# Trust gate for deep-hole rigidity of the Clebsch hexagon code

This import-only module is the formal verification surface for the rigidity,
decoding, chord-defect, field-uniqueness, and small-arc classification results
used by the focused Clebsch hexagon paper.

The coordinate modules check the displayed finite configuration and decoder
tables by kernel reduction.  The rigidity conclusion additionally depends on
the ten-point Brianchon bound and equality classification in R. H. Dye,
“Hexagons, conics, \(A_5\) and \(\mathrm{PSL}_2(K)\),” *Journal of the
London Mathematical Society* (2) 44 (1991), Theorems 1 and 3, pages 275--278,
doi:10.1112/jlms/s2-44.2.270.  The small-arc bridge reduces the four-, five-,
and seven-arc cases to exact secant moments; separate executable certificates
discharge the remaining finite geometric exclusions.
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
