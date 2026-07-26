import RelativeConicArcs.NinePointHeisenbergConicCensus

/-!
# Multiplicities in the five-subset conic census

Kernel reduction counts how many five-subsets produce each normalized conic in the explicit
uncovered nine-arc census.
-/

namespace RelativeConicArcs
namespace NinePointHeisenbergConicCountMultiplicity

open NinePointHeisenbergConicCensus

set_option maxHeartbeats 800000000
set_option maxRecDepth 100000

/-- Seventy-two conics occur once and nine occur for the six five-subsets of six points. -/
theorem five_subset_multiplicity_profile :
    conicMultiplicityCount 1 = 72 ∧
    conicMultiplicityCount 6 = 9 ∧
    distinctConics.all (fun coefficients =>
      fiveSubsetMultiplicity coefficients = 1 ||
      fiveSubsetMultiplicity coefficients = 6) = true := by
  decide +kernel

end NinePointHeisenbergConicCountMultiplicity
end RelativeConicArcs
