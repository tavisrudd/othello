import WeightedRules.Incremental
import WeightedRules.ConvergenceReflection

/-!
# Checked incremental min-plus certificates

An incremental certificate is tied to an old `CheckedSolution P` and a new
caller-supplied program `Q` on the same scalar coordinates. It checks identical
rules, pointwise numerical decreases of input costs, exact list coverage, a
bounded number of synchronous steps from the old valuation, and fixedness of
the returned valuation. These conditions establish the new least solution.

The accepted object converts to the existing from-zero `CheckedSolution Q`.
The incremental round count records work from the old state; the converted
certificate uses the scalar-count round bound for its from-zero semantics.
This is a kernel proof route and does not assert that an external producer or
parser implements either replay operation correctly.
-/

namespace WeightedRules

variable {n : Nat}

/-- Check source compatibility, coverage, warm replay and fixedness. Soundness
additionally requires a checked old solution with exactly `oldValues`. -/
def checkImprovementCertificate (P Q : Program Cost n) (oldValues : List Cost)
    (rounds : Nat) (values : List Cost) : Bool :=
  decide (P.rules = Q.rules ∧
    (∀ i, (Q.inputs i).val ≤ (P.inputs i).val) ∧
    oldValues.length = n ∧ values.length = n ∧ rounds ≤ n ∧
    (∀ i, iterateFrom boundedMinPlus Q (listState oldValues) rounds i = listState values i) ∧
    (∀ i, step boundedMinPlus Q (listState values) i = listState values i))

/-- Accepted incremental replay from a checked old solution equals the new
program's scalar-count iterate, even when replay stopped at an earlier fixed point. -/
theorem checkImprovementCertificate_eq_iterate (P Q : Program Cost n)
    (old : CheckedSolution P) (rounds : Nat) (values : List Cost)
    (accepted : checkImprovementCertificate P Q old.values rounds values = true) :
    listState values = iterate boundedMinPlus Q n := by
  rcases of_decide_eq_true accepted with ⟨hrules, hfacts, _, _, _, hreplay, hfixed⟩
  have hpq : ImprovesFacts boundedMinPlus P Q := by
    refine ⟨hrules, ?_⟩
    intro i
    apply Fin.ext
    change min (P.inputs i).val (Q.inputs i).val = (Q.inputs i).val
    exact min_eq_right (hfacts i)
  have hseed : StateLe boundedMinPlus (listState old.values) (iterate boundedMinPlus Q n) := by
    rw [old.eq_iterate]
    exact iterate_le_of_improves boundedMinPlus P Q hpq n
  have replay : iterateFrom boundedMinPlus Q (listState old.values) rounds =
      listState values := funext hreplay
  have fixed : step boundedMinPlus Q
      (iterateFrom boundedMinPlus Q (listState old.values) rounds) =
        iterateFrom boundedMinPlus Q (listState old.values) rounds := by
    rw [replay]
    exact funext hfixed
  exact replay.symm.trans (iterateFrom_eq_of_fixed Q _ hseed rounds fixed)

/-- Acceptance proves least fixedness for the new caller-supplied program. -/
theorem checkImprovementCertificate_sound (P Q : Program Cost n)
    (old : CheckedSolution P) (rounds : Nat) (values : List Cost)
    (accepted : checkImprovementCertificate P Q old.values rounds values = true) :
    IsLeastFixed Q (listState values) := by
  rw [checkImprovementCertificate_eq_iterate P Q old rounds values accepted]
  exact boundedMinPlus_iterate_least Q

/-- A checked incremental result carries the exact old proof as a parameter. -/
structure CheckedImprovement {P : Program Cost n} (old : CheckedSolution P)
    (Q : Program Cost n) where
  rounds : Nat
  values : List Cost
  accepted : checkImprovementCertificate P Q old.values rounds values = true

/-- A checked incremental result is the new least fixed valuation. -/
theorem CheckedImprovement.least {P Q : Program Cost n} {old : CheckedSolution P}
    (c : CheckedImprovement old Q) : IsLeastFixed Q (listState c.values) :=
  checkImprovementCertificate_sound P Q old c.rounds c.values c.accepted

/-- Every checked incremental result denotes the new scalar-count iterate. -/
theorem CheckedImprovement.eq_iterate {P Q : Program Cost n} {old : CheckedSolution P}
    (c : CheckedImprovement old Q) : listState c.values = iterate boundedMinPlus Q n :=
  checkImprovementCertificate_eq_iterate P Q old c.rounds c.values c.accepted

/-- Convert a checked improvement to the existing from-zero certificate type.
Its round count is the scalar count, independently of the incremental work count. -/
def CheckedImprovement.toCheckedSolution {P Q : Program Cost n} {old : CheckedSolution P}
    (c : CheckedImprovement old Q) : CheckedSolution Q where
  rounds := n
  values := c.values
  accepted := by
    rcases of_decide_eq_true c.accepted with ⟨_, _, _, hlength, _, _, _⟩
    unfold checkCertificate
    apply decide_eq_true
    refine ⟨hlength, le_rfl, ?_, ?_⟩
    · intro i
      exact (congrFun c.eq_iterate i).symm
    · exact fun i => congrFun c.least.1 i

/-- Every compatible fact improvement admits a checked incremental result in
at most the scalar-count number of rounds from the old checked valuation. -/
def iteratedImprovement {P : Program Cost n} (old : CheckedSolution P)
    (Q : Program Cost n) (h : ImprovesFacts boundedMinPlus P Q) : CheckedImprovement old Q where
  rounds := n
  values := List.ofFn (iterate boundedMinPlus Q n)
  accepted := by
    unfold checkImprovementCertificate
    apply decide_eq_true
    refine ⟨h.1, ?_, (of_decide_eq_true old.accepted).1, List.length_ofFn, le_rfl, ?_, ?_⟩
    · intro i
      have hi := congrArg Fin.val (h.2 i)
      change min (P.inputs i).val (Q.inputs i).val = (Q.inputs i).val at hi
      omega
    · intro i
      rw [listState_ofFn, old.eq_iterate]
      exact congrFun (improved_iterateFrom_bound P Q h) i
    · rw [listState_ofFn]
      exact fun i => congrFun (boundedMinPlus_iterate_fixed Q) i

end WeightedRules
