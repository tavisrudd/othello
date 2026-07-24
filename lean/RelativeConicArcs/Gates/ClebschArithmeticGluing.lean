import RelativeConicArcs.ClebschArithmeticGluing

/-!
# Import gate for rank-three arithmetic gluing

This gate exposes the literal `A3/B3/H3` reductions at `q = 5,7,11`, their matching
sheet actions, polynomial splitting checks, Coxeter-square orbits, exact small-field projective
stabilizer/orbit theorems, literal checks on the larger golden certificate tables, and the
bounded split/fused trichotomy.

The finite theorems use kernel reduction through `decide`.  Abstract octahedral,
icosahedral, tetrahedral, dihedral, orthogonal, spinor-norm, and number-field terminology
is not asserted by this gate.  Paper I trust-manifest claims
`thm-headline-gluing-clause-1`, `thm-headline-gluing-clause-2`, and
`thm-headline-gluing-clause-3` record the corresponding cited semantic inputs.  The imported
replacement-spine character theorem is reused only as an abstract equal-kernel interface.  No
all-prime statement is asserted.
-/

#print axioms RelativeConicArcs.ClebschArithmeticGluing.vertexReductions_are_bijective
#print axioms RelativeConicArcs.ClebschArithmeticGluing.a3_two_has_no_root
#print axioms RelativeConicArcs.ClebschArithmeticGluing.b3_two_roots
#print axioms RelativeConicArcs.ClebschArithmeticGluing.h3_five_roots
#print axioms RelativeConicArcs.ClebschArithmeticGluing.h3_golden_roots
#print axioms RelativeConicArcs.ClebschArithmeticGluing.reduced_vertex_polynomials_split
#print axioms RelativeConicArcs.ClebschArithmeticGluing.matchingEdgeLists_encode_frozen_matchings
#print axioms RelativeConicArcs.ClebschArithmeticGluing.frozen_matching_mates_are_fixedPointFree_involutions
#print axioms RelativeConicArcs.ClebschArithmeticGluing.a3_matching_is_fused
#print axioms RelativeConicArcs.ClebschArithmeticGluing.b3_reductions_induce_split_matchings
#print axioms RelativeConicArcs.ClebschArithmeticGluing.silverTransporter_swaps_matchings
#print axioms RelativeConicArcs.ClebschArithmeticGluing.goldenTransporter_swaps_matchings
#print axioms RelativeConicArcs.ClebschArithmeticGluing.coxeterSquare_orbits
#print axioms RelativeConicArcs.ClebschArithmeticGluing.coxeterSquare_orders_and_square_determinants
#print axioms RelativeConicArcs.ClebschArithmeticGluing.projective_group_orders
#print axioms RelativeConicArcs.ClebschArithmeticGluing.a3_fused_stabilizer_and_orbit
#print axioms RelativeConicArcs.ClebschArithmeticGluing.b3_split_stabilizers_and_orbits
#print axioms RelativeConicArcs.ClebschArithmeticGluing.h3_certificate_literal_checks
#print axioms RelativeConicArcs.ClebschArithmeticGluing.h3_stabilizer_generation_word_data
#print axioms RelativeConicArcs.ClebschArithmeticGluing.transporters_are_outer
#print axioms RelativeConicArcs.ClebschArithmeticGluing.rankThree_split_fused_trichotomy
#print axioms RelativeConicArcs.ClebschArithmeticGluing.stabilizer_eq_character_kernel
#print axioms RelativeConicArcs.ClebschArithmeticGluing.sheetCharacter_eq_of_kernel_eq
