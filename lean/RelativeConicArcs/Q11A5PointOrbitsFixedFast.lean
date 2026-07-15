import RelativeConicArcs.Q11A5PointOrbitsArithmetic

/-! The single reflected fixed-point-union certificate for the Q11 A5 action. -/

namespace RelativeConicArcs.Examples.Q11A5PointOrbits

set_option maxHeartbeats 100000000
set_option maxRecDepth 100000

private instance : Fact (Nat.Prime 11) := ⟨by decide⟩

theorem orderFiveFixedUnionFast_eq_expected :
    orderFiveFixedUnionFast = witnessSet ∪ standardConicIndices := by
  decide

end RelativeConicArcs.Examples.Q11A5PointOrbits
