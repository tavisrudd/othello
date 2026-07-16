import RelativeConicArcs.Q25RowCompositionPrototypeData

/-! Narrow profiling target for the secant line-witness obligation. -/

namespace RelativeConicArcs
namespace Q25RowCompositionProfileWitness

open Q25PairCertificate Q25LineMaskChecker Q25CarrierLineData
open Q25RowCompositionPrototypeData

set_option maxHeartbeats 300000000
set_option maxRecDepth 100000

theorem witnessOnly :
    ∀ i j : Fin 8, configPoint orbit5 orbit58 orbit169 i ≠
        configPoint orbit5 orbit58 orbit169 j →
      LineWitnessValid (configPoint orbit5 orbit58 orbit169 i)
        (configPoint orbit5 orbit58 orbit169 j)
        (lineOfNumber (secantLineNumber i j)) (secantScale i j) := by
  decide

end Q25RowCompositionProfileWitness
end RelativeConicArcs
