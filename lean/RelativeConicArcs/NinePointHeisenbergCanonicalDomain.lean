import RelativeConicArcs.NinePointHeisenbergIncidence

/-!
# Canonical projective coordinate domain over `ZMod 19`

Kernel reduction checks that the explicit coordinate list has 381 distinct nonzero vectors.  This
is the finite domain used for every projective point and line census of the nine-point Heisenberg
pair; no external point list is imported.
-/

namespace RelativeConicArcs
namespace NinePointHeisenbergCanonicalDomain

open NinePointHeisenbergIncidence

set_option maxHeartbeats 400000000
set_option maxRecDepth 100000

/-- The coordinate domain consists of 381 distinct nonzero representatives. -/
theorem canonical_projective_point_domain :
    canonicalPoints.length = 381 ∧
    canonicalPoints.Nodup ∧
    canonicalPoints.all (fun p => decide (p ≠ 0)) = true := by
  decide

end NinePointHeisenbergCanonicalDomain
end RelativeConicArcs
