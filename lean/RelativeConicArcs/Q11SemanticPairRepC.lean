import RelativeConicArcs.Q11SemanticBase
namespace RelativeConicArcs.Examples.Q11Coding
private instance : Fact (Nat.Prime 11) := ⟨by decide⟩
set_option maxHeartbeats 30000000
set_option maxRecDepth 100000
theorem distance_two_secant_pair_rep_c : ∀ (i : Fin 133) (e : Fin 6 × Fin 6),
    68 ≤ i.1 → i.1 < 102 → canonicalSyndromeDistance i = 2 → e ∈ witnessPairs →
    Matrix.det ![projectiveVec i, witnessVec e.1, witnessVec e.2] = 0 →
    ∃ a b : ZMod 11, a ≠ 0 ∧ b ≠ 0 ∧
      a • witnessVec e.1 + b • witnessVec e.2 = projectiveVec i := by decide
end RelativeConicArcs.Examples.Q11Coding
