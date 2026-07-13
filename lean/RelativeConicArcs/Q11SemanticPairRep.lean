import RelativeConicArcs.Q11SemanticPairRepA
import RelativeConicArcs.Q11SemanticPairRepB
import RelativeConicArcs.Q11SemanticPairRepC
import RelativeConicArcs.Q11SemanticPairRepD
namespace RelativeConicArcs.Examples.Q11Coding
private instance : Fact (Nat.Prime 11) := ⟨by decide⟩
theorem distance_two_secant_pair_rep (i : Fin 133) (e : Fin 6 × Fin 6)
    (hd : canonicalSyndromeDistance i = 2) (he : e ∈ witnessPairs)
    (hdet : Matrix.det ![projectiveVec i, witnessVec e.1, witnessVec e.2] = 0) :
    ∃ a b : ZMod 11, a ≠ 0 ∧ b ≠ 0 ∧
      a • witnessVec e.1 + b • witnessVec e.2 = projectiveVec i := by
  by_cases h₁ : i.1 < 34
  · exact distance_two_secant_pair_rep_a i e h₁ hd he hdet
  by_cases h₂ : i.1 < 68
  · exact distance_two_secant_pair_rep_b i e (by omega) h₂ hd he hdet
  by_cases h₃ : i.1 < 102
  · exact distance_two_secant_pair_rep_c i e (by omega) h₃ hd he hdet
  exact distance_two_secant_pair_rep_d i e (by omega) hd he hdet
end RelativeConicArcs.Examples.Q11Coding
