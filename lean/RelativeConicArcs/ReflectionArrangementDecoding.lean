import RelativeConicArcs.ReflectionArrangements
import RelativeConicArcs.Q11DecodingSynthesis

/-!
# Joint incidence/ambiguity census

This downstream module records, in one theorem, the reduced-`H3` incidence-stratum cardinalities
together with the Clebsch nearest-codeword ambiguity-census cardinalities.  It is kept separate from
the coordinate module so the decoder closure does not enter that module's elaboration.
-/

namespace RelativeConicArcs.Examples.ReflectionArrangements

open RelativeConicArcs.Examples.Q11Coding

/-- Joint numerical census: the reduced-`H3` incidence-stratum sizes for incidence `0,1,2,3` together
with the Clebsch nearest-codeword ambiguity-census sizes.  This is a conjunction of cardinality
equalities only; it asserts no map, membership, or leader-count equivalence between the two
stratifications. -/
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
