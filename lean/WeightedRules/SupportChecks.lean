import WeightedRules.Oracle

/-!
# Support certificate controls

The zero-valued self-loop is fixed but unsupported: with the rule as witness
its rank cannot decrease, and with the base fact as witness its value differs
from the absent fact. Both are rejected by the direct checker and at the
external entry point. The infinity valuation is accepted, so a failure to
invoke the fixture cannot masquerade as rejection. The executable fixture
also exercises the resource policy: a producer that floods its output is cut
off at the byte limit. The fixture supplies no Lean source.
-/

namespace WeightedRules

private def selfLoop : Program Cost 1 := ⟨fun _ => infinity, [⟨0, 0, 0⟩]⟩

/-- The direct checker rejects the unsupported zero cycle under both witnesses. -/
theorem selfLoop_zero_unsupported :
    checkSupportCertificate selfLoop [⟨0, by decide⟩] [0] [1] = false ∧
      checkSupportCertificate selfLoop [⟨0, by decide⟩] [0] [0] = false ∧
      checkSupportCertificate selfLoop [⟨0, by decide⟩] [5] [1] = false := by
  decide +kernel

/-- The infinity valuation is supported. -/
theorem selfLoop_infinity_supported :
    checkSupportCertificate selfLoop [infinity] [0] [0] = true := by
  decide +kernel

private def acceptedLoop : SupportedSolution selfLoop :=
  ergodis_support_solution selfLoop from "valid" via "WeightedRules/fixtures/rejection-oracle"

example : IsLeastFixed selfLoop (listState acceptedLoop.values) := acceptedLoop.least

/-- error: Ergodis support certificate failed kernel check -/
#guard_msgs in
example : SupportedSolution selfLoop :=
  ergodis_support_solution selfLoop from "cycle" via "WeightedRules/fixtures/rejection-oracle"

/-- error: Ergodis support certificate failed kernel check -/
#guard_msgs in
example : SupportedSolution selfLoop :=
  ergodis_support_solution selfLoop from "fact" via "WeightedRules/fixtures/rejection-oracle"

/-- error: Ergodis certificate: invalid certificate dimensions -/
#guard_msgs in
example : SupportedSolution selfLoop :=
  ergodis_support_solution selfLoop from "coverage" via "WeightedRules/fixtures/rejection-oracle"

/-- error: Ergodis certificate: certificate exceeds byte limit -/
#guard_msgs in
example : SupportedSolution selfLoop :=
  ergodis_support_solution selfLoop from "flood" via "WeightedRules/fixtures/rejection-oracle"

/-- error: Ergodis oracle: explicit executable must be a relative path without parent segments -/
#guard_msgs in
example : SupportedSolution selfLoop :=
  ergodis_support_solution selfLoop from "valid" via "../WeightedRules/fixtures/rejection-oracle"

/-- The replay route rejects the same unsupported cycle through the ordinary
certificate, so the two checkers agree on the control. -/
theorem selfLoop_replay_rejects :
    checkCertificate selfLoop 1 [⟨0, by decide⟩] = false := by
  decide +kernel

end WeightedRules
