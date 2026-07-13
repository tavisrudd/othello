import RelativeConicArcs.Examples

namespace RelativeConicArcs.Examples

open Certificate

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

theorem q9_check : check q9Witness = true := by decide

end RelativeConicArcs.Examples
