import RelativeConicArcs.SmallOddRelativeConicWitnessData

/-!
# Order-nineteen ordinary coverage outside the first affine chart

Kernel reduction verifies the second normalized affine chart and the remaining projective point.
Together with the row modules, these statements exhaust the projective plane over `ZMod 19`.
-/

namespace RelativeConicArcs.SmallOddRelativeConicWitnesses

open Certificate SmallOddRelativeConicWitnessData

set_option maxHeartbeats 200000000
set_option maxRecDepth 100000

private instance : Fact (Nat.Prime 19) := ⟨by decide⟩

/-- Every point in the second normalized affine chart is covered by a witness secant. -/
theorem q19_ordinary_second :
    ∀ z : ZMod 19, RawOrdinaryCovered q19Witness ![0, 1, z] := by decide

/-- The remaining projective point is covered by a witness secant. -/
theorem q19_ordinary_final :
    RawOrdinaryCovered q19Witness ![0, 0, 1] := by decide

end RelativeConicArcs.SmallOddRelativeConicWitnesses
