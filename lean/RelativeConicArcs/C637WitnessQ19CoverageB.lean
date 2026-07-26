import RelativeConicArcs.C637WitnessData

namespace RelativeConicArcs.C637Witnesses

open Certificate C637WitnessData

set_option maxHeartbeats 200000000
set_option maxRecDepth 100000

private instance : Fact (Nat.Prime 19) := ⟨by decide⟩

theorem q19_ordinary_y4 :
    ∀ z : ZMod 19, RawOrdinaryCovered q19Witness ![1, 4, z] := by decide
theorem q19_ordinary_y5 :
    ∀ z : ZMod 19, RawOrdinaryCovered q19Witness ![1, 5, z] := by decide
theorem q19_ordinary_y6 :
    ∀ z : ZMod 19, RawOrdinaryCovered q19Witness ![1, 6, z] := by decide
theorem q19_ordinary_y7 :
    ∀ z : ZMod 19, RawOrdinaryCovered q19Witness ![1, 7, z] := by decide

end RelativeConicArcs.C637Witnesses
