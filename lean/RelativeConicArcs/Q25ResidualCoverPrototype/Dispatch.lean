import RelativeConicArcs.Q25ResidualTransportData.T_031_C_032_081_V_00
import RelativeConicArcs.Q25ResidualTransportData.T_031_C_032_081_V_01

/-!
# Mixed-row dispatcher prototype for the C151 residual cover

This module tests the final payload-dispatch shape on one 50-row leaf. Bad entries reduce only
their stored collinear witness; valid entries reuse the already checked pointwise transport.
-/

namespace RelativeConicArcs
namespace Q25ResidualCoverPrototype

open Q25ResidualCoverData Q25ResidualTransportData

set_option maxHeartbeats 300000000
set_option maxRecDepth 100000

theorem prototypePayloadDispatch (i : Fin 50) :
    (residualCoverRow031C032_081[i]).ValidFor ⟨31, by decide⟩ := by
  fin_cases i <;>
    first
    | exact residualTransportB031C057_payloadValidFor
    | exact residualTransportB031C059_payloadValidFor
    | exact residualTransportB031C060_payloadValidFor
    | exact residualTransportB031C061_payloadValidFor
    | exact residualTransportB031C062_payloadValidFor
    | exact residualTransportB031C063_payloadValidFor
    | exact residualTransportB031C064_payloadValidFor
    | exact residualTransportB031C065_payloadValidFor
    | exact residualTransportB031C066_payloadValidFor
    | exact residualTransportB031C067_payloadValidFor
    | exact residualTransportB031C072_payloadValidFor
    | exact residualTransportB031C073_payloadValidFor
    | exact residualTransportB031C074_payloadValidFor
    | decide

end Q25ResidualCoverPrototype
end RelativeConicArcs
