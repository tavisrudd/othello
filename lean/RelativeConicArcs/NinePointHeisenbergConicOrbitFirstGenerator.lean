import RelativeConicArcs.NinePointHeisenbergConicCensus

/-!
# First generator action on the six-point conics

Kernel reduction checks that the first displayed Heisenberg generator translates the first label
coordinate on all nine six-point conics.
-/

namespace RelativeConicArcs
namespace NinePointHeisenbergConicOrbitFirstGenerator

open NinePointHeisenbergPair NinePointHeisenbergIncidence NinePointHeisenbergConicCensus

set_option maxHeartbeats 800000000
set_option maxRecDepth 100000

/-- The first Heisenberg generator translates the first label coordinate on the nine conics. -/
theorem first_generator_translates_six_point_conics :
    labels.all (fun selectedLabel =>
      mapsRationalConic g (chosenSixPointConic selectedLabel)
        (chosenSixPointConic
          (selectedLabel.1 + 1, selectedLabel.2))) = true := by
  decide +kernel

end NinePointHeisenbergConicOrbitFirstGenerator
end RelativeConicArcs
