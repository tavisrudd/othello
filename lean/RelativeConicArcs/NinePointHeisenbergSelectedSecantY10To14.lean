import RelativeConicArcs.NinePointHeisenbergIncidence

/-!
# Selected-orbit secant multiplicities on affine rows ten through fourteen

Kernel reduction counts selected-orbit chord incidences on the 95 canonical affine points with
second coordinate representative ten through fourteen.
-/

namespace RelativeConicArcs
namespace NinePointHeisenbergSelectedSecantY10To14

open NinePointHeisenbergIncidence

set_option maxHeartbeats 400000000
set_option maxRecDepth 100000

/-- The five selected-orbit chord multiplicities on affine rows ten through fourteen. -/
theorem secant_multiplicity_profile :
    offSetSecantMultiplicityCountOn canonicalPointsY10To14 NinePointHeisenbergPair.selected 0 = 2 ∧
    offSetSecantMultiplicityCountOn canonicalPointsY10To14 NinePointHeisenbergPair.selected 1 = 43 ∧
    offSetSecantMultiplicityCountOn canonicalPointsY10To14 NinePointHeisenbergPair.selected 2 = 27 ∧
    offSetSecantMultiplicityCountOn canonicalPointsY10To14 NinePointHeisenbergPair.selected 3 = 19 ∧
    offSetSecantMultiplicityCountOn canonicalPointsY10To14 NinePointHeisenbergPair.selected 4 = 2 := by
  decide

end NinePointHeisenbergSelectedSecantY10To14
end RelativeConicArcs
