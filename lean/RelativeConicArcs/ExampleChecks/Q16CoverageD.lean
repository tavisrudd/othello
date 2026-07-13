import RelativeConicArcs.Examples

namespace RelativeConicArcs.Examples

open Certificate FiniteFields

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

theorem q16_cov_y12 :
    ∀ z : GF16, RawCovered q16Witness ![1, GF16.ofNat 12, z] := by decide

theorem q16_cov_y13 :
    ∀ z : GF16, RawCovered q16Witness ![1, GF16.ofNat 13, z] := by decide

theorem q16_cov_y14 :
    ∀ z : GF16, RawCovered q16Witness ![1, GF16.ofNat 14, z] := by decide

theorem q16_cov_y15 :
    ∀ z : GF16, RawCovered q16Witness ![1, GF16.ofNat 15, z] := by decide

end RelativeConicArcs.Examples
