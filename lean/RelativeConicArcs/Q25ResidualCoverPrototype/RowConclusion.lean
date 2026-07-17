import RelativeConicArcs.Q25ResidualClassLinkData.L_031_C_032_081_V_00

/-!
# Direct residual-row conclusion prototype

This two-row gate tests the final mixed conclusion shape without reducing a generated payload
array.  The bad row closes through its literal collinear witness; the valid row reuses its checked
source-cardinality lower bound.
-/

namespace RelativeConicArcs
namespace Q25ResidualCoverPrototype

open Q25Coordinates Q25MinimumMask Q25ResidualCoverData

def prototypeConclusionC : Fin 2 → Fin 310
  | 0 => ⟨56, by decide⟩
  | 1 => ⟨57, by decide⟩

def prototypeConclusionBad : BadRowPayload :=
  { c := ⟨56, by decide⟩, i := ⟨1, by decide⟩,
    j := ⟨4, by decide⟩, k := ⟨6, by decide⟩ }

theorem prototypeConclusionBad_valid : prototypeConclusionBad.Valid ⟨31, by decide⟩ := by
  decide

theorem prototypeConclusion (i : Fin 2)
    (hraw : RawCap (rowConfig ⟨31, by decide⟩ (prototypeConclusionC i))) :
    32 ≤ (legalOrbitSet (rowConfig ⟨31, by decide⟩ (prototypeConclusionC i))).card := by
  fin_cases i
  · apply (BadRowPayload.not_rawCap prototypeConclusionBad_valid).elim
    simpa [prototypeConclusionBad, prototypeConclusionC] using hraw
  · have hraw' : RawCap (rowConfig ⟨31, by decide⟩
        Q25ResidualTransportData.residualTransportB031C057Payload.c) := by
      simpa [prototypeConclusionC,
        Q25ResidualTransportData.residualTransportB031C057Payload] using hraw
    simpa [prototypeConclusionC,
      Q25ResidualTransportData.residualTransportB031C057Payload] using
        Q25ResidualClassLinkData.residualTransportB031C057_source_card_ge_32 hraw'

end Q25ResidualCoverPrototype
end RelativeConicArcs
