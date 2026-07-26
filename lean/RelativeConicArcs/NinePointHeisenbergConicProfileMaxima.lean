import RelativeConicArcs.NinePointHeisenbergConicCensus

/-!
# Intersection maxima of the five-subset conics

Kernel reduction checks the maximum intersections of every distinct five-subset conic with the
explicit selected and uncovered nine-point orbits.
-/

namespace RelativeConicArcs
namespace NinePointHeisenbergConicProfileMaxima

open NinePointHeisenbergConicCensus

set_option maxHeartbeats 800000000
set_option maxRecDepth 100000

/-- No five-subset conic contains seven uncovered points or two selected points. -/
theorem conic_intersection_maxima :
    distinctConics.all (fun coefficients =>
      pointsOnConic coefficients NinePointHeisenbergPair.uncovered ≤ 6 &&
      pointsOnConic coefficients NinePointHeisenbergPair.selected ≤ 1) = true := by
  decide +kernel

end NinePointHeisenbergConicProfileMaxima
end RelativeConicArcs
