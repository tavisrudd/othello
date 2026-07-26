import RelativeConicArcs.NinePointHeisenbergConicCensus

/-!
# Second generator action on the six-point conics

Kernel reduction checks that the second displayed Heisenberg generator translates the second
label coordinate on all nine six-point conics.
-/

namespace RelativeConicArcs
namespace NinePointHeisenbergConicOrbitSecondGenerator

open NinePointHeisenbergPair NinePointHeisenbergIncidence NinePointHeisenbergConicCensus

set_option maxHeartbeats 800000000
set_option maxRecDepth 100000

/-- The second Heisenberg generator translates the second label coordinate on the nine conics. -/
theorem second_generator_translates_six_point_conics :
    labels.all (fun selectedLabel =>
      mapsRationalConic h (chosenSixPointConic selectedLabel)
        (chosenSixPointConic
          (selectedLabel.1, selectedLabel.2 + 1))) = true := by
  decide +kernel

end NinePointHeisenbergConicOrbitSecondGenerator
end RelativeConicArcs
