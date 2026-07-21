import RelativeConicArcs.ClebschDoubleCosetDepthBase

/-!
# Negative-sheet secant-depth checks and antipodality

Kernel reduction recounts the three representatives paired with the positive sheet.  Separate
checks establish that the displayed involution carries every positive-sheet secant union to the
corresponding negative-sheet union and that the four oriented counts change sign.
-/

namespace RelativeConicArcs
namespace ClebschDoubleCosetDepth

open ClebschGateway.Q11Matching

set_option maxRecDepth 100000
set_option maxHeartbeats 2000000

/-- The sixteen zero counts of the negative fixed representative. -/
theorem negativeSingleton_zeroCounts :
    (fun r ↦ relationZeroCount (orbitRepresentative 3) r) =
      ![0, 6, 0, 0, 12, 3, 0, 0, 0, 12, 0, 0, 12, 0, 12, 0] := by
  decide

/-- The sixteen zero counts of the negative orbit-four representative. -/
theorem negativeOrbitFour_zeroCounts :
    (fun r ↦ relationZeroCount (orbitRepresentative 4) r) =
      ![0, 6, 0, 0, 12, 0, 3, 3, 6, 3, 3, 6, 3, 3, 3, 6] := by
  decide

/-- The sixteen zero counts of the negative orbit-six representative. -/
theorem negativeOrbitSix_zeroCounts :
    (fun r ↦ relationZeroCount (orbitRepresentative 5) r) =
      ![0, 0, 2, 3, 12, 1, 4, 3, 6, 6, 3, 6, 6, 1, 2, 2] := by
  decide

/-- The three negative representatives have the opposite signed depth profiles. -/
theorem negativeRepresentative_profiles :
    depthProfile (orbitRepresentative 3) = ![6, 0, -12, 12] ∧
    depthProfile (orbitRepresentative 4) = ![3, -3, 0, -3] ∧
    depthProfile (orbitRepresentative 5) = ![-3, 2, 2, 0] := by
  decide

/-- The depth profile is constant on each of the three generated negative-sheet orbits. -/
theorem negative_depth_constant_on_generated_orbits :
    (∀ p ∈ generatedOrbit (orbitRepresentative 3),
      depthProfile p = depthProfile (orbitRepresentative 3)) ∧
    (∀ p ∈ generatedOrbit (orbitRepresentative 4),
      depthProfile p = depthProfile (orbitRepresentative 4)) ∧
    (∀ p ∈ generatedOrbit (orbitRepresentative 5),
      depthProfile p = depthProfile (orbitRepresentative 5)) := by
  decide

/-- On the positive sheet, the involution transports membership in every six-secants union. -/
theorem sheetInvolution_secant_equivariant_positive :
    ∀ p ∈ sheetParents 0, ∀ x,
      liesOnSecantUnion (sheetInvolutionParent p) (sheetInvolutionPoint x) =
        liesOnSecantUnion p x := by
  decide

/-- The geometric sheet involution negates every positive-sheet depth profile. -/
theorem depthProfile_sheetInvolution_positive :
    ∀ p ∈ sheetParents 0,
      depthProfile (sheetInvolutionParent p) = -depthProfile p := by
  decide

/-- On the negative sheet, the singleton depth profile determines its unique matching row. -/
theorem negativeSingleton_profile_recovers_parent :
    ∀ p ∈ sheetParents 1,
      depthProfile p = depthProfile (orbitRepresentative 3) → p = orbitRepresentative 3 := by
  decide

end ClebschDoubleCosetDepth
end RelativeConicArcs
