import RelativeConicArcs.C637WitnessData

namespace RelativeConicArcs.C637Witnesses

open Certificate C637WitnessData

set_option maxHeartbeats 200000000
set_option maxRecDepth 100000

private instance : Fact (Nat.Prime 19) := ⟨by decide⟩

theorem q19_ordinary_y8 :
    ∀ z : ZMod 19, RawOrdinaryCovered q19Witness ![1, 8, z] := by decide
theorem q19_ordinary_y9 :
    ∀ z : ZMod 19, RawOrdinaryCovered q19Witness ![1, 9, z] := by decide
theorem q19_ordinary_y10 :
    ∀ z : ZMod 19, RawOrdinaryCovered q19Witness ![1, 10, z] := by decide
theorem q19_ordinary_y11 :
    ∀ z : ZMod 19, RawOrdinaryCovered q19Witness ![1, 11, z] := by decide

end RelativeConicArcs.C637Witnesses
