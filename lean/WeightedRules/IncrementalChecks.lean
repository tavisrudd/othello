import WeightedRules.IncrementalReflection

/-!
# Incremental certificate boundary controls

One-coordinate self-product programs exercise fact improvements, zero-round
no-ops, chained certificates and invalid updates. Retraction of a zero-cost
fact leaves zero as an unsupported algebraic fixed point; source compatibility
rejects its reuse. The raw incremental predicate requires an independently
checked old solution, as demonstrated by a false seed that passes local replay
but fails the old from-zero checker. All controls use kernel reduction.
-/

namespace WeightedRules

private def selfProduct (fact : Cost) : Program Cost 1 :=
  ⟨fun _ => fact, [⟨0, 0, 0⟩]⟩

private def fiveSolution : CheckedSolution (selfProduct ⟨5, by decide⟩) where
  rounds := 1
  values := [⟨5, by decide⟩]
  accepted := by decide +kernel

/-- A one-round decrease from five to three is a checked fact improvement. -/
def fiveToThree : CheckedImprovement fiveSolution (selfProduct ⟨3, by decide⟩) where
  rounds := 1
  values := [⟨3, by decide⟩]
  accepted := by decide +kernel

/-- A converted improvement can seed another checked improvement. -/
def threeToOne : CheckedImprovement fiveToThree.toCheckedSolution (selfProduct ⟨1, by decide⟩) where
  rounds := 1
  values := [⟨1, by decide⟩]
  accepted := by decide +kernel

/-- A no-op may use zero replay rounds. -/
theorem zero_round_improvement :
    checkImprovementCertificate (selfProduct ⟨5, by decide⟩) (selfProduct ⟨5, by decide⟩)
      fiveSolution.values 0 fiveSolution.values = true := by
  decide +kernel

/-- A changed rule list is rejected even when the proposed valuation still
solves the new equations. -/
theorem changed_rules_rejected :
    checkImprovementCertificate (selfProduct ⟨5, by decide⟩)
      ⟨fun _ => ⟨5, by decide⟩, []⟩ fiveSolution.values 0 fiveSolution.values = false := by
  decide +kernel

/-- Retracting a supporting zero fact cannot reuse the resulting unsupported
zero fixed point, despite successful local replay and fixedness. -/
theorem retraction_rejected :
    step boundedMinPlus (selfProduct infinity) (fun _ => ⟨0, by decide⟩) =
      (fun _ => ⟨0, by decide⟩) ∧
    checkImprovementCertificate (selfProduct ⟨0, by decide⟩) (selfProduct infinity)
      [⟨0, by decide⟩] 1 [⟨0, by decide⟩] = false := by
  decide +kernel

/-- Exact old/new coverage, the replay bound and actual replayed values are
checked independently of fixedness. -/
theorem incremental_rejection_controls :
    checkImprovementCertificate (selfProduct ⟨5, by decide⟩) (selfProduct ⟨3, by decide⟩)
      [] 1 [⟨3, by decide⟩] = false ∧
    checkImprovementCertificate (selfProduct ⟨5, by decide⟩) (selfProduct ⟨3, by decide⟩)
      fiveSolution.values 1 [] = false ∧
    checkImprovementCertificate (selfProduct ⟨5, by decide⟩) (selfProduct ⟨3, by decide⟩)
      fiveSolution.values 2 [⟨3, by decide⟩] = false ∧
    checkImprovementCertificate (selfProduct ⟨5, by decide⟩) (selfProduct ⟨3, by decide⟩)
      fiveSolution.values 1 [⟨0, by decide⟩] = false := by
  decide +kernel

/-- Local replay alone cannot authenticate the old seed. The incremental
soundness theorem therefore requires an old `CheckedSolution` as a typed input. -/
theorem unchecked_seed_boundary :
    checkImprovementCertificate (selfProduct infinity) (selfProduct infinity)
      [⟨0, by decide⟩] 0 [⟨0, by decide⟩] = true ∧
    checkCertificate (selfProduct infinity) 1 [⟨0, by decide⟩] = false := by
  decide +kernel

/-- Chained checked improvements preserve the existing least-solution interface. -/
theorem chained_improvement_least :
    IsLeastFixed (selfProduct ⟨1, by decide⟩) (listState threeToOne.toCheckedSolution.values) :=
  threeToOne.toCheckedSolution.least

end WeightedRules
