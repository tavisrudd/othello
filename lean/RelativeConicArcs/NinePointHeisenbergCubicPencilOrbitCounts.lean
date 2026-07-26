import RelativeConicArcs.NinePointHeisenbergCubicPencilCensus

/-!
# Rational point counts of the orbit cubics

Kernel reduction checks all 381 rational projective points on each of the two cubics whose zero
sets contain the displayed nine-point orbits.
-/

namespace RelativeConicArcs
namespace NinePointHeisenbergCubicPencilOrbitCounts

open NinePointHeisenbergCubicPencil NinePointHeisenbergCubicPencilCounts

set_option maxHeartbeats 800000000
set_option maxRecDepth 100000

/-- Each of the two orbit cubics has eighteen rational projective points. -/
theorem orbit_cubic_point_counts :
    projectivePointCount selectedCoefficients = 18 ∧
    projectivePointCount uncoveredCoefficients = 18 := by
  decide

end NinePointHeisenbergCubicPencilOrbitCounts
end RelativeConicArcs
