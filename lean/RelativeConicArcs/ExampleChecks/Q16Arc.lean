import RelativeConicArcs.Examples

namespace RelativeConicArcs.Examples

open Certificate

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

theorem q16_rawArc : RawArc q16Witness := by decide

end RelativeConicArcs.Examples
