import RelativeConicArcs.NinePointHeisenbergIncidence

/-!
# Uncovered-orbit secant multiplicities on affine rows zero through four

Kernel reduction counts uncovered-orbit chord incidences on the first 95 canonical affine points.
-/

namespace RelativeConicArcs
namespace NinePointHeisenbergUncoveredSecantY0To4

open NinePointHeisenbergIncidence
set_option maxHeartbeats 400000000
set_option maxRecDepth 100000

/-- The five uncovered-orbit chord multiplicities on affine rows zero through four. -/
theorem secant_multiplicity_profile :
    offSetSecantMultiplicityCountOn canonicalPointsY0To4 NinePointHeisenbergPair.uncovered 0 = 4 ∧
    offSetSecantMultiplicityCountOn canonicalPointsY0To4 NinePointHeisenbergPair.uncovered 1 = 36 ∧
    offSetSecantMultiplicityCountOn canonicalPointsY0To4 NinePointHeisenbergPair.uncovered 2 = 41 ∧
    offSetSecantMultiplicityCountOn canonicalPointsY0To4 NinePointHeisenbergPair.uncovered 3 = 9 ∧
    offSetSecantMultiplicityCountOn canonicalPointsY0To4 NinePointHeisenbergPair.uncovered 4 = 5 := by
  decide

end NinePointHeisenbergUncoveredSecantY0To4
end RelativeConicArcs
