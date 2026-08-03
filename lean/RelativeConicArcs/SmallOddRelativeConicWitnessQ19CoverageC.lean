import RelativeConicArcs.SmallOddRelativeConicWitnessData

/-!
# Order-nineteen ordinary coverage, affine rows eight through eleven

Kernel reduction verifies secant coverage for every third coordinate in four normalized affine
rows.  The partition is mathematical by coordinate value and bounds elaboration cost.
-/

namespace RelativeConicArcs.SmallOddRelativeConicWitnesses

open Certificate SmallOddRelativeConicWitnessData

set_option maxHeartbeats 200000000
set_option maxRecDepth 100000

private instance : Fact (Nat.Prime 19) := ⟨by decide⟩

/-- Every normalized affine point with second coordinate eight is covered by a witness secant. -/
theorem q19_ordinary_y8 :
    ∀ z : ZMod 19, RawOrdinaryCovered q19Witness ![1, 8, z] := by decide
/-- Every normalized affine point with second coordinate nine is covered by a witness secant. -/
theorem q19_ordinary_y9 :
    ∀ z : ZMod 19, RawOrdinaryCovered q19Witness ![1, 9, z] := by decide
/-- Every normalized affine point with second coordinate ten is covered by a witness secant. -/
theorem q19_ordinary_y10 :
    ∀ z : ZMod 19, RawOrdinaryCovered q19Witness ![1, 10, z] := by decide
/-- Every normalized affine point with second coordinate eleven is covered by a witness secant. -/
theorem q19_ordinary_y11 :
    ∀ z : ZMod 19, RawOrdinaryCovered q19Witness ![1, 11, z] := by decide

end RelativeConicArcs.SmallOddRelativeConicWitnesses
