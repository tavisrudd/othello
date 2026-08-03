import RelativeConicArcs.SmallOddRelativeConicWitnessData

/-!
# Order-nineteen ordinary coverage, affine rows zero through three

Kernel reduction verifies secant coverage for every third coordinate in four normalized affine
rows.  The remaining rows and projective charts are checked in adjacent bounded modules.
-/

namespace RelativeConicArcs.SmallOddRelativeConicWitnesses

open Certificate SmallOddRelativeConicWitnessData

set_option maxHeartbeats 200000000
set_option maxRecDepth 100000

private instance : Fact (Nat.Prime 19) := ⟨by decide⟩

/-- Every normalized affine point with second coordinate zero is covered by a witness secant. -/
theorem q19_ordinary_y0 :
    ∀ z : ZMod 19, RawOrdinaryCovered q19Witness ![1, 0, z] := by decide
/-- Every normalized affine point with second coordinate one is covered by a witness secant. -/
theorem q19_ordinary_y1 :
    ∀ z : ZMod 19, RawOrdinaryCovered q19Witness ![1, 1, z] := by decide
/-- Every normalized affine point with second coordinate two is covered by a witness secant. -/
theorem q19_ordinary_y2 :
    ∀ z : ZMod 19, RawOrdinaryCovered q19Witness ![1, 2, z] := by decide
/-- Every normalized affine point with second coordinate three is covered by a witness secant. -/
theorem q19_ordinary_y3 :
    ∀ z : ZMod 19, RawOrdinaryCovered q19Witness ![1, 3, z] := by decide

end RelativeConicArcs.SmallOddRelativeConicWitnesses
