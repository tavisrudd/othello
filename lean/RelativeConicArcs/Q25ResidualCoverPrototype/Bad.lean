import RelativeConicArcs.Q25ResidualCoverPrototype.Data

namespace RelativeConicArcs
namespace Q25ResidualCoverPrototype

open Q25Coordinates Q25PairCertificate Q25ResidualCoverData

set_option maxHeartbeats 300000000
set_option maxRecDepth 100000

theorem prototypeBad_valid : prototypeBad.Valid ⟨6, by decide⟩ := by
  decide

theorem prototypeBad_not_rawCap :
    ¬ RawCap (rowConfig ⟨6, by decide⟩ prototypeBad.c) :=
  BadRowPayload.not_rawCap prototypeBad_valid

end Q25ResidualCoverPrototype
end RelativeConicArcs
