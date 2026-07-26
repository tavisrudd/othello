import RelativeConicArcs.NinePointHeisenbergIncidence

/-!
# Uncovered-orbit secant multiplicities on the last affine rows and infinity

Kernel reduction counts uncovered-orbit chord incidences on the 96 canonical points in the final
coordinate block.
-/

namespace RelativeConicArcs
namespace NinePointHeisenbergUncoveredSecantY15To18AndInfinity

open NinePointHeisenbergIncidence
set_option maxHeartbeats 400000000
set_option maxRecDepth 100000

/-- The five uncovered-orbit chord multiplicities on the final coordinate block. -/
theorem secant_multiplicity_profile :
    offSetSecantMultiplicityCountOn canonicalPointsY15To18AndInfinity NinePointHeisenbergPair.uncovered 0 = 2 ∧
    offSetSecantMultiplicityCountOn canonicalPointsY15To18AndInfinity NinePointHeisenbergPair.uncovered 1 = 31 ∧
    offSetSecantMultiplicityCountOn canonicalPointsY15To18AndInfinity NinePointHeisenbergPair.uncovered 2 = 44 ∧
    offSetSecantMultiplicityCountOn canonicalPointsY15To18AndInfinity NinePointHeisenbergPair.uncovered 3 = 9 ∧
    offSetSecantMultiplicityCountOn canonicalPointsY15To18AndInfinity NinePointHeisenbergPair.uncovered 4 = 5 := by
  decide

end NinePointHeisenbergUncoveredSecantY15To18AndInfinity
end RelativeConicArcs
