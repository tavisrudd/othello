import RelativeConicArcs.Q25ResidualCoverPrototype.Data

namespace RelativeConicArcs
namespace Q25ResidualCoverPrototype

open Q25ResidualCoverData

set_option maxHeartbeats 300000000
set_option maxRecDepth 100000

theorem prototypeValid_transport : prototypeValid.TransportValid ⟨40, by decide⟩ := by
  unfold ValidRowPayload.TransportValid ValidRowPayload.canonicalConfig rowConfig prototypeValid
  decide

end Q25ResidualCoverPrototype
end RelativeConicArcs
