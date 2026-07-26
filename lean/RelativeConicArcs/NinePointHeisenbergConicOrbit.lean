import RelativeConicArcs.NinePointHeisenbergConicOrbitRelative
import RelativeConicArcs.NinePointHeisenbergConicOrbitFirstGenerator
import RelativeConicArcs.NinePointHeisenbergConicOrbitSecondGenerator
import RelativeConicArcs.NinePointHeisenbergConicOrbitTangent

/-!
# The orbit of six-point conics

The relative-label profile, two generator actions, and tangent profile are checked in separate
bounded kernel computations.  This module collects their conclusions without repeating those
computations.
-/

namespace RelativeConicArcs
namespace NinePointHeisenbergConicOrbit

open NinePointHeisenbergIncidence NinePointHeisenbergConicCensus

/--
For each selected orbit label there is exactly one six-point conic, and its omitted uncovered
labels are the three displayed translates.
-/
theorem six_point_conics_have_relative_orbit_profile :
    labels.all (fun selectedLabel =>
      distinctConics.countP (hasRelativeSixPointProfile selectedLabel) = 1) = true :=
  NinePointHeisenbergConicOrbitRelative.six_point_conics_have_relative_orbit_profile

/-- The first Heisenberg generator translates the first label coordinate on the nine conics. -/
theorem first_generator_translates_six_point_conics :
    labels.all (fun selectedLabel =>
      mapsRationalConic NinePointHeisenbergPair.g (chosenSixPointConic selectedLabel)
        (chosenSixPointConic
          (selectedLabel.1 + 1, selectedLabel.2))) = true :=
  NinePointHeisenbergConicOrbitFirstGenerator.first_generator_translates_six_point_conics

/-- The second Heisenberg generator translates the second label coordinate on the nine conics. -/
theorem second_generator_translates_six_point_conics :
    labels.all (fun selectedLabel =>
      mapsRationalConic NinePointHeisenbergPair.h (chosenSixPointConic selectedLabel)
        (chosenSixPointConic
          (selectedLabel.1, selectedLabel.2 + 1))) = true :=
  NinePointHeisenbergConicOrbitSecondGenerator.second_generator_translates_six_point_conics

/-- At the unique selected point of every six-point conic, the tangent contains no uncovered
point and no second selected point. -/
theorem six_point_conic_tangent_profile :
    distinctConics.all closestConicTangentProfile = true :=
  NinePointHeisenbergConicOrbitTangent.six_point_conic_tangent_profile

end NinePointHeisenbergConicOrbit
end RelativeConicArcs
