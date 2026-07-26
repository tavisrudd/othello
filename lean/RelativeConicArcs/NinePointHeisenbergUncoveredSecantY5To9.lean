import RelativeConicArcs.NinePointHeisenbergIncidence

/-!
# Uncovered-orbit secant multiplicities on affine rows five through nine

Kernel reduction counts uncovered-orbit chord incidences on this 95-point affine block.
-/

namespace RelativeConicArcs
namespace NinePointHeisenbergUncoveredSecantY5To9

open NinePointHeisenbergIncidence
set_option maxHeartbeats 400000000
set_option maxRecDepth 100000

/-- The five uncovered-orbit chord multiplicities on affine rows five through nine. -/
theorem secant_multiplicity_profile :
    offSetSecantMultiplicityCountOn canonicalPointsY5To9 NinePointHeisenbergPair.uncovered 0 = 3 ∧
    offSetSecantMultiplicityCountOn canonicalPointsY5To9 NinePointHeisenbergPair.uncovered 1 = 22 ∧
    offSetSecantMultiplicityCountOn canonicalPointsY5To9 NinePointHeisenbergPair.uncovered 2 = 61 ∧
    offSetSecantMultiplicityCountOn canonicalPointsY5To9 NinePointHeisenbergPair.uncovered 3 = 4 ∧
    offSetSecantMultiplicityCountOn canonicalPointsY5To9 NinePointHeisenbergPair.uncovered 4 = 3 := by
  decide

end NinePointHeisenbergUncoveredSecantY5To9
end RelativeConicArcs
