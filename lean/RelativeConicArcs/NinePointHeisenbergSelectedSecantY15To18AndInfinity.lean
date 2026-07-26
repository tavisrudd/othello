import RelativeConicArcs.NinePointHeisenbergIncidence

/-!
# Selected-orbit secant multiplicities on the last affine rows and infinity

Kernel reduction counts selected-orbit chord incidences on the 96 canonical points in the final
coordinate block.
-/

namespace RelativeConicArcs
namespace NinePointHeisenbergSelectedSecantY15To18AndInfinity

open NinePointHeisenbergIncidence

set_option maxHeartbeats 400000000
set_option maxRecDepth 100000

/-- The five selected-orbit chord multiplicities on the final coordinate block. -/
theorem secant_multiplicity_profile :
    offSetSecantMultiplicityCountOn canonicalPointsY15To18AndInfinity NinePointHeisenbergPair.selected 0 = 5 ∧
    offSetSecantMultiplicityCountOn canonicalPointsY15To18AndInfinity NinePointHeisenbergPair.selected 1 = 44 ∧
    offSetSecantMultiplicityCountOn canonicalPointsY15To18AndInfinity NinePointHeisenbergPair.selected 2 = 30 ∧
    offSetSecantMultiplicityCountOn canonicalPointsY15To18AndInfinity NinePointHeisenbergPair.selected 3 = 13 ∧
    offSetSecantMultiplicityCountOn canonicalPointsY15To18AndInfinity NinePointHeisenbergPair.selected 4 = 2 := by
  decide

end NinePointHeisenbergSelectedSecantY15To18AndInfinity
end RelativeConicArcs
