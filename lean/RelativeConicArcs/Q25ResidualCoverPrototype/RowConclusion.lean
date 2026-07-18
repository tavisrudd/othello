import RelativeConicArcs.Q25ResidualDispatchData.D_R_031_C_032_081
import RelativeConicArcs.Q25ResidualClassLinkData.L_031_C_032_081_V_00
import RelativeConicArcs.Q25ResidualClassLinkData.L_031_C_032_081_V_01

/-!
# Residual-row conclusion prototype

This leaf-shaped gate composes the checked mixed-row dispatcher with the canonical-class lower
bounds.  Bad rows close through the dispatcher's collinear witness; valid rows reuse its checked
transport and the corresponding canonical bound.
-/

namespace RelativeConicArcs
namespace Q25ResidualCoverPrototype

open Q25Coordinates Q25MinimumMask Q25ResidualCoverData

set_option maxHeartbeats 300000000
set_option maxRecDepth 100000

theorem prototypeRowConclusion (i : Fin 50)
    (hraw : RawCap (rowConfig ⟨31, by decide⟩
      (residualCoverRow031C032_081[i]).c)) :
    32 ≤ (legalOrbitSet (rowConfig ⟨31, by decide⟩
      (residualCoverRow031C032_081[i]).c)).card := by
  have hvalid := Q25ResidualDispatchData.dispatchR_031_C_032_081 i
  fin_cases i
  · exact (BadRowPayload.not_rawCap hvalid hraw).elim
  · exact (BadRowPayload.not_rawCap hvalid hraw).elim
  · exact (BadRowPayload.not_rawCap hvalid hraw).elim
  · exact (BadRowPayload.not_rawCap hvalid hraw).elim
  · exact (BadRowPayload.not_rawCap hvalid hraw).elim
  · exact (BadRowPayload.not_rawCap hvalid hraw).elim
  · exact (BadRowPayload.not_rawCap hvalid hraw).elim
  · exact (BadRowPayload.not_rawCap hvalid hraw).elim
  · exact (BadRowPayload.not_rawCap hvalid hraw).elim
  · exact (BadRowPayload.not_rawCap hvalid hraw).elim
  · exact (BadRowPayload.not_rawCap hvalid hraw).elim
  · exact (BadRowPayload.not_rawCap hvalid hraw).elim
  · exact (BadRowPayload.not_rawCap hvalid hraw).elim
  · exact (BadRowPayload.not_rawCap hvalid hraw).elim
  · exact (BadRowPayload.not_rawCap hvalid hraw).elim
  · exact (BadRowPayload.not_rawCap hvalid hraw).elim
  · exact (BadRowPayload.not_rawCap hvalid hraw).elim
  · exact (BadRowPayload.not_rawCap hvalid hraw).elim
  · exact (BadRowPayload.not_rawCap hvalid hraw).elim
  · exact (BadRowPayload.not_rawCap hvalid hraw).elim
  · exact (BadRowPayload.not_rawCap hvalid hraw).elim
  · exact (BadRowPayload.not_rawCap hvalid hraw).elim
  · exact (BadRowPayload.not_rawCap hvalid hraw).elim
  · exact (BadRowPayload.not_rawCap hvalid hraw).elim
  · exact (BadRowPayload.not_rawCap hvalid hraw).elim
  · exact ValidRowPayload.source_card_ge_of_canonical hvalid hraw
      Q25ResidualClassLinkData.residualTransportB031C057_canonical_card_ge_32
  · exact (BadRowPayload.not_rawCap hvalid hraw).elim
  · exact ValidRowPayload.source_card_ge_of_canonical hvalid hraw
      Q25ResidualClassLinkData.residualTransportB031C059_canonical_card_ge_32
  · exact ValidRowPayload.source_card_ge_of_canonical hvalid hraw
      Q25ResidualClassLinkData.residualTransportB031C060_canonical_card_ge_32
  · exact ValidRowPayload.source_card_ge_of_canonical hvalid hraw
      Q25ResidualClassLinkData.residualTransportB031C061_canonical_card_ge_32
  · exact ValidRowPayload.source_card_ge_of_canonical hvalid hraw
      Q25ResidualClassLinkData.residualTransportB031C062_canonical_card_ge_32
  · exact ValidRowPayload.source_card_ge_of_canonical hvalid hraw
      Q25ResidualClassLinkData.residualTransportB031C063_canonical_card_ge_32
  · exact ValidRowPayload.source_card_ge_of_canonical hvalid hraw
      Q25ResidualClassLinkData.residualTransportB031C064_canonical_card_ge_32
  · exact ValidRowPayload.source_card_ge_of_canonical hvalid hraw
      Q25ResidualClassLinkData.residualTransportB031C065_canonical_card_ge_32
  · exact ValidRowPayload.source_card_ge_of_canonical hvalid hraw
      Q25ResidualClassLinkData.residualTransportB031C066_canonical_card_ge_32
  · exact ValidRowPayload.source_card_ge_of_canonical hvalid hraw
      Q25ResidualClassLinkData.residualTransportB031C067_canonical_card_ge_32
  · exact (BadRowPayload.not_rawCap hvalid hraw).elim
  · exact (BadRowPayload.not_rawCap hvalid hraw).elim
  · exact (BadRowPayload.not_rawCap hvalid hraw).elim
  · exact (BadRowPayload.not_rawCap hvalid hraw).elim
  · exact ValidRowPayload.source_card_ge_of_canonical hvalid hraw
      Q25ResidualClassLinkData.residualTransportB031C072_canonical_card_ge_32
  · exact ValidRowPayload.source_card_ge_of_canonical hvalid hraw
      Q25ResidualClassLinkData.residualTransportB031C073_canonical_card_ge_32
  · exact ValidRowPayload.source_card_ge_of_canonical hvalid hraw
      Q25ResidualClassLinkData.residualTransportB031C074_canonical_card_ge_32
  · exact (BadRowPayload.not_rawCap hvalid hraw).elim
  · exact (BadRowPayload.not_rawCap hvalid hraw).elim
  · exact (BadRowPayload.not_rawCap hvalid hraw).elim
  · exact (BadRowPayload.not_rawCap hvalid hraw).elim
  · exact (BadRowPayload.not_rawCap hvalid hraw).elim
  · exact (BadRowPayload.not_rawCap hvalid hraw).elim
  · exact (BadRowPayload.not_rawCap hvalid hraw).elim

end Q25ResidualCoverPrototype
end RelativeConicArcs
