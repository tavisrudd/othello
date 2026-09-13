import WeightedRules.Convergence

/-!
# Incremental iteration after fact improvements

When the rule list is unchanged and facts increase in information order, the
old least solution lies below the new one. Iterating the new program from that
old solution reaches the new least solution within the scalar round bound.
Any earlier fixed iterate is already least.

The argument is a sandwich: iteration from zero lies below iteration from the
seed, while a seed below the new least fixed point remains below it. The lower
bound reaches the least solution at the scalar count. Early fixedness gives
the same conclusion by leastness. The seed hypothesis is essential; an
unsupported numerical fixed point cannot be admitted merely because it is fixed.
-/

namespace WeightedRules

variable {W : Type} {n : Nat}

/-- Iterate a supplied program from an explicit initial valuation. -/
def iterateFrom (A : ScalarAlgebra W) (P : Program W n) (seed : State W n) : Nat → State W n
  | 0 => seed
  | k + 1 => step A P (iterateFrom A P seed k)

/-- Starting with no facts recovers the ordinary Kleene iteration. -/
theorem iterateFrom_zero (A : ScalarAlgebra W) (P : Program W n) (k : Nat) :
    iterateFrom A P (fun _ => A.zero) k = iterate A P k := by
  induction k with
  | zero => rfl
  | succ k ih => exact congrArg (step A P) ih

/-- Iteration is monotone in its initial valuation. -/
theorem iterateFrom_mono (A : ScalarAlgebra W) (P : Program W n)
    (x y : State W n) (h : StateLe A x y) (k : Nat) :
    StateLe A (iterateFrom A P x k) (iterateFrom A P y k) := by
  induction k with
  | zero => exact h
  | succ k ih => exact step_mono A P ih

/-- A seed below a fixed point stays below it throughout iteration. -/
theorem iterateFrom_le_fixed (A : ScalarAlgebra W) (P : Program W n)
    (seed y : State W n) (hseed : StateLe A seed y) (hy : step A P y = y) (k : Nat) :
    StateLe A (iterateFrom A P seed k) y := by
  induction k with
  | zero => exact hseed
  | succ k ih => simpa only [iterateFrom, hy] using step_mono A P ih

/-- Iteration from any seed contains the information obtained from zero. -/
theorem iterate_le_iterateFrom (A : ScalarAlgebra W) (P : Program W n)
    (seed : State W n) (k : Nat) : StateLe A (iterate A P k) (iterateFrom A P seed k) := by
  rw [← iterateFrom_zero]
  exact iterateFrom_mono A P _ seed (fun i => zero_le A (seed i)) k

/-- A fact improvement preserves the rule list and increases every input in
information order. For min-plus this permits only numerical cost decreases. -/
def ImprovesFacts (A : ScalarAlgebra W) (P Q : Program W n) : Prop :=
  P.rules = Q.rules ∧ StateLe A P.inputs Q.inputs

/-- Improved facts improve one evaluation of the same valuation. -/
theorem step_le_of_improves (A : ScalarAlgebra W) (P Q : Program W n)
    (h : ImprovesFacts A P Q) (x : State W n) : StateLe A (step A P x) (step A Q x) := by
  intro i
  unfold step
  rw [h.1]
  exact add_mono A (h.2 i) (info_refl A _)

/-- Every from-zero iterate improves when facts improve and rules are unchanged. -/
theorem iterate_le_of_improves (A : ScalarAlgebra W) (P Q : Program W n)
    (h : ImprovesFacts A P Q) (k : Nat) : StateLe A (iterate A P k) (iterate A Q k) := by
  induction k with
  | zero => exact fun i => info_refl A _
  | succ k ih =>
    exact fun i => info_trans A (step_le_of_improves A P Q h _ i) (step_mono A Q ih i)

/-- Any seed below the bounded min-plus least solution reaches that solution
within the scalar-count number of synchronous rounds. -/
theorem iterateFrom_scalar_bound (P : Program Cost n) (seed : State Cost n)
    (hseed : StateLe boundedMinPlus seed (iterate boundedMinPlus P n)) :
    iterateFrom boundedMinPlus P seed n = iterate boundedMinPlus P n := by
  funext i
  apply info_antisymm boundedMinPlus
  · exact iterateFrom_le_fixed boundedMinPlus P seed _ hseed
      (boundedMinPlus_iterate_fixed P) n i
  · exact iterate_le_iterateFrom boundedMinPlus P seed n i

/-- A fixed iterate from a seed below the new least solution is already that
solution, without requiring the full scalar-count number of replay rounds. -/
theorem iterateFrom_eq_of_fixed (P : Program Cost n) (seed : State Cost n)
    (hseed : StateLe boundedMinPlus seed (iterate boundedMinPlus P n)) (k : Nat)
    (hfixed : step boundedMinPlus P (iterateFrom boundedMinPlus P seed k) =
      iterateFrom boundedMinPlus P seed k) :
    iterateFrom boundedMinPlus P seed k = iterate boundedMinPlus P n := by
  funext i
  apply info_antisymm boundedMinPlus
  · exact iterateFrom_le_fixed boundedMinPlus P seed _ hseed
      (boundedMinPlus_iterate_fixed P) k i
  · exact iterate_le_fixed boundedMinPlus P _ hfixed n i

/-- The old least solution is a safe seed after a pointwise fact improvement,
and the new least solution is reached within the scalar round bound. -/
theorem improved_iterateFrom_bound (P Q : Program Cost n)
    (h : ImprovesFacts boundedMinPlus P Q) :
    iterateFrom boundedMinPlus Q (iterate boundedMinPlus P n) n =
      iterate boundedMinPlus Q n :=
  iterateFrom_scalar_bound Q _ (iterate_le_of_improves boundedMinPlus P Q h n)

/-- An earlier fixed iterate seeded by the old least solution is the new least
solution whenever only facts improve and the rules remain identical. -/
theorem improved_iterateFrom_fixed (P Q : Program Cost n)
    (h : ImprovesFacts boundedMinPlus P Q) (k : Nat)
    (hfixed : step boundedMinPlus Q
      (iterateFrom boundedMinPlus Q (iterate boundedMinPlus P n) k) =
        iterateFrom boundedMinPlus Q (iterate boundedMinPlus P n) k) :
    iterateFrom boundedMinPlus Q (iterate boundedMinPlus P n) k =
      iterate boundedMinPlus Q n :=
  iterateFrom_eq_of_fixed Q _ (iterate_le_of_improves boundedMinPlus P Q h n) k hfixed

end WeightedRules
