import RelativeConicArcs.C637WitnessData

namespace RelativeConicArcs.C637Witnesses

open Certificate C637WitnessData

set_option maxHeartbeats 200000000
set_option maxRecDepth 100000

private instance : Fact (Nat.Prime 19) := ⟨by decide⟩

theorem q19_ordinary_y0 :
    ∀ z : ZMod 19, RawOrdinaryCovered q19Witness ![1, 0, z] := by decide
theorem q19_ordinary_y1 :
    ∀ z : ZMod 19, RawOrdinaryCovered q19Witness ![1, 1, z] := by decide
theorem q19_ordinary_y2 :
    ∀ z : ZMod 19, RawOrdinaryCovered q19Witness ![1, 2, z] := by decide
theorem q19_ordinary_y3 :
    ∀ z : ZMod 19, RawOrdinaryCovered q19Witness ![1, 3, z] := by decide

end RelativeConicArcs.C637Witnesses
