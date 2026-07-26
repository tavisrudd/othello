import RelativeConicArcs.NinePointHeisenbergConicCensus

/-!
# Tangent profile of the six-point conics

Kernel reduction checks the tangent incidence at the unique selected-orbit point of every
six-point conic.
-/

namespace RelativeConicArcs
namespace NinePointHeisenbergConicOrbitTangent

open NinePointHeisenbergConicCensus

set_option maxHeartbeats 800000000
set_option maxRecDepth 100000

/-- At the unique selected point of every six-point conic, the tangent contains no uncovered
point and no second selected point. -/
theorem six_point_conic_tangent_profile :
    distinctConics.all closestConicTangentProfile = true := by
  decide +kernel

end NinePointHeisenbergConicOrbitTangent
end RelativeConicArcs
