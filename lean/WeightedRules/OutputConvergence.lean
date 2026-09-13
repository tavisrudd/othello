import WeightedRules.Convergence

/-!
# Convergence counted by distinct rule outputs

A bounded min-plus program on `n` coordinates is fixed after at most
`min n (m + 1)` rounds, where `m` counts distinct rule outputs. The first round
loads facts. Every subsequent improvement must occur at a rule output, so a
late-improvement counting argument counts only those coordinates. Duplicate
rules and the number of immutable input coordinates do not increase `m`.

The theorem includes empty programs and programs with no rules. It preserves
the original scalar-count certificate bound and uses ordinary kernel proofs.
-/

namespace WeightedRules

variable {W : Type} {n : Nat}

/-- The distinct scalar coordinates occurring as outputs of grounded rules. -/
def ruleOutputs (P : Program W n) : Finset (Fin n) :=
  (P.rules.map (·.output)).toFinset

/-- The rule-output round bound, capped by the total scalar count. -/
def ruleOutputBound (P : Program W n) : Nat := min n ((ruleOutputs P).card + 1)

private theorem late_improvement_coordinates (P : Program Cost n) (k : Nat) (i : Fin n)
    (h : (iterate boundedMinPlus P (k + 2) i).val <
      (iterate boundedMinPlus P (k + 1) i).val) :
    ∃ s : Finset (Fin n), s ⊆ ruleOutputs P ∧ s.card = k + 1 ∧
      ∀ j ∈ s, (iterate boundedMinPlus P (k + 2) j).val ≤
        (iterate boundedMinPlus P (k + 2) i).val := by
  induction k generalizing i with
  | zero =>
    obtain ⟨hi, _⟩ := boundedMinPlus_step_improvement P
      (iterate boundedMinPlus P 1) (iterate boundedMinPlus P 0) i h
    refine ⟨{i}, ?_, by simp, by simp⟩
    intro j hj
    have hj' : j = i := Finset.mem_singleton.mp hj
    subst j
    exact List.mem_toFinset.mpr hi
  | succ k ih =>
    obtain ⟨hi, j, hj, hjcost⟩ := boundedMinPlus_step_improvement P
      (iterate boundedMinPlus P (k + 2)) (iterate boundedMinPlus P (k + 1)) i h
    obtain ⟨s, hsub, hcard, hs⟩ := ih j hj
    have hnot : i ∉ s := by
      intro hi'
      have := hs i hi'
      change (iterate boundedMinPlus P (k + 3) i).val <
        (iterate boundedMinPlus P (k + 2) i).val at h
      change (iterate boundedMinPlus P (k + 2) j).val ≤
        (iterate boundedMinPlus P (k + 3) i).val at hjcost
      omega
    refine ⟨insert i s, ?_, ?_, ?_⟩
    · intro a ha
      rcases Finset.mem_insert.mp ha with rfl | ha
      · exact List.mem_toFinset.mpr hi
      · exact hsub ha
    · rw [Finset.card_insert_of_notMem hnot, hcard]
    · intro a ha
      rcases Finset.mem_insert.mp ha with rfl | ha
      · exact le_rfl
      · exact le_trans (boundedMinPlus_iterate_succ_cost P (k + 2) a)
          (le_trans (hs a ha) hjcost)

private theorem fixed_after_outputs (P : Program Cost n) :
    step boundedMinPlus P (iterate boundedMinPlus P ((ruleOutputs P).card + 1)) =
      iterate boundedMinPlus P ((ruleOutputs P).card + 1) := by
  funext i
  apply Fin.ext
  have hle := boundedMinPlus_iterate_succ_cost P ((ruleOutputs P).card + 1) i
  change (iterate boundedMinPlus P ((ruleOutputs P).card + 2) i).val = _
  by_contra hne
  have hlt : (iterate boundedMinPlus P ((ruleOutputs P).card + 2) i).val <
      (iterate boundedMinPlus P ((ruleOutputs P).card + 1) i).val := by
    change (iterate boundedMinPlus P ((ruleOutputs P).card + 2) i).val ≤ _ at hle
    omega
  obtain ⟨s, hsub, hcard, _⟩ := late_improvement_coordinates P (ruleOutputs P).card i hlt
  have := Finset.card_le_card hsub
  omega

/-- Every bounded min-plus program is fixed within one round beyond its number
of distinct rule outputs, capped by its total scalar count. -/
theorem boundedMinPlus_rule_output_fixed (P : Program Cost n) :
    step boundedMinPlus P (iterate boundedMinPlus P (ruleOutputBound P)) =
      iterate boundedMinPlus P (ruleOutputBound P) := by
  by_cases h : n ≤ (ruleOutputs P).card + 1
  · simp only [ruleOutputBound, min_eq_left h]
    exact boundedMinPlus_iterate_fixed P
  · have h' : (ruleOutputs P).card + 1 ≤ n := by omega
    simp only [ruleOutputBound, min_eq_right h']
    exact fixed_after_outputs P

/-- A convergence certificate at the tighter rule-output bound, admitted under
the existing total scalar-count bound. -/
def ruleOutputCertificate (P : Program Cost n) : Certificate boundedMinPlus P n where
  rounds := ruleOutputBound P
  within := min_le_left _ _
  fixed := boundedMinPlus_rule_output_fixed P

/-- The rule-output-bound iterate is the least fixed valuation. -/
theorem boundedMinPlus_rule_output_least (P : Program Cost n) :
    step boundedMinPlus P (iterate boundedMinPlus P (ruleOutputBound P)) =
      iterate boundedMinPlus P (ruleOutputBound P) ∧
    ∀ y, step boundedMinPlus P y = y → StateLe boundedMinPlus
      (iterate boundedMinPlus P (ruleOutputBound P)) y :=
  certificate_least boundedMinPlus P n (ruleOutputCertificate P)

end WeightedRules
