import WeightedRules.BoundedMinPlus
import Mathlib.Data.Finset.Card

/-!
# Scalar-round convergence of bounded min-plus rules

A grounded program with `n` scalar coordinates reaches its least fixed point
after at most `n` synchronous iterations from infinity. Rules may be cyclic,
and both factors of a product may refer to the same coordinate. Addition of
costs saturates at `2^32 - 1`, with the same sentinel convention as the scalar
algebra.

The proof counts coordinates forced by a late improvement. An improvement at
round `k + 1` has an improving rule factor at round `k`, of no greater cost.
The coordinates counted for that factor exclude the new output: its previous
cost is strictly larger. Thus a round-`k` improvement requires `k` distinct
coordinates. All proofs use ordinary kernel-checked terms.
-/

namespace WeightedRules

variable {n : Nat}

private theorem info_cost {a b : Cost} :
    InfoLe boundedMinPlus a b ↔ b.val ≤ a.val := by
  constructor
  · intro h
    have h' := congrArg Fin.val h
    change min a.val b.val = b.val at h'
    omega
  · intro h
    apply Fin.ext
    change min a.val b.val = b.val
    omega

/-- Numerical costs never increase along from-zero bounded min-plus iteration. -/
theorem boundedMinPlus_iterate_succ_cost (P : Program Cost n) (k : Nat) (i : Fin n) :
    (iterate boundedMinPlus P (k + 1) i).val ≤
      (iterate boundedMinPlus P k i).val := by
  have h : StateLe boundedMinPlus (iterate boundedMinPlus P k)
      (iterate boundedMinPlus P (k + 1)) := by
    induction k with
    | zero => exact fun j => zero_le boundedMinPlus _
    | succ k ih => exact step_mono boundedMinPlus P ih
  exact info_cost.mp (h i)

private theorem mul_left_cost (a b : Cost) : a.val ≤ (costMul a b).val := by
  have := a.isLt
  change a.val ≤ min 4294967295 (a.val + b.val)
  omega

private theorem mul_right_cost (a b : Cost) : b.val ≤ (costMul a b).val := by
  have := b.isLt
  change b.val ≤ min 4294967295 (a.val + b.val)
  omega

private theorem contributions_le_rule (rs : List (ProductRule n)) (x : State Cost n)
    (i : Fin n) (r : ProductRule n) (hr : r ∈ rs) (ho : r.output = i) :
    (contributions boundedMinPlus rs x i).val ≤
      (costMul (x r.left) (x r.right)).val := by
  induction rs with
  | nil => simp at hr
  | cons q qs ih =>
    rcases List.mem_cons.mp hr with h | h
    · subst q
      simp only [contributions, ho, if_true]
      exact min_le_left _ _
    · exact le_trans (min_le_right _ _) (ih h)

private theorem contributions_witness (rs : List (ProductRule n))
    (x : State Cost n) (i : Fin n)
    (h : (contributions boundedMinPlus rs x i).val < 4294967295) :
    ∃ r ∈ rs, r.output = i ∧
      (costMul (x r.left) (x r.right)).val =
        (contributions boundedMinPlus rs x i).val := by
  induction rs with
  | nil => change 4294967295 < 4294967295 at h; omega
  | cons r rs ih =>
    by_cases ho : r.output = i
    · simp only [contributions, ho, if_true] at h ⊢
      change min (costMul (x r.left) (x r.right)).val
        (contributions boundedMinPlus rs x i).val < 4294967295 at h
      by_cases hm : (costMul (x r.left) (x r.right)).val ≤
          (contributions boundedMinPlus rs x i).val
      · exact ⟨r, List.mem_cons_self, ho, (min_eq_left hm).symm⟩
      · have ht : (contributions boundedMinPlus rs x i).val < 4294967295 := by omega
        obtain ⟨q, hq, hqo, heq⟩ := ih ht
        refine ⟨q, List.mem_cons_of_mem r hq, hqo, ?_⟩
        change (costMul (x q.left) (x q.right)).val =
          min (costMul (x r.left) (x r.right)).val
            (contributions boundedMinPlus rs x i).val
        omega
    · have ht : (contributions boundedMinPlus rs x i).val < 4294967295 := by
        change (costAdd (if r.output = i then _ else infinity)
          (contributions boundedMinPlus rs x i)).val < 4294967295 at h
        rw [if_neg ho] at h
        change min 4294967295 _ < 4294967295 at h
        omega
      obtain ⟨q, hq, hqo, heq⟩ := ih ht
      refine ⟨q, List.mem_cons_of_mem r hq, hqo, ?_⟩
      simp only [contributions, ho, if_false]
      change (costMul (x q.left) (x q.right)).val = min 4294967295 _
      omega

/-- A strict step improvement occurs at a rule output and has an improving
prior coordinate whose cost is no greater than the new output cost. -/
theorem boundedMinPlus_step_improvement (P : Program Cost n) (x y : State Cost n) (i : Fin n)
    (h : (step boundedMinPlus P x i).val < (step boundedMinPlus P y i).val) :
    i ∈ P.rules.map (·.output) ∧
      ∃ j, (x j).val < (y j).val ∧ (x j).val ≤ (step boundedMinPlus P x i).val := by
  have hi : (step boundedMinPlus P y i).val ≤ (P.inputs i).val := min_le_left _ _
  have hy := (step boundedMinPlus P y i).isLt
  have hc : (contributions boundedMinPlus P.rules x i).val < 4294967295 := by
    change min (P.inputs i).val (contributions boundedMinPlus P.rules x i).val < _ at h
    omega
  have he : (step boundedMinPlus P x i).val =
      (contributions boundedMinPlus P.rules x i).val := by
    change min (P.inputs i).val _ = _
    change min (P.inputs i).val _ < _ at h
    omega
  obtain ⟨r, hr, ho, hv⟩ := contributions_witness P.rules x i hc
  have hold : (step boundedMinPlus P y i).val ≤
      (costMul (y r.left) (y r.right)).val :=
    le_trans (min_le_right _ _) (contributions_le_rule P.rules y i r hr ho)
  have hprod : (costMul (x r.left) (x r.right)).val <
      (costMul (y r.left) (y r.right)).val := by omega
  refine ⟨List.mem_map.mpr ⟨r, hr, ho⟩, ?_⟩
  by_cases hl : (x r.left).val < (y r.left).val
  · refine ⟨r.left, hl, ?_⟩
    have := mul_left_cost (x r.left) (x r.right)
    omega
  · refine ⟨r.right, ?_, ?_⟩
    · change min 4294967295 ((x r.left).val + (x r.right).val) <
        min 4294967295 ((y r.left).val + (y r.right).val) at hprod
      omega
    · have := mul_right_cost (x r.left) (x r.right)
      omega

private theorem improvement_coordinates (P : Program Cost n) (k : Nat) (i : Fin n)
    (h : (iterate boundedMinPlus P (k + 1) i).val <
      (iterate boundedMinPlus P k i).val) :
    ∃ s : Finset (Fin n), s.card = k + 1 ∧
      ∀ j ∈ s, (iterate boundedMinPlus P (k + 1) j).val ≤
        (iterate boundedMinPlus P (k + 1) i).val := by
  induction k generalizing i with
  | zero => exact ⟨{i}, by simp, by simp⟩
  | succ k ih =>
    obtain ⟨_, j, hj, hjcost⟩ := boundedMinPlus_step_improvement P
      (iterate boundedMinPlus P (k + 1)) (iterate boundedMinPlus P k) i h
    obtain ⟨s, hcard, hs⟩ := ih j hj
    have hnot : i ∉ s := by
      intro hi
      have := hs i hi
      change (iterate boundedMinPlus P (k + 2) i).val <
        (iterate boundedMinPlus P (k + 1) i).val at h
      change (iterate boundedMinPlus P (k + 1) j).val ≤
        (iterate boundedMinPlus P (k + 2) i).val at hjcost
      omega
    refine ⟨insert i s, ?_, ?_⟩
    · rw [Finset.card_insert_of_notMem hnot, hcard]
    · intro a ha
      rcases Finset.mem_insert.mp ha with rfl | ha
      · exact le_rfl
      · exact le_trans (boundedMinPlus_iterate_succ_cost P (k + 1) a) (le_trans (hs a ha) hjcost)

/-- A strict improvement in round `k + 1` requires at least `k + 1` scalar
coordinates, independently of the number of rules and of represented costs. -/
theorem boundedMinPlus_improvement_round_le (P : Program Cost n) (k : Nat) (i : Fin n)
    (h : (iterate boundedMinPlus P (k + 1) i).val <
      (iterate boundedMinPlus P k i).val) : k + 1 ≤ n := by
  obtain ⟨s, hcard, _⟩ := improvement_coordinates P k i h
  have hbound := Finset.card_le_univ s
  simp only [Fintype.card_fin] at hbound
  omega

/-- Every bounded min-plus program is fixed after `n` rounds, where `n` counts
all scalar coordinates, including fixed inputs. The statement includes `n = 0`. -/
theorem boundedMinPlus_iterate_fixed (P : Program Cost n) :
    step boundedMinPlus P (iterate boundedMinPlus P n) =
      iterate boundedMinPlus P n := by
  funext i
  apply Fin.ext
  have hle := boundedMinPlus_iterate_succ_cost P n i
  change (iterate boundedMinPlus P (n + 1) i).val = _
  by_contra hne
  have hlt : (iterate boundedMinPlus P (n + 1) i).val <
      (iterate boundedMinPlus P n i).val := by omega
  have hbound := boundedMinPlus_improvement_round_le P n i hlt
  omega

/-- Every iteration after the scalar bound equals the valuation at that bound. -/
theorem boundedMinPlus_iterate_add (P : Program Cost n) (k : Nat) :
    iterate boundedMinPlus P (n + k) = iterate boundedMinPlus P n := by
  induction k with
  | zero => rfl
  | succ k ih =>
    change step boundedMinPlus P (iterate boundedMinPlus P (n + k)) = _
    rw [ih]
    exact boundedMinPlus_iterate_fixed P

/-- Every bounded min-plus program admits a convergence certificate with the
scalar count as its round bound; existence does not require an external solver. -/
def boundedMinPlusCertificate (P : Program Cost n) : Certificate boundedMinPlus P n where
  rounds := n
  within := le_rfl
  fixed := boundedMinPlus_iterate_fixed P

/-- The valuation after the scalar-count number of rounds is the least solution
in information order, equivalently the greatest numerical fixed valuation. -/
theorem boundedMinPlus_iterate_least (P : Program Cost n) :
    step boundedMinPlus P (iterate boundedMinPlus P n) =
      iterate boundedMinPlus P n ∧
    ∀ y, step boundedMinPlus P y = y → StateLe boundedMinPlus
      (iterate boundedMinPlus P n) y :=
  certificate_least boundedMinPlus P n (boundedMinPlusCertificate P)

end WeightedRules
