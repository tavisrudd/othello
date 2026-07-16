import RelativeConicArcs.Q25RowCompositionPrototypeData

/-!
# C151 row-composition prototype

The literal data live in `Q25RowCompositionPrototypeData`; this module assembles the four checked
obligations into the paper-facing lower bound.
-/

namespace RelativeConicArcs
namespace Q25RowCompositionPrototype

open Q25Coordinates Q25PairCertificate Q25MinimumMask Q25LineMaskComposition
open Q25RowCompositionPrototypeData

set_option maxHeartbeats 300000000
set_option maxRecDepth 100000

def secantCertificate :
    SecantCompositionCertificate orbit5 orbit58 orbit169 legalMask where
  lineNumber := secantLineNumber
  scale := secantScale
  witness := by decide
  symmetric := by decide
  avoids := by decide

theorem freshMaskSafe : FreshMaskSafe orbit5 orbit58 orbit169 legalMask := by
  decide

theorem carrierMaskSafe : CarrierMaskSafe orbit5 orbit58 orbit169 legalMask := by
  decide

def rowCertificate : RowCompositionCertificate orbit5 orbit58 orbit169 legalMask where
  card_le := by decide
  fresh := freshMaskSafe
  secants := secantCertificate
  carrier := carrierMaskSafe

theorem reflectedMaskCertificate :
    ReflectedMaskCertificate (normalizedConfig orbit5 orbit58 orbit169) legalMask :=
  rowCertificate.toReflectedMaskCertificate

theorem legalOrbitSet_card_ge_32 :
    32 ≤ (legalOrbitSet (normalizedConfig orbit5 orbit58 orbit169)).card :=
  card_legalOrbitSet_ge_32
    (normalizedConfig_isConjInvariant orbit5 orbit58 orbit169)
    reflectedMaskCertificate

end Q25RowCompositionPrototype
end RelativeConicArcs
