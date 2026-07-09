import NodeKayles.Basic
import NodeKayles.Certificate
import CapGame.GraphMirror

/-!
# Node-Kayles double-encoding equivalence

The repo carries two formalisations of the capacity-1 Node-Kayles / cap game:

* the **vertex-deletion** form `NodeKayles.win` (`NodeKayles/Basic.lean`): a position is
  the live vertex set `S`, and a move picks a live `v` and deletes its closed
  neighbourhood `N[v]`;
* the **independent-set-building** form `FiniteBuildGame.Win (ConflictGraph.IndepValid adj)`
  (`CapGame/GraphMirror.lean`): a position is an independent set `S` of the conflict graph,
  and a move adds one fresh non-conflicting vertex.

This file closes the gap left open in `GraphMirror.lean`: the two encodings compute the
same normal-play value.  The bridge tracks, for each built independent set `S`, its
**live set** `liveSet G S = univ \ ⋃_{u ∈ S} N[u]` — the vertices still legally playable —
and shows the build-up value of `S` equals the deletion value of `liveSet G S`.  The
`S = ∅` instance is the headline `indepGame_isP_iff`.
-/

namespace NodeKayles

variable {k : ℕ}

/-- The conflict relation of a Node-Kayles graph as a `Prop`-valued adjacency:
`conflictAdj G x y` holds iff `x` and `y` are adjacent in `G`.  This is the `adj` fed to the
independent-set-building encoding `ConflictGraph.IndepValid`. -/
def conflictAdj (G : Graph k) (x y : Fin k) : Prop := G.adj x y = true

/-- The conflict relation is symmetric (from `G.symm`). -/
theorem conflictAdj_symm (G : Graph k) :
    ∀ x y : Fin k, conflictAdj G x y → conflictAdj G y x := by
  intro x y h
  rw [conflictAdj, G.symm y x]
  exact h

/-- Membership in a closed neighbourhood, unfolded. -/
theorem mem_closedNbhd (G : Graph k) {u v : Fin k} :
    v ∈ closedNbhd G u ↔ v = u ∨ G.adj u v = true := by
  simp only [closedNbhd, Finset.mem_filter, Finset.mem_univ, true_and]

/-- The **live set** of a built independent position `S`: the vertices that are neither in
`S` nor adjacent to any vertex of `S`, i.e. those still legally playable.  This is the
deletion-form position corresponding to the build-form position `S`. -/
def liveSet (G : Graph k) (S : Finset (Fin k)) : Finset (Fin k) :=
  Finset.univ \ S.biUnion (closedNbhd G)

/-- A vertex is live iff it differs from, and is non-adjacent to, every vertex of `S`. -/
theorem mem_liveSet (G : Graph k) {S : Finset (Fin k)} {v : Fin k} :
    v ∈ liveSet G S ↔ ∀ u ∈ S, v ≠ u ∧ G.adj u v = false := by
  unfold liveSet
  simp only [Finset.mem_sdiff, Finset.mem_univ, true_and, Finset.mem_biUnion,
    not_exists, not_and, mem_closedNbhd, not_or, Bool.not_eq_true]

/-- Before any move every vertex is live. -/
theorem liveSet_empty (G : Graph k) : liveSet G (∅ : Finset (Fin k)) = Finset.univ := by
  unfold liveSet
  rw [Finset.biUnion_empty, Finset.sdiff_empty]

/-- **Child correspondence.**  Playing a fresh vertex `x` in the build-up game turns the
live set into the deletion-form child `liveSet G S \ N[x]`.  (This holds for every `x`; the
`insert` on the build side mirrors the `\ closedNbhd` on the deletion side.) -/
theorem liveSet_child (G : Graph k) (S : Finset (Fin k)) (x : Fin k) :
    liveSet G (insert x S) = liveSet G S \ closedNbhd G x := by
  unfold liveSet
  rw [Finset.biUnion_insert]
  ext v
  simp only [Finset.mem_sdiff, Finset.mem_univ, true_and, Finset.mem_union]
  tauto

/-- **Move bijection.**  From a valid built position `S`, the legal build-up moves are
exactly the live vertices: `x` extends `S` to a fresh independent set iff `x ∈ liveSet G S`. -/
theorem move_iff_liveSet (G : Graph k) {S : Finset (Fin k)} {x : Fin k}
    (hS : ConflictGraph.IndepValid (conflictAdj G) S) :
    FiniteBuildGame.Move (ConflictGraph.IndepValid (conflictAdj G)) S x ↔ x ∈ liveSet G S := by
  rw [mem_liveSet]
  constructor
  · intro hmove
    obtain ⟨hxS, hins⟩ := hmove
    intro u hu
    have hxu : x ≠ u := fun h => hxS (h ▸ hu)
    refine ⟨hxu, ?_⟩
    have hnotadj : ¬ (G.adj x u = true) :=
      hins x (Finset.mem_insert_self x S) u (Finset.mem_insert_of_mem hu) hxu
    have hxu_false : G.adj x u = false := by simpa using hnotadj
    rw [G.symm u x]
    exact hxu_false
  · intro h
    have hxS : x ∉ S := fun hx => (h x hx).1 rfl
    refine ⟨hxS, ?_⟩
    refine ConflictGraph.indepValid_insert (conflictAdj_symm G) hS ?_
    intro z hz
    have hxz : G.adj x z = false := by
      rw [G.symm x z]; exact (h z hz).2
    show ¬ (G.adj x z = true)
    rw [hxz]; simp

/-- The build-up child `insert x S` has a strictly smaller live set — the termination fact
for the bridge induction: `x` itself is deleted (it lies in `N[x]`). -/
theorem liveSet_insert_ssubset (G : Graph k) {S : Finset (Fin k)} {x : Fin k}
    (hx : x ∈ liveSet G S) : liveSet G (insert x S) ⊂ liveSet G S := by
  rw [liveSet_child G S x]
  exact sdiff_closedNbhd_ssubset G hx

/-- **Bridge lemma.**  For every valid built position `S`, its build-up value equals the
deletion-form value of its live set.  Proved by strong induction on `(liveSet G S).card`:
the move bijection matches legal moves, and the child correspondence matches children
(the child `insert x S` stays valid, so the IH applies to its strictly-smaller live set). -/
theorem bridge (G : Graph k) (S : Finset (Fin k))
    (hS : ConflictGraph.IndepValid (conflictAdj G) S) :
    FiniteBuildGame.Win (ConflictGraph.IndepValid (conflictAdj G)) S ↔ win G (liveSet G S) := by
  constructor
  · intro hwin
    rw [FiniteBuildGame.win_iff_exists_move] at hwin
    obtain ⟨x, hxmove, hxlose⟩ := hwin
    have hxlive : x ∈ liveSet G S := (move_iff_liveSet G hS).mp hxmove
    have hins : ConflictGraph.IndepValid (conflictAdj G) (insert x S) := hxmove.2
    rw [win.eq_def]
    refine ⟨⟨x, hxlive⟩, ?_⟩
    show ¬ win G (liveSet G S \ closedNbhd G x)
    rw [← liveSet_child G S x, ← bridge G (insert x S) hins]
    exact hxlose
  · intro hwin
    rw [win.eq_def] at hwin
    obtain ⟨⟨v, hv⟩, hvlose⟩ := hwin
    have hvmove : FiniteBuildGame.Move (ConflictGraph.IndepValid (conflictAdj G)) S v :=
      (move_iff_liveSet G hS).mpr hv
    have hins : ConflictGraph.IndepValid (conflictAdj G) (insert v S) := hvmove.2
    rw [FiniteBuildGame.win_iff_exists_move]
    refine ⟨v, hvmove, ?_⟩
    rw [bridge G (insert v S) hins, liveSet_child G S v]
    exact hvlose
termination_by (liveSet G S).card
decreasing_by
  all_goals
    exact Finset.card_lt_card (liveSet_insert_ssubset G (by assumption))

/-- **Double-encoding gap closed.**  The independent-set-building game on the conflict graph
of `G` (empty start) and the vertex-deletion Node-Kayles game on `G` (all vertices live)
have the same normal-play value: the empty build position is a P-position iff the full live
set is.  The `S = ∅` instance of `bridge`, using `liveSet G ∅ = univ`. -/
theorem indepGame_isP_iff (G : Graph k) :
    FiniteBuildGame.IsP (ConflictGraph.IndepValid (conflictAdj G)) (∅ : Finset (Fin k)) ↔
      NodeKayles.IsP G Finset.univ := by
  have hempty : ConflictGraph.IndepValid (conflictAdj G) (∅ : Finset (Fin k)) := by
    intro x hx
    simp at hx
  show ¬ FiniteBuildGame.Win (ConflictGraph.IndepValid (conflictAdj G)) (∅ : Finset (Fin k)) ↔
       ¬ win G Finset.univ
  rw [bridge G ∅ hempty, liveSet_empty G]

end NodeKayles
