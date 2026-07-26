import RelativeConicArcs.MatchingPackingDefect
import RelativeConicArcs.MatchingPackingDefectBridge

/-!
# Matching-packing defect verification boundary

This import-only module checks the finite-graph leave theorem, the exact partition of Kneser edges
between nonmaximum and maximum concurrence cliques, and the resulting quantitative transfer from
missing maximum-matching blocks to the integer-normalized prescribed-hole defect.
-/

#print axioms RelativeConicArcs.MatchingPacking.oneBlockShort_leave_isClique
#print axioms RelativeConicArcs.badConcurrenceEdgeCount_add_maximumBlocks
#print axioms RelativeConicArcs.matchingPackingDeficiency_le_scaledDefect
#print axioms RelativeConicArcs.two_mul_half_le_scaledDefect_of_two_le_matchingPackingDeficiency
#print axioms RelativeConicArcs.maximumConcurrenceBlockDeficiency_le_scaledDefect
#print axioms
  RelativeConicArcs.two_mul_half_le_scaledDefect_of_two_le_maximumConcurrenceBlockDeficiency
