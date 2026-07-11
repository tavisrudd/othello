import Mathlib.Tactic
import Mathlib.Data.Fintype.Card
import Mathlib.Algebra.Order.BigOperators.Group.Finset

/-!
# q-ary weight counting lemmas (shared `FiniteGeom` base)

Minimal, self-contained arithmetic used by the concatenation transfer lemma
(`RepairCodes.Transfer`) and, later, by the completion-core `δ_x = τ` layer.

These are pure `Finset` / `ℕ` bounds: the number of coordinates carrying a
nonzero (resp. `≥ d`) weight is controlled by the total weight. No field or
code structure appears here — that lives in the libraries that cite these
lemmas — which is why this is the shared base of the formalization plan.
-/

namespace FiniteGeom

open Finset

variable {ι : Type*} [Fintype ι]

/-- If every coordinate satisfying `P` carries weight at least one, then the
number of such coordinates is at most the total weight. This is the counting
core of "`#nonzero blocks ≤ q-ary weight`". -/
theorem card_filter_le_sum (g : ι → ℕ) (P : ι → Prop) [DecidablePred P]
    (h : ∀ i, P i → 1 ≤ g i) :
    (univ.filter P).card ≤ ∑ i, g i := by
  calc (univ.filter P).card
      = ∑ _i ∈ univ.filter P, 1 := by rw [card_eq_sum_ones]
    _ ≤ ∑ i ∈ univ.filter P, g i :=
        sum_le_sum (fun i hi => h i (mem_filter.mp hi).2)
    _ ≤ ∑ i, g i := sum_le_sum_of_subset (filter_subset _ _)

/-- If every coordinate satisfying `P` carries weight at least `d`, then
`d * (#coordinates satisfying P) ≤ total weight`. This is the lower bound used
to force "few nonzero blocks": each nonzero inner-dual block spends at least
the dual distance `d` of the total budget. -/
theorem mul_card_filter_le_sum (g : ι → ℕ) (P : ι → Prop) [DecidablePred P]
    (d : ℕ) (h : ∀ i, P i → d ≤ g i) :
    d * (univ.filter P).card ≤ ∑ i, g i := by
  have hconst : ∑ _i ∈ univ.filter P, d = (univ.filter P).card * d := by
    rw [sum_const, smul_eq_mul]
  calc d * (univ.filter P).card
      = (univ.filter P).card * d := Nat.mul_comm _ _
    _ = ∑ _i ∈ univ.filter P, d := hconst.symm
    _ ≤ ∑ i ∈ univ.filter P, g i :=
        sum_le_sum (fun i hi => h i (mem_filter.mp hi).2)
    _ ≤ ∑ i, g i := sum_le_sum_of_subset (filter_subset _ _)

end FiniteGeom
