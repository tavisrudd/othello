import Mathlib

/-!
# Node-Kayles win predicate — Phase 1 (Approach A, the spec backbone)

The 2-lite formal-verification spine for the queens `getK` leaf evaluator. This file is
the Lean mirror of the *scalar reference* in `rust/src/queens/dense.rs`:

| Lean (here)          | Rust (`dense.rs`)                       | meaning                              |
|----------------------|-----------------------------------------|--------------------------------------|
| `win`                | `wins_rec` (`:584`)                      | `W_K(G) = ∃v · ¬W_{K-1}(G∖N[v])`     |
| `closedNbhd G v`     | `full & !((1<<i) \| adj[i])` (per getK)  | delete `{v} ∪ N(v)` (the move)       |
| `firstPlayerWins`    | `get(k, code)` over the full graph       | first player wins this position      |

`win` is a `Prop` here (Node-Kayles normal-play P/N value): clean for the `win_iso`
invariance proof and well-founded recursion. The *computable* `Bool` twin + its `#eval`
cross-check against the Rust `wins_rec` is Phase 3. Phase 2 adds the `code ↔ Graph` decode
(`graphOfCode` ↔ `adj_from_code`) and the W0..W8 build correctness; Phase 4 (optional)
grafts the mathlib `PGame`/Sprague–Grundy bridge.
-/

namespace NodeKayles

variable {k : ℕ}

/-- A finite simple graph on `Fin k`: symmetric, irreflexive adjacency (`Bool`-valued, so
    decidable by construction). The abstract Node-Kayles graph one labelled
    upper-triangular `code` decodes to (Phase 2). -/
structure Graph (k : ℕ) where
  adj    : Fin k → Fin k → Bool
  symm   : ∀ i j, adj i j = adj j i
  irrefl : ∀ i, adj i i = false

/-- Closed neighbourhood of `v`: `v` together with its neighbours — the vertex set a move
    deletes. Placing a queen on a square blocks that square plus every square it attacks,
    i.e. removes `{v} ∪ N(v)` from the live set. -/
def closedNbhd (G : Graph k) (v : Fin k) : Finset (Fin k) :=
  Finset.univ.filter (fun u => u = v ∨ G.adj v u = true)

@[simp] theorem self_mem_closedNbhd (G : Graph k) (v : Fin k) :
    v ∈ closedNbhd G v := by
  simp [closedNbhd]

/-- Node-Kayles win predicate (normal play): the player to move **wins** iff some live
    vertex `v`, when played, leaves the opponent a **loss**. `S` is the set of live
    vertices; a terminal position (`S = ∅`) is a loss for the mover.

    Well-founded on `S.card`: the played `v` lies in both `S` and its own closed
    neighbourhood (`self_mem_closedNbhd`), so the child set `S \ N[v]` is a strict subset
    of `S` and its cardinality strictly drops. Mirrors `wins_rec` (`dense.rs:584`). -/
def win (G : Graph k) (S : Finset (Fin k)) : Prop :=
  -- Bind over the subtype `S` (not `∃ v ∈ S`, a conjunction) so `v.2 : ↑v ∈ S` is in
  -- scope at the recursive call — the witness the termination proof needs.
  ∃ v : S, ¬ win G (S \ closedNbhd G (v : Fin k))
termination_by S.card
decreasing_by
  have hv : (v : Fin k) ∈ S := v.2
  have hssub : S \ closedNbhd G (v : Fin k) ⊂ S :=
    (Finset.ssubset_iff_of_subset Finset.sdiff_subset).mpr
      ⟨(v : Fin k), hv, fun hc => (Finset.mem_sdiff.mp hc).2 (self_mem_closedNbhd G (v : Fin k))⟩
  exact Finset.card_lt_card hssub

/-- "First player wins the game on `G`" — every vertex live. The board-level result
    (e.g. n=18 is a first-player win) is `firstPlayerWins (queenGraph 18)`, where
    `queenGraph` is the Phase-2 board→graph bridge (`att08`/`adj_row_pext`). -/
def firstPlayerWins (G : Graph k) : Prop := win G Finset.univ

/-- **Relabeling (isomorphism) invariance.** `win` depends only on the isomorphism class
    of `(G, S)`: transporting the live set along a graph isomorphism `e` preserves the
    value. The mathematical content behind `projected_code` (`dense.rs:516`) — the getK
    recurrence relabels each child's surviving vertices to `0..k'` to index a smaller
    table, and this lemma is what makes that lookup sound.

    Proof (Phase-1 target): strong induction on `S.card`; `closedNbhd` commutes with `e`
    (`he` + `symm`), and `Finset.map e.toEmbedding` commutes with `\` and `univ`, so both
    sides run the same recurrence modulo `e`. -/
theorem win_iso {k k' : ℕ} (G : Graph k) (H : Graph k') (e : Fin k ≃ Fin k')
    (he : ∀ i j, G.adj i j = H.adj (e i) (e j)) (S : Finset (Fin k)) :
    win G S ↔ win H (S.map e.toEmbedding) := by
  sorry

end NodeKayles
