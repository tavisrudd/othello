import RelativeConicArcs.ChowRestrictionDescent

/-!
# Polynomial restriction and Frobenius-descent verification boundary

This import-only module checks homogeneous linear substitution, restriction of a finite product of
linear factors, the paired-factor square identity, and descent of extended linewise roots through
a jointly detecting restriction family.

It does not assert the projective incidence hypotheses that produce a factor pairing, an
interpolation theorem for compatible linewise roots, or joint detection for a particular family
of projective lines and a particular degree bound.
-/

#print axioms RelativeConicArcs.planeLineRestriction_X
#print axioms RelativeConicArcs.planeLineRestriction_dualLinearFactorProduct
#print axioms RelativeConicArcs.prod_eq_sq_of_equiv_sum
#print axioms RelativeConicArcs.planeLineRestriction_dualLinearFactorProduct_eq_sq_of_pairing
#print axioms RelativeConicArcs.globalSquareRoot_restricts
#print axioms RelativeConicArcs.exists_globalSquareRoot_of_jointlyDetected_extendedRoots
#print axioms RelativeConicArcs.isInSquareFrobeniusImage_of_jointlyDetected_extendedRoots
