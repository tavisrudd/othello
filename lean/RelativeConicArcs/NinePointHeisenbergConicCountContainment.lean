import RelativeConicArcs.NinePointHeisenbergConicCensus

/-!
# Incidence of five-subset conics

Kernel reduction checks that every normalized signed-minor form vanishes on the five explicit
uncovered-orbit points used to construct it.
-/

namespace RelativeConicArcs
namespace NinePointHeisenbergConicCountContainment

open NinePointHeisenbergPair NinePointHeisenbergConicCensus

set_option maxHeartbeats 800000000
set_option maxRecDepth 100000

/-- Every normalized signed-minor form vanishes on the five uncovered points that define it. -/
theorem each_conic_contains_its_five_subset :
    (fiveSubsetIndexLists.zip fiveSubsetConics).all (fun entry =>
      entry.1.all fun index =>
        quadraticValue entry.2 (NinePointHeisenbergPair.uncovered.get index) = 0) = true := by
  decide +kernel

end NinePointHeisenbergConicCountContainment
end RelativeConicArcs
