import RelativeConicArcs.NinePointHeisenbergIncidence

/-!
# Arc check for the uncovered nine-point Heisenberg orbit

Kernel reduction checks every triple in the explicit uncovered orbit over `ZMod 19`.
-/

namespace RelativeConicArcs
namespace NinePointHeisenbergUncoveredArc

open NinePointHeisenbergIncidence

set_option maxHeartbeats 400000000
set_option maxRecDepth 100000

/-- The displayed uncovered nine-point set is a projective arc. -/
theorem uncovered_set_is_arc :
    isCoordinateArc NinePointHeisenbergPair.uncovered = true := by
  decide

end NinePointHeisenbergUncoveredArc
end RelativeConicArcs
