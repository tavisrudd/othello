import PassantCodeQ13.Gates.Main

/-!
# Axiom audit for the finite q=13 passant-code leaves

The commands print the actual axiom dependencies of every aggregate native terminal under the
pinned Lean toolchain.  Native evaluation is expected to expose declaration-local axioms.
-/

#print axioms PassantCodeQ13.WeightTen.local_partition
#print axioms PassantCodeQ13.WeightTen.all_isolated_profiles_disjoint
#print axioms PassantCodeQ13.WeightTen.all_cycle_profiles_disjoint
#print axioms PassantCodeQ13.WeightTen.cycle_pair_partition
#print axioms PassantCodeQ13.Rank.incidenceRows_rank
#print axioms PassantCodeQ13.AssociationAlgebra.relation_matrix_ranks
#print axioms PassantCodeQ13.AssociationAlgebra.rhoZero_square
#print axioms PassantCodeQ13.AssociationAlgebra.rankThirtySix_squaring_cycle
#print axioms PassantCodeQ13.MinimumWords.orbitS4_size_and_kernel
#print axioms PassantCodeQ13.MinimumWords.orbitS4_rank
#print axioms PassantCodeQ13.MinimumWords.orbitDihedralA_certificate
#print axioms PassantCodeQ13.MinimumWords.orbitDihedralB_certificate
#print axioms PassantCodeQ13.MinimumWords.orbitDihedralC_certificate
#print axioms PassantCodeQ13.MinimumWords.dihedral_orbits_pairwise_disjoint
#print axioms PassantCodeQ13.MinimumWords.minimumSupportCodes_length
#print axioms PassantCodeQ13.MinimumWords.pair_concurrence_recovers_passant_join
#print axioms PassantCodeQ13.MinimumWords.geometric_rows_have_zero_triple_signatures
#print axioms PassantCodeQ13.Gates.Main.weightTenCertificate
#print axioms PassantCodeQ13.Gates.Main.minimumOrbitCertificate
