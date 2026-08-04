import RelativeConicArcs.ClebschGoldenConference
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic

/-!
# The middle exterior return on six labelled axes

The twenty basis vectors are the increasing three-subsets of six labels in
lexicographic order.  The third compound matrix is defined entrywise by the
corresponding `3 × 3` minor.  Signed complementation defines the middle Hodge
matrix, and their product is the middle-exterior return.

Two displayed tables carry the complementation datum: the index table
`complementIndex` and the sign table `hodgeSign`.  This module proves that
neither is an arbitrary choice.  A basis label's triple and the triple of its
`complementIndex` image are complementary subsets of the six labels, and that
property determines the table; the sign table is minus one to the number of
inversions of the map which concatenates a triple with its increasing
complement.  That map is proved to be a permutation of the six labels, and
minus one to the inversion count is the sign of a permutation by the standard
inversion formula, but that identification is stated as ambient convention and
is not formalized here: no comparison with a library permutation-sign function
is proved.  The inversion count is three less than the sum of the triple's
labels, so the sign depends only on the parity of that sum.  Because two
complementary triples have label sums adding to `0 + 1 + 2 + 3 + 4 + 5 = 15`,
the two complementary signs multiply to `(-1)^17 = -1`, which is the parity
computation behind middle-degree Hodge complementation squaring to minus the
identity.  The exponent `17` is the normalized form `(σ(S)+1) + (σ(Sᶜ)+1)`
used below to keep both exponents natural numbers; in the equivalent form
`(-1)^(σ(S)-3)` for each sign the product exponent is `9`.

The exhaustive checking that the displayed signs previously carried has not
disappeared; it has moved down to the tables themselves and changed subject.
Six statements are kernel decisions: that distinct labels have distinct
subsets and that the concatenation map is injective, over the four hundred
ordered pairs of labels and the seven hundred and twenty label-position-pair
triples respectively; and, over the twenty labels, that the index table is set
complement, that the sign table is minus one to the inversion count, that the
inversion count is the label sum less three, and that complementary label sums
are fifteen.  Each of the latter four is a statement a reader can verify
directly from the displayed tables, rather than an opaque list of signs.  No
`20 × 20` return matrix, generated table, compiled evaluation, or
external axiom is used.

The table `triple` itself remains displayed data whose documented description —
the increasing three-subsets of six labels in lexicographic order — is not
formally supported here; the inversion argument takes its increasingness as
given.
-/

namespace RelativeConicArcs
namespace ClebschMiddleExterior

open Matrix
open scoped Matrix
open ClebschGoldenConference

set_option maxRecDepth 10000

/-- The increasing triples of `Fin 6`, in lexicographic order. -/
def triple : Fin 20 → Fin 3 → Fin 6 :=
  ![![0, 1, 2], ![0, 1, 3], ![0, 1, 4], ![0, 1, 5],
    ![0, 2, 3], ![0, 2, 4], ![0, 2, 5], ![0, 3, 4],
    ![0, 3, 5], ![0, 4, 5], ![1, 2, 3], ![1, 2, 4],
    ![1, 2, 5], ![1, 3, 4], ![1, 3, 5], ![1, 4, 5],
    ![2, 3, 4], ![2, 3, 5], ![2, 4, 5], ![3, 4, 5]]

/-- The underlying three-element set of a basis label. -/
def tripleSet (S : Fin 20) : Finset (Fin 6) :=
  {triple S 0, triple S 1, triple S 2}

/-- Intersection size of two triple-basis labels. -/
def intersectionSize (S T : Fin 20) : ℕ :=
  (tripleSet S ∩ tripleSet T).card

/-- Number of basis labels meeting each of two triples in one point. -/
def commonIntersectionOneNeighbors (S T : Fin 20) : ℕ :=
  (Finset.univ.filter fun U : Fin 20 =>
    intersectionSize U S = 1 ∧ intersectionSize U T = 1).card

/-- Complementation on the lexicographically ordered triple basis. -/
def complementIndex : Fin 20 → Fin 20 :=
  ![19, 18, 17, 16, 15, 14, 13, 12, 11, 10,
    9, 8, 7, 6, 5, 4, 3, 2, 1, 0]

/-- Sign attached to a basis label by concatenating its triple with the
increasing complementary triple.  `hodgeSign_eq_neg_one_pow_inversions` proves
that the table is minus one to the inversion count of that concatenation,
which is the sign of the concatenation permutation under the standard
inversion formula for permutation signs; the comparison with a library
permutation-sign function is not formalized. -/
def hodgeSign : Fin 20 → ℤ :=
  ![1, -1, 1, -1, 1, -1, 1, 1, -1, 1,
    -1, 1, -1, -1, 1, -1, 1, -1, 1, -1]

/-- The three-element subset of a basis label determines the label. -/
theorem tripleSet_injective : Function.Injective tripleSet := by
  intro S T hST
  revert hST
  revert S T
  decide

/-- Complementation on the lexicographically ordered triple basis is set
complement on the underlying three-element subsets of the six labels. -/
theorem tripleSet_complementIndex (S : Fin 20) :
    tripleSet (complementIndex S) = (tripleSet S)ᶜ := by
  revert S
  decide

/-- Set complement characterizes the index table: a basis label is the
complement of `S` exactly when its subset is the set complement of `S`'s.  So
`complementIndex` records complementation rather than choosing a pairing. -/
theorem eq_complementIndex_iff (S T : Fin 20) :
    T = complementIndex S ↔ tripleSet T = (tripleSet S)ᶜ := by
  constructor
  · rintro rfl
    exact tripleSet_complementIndex S
  · intro h
    exact tripleSet_injective (h.trans (tripleSet_complementIndex S).symm)

/-- Complementation is an involution on the triple basis, because set
complement is an involution on the three-element subsets. -/
theorem complementIndex_involutive : Function.Involutive complementIndex := by
  intro S
  refine tripleSet_injective ?_
  rw [tripleSet_complementIndex, tripleSet_complementIndex, compl_compl]

/-- Sum of the three labels of a basis triple. -/
def tripleSum (S : Fin 20) : ℕ :=
  (triple S 0 : ℕ) + (triple S 1 : ℕ) + (triple S 2 : ℕ)

/-- The map of the six positions which carries `0, 1, 2` to the increasing
labels of the triple `S` and `3, 4, 5` to the increasing labels of the
complementary triple. -/
def concatenation (S : Fin 20) : Fin 6 → Fin 6 :=
  ![triple S 0, triple S 1, triple S 2,
    triple (complementIndex S) 0, triple (complementIndex S) 1,
    triple (complementIndex S) 2]

/-- The concatenation map is injective, hence a permutation of the six
labels. -/
theorem concatenation_injective (S : Fin 20) :
    Function.Injective (concatenation S) := by
  intro i j hij
  revert hij
  revert i j
  revert S
  decide

/-- The concatenation map is a permutation of the six labels.  This is what
licenses reading its inversion count as a permutation statistic; it is not
itself used in the proof of the sign identity below. -/
theorem concatenation_bijective (S : Fin 20) :
    Function.Bijective (concatenation S) :=
  Finite.injective_iff_bijective.mp (concatenation_injective S)

/-- Inversions of the concatenation map: ordered pairs of positions whose
labels appear in the opposite order.  Minus one raised to this count is the
sign of a permutation under the standard inversion formula, which is used here
as ambient convention rather than as a formalized comparison. -/
def concatenationInversions (S : Fin 20) : ℕ :=
  (Finset.univ.filter fun p : Fin 6 × Fin 6 =>
    p.1 < p.2 ∧ concatenation S p.2 < concatenation S p.1).card

/-- The displayed sign table is minus one to the number of inversions of the
concatenation map, that is, the sign of that permutation under the standard
inversion formula. -/
theorem hodgeSign_eq_neg_one_pow_inversions (S : Fin 20) :
    hodgeSign S = (-1 : ℤ) ^ concatenationInversions S := by
  revert S
  decide

/-- Concatenating a triple with its increasing complement inverts a position
pair exactly when a label of the triple exceeds a label of the complement, and
the label `triple S k` exceeds exactly `triple S k - k` of them.  Summing over
the three positions gives `tripleSum S - 3` inversions. -/
theorem concatenationInversions_add_three (S : Fin 20) :
    concatenationInversions S + 3 = tripleSum S := by
  revert S
  decide

/-- Two complementary triples partition the six labels, so their label sums
add to `0 + 1 + 2 + 3 + 4 + 5`. -/
theorem tripleSum_add_tripleSum_complementIndex (S : Fin 20) :
    tripleSum S + tripleSum (complementIndex S) = 15 := by
  revert S
  decide

/-- The concatenation sign depends only on the parity of the triple's label
sum. -/
theorem hodgeSign_eq_neg_one_pow_tripleSum (S : Fin 20) :
    hodgeSign S = (-1 : ℤ) ^ (tripleSum S + 1) := by
  rw [hodgeSign_eq_neg_one_pow_inversions,
    ← concatenationInversions_add_three S,
    show concatenationInversions S + 3 + 1 = concatenationInversions S + 4 from rfl,
    pow_add]
  norm_num

/-- Each concatenation sign is a unit of square one. -/
theorem hodgeSign_mul_self (S : Fin 20) : hodgeSign S * hodgeSign S = 1 := by
  rw [hodgeSign_eq_neg_one_pow_tripleSum, ← pow_add, ← two_mul, pow_mul]
  norm_num

/-- The two concatenation signs of a triple and its complement multiply to
minus one.  This is a parity computation: the two signs are minus one to
`tripleSum S + 1` and `tripleSum Sᶜ + 1`, and the two label sums add to `15`,
so the product is `(-1)^17`.  It is the whole content of middle-degree Hodge
complementation squaring to minus the identity. -/
theorem hodgeSign_mul_complement (S : Fin 20) :
    hodgeSign S * hodgeSign (complementIndex S) = -1 := by
  have h : tripleSum S + 1 + (tripleSum (complementIndex S) + 1) = 17 := by
    have := tripleSum_add_tripleSum_complementIndex S
    omega
  rw [hodgeSign_eq_neg_one_pow_tripleSum, hodgeSign_eq_neg_one_pow_tripleSum,
    ← pow_add, h]
  norm_num

/-- Signed middle-degree Hodge complementation.  In row `S` the coefficient
is `ε(Sᶜ,S) = -ε(S,Sᶜ)`, so on column vectors this sends
`e_S` to `ε(S,Sᶜ)e_{Sᶜ}`. -/
def hodgeMatrix : Matrix (Fin 20) (Fin 20) ℤ :=
  fun S T => if T = complementIndex S then -hodgeSign S else 0

/-- The `3 × 3` minor selected by two increasing triples. -/
def minorThree (C : Matrix (Fin 6) (Fin 6) ℤ) (S T : Fin 20) :
    Matrix (Fin 3) (Fin 3) ℤ :=
  fun i j => C (triple S i) (triple T j)

/-- Closed determinant formula in dimension three. -/
def detThree (A : Matrix (Fin 3) (Fin 3) ℤ) : ℤ :=
  A 0 0 * A 1 1 * A 2 2 - A 0 0 * A 1 2 * A 2 1
    - A 0 1 * A 1 0 * A 2 2 + A 0 1 * A 1 2 * A 2 0
    + A 0 2 * A 1 0 * A 2 1 - A 0 2 * A 1 1 * A 2 0

/-- The closed formula is the ordinary matrix determinant. -/
theorem detThree_eq_det (A : Matrix (Fin 3) (Fin 3) ℤ) :
    detThree A = Matrix.det A := by
  simpa [detThree] using (Matrix.det_fin_three A).symm

/-- The third compound matrix, representing the third exterior power in the
increasing-triple bases. -/
def compoundThree (C : Matrix (Fin 6) (Fin 6) ℤ) :
    Matrix (Fin 20) (Fin 20) ℤ :=
  fun S T => detThree (minorThree C S T)

/-- The middle-exterior return `* Λ³C` for the golden conference matrix.  The
sparse Hodge factor is evaluated directly. -/
def middleExterior : Matrix (Fin 20) (Fin 20) ℤ :=
  fun S T =>
    -hodgeSign S * compoundThree conferenceMatrix (complementIndex S) T

/-- The direct sparse formula for the return equals Hodge multiplication by
the third compound matrix. -/
theorem middleExterior_eq_hodge_mul :
    middleExterior = hodgeMatrix * compoundThree conferenceMatrix := by
  ext S T
  simp [middleExterior, hodgeMatrix, Matrix.mul_apply]

end ClebschMiddleExterior
end RelativeConicArcs
