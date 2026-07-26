import RelativeConicArcs.CarrierArcBound

/-!
# Square-root carrier cardinality verification boundary

This import-only module checks exact degree growth for finite products, bounded-degree detection by
pairwise relatively prime degree-one divisors, nonsquareness of squarefree nonunits, and the
composition of linewise roots, ambient extension, joint detection, and nonsquareness into a finite
carrier-cardinality bound.

It does not assert the projective incidence hypotheses that produce the line divisors, the
squarefree dual-factor product, or the one-line polynomial correction used to interpolate
compatible roots on a nodal line arrangement.
-/

#print axioms RelativeConicArcs.exists_finset_extension_of_single_correction
#print axioms RelativeConicArcs.totalDegree_fintypeProd_of_ne_zero
#print axioms RelativeConicArcs.totalDegree_fintypeProd_eq_card_of_degree_one
#print axioms RelativeConicArcs.eq_zero_of_pairwise_isRelPrime_dvd_of_totalDegree_lt_card
#print axioms RelativeConicArcs.not_exists_eq_sq_of_squarefree_of_not_isUnit
#print axioms RelativeConicArcs.not_exists_fintypeProd_eq_sq_of_pairwise_isRelPrime_of_squarefree
#print axioms RelativeConicArcs.card_le_of_linewiseSquareRoots_extend_and_jointlyDetect
#print axioms RelativeConicArcs.card_le_of_linewiseSquareRoots_extend_of_lineProductDetection
