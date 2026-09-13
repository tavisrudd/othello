import WeightedRules.OutputConvergence
import WeightedRules.ConvergenceSharpness

/-!
# Sharpness of the output count plus one

For every `m`, one fact coordinate and `m` rule outputs form a predecessor
chain requiring `m + 1` rounds. The initial coordinate has no defining rule.
Thus the fact-loading round is necessary at every output count, independently
of the earlier family proving sharpness of the total scalar bound.
-/

namespace WeightedRules

/-- A chain with one immutable fact and exactly `m` distinct rule outputs. -/
def outputChainProgram (m : Nat) : Program Cost (m + 1) where
  inputs := fun i => if i.val = 0 then ⟨0, by decide⟩ else infinity
  rules := ((List.finRange (m + 1)).filter fun i => i.val != 0).map fun i =>
    { output := i
      left := ⟨i.val - 1, by omega⟩
      right := ⟨i.val - 1, by omega⟩ }

/-- Every coordinate except the initial fact is a rule output. -/
theorem outputChain_rule_outputs (m : Nat) :
    ruleOutputs (outputChainProgram m) = Finset.univ.erase 0 := by
  ext i
  simp only [ruleOutputs, outputChainProgram, List.map_map, Function.comp_apply,
    List.mem_toFinset, List.mem_map,
    List.mem_filter, List.mem_finRange, true_and, bne_iff_ne,
    Finset.mem_erase, Finset.mem_univ, and_true]
  constructor
  · rintro ⟨j, hj, rfl⟩
    intro h
    exact hj (by simpa using congrArg Fin.val h)
  · intro hi
    refine ⟨i, ?_, rfl⟩
    intro h
    apply hi
    apply Fin.ext
    simpa using h

/-- The output count is exactly the family parameter. -/
theorem outputChain_output_count (m : Nat) :
    (ruleOutputs (outputChainProgram m)).card = m := by
  rw [outputChain_rule_outputs]
  simp

private theorem outputChain_step (m : Nat) (x : State Cost (m + 1)) (i : Fin (m + 1)) :
    step boundedMinPlus (outputChainProgram m) x i =
      if i.val = 0 then ⟨0, by decide⟩ else
        costMul (x ⟨i.val - 1, by omega⟩) (x ⟨i.val - 1, by omega⟩) := by
  unfold step outputChainProgram
  rw [indexed_contributions]
  simp only [List.mem_filter, List.mem_finRange, true_and, bne_iff_ne]
  by_cases h : i.val = 0
  · simp [h, boundedMinPlus, costAdd, infinity]
  · simp only [if_neg h, if_pos h]
    rw [boundedMinPlus.add_comm]
    exact boundedMinPlus.add_zero _

/-- A fact propagates by one coordinate per synchronous round. -/
theorem outputChain_iterate (m k : Nat) (i : Fin (m + 1)) :
    iterate boundedMinPlus (outputChainProgram m) k i =
      if i.val < k then ⟨0, by decide⟩ else infinity := by
  induction k generalizing i with
  | zero => simp [iterate, boundedMinPlus, infinity]
  | succ k ih =>
    rw [iterate, outputChain_step]
    by_cases hz : i.val = 0
    · simp [hz]
    · simp only [hz, if_false]
      rw [ih]
      by_cases hi : i.val < k + 1
      · have hp : i.val - 1 < k := by omega
        simp [hi, hp, costMul]
      · have hp : ¬ i.val - 1 < k := by omega
        simp [hi, hp, costMul, infinity]

/-- This chain's bound uses exactly its output count plus one. -/
theorem outputChain_bound (m : Nat) : ruleOutputBound (outputChainProgram m) = m + 1 := by
  simp [ruleOutputBound, outputChain_output_count]

/-- For every output count, the extra loading round is necessary. -/
theorem outputChain_requires_extra_round (m : Nat) :
    iterate boundedMinPlus (outputChainProgram m) m ≠
      iterate boundedMinPlus (outputChainProgram m) (m + 1) := by
  intro h
  have hi := congrFun h ⟨m, by omega⟩
  rw [outputChain_iterate, outputChain_iterate] at hi
  simp only [lt_self_iff_false, if_false, Nat.lt_succ_self, if_true] at hi
  have hv := congrArg Fin.val hi
  change 4294967295 = 0 at hv
  omega

end WeightedRules
