import RelativeConicArcs.NinePointHeisenbergConicTable

/-! # Conic point types for normalized conics 76 through 78

Kernel reduction checks the discriminant-square and exact rational secant definitions at every
selected-orbit point for this three-conic block.
-/
namespace RelativeConicArcs.NinePointHeisenbergConicType75To77
open NinePointHeisenbergConicCensus NinePointHeisenbergConicTable
set_option maxHeartbeats 800000000
set_option maxRecDepth 100000
/-- The two point-type definitions agree on normalized conics 76 through 78. -/
theorem agreement : ((conicTable.drop 75).take 3).all conicTypeAgreement = true := by decide +kernel
end RelativeConicArcs.NinePointHeisenbergConicType75To77
