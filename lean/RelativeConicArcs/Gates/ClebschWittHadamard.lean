import RelativeConicArcs.ClebschWittHadamardSequences
import RelativeConicArcs.ClebschWittHadamardCode
import RelativeConicArcs.ClebschWittHadamardGeometry
import RelativeConicArcs.ClebschWittHadamardActions
import RelativeConicArcs.ClebschWittHadamardClosures

/-!
# Import gate for the ternary Witt--Hadamard finite checks

This gate exposes the cyclic quadratic-residue incidence design, the exact ternary code weight
distribution, the Steiner `5-(12,6,1)` minimum-support design, the twelve full-support projective
points, their complete 66-secant shadow, the order-twelve Hadamard identity, and literal
degree-twelve generator actions.

No classical Mathieu-group, projective-linear-group, nonsplit-cover, or abstract outer-group
identification is asserted.  The gate does expose the literal finite normalizer and non-inner
witness checks; classical names require a separate cited-input boundary unless exact
finite-group identification terminals are added.

The independently compiled exhaustive certificate leaves use `native_decide`; this toolchain
prints a declaration-local `_native.native_decide.ax_1_1` dependency for each such leaf.  The small
parent-orbit discriminator uses kernel `decide` and has only `propext`, `Classical.choice`, and
`Quot.sound`.  No certificate JSON, GAP result, or classical group name is imported as an axiom.
-/

#print axioms RelativeConicArcs.ClebschWittHadamard.residueBlocks_two_design
#print axioms RelativeConicArcs.ClebschWittHadamard.residueSign_periodic_correlation
#print axioms RelativeConicArcs.ClebschWittHadamard.barker_aperiodic_correlations
#print axioms RelativeConicArcs.ClebschWittHadamard.code_card
#print axioms RelativeConicArcs.ClebschWittHadamard.code_weight_distribution
#print axioms RelativeConicArcs.ClebschWittHadamard.punctured_weight_distribution
#print axioms RelativeConicArcs.ClebschWittHadamard.punctured_perfect_parameter_identity
#print axioms RelativeConicArcs.ClebschWittHadamard.parity_extension_rule
#print axioms RelativeConicArcs.ClebschWittHadamard.generator_gram_zero
#print axioms RelativeConicArcs.ClebschWittHadamard.hexads_steiner_five
#print axioms RelativeConicArcs.ClebschWittHadamard.fullSupportPoints_complete
#print axioms RelativeConicArcs.ClebschWittHadamard.hadamard_gram
#print axioms RelativeConicArcs.ClebschWittHadamard.secant_exhaustion
#print axioms RelativeConicArcs.ClebschWittHadamard.displayed_maps_are_permutations
#print axioms RelativeConicArcs.ClebschWittHadamard.frozen_action_literal_checks
#print axioms RelativeConicArcs.ClebschWittHadamard.frozen_fullSupport_action
#print axioms RelativeConicArcs.ClebschWittHadamard.parent_generators_preserve_hexads
#print axioms RelativeConicArcs.ClebschWittHadamard.parent_action_discriminator
#print axioms RelativeConicArcs.ClebschWittHadamard.row_column_hinge
#print axioms RelativeConicArcs.ClebschWittHadamard.rowCarrierRelabelling_twoSidedInverse
#print axioms RelativeConicArcs.ClebschWittHadamard.parent_intersection_and_join
#print axioms RelativeConicArcs.ClebschWittHadamard.row_action_has_design_closure
#print axioms RelativeConicArcs.ClebschWittHadamard.row_column_assignment_finite_graph_certificate
#print axioms RelativeConicArcs.ClebschWittHadamard.row_column_assignment_normalizes_design_closure
#print axioms RelativeConicArcs.ClebschWittHadamard.row_column_hinge_has_no_inner_witness
