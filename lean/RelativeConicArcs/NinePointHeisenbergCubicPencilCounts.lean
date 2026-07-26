import RelativeConicArcs.NinePointHeisenbergCubicPencil
import RelativeConicArcs.NinePointHeisenbergIncidence

/-!
# Rational point counts in a Heisenberg-invariant cubic pencil

This module checks every one of the 381 projective points over `ZMod 19` on each of the twenty
rational members of the explicit cubic pencil.  The point-count histogram and empty rational base
locus are closed finite propositions proved by kernel reduction.
-/

namespace RelativeConicArcs
namespace NinePointHeisenbergCubicPencilCounts

open NinePointHeisenbergIncidence NinePointHeisenbergCubicPencil

set_option maxHeartbeats 800000000
set_option maxRecDepth 100000

/-- Number of rational projective zeros of a cubic. -/
def projectivePointCount (coefficients : CubicCoefficients) : Nat :=
  canonicalPoints.countP fun p => cubicValue coefficients p = 0

/-- The nineteen affine pencil parameters `F_A + t F_U`. -/
def affinePencilMembers : List CubicCoefficients :=
  fieldElements.map fun t => selectedCoefficients + t • uncoveredCoefficients

/-- The twenty rational members of the projective cubic pencil. -/
def rationalPencilMembers : List CubicCoefficients :=
  affinePencilMembers ++ [uncoveredCoefficients]

/-- Whether two cubic coefficient vectors differ by a field scalar. -/
def scalarEquivalentCoefficients
    (left right : CubicCoefficients) : Bool :=
  fieldElements.any fun scalar => decide (left = scalar • right)

/-- Number of rational pencil members with a prescribed projective point count. -/
def pencilPointCountMultiplicity (pointCount : Nat) : Nat :=
  rationalPencilMembers.countP fun coefficients =>
    projectivePointCount coefficients = pointCount

attribute [reducible] projectivePointCount affinePencilMembers rationalPencilMembers
  scalarEquivalentCoefficients pencilPointCountMultiplicity

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

/-- The list contains twenty pairwise projectively distinct nonzero cubic forms. -/
theorem rational_pencil_members_are_distinct :
    rationalPencilMembers.length = 20 ∧
    rationalPencilMembers.all (fun coefficients => decide (coefficients ≠ 0)) = true ∧
    (List.sublistsLen 2 rationalPencilMembers).all (fun pair =>
      match pair with
      | [left, right] => !scalarEquivalentCoefficients left right
      | _ => false) = true := by
  decide

/-- Each of the two orbit cubics has eighteen rational projective points. -/
theorem orbit_cubic_point_counts :
    projectivePointCount selectedCoefficients = 18 ∧
    projectivePointCount uncoveredCoefficients = 18 := by
  decide

/-- The two orbit cubics have no common `F₁₉`-rational projective point. -/
theorem rational_base_locus_is_empty :
    canonicalPoints.all (fun p =>
      !(decide (cubicValue selectedCoefficients p = 0) &&
        decide (cubicValue uncoveredCoefficients p = 0))) = true := by
  decide

end NinePointHeisenbergCubicPencilCounts
end RelativeConicArcs
