import RelativeConicArcs.SmallOddRelativeConicWitnessData

/-!
# Order-nineteen ordinary coverage, affine rows twelve through fifteen

Kernel reduction verifies secant coverage for every third coordinate in four normalized affine
rows.  The partition is mathematical by coordinate value and bounds elaboration cost.
-/

namespace RelativeConicArcs.SmallOddRelativeConicWitnesses

open Certificate SmallOddRelativeConicWitnessData

set_option maxHeartbeats 200000000
set_option maxRecDepth 100000

private instance : Fact (Nat.Prime 19) := ⟨by decide⟩

/-- Every normalized affine point with second coordinate twelve is covered by a witness secant. -/
theorem q19_ordinary_y12 :
    ∀ z : ZMod 19, RawOrdinaryCovered q19Witness ![1, 12, z] := by decide
/-- Every normalized affine point with second coordinate thirteen is covered by a witness secant. -/
theorem q19_ordinary_y13 :
    ∀ z : ZMod 19, RawOrdinaryCovered q19Witness ![1, 13, z] := by decide
/-- Every normalized affine point with second coordinate fourteen is covered by a witness secant. -/
theorem q19_ordinary_y14 :
    ∀ z : ZMod 19, RawOrdinaryCovered q19Witness ![1, 14, z] := by decide
/-- Every normalized affine point with second coordinate fifteen is covered by a witness secant. -/
theorem q19_ordinary_y15 :
    ∀ z : ZMod 19, RawOrdinaryCovered q19Witness ![1, 15, z] := by decide

end RelativeConicArcs.SmallOddRelativeConicWitnesses
