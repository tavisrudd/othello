import Mathlib.Algebra.Field.Basic
import Mathlib.Data.Finset.Basic

/-!
# Grid caps for the residual `PG(2,q)` game

This file starts the stable formalization layer for the projective-cap notes.
It models the post-opening residual as an affine grid over a field: legal
positions are partial permutations with no three affine-collinear cells.

The heavier finite-field count `q^2 - 9q + 21` is not stated here yet; this file
only fixes vocabulary and proves the subset monotonicity lemmas that later
counting and game-value statements should reuse.
-/

namespace ProjectiveCap

variable {K : Type*} [Field K]

/-- A grid cell in the residual affine plane. -/
abbrev GridPoint (K : Type*) := K × K

/-- Affine collinearity in coordinates, written without division. -/
def Collinear (p q r : GridPoint K) : Prop :=
  (q.1 - p.1) * (r.2 - p.2) = (q.2 - p.2) * (r.1 - p.1)

/-- A finite set of grid cells has at most one point in each row. -/
def RowSparse (S : Finset (GridPoint K)) : Prop :=
  ∀ ⦃p q : GridPoint K⦄, p ∈ S → q ∈ S → p.1 = q.1 → p = q

/-- A finite set of grid cells has at most one point in each column. -/
def ColSparse (S : Finset (GridPoint K)) : Prop :=
  ∀ ⦃p q : GridPoint K⦄, p ∈ S → q ∈ S → p.2 = q.2 → p = q

/-- The burned-direction constraint: at most one point per row and column. -/
def PartialPermutation (S : Finset (GridPoint K)) : Prop :=
  RowSparse S ∧ ColSparse S

/-- No three distinct selected grid cells are affine-collinear. -/
def AffineCap (S : Finset (GridPoint K)) : Prop :=
  ∀ ⦃a b c : GridPoint K⦄,
    a ∈ S → b ∈ S → c ∈ S →
      a ≠ b → a ≠ c → b ≠ c → ¬ Collinear a b c

/-- Legal residual positions after the projective opening pair. -/
def GridCap (S : Finset (GridPoint K)) : Prop :=
  PartialPermutation S ∧ AffineCap S

omit [Field K] in
theorem rowSparse_mono {S T : Finset (GridPoint K)}
    (hST : S ⊆ T) (hT : RowSparse T) : RowSparse S := by
  intro p q hp hq heq
  exact hT (hST hp) (hST hq) heq

omit [Field K] in
theorem colSparse_mono {S T : Finset (GridPoint K)}
    (hST : S ⊆ T) (hT : ColSparse T) : ColSparse S := by
  intro p q hp hq heq
  exact hT (hST hp) (hST hq) heq

omit [Field K] in
theorem partialPermutation_mono {S T : Finset (GridPoint K)}
    (hST : S ⊆ T) (hT : PartialPermutation T) : PartialPermutation S :=
  ⟨rowSparse_mono hST hT.1, colSparse_mono hST hT.2⟩

theorem affineCap_mono {S T : Finset (GridPoint K)}
    (hST : S ⊆ T) (hT : AffineCap T) : AffineCap S := by
  intro a b c ha hb hc hab hac hbc
  exact hT (hST ha) (hST hb) (hST hc) hab hac hbc

theorem gridCap_mono {S T : Finset (GridPoint K)}
    (hST : S ⊆ T) (hT : GridCap T) : GridCap S :=
  ⟨partialPermutation_mono hST hT.1, affineCap_mono hST hT.2⟩

end ProjectiveCap
