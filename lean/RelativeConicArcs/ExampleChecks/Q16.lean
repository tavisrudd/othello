import RelativeConicArcs.ExampleChecks.Q16Disjoint
import RelativeConicArcs.ExampleChecks.Q16Arc
import RelativeConicArcs.ExampleChecks.Q16Coverage

namespace RelativeConicArcs.Examples

open Certificate

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

theorem q16_check : check q16Witness = true := by
  simp only [check, Bool.and_eq_true]
  exact ⟨⟨decide_eq_true q16_rawDisjoint, decide_eq_true q16_rawArc⟩,
    decide_eq_true q16_rawCoverage⟩

end RelativeConicArcs.Examples
