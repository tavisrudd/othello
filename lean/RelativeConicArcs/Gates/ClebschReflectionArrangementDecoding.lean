import RelativeConicArcs.ReflectionArrangementDecoding

/-!
# Reflection-arrangement coordinate and decoding bridge — re-export

This import-only gate re-exports the explicit `ZMod 11` and `ZMod 5` coordinate checks for the
fifteen-line and six-line arrangements, the invertible coordinate map and its contragredient action,
the projective distinctness and incidence spectra of both coordinate tables, the two-sided
frame-join/braid-form correspondence, and the affine-ray theorem relating incidence multiplicity
`0,1,2,3,5` to actual nearest-leader count `20,1,2,3,1`.  The point/scalar map is bijective onto all
nonzero syndromes, and the disjoint incidence-one/incidence-five union is exactly the semantic
one-leader stratum.

The imported modules check coordinate tables and arithmetic.  This gate does not itself identify
the tables with abstract Coxeter arrangements or interpret the integer factorizations as
characteristic-polynomial theorems.
-/

#print axioms RelativeConicArcs.Examples.ReflectionArrangements.tau11_relation
#print axioms RelativeConicArcs.Examples.ReflectionArrangements.tau5_relation
#print axioms RelativeConicArcs.Examples.ReflectionArrangements.h3_characteristic_two_boundary
#print axioms RelativeConicArcs.Examples.ReflectionArrangements.h3_fivefold_points_arc
#print axioms RelativeConicArcs.Examples.ReflectionArrangements.h3_joins_are_root_directions
#print axioms RelativeConicArcs.Examples.ReflectionArrangements.h3_join_directions_injective
#print axioms RelativeConicArcs.Examples.ReflectionArrangements.h3_root_directions_injective
#print axioms RelativeConicArcs.Examples.ReflectionArrangements.h3_projectivity_det_ne_zero
#print axioms RelativeConicArcs.Examples.ReflectionArrangements.h3_projectivity_inverse_apply
#print axioms RelativeConicArcs.Examples.ReflectionArrangements.h3_projectivity_apply_inverse
#print axioms RelativeConicArcs.Examples.ReflectionArrangements.h3_dual_projectivity_dot
#print axioms RelativeConicArcs.Examples.ReflectionArrangements.h3_projective_index_bijective
#print axioms RelativeConicArcs.Examples.ReflectionArrangements.h3_multiplicity_eq_normalized_rawPointIndex
#print axioms RelativeConicArcs.Examples.ReflectionArrangements.h3_fivefold_points_exact
#print axioms RelativeConicArcs.Examples.ReflectionArrangements.h3_intersection_spectrum
#print axioms RelativeConicArcs.Examples.ReflectionArrangements.h3_characteristic_five_spectrum
#print axioms RelativeConicArcs.Examples.ReflectionArrangements.a3_frame_joins_are_braid_mirrors
#print axioms RelativeConicArcs.Examples.ReflectionArrangements.a3_join_directions_injective
#print axioms RelativeConicArcs.Examples.ReflectionArrangements.a3_root_directions_injective
#print axioms RelativeConicArcs.Examples.ReflectionArrangements.a3_intersection_spectrum
#print axioms RelativeConicArcs.Examples.ReflectionArrangements.h3_affine_syndrome_bijective
#print axioms RelativeConicArcs.Examples.ReflectionArrangements.h3_affine_syndromes_card
#print axioms RelativeConicArcs.Examples.ReflectionArrangements.h3_affine_syndrome_nearestLeaderCount
#print axioms RelativeConicArcs.Examples.ReflectionArrangements.h3_affine_syndromes_disjoint_of_ne
#print axioms RelativeConicArcs.Examples.ReflectionArrangements.h3_one_leader_syndromes_card
#print axioms RelativeConicArcs.Examples.ReflectionArrangements.h3_one_leader_syndromes_sound
#print axioms RelativeConicArcs.Examples.ReflectionArrangements.h3_one_leader_syndromes_eq_ambiguityOne
#print axioms RelativeConicArcs.Examples.ReflectionArrangements.h3_mobius_sum
#print axioms RelativeConicArcs.Examples.ReflectionArrangements.h3_characteristic_polynomial
#print axioms RelativeConicArcs.Examples.ReflectionArrangements.a3_characteristic_polynomial
#print axioms RelativeConicArcs.Examples.ReflectionArrangements.h3_conic_size_factorization
#print axioms RelativeConicArcs.Examples.ReflectionArrangements.a3_conic_size_factorization
