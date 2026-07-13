import RelativeConicArcs.Examples

namespace RelativeConicArcs.Examples

open Certificate FiniteFields

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

theorem q16_cov_y4 :
    ∀ z : GF16, RawCovered q16Witness ![1, GF16.ofNat 4, z] := by decide

theorem q16_cov_y5 :
    ∀ z : GF16, RawCovered q16Witness ![1, GF16.ofNat 5, z] := by decide

theorem q16_cov_y6 :
    ∀ z : GF16, RawCovered q16Witness ![1, GF16.ofNat 6, z] := by decide

theorem q16_cov_y7 :
    ∀ z : GF16, RawCovered q16Witness ![1, GF16.ofNat 7, z] := by decide

end RelativeConicArcs.Examples
