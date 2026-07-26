import RelativeConicArcs.C637WitnessData

namespace RelativeConicArcs.C637Witnesses

open Certificate C637WitnessData

set_option maxHeartbeats 200000000
set_option maxRecDepth 100000

private instance : Fact (Nat.Prime 19) := ⟨by decide⟩

theorem q19_ordinary_second :
    ∀ z : ZMod 19, RawOrdinaryCovered q19Witness ![0, 1, z] := by decide

theorem q19_ordinary_final :
    RawOrdinaryCovered q19Witness ![0, 0, 1] := by decide

end RelativeConicArcs.C637Witnesses
