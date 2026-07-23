import RelativeConicArcs.ClebschInformationLatticeB3
import RelativeConicArcs.ClebschInformationLatticeH3

/-!
# Import-only gate for the two finite information lattices

This gate exports the complete displayed matching and `K`-action checks, the exact identification
of `(sheet, shared-edge counts)` fibres with `K`-orbits, the necessity of the sheet coordinate, and
the strict invariant-function-subalgebra towers of dimensions `1, 2, 6, 14` and `1, 2, 6, 22`.
The twenty-two-point leaf also imports the public six-profile matching-depth terminal without
identifying its coordinate system with the shared-edge profiles checked here.
-/

#print axioms RelativeConicArcs.ClebschInformationLattice.fibreSubalgebra_finrank
#print axioms RelativeConicArcs.ClebschInformationLattice.B3.matchingMate_fixedPointFree_involutive
#print axioms RelativeConicArcs.ClebschInformationLattice.B3.matchingMate_injective
#print axioms RelativeConicArcs.ClebschInformationLattice.B3.kAction_group_laws
#print axioms RelativeConicArcs.ClebschInformationLattice.B3.kAction_injective
#print axioms RelativeConicArcs.ClebschInformationLattice.B3.sameKOrbit_equivalence
#print axioms RelativeConicArcs.ClebschInformationLattice.B3.sameKOrbit_iff_kOrbitLabel_eq
#print axioms RelativeConicArcs.ClebschInformationLattice.B3.intrinsicProfile_eq_iff_sameKOrbit
#print axioms RelativeConicArcs.ClebschInformationLattice.B3.sharedEdgePair_not_complete
#print axioms RelativeConicArcs.ClebschInformationLattice.B3.invariantSubalgebra_inclusions
#print axioms RelativeConicArcs.ClebschInformationLattice.B3.constantInvariant_finrank
#print axioms RelativeConicArcs.ClebschInformationLattice.B3.sheetInvariant_finrank
#print axioms RelativeConicArcs.ClebschInformationLattice.B3.kOrbitInvariant_finrank
#print axioms RelativeConicArcs.ClebschInformationLattice.B3.fullFunctionAlgebra_finrank
#print axioms RelativeConicArcs.ClebschInformationLattice.B3.invariantSubalgebra_strictTower
#print axioms RelativeConicArcs.ClebschInformationLattice.H3.matchingMate_fixedPointFree_involutive
#print axioms RelativeConicArcs.ClebschInformationLattice.H3.matchingMate_injective
#print axioms RelativeConicArcs.ClebschInformationLattice.H3.kAction_group_laws
#print axioms RelativeConicArcs.ClebschInformationLattice.H3.kAction_twoSidedInverse
#print axioms RelativeConicArcs.ClebschInformationLattice.H3.kAction_injective
#print axioms RelativeConicArcs.ClebschInformationLattice.H3.sameKOrbit_equivalence
#print axioms RelativeConicArcs.ClebschInformationLattice.H3.sameKOrbit_iff_kOrbitLabel_eq
#print axioms RelativeConicArcs.ClebschInformationLattice.H3.intrinsicProfile_values
#print axioms RelativeConicArcs.ClebschInformationLattice.H3.intrinsicProfile_eq_iff_sameKOrbit
#print axioms RelativeConicArcs.ClebschInformationLattice.H3.sharedEdgePair_not_complete
#print axioms RelativeConicArcs.ClebschInformationLattice.H3.invariantSubalgebra_inclusions
#print axioms RelativeConicArcs.ClebschInformationLattice.H3.constantInvariant_finrank
#print axioms RelativeConicArcs.ClebschInformationLattice.H3.sheetInvariant_finrank
#print axioms RelativeConicArcs.ClebschInformationLattice.H3.kOrbitInvariant_finrank
#print axioms RelativeConicArcs.ClebschInformationLattice.H3.fullFunctionAlgebra_finrank
#print axioms RelativeConicArcs.ClebschInformationLattice.H3.invariantSubalgebra_strictTower
