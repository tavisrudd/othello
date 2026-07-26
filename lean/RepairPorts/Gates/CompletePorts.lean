import RepairPorts.MDSReconstruction

/-!
# Complete bounded repair-port reconstruction gate

This import-only module exposes the paper-facing coefficient-port object, intrinsic reconstruction
radius, standard-code duality bridge, and the MDS minimum-port reconstruction theorem.  All
headline declarations are proved by finite linear algebra; no executable certificate or imported
mathematical axiom occurs in their dependency closure.
-/

#print axioms FiniteGeom.dualCode_dualCode
#print axioms FiniteGeom.dualCode_injective
#print axioms RepairPorts.reconstructedCode_eq
#print axioms RepairPorts.PointedCoefficientPortIso.reconstructsAt_iff
#print axioms RepairPorts.PointedCoefficientPortIso.reconstructionRadius_eq
#print axioms RepairPorts.HasMDSDualParameters.exists_normalized_word
#print axioms RepairPorts.HasMDSDualParameters.repairHypergraph_eq_powersetCard
#print axioms RepairPorts.HasMDSDualParameters.reconstructsAt
#print axioms RepairPorts.HasMDSDualParameters.reconstructsAt_iff
#print axioms RepairPorts.HasMDSDualParameters.reconstructionRadius_eq

