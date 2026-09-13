import WeightedRules.Contract
import Mathlib.Data.Finset.Card
import Mathlib.Data.Fintype.Card

/-!
# Convergence over ordered inflationary algebras

An idempotent semiring on a linearly ordered carrier is *ordered inflationary*
when its addition is the minimum of the order and each factor lies below its
product. Bounded min-plus is the model case: alternatives select the smaller
cost and composition adds nonnegative costs. Boolean reachability under the
order `true < false`, bounded max-min and bounded max-times under the dual
order are further instances. Neither finiteness of the carrier nor a
comparison minus is assumed.

For such an algebra, a grounded program on `n` scalar coordinates reaches its
least fixed point after at most `n` synchronous iterations from zero, and
after at most `min n (m + 1)` iterations where `m` counts distinct rule
outputs. Rules may be cyclic, and both factors of a product may name the same
coordinate.

The proof counts coordinates forced by a late improvement. In the information
order zero is least and an alternative absorbs the larger value, so the
iterates decrease along the carrier order. A strict decrease at round `k + 1`
comes from a product whose factor decreased at round `k`; the factor lies
below the product, hence below the new output value, while the output's
previous value lies strictly above it. Collecting the factor's coordinates by
induction yields `k + 1` distinct coordinates, all rule outputs after the first
round. More coordinates than exist is impossible, which bounds the round of
the last improvement. All proofs are ordinary kernel-checked terms.
-/

namespace WeightedRules

variable {W : Type} {n : Nat}

/-- The distinct scalar coordinates occurring as outputs of grounded rules. -/
def ruleOutputs (P : Program W n) : Finset (Fin n) :=
  (P.rules.map (·.output)).toFinset

/-- The rule-output round bound, capped by the total scalar count. -/
def ruleOutputBound (P : Program W n) : Nat := min n ((ruleOutputs P).card + 1)

/-- An idempotent semiring on a linear order whose alternative is the minimum
and whose product lies above each of its factors. The information order of the
algebra is then the reverse of the carrier order. -/
structure OrderedInflationary [LinearOrder W] (A : ScalarAlgebra W) : Prop where
  add_min : ∀ a b, A.add a b = min a b
  le_mul_left : ∀ a b, a ≤ A.mul a b
  le_mul_right : ∀ a b, b ≤ A.mul a b

namespace OrderedInflationary

variable [LinearOrder W] {A : ScalarAlgebra W} (h : OrderedInflationary A)
include h

/-- Information increases exactly when the carrier value decreases. -/
theorem info_iff (a b : W) : InfoLe A a b ↔ b ≤ a := by
  unfold InfoLe
  rw [h.add_min]
  exact min_eq_right_iff

/-- The additive zero is the greatest carrier value. -/
theorem le_zero (a : W) : a ≤ A.zero := by
  have e := A.add_zero a
  rw [h.add_min] at e
  exact min_eq_left_iff.mp e

/-- The multiplicative unit is the least carrier value. -/
theorem one_le (a : W) : A.one ≤ a := by
  have e := h.le_mul_right a A.one
  rwa [A.mul_one] at e

/-- The product is monotone in the carrier order on both factors. -/
theorem mul_le_mul {a b c d : W} (hac : a ≤ c) (hbd : b ≤ d) :
    A.mul a b ≤ A.mul c d :=
  (h.info_iff _ _).mp (mul_mono A ((h.info_iff _ _).mpr hac) ((h.info_iff _ _).mpr hbd))

/-- Carrier values never increase along from-zero iteration. -/
theorem iterate_succ_le (P : Program W n) (k : Nat) (i : Fin n) :
    iterate A P (k + 1) i ≤ iterate A P k i := by
  have hle : StateLe A (iterate A P k) (iterate A P (k + 1)) := by
    induction k with
    | zero => exact fun j => zero_le A _
    | succ k ih => exact step_mono A P ih
  exact (h.info_iff _ _).mp (hle i)

/-- The contribution sum lies below every listed product with that output. -/
theorem contributions_le_rule (rs : List (ProductRule n)) (x : State W n)
    (i : Fin n) (r : ProductRule n) (hr : r ∈ rs) (ho : r.output = i) :
    contributions A rs x i ≤ A.mul (x r.left) (x r.right) := by
  induction rs with
  | nil => simp at hr
  | cons q qs ih =>
    rcases List.mem_cons.mp hr with hq | hq
    · subst hq
      simp only [contributions, ho, if_true]
      rw [h.add_min]
      exact min_le_left _ _
    · simp only [contributions]
      rw [h.add_min]
      exact le_trans (min_le_right _ _) (ih hq)

/-- A contribution sum strictly below zero is attained by some listed product. -/
theorem contributions_witness (rs : List (ProductRule n)) (x : State W n) (i : Fin n)
    (hc : contributions A rs x i < A.zero) :
    ∃ r ∈ rs, r.output = i ∧ A.mul (x r.left) (x r.right) = contributions A rs x i := by
  induction rs with
  | nil =>
    simp only [contributions] at hc
    exact absurd hc (lt_irrefl _)
  | cons r rs ih =>
    simp only [contributions] at hc ⊢
    by_cases ho : r.output = i
    · rw [if_pos ho] at hc ⊢
      rw [h.add_min] at hc ⊢
      by_cases hm : A.mul (x r.left) (x r.right) ≤ contributions A rs x i
      · exact ⟨r, List.mem_cons_self, ho, (min_eq_left hm).symm⟩
      · have hlt := not_le.mp hm
        rw [min_eq_right hlt.le] at hc ⊢
        obtain ⟨q, hq, hqo, heq⟩ := ih hc
        exact ⟨q, List.mem_cons_of_mem r hq, hqo, heq⟩
    · rw [if_neg ho] at hc ⊢
      rw [h.add_min, min_eq_right (h.le_zero _)] at hc ⊢
      obtain ⟨q, hq, hqo, heq⟩ := ih hc
      exact ⟨q, List.mem_cons_of_mem r hq, hqo, heq⟩

/-- A strict step improvement occurs at a rule output and has an improving
prior coordinate lying below the new output value. -/
theorem step_improvement (P : Program W n) (x y : State W n) (i : Fin n)
    (hlt : step A P x i < step A P y i) :
    i ∈ P.rules.map (·.output) ∧
      ∃ j, x j < y j ∧ x j ≤ step A P x i := by
  have hy : step A P y i ≤ P.inputs i := by
    simp only [step]
    rw [h.add_min]
    exact min_le_left _ _
  have hmin : min (P.inputs i) (contributions A P.rules x i) < P.inputs i := by
    have e : step A P x i = min (P.inputs i) (contributions A P.rules x i) := by
      simp only [step]
      rw [h.add_min]
    rw [← e]
    exact lt_of_lt_of_le hlt hy
  have hb : contributions A P.rules x i < P.inputs i :=
    (min_lt_iff.mp hmin).resolve_left (lt_irrefl _)
  have he : step A P x i = contributions A P.rules x i := by
    simp only [step]
    rw [h.add_min]
    exact min_eq_right hb.le
  have hc : contributions A P.rules x i < A.zero :=
    lt_of_lt_of_le (he ▸ hlt) (h.le_zero _)
  obtain ⟨r, hr, ho, hv⟩ := h.contributions_witness P.rules x i hc
  have hold : step A P y i ≤ A.mul (y r.left) (y r.right) := by
    simp only [step]
    rw [h.add_min]
    exact le_trans (min_le_right _ _) (h.contributions_le_rule P.rules y i r hr ho)
  have hprod : A.mul (x r.left) (x r.right) < A.mul (y r.left) (y r.right) := by
    rw [hv, ← he]
    exact lt_of_lt_of_le hlt hold
  refine ⟨List.mem_map.mpr ⟨r, hr, ho⟩, ?_⟩
  by_cases hl : x r.left < y r.left
  · refine ⟨r.left, hl, ?_⟩
    rw [he, ← hv]
    exact h.le_mul_left _ _
  · have hyl : y r.left ≤ x r.left := not_lt.mp hl
    have hxr : x r.right < y r.right := by
      by_contra hnr
      exact absurd (h.mul_le_mul hyl (not_lt.mp hnr)) (not_le.mpr hprod)
    refine ⟨r.right, hxr, ?_⟩
    rw [he, ← hv]
    exact h.le_mul_right _ _

/-- A strict improvement at round `k + 1` forces `k + 1` distinct coordinates
whose values at that round lie below the improved value. -/
theorem improvement_coordinates (P : Program W n) (k : Nat) (i : Fin n)
    (hlt : iterate A P (k + 1) i < iterate A P k i) :
    ∃ s : Finset (Fin n), s.card = k + 1 ∧
      ∀ j ∈ s, iterate A P (k + 1) j ≤ iterate A P (k + 1) i := by
  induction k generalizing i with
  | zero => exact ⟨{i}, by simp, by simp⟩
  | succ k ih =>
    obtain ⟨_, j, hj, hjc⟩ := h.step_improvement P
      (iterate A P (k + 1)) (iterate A P k) i hlt
    obtain ⟨s, hcard, hs⟩ := ih j hj
    have hnot : i ∉ s := by
      intro hi
      exact absurd (lt_of_le_of_lt (le_trans (hs i hi) hjc) hlt) (lt_irrefl _)
    refine ⟨insert i s, ?_, ?_⟩
    · rw [Finset.card_insert_of_notMem hnot, hcard]
    · intro a ha
      rcases Finset.mem_insert.mp ha with rfl | ha
      · exact le_rfl
      · exact le_trans (h.iterate_succ_le P (k + 1) a) (le_trans (hs a ha) hjc)

/-- A strict improvement in round `k + 1` requires at least `k + 1` scalar
coordinates, independently of the number of rules and of carrier values. -/
theorem improvement_round_le (P : Program W n) (k : Nat) (i : Fin n)
    (hlt : iterate A P (k + 1) i < iterate A P k i) : k + 1 ≤ n := by
  obtain ⟨s, hcard, _⟩ := h.improvement_coordinates P k i hlt
  have hbound := Finset.card_le_univ s
  simp only [Fintype.card_fin] at hbound
  omega

/-- Every program is fixed after `n` rounds, where `n` counts all scalar
coordinates, including fixed inputs. The statement includes `n = 0`. -/
theorem iterate_fixed (P : Program W n) :
    step A P (iterate A P n) = iterate A P n := by
  funext i
  rcases lt_or_eq_of_le (h.iterate_succ_le P n i) with hlt | heq
  · have := h.improvement_round_le P n i hlt
    omega
  · exact heq

/-- Every iteration after the scalar bound equals the valuation at that bound. -/
theorem iterate_add (P : Program W n) (k : Nat) :
    iterate A P (n + k) = iterate A P n := by
  induction k with
  | zero => rfl
  | succ k ih =>
    change step A P (iterate A P (n + k)) = _
    rw [ih]
    exact h.iterate_fixed P

/-- The convergence certificate with the scalar count as its round bound;
existence does not require an external solver. -/
def certificate (P : Program W n) : Certificate A P n where
  rounds := n
  within := le_rfl
  fixed := h.iterate_fixed P

/-- The valuation after the scalar-count number of rounds is the least solution
in information order, equivalently the greatest carrier-order fixed valuation. -/
theorem iterate_least (P : Program W n) :
    step A P (iterate A P n) = iterate A P n ∧
    ∀ y, step A P y = y → StateLe A (iterate A P n) y :=
  certificate_least A P n (h.certificate P)

/-- A strict improvement at round `k + 2` forces `k + 1` distinct rule outputs
whose values at that round lie below the improved value. -/
theorem late_improvement_coordinates (P : Program W n) (k : Nat) (i : Fin n)
    (hlt : iterate A P (k + 2) i < iterate A P (k + 1) i) :
    ∃ s : Finset (Fin n), s ⊆ ruleOutputs P ∧ s.card = k + 1 ∧
      ∀ j ∈ s, iterate A P (k + 2) j ≤ iterate A P (k + 2) i := by
  induction k generalizing i with
  | zero =>
    obtain ⟨hi, _⟩ := h.step_improvement P (iterate A P 1) (iterate A P 0) i hlt
    refine ⟨{i}, ?_, by simp, by simp⟩
    intro j hj
    rw [Finset.mem_singleton.mp hj]
    exact List.mem_toFinset.mpr hi
  | succ k ih =>
    obtain ⟨hi, j, hj, hjc⟩ := h.step_improvement P
      (iterate A P (k + 2)) (iterate A P (k + 1)) i hlt
    obtain ⟨s, hsub, hcard, hs⟩ := ih j hj
    have hnot : i ∉ s := by
      intro hi'
      exact absurd (lt_of_le_of_lt (le_trans (hs i hi') hjc) hlt) (lt_irrefl _)
    refine ⟨insert i s, ?_, ?_, ?_⟩
    · intro a ha
      rcases Finset.mem_insert.mp ha with rfl | ha
      · exact List.mem_toFinset.mpr hi
      · exact hsub ha
    · rw [Finset.card_insert_of_notMem hnot, hcard]
    · intro a ha
      rcases Finset.mem_insert.mp ha with rfl | ha
      · exact le_rfl
      · exact le_trans (h.iterate_succ_le P (k + 2) a) (le_trans (hs a ha) hjc)

/-- Every program is fixed one round beyond its number of distinct rule outputs. -/
theorem fixed_after_outputs (P : Program W n) :
    step A P (iterate A P ((ruleOutputs P).card + 1)) =
      iterate A P ((ruleOutputs P).card + 1) := by
  funext i
  rcases lt_or_eq_of_le (h.iterate_succ_le P ((ruleOutputs P).card + 1) i) with hlt | heq
  · obtain ⟨s, hsub, hcard, _⟩ := h.late_improvement_coordinates P (ruleOutputs P).card i hlt
    have := Finset.card_le_card hsub
    omega
  · exact heq

/-- Every program is fixed within one round beyond its number of distinct rule
outputs, capped by its total scalar count. -/
theorem rule_output_fixed (P : Program W n) :
    step A P (iterate A P (ruleOutputBound P)) = iterate A P (ruleOutputBound P) := by
  by_cases hn : n ≤ (ruleOutputs P).card + 1
  · simp only [ruleOutputBound, min_eq_left hn]
    exact h.iterate_fixed P
  · have h' : (ruleOutputs P).card + 1 ≤ n := by omega
    simp only [ruleOutputBound, min_eq_right h']
    exact h.fixed_after_outputs P

/-- A convergence certificate at the rule-output bound, admitted under the
total scalar-count bound. -/
def ruleOutputCertificate (P : Program W n) : Certificate A P n where
  rounds := ruleOutputBound P
  within := min_le_left _ _
  fixed := h.rule_output_fixed P

/-- The rule-output-bound iterate is the least fixed valuation. -/
theorem rule_output_least (P : Program W n) :
    step A P (iterate A P (ruleOutputBound P)) = iterate A P (ruleOutputBound P) ∧
    ∀ y, step A P y = y → StateLe A (iterate A P (ruleOutputBound P)) y :=
  certificate_least A P n (h.ruleOutputCertificate P)

end OrderedInflationary

end WeightedRules
