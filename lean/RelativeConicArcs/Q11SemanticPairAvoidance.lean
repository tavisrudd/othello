import RelativeConicArcs.Q11SemanticBase
namespace RelativeConicArcs.Examples.Q11Coding
private instance : Fact (Nat.Prime 11) := ⟨by decide⟩
set_option maxHeartbeats 30000000
set_option maxRecDepth 100000
theorem index_zero_pair_avoidance : ∀ i : Fin 133,
    rawPointIndex (projectiveVec i) = 0 → ∀ j k : Fin 6, ∀ a b : ZMod 11,
      a • witnessVec j + b • witnessVec k ≠ projectiveVec i := by decide
end RelativeConicArcs.Examples.Q11Coding
