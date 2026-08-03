import RelativeConicArcs.SmallOddRelativeConicWitnessData

/-!
# Order-seventeen relative-conic witness

Kernel reduction checks the nine displayed projective points for the arc, conic-avoidance, and
prescribed-conic coverage predicates used by `Certificate.check`.  The resulting theorem is an
upper bound only; no exhaustive lower-bound classification is imported.
-/

namespace RelativeConicArcs.SmallOddRelativeConicWitnesses

open Certificate Conic SmallOddRelativeConicWitnessData

set_option maxHeartbeats 200000000
set_option maxRecDepth 100000

private instance : Fact (Nat.Prime 17) := ⟨by decide⟩

/-- Kernel reduction accepts the order-seventeen witness certificate. -/
theorem q17_check : check q17Witness = true := by decide

/-- The least size of an arc complete outside a conic over `ZMod 17` is at most nine. -/
theorem rhoC_ZMod17_le_nine : rhoC (K := ZMod 17) ≤ 9 := by
  simpa [q17Witness] using rhoC_le_length_of_check q17_check

end RelativeConicArcs.SmallOddRelativeConicWitnesses
