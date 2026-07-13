import RelativeConicArcs.Q11SemanticBase
namespace RelativeConicArcs.Examples.Q11Coding
private instance : Fact (Nat.Prime 11) := ⟨by decide⟩
set_option maxHeartbeats 30000000
set_option maxRecDepth 100000
theorem nonzero_nonfive_has_two_presentation_a : ∀ i : Fin 133, i.1 < 34 →
    rawPointIndex (projectiveVec i) ≠ 0 → rawPointIndex (projectiveVec i) ≠ 5 →
    ∃ j k : Fin 6, j < k ∧ ∃ a b : ZMod 11,
      a ≠ 0 ∧ b ≠ 0 ∧ a • witnessVec j + b • witnessVec k = projectiveVec i := by decide
end RelativeConicArcs.Examples.Q11Coding
