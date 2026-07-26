import RelativeConicArcs.NinePointHeisenbergConicCensus

/-!
# Cardinality of the five-subset conic census

Kernel reduction constructs and deduplicates the conics through all five-subsets of the explicit
uncovered nine-arc and checks their nonsingularity.
-/

namespace RelativeConicArcs
namespace NinePointHeisenbergConicCountCardinality

open NinePointHeisenbergConicCensus

set_option maxHeartbeats 800000000
set_option maxRecDepth 100000

/-- There are 126 five-subsets, determining 81 distinct nonsingular conics. -/
theorem five_subset_conic_counts :
    fiveSubsetIndexLists.length = 126 ∧
    fiveSubsetConics.length = 126 ∧
    distinctConics.length = 81 ∧
    distinctConics.all isNonsingular = true := by
  decide +kernel

end NinePointHeisenbergConicCountCardinality
end RelativeConicArcs
