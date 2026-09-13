import WeightedRules.Convergence

/-!
# Sharpness of the scalar-round bound

For each positive number `n` of coordinates, a chain program requires exactly
`n` synchronous rounds from infinity. Coordinate zero has a zero-cost fact;
each other coordinate is the product of two copies of its predecessor. The
zero-coordinate rule is a harmless self-product. In round `k`, precisely the
coordinates with index less than `k` have cost zero.

This family proves sharpness over the same binary-rule syntax as the general
convergence theorem. The argument is symbolic for every positive `n`, with no
enumerated size cutoff or native decision procedure.
-/

namespace WeightedRules

private theorem indexed_contributions {n : Nat} (indices : List (Fin n))
    (left right : Fin n → Fin n) (x : State Cost n) (i : Fin n) :
    contributions boundedMinPlus
      (indices.map fun j => ⟨j, left j, right j⟩) x i =
      if i ∈ indices then costMul (x (left i)) (x (right i)) else infinity := by
  induction indices with
  | nil => rfl
  | cons j js ih =>
    simp only [List.map_cons, contributions, ih, List.mem_cons]
    by_cases h : j = i
    · subst j
      simp only [if_true, true_or]
      split
      · exact boundedMinPlus.add_idem _
      · exact boundedMinPlus.add_zero _
    · have hi : i ≠ j := Ne.symm h
      simp only [h, hi, if_false, false_or]
      rw [boundedMinPlus.add_comm, boundedMinPlus.add_zero]

/-- A scalar chain whose facts and predecessor products propagate zero cost
one coordinate per round. The definition also allows the empty program. -/
def zeroChainProgram (n : Nat) : Program Cost n where
  inputs := fun i => if i.val = 0 then ⟨0, by decide⟩ else infinity
  rules := (List.finRange n).map fun i =>
    { output := i
      left := ⟨i.val - 1, by omega⟩
      right := ⟨i.val - 1, by omega⟩ }

private theorem zeroChain_step (n : Nat) (x : State Cost n) (i : Fin n) :
    step boundedMinPlus (zeroChainProgram n) x i =
      costAdd (if i.val = 0 then ⟨0, by decide⟩ else infinity)
        (costMul (x ⟨i.val - 1, by omega⟩) (x ⟨i.val - 1, by omega⟩)) := by
  unfold step zeroChainProgram
  rw [indexed_contributions]
  simp only [List.mem_finRange, if_true]
  rfl

/-- At round `k` of a chain of `n` scalars, the represented cost is zero
exactly at coordinates with index less than `k`, and infinity elsewhere. -/
theorem zeroChain_iterate (n k : Nat) (i : Fin n) :
    iterate boundedMinPlus (zeroChainProgram n) k i =
      if i.val < k then ⟨0, by decide⟩ else infinity := by
  induction k generalizing i with
  | zero => simp [iterate, boundedMinPlus, infinity]
  | succ k ih =>
    rw [iterate, zeroChain_step]
    rw [ih]
    apply Fin.ext
    simp only [costAdd, costMul]
    split_ifs <;> simp_all [infinity] <;> omega

/-- For every positive scalar count, a chain changes between rounds `n - 1`
and `n`. Thus a smaller uniform round bound is impossible for this syntax. -/
theorem zeroChain_requires_scalar_rounds (n : Nat) (hn : 0 < n) :
    iterate boundedMinPlus (zeroChainProgram n) (n - 1) ≠
      iterate boundedMinPlus (zeroChainProgram n) n := by
  intro h
  have hi := congrFun h ⟨n - 1, by omega⟩
  rw [zeroChain_iterate, zeroChain_iterate] at hi
  have hn' : n - 1 < n := by omega
  simp only [lt_self_iff_false, if_false, hn', if_true] at hi
  have hv := congrArg Fin.val hi
  change 4294967295 = 0 at hv
  omega

end WeightedRules
