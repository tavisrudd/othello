import RelativeConicArcs.Q11SemanticTwoRepA
import RelativeConicArcs.Q11SemanticTwoRepB
import RelativeConicArcs.Q11SemanticTwoRepC
import RelativeConicArcs.Q11SemanticTwoRepD
namespace RelativeConicArcs.Examples.Q11Coding
private instance : Fact (Nat.Prime 11) := ⟨by decide⟩
set_option maxHeartbeats 30000000
set_option maxRecDepth 100000
theorem nonzero_nonfive_has_two_presentation : ∀ i : Fin 133,
    rawPointIndex (projectiveVec i) ≠ 0 → rawPointIndex (projectiveVec i) ≠ 5 →
    ∃ j k : Fin 6, j < k ∧ ∃ a b : ZMod 11,
      a ≠ 0 ∧ b ≠ 0 ∧ a • witnessVec j + b • witnessVec k = projectiveVec i := by
  intro i hzero hfive
  by_cases h₁ : i.1 < 34
  · exact nonzero_nonfive_has_two_presentation_a i h₁ hzero hfive
  by_cases h₂ : i.1 < 68
  · exact nonzero_nonfive_has_two_presentation_b i (by omega) h₂ hzero hfive
  by_cases h₃ : i.1 < 102
  · exact nonzero_nonfive_has_two_presentation_c i (by omega) h₃ hzero hfive
  exact nonzero_nonfive_has_two_presentation_d i (by omega) hzero hfive
end RelativeConicArcs.Examples.Q11Coding
