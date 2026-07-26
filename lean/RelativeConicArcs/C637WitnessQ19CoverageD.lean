import RelativeConicArcs.C637WitnessData

namespace RelativeConicArcs.C637Witnesses

open Certificate C637WitnessData

set_option maxHeartbeats 200000000
set_option maxRecDepth 100000

private instance : Fact (Nat.Prime 19) := ⟨by decide⟩

theorem q19_ordinary_y12 :
    ∀ z : ZMod 19, RawOrdinaryCovered q19Witness ![1, 12, z] := by decide
theorem q19_ordinary_y13 :
    ∀ z : ZMod 19, RawOrdinaryCovered q19Witness ![1, 13, z] := by decide
theorem q19_ordinary_y14 :
    ∀ z : ZMod 19, RawOrdinaryCovered q19Witness ![1, 14, z] := by decide
theorem q19_ordinary_y15 :
    ∀ z : ZMod 19, RawOrdinaryCovered q19Witness ![1, 15, z] := by decide

end RelativeConicArcs.C637Witnesses
