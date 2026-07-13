import RelativeConicArcs.ExampleChecks.Q16CoverageA
import RelativeConicArcs.ExampleChecks.Q16CoverageB
import RelativeConicArcs.ExampleChecks.Q16CoverageC
import RelativeConicArcs.ExampleChecks.Q16CoverageD
import RelativeConicArcs.ExampleChecks.Q16CoverageTail

namespace RelativeConicArcs.Examples

open Certificate FiniteFields

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

theorem q16_rawCoverage : RawCoverage q16Witness := by
  refine ⟨?_, q16_cov_second, q16_cov_final⟩
  rintro ⟨y⟩
  fin_cases y
  · exact q16_cov_y0
  · exact q16_cov_y1
  · exact q16_cov_y2
  · exact q16_cov_y3
  · exact q16_cov_y4
  · exact q16_cov_y5
  · exact q16_cov_y6
  · exact q16_cov_y7
  · exact q16_cov_y8
  · exact q16_cov_y9
  · exact q16_cov_y10
  · exact q16_cov_y11
  · exact q16_cov_y12
  · exact q16_cov_y13
  · exact q16_cov_y14
  · exact q16_cov_y15

end RelativeConicArcs.Examples
