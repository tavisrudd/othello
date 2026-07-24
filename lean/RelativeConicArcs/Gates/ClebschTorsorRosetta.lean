import RelativeConicArcs.ClebschTorsorRosetta

/-!
# Import gate for the Clebsch torsor dictionary

This gate exposes the reusable free-`C₂` torsor interface, the fixed-child/sign bridge,
the three equal-kernel character readouts, the bounded rank-three split/inert row, the
q=11 design/Fourier/Hadamard swap dictionary, the exact forced-outer row/column boundary,
and the golden quadratic reduction dictionary.

The small symbolic and finite reduction terminals use kernel proofs.  The forced-outer
terminal imports the independently compiled native checks of the 95,040-element
degree-twelve closure and therefore retains their declaration-local native-decision
axioms.  Geometric and number-field interpretations of the tagged two-point carriers
remain explicit external-certificate inputs.
-/

#print axioms RelativeConicArcs.ClebschTorsorRosetta.no_invariant_point
#print axioms RelativeConicArcs.ClebschTorsorRosetta.point_or_swapped_point
#print axioms RelativeConicArcs.ClebschTorsorRosetta.retag_intertwines_swap
#print axioms RelativeConicArcs.ClebschTorsorRosetta.fixedChildQuotient_is_signTorsor
#print axioms RelativeConicArcs.ClebschTorsorRosetta.three_readout_dictionaries
#print axioms RelativeConicArcs.ClebschTorsorRosetta.one_sign_character_three_readouts
#print axioms RelativeConicArcs.ClebschTorsorRosetta.one_sign_character_with_named_kernel
#print axioms RelativeConicArcs.ClebschTorsorRosetta.rankThree_split_inert_orientation_row
#print axioms RelativeConicArcs.ClebschTorsorRosetta.golden_characteristic_zero_reduction_dictionary
#print axioms RelativeConicArcs.ClebschTorsorRosetta.q11_three_outer_readouts
#print axioms RelativeConicArcs.ClebschTorsorRosetta.q11_hadamard_hinge_is_forced_outer
#print axioms RelativeConicArcs.ClebschTorsorRosetta.torsor_rosetta_closing_theorem
