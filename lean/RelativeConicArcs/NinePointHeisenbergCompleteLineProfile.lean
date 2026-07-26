import RelativeConicArcs.NinePointHeisenbergIncidence

/-!
# Complete line-intersection profile of a nine-point Heisenberg pair

Kernel reduction ranges over all 381 canonical projective lines of `PG(2, 19)`, checks the seven
occurring intersection types with the two explicit nine-point sets, and rules out every other
type.  No line-profile table is imported.
-/

namespace RelativeConicArcs
namespace NinePointHeisenbergCompleteLineProfile

open NinePointHeisenbergIncidence

set_option maxHeartbeats 400000000
set_option maxRecDepth 100000

/-- The seven occurring line types and their multiplicities account for all 381 lines. -/
theorem complete_line_type_profile :
    lineTypeCount 0 0 = 147 ∧
    lineTypeCount 0 1 = 81 ∧
    lineTypeCount 0 2 = 9 ∧
    lineTypeCount 1 0 = 54 ∧
    lineTypeCount 1 1 = 27 ∧
    lineTypeCount 1 2 = 27 ∧
    lineTypeCount 2 0 = 36 ∧
    canonicalPoints.all (fun line =>
      lineType line = (0, 0) || lineType line = (0, 1) ||
      lineType line = (0, 2) || lineType line = (1, 0) ||
      lineType line = (1, 1) || lineType line = (1, 2) ||
      lineType line = (2, 0)) = true := by
  decide

end NinePointHeisenbergCompleteLineProfile
end RelativeConicArcs
