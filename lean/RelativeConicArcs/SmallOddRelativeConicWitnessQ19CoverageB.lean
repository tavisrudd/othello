import RelativeConicArcs.SmallOddRelativeConicWitnessData

/-!
# Order-nineteen ordinary coverage, affine rows four through seven

Kernel reduction verifies secant coverage for every third coordinate in four normalized affine
rows.  The partition is mathematical by coordinate value and bounds elaboration cost.
-/

namespace RelativeConicArcs.SmallOddRelativeConicWitnesses

open Certificate SmallOddRelativeConicWitnessData

set_option maxHeartbeats 200000000
set_option maxRecDepth 100000

private instance : Fact (Nat.Prime 19) := ⟨by decide⟩

/-- Every normalized affine point with second coordinate four is covered by a witness secant. -/
theorem q19_ordinary_y4 :
    ∀ z : ZMod 19, RawOrdinaryCovered q19Witness ![1, 4, z] := by decide
/-- Every normalized affine point with second coordinate five is covered by a witness secant. -/
theorem q19_ordinary_y5 :
    ∀ z : ZMod 19, RawOrdinaryCovered q19Witness ![1, 5, z] := by decide
/-- Every normalized affine point with second coordinate six is covered by a witness secant. -/
theorem q19_ordinary_y6 :
    ∀ z : ZMod 19, RawOrdinaryCovered q19Witness ![1, 6, z] := by decide
/-- Every normalized affine point with second coordinate seven is covered by a witness secant. -/
theorem q19_ordinary_y7 :
    ∀ z : ZMod 19, RawOrdinaryCovered q19Witness ![1, 7, z] := by decide

end RelativeConicArcs.SmallOddRelativeConicWitnesses
