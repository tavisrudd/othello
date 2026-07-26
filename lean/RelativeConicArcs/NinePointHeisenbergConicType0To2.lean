import RelativeConicArcs.NinePointHeisenbergConicTable

/-! # Conic point types for normalized conics 1 through 3

Kernel reduction checks the discriminant-square and exact rational secant definitions at every
selected-orbit point for this three-conic block.
-/
namespace RelativeConicArcs.NinePointHeisenbergConicType0To2
open NinePointHeisenbergConicCensus NinePointHeisenbergConicTable
set_option maxHeartbeats 800000000
set_option maxRecDepth 100000
/-- The two point-type definitions agree on normalized conics 1 through 3. -/
theorem agreement : (conicTable.take 3).all conicTypeAgreement = true := by decide +kernel
end RelativeConicArcs.NinePointHeisenbergConicType0To2
