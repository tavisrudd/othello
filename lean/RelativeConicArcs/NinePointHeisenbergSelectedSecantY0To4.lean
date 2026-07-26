import RelativeConicArcs.NinePointHeisenbergIncidence

/-!
# Selected-orbit secant multiplicities on affine rows zero through four

Kernel reduction counts selected-orbit chord incidences on the 95 canonical affine points with
second coordinate representative zero through four.
-/

namespace RelativeConicArcs
namespace NinePointHeisenbergSelectedSecantY0To4

open NinePointHeisenbergIncidence

set_option maxHeartbeats 400000000
set_option maxRecDepth 100000

/-- The five selected-orbit chord multiplicities on affine rows zero through four. -/
theorem secant_multiplicity_profile :
    offSetSecantMultiplicityCountOn canonicalPointsY0To4 NinePointHeisenbergPair.selected 0 = 0 ∧
    offSetSecantMultiplicityCountOn canonicalPointsY0To4 NinePointHeisenbergPair.selected 1 = 22 ∧
    offSetSecantMultiplicityCountOn canonicalPointsY0To4 NinePointHeisenbergPair.selected 2 = 36 ∧
    offSetSecantMultiplicityCountOn canonicalPointsY0To4 NinePointHeisenbergPair.selected 3 = 27 ∧
    offSetSecantMultiplicityCountOn canonicalPointsY0To4 NinePointHeisenbergPair.selected 4 = 5 := by
  decide

end NinePointHeisenbergSelectedSecantY0To4
end RelativeConicArcs
