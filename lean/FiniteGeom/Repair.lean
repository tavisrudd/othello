import FiniteGeom.Code
import FiniteGeom.Hypergraph

/-!
# Repair hypergraphs derived from bounded dual-word supports

For a linear code `C ≤ 𝔽ⁿ`, a helper set `R` repairs coordinate `x` when a dual word is nonzero at
`x` and has support exactly `{x} ∪ R`.  `repairHypergraph C x r` collects every such support with
at most `r` helpers, excluding `x` itself.  This is the complete bounded-radius repair hypergraph,
not a selected family of declared recovery groups.

The first structural theorem, `repair_edge_card_eq_of_dualDist`, says that if
`r+1 ≤ d(C⊥)`, every edge in the radius-`r` hypergraph has exactly `r` helpers.  For the q=9 seed,
`d(C₀⊥)=4` therefore makes every radius-three repair a minimum four-support dual circuit.
-/

namespace FiniteGeom

open Finset

variable {n : ℕ} {𝔽 : Type*} [Field 𝔽] [DecidableEq 𝔽]

/-- Hamming support of a word as a `Finset`. -/
def wordSupport (y : Fin n → 𝔽) : Finset (Fin n) :=
  univ.filter fun j => y j ≠ 0

@[simp]
theorem mem_wordSupport {y : Fin n → 𝔽} {j : Fin n} : j ∈ wordSupport y ↔ y j ≠ 0 := by
  simp [wordSupport]

/-- Support cardinality is Hamming weight. -/
theorem card_wordSupport (y : Fin n → 𝔽) : (wordSupport y).card = hammingNorm y := rfl

/-- The complete radius-`r` repair hypergraph at coordinate `x`. An edge is the helper part of a
dual-word support through `x`, with at most `r` helpers and with `x` excluded. -/
noncomputable def repairHypergraph (C : Submodule 𝔽 (Fin n → 𝔽)) (x : Fin n) (r : ℕ) :
    Finset (Finset (Fin n)) := by
  classical
  exact (univ.erase x).powerset.filter fun R =>
    R.card ≤ r ∧ ∃ y ∈ dualCode C, y x ≠ 0 ∧ wordSupport y = insert x R

theorem mem_repairHypergraph {C : Submodule 𝔽 (Fin n → 𝔽)} {x : Fin n} {r : ℕ}
    {R : Finset (Fin n)} :
    R ∈ repairHypergraph C x r ↔
      R ⊆ univ.erase x ∧ R.card ≤ r ∧
        ∃ y ∈ dualCode C, y x ≠ 0 ∧ wordSupport y = insert x R := by
  classical
  simp only [repairHypergraph, mem_filter, mem_powerset]

/-- If the dual distance is at least `r+1`, every radius-`r` repair edge has exactly `r` helpers.
The witnessing dual word has support `insert x R`, hence weight `R.card+1`; dual distance supplies
the lower bound while membership supplies `R.card≤r`. -/
theorem repair_edge_card_eq_of_dualDist {C : Submodule 𝔽 (Fin n → 𝔽)} {x : Fin n} {r : ℕ}
    (hd : r + 1 ≤ dualDist C) {R : Finset (Fin n)} (hR : R ∈ repairHypergraph C x r) :
    R.card = r := by
  obtain ⟨hsub, hcard, y, hy, hyx, hsupp⟩ := mem_repairHypergraph.mp hR
  have hxR : x ∉ R := by
    intro hx
    exact (Finset.mem_erase.mp (hsub hx)).1 rfl
  have hy0 : y ≠ 0 := by
    intro h
    exact hyx (congrFun h x)
  have hdist := dualDist_le_hammingNorm hy hy0
  rw [← card_wordSupport, hsupp, Finset.card_insert_of_notMem hxR] at hdist
  omega

/-- Under the same distance gate and positive radius, every repair edge is nonempty. -/
theorem repair_edge_nonempty_of_dualDist {C : Submodule 𝔽 (Fin n → 𝔽)} {x : Fin n} {r : ℕ}
    (hr : 0 < r) (hd : r + 1 ≤ dualDist C) {R : Finset (Fin n)}
    (hR : R ∈ repairHypergraph C x r) : R.Nonempty := by
  rw [Finset.nonempty_iff_ne_empty]
  intro h
  have hc := repair_edge_card_eq_of_dualDist hd hR
  rw [h, Finset.card_empty] at hc
  omega

/-- A repair edge of a row code gives a genuinely dependent family consisting of the target
column and its helpers. The coefficients are the witnessing dual word restricted to its support. -/
theorem repair_edge_columns_dependent {k : ℕ} {G : Matrix (Fin k) (Fin n) 𝔽}
    {x : Fin n} {r : ℕ} {R : Finset (Fin n)}
    (hR : R ∈ repairHypergraph (rowCode G) x r) :
    ¬ LinearIndependent 𝔽 (fun j : ↥(insert x R) => G.col j) := by
  obtain ⟨-, -, y, hy, hyx, hsupp⟩ := mem_repairHypergraph.mp hR
  have hfull := dual_word_column_relation hy
  have hrel : ∑ j : ↥(insert x R), y j • G.col j = 0 := by
    calc
      (∑ j : ↥(insert x R), y j • G.col j) = ∑ j ∈ insert x R, y j • G.col j := by
        rw [← (insert x R).sum_attach]
        rfl
      _ = ∑ j, y j • G.col j := by
        apply Finset.sum_subset (Finset.subset_univ _)
        intro j _ hj
        have hj0 : y j = 0 := by
          have : j ∉ wordSupport y := by simpa only [hsupp] using hj
          simpa only [mem_wordSupport, not_not] using this
        simp [hj0]
      _ = 0 := hfull
  rw [Fintype.not_linearIndependent_iff]
  refine ⟨(fun j : ↥(insert x R) => y j), hrel, ?_⟩
  exact ⟨⟨x, Finset.mem_insert_self x R⟩, hyx⟩

/-- Reindexing the target-and-helper columns of a repair edge as a square matrix gives zero
determinant. This is the determinant form of `repair_edge_columns_dependent`. -/
theorem repair_edge_reindexed_det_eq_zero {k : ℕ} {G : Matrix (Fin k) (Fin n) 𝔽}
    {x : Fin n} {r : ℕ} {R : Finset (Fin n)}
    (hR : R ∈ repairHypergraph (rowCode G) x r) (e : Fin k ≃ ↥(insert x R)) :
    Matrix.det (fun i j => G i (e j)) = 0 := by
  let A : Matrix (Fin k) (Fin k) 𝔽 := fun i j => G i (e j)
  change A.det = 0
  apply Matrix.det_eq_zero_of_not_linearIndependent_cols
  intro hli
  apply repair_edge_columns_dependent hR
  have heq : (A.col ∘ e.symm) = fun j : ↥(insert x R) => G.col j := by
    funext j
    ext i
    simp [A, Matrix.col]
  rw [← heq]
  exact hli.comp e.symm e.symm.injective

end FiniteGeom
