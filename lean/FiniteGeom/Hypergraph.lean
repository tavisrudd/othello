import Mathlib.Tactic
import Mathlib.Data.Fintype.Card
import Mathlib.Order.Lattice.Nat

/-!
# Hypergraph matching `ν` and transversal `τ` (shared `FiniteGeom` base)

The minimal `Finset`-of-`Finset` hypergraph layer the formalization plan calls
for ([`notes/handoffs/2026-07-11-lean-formalization-plan.md`](../notes) §3). A
hypergraph is its edge set `H : Finset (Finset V)` — in the LRC application the
edges are the recovery/repair sets of a coordinate. We define the matching
number `ν(H)` (largest set of pairwise-disjoint recovery sets = disjoint
availability) and the transversal number `τ(H)` (smallest hitting set =
adversarial cover), and prove the König-type inequality `ν ≤ τ`.

The strict gap `τ > ν` on a positive fraction of coordinates is the whole point
of the repair-hypergraph transfer (`RepairCodes` §1.4) and the `δ_x = τ`
completion-distance invariant shared into `CompletionCore` (Phase 1 step 2);
`ν ≤ τ` is the baseline those build on. Self-contained combinatorics — no field
or code structure appears here.
-/

namespace FiniteGeom

open Finset

variable {V : Type*} [Fintype V] [DecidableEq V]

/-- `M` is a matching of the hypergraph `H`: a subfamily of pairwise-disjoint
edges. -/
def IsMatching (H M : Finset (Finset V)) : Prop :=
  M ⊆ H ∧ ∀ ⦃a⦄, a ∈ M → ∀ ⦃b⦄, b ∈ M → a ≠ b → Disjoint a b

/-- `T` is a transversal (vertex cover) of `H`: it meets every edge. -/
def IsTransversal (H : Finset (Finset V)) (T : Finset V) : Prop :=
  ∀ ⦃e⦄, e ∈ H → (T ∩ e).Nonempty

omit [Fintype V] in
/-- **König-type inequality, pointwise.** Any matching is no larger than any
transversal: each matched edge is hit by the cover, and matched edges being
pairwise disjoint, distinct edges are hit by distinct cover vertices. -/
theorem matching_card_le_transversal_card {H M : Finset (Finset V)} {T : Finset V}
    (hM : IsMatching H M) (hT : IsTransversal H T) : M.card ≤ T.card := by
  classical
  rcases M.eq_empty_or_nonempty with hM0 | ⟨e0, he0⟩
  · simp [hM0]
  · obtain ⟨v0, -⟩ := hT (hM.1 he0)
    -- pick, for each matched edge, a cover vertex it contains
    set f : Finset V → V := fun e => if h : (T ∩ e).Nonempty then h.choose else v0 with hf
    have hmem : ∀ e ∈ M, f e ∈ e ∧ f e ∈ T := by
      intro e he
      have hne : (T ∩ e).Nonempty := hT (hM.1 he)
      have hfe : f e = hne.choose := by simp only [hf]; exact dif_pos hne
      rw [hfe]
      exact ⟨Finset.mem_of_mem_inter_right hne.choose_spec,
             Finset.mem_of_mem_inter_left hne.choose_spec⟩
    refine Finset.card_le_card_of_injOn f (fun e he => (hmem e he).2) ?_
    intro a ha b hb hab
    rw [Finset.mem_coe] at ha hb
    by_contra hne
    have hdisj := hM.2 ha hb hne
    have hfa := (hmem a ha).1
    have hfb := (hmem b hb).1
    rw [hab] at hfa
    exact (Finset.disjoint_left.mp hdisj hfa) hfb

open scoped Classical in
/-- Matching number `ν(H)`: the largest size of a matching of `H`. -/
noncomputable def matchingNumber (H : Finset (Finset V)) : ℕ :=
  sSup {n | ∃ M, IsMatching H M ∧ M.card = n}

open scoped Classical in
/-- Transversal number `τ(H)`: the smallest size of a transversal of `H`. -/
noncomputable def transversalNumber (H : Finset (Finset V)) : ℕ :=
  sInf {n | ∃ T, IsTransversal H T ∧ T.card = n}

/-- **`ν(H) ≤ τ(H)`.** The matching number never exceeds the transversal number
(assuming every edge is nonempty, so that a transversal exists). -/
theorem nu_le_tau (H : Finset (Finset V)) (hne : ∀ e ∈ H, e.Nonempty) :
    matchingNumber H ≤ transversalNumber H := by
  classical
  have hAne : ({n | ∃ M, IsMatching H M ∧ M.card = n} : Set ℕ).Nonempty :=
    ⟨0, ∅, ⟨empty_subset H, fun a ha => by simp at ha⟩, card_empty⟩
  have hAbdd : BddAbove {n | ∃ M, IsMatching H M ∧ M.card = n} :=
    ⟨H.card, fun n hn => by obtain ⟨M, hM, rfl⟩ := hn; exact card_le_card hM.1⟩
  have hBne : ({n | ∃ T, IsTransversal H T ∧ T.card = n} : Set ℕ).Nonempty :=
    ⟨Fintype.card V, univ, fun e he => by rw [univ_inter]; exact hne e he, card_univ⟩
  obtain ⟨M, hM, hMcard⟩ := Nat.sSup_mem hAne hAbdd
  obtain ⟨T, hT, hTcard⟩ := Nat.sInf_mem hBne
  unfold matchingNumber transversalNumber
  calc sSup {n | ∃ M, IsMatching H M ∧ M.card = n}
      = M.card := hMcard.symm
    _ ≤ T.card := matching_card_le_transversal_card hM hT
    _ = sInf {n | ∃ T, IsTransversal H T ∧ T.card = n} := hTcard

end FiniteGeom
