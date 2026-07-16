import RelativeConicArcs.Q25ResidualCoverPrototype.Bad
import RelativeConicArcs.Q25ResidualCoverPrototype.ValidTransport
import RelativeConicArcs.Q25ExactMinimumRows.C_0267

namespace RelativeConicArcs
namespace Q25ResidualCoverPrototype

open Q25MinimumMask Q25ResidualCoverData

theorem prototypeValid_source_card_eq_32
    (hsource : Q25Coordinates.RawCap (rowConfig ⟨40, by decide⟩ prototypeValid.c)) :
    (legalOrbitSet (rowConfig ⟨40, by decide⟩ prototypeValid.c)).card = 32 := by
  calc
    _ = (legalOrbitSet prototypeValid.canonicalConfig).card :=
      ValidRowPayload.legalCard_eq prototypeValid_transport hsource
    _ = 32 := by
      simpa [prototypeValid, ValidRowPayload.canonicalConfig, rowConfig] using
        Q25ExactMinimumRows.class0267LegalOrbitSet_card_eq_32

end Q25ResidualCoverPrototype
end RelativeConicArcs
