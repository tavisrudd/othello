import RelativeConicArcs.NinePointHeisenbergCubicPencilPointProfile
import RelativeConicArcs.NinePointHeisenbergCubicPencilDistinct
import RelativeConicArcs.NinePointHeisenbergCubicPencilOrbitCounts
import RelativeConicArcs.NinePointHeisenbergCubicPencilBaseLocus

/-!
# Rational point counts in a Heisenberg-invariant cubic pencil

The point-count distribution, projective distinctness, orbit-cubic counts, and rational base
locus are checked in separate bounded kernel computations.  This module collects their
conclusions and the definitions from the census module without repeating those computations.
-/

namespace RelativeConicArcs
namespace NinePointHeisenbergCubicPencilCounts

open NinePointHeisenbergIncidence NinePointHeisenbergCubicPencil

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
      projectivePointCount coefficients = 57) = true :=
  NinePointHeisenbergCubicPencilPointProfile.rational_pencil_point_count_profile

/-- The list contains twenty pairwise projectively distinct nonzero cubic forms. -/
theorem rational_pencil_members_are_distinct :
    rationalPencilMembers.length = 20 ∧
    rationalPencilMembers.all (fun coefficients => decide (coefficients ≠ 0)) = true ∧
    (List.sublistsLen 2 rationalPencilMembers).all (fun pair =>
      match pair with
      | [left, right] => !scalarEquivalentCoefficients left right
      | _ => false) = true :=
  NinePointHeisenbergCubicPencilDistinct.rational_pencil_members_are_distinct

/-- Each of the two orbit cubics has eighteen rational projective points. -/
theorem orbit_cubic_point_counts :
    projectivePointCount selectedCoefficients = 18 ∧
    projectivePointCount uncoveredCoefficients = 18 :=
  NinePointHeisenbergCubicPencilOrbitCounts.orbit_cubic_point_counts

/-- The two orbit cubics have no common `F₁₉`-rational projective point. -/
theorem rational_base_locus_is_empty :
    canonicalPoints.all (fun p =>
      !(decide (cubicValue selectedCoefficients p = 0) &&
        decide (cubicValue uncoveredCoefficients p = 0))) = true :=
  NinePointHeisenbergCubicPencilBaseLocus.rational_base_locus_is_empty

end NinePointHeisenbergCubicPencilCounts
end RelativeConicArcs
