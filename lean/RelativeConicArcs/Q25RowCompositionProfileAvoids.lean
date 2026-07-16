import RelativeConicArcs.Q25RowCompositionPrototypeData

/-! Narrow profiling target for the secant-mask avoidance obligation. -/

namespace RelativeConicArcs
namespace Q25RowCompositionProfileAvoids

open Q25PairCertificate Q25LineMaskComposition Q25CarrierLineData
open Q25RowCompositionPrototypeData

set_option maxHeartbeats 300000000
set_option maxRecDepth 100000

theorem avoidsOnly :
    ∀ i j : Fin 8, i < j →
      MaskWordDisjoint legalMask (lineMaskOfNumber (secantLineNumber i j)) := by
  decide

end Q25RowCompositionProfileAvoids
end RelativeConicArcs
