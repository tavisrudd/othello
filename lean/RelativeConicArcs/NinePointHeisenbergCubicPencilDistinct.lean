import RelativeConicArcs.NinePointHeisenbergCubicPencilCensus
import Mathlib.Data.List.Sublists

/-!
# Projective distinctness in the rational cubic pencil

Kernel reduction checks that the twenty listed pencil members are nonzero and pairwise
inequivalent under field-scalar multiplication.
-/

namespace RelativeConicArcs
namespace NinePointHeisenbergCubicPencilDistinct

open NinePointHeisenbergCubicPencilCounts

set_option maxHeartbeats 800000000
set_option maxRecDepth 100000

/-- The list contains twenty pairwise projectively distinct nonzero cubic forms. -/
theorem rational_pencil_members_are_distinct :
    rationalPencilMembers.length = 20 ∧
    rationalPencilMembers.all (fun coefficients => decide (coefficients ≠ 0)) = true ∧
    (List.sublistsLen 2 rationalPencilMembers).all (fun pair =>
      match pair with
      | [left, right] => !scalarEquivalentCoefficients left right
      | _ => false) = true := by
  decide

end NinePointHeisenbergCubicPencilDistinct
end RelativeConicArcs
