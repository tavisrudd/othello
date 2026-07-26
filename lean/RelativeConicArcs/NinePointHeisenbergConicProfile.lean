import RelativeConicArcs.NinePointHeisenbergConicProfileComplete
import RelativeConicArcs.NinePointHeisenbergConicProfileMaxima

/-!
# Intersection profile of the five-subset conics

The complete profile and its intersection bounds are checked in separate bounded kernel
computations.  This module collects their conclusions without repeating either computation.
-/

namespace RelativeConicArcs
namespace NinePointHeisenbergConicProfile

open NinePointHeisenbergConicCensus

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
      conicProfile coefficients = (6, 1, 3, 5)) = true :=
  NinePointHeisenbergConicProfileComplete.complete_conic_profile

/-- No five-subset conic contains seven uncovered points or two selected points. -/
theorem conic_intersection_maxima :
    distinctConics.all (fun coefficients =>
      pointsOnConic coefficients NinePointHeisenbergPair.uncovered ≤ 6 &&
      pointsOnConic coefficients NinePointHeisenbergPair.selected ≤ 1) = true :=
  NinePointHeisenbergConicProfileMaxima.conic_intersection_maxima

end NinePointHeisenbergConicProfile
end RelativeConicArcs
