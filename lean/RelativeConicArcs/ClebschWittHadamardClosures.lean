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

/-- The simultaneous-word graph has exact 95,040-element source and target carriers, mutually
inverse lookups, generator-step compatibility, a square given by a closure element on every
recorded pair, and the displayed generator correspondence. -/
theorem row_column_assignment_finite_graph_certificate :
    rowColumnAssignmentChecks := by
  native_decide

/-- The certified row/column lookup and its inverse preserve the design closure on every indexed
carrier element.  This is the literal finite normalizer statement; no named-group identification
is inferred. -/
theorem row_column_assignment_normalizes_design_closure :
    let source := closureArray designClosure
    let target := closureArray alignedRowClosure
    (∀ i : Fin source.size,
      designClosure.contains (rowColumnImage source[i.val]!) = true ∧
      rowColumnPreimage (rowColumnImage source[i.val]!) = source[i.val]!) ∧
    (∀ i : Fin target.size,
      designClosure.contains (rowColumnPreimage target[i.val]!) = true ∧
      rowColumnImage (rowColumnPreimage target[i.val]!) = target[i.val]!) := by
  have certificate := row_column_assignment_finite_graph_certificate
  dsimp [rowColumnAssignmentChecks] at certificate
  rcases certificate with
    ⟨_, _, _, _, _, _, _, _, source_total, target_total, _, _⟩
  exact ⟨fun i => ⟨(source_total i).2.1, (source_total i).2.2⟩,
    fun i => ⟨(target_total i).1, (target_total i).2.2⟩⟩

/-- No element of the coordinate closure simultaneously conjugates its two displayed generators
to the aligned row generators. -/
theorem row_column_hinge_has_no_inner_witness :
    rowColumnNonInnerCheck := by
  native_decide

end ClebschWittHadamard
end RelativeConicArcs
