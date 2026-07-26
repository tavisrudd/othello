import RelativeConicArcs.NinePointHeisenbergIncidence

/-!
# Uncovered-orbit secant multiplicities on affine rows ten through fourteen

Kernel reduction counts uncovered-orbit chord incidences on this 95-point affine block.
-/

namespace RelativeConicArcs
namespace NinePointHeisenbergUncoveredSecantY10To14

open NinePointHeisenbergIncidence
set_option maxHeartbeats 400000000
set_option maxRecDepth 100000

/-- The five uncovered-orbit chord multiplicities on affine rows ten through fourteen. -/
theorem secant_multiplicity_profile :
    offSetSecantMultiplicityCountOn canonicalPointsY10To14 NinePointHeisenbergPair.uncovered 0 = 9 ∧
    offSetSecantMultiplicityCountOn canonicalPointsY10To14 NinePointHeisenbergPair.uncovered 1 = 37 ∧
    offSetSecantMultiplicityCountOn canonicalPointsY10To14 NinePointHeisenbergPair.uncovered 2 = 34 ∧
    offSetSecantMultiplicityCountOn canonicalPointsY10To14 NinePointHeisenbergPair.uncovered 3 = 8 ∧
    offSetSecantMultiplicityCountOn canonicalPointsY10To14 NinePointHeisenbergPair.uncovered 4 = 5 := by
  decide

end NinePointHeisenbergUncoveredSecantY10To14
end RelativeConicArcs
