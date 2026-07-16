import RelativeConicArcs.Q25RowCompositionPrototypeData

/-! Narrow profiling target for the candidate-carrier avoidance obligation. -/

namespace RelativeConicArcs
namespace Q25RowCompositionProfileCarrier

open Q25LineMaskComposition Q25RowCompositionPrototypeData

set_option maxHeartbeats 300000000
set_option maxRecDepth 100000

theorem carrierOnly : CarrierMaskSafe orbit5 orbit58 orbit169 legalMask := by
  decide

end Q25RowCompositionProfileCarrier
end RelativeConicArcs
