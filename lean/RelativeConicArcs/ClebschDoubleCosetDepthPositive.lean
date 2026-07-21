import RelativeConicArcs.ClebschDoubleCosetDepthBase

/-!
# Positive-sheet secant-depth checks

Kernel reduction recounts the sixteen relation cells for one representative of each positive-sheet
tetrahedral orbit.  It also checks constancy of the four signed counts on all eleven matching rows
generated from those representatives.  The displayed count vectors are theorem conclusions, not
input to the depth function.
-/

namespace RelativeConicArcs
namespace ClebschDoubleCosetDepth

set_option maxRecDepth 100000
set_option maxHeartbeats 2000000

/-- The sixteen zero counts of the fixed positive representative. -/
theorem positiveSingleton_zeroCounts :
    (fun r ↦ relationZeroCount (orbitRepresentative 0) r) =
      ![0, 0, 0, 0, 12, 3, 12, 0, 0, 0, 6, 12, 12, 0, 0, 0] := by
  decide

/-- The sixteen zero counts of the positive orbit-four representative. -/
theorem positiveOrbitFour_zeroCounts :
    (fun r ↦ relationZeroCount (orbitRepresentative 1) r) =
      ![0, 3, 0, 3, 12, 0, 3, 3, 6, 6, 6, 3, 3, 0, 3, 6] := by
  decide

/-- The sixteen zero counts of the positive orbit-six representative. -/
theorem positiveOrbitSix_zeroCounts :
    (fun r ↦ relationZeroCount (orbitRepresentative 2) r) =
      ![0, 3, 2, 1, 12, 1, 2, 3, 6, 6, 0, 6, 6, 3, 4, 2] := by
  decide

/-- The three positive representatives have the claimed signed depth profiles. -/
theorem positiveRepresentative_profiles :
    depthProfile (orbitRepresentative 0) = ![-6, 0, 12, -12] ∧
    depthProfile (orbitRepresentative 1) = ![-3, 3, 0, 3] ∧
    depthProfile (orbitRepresentative 2) = ![3, -2, -2, 0] := by
  decide

/-- The depth profile is constant on each of the three generated positive-sheet orbits. -/
theorem positive_depth_constant_on_generated_orbits :
    (∀ p ∈ generatedOrbit (orbitRepresentative 0),
      depthProfile p = depthProfile (orbitRepresentative 0)) ∧
    (∀ p ∈ generatedOrbit (orbitRepresentative 1),
      depthProfile p = depthProfile (orbitRepresentative 1)) ∧
    (∀ p ∈ generatedOrbit (orbitRepresentative 2),
      depthProfile p = depthProfile (orbitRepresentative 2)) := by
  decide

/-- On the positive sheet, the singleton depth profile determines its unique matching row. -/
theorem positiveSingleton_profile_recovers_parent :
    ∀ p ∈ ClebschGateway.Q11Matching.sheetParents 0,
      depthProfile p = depthProfile (orbitRepresentative 0) → p = orbitRepresentative 0 := by
  decide

end ClebschDoubleCosetDepth
end RelativeConicArcs
