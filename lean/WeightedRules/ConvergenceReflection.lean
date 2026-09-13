import WeightedRules.Convergence
import WeightedRules.Reflection

/-!
# Completeness of bounded min-plus certificate reflection

For every finite grounded program, the scalar-count iterate has an exact cost
list accepted by the reflective checker. The universal convergence theorem
supplies fixedness; list indexing supplies complete coordinate coverage.
Conversely, every accepted certificate denotes that same valuation, even if
its round count is smaller. The construction and all proofs are kernel-checked;
no external producer is assumed to terminate or to return a valid certificate.
-/

namespace WeightedRules

variable {n : Nat}

/-- Encoding every scalar in index order and decoding the resulting list
preserves the original valuation, including the empty scalar type. -/
theorem listState_ofFn (x : State Cost n) : listState (List.ofFn x) = x := by
  funext i
  simp [listState, i.isLt]

/-- The complete scalar-count iterate is always accepted by the existing
reflective checker, including its exact coverage and round-bound checks. -/
theorem checkCertificate_complete (P : Program Cost n) :
    checkCertificate P n (List.ofFn (iterate boundedMinPlus P n)) = true := by
  unfold checkCertificate
  apply decide_eq_true
  rw [listState_ofFn]
  exact ⟨List.length_ofFn, le_rfl, fun _ => rfl,
    fun i => congrFun (boundedMinPlus_iterate_fixed P) i⟩

/-- A checked cost list constructed by finite iteration for any supplied program. -/
def iteratedCheckedSolution (P : Program Cost n) : CheckedSolution P where
  rounds := n
  values := List.ofFn (iterate boundedMinPlus P n)
  accepted := checkCertificate_complete P

/-- Every accepted external or internal certificate returns the scalar-count
iterate of the caller's program, regardless of its accepted round count. -/
theorem CheckedSolution.eq_iterate {P : Program Cost n} (s : CheckedSolution P) :
    listState s.values = iterate boundedMinPlus P n := by
  funext i
  apply info_antisymm boundedMinPlus
  · exact s.least.2 _ (boundedMinPlus_iterate_fixed P) i
  · exact iterate_le_fixed boundedMinPlus P _ s.least.1 n i

end WeightedRules
