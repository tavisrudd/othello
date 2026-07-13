import RelativeConicArcs.Q11SemanticBase
namespace RelativeConicArcs.Examples.Q11Coding
private instance : Fact (Nat.Prime 11) := ⟨by decide⟩
set_option maxHeartbeats 30000000
set_option maxRecDepth 100000
theorem index_five_has_one_presentation : ∀ i : Fin 133,
    rawPointIndex (projectiveVec i) = 5 →
    ∃ j : Fin 6, ∃ a : ZMod 11, a ≠ 0 ∧ a • witnessVec j = projectiveVec i := by decide
end RelativeConicArcs.Examples.Q11Coding
