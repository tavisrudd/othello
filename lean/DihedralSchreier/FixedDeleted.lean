import NodeKayles.Basic

/-!
# Fixed-point-deleted Schreier triples

This file formalizes the construction of Section 3 of the accompanying manuscript. An
`InvolutionTriple` acts on a finite labelled set. Pair-product fixed points form the
deleted set, while the three involutions supply the simple Schreier graph. The actual
Node-Kayles position is that graph with only `live` vertices available.
-/

namespace DihedralSchreier

/-- Three involutions acting on a finite labelled set. -/
structure InvolutionTriple (k : ℕ) where
  act : Fin 3 → Equiv.Perm (Fin k)
  involutive : ∀ i x, act i (act i x) = x

namespace InvolutionTriple

variable {k : ℕ} (T : InvolutionTriple k)

/-- A vertex is deleted when it is fixed by a product of two distinct generators. -/
def PairFixed (x : Fin k) : Prop :=
  ∃ i j : Fin 3, i < j ∧ T.act i (T.act j x) = x

/-- The finite deleted set from equation (3.1). -/
noncomputable def deleted : Finset (Fin k) :=
  by
    classical
    exact Finset.univ.filter (PairFixed T)

/-- The surviving vertices of the fixed-point-deleted Schreier position. -/
noncomputable def live : Finset (Fin k) :=
  Finset.univ \ deleted T

/-- Adjacency before deletion: two distinct vertices are joined when one generator sends
the first to the second. Repeated generator edges are automatically merged. -/
def Adj (x y : Fin k) : Prop :=
  x ≠ y ∧ ∃ i : Fin 3, T.act i x = y

theorem adj_symm {x y : Fin k} : T.Adj x y ↔ T.Adj y x := by
  constructor
  · rintro ⟨hxy, i, hi⟩
    refine ⟨Ne.symm hxy, i, ?_⟩
    rw [← hi]
    exact T.involutive i x
  · rintro ⟨hyx, i, hi⟩
    refine ⟨Ne.symm hyx, i, ?_⟩
    rw [← hi]
    exact T.involutive i y

/-- The simple Schreier graph underlying the residual position. Loops are suppressed by
the `x ≠ y` clause in `Adj`; repeated coloured edges become one Boolean edge. -/
noncomputable def graph : NodeKayles.Graph k := by
  classical
  exact
    { adj := fun x y => decide (Adj T x y)
      symm := fun x y => by
        have hs := adj_symm T (x := x) (y := y)
        by_cases hxy : Adj T x y
        · simp [hxy, hs.mp hxy]
        · have hyx : ¬Adj T y x := fun h => hxy (hs.mpr h)
          simp [hxy, hyx]
      irrefl := fun x => by simp [Adj] }

@[simp] theorem mem_deleted_iff (x : Fin k) : x ∈ deleted T ↔ PairFixed T x := by
  simp [deleted]

@[simp] theorem mem_live_iff (x : Fin k) : x ∈ live T ↔ ¬PairFixed T x := by
  simp [live]

@[simp] theorem graph_adj_eq_true_iff {x y : Fin k} :
    (graph T).adj x y = true ↔ Adj T x y := by
  simp [graph]

/-- The Node-Kayles residual attached to the triple: use `T.graph` as the graph and
`T.live` as the current live set. -/
def residualWin : Prop :=
  NodeKayles.win (graph T) (live T)

end InvolutionTriple

end DihedralSchreier
