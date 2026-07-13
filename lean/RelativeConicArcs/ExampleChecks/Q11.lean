import RelativeConicArcs.Examples

namespace RelativeConicArcs.Examples

open Certificate

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

private instance : Fact (Nat.Prime 11) := ⟨by decide⟩

theorem q11_check : check q11Witness = true := by decide

end RelativeConicArcs.Examples
