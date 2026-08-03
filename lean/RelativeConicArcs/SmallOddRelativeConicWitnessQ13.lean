import RelativeConicArcs.SmallOddRelativeConicWitnessData

/-!
# Order-thirteen relative-conic witness

Kernel reduction checks the eight displayed projective points for the arc, conic-avoidance, and
prescribed-conic coverage predicates used by `Certificate.check`.  The resulting theorem is an
upper bound only; no exhaustive lower-bound classification is imported.
-/

namespace RelativeConicArcs.SmallOddRelativeConicWitnesses

open Certificate Conic SmallOddRelativeConicWitnessData

set_option maxHeartbeats 200000000
set_option maxRecDepth 100000

private instance : Fact (Nat.Prime 13) := ⟨by decide⟩

/-- Kernel reduction accepts the order-thirteen witness certificate. -/
theorem q13_check : check q13Witness = true := by decide

/-- The least size of an arc complete outside a conic over `ZMod 13` is at most eight. -/
theorem rhoC_ZMod13_le_eight : rhoC (K := ZMod 13) ≤ 8 := by
  simpa [q13Witness] using rhoC_le_length_of_check q13_check

end RelativeConicArcs.SmallOddRelativeConicWitnesses
