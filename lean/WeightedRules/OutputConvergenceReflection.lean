import WeightedRules.OutputConvergence
import WeightedRules.IncrementalReflection

/-!
# Checked certificates at the rule-output bound

The iterate at the capped rule-output bound equals the scalar-count iterate.
It can therefore supply a checked solution directly, or replace the logical
round count of an already checked solution without changing its values.
Incremental results retain their replay work count and can optionally convert
to this bound instead of the total scalar count. It need not reduce the round
count of a certificate that already stopped early. No certificate schema or
admission rule changes.
-/

namespace WeightedRules

variable {n : Nat}

/-- The rule-output and total-scalar bounds produce the same least valuation. -/
theorem ruleOutput_iterate_eq_scalar (P : Program Cost n) :
    iterate boundedMinPlus P (ruleOutputBound P) = iterate boundedMinPlus P n :=
  certificates_agree boundedMinPlus P n n (ruleOutputCertificate P) (boundedMinPlusCertificate P)

/-- The structural bound also suffices from any seed below the least solution. -/
theorem iterateFrom_rule_output_bound (P : Program Cost n) (seed : State Cost n)
    (hseed : StateLe boundedMinPlus seed (iterate boundedMinPlus P n)) :
    iterateFrom boundedMinPlus P seed (ruleOutputBound P) =
      iterate boundedMinPlus P n := by
  funext i
  apply info_antisymm boundedMinPlus
  · exact iterateFrom_le_fixed boundedMinPlus P seed _ hseed
      (boundedMinPlus_iterate_fixed P) (ruleOutputBound P) i
  · rw [← ruleOutput_iterate_eq_scalar P]
    exact iterate_le_iterateFrom boundedMinPlus P seed (ruleOutputBound P) i

/-- An old least solution reaches the new one by the rule-output bound after
an admitted fact improvement. -/
theorem improved_iterateFrom_rule_output_bound (P Q : Program Cost n)
    (h : ImprovesFacts boundedMinPlus P Q) :
    iterateFrom boundedMinPlus Q (iterate boundedMinPlus P n) (ruleOutputBound Q) =
      iterate boundedMinPlus Q n :=
  iterateFrom_rule_output_bound Q _ (iterate_le_of_improves boundedMinPlus P Q h n)

/-- Construct an existing-format checked solution using the rule-output bound. -/
def ruleOutputCheckedSolution (P : Program Cost n) : CheckedSolution P where
  rounds := ruleOutputBound P
  values := List.ofFn (iterate boundedMinPlus P (ruleOutputBound P))
  accepted := by
    unfold checkCertificate
    apply decide_eq_true
    rw [listState_ofFn]
    exact ⟨List.length_ofFn, min_le_left _ _, fun _ => rfl,
      fun i => congrFun (boundedMinPlus_rule_output_fixed P) i⟩

/-- Retain a checked valuation while replacing its logical from-zero round count
by the capped rule-output bound. -/
def CheckedSolution.withRuleOutputBound {P : Program Cost n} (s : CheckedSolution P) :
    CheckedSolution P where
  rounds := ruleOutputBound P
  values := s.values
  accepted := by
    unfold checkCertificate
    apply decide_eq_true
    refine ⟨(of_decide_eq_true s.accepted).1, min_le_left _ _, ?_, ?_⟩
    · intro i
      exact congrFun ((ruleOutput_iterate_eq_scalar P).trans s.eq_iterate.symm) i
    · exact fun i => congrFun s.least.1 i

/-- Convert an incremental proof without changing its returned valuation.
The new round count is a from-zero bound, distinct from the incremental work count. -/
def CheckedImprovement.toRuleOutputSolution {P Q : Program Cost n} {old : CheckedSolution P}
    (c : CheckedImprovement old Q) : CheckedSolution Q :=
  c.toCheckedSolution.withRuleOutputBound

end WeightedRules
