import RelativeConicArcs.Q25RowCompositionPrototypeData

/-! Narrow profiling target for the freshness obligation. -/

namespace RelativeConicArcs
namespace Q25RowCompositionProfileFresh

open Q25LineMaskComposition Q25RowCompositionPrototypeData

set_option maxHeartbeats 300000000
set_option maxRecDepth 100000

theorem freshOnly : FreshMaskSafe orbit5 orbit58 orbit169 legalMask := by
  decide

end Q25RowCompositionProfileFresh
end RelativeConicArcs
