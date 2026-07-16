import RelativeConicArcs.Q25ResidualTransportData.T_031_C_032_081_V_00
import RelativeConicArcs.Q25RowCompositionData.C_0015_0019

/-!
# Canonical-class link prototype for the C151 residual cover

This module connects one transported payload's canonical coordinates to the literal row-composition
class at its stored class index. The class theorem, rather than the stored `legalCount`, supplies
the semantic lower bound.
-/

namespace RelativeConicArcs
namespace Q25ResidualCoverPrototype

open Q25Coordinates Q25PairCertificate Q25MinimumMask Q25ResidualCoverData Q25ResidualTransportData
  Q25RowCompositionData

theorem prototypeCanonicalClassLink :
    residualTransportB031C057Payload.canonicalConfig =
      normalizedConfig class0017A class0017B class0017C := by
  rfl

theorem prototypeCanonicalClass_card_ge_32 :
    32 ≤ (legalOrbitSet residualTransportB031C057Payload.canonicalConfig).card := by
  rw [prototypeCanonicalClassLink]
  exact class0017LegalOrbitSet_card_ge_32

end Q25ResidualCoverPrototype
end RelativeConicArcs
