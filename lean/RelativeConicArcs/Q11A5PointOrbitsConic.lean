import RelativeConicArcs.Q11A5PointOrbitsData

/-! The standard-conic equation on the 133 canonical Q11 points. -/

namespace RelativeConicArcs.Examples.Q11A5PointOrbits

set_option maxHeartbeats 100000000
set_option maxRecDepth 100000

private instance : Fact (Nat.Prime 11) := ⟨by decide⟩

/-- Membership in the displayed twelve-set is exactly XZ-Y²=0. -/
theorem mem_standardConicIndices_iff :
    ∀ p : PointIndex,
      p ∈ standardConicIndices ↔ pointVec p 0 * pointVec p 2 = pointVec p 1 ^ 2 := by
  intro p
  fin_cases p <;> decide

end RelativeConicArcs.Examples.Q11A5PointOrbits
