import RelativeConicArcs.Examples

namespace RelativeConicArcs.Examples

open Certificate FiniteFields

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

theorem q16_cov_second : ∀ z : GF16, RawCovered q16Witness ![0, 1, z] := by decide

theorem q16_cov_final : RawCovered q16Witness ![0, 0, 1] := by decide

end RelativeConicArcs.Examples
