import WeightedRules.Oracle

/-!
# Adversarial external certificate controls

The executable fixture deliberately returns malformed metadata, an out-of-range
cost, a failed process status, or an unsupported zero-valued self-loop. Expected
elaboration errors establish rejection at the actual oracle entry point. A valid
infinity-valued self-loop is accepted, so failure to invoke the fixture cannot
masquerade as successful rejection. The fixture supplies no Lean source.
-/

namespace WeightedRules

private def selfLoop : Program Cost 1 := ⟨fun _ => infinity, [⟨0, 0, 0⟩]⟩

private def acceptedLoop : CheckedSolution selfLoop :=
  ergodis_solution selfLoop from "valid" via "WeightedRules/fixtures/rejection-oracle"

example : IsLeastFixed selfLoop (listState acceptedLoop.values) := acceptedLoop.least

/-- error: Ergodis certificate: unsupported certificate schema -/
#guard_msgs in
example : CheckedSolution selfLoop :=
  ergodis_solution selfLoop from "schema" via "WeightedRules/fixtures/rejection-oracle"

/-- error: Ergodis certificate: invalid certificate dimensions or round bound -/
#guard_msgs in
example : CheckedSolution selfLoop :=
  ergodis_solution selfLoop from "coverage" via "WeightedRules/fixtures/rejection-oracle"

/-- error: Ergodis certificate: invalid certificate dimensions or round bound -/
#guard_msgs in
example : CheckedSolution selfLoop :=
  ergodis_solution selfLoop from "rounds" via "WeightedRules/fixtures/rejection-oracle"

/-- error: Ergodis certificate: cost outside bounded carrier -/
#guard_msgs in
example : CheckedSolution selfLoop :=
  ergodis_solution selfLoop from "range" via "WeightedRules/fixtures/rejection-oracle"

/-- error: Ergodis certificate: invalid source identity encoding -/
#guard_msgs in
example : CheckedSolution selfLoop :=
  ergodis_solution selfLoop from "identity" via "WeightedRules/fixtures/rejection-oracle"

/-- error: Ergodis oracle failed (exit 7) -/
#guard_msgs in
example : CheckedSolution selfLoop :=
  ergodis_solution selfLoop from "exit" via "WeightedRules/fixtures/rejection-oracle"

/-- error: Ergodis certificate failed kernel replay -/
#guard_msgs in
example : CheckedSolution selfLoop :=
  ergodis_solution selfLoop from "unsupported" via "WeightedRules/fixtures/rejection-oracle"

private def differentProgram : Program Cost 1 := ⟨fun _ => ⟨7, by decide⟩, []⟩

/-- error: Ergodis certificate failed kernel replay -/
#guard_msgs in
example : CheckedSolution differentProgram :=
  ergodis_solution differentProgram from "valid" via "WeightedRules/fixtures/rejection-oracle"

end WeightedRules
