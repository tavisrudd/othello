import RelativeConicArcs.MatchingPackingCompletionBridge
import RelativeConicArcs.SmallOddRelativeConicWitnesses

/-!
# Small odd-order witnesses and matching-packing defect bounds

This import-only gate checks two human-scale additions to the formal theory of arcs complete
outside a prescribed conic.  The first is the maximum-matching packing argument: failure of an
exact matching design forces a two-block deficiency and hence a quantitative prescribed-hole
defect bound.  The second consists of explicit relative-conic witnesses over fields of orders
thirteen, seventeen, and nineteen.

The witness checks establish only the upper bounds eight, nine, and ten.  Exhaustive classifications
supplying the corresponding lower bounds are external computations and are not represented by Lean
declarations in this gate.  All finite witness predicates here are checked by kernel reduction.
-/

#print axioms RelativeConicArcs.MatchingPacking.oneBlockShort_leave_isClique
#print axioms
  RelativeConicArcs.CliquePacking.exists_decomposition_of_card_leave_eq_choose
#print axioms RelativeConicArcs.badConcurrenceEdgeCount_add_maximumBlocks
#print axioms RelativeConicArcs.matchingPackingDeficiency_le_scaledDefect
#print axioms RelativeConicArcs.two_mul_half_le_scaledDefect_of_two_le_matchingPackingDeficiency
#print axioms RelativeConicArcs.maximumConcurrenceBlockDeficiency_le_scaledDefect
#print axioms
  RelativeConicArcs.two_mul_half_le_scaledDefect_of_two_le_maximumConcurrenceBlockDeficiency
#print axioms
  RelativeConicArcs.two_le_maximumConcurrenceBlockDeficiency_of_no_decomposition
#print axioms
  RelativeConicArcs.two_mul_half_le_scaledDefect_of_no_disjointness_decomposition

#print axioms RelativeConicArcs.SmallOddRelativeConicWitnessData.q13Normalization_det
#print axioms RelativeConicArcs.SmallOddRelativeConicWitnessData.q17Normalization_det
#print axioms RelativeConicArcs.SmallOddRelativeConicWitnessData.q13Normalization_maps
#print axioms RelativeConicArcs.SmallOddRelativeConicWitnessData.q17Normalization_maps
#print axioms RelativeConicArcs.SmallOddRelativeConicWitnessData.q13Normalization_conicForm
#print axioms RelativeConicArcs.SmallOddRelativeConicWitnessData.q17Normalization_conicForm
#print axioms RelativeConicArcs.SmallOddRelativeConicWitnesses.q13_check
#print axioms RelativeConicArcs.SmallOddRelativeConicWitnesses.q17_check
#print axioms RelativeConicArcs.SmallOddRelativeConicWitnesses.q19_check
#print axioms RelativeConicArcs.SmallOddRelativeConicWitnesses.q19_ordinaryCoverage
#print axioms RelativeConicArcs.SmallOddRelativeConicWitnesses.q19_complete
#print axioms RelativeConicArcs.SmallOddRelativeConicWitnesses.rhoC_ZMod13_le_eight
#print axioms RelativeConicArcs.SmallOddRelativeConicWitnesses.rhoC_ZMod17_le_nine
#print axioms RelativeConicArcs.SmallOddRelativeConicWitnesses.rhoC_ZMod19_le_ten
