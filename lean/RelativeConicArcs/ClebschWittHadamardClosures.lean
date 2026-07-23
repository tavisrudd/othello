import RelativeConicArcs.ClebschWittHadamard

/-!
# Degree-twelve closure and row/column automorphism checks

This leaf uses bounded native work-list evaluation on packed degree-twelve permutations.  It checks
the parent orders and intersection/join relations, equality of the coordinate and transported-row
closures, the simultaneous-word graph of the row/column automorphism, its inner square, and the
absence of an inner element realizing the generator assignment.  In the pinned toolchain every
terminal exposes a declaration-local `_native.native_decide.ax_1_1` dependency; no classical
group name is asserted.
-/

namespace RelativeConicArcs
namespace ClebschWittHadamard

/-- Exact finite closure checks for the two degree-twelve parents and their common hinge. -/
theorem parent_intersection_and_join : parentClosureChecks := by
  native_decide

/-- Transported row action has the same full finite closure as the coordinate design action. -/
theorem row_action_has_design_closure : rowClosureChecks := by
  native_decide

/-- The simultaneous word closure is the graph of a bijective generator assignment whose square
is the displayed inner conjugation. -/
theorem row_column_assignment_is_automorphism_graph :
    rowColumnAssignmentChecks := by
  native_decide

/-- No element of the coordinate closure simultaneously conjugates its two displayed generators
to the aligned row generators. -/
theorem row_column_hinge_has_no_inner_witness :
    rowColumnNonInnerCheck := by
  native_decide

end ClebschWittHadamard
end RelativeConicArcs
