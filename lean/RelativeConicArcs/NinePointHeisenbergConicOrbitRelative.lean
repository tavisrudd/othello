import RelativeConicArcs.NinePointHeisenbergConicCensus

/-!
# Relative-label profile of the six-point conics

Kernel reduction checks the omitted uncovered-orbit labels of the unique six-point conic through
each selected-orbit point.
-/

namespace RelativeConicArcs
namespace NinePointHeisenbergConicOrbitRelative

open NinePointHeisenbergIncidence NinePointHeisenbergConicCensus

set_option maxHeartbeats 800000000
set_option maxRecDepth 100000

/--
For each selected orbit label there is exactly one six-point conic, and its omitted uncovered
labels are the three displayed translates.
-/
theorem six_point_conics_have_relative_orbit_profile :
    labels.all (fun selectedLabel =>
      distinctConics.countP (hasRelativeSixPointProfile selectedLabel) = 1) = true := by
  decide +kernel

end NinePointHeisenbergConicOrbitRelative
end RelativeConicArcs
