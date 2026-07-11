import FiniteGeom.Hypergraph

/-!
# Completion distance as a transversal number: `δ_x = τ(𝓗_C(x))` (shared `FiniteGeom` base)

Phase 1 step 2 of the formalization plan
([`notes/handoffs/2026-07-11-lean-formalization-plan.md`](../notes)): the completion-distance
invariant of completion-core Prop 2.2 ([`notes/2026-07-10-completion-core-rigidity-upgrades.md`](../notes)),
built in the shared base so both `RepairCodes` and `CompletionCore` cite one proof.

## What is modelled, and what is folded into the definition (abstract-first)

For a facet `C` and an external symbol `x ∉ C`, Prop 2.2 forms the **circuit-trace hypergraph**
`𝓗_C(x) = {A ⊆ C : A ∪ {x} is a circuit}` and states

  `δ_x(C) = τ(𝓗_C(x))`,

the deletion cost of inserting `x` (the fewest elements of `C` to erase so that `(C∖D) ∪ {x}`
becomes independent) equals the transversal number of `𝓗_C(x)`.

Following the plan's abstract-first decision, the *matroid* content of the paper's proof —
"`(C∖D) ∪ {x}` is independent exactly when it contains no circuit, and since `C` is independent
every relevant circuit contains `x`" — is folded into the **definition** of the deletion
predicate: a deletion `D` makes the insertion independent iff no circuit trace `A ∈ 𝓗_C(x)`
survives the deletion (`A ⊄ C ∖ D`). That is exactly the paper's characterization, so the
resulting statement `completionDistance = transversalNumber` is the finite content of Prop 2.2
with no imported input. A concrete matroid instance discharging "no surviving trace ⟺ independent"
is deferred to the instance layer; here `𝓗_C(x)` is any `Finset`-hypergraph with edges inside `C`.
-/

namespace FiniteGeom

open Finset

variable {V : Type*} [Fintype V] [DecidableEq V]

omit [Fintype V] in
/-- Bridge fact: for an edge `A ⊆ C`, the trace `A` **survives** the deletion `D` (i.e.
`A ⊆ C ∖ D`) exactly when `D` misses `A`. Contrapositive: `A` is destroyed iff `D` meets `A`.
This is what turns "no surviving circuit trace" into "`D` is a transversal". -/
theorem not_subset_sdiff_iff {C D A : Finset V} (hA : A ⊆ C) :
    ¬ A ⊆ C \ D ↔ (D ∩ A).Nonempty := by
  constructor
  · intro h
    rw [Finset.not_subset] at h
    obtain ⟨a, haA, haCD⟩ := h
    have haC : a ∈ C := hA haA
    have haD : a ∈ D := by
      by_contra haD
      exact haCD (Finset.mem_sdiff.mpr ⟨haC, haD⟩)
    exact ⟨a, Finset.mem_inter.mpr ⟨haD, haA⟩⟩
  · rintro ⟨a, ha⟩
    rw [Finset.mem_inter] at ha
    rw [Finset.not_subset]
    exact ⟨a, ha.2, fun h => (Finset.mem_sdiff.mp h).2 ha.1⟩

omit [Fintype V] in
/-- "Deleting `D` destroys every circuit trace" is, for a hypergraph with edges inside `C`,
literally "`D` is a transversal of the hypergraph". -/
theorem insertIndep_iff_transversal {H : Finset (Finset V)} {C D : Finset V}
    (hsub : ∀ A ∈ H, A ⊆ C) :
    (∀ A ∈ H, ¬ A ⊆ C \ D) ↔ IsTransversal H D := by
  constructor
  · intro h e he; exact (not_subset_sdiff_iff (hsub e he)).mp (h e he)
  · intro h A hA; exact (not_subset_sdiff_iff (hsub A hA)).mpr (h hA)

/-- Completion distance `δ_x(C)`: the fewest elements of `C` to delete so that inserting `x`
becomes independent — modelled (see the module docstring) as the fewest to delete so that no
circuit trace `A ∈ H = 𝓗_C(x)` survives. -/
noncomputable def completionDistance (H : Finset (Finset V)) (C : Finset V) : ℕ :=
  sInf {n | ∃ D, D ⊆ C ∧ (∀ A ∈ H, ¬ A ⊆ C \ D) ∧ D.card = n}

/-- **`δ_x(C) = τ(𝓗_C(x))` (completion-core Prop 2.2, finite content).** With every circuit
trace inside `C` and nonempty, the completion distance equals the transversal number of the
circuit-trace hypergraph. The `≥ τ` direction is immediate (a witnessing deletion *is* a
transversal); the `≤ τ` direction intersects a minimum transversal with `C` — legitimate
because every edge already lies in `C`, so nothing outside `C` is needed to cover. -/
theorem completionDistance_eq_transversalNumber (H : Finset (Finset V)) (C : Finset V)
    (hsub : ∀ A ∈ H, A ⊆ C) (hne : ∀ A ∈ H, A.Nonempty) :
    completionDistance H C = transversalNumber H := by
  classical
  -- the deletion-cost set is nonempty: deleting all of `C` destroys every (nonempty) trace.
  have hSne : ({n | ∃ D, D ⊆ C ∧ (∀ A ∈ H, ¬ A ⊆ C \ D) ∧ D.card = n} : Set ℕ).Nonempty := by
    refine ⟨C.card, C, subset_refl _, ?_, rfl⟩
    intro A hA hsubA
    have : A ⊆ (∅ : Finset V) := by simpa [sdiff_self] using hsubA
    exact (hne A hA).ne_empty (Finset.subset_empty.mp this)
  -- the transversal-size set is nonempty: `univ` covers every edge.
  have hTne : ({n | ∃ T, IsTransversal H T ∧ T.card = n} : Set ℕ).Nonempty :=
    ⟨Fintype.card V, univ, fun e he => by rw [univ_inter]; exact hne e he, card_univ⟩
  refine le_antisymm ?_ ?_
  · -- δ ≤ τ: intersect a minimum transversal `T` with `C`; `T ∩ C` still covers and is ⊆ C.
    obtain ⟨T, hT, hTcard⟩ := Nat.sInf_mem hTne
    set D := T ∩ C with hD
    have hDsub : D ⊆ C := inter_subset_right
    have hDtr : IsTransversal H D := by
      intro e he
      obtain ⟨v, hv⟩ := hT he
      rw [Finset.mem_inter] at hv
      exact ⟨v, Finset.mem_inter.mpr ⟨Finset.mem_inter.mpr ⟨hv.1, hsub e he hv.2⟩, hv.2⟩⟩
    have hDins : ∀ A ∈ H, ¬ A ⊆ C \ D := (insertIndep_iff_transversal hsub).mpr hDtr
    calc completionDistance H C
        ≤ D.card := Nat.sInf_le ⟨D, hDsub, hDins, rfl⟩
      _ ≤ T.card := card_le_card inter_subset_left
      _ = transversalNumber H := hTcard
  · -- τ ≤ δ: a minimum deletion `D₀` is itself a transversal.
    obtain ⟨D₀, hD₀sub, hD₀ins, hD₀card⟩ := Nat.sInf_mem hSne
    have hD₀tr : IsTransversal H D₀ := (insertIndep_iff_transversal hsub).mp hD₀ins
    calc transversalNumber H
        ≤ D₀.card := transversalNumber_le_card hD₀tr
      _ = completionDistance H C := hD₀card

end FiniteGeom
