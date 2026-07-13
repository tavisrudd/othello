import RelativeConicArcs.Examples

namespace RelativeConicArcs.Examples

open Certificate

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

theorem q8_check : check q8Witness = true := by decide

end RelativeConicArcs.Examples
