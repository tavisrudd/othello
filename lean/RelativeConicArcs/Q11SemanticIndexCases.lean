import RelativeConicArcs.Q11SemanticBase
namespace RelativeConicArcs.Examples.Q11Coding
private instance : Fact (Nat.Prime 11) := ⟨by decide⟩
set_option maxHeartbeats 30000000
set_option maxRecDepth 100000
theorem rawPointIndex_cases : ∀ i : Fin 133,
    rawPointIndex (projectiveVec i) = 0 ∨ rawPointIndex (projectiveVec i) = 1 ∨
    rawPointIndex (projectiveVec i) = 2 ∨ rawPointIndex (projectiveVec i) = 3 ∨
    rawPointIndex (projectiveVec i) = 5 := by decide
end RelativeConicArcs.Examples.Q11Coding
