import WeightedRules.Convergence

/-!
# Convergence counted by distinct rule outputs

A bounded min-plus program on `n` coordinates is fixed after at most
`min n (m + 1)` rounds, where `m` counts distinct rule outputs. The first round
loads facts. Every subsequent improvement must occur at a rule output, so a
late-improvement counting argument counts only those coordinates. Duplicate
rules and the number of immutable input coordinates do not increase `m`.

The theorem includes empty programs and programs with no rules. It preserves
the original scalar-count certificate bound. The bound `ruleOutputBound` and
its proof are the ordered inflationary instance of
`WeightedRules.OrderedInflationary.rule_output_fixed`; this module restates
them for the bounded min-plus carrier with ordinary kernel proofs.
-/

namespace WeightedRules

variable {n : Nat}

/-- Every bounded min-plus program is fixed within one round beyond its number
of distinct rule outputs, capped by its total scalar count. -/
theorem boundedMinPlus_rule_output_fixed (P : Program Cost n) :
    step boundedMinPlus P (iterate boundedMinPlus P (ruleOutputBound P)) =
      iterate boundedMinPlus P (ruleOutputBound P) :=
  boundedMinPlus_orderedInflationary.rule_output_fixed P

/-- A convergence certificate at the tighter rule-output bound, admitted under
the existing total scalar-count bound. -/
def ruleOutputCertificate (P : Program Cost n) : Certificate boundedMinPlus P n :=
  boundedMinPlus_orderedInflationary.ruleOutputCertificate P

/-- The rule-output-bound iterate is the least fixed valuation. -/
theorem boundedMinPlus_rule_output_least (P : Program Cost n) :
    step boundedMinPlus P (iterate boundedMinPlus P (ruleOutputBound P)) =
      iterate boundedMinPlus P (ruleOutputBound P) ∧
    ∀ y, step boundedMinPlus P y = y → StateLe boundedMinPlus
      (iterate boundedMinPlus P (ruleOutputBound P)) y :=
  certificate_least boundedMinPlus P n (ruleOutputCertificate P)

end WeightedRules
