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
adversarial cover), and prove the elementary weak-duality bound `ν ≤ τ`.

This is the *easy* direction only — `ν ≤ τ` holds for every hypergraph. It is
**not** König's theorem, whose equality `ν = τ` needs bipartiteness and is not
claimed here. The definitions are pinned by `card_le_matchingNumber` /
`transversalNumber_le_card` (each is the intended extremal value, upper/lower
bound + attained), and exercised on a concrete hypergraph in the examples below.

The strict gap `τ > ν` on a positive fraction of coordinates is the point of the
repair-hypergraph transfer (`RepairCodes` §1.4) and the `δ_x = τ`
completion-distance invariant shared into `CompletionCore` (Phase 1 step 2);
`ν ≤ τ` is the baseline those build on. The strictness is real: the triangle
hypergraph example below exhibits `ν = 1 < 2 = τ` (so `ν ≤ τ` cannot be
strengthened to equality). A *code-derived* `τ > ν` instance — the LRC repair
hypergraph of a real coordinate — still waits on the concrete `FiniteGeom` code
layer. Self-contained combinatorics — no field or code structure appears here.
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
/-- **Weak duality, pointwise.** Any matching is no larger than any transversal
(the elementary `ν ≤ τ` direction — *not* König's equality, which needs
bipartiteness and is not claimed): each matched edge is hit by the cover, and
matched edges being pairwise disjoint, distinct edges are hit by distinct cover
vertices. -/
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

omit [Fintype V] [DecidableEq V] in
/-- `ν(H)` is an upper bound on every matching size: `ν` is the *sup*. Together
with attainment (`Nat.sSup_mem`) this pins `matchingNumber` to the intended
"largest matching size". -/
theorem card_le_matchingNumber {H M : Finset (Finset V)} (hM : IsMatching H M) :
    M.card ≤ matchingNumber H :=
  le_csSup ⟨H.card, by rintro n ⟨M', hM', rfl⟩; exact card_le_card hM'.1⟩ ⟨M, hM, rfl⟩

omit [Fintype V] in
/-- `τ(H)` is a lower bound on every transversal size: `τ` is the *inf*. Together
with attainment (`Nat.sInf_mem`) this pins `transversalNumber` to the intended
"smallest transversal size". -/
theorem transversalNumber_le_card {H : Finset (Finset V)} {T : Finset V}
    (hT : IsTransversal H T) : transversalNumber H ≤ T.card :=
  Nat.sInf_le ⟨T, hT, rfl⟩

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

omit [Fintype V] in
/-- **`p`-uniform transversal bound: `τ(H) ≤ p · ν(H)`** when every edge is nonempty with at
most `p` vertices. This is the finite structural counterpart to the imported asymptotic
`τ/ν → p` (plan §5 decision 3: the elementary bounds are *proved*, not axiomatized). Proof: the
vertex set of a **maximum** matching `M` is a transversal — any edge meeting none of `M`'s edges
would extend `M`, contradicting maximality — and it has at most `p` vertices per matched edge, so
`τ ≤ |⋃M| ≤ p·|M| = p·ν`. -/
theorem transversalNumber_le_mul_matchingNumber (H : Finset (Finset V)) (p : ℕ)
    (hne : ∀ e ∈ H, e.Nonempty) (hp : ∀ e ∈ H, e.card ≤ p) :
    transversalNumber H ≤ p * matchingNumber H := by
  classical
  have hAne : ({n | ∃ M, IsMatching H M ∧ M.card = n} : Set ℕ).Nonempty :=
    ⟨0, ∅, ⟨empty_subset H, fun a ha => by simp at ha⟩, card_empty⟩
  have hAbdd : BddAbove {n | ∃ M, IsMatching H M ∧ M.card = n} :=
    ⟨H.card, fun n hn => by obtain ⟨M, hM, rfl⟩ := hn; exact card_le_card hM.1⟩
  obtain ⟨M, hM, hMcard⟩ := Nat.sSup_mem hAne hAbdd
  have hMν : matchingNumber H = M.card := by unfold matchingNumber; exact hMcard.symm
  -- the vertex set of the maximum matching is a transversal.
  have hT : IsTransversal H (M.biUnion id) := by
    intro e he
    by_contra hcon
    rw [Finset.not_nonempty_iff_eq_empty] at hcon
    have hdisjTe : Disjoint (M.biUnion id) e := Finset.disjoint_iff_inter_eq_empty.mpr hcon
    have heM : e ∉ M := by
      intro heM
      obtain ⟨v, hv⟩ := hne e he
      exact (Finset.disjoint_left.mp hdisjTe ((Finset.subset_biUnion_of_mem id heM) hv)) hv
    have hM' : IsMatching H (insert e M) := by
      refine ⟨Finset.insert_subset he hM.1, ?_⟩
      intro a ha b hb hab
      rw [Finset.mem_insert] at ha hb
      rcases ha with rfl | ha <;> rcases hb with rfl | hb
      · exact absurd rfl hab
      · exact hdisjTe.symm.mono_right (Finset.subset_biUnion_of_mem id hb)
      · exact (hdisjTe.symm.mono_right (Finset.subset_biUnion_of_mem id ha)).symm
      · exact hM.2 ha hb hab
    have hle := card_le_matchingNumber hM'
    rw [hMν, Finset.card_insert_of_notMem heM] at hle
    omega
  calc transversalNumber H
      ≤ (M.biUnion id).card := transversalNumber_le_card hT
    _ ≤ ∑ _f ∈ M, p :=
        le_trans Finset.card_biUnion_le
          (Finset.sum_le_sum (fun f hf => by simp only [id_eq]; exact hp f (hM.1 hf)))
    _ = M.card * p := by rw [Finset.sum_const, smul_eq_mul]
    _ = p * matchingNumber H := by rw [hMν, Nat.mul_comm]

/-- Concrete exercise of the whole API: the one-edge hypergraph `{{0,1}}` on
`Fin 2` has `ν = τ = 1`. Drives `IsMatching` / `IsTransversal`, the definition
pins (`card_le_matchingNumber`, `transversalNumber_le_card`), and `nu_le_tau`
end-to-end, catching a `sSup`/`sInf` swap or off-by-one in the definitions. -/
example :
    matchingNumber ({{0, 1}} : Finset (Finset (Fin 2))) = 1 ∧
      transversalNumber ({{0, 1}} : Finset (Finset (Fin 2))) = 1 := by
  have hM : IsMatching ({{0, 1}} : Finset (Finset (Fin 2))) {{0, 1}} := by
    refine ⟨subset_refl _, ?_⟩
    intro a ha b hb hab
    rw [mem_singleton] at ha hb
    exact absurd (ha.trans hb.symm) hab
  have hT : IsTransversal ({{0, 1}} : Finset (Finset (Fin 2))) {0} := by
    intro e he
    rw [mem_singleton] at he
    subst he
    exact ⟨0, by decide⟩
  have hne : ∀ e ∈ ({{0, 1}} : Finset (Finset (Fin 2))), e.Nonempty := by
    intro e he
    rw [mem_singleton] at he
    subst he
    exact ⟨0, by decide⟩
  have h1 : (1 : ℕ) ≤ matchingNumber ({{0, 1}} : Finset (Finset (Fin 2))) := by
    simpa using card_le_matchingNumber hM
  have h2 : transversalNumber ({{0, 1}} : Finset (Finset (Fin 2))) ≤ 1 := by
    simpa using transversalNumber_le_card hT
  have h3 := nu_le_tau ({{0, 1}} : Finset (Finset (Fin 2))) hne
  exact ⟨by omega, by omega⟩

/-- The triangle hypergraph `{{0,1},{1,2},{0,2}}` on `Fin 3`: three pairwise-intersecting
edges. It witnesses the strict gap `ν = 1 < 2 = τ`, so weak duality `ν ≤ τ` is *not* an
equality in general (contrast the one-edge example above, where `ν = τ`). This is the
combinatorial demonstration of the `τ > ν` phenomenon the repair-hypergraph transfer exploits.
`RepairCodes.Q9Seed` now supplies a code-derived repair hypergraph; its exact `ν=3, τ=5`
evaluation is the remaining strict-gap goal. -/
example :
    matchingNumber ({{0, 1}, {1, 2}, {0, 2}} : Finset (Finset (Fin 3))) = 1 ∧
      transversalNumber ({{0, 1}, {1, 2}, {0, 2}} : Finset (Finset (Fin 3))) = 2 := by
  classical
  set H : Finset (Finset (Fin 3)) := {{0, 1}, {1, 2}, {0, 2}} with hH
  -- distinct edges of the triangle always share a vertex (never disjoint).
  have hint : ∀ a ∈ H, ∀ b ∈ H, a ≠ b → ¬ Disjoint a b := by decide
  -- ν ≥ 1 via a single-edge matching; ν ≤ 1 because a matching's edges are pairwise disjoint.
  have hMone : IsMatching H {{0, 1}} := by
    refine ⟨by decide, ?_⟩
    intro a ha b hb hab
    rw [mem_singleton] at ha hb
    exact absurd (ha.trans hb.symm) hab
  have hnu_ge : 1 ≤ matchingNumber H := by simpa using card_le_matchingNumber hMone
  have hnu_le : matchingNumber H ≤ 1 := by
    unfold matchingNumber
    refine csSup_le ⟨0, ∅, ⟨empty_subset _, by intro a ha; simp at ha⟩, card_empty⟩ ?_
    rintro n ⟨M, hM, rfl⟩
    rw [Finset.card_le_one]
    intro a ha b hb
    by_contra hab
    exact hint a (hM.1 ha) b (hM.1 hb) hab (hM.2 ha hb hab)
  -- τ ≤ 2 via the cover {0,1}; τ ≥ 2 because no single vertex meets all three edges.
  have hTtwo : IsTransversal H ({0, 1} : Finset (Fin 3)) := by
    intro e he; fin_cases he <;> decide
  have htau_le : transversalNumber H ≤ 2 := by
    simpa using transversalNumber_le_card hTtwo
  have hTne : ({n | ∃ T, IsTransversal H T ∧ T.card = n} : Set ℕ).Nonempty :=
    ⟨2, {0, 1}, hTtwo, by decide⟩
  have htau_ge : 2 ≤ transversalNumber H := by
    have hlb : ∀ T : Finset (Fin 3), (∀ e ∈ H, (T ∩ e).Nonempty) → 2 ≤ T.card := by decide
    unfold transversalNumber
    exact le_csInf hTne (by rintro n ⟨T, hT, rfl⟩; exact hlb T fun e he => hT he)
  exact ⟨by omega, by omega⟩

end FiniteGeom
