import FiniteGeom.BaerCompletion.PairExtension

/-!
# Robust blocked points

Deleting fewer than the obstruction transversal number cannot make an external point insertable.
This is the formal robustness half of the paper's fixed-hole bridge theorem.
-/

namespace FiniteGeom.BaerCompletion

open Finset

variable {V : Type*} [Fintype V] [DecidableEq V]

omit [Fintype V] in
/-- Fewer than `τ(H)` deletions leave at least one obstruction edge wholly alive. -/
theorem exists_surviving_obstruction {H : Finset (Finset V)} {C D : Finset V}
    (hsub : ∀ A ∈ H, A ⊆ C) (hlt : D.card < transversalNumber H) :
    ∃ A ∈ H, A ⊆ C \ D := by
  by_contra h
  push Not at h
  have htr : IsTransversal H D :=
    (insertIndep_iff_transversal hsub).mp h
  have := transversalNumber_le_card htr
  omega

variable (I : IndependenceSystem V) [DecidablePred I.indep]

omit [Fintype V] in
/-- **Robust-hole theorem.** A deletion set smaller than the obstruction transversal number cannot
enable insertion of the blocked point. -/
theorem not_insertion_indep_of_card_lt_tau {C D : Finset V} {x : V}
    (hlt : D.card < transversalNumber (obstructionHypergraph I C x)) :
    ¬ I.indep (insert x (C \ D)) := by
  intro hins
  have hnone := (insertion_indep_iff_no_surviving_trace I).mp hins
  have hsub : ∀ A ∈ obstructionHypergraph I C x, A ⊆ C := by
    intro A hA
    exact obstruction_edge_subset I hA
  have htr : IsTransversal (obstructionHypergraph I C x) D :=
    (insertIndep_iff_transversal hsub).mp hnone
  have := transversalNumber_le_card htr
  omega

omit [Fintype V] in
/-- Stability under a perturbation that preserves the complete obstruction hypergraph. -/
theorem not_insertion_indep_of_preserved_obstructions
    {C C' D : Finset V} {x : V}
    (hpres : obstructionHypergraph I C' x = obstructionHypergraph I C x)
    (hlt : D.card < transversalNumber (obstructionHypergraph I C x)) :
    ¬ I.indep (insert x (C' \ D)) := by
  apply not_insertion_indep_of_card_lt_tau I
  simpa [hpres] using hlt

omit [Fintype V] in
/-- Stronger perturbation theorem: equality of obstruction hypergraphs is unnecessary. It is enough
that every old obstruction trace remains supported in the perturbed configuration. New
obstructions may be created freely. -/
theorem not_insertion_indep_of_obstructions_persist
    {C C' D : Finset V} {x : V}
    (hpersist : ∀ A ∈ obstructionHypergraph I C x, A ⊆ C')
    (hlt : D.card < transversalNumber (obstructionHypergraph I C x)) :
    ¬ I.indep (insert x (C' \ D)) := by
  intro hins
  have htr : IsTransversal (obstructionHypergraph I C x) D := by
    intro A hA
    apply (not_subset_sdiff_iff (hpersist A hA)).mp
    intro hsurvive
    have hsub : insert x A ⊆ insert x (C' \ D) :=
      Finset.insert_subset_insert x (fun _ ha => hsurvive ha)
    exact (mem_obstructionHypergraph I).mp hA |>.2 (I.hereditary hsub hins)
  have := transversalNumber_le_card htr
  omega

omit [Fintype V] [DecidablePred I.indep] in
/-- Secant-count form of the robust-hole theorem. For disjoint pair obstructions, fewer deletions
than occupied secants leave the point blocked. -/
theorem not_insertion_indep_of_card_lt_secantCount
    {C D : Finset V} {x : V} {H : Finset (Finset V)}
    (hsec : IsSecantObstructionFamily I C x H) (hlt : D.card < H.card) :
    ¬ I.indep (insert x (C \ D)) := by
  intro hins
  have hnone := (hsec.insertion_iff D).mp hins
  have htr : IsTransversal H D :=
    (insertIndep_iff_transversal hsec.edge_subset).mp hnone
  have hlower : H.card ≤ D.card := by
    have hmatching : IsMatching H H := ⟨subset_refl _, hsec.edge_disjoint⟩
    exact matching_card_le_transversal_card hmatching htr
  omega

end FiniteGeom.BaerCompletion
