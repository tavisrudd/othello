import RelativeConicArcs.NinePointHeisenbergCubicPencilCensus

/-!
# Rational base locus of the cubic pencil

Kernel reduction checks every projective point over `ZMod 19` and proves that the two orbit
cubics have no common rational projective zero.
-/

namespace RelativeConicArcs
namespace NinePointHeisenbergCubicPencilBaseLocus

open NinePointHeisenbergIncidence NinePointHeisenbergCubicPencil

set_option maxHeartbeats 800000000
set_option maxRecDepth 100000

/-- The two orbit cubics have no common `F₁₉`-rational projective point. -/
theorem rational_base_locus_is_empty :
    canonicalPoints.all (fun p =>
      !(decide (cubicValue selectedCoefficients p = 0) &&
        decide (cubicValue uncoveredCoefficients p = 0))) = true := by
  decide

end NinePointHeisenbergCubicPencilBaseLocus
end RelativeConicArcs
