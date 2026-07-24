import RelativeConicArcs.ClebschTorsorRosetta

/-!
# Import gate for the certified Clebsch torsor dictionaries

This gate exposes the free-`C₂` API, actual split-root torsors at seven and eleven,
the certified fixed-child quotient interface, the concrete three-character certificate
interface, the inert geometric-orbit control, the q=11 outer-readout certificate
interface, the current finite row/column no-inner boundary, and the degree-two
characteristic-zero golden reduction interface.

The semantic fixed-child, character, design, Fourier, Hadamard, and descent
identifications are explicit theorem inputs.  They are not manufactured by identifying
fresh copies of `Fin 2`.  The forced-outer terminal imports the independently compiled
native checks of the degree-twelve closure and retains their declaration-local
native-decision axioms.
-/

#print axioms RelativeConicArcs.ClebschTorsorRosetta.no_invariant_point
#print axioms RelativeConicArcs.ClebschTorsorRosetta.point_or_swapped_point
#print axioms RelativeConicArcs.ClebschTorsorRosetta.splitRoot_values
#print axioms RelativeConicArcs.ClebschTorsorRosetta.pairedParentSwap_exchanges_sheets
#print axioms RelativeConicArcs.ClebschTorsorRosetta.fixedChildQuotient_is_t11
#print axioms RelativeConicArcs.ClebschTorsorRosetta.one_sign_character_three_readouts
#print axioms RelativeConicArcs.ClebschTorsorRosetta.rankThree_split_inert_orientation
#print axioms RelativeConicArcs.ClebschTorsorRosetta.q11_outer_readouts_agree
#print axioms RelativeConicArcs.ClebschTorsorRosetta.q11_hadamard_hinge_is_forced_outer
#print axioms RelativeConicArcs.ClebschTorsorRosetta.golden_characteristic_zero_reduction_dictionary
#print axioms RelativeConicArcs.ClebschTorsorRosetta.torsor_rosetta_closing_theorem
