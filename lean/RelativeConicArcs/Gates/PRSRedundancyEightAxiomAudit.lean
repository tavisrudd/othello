import RelativeConicArcs.Gates.PRSRedundancyEight

/-!
# Axiom audit for projective Reed--Solomon redundancy eight

The commands below print the dependencies of the public contraction, arithmetic, synthesis,
cardinality, orbit, cocycle, and characteristic-seven boundary terminals.  The imported module has
no project-local axioms, generated evaluator, external oracle, or finite certificate; its geometric
and coding trust boundaries are theorem hypotheses and structure fields.
-/

#print axioms RelativeConicArcs.PRSRedundancyEight.threeMarkerContraction_map
#print axioms RelativeConicArcs.PRSRedundancyEight.threeMarker_genusOne_hasseWeil_bound
#print axioms RelativeConicArcs.PRSRedundancyEight.redundancyEightHighFieldSynthesis
#print axioms RelativeConicArcs.PRSRedundancyEight.PersistentFamilyData.classified_card
#print axioms RelativeConicArcs.PRSRedundancyEight.OrbitArithmetic.orbit_count_pairs
#print axioms RelativeConicArcs.PRSRedundancyEight.OrbitArithmetic.seventhPower_sigmaInversionOrbitCount
#print axioms RelativeConicArcs.PRSRedundancyEight.tangentTranslateSeven_of_cast_eq_zero
#print axioms RelativeConicArcs.PRSRedundancyEight.tangentTranslateSeven_surjective
#print axioms RelativeConicArcs.PRSRedundancyEight.CharacteristicSevenCarrierBoundary.proved_boundary
