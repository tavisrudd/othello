import RelativeConicArcs.NinePointHeisenbergCubicPencilCensus

/-!
# Rational point-count distribution of the cubic pencil

Kernel reduction checks all 381 projective points on each of the twenty rational members of the
explicit Heisenberg-invariant cubic pencil.
-/

namespace RelativeConicArcs
namespace NinePointHeisenbergCubicPencilPointProfile

open NinePointHeisenbergCubicPencilCounts

set_option maxHeartbeats 800000000
set_option maxRecDepth 100000

/-- The complete rational point-count distribution of the twenty pencil members. -/
theorem rational_pencil_point_count_profile :
    pencilPointCountMultiplicity 0 = 3 ∧
    pencilPointCountMultiplicity 18 = 12 ∧
    pencilPointCountMultiplicity 27 = 4 ∧
    pencilPointCountMultiplicity 57 = 1 ∧
    rationalPencilMembers.all (fun coefficients =>
      projectivePointCount coefficients = 0 ||
      projectivePointCount coefficients = 18 ||
      projectivePointCount coefficients = 27 ||
      projectivePointCount coefficients = 57) = true := by
  decide

end NinePointHeisenbergCubicPencilPointProfile
end RelativeConicArcs
