import RelativeConicArcs.Examples

namespace RelativeConicArcs.Examples

open Certificate FiniteFields

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

theorem q16_cov_y8 :
    ∀ z : GF16, RawCovered q16Witness ![1, GF16.ofNat 8, z] := by decide

theorem q16_cov_y9 :
    ∀ z : GF16, RawCovered q16Witness ![1, GF16.ofNat 9, z] := by decide

theorem q16_cov_y10 :
    ∀ z : GF16, RawCovered q16Witness ![1, GF16.ofNat 10, z] := by decide

theorem q16_cov_y11 :
    ∀ z : GF16, RawCovered q16Witness ![1, GF16.ofNat 11, z] := by decide

end RelativeConicArcs.Examples
