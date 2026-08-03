import Mathlib.Algebra.Field.Basic
import Mathlib.Data.Fintype.Basic
import Mathlib.Data.Fintype.Prod
import Mathlib.Data.Finset.Basic

/-!
# Grid caps in the affine plane over a field

Let `K` be a field and let `GridPoint K = K × K` be the cells of the affine plane
in coordinates. Three cells `p`, `q`, `r` are `Collinear` when the division-free
identity `(q.1 - p.1) * (r.2 - p.2) = (q.2 - p.2) * (r.1 - p.1)` holds. That
condition is symmetric in the usual sense of affine collinearity and makes no
distinctness assumption, so a repeated cell is collinear with anything; the
distinctness hypotheses are carried by the cap predicate below.

A finite set `S` of cells is `RowSparse` when distinct members never share a first
coordinate, `ColSparse` when distinct members never share a second coordinate, and
a `PartialPermutation` when both hold. It satisfies `AffineCap` when no three
pairwise distinct members are collinear, and it is a `GridCap` when it is both a
partial permutation and an affine cap.

Over a finite field with decidable equality each of these predicates is decided by
enumerating pairs or triples of cells of `K × K`. The remaining results record
that all five predicates are inherited by subsets.
-/

namespace ProjectiveCap

variable {K : Type*} [Field K]

/-- A cell of the affine plane over `K`, given by its pair of coordinates. -/
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

/-- A finite set of grid cells meets each row and each column at most once, so its
cells are the graph of a partial injection from first to second coordinates. -/
def PartialPermutation (S : Finset (GridPoint K)) : Prop :=
  RowSparse S ∧ ColSparse S

/-- No three distinct selected grid cells are affine-collinear. -/
def AffineCap (S : Finset (GridPoint K)) : Prop :=
  ∀ ⦃a b c : GridPoint K⦄,
    a ∈ S → b ∈ S → c ∈ S →
      a ≠ b → a ≠ c → b ≠ c → ¬ Collinear a b c

/-- A grid cap: a finite set of cells of the affine plane over `K` that meets each
row and each column at most once and contains no three pairwise distinct collinear
cells. -/
def GridCap (S : Finset (GridPoint K)) : Prop :=
  PartialPermutation S ∧ AffineCap S

/-- Decides affine collinearity of three cells of `K × K` over a field with
decidable equality, since the defining condition is a single equation between two
products of coordinate differences. -/
instance instDecidableCollinear {K : Type*} [Field K] [DecidableEq K] (p q r : GridPoint K) :
    Decidable (Collinear (K := K) p q r) := by
  unfold Collinear
  infer_instance

/-- Decides whether a finite set of grid cells over a finite field has at most one
point in each row, by enumerating all ordered pairs of cells of `K × K`. -/
instance instDecidableRowSparse {K : Type*} [Field K] [Fintype K] [DecidableEq K]
    (S : Finset (GridPoint K)) :
    Decidable (RowSparse (K := K) S) :=
  decidable_of_iff
    (∀ p ∈ (Finset.univ : Finset (GridPoint K)),
      ∀ q ∈ (Finset.univ : Finset (GridPoint K)), p ∈ S -> q ∈ S -> p.1 = q.1 -> p = q)
    (by
      constructor
      · intro h p q hp hq hrow
        exact h p (Finset.mem_univ p) q (Finset.mem_univ q) hp hq hrow
      · intro h p _hpU q _hqU hp hq hrow
        exact h hp hq hrow)

/-- Decides whether a finite set of grid cells over a finite field has at most one
point in each column, by enumerating all ordered pairs of cells of `K × K`. -/
instance instDecidableColSparse {K : Type*} [Field K] [Fintype K] [DecidableEq K]
    (S : Finset (GridPoint K)) :
    Decidable (ColSparse (K := K) S) :=
  decidable_of_iff
    (∀ p ∈ (Finset.univ : Finset (GridPoint K)),
      ∀ q ∈ (Finset.univ : Finset (GridPoint K)), p ∈ S -> q ∈ S -> p.2 = q.2 -> p = q)
    (by
      constructor
      · intro h p q hp hq hcol
        exact h p (Finset.mem_univ p) q (Finset.mem_univ q) hp hq hcol
      · intro h p _hpU q _hqU hp hq hcol
        exact h hp hq hcol)

set_option checkBinderAnnotations false in
/-- Decides whether a finite set of grid cells over a finite field has at most one
point in each row and each column, by conjoining the two separate decisions. -/
instance instDecidablePartialPermutation {K : Type*} [Field K] [Fintype K] [DecidableEq K]
    (S : Finset (GridPoint K)) :
    Decidable (PartialPermutation (K := K) S) := by
  unfold PartialPermutation
  infer_instance

/-- Decides whether a finite set of grid cells over a finite field contains no three
pairwise distinct affine-collinear points, by enumerating all ordered triples of
cells of `K × K`. -/
instance instDecidableAffineCap {K : Type*} [Field K] [Fintype K] [DecidableEq K]
    (S : Finset (GridPoint K)) :
    Decidable (AffineCap (K := K) S) :=
  decidable_of_iff
    (∀ a ∈ (Finset.univ : Finset (GridPoint K)),
      ∀ b ∈ (Finset.univ : Finset (GridPoint K)),
      ∀ c ∈ (Finset.univ : Finset (GridPoint K)),
      a ∈ S -> b ∈ S -> c ∈ S ->
        a ≠ b -> a ≠ c -> b ≠ c -> ¬ Collinear (K := K) a b c)
    (by
      constructor
      · intro h a b c ha hb hc hab hac hbc
        exact h a (Finset.mem_univ a) b (Finset.mem_univ b) c (Finset.mem_univ c)
          ha hb hc hab hac hbc
      · intro h a _haU b _hbU c _hcU ha hb hc hab hac hbc
        exact h ha hb hc hab hac hbc)

set_option checkBinderAnnotations false in
/-- Decides whether a finite set of grid cells over a finite field is a grid cap,
by conjoining the decisions of its two defining conditions: at most one point per
row and per column, and no three distinct affine-collinear points. -/
instance instDecidableGridCap {K : Type*} [Field K] [Fintype K] [DecidableEq K]
    (S : Finset (GridPoint K)) :
    Decidable (GridCap (K := K) S) := by
  unfold GridCap
  infer_instance

omit [Field K] in
/-- Having at most one point in each row is inherited by subsets: if distinct points
of `T ⊆ K × K` never share a first coordinate, the same holds in `S ⊆ T`. -/
theorem rowSparse_mono {S T : Finset (GridPoint K)}
    (hST : S ⊆ T) (hT : RowSparse T) : RowSparse S := by
  intro p q hp hq heq
  exact hT (hST hp) (hST hq) heq

omit [Field K] in
/-- Having at most one point in each column is inherited by subsets: if distinct
points of `T ⊆ K × K` never share a second coordinate, the same holds in `S ⊆ T`. -/
theorem colSparse_mono {S T : Finset (GridPoint K)}
    (hST : S ⊆ T) (hT : ColSparse T) : ColSparse S := by
  intro p q hp hq heq
  exact hT (hST hp) (hST hq) heq

omit [Field K] in
/-- Having at most one point in each row and each column is inherited by subsets of
a finite set of grid cells. -/
theorem partialPermutation_mono {S T : Finset (GridPoint K)}
    (hST : S ⊆ T) (hT : PartialPermutation T) : PartialPermutation S :=
  ⟨rowSparse_mono hST hT.1, colSparse_mono hST hT.2⟩

/-- The affine cap condition is inherited by subsets: if no three pairwise distinct
points of `T ⊆ K × K` are affine-collinear, the same holds for every `S ⊆ T`. -/
theorem affineCap_mono {S T : Finset (GridPoint K)}
    (hST : S ⊆ T) (hT : AffineCap T) : AffineCap S := by
  intro a b c ha hb hc hab hac hbc
  exact hT (hST ha) (hST hb) (hST hc) hab hac hbc

/-- Being a grid cap is inherited by subsets: if `T ⊆ K × K` has at most one point
per row and per column and contains no three distinct affine-collinear points, then
so does every `S ⊆ T`. -/
theorem gridCap_mono {S T : Finset (GridPoint K)}
    (hST : S ⊆ T) (hT : GridCap T) : GridCap S :=
  ⟨partialPermutation_mono hST hT.1, affineCap_mono hST hT.2⟩

end ProjectiveCap
