import RelativeConicArcs.Q11A5PointOrbitsData

/-! Small global summaries of the Q11 A5 support action. -/

namespace RelativeConicArcs.Examples.Q11A5PointOrbits

set_option maxHeartbeats 100000000
set_option maxRecDepth 100000

/-- The displayed support family contains the identity. -/
theorem support_family_identity : ∀ i : Fin 6, supportPerm 0 i = i := by decide

/-- The icosahedral order histogram has 24 elements of order five. -/
theorem order_five_count :
    ((Finset.univ : Finset GroupIndex).filter OrderFive).card = 24 := by decide

end RelativeConicArcs.Examples.Q11A5PointOrbits
