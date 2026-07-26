import RelativeConicArcs.NinePointHeisenbergIncidence

/-!
# Selected-orbit secant multiplicities on affine rows five through nine

Kernel reduction counts selected-orbit chord incidences on the 95 canonical affine points with
second coordinate representative five through nine.
-/

namespace RelativeConicArcs
namespace NinePointHeisenbergSelectedSecantY5To9

open NinePointHeisenbergIncidence

set_option maxHeartbeats 400000000
set_option maxRecDepth 100000

/-- The five selected-orbit chord multiplicities on affine rows five through nine. -/
theorem secant_multiplicity_profile :
    offSetSecantMultiplicityCountOn canonicalPointsY5To9 NinePointHeisenbergPair.selected 0 = 2 ∧
    offSetSecantMultiplicityCountOn canonicalPointsY5To9 NinePointHeisenbergPair.selected 1 = 53 ∧
    offSetSecantMultiplicityCountOn canonicalPointsY5To9 NinePointHeisenbergPair.selected 2 = 33 ∧
    offSetSecantMultiplicityCountOn canonicalPointsY5To9 NinePointHeisenbergPair.selected 3 = 7 ∧
    offSetSecantMultiplicityCountOn canonicalPointsY5To9 NinePointHeisenbergPair.selected 4 = 0 := by
  decide

end NinePointHeisenbergSelectedSecantY5To9
end RelativeConicArcs
