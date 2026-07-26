import RelativeConicArcs.NinePointHeisenbergIncidence

/-!
# Arc check for the selected nine-point Heisenberg orbit

Kernel reduction checks every triple in the explicit selected orbit over `ZMod 19`.
-/

namespace RelativeConicArcs
namespace NinePointHeisenbergSelectedArc

open NinePointHeisenbergIncidence

set_option maxHeartbeats 400000000
set_option maxRecDepth 100000

/-- The displayed selected nine-point set is a projective arc. -/
theorem selected_set_is_arc :
    isCoordinateArc NinePointHeisenbergPair.selected = true := by
  decide

end NinePointHeisenbergSelectedArc
end RelativeConicArcs
