import RelativeConicArcs.Examples

namespace RelativeConicArcs.Examples

open Certificate FiniteFields

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

theorem q16_cov_y0 :
    ∀ z : GF16, RawCovered q16Witness ![1, GF16.ofNat 0, z] := by decide

theorem q16_cov_y1 :
    ∀ z : GF16, RawCovered q16Witness ![1, GF16.ofNat 1, z] := by decide

theorem q16_cov_y2 :
    ∀ z : GF16, RawCovered q16Witness ![1, GF16.ofNat 2, z] := by decide

theorem q16_cov_y3 :
    ∀ z : GF16, RawCovered q16Witness ![1, GF16.ofNat 3, z] := by decide

end RelativeConicArcs.Examples
