import ProjectiveCap.GridGame
import Mathlib.Data.Finset.Card

/-!
# Residual grid counting vocabulary

This file contains stable finite-set facts used by the residual-grid extension
count.  It deliberately stops short of the incidence-heavy `q^2 - 9q + 21`
theorem.
-/

namespace ProjectiveCap

variable {K : Type*} [Field K] [Fintype K] [DecidableEq K]

/-- Rows already used by a residual-grid position. -/
noncomputable def UsedRows (S : Finset (GridPoint K)) : Finset K :=
  S.image Prod.fst

/-- Columns already used by a residual-grid position. -/
noncomputable def UsedCols (S : Finset (GridPoint K)) : Finset K :=
  S.image Prod.snd

/-- Candidate cells in unused rows and unused columns. -/
noncomputable def FreeFreeCells (S : Finset (GridPoint K)) : Finset (GridPoint K) :=
  Finset.univ.filter fun p =>
    p.1 ∉ UsedRows (K := K) S ∧ p.2 ∉ UsedCols (K := K) S

/-- The affine line through a pair of grid points, represented as a finset. -/
noncomputable def PairLine (a b : GridPoint K) : Finset (GridPoint K) := by
  classical
  exact Finset.univ.filter fun p => Collinear (K := K) a b p

/-- A candidate is blocked by some old pair-line. -/
def PairLineBlockedBy (S : Finset (GridPoint K)) (p : GridPoint K) : Prop :=
  ∃ a : GridPoint K, ∃ b : GridPoint K,
    a ∈ S ∧ b ∈ S ∧ a ≠ b ∧ Collinear (K := K) a b p

omit [Field K] [Fintype K] in
theorem mem_usedRows {S : Finset (GridPoint K)} {r : K} :
    r ∈ UsedRows (K := K) S ↔ ∃ p : GridPoint K, p ∈ S ∧ p.1 = r := by
  simp [UsedRows]

omit [Field K] [Fintype K] in
theorem mem_usedCols {S : Finset (GridPoint K)} {c : K} :
    c ∈ UsedCols (K := K) S ↔ ∃ p : GridPoint K, p ∈ S ∧ p.2 = c := by
  simp [UsedCols]

omit [Field K] in
theorem mem_freeFreeCells {S : Finset (GridPoint K)} {p : GridPoint K} :
    p ∈ FreeFreeCells (K := K) S ↔
      p.1 ∉ UsedRows (K := K) S ∧ p.2 ∉ UsedCols (K := K) S := by
  simp [FreeFreeCells]

theorem mem_pairLine {a b p : GridPoint K} :
    p ∈ PairLine (K := K) a b ↔ Collinear (K := K) a b p := by
  classical
  simp [PairLine]

omit [Field K] [Fintype K] in
theorem card_usedRows_eq_card_of_rowSparse {S : Finset (GridPoint K)}
    (hrow : RowSparse (K := K) S) :
    (UsedRows (K := K) S).card = S.card := by
  classical
  unfold UsedRows
  exact Finset.card_image_of_injOn (by
    intro p hp q hq hpq
    exact hrow hp hq hpq)

omit [Field K] [Fintype K] in
theorem card_usedCols_eq_card_of_colSparse {S : Finset (GridPoint K)}
    (hcol : ColSparse (K := K) S) :
    (UsedCols (K := K) S).card = S.card := by
  classical
  unfold UsedCols
  exact Finset.card_image_of_injOn (by
    intro p hp q hq hpq
    exact hcol hp hq hpq)

omit [Fintype K] in
theorem card_usedRows_of_card_three {S : Finset (GridPoint K)}
    (hcard : S.card = 3) (hS : GridCap (K := K) S) :
    (UsedRows (K := K) S).card = 3 := by
  rw [card_usedRows_eq_card_of_rowSparse hS.1.1, hcard]

omit [Fintype K] in
theorem card_usedCols_of_card_three {S : Finset (GridPoint K)}
    (hcard : S.card = 3) (hS : GridCap (K := K) S) :
    (UsedCols (K := K) S).card = 3 := by
  rw [card_usedCols_eq_card_of_colSparse hS.1.2, hcard]

end ProjectiveCap
