import RelativeConicArcs.SmallOddRelativeConicWitnessData

/-!
# Order-nineteen ordinary coverage, affine rows sixteen through eighteen

Kernel reduction verifies secant coverage for every third coordinate in the final three normalized
affine rows.  The other affine rows and projective charts are checked in adjacent bounded modules.
-/

namespace RelativeConicArcs.SmallOddRelativeConicWitnesses

open Certificate SmallOddRelativeConicWitnessData

set_option maxHeartbeats 200000000
set_option maxRecDepth 100000

private instance : Fact (Nat.Prime 19) := ⟨by decide⟩

/-- Every normalized affine point with second coordinate sixteen is covered by a witness secant. -/
theorem q19_ordinary_y16 :
    ∀ z : ZMod 19, RawOrdinaryCovered q19Witness ![1, 16, z] := by decide
/-- Every normalized affine point with second coordinate seventeen is covered by a witness secant. -/
theorem q19_ordinary_y17 :
    ∀ z : ZMod 19, RawOrdinaryCovered q19Witness ![1, 17, z] := by decide
/-- Every normalized affine point with second coordinate eighteen is covered by a witness secant. -/
theorem q19_ordinary_y18 :
    ∀ z : ZMod 19, RawOrdinaryCovered q19Witness ![1, 18, z] := by decide

end RelativeConicArcs.SmallOddRelativeConicWitnesses
