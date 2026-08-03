import RelativeConicArcs.SmallOddRelativeConicWitnessData

/-!
# Basic checks for the order-nineteen witness

Kernel reduction verifies that the ten raw projective points are distinct, avoid the standard
conic, and contain no collinear triple.  Coverage is split into separate modules.
-/

namespace RelativeConicArcs.SmallOddRelativeConicWitnesses

open Certificate SmallOddRelativeConicWitnessData

set_option maxHeartbeats 200000000
set_option maxRecDepth 100000

private instance : Fact (Nat.Prime 19) := ⟨by decide⟩

/-- Every point of the order-nineteen witness avoids the standard conic. -/
theorem q19_rawDisjoint : RawDisjoint q19Witness := by decide

/-- The order-nineteen witness has no repeated projective point and no collinear triple. -/
theorem q19_rawArc : RawArc q19Witness := by decide

end RelativeConicArcs.SmallOddRelativeConicWitnesses
