import RelativeConicArcs.NinePointHeisenbergConicCensus

/-!
# Complete profile of the five-subset conics

For each of the 81 distinct conics determined by five uncovered-orbit points, kernel reduction
counts intersections with both nine-point orbits and classifies off-conic selected points by the
discriminant-square predicates.
-/

namespace RelativeConicArcs
namespace NinePointHeisenbergConicProfileComplete

open NinePointHeisenbergConicCensus

set_option maxHeartbeats 800000000
set_option maxRecDepth 100000

/-- The complete intersection and internal/external profile of the 81 conics. -/
theorem complete_conic_profile :
    conicProfileCount 5 0 3 6 = 9 ∧
    conicProfileCount 5 0 4 5 = 9 ∧
    conicProfileCount 5 0 5 4 = 45 ∧
    conicProfileCount 5 1 4 4 = 9 ∧
    conicProfileCount 6 1 3 5 = 9 ∧
    distinctConics.all (fun coefficients =>
      conicProfile coefficients = (5, 0, 3, 6) ||
      conicProfile coefficients = (5, 0, 4, 5) ||
      conicProfile coefficients = (5, 0, 5, 4) ||
      conicProfile coefficients = (5, 1, 4, 4) ||
      conicProfile coefficients = (6, 1, 3, 5)) = true := by
  decide +kernel

end NinePointHeisenbergConicProfileComplete
end RelativeConicArcs
