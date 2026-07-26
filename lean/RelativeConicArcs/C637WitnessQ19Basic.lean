import RelativeConicArcs.C637WitnessData

namespace RelativeConicArcs.C637Witnesses

open Certificate C637WitnessData

set_option maxHeartbeats 200000000
set_option maxRecDepth 100000

private instance : Fact (Nat.Prime 19) := ⟨by decide⟩

theorem q19_rawDisjoint : RawDisjoint q19Witness := by decide

theorem q19_rawArc : RawArc q19Witness := by decide

end RelativeConicArcs.C637Witnesses
