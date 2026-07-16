import RelativeConicArcs.Q25RowCompositionPrototypeData

/-! Narrow profiling target for one split secant-mask avoidance leaf. -/

namespace RelativeConicArcs
namespace Q25RowCompositionProfileAvoidOne

open Q25LineMaskComposition Q25CarrierLineData
open Q25RowCompositionPrototypeData

set_option maxHeartbeats 300000000
set_option maxRecDepth 100000

theorem avoid01 :
    MaskAvoids legalMask (lineMaskOfNumber (secantLineNumber 0 1)) := by
  decide

end Q25RowCompositionProfileAvoidOne
end RelativeConicArcs
