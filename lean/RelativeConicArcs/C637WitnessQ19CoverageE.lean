import RelativeConicArcs.C637WitnessData

namespace RelativeConicArcs.C637Witnesses

open Certificate C637WitnessData

set_option maxHeartbeats 200000000
set_option maxRecDepth 100000

private instance : Fact (Nat.Prime 19) := ⟨by decide⟩

theorem q19_ordinary_y16 :
    ∀ z : ZMod 19, RawOrdinaryCovered q19Witness ![1, 16, z] := by decide
theorem q19_ordinary_y17 :
    ∀ z : ZMod 19, RawOrdinaryCovered q19Witness ![1, 17, z] := by decide
theorem q19_ordinary_y18 :
    ∀ z : ZMod 19, RawOrdinaryCovered q19Witness ![1, 18, z] := by decide

end RelativeConicArcs.C637Witnesses
