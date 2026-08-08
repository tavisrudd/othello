import RelativeConicArcs.ClebschOuterSegreRelations
import Mathlib.Tactic.Ring

/-!
# The six outer conference representatives and their coloured-triangle frame

The six signed translates of the oriented triangle cubic of the fixed order-six
integral conference matrix are indexed here by the six reorderings of the
labels `3`, `4`, `5`, as in `RelativeConicArcs.ClebschOuterSegreRelations`.
This module supplies the two things that presentation leaves implicit: an
explicit conference matrix carrying each translate, and the explicit table of
twenty signs that each translate puts on the twenty increasing triples.

The representative attached to a reordering `σ` is the relabelled matrix
`C.submatrix σ⁻¹ σ⁻¹`, negated when `σ` is odd.  It is again symmetric, has
vanishing diagonal, has off-diagonal entries squaring to one, and satisfies the
same conference equation `C² = 5 • 1`; the negation is what makes its twenty
triangle products equal the twenty coefficients of the corresponding translate
rather than their negatives, since a triangle product is a cubic monomial in the
entries.  The resulting six sign words are recorded as an explicit table, and
the theorems below prove that the table is exactly what the reordering rule
produces, that it is the table of triangle products of the representative, that
each of its rows satisfies the four-point two-graph identity, that the six rows
are pairwise distinct, and that each translate is the coloured-triangle cubic of
its row, coefficient by coefficient.

All statements about the explicit tables are exhaustive kernel decisions over
their full finite index domains: thirty-six pairs of a reordering and a label
for the inverse tables, twenty triples for their monotonicity, four hundred
ordered pairs of triples for their distinctness, one hundred and twenty pairs of
a reordering and a triple for the entries of the sign table, and seven hundred
and twenty triples of two reorderings and a label for the distinctness of the
six rows.  The coefficient identity itself holds over an arbitrary commutative
ring.  Nothing here identifies the six translates with a construction outside
this repository; the correspondence with the one-factorizations of the complete
graph on the six labels is proved in
`RelativeConicArcs.ClebschOuterMatchingFrame`.
-/

namespace RelativeConicArcs.ClebschOuterJoubertFrame

open RelativeConicArcs.ClebschGoldenConference
open RelativeConicArcs.ClebschOuterSegreRelations

/-- The inverses of the six coordinate reorderings indexing the outer family.
Each fixes the labels `0`, `1`, `2`; the two three-cycles on `3`, `4`, `5` are
exchanged, and the three transpositions and the identity are their own
inverses. -/
def outerReindexInverse : Fin 6 → Fin 6 → Fin 6 :=
  ![![0, 1, 2, 3, 4, 5],
    ![0, 1, 2, 3, 5, 4],
    ![0, 1, 2, 4, 3, 5],
    ![0, 1, 2, 5, 3, 4],
    ![0, 1, 2, 4, 5, 3],
    ![0, 1, 2, 5, 4, 3]]

/-- The displayed inverse reordering is a right inverse to the `t`-th outer
coordinate reordering. -/
theorem outerReindex_outerReindexInverse (t i : Fin 6) :
    outerReindex t (outerReindexInverse t i) = i := by decide +revert

/-- The displayed inverse reordering is a left inverse to the `t`-th outer
coordinate reordering. -/
theorem outerReindexInverse_outerReindex (t i : Fin 6) :
    outerReindexInverse t (outerReindex t i) = i := by decide +revert

/-- The relabelling of the six axes attached to the `t`-th member of the outer
family, as a permutation of the labels. -/
def outerRelabel (t : Fin 6) : Equiv.Perm (Fin 6) where
  toFun := outerReindexInverse t
  invFun := outerReindex t
  left_inv i := outerReindex_outerReindexInverse t i
  right_inv i := outerReindexInverse_outerReindex t i

/-- The outer relabelling acts by the displayed inverse coordinate reordering. -/
theorem outerRelabel_apply (t i : Fin 6) : outerRelabel t i = outerReindexInverse t i := rfl

/-- The relabelling of the fixed integral conference matrix along the inverse of
the `t`-th reordering. -/
def relabelledConference (t : Fin 6) : Matrix (Fin 6) (Fin 6) ℤ :=
  conferenceMatrix.submatrix (outerReindexInverse t) (outerReindexInverse t)

/-- The conference matrix carrying the `t`-th member of the outer family: the
relabelling above, negated when the reordering is odd, so that its triangle
products are the coefficients of the `t`-th translate rather than their
negatives. -/
def outerConference (t : Fin 6) : Matrix (Fin 6) (Fin 6) ℤ :=
  outerSign ℤ t • relabelledConference t

/-- Entrywise form of the signed, relabelled conference matrix representing the
`t`-th outer cubic. -/
theorem outerConference_apply (t i j : Fin 6) :
    outerConference t i j =
      outerSign ℤ t *
        conferenceMatrix (outerReindexInverse t i) (outerReindexInverse t j) := rfl

/-- The sign of each reordering squares to one. -/
theorem outerSign_sq (t : Fin 6) : outerSign ℤ t * outerSign ℤ t = 1 := by
  decide +revert

/-- Each outer representative is symmetric. -/
theorem outerConference_transpose (t : Fin 6) :
    (outerConference t).transpose = outerConference t := by
  rw [outerConference, Matrix.transpose_smul, relabelledConference,
    Matrix.transpose_submatrix, conferenceMatrix_transpose]

/-- Each outer representative has vanishing diagonal. -/
theorem outerConference_apply_self (t i : Fin 6) : outerConference t i i = 0 := by
  rw [outerConference_apply, conferenceMatrix_apply_self, mul_zero]

/-- Every off-diagonal entry of an outer representative squares to one. -/
theorem outerConference_apply_sq (t i j : Fin 6) (hij : i ≠ j) :
    outerConference t i j * outerConference t i j = 1 := by
  have hne : outerReindexInverse t i ≠ outerReindexInverse t j :=
    fun h => hij ((outerRelabel t).injective h)
  rw [outerConference_apply]
  calc
    outerSign ℤ t * conferenceMatrix (outerReindexInverse t i) (outerReindexInverse t j) *
        (outerSign ℤ t * conferenceMatrix (outerReindexInverse t i) (outerReindexInverse t j))
        = (outerSign ℤ t * outerSign ℤ t) *
          (conferenceMatrix (outerReindexInverse t i) (outerReindexInverse t j) *
            conferenceMatrix (outerReindexInverse t i) (outerReindexInverse t j)) := by ring
    _ = 1 := by rw [outerSign_sq, conferenceMatrix_apply_sq _ _ hne]; ring

/-- Each outer representative satisfies the same conference equation as the
fixed matrix.  Renaming labels along a permutation is a ring map on matrices, so
the square is carried across unchanged, and the sign of the reordering squares
away. -/
theorem outerConference_sq (t : Fin 6) :
    outerConference t * outerConference t =
      5 • (1 : Matrix (Fin 6) (Fin 6) ℤ) := by
  have hrel : relabelledConference t * relabelledConference t =
      5 • (1 : Matrix (Fin 6) (Fin 6) ℤ) := by
    have hsub : relabelledConference t =
        conferenceMatrix.submatrix (outerRelabel t) (outerRelabel t) := rfl
    rw [hsub, Matrix.submatrix_mul_equiv _ _ _ (outerRelabel t) _, conferenceMatrix_sq]
    ext i j
    simp only [Matrix.submatrix_apply, Matrix.smul_apply, Matrix.one_apply,
      (outerRelabel t).injective.eq_iff]
  rw [outerConference, Matrix.smul_mul, Matrix.mul_smul, hrel, smul_smul,
    outerSign_sq, one_smul]

/-- The triangle product of an outer representative on three labels is the sign
of its reordering times the triangle product of the fixed conference matrix on
their preimages: a triangle product is a cubic monomial in the entries, so the
sign appears once rather than three times. -/
theorem triangleSign_outerConference (t i j k : Fin 6) :
    triangleSign (outerConference t) i j k =
      outerSign ℤ t *
        triangleSign conferenceMatrix (outerReindexInverse t i)
          (outerReindexInverse t j) (outerReindexInverse t k) := by
  simp only [triangleSign, outerConference_apply]
  calc
    _ = (outerSign ℤ t * outerSign ℤ t) * outerSign ℤ t *
        (conferenceMatrix (outerReindexInverse t i) (outerReindexInverse t j) *
          conferenceMatrix (outerReindexInverse t j) (outerReindexInverse t k) *
          conferenceMatrix (outerReindexInverse t k) (outerReindexInverse t i)) := by ring
    _ = _ := by rw [outerSign_sq]; ring

/-- The twenty increasing three-element subsets of the six labels, listed in
the order in which the coefficient words below record their signs. -/
def tripleLabel : Fin 20 → Fin 6 × Fin 6 × Fin 6 :=
  ![(0, 1, 2), (0, 1, 3), (0, 1, 4), (0, 1, 5), (0, 2, 3),
    (0, 2, 4), (0, 2, 5), (0, 3, 4), (0, 3, 5), (0, 4, 5),
    (1, 2, 3), (1, 2, 4), (1, 2, 5), (1, 3, 4), (1, 3, 5),
    (1, 4, 5), (2, 3, 4), (2, 3, 5), (2, 4, 5), (3, 4, 5)]

/-- The twenty labels listed by `tripleLabel` are strictly increasing triples,
and the twenty listed triples are pairwise distinct.  A reader who also counts
the three-element subsets of six labels concludes that the list is exactly that
set; the count itself is not formalized here. -/
theorem tripleLabel_strictMono (n : Fin 20) :
    (tripleLabel n).1 < (tripleLabel n).2.1 ∧ (tripleLabel n).2.1 < (tripleLabel n).2.2 := by
  decide +kernel +revert

/-- The increasing-triple indexing of the twenty cubic coefficients is
injective. -/
theorem tripleLabel_injective : Function.Injective tripleLabel := by decide +kernel +revert

/-- The coefficient words of the six outer cubics: row `t` lists, in the order
of `tripleLabel`, the sign that the `t`-th translate attaches to each
increasing triple. -/
def outerColouring : Fin 6 → Fin 20 → ℤ :=
  ![![-1, -1,  1,  1,  1, -1,  1,  1, -1, -1,  1,  1, -1, -1,  1, -1, -1, -1,  1,  1],
    ![ 1,  1, -1, -1, -1, -1,  1,  1, -1,  1, -1,  1, -1, -1,  1,  1,  1,  1, -1, -1],
    ![ 1, -1,  1, -1,  1, -1, -1, -1,  1,  1, -1, -1,  1,  1,  1, -1,  1, -1,  1, -1],
    ![-1,  1, -1,  1,  1,  1, -1, -1, -1,  1, -1,  1,  1,  1, -1, -1, -1,  1, -1,  1],
    ![-1,  1,  1, -1, -1,  1,  1, -1,  1, -1,  1, -1,  1, -1, -1,  1,  1, -1, -1,  1],
    ![ 1, -1, -1,  1, -1,  1, -1,  1,  1, -1,  1, -1, -1,  1, -1,  1, -1,  1,  1, -1]]

/-- Every entry of the table is a sign. -/
theorem outerColouring_sq (t : Fin 6) (n : Fin 20) :
    outerColouring t n * outerColouring t n = 1 := by decide +kernel +revert

/-- The table is what the reordering rule produces: the sign that the `t`-th
translate attaches to an increasing triple `S` is the sign of the `t`-th
reordering times the triangle product of the fixed conference matrix on the
preimage of `S`. -/
theorem outerColouring_eq_smul_triangleSign (t : Fin 6) (n : Fin 20) :
    outerColouring t n =
      outerSign ℤ t *
        triangleSign conferenceMatrix (outerReindexInverse t (tripleLabel n).1)
          (outerReindexInverse t (tripleLabel n).2.1)
          (outerReindexInverse t (tripleLabel n).2.2) := by
  decide +kernel +revert

/-- Equivalently, and this is the property the representatives are chosen for,
the table is the table of triangle products of the outer representative:
row `t` at the triple `S` is the triangle product of `outerConference t` on
`S`. -/
theorem outerColouring_eq_triangleSign_outerConference (t : Fin 6) (n : Fin 20) :
    outerColouring t n =
      triangleSign (outerConference t) (tripleLabel n).1 (tripleLabel n).2.1
        (tripleLabel n).2.2 := by
  rw [triangleSign_outerConference]
  exact outerColouring_eq_smul_triangleSign t n

/-- The six coefficient words are pairwise distinct, so the outer family has
six members rather than fewer. -/
theorem outerColouring_injective : Function.Injective outerColouring := by
  decide +kernel +revert

/-- Each row of the table obeys the four-point two-graph identity: the product
of the four signs carried by the four triples inside a four-element set of
labels is one.  The global sign of the row cancels, being a fourth power, so
this is the four-point identity for the triangle products of the outer
representative. -/
theorem outerColouring_four_point (t : Fin 6) (n₁ n₂ n₃ n₄ : Fin 20)
    (i j k l : Fin 6)
    (hij : i ≠ j) (hik : i ≠ k) (hil : i ≠ l)
    (hjk : j ≠ k) (hjl : j ≠ l) (hkl : k ≠ l)
    (h₁ : tripleLabel n₁ = (i, j, k)) (h₂ : tripleLabel n₂ = (i, j, l))
    (h₃ : tripleLabel n₃ = (i, k, l)) (h₄ : tripleLabel n₄ = (j, k, l)) :
    outerColouring t n₁ * outerColouring t n₂ *
      outerColouring t n₃ * outerColouring t n₄ = 1 := by
  have hsign := fun m => outerColouring_eq_triangleSign_outerConference t m
  rw [hsign n₁, hsign n₂, hsign n₃, hsign n₄, h₁, h₂, h₃, h₄]
  exact triangleSign_four_point (outerConference t)
    (outerConference_transpose t) (fun a b hab => outerConference_apply_sq t a b hab)
    i j k l hij hik hil hjk hjl hkl

/-- The coloured-triangle cubic of a sign function on the twenty increasing
triples: the sum over the triples of the sign times the product of the three
corresponding coordinates. -/
def colouringCubic {R : Type*} [CommRing R] (e : Fin 20 → R) (x : Fin 6 → R) : R :=
  ∑ n : Fin 20,
    e n * (x (tripleLabel n).1 * x (tripleLabel n).2.1 * x (tripleLabel n).2.2)

/-- Coefficient-by-coefficient identification of the six outer cubics with the
coloured-triangle forms of the displayed table: over every commutative ring and
identically in the six coordinates, the `t`-th signed translate of the triangle
cubic is the cubic whose coefficient on each increasing triple is the entry of
row `t`. -/
theorem outerCubic_eq_colouringCubic {R : Type*} [CommRing R] (x : Fin 6 → R)
    (t : Fin 6) :
    outerCubic x t = colouringCubic (fun n => ((outerColouring t n : ℤ) : R)) x := by
  fin_cases t <;>
    simp [colouringCubic, Fin.sum_univ_succ, tripleLabel, outerColouring, outerCubic,
      outerSign, outerReindex, triangleCubic, cubicTerm, triangleSign,
      conferenceMatrixOver, conferenceMatrix] <;>
    ring

end RelativeConicArcs.ClebschOuterJoubertFrame
