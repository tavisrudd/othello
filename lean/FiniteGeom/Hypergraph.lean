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

/-- Relabel every vertex and edge of a finite hypergraph along an equivalence. -/
def relabelHypergraph {W : Type*} [DecidableEq W] (e : V ≃ W)
    (H : Finset (Finset V)) : Finset (Finset W) :=
  H.image fun s => s.map e.toEmbedding

/-- Embed a hypergraph into a possibly larger vertex type.  Vertices outside the image are
isolated and therefore do not affect matching data. -/
def embedHypergraph {W : Type*} [DecidableEq W] (e : V ↪ W)
    (H : Finset (Finset V)) : Finset (Finset W) :=
  H.image fun s => s.map e

omit [Fintype V] [DecidableEq V] in
theorem card_relabelHypergraph {W : Type*} [DecidableEq W] (e : V ≃ W)
    (H : Finset (Finset V)) : (relabelHypergraph e H).card = H.card := by
  apply Finset.card_image_of_injective
  exact Finset.map_injective e.toEmbedding

omit [Fintype V] [DecidableEq V] in
theorem card_embedHypergraph {W : Type*} [DecidableEq W] (e : V ↪ W)
    (H : Finset (Finset V)) : (embedHypergraph e H).card = H.card := by
  apply Finset.card_image_of_injective
  exact Finset.map_injective e

omit [Fintype V] in
theorem relabelHypergraph_symm {W : Type*} [DecidableEq W] (e : V ≃ W)
    (H : Finset (Finset V)) : relabelHypergraph e.symm (relabelHypergraph e H) = H := by
  ext s
  simp [relabelHypergraph, Finset.map_map]

/-- `M` is a matching of the hypergraph `H`: a subfamily of pairwise-disjoint
edges. -/
def IsMatching (H M : Finset (Finset V)) : Prop :=
  M ⊆ H ∧ ∀ ⦃a⦄, a ∈ M → ∀ ⦃b⦄, b ∈ M → a ≠ b → Disjoint a b

/-- `T` is a transversal (vertex cover) of `H`: it meets every edge. -/
def IsTransversal (H : Finset (Finset V)) (T : Finset V) : Prop :=
  ∀ ⦃e⦄, e ∈ H → (T ∩ e).Nonempty

/-- A vertex set is hypergraph-independent when it contains no edge. -/
def IsIndependent (H : Finset (Finset V)) (S : Finset V) : Prop :=
  ∀ ⦃e⦄, e ∈ H → ¬ e ⊆ S

/-- Complements exchange transversals and independent sets. -/
theorem isTransversal_compl_iff {H : Finset (Finset V)} {S : Finset V} :
    IsTransversal H (univ \ S) ↔ IsIndependent H S := by
  constructor
  · intro hT E hE hES
    obtain ⟨v, hv⟩ := hT hE
    have hv' := Finset.mem_inter.mp hv
    exact (Finset.mem_sdiff.mp hv'.1).2 (hES hv'.2)
  · intro hS E hE
    by_contra hnone
    rw [Finset.not_nonempty_iff_eq_empty] at hnone
    apply hS hE
    intro v hvE
    by_contra hvS
    have hvC : v ∈ univ \ S := by simp [hvS]
    have : v ∈ (univ \ S) ∩ E := Finset.mem_inter.mpr ⟨hvC, hvE⟩
    rw [hnone] at this
    simp at this

/-- The inclusion-minimal edges of a finite hypergraph.  Passing from a hypergraph to this
clutter removes redundant supersets without changing either extremal invariant, provided the
edges are nonempty for the matching statement. -/
def minimalHyperedges (H : Finset (Finset V)) : Finset (Finset V) :=
  H.filter fun A => ∀ B ∈ H, B ⊆ A → A ⊆ B

/-- The two-element subsets of a finite type, viewed as the edge set of its complete graph. -/
def completePairHypergraph (V : Type*) [Fintype V] [DecidableEq V] :
    Finset (Finset V) :=
  univ.powersetCard 2

@[simp] theorem mem_completePairHypergraph {E : Finset V} :
    E ∈ completePairHypergraph V ↔ E.card = 2 := by
  simp [completePairHypergraph]

theorem mem_minimalHyperedges {H : Finset (Finset V)} {A : Finset V} :
    A ∈ minimalHyperedges H ↔ A ∈ H ∧ ∀ B ∈ H, B ⊆ A → A ⊆ B := by
  simp [minimalHyperedges]

/-- Every edge of a finite hypergraph contains an inclusion-minimal edge. -/
theorem exists_minimalHyperedge_subset {H : Finset (Finset V)} {A : Finset V}
    (hA : A ∈ H) : ∃ B ∈ minimalHyperedges H, B ⊆ A := by
  classical
  let sizes : Set ℕ := {n | ∃ B ∈ H, B ⊆ A ∧ B.card = n}
  have hsizes : sizes.Nonempty := ⟨A.card, A, hA, subset_refl _, rfl⟩
  obtain ⟨B, hBH, hBA, hBcard⟩ := Nat.sInf_mem hsizes
  refine ⟨B, mem_minimalHyperedges.mpr ⟨hBH, ?_⟩, hBA⟩
  intro C hCH hCB
  have hle : B.card ≤ C.card := by
    rw [hBcard]
    exact Nat.sInf_le ⟨C, hCH, hCB.trans hBA, rfl⟩
  have hEq : C = B := Finset.eq_of_subset_of_card_le hCB hle
  simp [hEq]

/-- A set hits every edge iff it hits every inclusion-minimal edge. -/
theorem isTransversal_minimalHyperedges_iff {H : Finset (Finset V)} {T : Finset V} :
    IsTransversal (minimalHyperedges H) T ↔ IsTransversal H T := by
  constructor
  · intro hT A hA
    obtain ⟨B, hB, hBA⟩ := exists_minimalHyperedge_subset hA
    obtain ⟨v, hv⟩ := hT hB
    exact ⟨v, Finset.mem_inter.mpr ⟨(Finset.mem_inter.mp hv).1,
      hBA (Finset.mem_inter.mp hv).2⟩⟩
  · intro hT A hA
    exact hT (mem_minimalHyperedges.mp hA).1

omit [Fintype V] [DecidableEq V] in
theorem IsMatching.relabelHypergraph {W : Type*} [Fintype W] [DecidableEq W]
    (e : V ≃ W) {H M : Finset (Finset V)} (h : IsMatching H M) :
    IsMatching (relabelHypergraph e H) (relabelHypergraph e M) := by
  refine ⟨?_, ?_⟩
  · intro edge hedge
    obtain ⟨edge0, hedge0, rfl⟩ := Finset.mem_image.mp hedge
    exact Finset.mem_image.mpr ⟨edge0, h.1 hedge0, rfl⟩
  intro a ha b hb hab
  obtain ⟨a0, ha0, rfl⟩ := Finset.mem_image.mp ha
  obtain ⟨b0, hb0, rfl⟩ := Finset.mem_image.mp hb
  apply (Finset.disjoint_map e.toEmbedding).mpr
  apply h.2 ha0 hb0
  intro h0
  apply hab
  exact congrArg (fun s => s.map e.toEmbedding) h0

theorem isMatching_relabelHypergraph_iff {W : Type*} [Fintype W] [DecidableEq W]
    (e : V ≃ W) {H M : Finset (Finset V)} :
    IsMatching (relabelHypergraph e H) (relabelHypergraph e M) ↔ IsMatching H M := by
  constructor
  · intro h
    have h' := h.relabelHypergraph e.symm
    simpa only [relabelHypergraph_symm] using h'
  · exact fun h => h.relabelHypergraph e

omit [Fintype V] [DecidableEq V] in
theorem IsMatching.embedHypergraph {W : Type*} [Fintype W] [DecidableEq W]
    (e : V ↪ W) {H M : Finset (Finset V)} (h : IsMatching H M) :
    IsMatching (embedHypergraph e H) (embedHypergraph e M) := by
  refine ⟨?_, ?_⟩
  · intro edge hedge
    obtain ⟨edge0, hedge0, rfl⟩ := Finset.mem_image.mp hedge
    exact Finset.mem_image.mpr ⟨edge0, h.1 hedge0, rfl⟩
  · intro a ha b hb hab
    obtain ⟨a0, ha0, rfl⟩ := Finset.mem_image.mp ha
    obtain ⟨b0, hb0, rfl⟩ := Finset.mem_image.mp hb
    apply (Finset.disjoint_map e).mpr
    apply h.2 ha0 hb0
    intro h0
    exact hab (congrArg (fun s => s.map e) h0)

omit [Fintype V] in
theorem IsTransversal.embedHypergraph {W : Type*} [Fintype W] [DecidableEq W]
    (e : V ↪ W) {H : Finset (Finset V)} {T : Finset V} (h : IsTransversal H T) :
    IsTransversal (embedHypergraph e H) (T.map e) := by
  intro E hE
  obtain ⟨E₀, hE₀, rfl⟩ := Finset.mem_image.mp hE
  obtain ⟨v, hv⟩ := h hE₀
  have hv' := Finset.mem_inter.mp hv
  exact ⟨e v, Finset.mem_inter.mpr ⟨Finset.mem_map.mpr ⟨v, hv'.1, rfl⟩,
    Finset.mem_map.mpr ⟨v, hv'.2, rfl⟩⟩⟩

omit [Fintype V] in
theorem IsTransversal.relabelHypergraph {W : Type*} [Fintype W] [DecidableEq W]
    (e : V ≃ W) {H : Finset (Finset V)} {T : Finset V} (h : IsTransversal H T) :
    IsTransversal (relabelHypergraph e H) (T.map e.toEmbedding) := by
  intro edge hedge
  obtain ⟨edge0, hedge0, rfl⟩ := Finset.mem_image.mp hedge
  obtain ⟨v, hv⟩ := h hedge0
  exact ⟨e v, Finset.mem_inter.mpr ⟨Finset.mem_map.mpr ⟨v,
    Finset.mem_of_mem_inter_left hv, rfl⟩, Finset.mem_map.mpr ⟨v,
    Finset.mem_of_mem_inter_right hv, rfl⟩⟩⟩

theorem isTransversal_relabelHypergraph_iff {W : Type*} [Fintype W] [DecidableEq W]
    (e : V ≃ W) {H : Finset (Finset V)} {T : Finset V} :
    IsTransversal (relabelHypergraph e H) (T.map e.toEmbedding) ↔ IsTransversal H T := by
  constructor
  · intro h
    have h' := h.relabelHypergraph e.symm
    simpa [relabelHypergraph_symm, Finset.map_map] using h'
  · exact fun h => h.relabelHypergraph e

omit [Fintype V] [DecidableEq V] in
theorem IsIndependent.relabelHypergraph {W : Type*} [Fintype W] [DecidableEq W]
    (e : V ≃ W) {H : Finset (Finset V)} {S : Finset V} (h : IsIndependent H S) :
    IsIndependent (relabelHypergraph e H) (S.map e.toEmbedding) := by
  intro E hE hES
  obtain ⟨E₀, hE₀, rfl⟩ := Finset.mem_image.mp hE
  apply h hE₀
  intro v hv
  have hev : e v ∈ S.map e.toEmbedding := hES (Finset.mem_map.mpr ⟨v, hv, rfl⟩)
  obtain ⟨w, hwS, hw⟩ := Finset.mem_map.mp hev
  exact (e.injective hw).symm ▸ hwS

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

/-- Independence number, expressed through complement duality with transversals. -/
noncomputable def independenceNumber (H : Finset (Finset V)) : ℕ :=
  Fintype.card V - transversalNumber H

omit [Fintype V] [DecidableEq V] in
/-- The matching number of a finite hypergraph is attained by an actual matching. -/
theorem exists_matching_card_eq_matchingNumber (H : Finset (Finset V)) :
    ∃ M, IsMatching H M ∧ M.card = matchingNumber H := by
  have hne : ({m | ∃ M, IsMatching H M ∧ M.card = m} : Set ℕ).Nonempty :=
    ⟨0, ∅, ⟨Finset.empty_subset H, fun _ hm => by simp at hm⟩, Finset.card_empty⟩
  have hbdd : BddAbove {m | ∃ M, IsMatching H M ∧ M.card = m} :=
    ⟨H.card, by
      intro m hm
      obtain ⟨M, hM, rfl⟩ := hm
      exact Finset.card_le_card hM.1⟩
  obtain ⟨M, hM, hMcard⟩ := Nat.sSup_mem hne hbdd
  refine ⟨M, hM, ?_⟩
  unfold matchingNumber
  exact hMcard

/-- The transversal number is attained when every edge is nonempty. -/
theorem exists_transversal_card_eq_transversalNumber (H : Finset (Finset V))
    (hne : ∀ E ∈ H, E.Nonempty) :
    ∃ T, IsTransversal H T ∧ T.card = transversalNumber H := by
  have hset : ({n | ∃ T, IsTransversal H T ∧ T.card = n} : Set ℕ).Nonempty :=
    ⟨Fintype.card V, univ, fun E hE => by rw [univ_inter]; exact hne E hE, card_univ⟩
  obtain ⟨T, hT, hTcard⟩ := Nat.sInf_mem hset
  refine ⟨T, hT, ?_⟩
  unfold transversalNumber
  exact hTcard

/-- Matching number is invariant under a bijective relabeling of vertices. -/
theorem matchingNumber_relabelHypergraph {W : Type*} [Fintype W] [DecidableEq W]
    (e : V ≃ W) (H : Finset (Finset V)) :
    matchingNumber (relabelHypergraph e H) = matchingNumber H := by
  unfold matchingNumber
  congr 1
  ext n
  constructor
  · rintro ⟨M, hM, rfl⟩
    let M0 := relabelHypergraph e.symm M
    have hM0 : IsMatching H M0 := by
      have h := hM.relabelHypergraph e.symm
      simpa only [relabelHypergraph_symm] using h
    refine ⟨M0, hM0, ?_⟩
    change (relabelHypergraph e.symm M).card = M.card
    exact card_relabelHypergraph e.symm M
  · rintro ⟨M, hM, rfl⟩
    exact ⟨relabelHypergraph e M, hM.relabelHypergraph e, card_relabelHypergraph e M⟩

/-- Transversal number is invariant under a bijective relabeling of vertices. -/
theorem transversalNumber_relabelHypergraph {W : Type*} [Fintype W] [DecidableEq W]
    (e : V ≃ W) (H : Finset (Finset V)) :
    transversalNumber (relabelHypergraph e H) = transversalNumber H := by
  unfold transversalNumber
  congr 1
  ext n
  constructor
  · rintro ⟨T, hT, rfl⟩
    let T0 := T.map e.symm.toEmbedding
    have hT0 : IsTransversal H T0 := by
      have h := hT.relabelHypergraph e.symm
      simpa [T0, relabelHypergraph_symm, Finset.map_map] using h
    exact ⟨T0, hT0, by simp [T0]⟩
  · rintro ⟨T, hT, rfl⟩
    exact ⟨T.map e.toEmbedding, hT.relabelHypergraph e, Finset.card_map e.toEmbedding⟩

/-- Every matching can be shrunk edgewise to a matching of inclusion-minimal edges with the
same cardinality, as long as the original edges are nonempty.  Nonemptiness is essential:
distinct disjoint edges could otherwise both shrink to the empty edge. -/
theorem exists_minimalHyperedges_matching {H M : Finset (Finset V)}
    (hne : ∀ e ∈ H, e.Nonempty) (hM : IsMatching H M) :
    ∃ N, IsMatching (minimalHyperedges H) N ∧ N.card = M.card := by
  classical
  let f : Finset V → Finset V := fun A =>
    if hA : A ∈ H then (exists_minimalHyperedge_subset hA).choose else ∅
  have hfmem : ∀ A ∈ M, f A ∈ minimalHyperedges H := by
    intro A hAM
    have hAH := hM.1 hAM
    simp only [f, dif_pos hAH]
    exact (exists_minimalHyperedge_subset hAH).choose_spec.1
  have hfsub : ∀ A ∈ M, f A ⊆ A := by
    intro A hAM
    have hAH := hM.1 hAM
    simp only [f, dif_pos hAH]
    exact (exists_minimalHyperedge_subset hAH).choose_spec.2
  have hfne : ∀ A ∈ M, (f A).Nonempty := by
    intro A hAM
    exact hne (f A) (mem_minimalHyperedges.mp (hfmem A hAM)).1
  have hfinj : Set.InjOn f M := by
    intro A hAM B hBM hEq
    by_contra hAB
    obtain ⟨v, hv⟩ := hfne A hAM
    have hvA : v ∈ A := hfsub A hAM hv
    have hvB : v ∈ B := hfsub B hBM (hEq ▸ hv)
    exact (Finset.disjoint_left.mp (hM.2 hAM hBM hAB) hvA) hvB
  let N := M.image f
  refine ⟨N, ?_, ?_⟩
  · refine ⟨?_, ?_⟩
    · intro B hBN
      obtain ⟨A, hAM, rfl⟩ := Finset.mem_image.mp hBN
      exact hfmem A hAM
    · intro A hAN B hBN hAB
      obtain ⟨A0, hA0M, rfl⟩ := Finset.mem_image.mp hAN
      obtain ⟨B0, hB0M, rfl⟩ := Finset.mem_image.mp hBN
      have hA0B0 : A0 ≠ B0 := by
        intro h
        exact hAB (congrArg f h)
      exact (hM.2 hA0M hB0M hA0B0).mono (hfsub A0 hA0M) (hfsub B0 hB0M)
  · exact Finset.card_image_iff.mpr hfinj

/-- Removing redundant supersets preserves matching number for nonempty hypergraphs. -/
theorem matchingNumber_minimalHyperedges (H : Finset (Finset V))
    (hne : ∀ e ∈ H, e.Nonempty) :
    matchingNumber (minimalHyperedges H) = matchingNumber H := by
  unfold matchingNumber
  congr 1
  ext n
  constructor
  · rintro ⟨M, hM, rfl⟩
    refine ⟨M, ⟨?_, hM.2⟩, rfl⟩
    intro A hA
    exact (mem_minimalHyperedges.mp (hM.1 hA)).1
  · rintro ⟨M, hM, rfl⟩
    obtain ⟨N, hN, hcard⟩ := exists_minimalHyperedges_matching hne hM
    exact ⟨N, hN, hcard⟩

/-- Removing redundant supersets preserves transversal number. -/
theorem transversalNumber_minimalHyperedges (H : Finset (Finset V)) :
    transversalNumber (minimalHyperedges H) = transversalNumber H := by
  unfold transversalNumber
  congr 1
  ext n
  constructor
  · rintro ⟨T, hT, rfl⟩
    exact ⟨T, isTransversal_minimalHyperedges_iff.mp hT, rfl⟩
  · rintro ⟨T, hT, rfl⟩
    exact ⟨T, isTransversal_minimalHyperedges_iff.mpr hT, rfl⟩

omit [Fintype V] [DecidableEq V] in
/-- To upper-bound `ν`, it suffices to upper-bound the cardinality of every matching. -/
theorem matchingNumber_le_of_forall {H : Finset (Finset V)} {n : ℕ}
    (h : ∀ M, IsMatching H M → M.card ≤ n) : matchingNumber H ≤ n := by
  have hne : ({m | ∃ M, IsMatching H M ∧ M.card = m} : Set ℕ).Nonempty :=
    ⟨0, ∅, ⟨Finset.empty_subset H, fun _ hm => by simp at hm⟩, Finset.card_empty⟩
  have hbdd : BddAbove {m | ∃ M, IsMatching H M ∧ M.card = m} :=
    ⟨H.card, by
      intro m hm
      obtain ⟨M, hM, hm⟩ := hm
      rw [← hm]
      exact Finset.card_le_card hM.1⟩
  obtain ⟨M, hM, hMcard⟩ := Nat.sSup_mem hne hbdd
  unfold matchingNumber
  rw [hMcard.symm]
  exact h M hM

omit [Fintype V] in
/-- To lower-bound `τ`, it suffices to lower-bound the cardinality of every transversal. -/
theorem le_transversalNumber_of_forall {H : Finset (Finset V)} {n : ℕ}
    (hex : ∃ T, IsTransversal H T)
    (h : ∀ T, IsTransversal H T → n ≤ T.card) : n ≤ transversalNumber H := by
  have hne : ({m | ∃ T, IsTransversal H T ∧ T.card = m} : Set ℕ).Nonempty := by
    obtain ⟨T, hT⟩ := hex
    exact ⟨T.card, T, hT, rfl⟩
  obtain ⟨T, hT, hTcard⟩ := Nat.sInf_mem hne
  unfold transversalNumber
  rw [← hTcard]
  exact h T hT

omit [Fintype V] [DecidableEq V] in
/-- `ν(H)` is an upper bound on every matching size: `ν` is the *sup*. Together
with attainment (`Nat.sSup_mem`) this pins `matchingNumber` to the intended
"largest matching size". -/
theorem card_le_matchingNumber {H M : Finset (Finset V)} (hM : IsMatching H M) :
    M.card ≤ matchingNumber H :=
  le_csSup ⟨H.card, by rintro n ⟨M', hM', rfl⟩; exact card_le_card hM'.1⟩ ⟨M, hM, rfl⟩

omit [Fintype V] [DecidableEq V] in
/-- Matching number is monotone when edges are added. -/
theorem matchingNumber_mono {H K : Finset (Finset V)} (hHK : H ⊆ K) :
    matchingNumber H ≤ matchingNumber K := by
  obtain ⟨M, hM, hMcard⟩ := exists_matching_card_eq_matchingNumber H
  rw [← hMcard]
  exact card_le_matchingNumber ⟨hM.1.trans hHK, hM.2⟩

omit [Fintype V] in
/-- Embedding into a larger ground type preserves matching number. -/
theorem matchingNumber_embedHypergraph {W : Type*} [Fintype W] [DecidableEq W]
    (e : V ↪ W) (H : Finset (Finset V)) :
    matchingNumber (embedHypergraph e H) = matchingNumber H := by
  apply le_antisymm
  · apply matchingNumber_le_of_forall
    intro M hM
    have hex (E : {E // E ∈ M}) : ∃ A ∈ H, A.map e = E.1 := by
      exact Finset.mem_image.mp (hM.1 E.2)
    let f : {E // E ∈ M} → Finset V := fun E => (hex E).choose
    have hfmem (E : {E // E ∈ M}) : f E ∈ H := (hex E).choose_spec.1
    have hfmap (E : {E // E ∈ M}) : (f E).map e = E.1 := (hex E).choose_spec.2
    let N := M.attach.image f
    have hNcard : N.card = M.card := by
      rw [show M.card = M.attach.card by simp]
      apply Finset.card_image_iff.mpr
      intro A hA B hB hEq
      apply Subtype.ext
      rw [← hfmap A, ← hfmap B, hEq]
    have hN : IsMatching H N := by
      refine ⟨?_, ?_⟩
      · intro A hAN
        obtain ⟨E, -, rfl⟩ := Finset.mem_image.mp hAN
        exact hfmem E
      · intro A hAN B hBN hAB
        obtain ⟨E, hE, rfl⟩ := Finset.mem_image.mp hAN
        obtain ⟨F, hF, rfl⟩ := Finset.mem_image.mp hBN
        apply (Finset.disjoint_map e).mp
        rw [hfmap E, hfmap F]
        apply hM.2 E.2 F.2
        intro hEF
        exact hAB (congrArg f (Subtype.ext hEF))
    rw [← hNcard]
    exact card_le_matchingNumber hN
  · obtain ⟨M, hM, hMcard⟩ := exists_matching_card_eq_matchingNumber H
    rw [← hMcard, ← card_embedHypergraph e M]
    exact card_le_matchingNumber (hM.embedHypergraph e)

omit [Fintype V] in
/-- `τ(H)` is a lower bound on every transversal size: `τ` is the *inf*. Together
with attainment (`Nat.sInf_mem`) this pins `transversalNumber` to the intended
"smallest transversal size". -/
theorem transversalNumber_le_card {H : Finset (Finset V)} {T : Finset V}
    (hT : IsTransversal H T) : transversalNumber H ≤ T.card :=
  Nat.sInf_le ⟨T, hT, rfl⟩

/-- Every independent set is bounded by `independenceNumber`. -/
theorem card_le_independenceNumber {H : Finset (Finset V)}
    (hne : ∀ E ∈ H, E.Nonempty) {S : Finset V} (hS : IsIndependent H S) :
    S.card ≤ independenceNumber H := by
  have hT : IsTransversal H (univ \ S) := isTransversal_compl_iff.mpr hS
  have htau := transversalNumber_le_card hT
  have hScard : (univ \ S).card = Fintype.card V - S.card := by
    rw [Finset.card_sdiff, Finset.inter_eq_left.mpr (Finset.subset_univ S), Finset.card_univ]
  rw [hScard] at htau
  have htauq : transversalNumber H ≤ Fintype.card V :=
    transversalNumber_le_card (show IsTransversal H univ by
      intro E hE
      rw [Finset.univ_inter]
      exact hne E hE)
  have hSq : S.card ≤ Fintype.card V := by
    simpa using Finset.card_le_card (Finset.subset_univ S)
  unfold independenceNumber
  omega

/-- A maximum independent set exists and has cardinality `independenceNumber`. -/
theorem exists_independent_card_eq_independenceNumber (H : Finset (Finset V))
    (hne : ∀ E ∈ H, E.Nonempty) :
    ∃ S, IsIndependent H S ∧ S.card = independenceNumber H := by
  obtain ⟨T, hT, hTcard⟩ := exists_transversal_card_eq_transversalNumber H hne
  let S := univ \ T
  have hS : IsIndependent H S := by
    apply isTransversal_compl_iff.mp
    simpa [S] using hT
  refine ⟨S, hS, ?_⟩
  have hTsub : T ⊆ univ := Finset.subset_univ T
  change (univ \ T).card = independenceNumber H
  rw [Finset.card_sdiff, Finset.inter_eq_left.mpr hTsub, Finset.card_univ, hTcard]
  rfl

/-- Embedding a nonempty-edge hypergraph into a larger ground type preserves transversal number. -/
theorem transversalNumber_embedHypergraph {W : Type*} [Fintype W] [DecidableEq W]
    (e : V ↪ W) (H : Finset (Finset V)) (hne : ∀ E ∈ H, E.Nonempty) :
    transversalNumber (embedHypergraph e H) = transversalNumber H := by
  classical
  apply le_antisymm
  · obtain ⟨T, hT, hTcard⟩ := exists_transversal_card_eq_transversalNumber H hne
    rw [← hTcard, ← Finset.card_map e]
    exact transversalNumber_le_card (hT.embedHypergraph e)
  · apply le_transversalNumber_of_forall
    · exact ⟨univ.map e, (show IsTransversal H univ from fun E hE => by
        rw [Finset.univ_inter]
        exact hne E hE).embedHypergraph e⟩
    · intro T hT
      let T₀ : Finset V := univ.filter fun v => e v ∈ T
      have hT₀ : IsTransversal H T₀ := by
        intro E hE
        have hmapE : E.map e ∈ embedHypergraph e H :=
          Finset.mem_image.mpr ⟨E, hE, rfl⟩
        obtain ⟨w, hw⟩ := hT hmapE
        have hw' := Finset.mem_inter.mp hw
        obtain ⟨v, hvE, hvw⟩ := Finset.mem_map.mp hw'.2
        subst w
        exact ⟨v, Finset.mem_inter.mpr ⟨by simp [T₀, hw'.1], hvE⟩⟩
      have hmapSub : T₀.map e ⊆ T := by
        intro w hw
        obtain ⟨v, hv, rfl⟩ := Finset.mem_map.mp hw
        exact (Finset.mem_filter.mp hv).2
      exact (transversalNumber_le_card hT₀).trans <| by
        rw [← Finset.card_map e]
        exact Finset.card_le_card hmapSub

/-- The complete graph on a finite type has matching number `⌊|V|/2⌋`. -/
theorem matchingNumber_completePairHypergraph :
    matchingNumber (completePairHypergraph V) = Fintype.card V / 2 := by
  classical
  apply le_antisymm
  · apply matchingNumber_le_of_forall
    intro M hM
    have hpairwise : (M : Set (Finset V)).PairwiseDisjoint id := by
      intro A hA B hB hAB
      change Disjoint A B
      exact hM.2 hA hB hAB
    have hcard : (M.biUnion id).card = 2 * M.card := by
      rw [Finset.card_biUnion hpairwise]
      calc
        (∑ E ∈ M, E.card) = ∑ _E ∈ M, 2 := by
          apply Finset.sum_congr rfl
          intro E hEM
          exact mem_completePairHypergraph.mp (hM.1 hEM)
        _ = 2 * M.card := by simp [Nat.mul_comm]
    have hle : (M.biUnion id).card ≤ Fintype.card V := by
      simpa using Finset.card_le_card (Finset.subset_univ (M.biUnion id))
    rw [hcard] at hle
    omega
  · let n := Fintype.card V
    let equiv : Fin n ≃ V := (Fintype.equivFin V).symm
    let pair : Fin (n / 2) → Finset V := fun i =>
      {equiv ⟨2 * i.1, by simp only [n]; omega⟩,
        equiv ⟨2 * i.1 + 1, by simp only [n]; omega⟩}
    let M : Finset (Finset V) := univ.image pair
    have hpairCard (i : Fin (n / 2)) : (pair i).card = 2 := by
      simp only [pair]
      rw [Finset.card_pair]
      intro h
      have h' := equiv.injective h
      have hval := congrArg Fin.val h'
      change 2 * i.1 = 2 * i.1 + 1 at hval
      omega
    have hpairInj : Function.Injective pair := by
      intro i j hij
      have hmem : equiv ⟨2 * i.1, by simp only [n]; omega⟩ ∈ pair j := by
        rw [← hij]
        simp [pair]
      simp only [pair, Finset.mem_insert, Finset.mem_singleton] at hmem
      rcases hmem with hEven | hOdd
      · have hval := congrArg Fin.val (equiv.injective hEven)
        change 2 * i.1 = 2 * j.1 at hval
        apply Fin.ext
        omega
      · have hval := congrArg Fin.val (equiv.injective hOdd)
        change 2 * i.1 = 2 * j.1 + 1 at hval
        omega
    have hMcard : M.card = n / 2 := by
      rw [show M = univ.image pair by rfl, Finset.card_image_of_injective _ hpairInj]
      simp
    have hM : IsMatching (completePairHypergraph V) M := by
      refine ⟨?_, ?_⟩
      · intro E hEM
        obtain ⟨i, -, rfl⟩ := Finset.mem_image.mp hEM
        exact mem_completePairHypergraph.mpr (hpairCard i)
      · intro A hAM B hBM hAB
        obtain ⟨i, -, rfl⟩ := Finset.mem_image.mp hAM
        obtain ⟨j, -, rfl⟩ := Finset.mem_image.mp hBM
        have hij : i ≠ j := fun h => hAB (congrArg pair h)
        rw [Finset.disjoint_left]
        intro v hvi hvj
        simp only [pair, Finset.mem_insert, Finset.mem_singleton] at hvi hvj
        rcases hvi with hi0 | hi1 <;> rcases hvj with hj0 | hj1
        · have hval := congrArg Fin.val (equiv.injective (hi0.symm.trans hj0))
          change 2 * i.1 = 2 * j.1 at hval
          exact hij (Fin.ext (by omega))
        · have hval := congrArg Fin.val (equiv.injective (hi0.symm.trans hj1))
          change 2 * i.1 = 2 * j.1 + 1 at hval
          omega
        · have hval := congrArg Fin.val (equiv.injective (hi1.symm.trans hj0))
          change 2 * i.1 + 1 = 2 * j.1 at hval
          omega
        · have hval := congrArg Fin.val (equiv.injective (hi1.symm.trans hj1))
          change 2 * i.1 + 1 = 2 * j.1 + 1 at hval
          exact hij (Fin.ext (by omega))
    rw [← hMcard]
    exact card_le_matchingNumber hM

/-- The complete graph on a nonempty finite type has transversal number `|V|-1`. -/
theorem transversalNumber_completePairHypergraph [Nonempty V] :
    transversalNumber (completePairHypergraph V) = Fintype.card V - 1 := by
  classical
  let v₀ : V := Classical.choice inferInstance
  have hupper : IsTransversal (completePairHypergraph V) (univ.erase v₀) := by
    intro E hE
    have hcard := mem_completePairHypergraph.mp hE
    by_contra hnone
    rw [Finset.not_nonempty_iff_eq_empty] at hnone
    have hdisj : Disjoint (univ.erase v₀) E :=
      Finset.disjoint_iff_inter_eq_empty.mpr hnone
    have hsub : E ⊆ {v₀} := by
      intro v hv
      have hvnot : v ∉ univ.erase v₀ := by
        intro hv'
        exact (Finset.disjoint_left.mp hdisj hv') hv
      simpa using hvnot
    have := Finset.card_le_card hsub
    simp at this
    omega
  apply le_antisymm
  · have hle := transversalNumber_le_card hupper
    simpa using hle
  · apply le_transversalNumber_of_forall
    · exact ⟨_, hupper⟩
    · intro T hT
      let U := univ \ T
      have hU : U.card ≤ 1 := by
        by_contra h
        have hlt : 1 < U.card := by omega
        obtain ⟨a, ha, b, hb, hab⟩ := Finset.one_lt_card.mp hlt
        have hedge : {a, b} ∈ completePairHypergraph V := by
          apply mem_completePairHypergraph.mpr
          simp [hab]
        obtain ⟨v, hv⟩ := hT hedge
        have hv' := Finset.mem_inter.mp hv
        simp only [Finset.mem_insert, Finset.mem_singleton] at hv'
        rcases hv'.2 with rfl | rfl
        · exact (Finset.mem_sdiff.mp ha).2 hv'.1
        · exact (Finset.mem_sdiff.mp hb).2 hv'.1
      have hsplit : T.card + U.card ≥ Fintype.card V := by
        have hsub : univ ⊆ T ∪ U := by simp [U]
        have := Finset.card_le_card hsub
        exact this.trans (Finset.card_union_le T U)
      omega

omit [Fintype V] in
/-- Matching numbers add for hypergraphs carried on disjoint vertex grounds. -/
theorem matchingNumber_union_of_disjoint_vertices (H K : Finset (Finset V))
    (hneH : ∀ E ∈ H, E.Nonempty) (_hneK : ∀ E ∈ K, E.Nonempty)
    (hground : Disjoint (H.biUnion id) (K.biUnion id)) :
    matchingNumber (H ∪ K) = matchingNumber H + matchingNumber K := by
  classical
  have hedgeDisjoint : Disjoint H K := by
    rw [Finset.disjoint_left]
    intro E hEH hEK
    obtain ⟨v, hvE⟩ := hneH E hEH
    exact (Finset.disjoint_left.mp hground
      (Finset.subset_biUnion_of_mem id hEH hvE))
      (Finset.subset_biUnion_of_mem id hEK hvE)
  apply le_antisymm
  · obtain ⟨M, hM, hMcard⟩ := exists_matching_card_eq_matchingNumber (H ∪ K)
    let MH := M.filter fun E => E ∈ H
    let MK := M.filter fun E => E ∈ K
    have hMsplit : M = MH ∪ MK := by
      ext E
      simp only [MH, MK, Finset.mem_union, Finset.mem_filter]
      constructor
      · intro hEM
        rcases Finset.mem_union.mp (hM.1 hEM) with hEH | hEK
        · exact Or.inl ⟨hEM, hEH⟩
        · exact Or.inr ⟨hEM, hEK⟩
      · rintro (⟨hEM, -⟩ | ⟨hEM, -⟩) <;> exact hEM
    have hMHK : Disjoint MH MK := by
      rw [Finset.disjoint_left]
      intro E hEH hEK
      exact Finset.disjoint_left.mp hedgeDisjoint (Finset.mem_filter.mp hEH).2
        (Finset.mem_filter.mp hEK).2
    have hMH : IsMatching H MH := by
      refine ⟨?_, ?_⟩
      · intro E hE
        exact (Finset.mem_filter.mp hE).2
      · intro A hA B hB hAB
        exact hM.2 (Finset.mem_filter.mp hA).1 (Finset.mem_filter.mp hB).1 hAB
    have hMK : IsMatching K MK := by
      refine ⟨?_, ?_⟩
      · intro E hE
        exact (Finset.mem_filter.mp hE).2
      · intro A hA B hB hAB
        exact hM.2 (Finset.mem_filter.mp hA).1 (Finset.mem_filter.mp hB).1 hAB
    have hcard : M.card = MH.card + MK.card := by
      rw [hMsplit, Finset.card_union_of_disjoint hMHK]
    rw [← hMcard, hcard]
    exact Nat.add_le_add (card_le_matchingNumber hMH) (card_le_matchingNumber hMK)
  · obtain ⟨MH, hMH, hMHcard⟩ := exists_matching_card_eq_matchingNumber H
    obtain ⟨MK, hMK, hMKcard⟩ := exists_matching_card_eq_matchingNumber K
    have hMHK : Disjoint MH MK := hedgeDisjoint.mono hMH.1 hMK.1
    have hcross (A : Finset V) (hAH : A ∈ H) (B : Finset V) (hBK : B ∈ K) :
        Disjoint A B := by
      exact hground.mono (Finset.subset_biUnion_of_mem id hAH)
        (Finset.subset_biUnion_of_mem id hBK)
    have hM : IsMatching (H ∪ K) (MH ∪ MK) := by
      refine ⟨Finset.union_subset_union hMH.1 hMK.1, ?_⟩
      intro A hA B hB hAB
      rcases Finset.mem_union.mp hA with hAH | hAK <;>
        rcases Finset.mem_union.mp hB with hBH | hBK
      · exact hMH.2 hAH hBH hAB
      · exact hcross A (hMH.1 hAH) B (hMK.1 hBK)
      · exact (hcross B (hMH.1 hBH) A (hMK.1 hAK)).symm
      · exact hMK.2 hAK hBK hAB
    rw [← hMHcard, ← hMKcard, ← Finset.card_union_of_disjoint hMHK]
    exact card_le_matchingNumber hM

/-- Transversal numbers add for hypergraphs carried on disjoint vertex grounds. -/
theorem transversalNumber_union_of_disjoint_vertices (H K : Finset (Finset V))
    (hneH : ∀ E ∈ H, E.Nonempty) (hneK : ∀ E ∈ K, E.Nonempty)
    (hground : Disjoint (H.biUnion id) (K.biUnion id)) :
    transversalNumber (H ∪ K) = transversalNumber H + transversalNumber K := by
  classical
  apply le_antisymm
  · obtain ⟨TH, hTH, hTHcard⟩ := exists_transversal_card_eq_transversalNumber H hneH
    obtain ⟨TK, hTK, hTKcard⟩ := exists_transversal_card_eq_transversalNumber K hneK
    have hT : IsTransversal (H ∪ K) (TH ∪ TK) := by
      intro E hE
      rcases Finset.mem_union.mp hE with hEH | hEK
      · obtain ⟨v, hv⟩ := hTH hEH
        have hv' := Finset.mem_inter.mp hv
        exact ⟨v, Finset.mem_inter.mpr ⟨Finset.mem_union_left TK hv'.1, hv'.2⟩⟩
      · obtain ⟨v, hv⟩ := hTK hEK
        have hv' := Finset.mem_inter.mp hv
        exact ⟨v, Finset.mem_inter.mpr ⟨Finset.mem_union_right TH hv'.1, hv'.2⟩⟩
    have hle := transversalNumber_le_card hT
    rw [← hTHcard, ← hTKcard]
    exact hle.trans (Finset.card_union_le TH TK)
  · apply le_transversalNumber_of_forall
    · exact ⟨univ, fun E hE => by
        rw [Finset.univ_inter]
        rcases Finset.mem_union.mp hE with hEH | hEK
        · exact hneH E hEH
        · exact hneK E hEK⟩
    · intro T hT
      let TH := T ∩ H.biUnion id
      let TK := T ∩ K.biUnion id
      have hTH : IsTransversal H TH := by
        intro E hEH
        obtain ⟨v, hv⟩ := hT (Finset.mem_union_left K hEH)
        have hv' := Finset.mem_inter.mp hv
        exact ⟨v, by
          simp only [TH, Finset.mem_inter]
          exact ⟨⟨hv'.1, Finset.subset_biUnion_of_mem id hEH hv'.2⟩, hv'.2⟩⟩
      have hTK : IsTransversal K TK := by
        intro E hEK
        obtain ⟨v, hv⟩ := hT (Finset.mem_union_right H hEK)
        have hv' := Finset.mem_inter.mp hv
        exact ⟨v, by
          simp only [TK, Finset.mem_inter]
          exact ⟨⟨hv'.1, Finset.subset_biUnion_of_mem id hEK hv'.2⟩, hv'.2⟩⟩
      have hdisj : Disjoint TH TK := hground.mono (Finset.inter_subset_right)
        (Finset.inter_subset_right)
      have hunionSub : TH ∪ TK ⊆ T :=
        Finset.union_subset Finset.inter_subset_left Finset.inter_subset_left
      have hcards : TH.card + TK.card ≤ T.card := by
        rw [← Finset.card_union_of_disjoint hdisj]
        exact Finset.card_le_card hunionSub
      exact (Nat.add_le_add (transversalNumber_le_card hTH)
        (transversalNumber_le_card hTK)).trans hcards

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
