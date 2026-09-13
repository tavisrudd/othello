import WeightedRules.OutputConvergenceReflection
import WeightedRules.OutputConvergenceSharpness
import WeightedRules.ChainDistance
import WeightedRules.IncrementalExample

/-!
# Rule-output round-bound controls

The bound is zero on an empty program and at most one without rules. It remains
sharp on the predecessor-chain family for every positive scalar count. On the
grounded four- and six-vertex distance programs, it is five and seven instead
of the total scalar counts twenty-one and forty-three. These bounds need not
be the first fixed round of an individual program.
-/

namespace WeightedRules

/-- Empty programs need zero rounds under the capped bound. -/
theorem empty_rule_output_bound (P : Program Cost 0) : ruleOutputBound P = 0 := by
  simp [ruleOutputBound]

/-- Programs without rules need at most the initial fact-loading round. -/
theorem no_rules_output_bound {n : Nat} (facts : State Cost n) :
    ruleOutputBound (⟨facts, []⟩ : Program Cost n) = min n 1 := rfl

/-- One immutable fact feeds one rule output; the fact loads before its product. -/
def oneOutputProgram : Program Cost 2 where
  inputs := fun i => if i.val = 0 then ⟨0, by decide⟩ else infinity
  rules := [⟨1, 0, 0⟩]

/-- Counting only rule outputs without the initial fact-loading round is unsound. -/
theorem rule_output_extra_round_needed :
    (ruleOutputs oneOutputProgram).card = 1 ∧ ruleOutputBound oneOutputProgram = 2 ∧
    iterate boundedMinPlus oneOutputProgram 1 1 ≠
      iterate boundedMinPlus oneOutputProgram 2 1 := by
  decide +kernel

/-- The predecessor-chain family has all its coordinates among the rule outputs. -/
theorem zeroChain_rule_outputs (n : Nat) : ruleOutputs (zeroChainProgram n) = Finset.univ := by
  ext i
  simp [ruleOutputs, zeroChainProgram]

/-- The capped rule-output bound equals the scalar count on the sharp chain family. -/
theorem zeroChain_rule_output_bound (n : Nat) : ruleOutputBound (zeroChainProgram n) = n := by
  simp [ruleOutputBound, zeroChain_rule_outputs]

/-- The rule-output bound is attained on a chain of every positive scalar count. -/
theorem zeroChain_rule_output_sharp (n : Nat) (hn : 0 < n) :
    iterate boundedMinPlus (zeroChainProgram n) (ruleOutputBound (zeroChainProgram n) - 1) ≠
      iterate boundedMinPlus (zeroChainProgram n) (ruleOutputBound (zeroChainProgram n)) := by
  rw [zeroChain_rule_output_bound]
  exact zeroChain_requires_scalar_rounds n hn

/-- Grounded distance rules yield bounds five and seven, independently of their
sixteen and thirty-six immutable edge coordinates. -/
theorem distance_rule_output_bounds :
    ruleOutputBound distanceProgram = 5 ∧ ruleOutputBound improvedDistanceProgram = 5 ∧
    ruleOutputBound chainDistanceProgram = 7 := by
  decide +kernel

/-- An external incremental witness converts to bound five with identical values;
its original three-step replay count and default bound twenty-one remain intact. -/
theorem improved_distance_output_conversion :
    oracleImprovedDistance.toRuleOutputSolution.rounds = 5 ∧
    oracleImprovedDistance.toRuleOutputSolution.values = oracleImprovedDistance.values ∧
    oracleImprovedDistance.rounds = 3 ∧ oracleImprovedDistance.toCheckedSolution.rounds = 21 := by
  decide +kernel

/-- The converted external witness retains leastness under the tighter bound. -/
theorem improved_distance_output_least :
    IsLeastFixed improvedDistanceProgram (listState oracleImprovedDistance.toRuleOutputSolution.values) :=
  oracleImprovedDistance.toRuleOutputSolution.least

end WeightedRules
