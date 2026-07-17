import RelativeConicArcs.ReflectionArrangements
import RelativeConicArcs.Q11DecodingSynthesis

/-!
# Decoder corollary of the reduced `H3` arrangement

This light downstream module joins the compact arrangement spectrum to the existing complete
nearest-codeword ambiguity theorem.  Keeping it separate prevents the semantic certificate closure
from accumulating in the coordinate leaf.
-/

namespace RelativeConicArcs.Examples.ReflectionArrangements

open RelativeConicArcs.Examples.Q11Coding

/-- The reduced `H3` multiplicity strata and the coefficient-bearing Clebsch decoder strata agree
at the paper-facing level.  `h3_dual_projectivity_maps_mirrors` supplies the exact geometric
identification between the arrangements. -/
theorem h3_decoder_strata :
    (h3PointsOfMultiplicity 0).card = 12 ∧
    (h3PointsOfMultiplicity 1).card = 90 ∧
    (h3PointsOfMultiplicity 2).card = 15 ∧
    (h3PointsOfMultiplicity 3).card = 10 ∧
    ambiguityOneSyndromes.card = 960 ∧
    ambiguityTwoSyndromes.card = 150 ∧
    ambiguityThreeSyndromes.card = 100 ∧
    ambiguityTwentySyndromes.card = 120 := by
  exact ⟨h3_intersection_spectrum.1, h3_intersection_spectrum.2.1,
    h3_intersection_spectrum.2.2.1, h3_intersection_spectrum.2.2.2.1,
    ambiguity_strata_counts.1, ambiguity_strata_counts.2.1,
    ambiguity_strata_counts.2.2.1, ambiguity_strata_counts.2.2.2⟩

#print axioms h3_decoder_strata

end RelativeConicArcs.Examples.ReflectionArrangements
