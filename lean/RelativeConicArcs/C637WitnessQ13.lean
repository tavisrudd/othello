import RelativeConicArcs.C637WitnessData

namespace RelativeConicArcs.C637Witnesses

open Certificate Conic C637WitnessData

set_option maxHeartbeats 200000000
set_option maxRecDepth 100000

private instance : Fact (Nat.Prime 13) := ⟨by decide⟩

theorem q13_check : check q13Witness = true := by decide

theorem rhoC_ZMod13_le_eight : rhoC (K := ZMod 13) ≤ 8 := by
  simpa [q13Witness] using rhoC_le_length_of_check q13_check

end RelativeConicArcs.C637Witnesses
