import RelativeConicArcs.Q11SemanticBase

namespace RelativeConicArcs.Examples.Q11Coding

private instance : Fact (Nat.Prime 11) := ⟨by decide⟩
set_option maxHeartbeats 30000000
set_option maxRecDepth 100000

/-- The canonical projective directions of a fixed secant index. -/
def directionsOfIndex (r : ℕ) : Finset (Fin 133) :=
  Finset.univ.filter fun i => rawPointIndex (projectiveVec i) = r

/-- Exact projective secant-index spectrum. -/
theorem secant_index_spectrum :
    (directionsOfIndex 0).card = 12 ∧
    (directionsOfIndex 1).card = 90 ∧
    (directionsOfIndex 2).card = 15 ∧
    (directionsOfIndex 3).card = 10 ∧
    (directionsOfIndex 5).card = 6 := by
  decide

end RelativeConicArcs.Examples.Q11Coding
