import RelativeConicArcs.C637WitnessData

namespace RelativeConicArcs.C637Witnesses

open Certificate Conic C637WitnessData

set_option maxHeartbeats 200000000
set_option maxRecDepth 100000

private instance : Fact (Nat.Prime 17) := ⟨by decide⟩

theorem q17_check : check q17Witness = true := by decide

theorem rhoC_ZMod17_le_nine : rhoC (K := ZMod 17) ≤ 9 := by
  simpa [q17Witness] using rhoC_le_length_of_check q17_check

end RelativeConicArcs.C637Witnesses
