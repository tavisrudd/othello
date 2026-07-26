import RelativeConicArcs.NinePointHeisenbergConicCountCardinality
import RelativeConicArcs.NinePointHeisenbergConicCountContainment
import RelativeConicArcs.NinePointHeisenbergConicCountRank
import RelativeConicArcs.NinePointHeisenbergConicCountMultiplicity

/-!
# Multiplicity counts for five-subset conics

The four independent kernel computations for the five-subset conic census are checked in
separate bounded modules.  This module collects their conclusions without repeating any finite
computation.
-/

namespace RelativeConicArcs
namespace NinePointHeisenbergConicCounts

/-- There are 126 five-subsets, determining 81 distinct nonsingular conics. -/
theorem five_subset_conic_counts :
    NinePointHeisenbergConicCensus.fiveSubsetIndexLists.length = 126 ∧
    NinePointHeisenbergConicCensus.fiveSubsetConics.length = 126 ∧
    NinePointHeisenbergConicCensus.distinctConics.length = 81 ∧
    NinePointHeisenbergConicCensus.distinctConics.all
      NinePointHeisenbergConicCensus.isNonsingular = true :=
  NinePointHeisenbergConicCountCardinality.five_subset_conic_counts

/-- Every normalized signed-minor form vanishes on the five uncovered points that define it. -/
theorem each_conic_contains_its_five_subset :
    (NinePointHeisenbergConicCensus.fiveSubsetIndexLists.zip
      NinePointHeisenbergConicCensus.fiveSubsetConics).all (fun entry =>
        entry.1.all fun index =>
          NinePointHeisenbergConicCensus.quadraticValue entry.2
            (NinePointHeisenbergPair.uncovered.get index) = 0) = true :=
  NinePointHeisenbergConicCountContainment.each_conic_contains_its_five_subset

/-- Every five-point evaluation matrix has a nonzero maximal minor, so its quadratic kernel is
one-dimensional. -/
theorem each_five_subset_has_full_evaluation_rank :
    NinePointHeisenbergConicCensus.fiveSubsetIndexLists.all (fun indices =>
      (List.ofFn fun omitted : Fin 6 => omitted).any fun omitted =>
        decide (Matrix.det
          (NinePointHeisenbergConicCensus.fivePointEvaluationMinor indices omitted) ≠ 0)) = true :=
  NinePointHeisenbergConicCountRank.each_five_subset_has_full_evaluation_rank

/-- Seventy-two conics occur once and nine occur for the six five-subsets of six points. -/
theorem five_subset_multiplicity_profile :
    NinePointHeisenbergConicCensus.conicMultiplicityCount 1 = 72 ∧
    NinePointHeisenbergConicCensus.conicMultiplicityCount 6 = 9 ∧
    NinePointHeisenbergConicCensus.distinctConics.all (fun coefficients =>
      NinePointHeisenbergConicCensus.fiveSubsetMultiplicity coefficients = 1 ||
      NinePointHeisenbergConicCensus.fiveSubsetMultiplicity coefficients = 6) = true :=
  NinePointHeisenbergConicCountMultiplicity.five_subset_multiplicity_profile

end NinePointHeisenbergConicCounts
end RelativeConicArcs
