import Mathlib.Data.Matrix.Mul
import Mathlib.LinearAlgebra.Matrix.Notation
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Ring

/-!
# The order-six golden conference matrix

This module fixes the integral symmetric conference matrix `C` on the six
labelled golden axes, indexed by `Fin 6` in the order `0, 1, 2, 3, 4, 5`.  It
proves the conference equation `C * C = 5 • 1` over `ℤ` and over every
commutative ring reached by the entrywise integer cast, the covariance of the
triangle products `C i j * C j k * C k i` under diagonal sign changes, the
translation invariance of the oriented triangle cubic along the all-ones
vector, and the four-point identity satisfied by the triangle products of an
arbitrary symmetric matrix whose off-diagonal entries square to one.

Three claims about the explicit integer table are finite and are discharged by
kernel reduction alone.  The symmetry `Cᵀ = C` and the square `C * C = 5 • 1`
are reduced entrywise by `Matrix.ext`, their thirty-six index pairs are
enumerated by `Fin` case analysis, and each resulting integer equation is
closed by the kernel; for the square this evaluates the six-term row-column sum
at each pair.  The twenty oriented triangle signs are decided as a single
closed conjunction of integer equations.  Each of these is an exhaustive check
of its entire finite index domain, not a sample.  No compiled evaluation,
generated data, imported certificate, or external assumption enters this
module, so its results rest only on `propext`, `Classical.choice`, and
`Quot.sound`.

The switching, pair-balance, four-point, and base-change statements are
symbolic proofs valid over an arbitrary commutative ring.
-/

namespace RelativeConicArcs
namespace ClebschGoldenConference

open Matrix
open scoped Matrix

/-- The symmetric integral conference matrix attached to the six labelled
golden axes.  The row and column order is `0, 1, 2, 3, 4, 5`. -/
def conferenceMatrix : Matrix (Fin 6) (Fin 6) ℤ :=
  !![0,  1,  1,  1, -1, -1;
     1,  0, -1, -1, -1, -1;
     1, -1,  0,  1,  1, -1;
     1, -1,  1,  0, -1,  1;
    -1, -1,  1, -1,  0, -1;
    -1, -1, -1,  1, -1,  0]

/-- The golden conference matrix is symmetric. -/
theorem conferenceMatrix_transpose : conferenceMatrix.transpose = conferenceMatrix := by
  ext i j
  fin_cases i <;> fin_cases j <;> rfl

/-- The diagonal of the golden conference matrix vanishes. -/
theorem conferenceMatrix_apply_self (i : Fin 6) : conferenceMatrix i i = 0 := by
  fin_cases i <;> rfl

/-- Every off-diagonal entry of the golden conference matrix squares to one. -/
theorem conferenceMatrix_apply_sq (i j : Fin 6) (hij : i ≠ j) :
    conferenceMatrix i j * conferenceMatrix i j = 1 := by
  fin_cases i <;> fin_cases j <;> simp_all [conferenceMatrix]

/-- The conference equation `C² = 5I` over the integers. -/
theorem conferenceMatrix_sq : conferenceMatrix * conferenceMatrix = 5 • (1 : Matrix (Fin 6) (Fin 6) ℤ) := by
  ext i j
  fin_cases i <;> fin_cases j <;> decide

/-- The same labelled conference matrix over a target ring, obtained by
mapping its integral entries. -/
def conferenceMatrixOver (R : Type*) [Ring R] : Matrix (Fin 6) (Fin 6) R :=
  conferenceMatrix.map (Int.castRingHom R)

/-- The conference equation is preserved by every commutative-ring base
change. -/
theorem conferenceMatrixOver_sq (R : Type*) [CommRing R] :
    conferenceMatrixOver R * conferenceMatrixOver R =
      (5 : R) • (1 : Matrix (Fin 6) (Fin 6) R) := by
  have hmapNsmul (n : ℕ) (A : Matrix (Fin 6) (Fin 6) ℤ) :
      (n • A).map (Int.castRingHom R) =
        n • A.map (Int.castRingHom R) := by
    ext i j
    change ((Int.castRingHom R) (n • A i j)) =
      n • (Int.castRingHom R) (A i j)
    simp
  calc
    conferenceMatrixOver R * conferenceMatrixOver R =
        (conferenceMatrix * conferenceMatrix).map (Int.castRingHom R) := by
          rw [conferenceMatrixOver, Matrix.map_mul]
    _ = (5 • (1 : Matrix (Fin 6) (Fin 6) ℤ)).map (Int.castRingHom R) := by
          rw [conferenceMatrix_sq]
    _ = 5 • (1 : Matrix (Fin 6) (Fin 6) ℤ).map (Int.castRingHom R) :=
          hmapNsmul 5 1
    _ = 5 • (1 : Matrix (Fin 6) (Fin 6) R) := by
          rw [Matrix.map_one (Int.castRingHom R) (by simp) (by simp)]
    _ = (5 : R) • (1 : Matrix (Fin 6) (Fin 6) R) := by
          ext i j
          simp [Matrix.one_apply]

/-- Diagonal sign switching sends `C` to the matrix with entry
`d i * C i j * d j`. -/
def switchMatrix {R : Type*} [Mul R] (d : Fin 6 → R)
    (C : Matrix (Fin 6) (Fin 6) R) : Matrix (Fin 6) (Fin 6) R :=
  fun i j => d i * C i j * d j

/-- The triangle product carried by three ordered labels.  For a symmetric
matrix it depends only on the underlying three-element set. -/
def triangleSign {R : Type*} [Mul R] (C : Matrix (Fin 6) (Fin 6) R)
    (i j k : Fin 6) : R :=
  C i j * C j k * C k i

/-- One monomial of the oriented triangle cubic. -/
def cubicTerm {R : Type*} [CommRing R] (C : Matrix (Fin 6) (Fin 6) R)
    (x : Fin 6 → R) (i j k : Fin 6) : R :=
  triangleSign C i j k * x i * x j * x k

/-- The oriented triangle cubic on the six labelled axes.  The twenty terms
are listed in increasing order, fixing the same orientation convention as the
conference matrix. -/
def triangleCubic {R : Type*} [CommRing R]
    (C : Matrix (Fin 6) (Fin 6) R) (x : Fin 6 → R) : R :=
  cubicTerm C x 0 1 2 + cubicTerm C x 0 1 3 +
  cubicTerm C x 0 1 4 + cubicTerm C x 0 1 5 +
  cubicTerm C x 0 2 3 + cubicTerm C x 0 2 4 +
  cubicTerm C x 0 2 5 + cubicTerm C x 0 3 4 +
  cubicTerm C x 0 3 5 + cubicTerm C x 0 4 5 +
  cubicTerm C x 1 2 3 + cubicTerm C x 1 2 4 +
  cubicTerm C x 1 2 5 + cubicTerm C x 1 3 4 +
  cubicTerm C x 1 3 5 + cubicTerm C x 1 4 5 +
  cubicTerm C x 2 3 4 + cubicTerm C x 2 3 5 +
  cubicTerm C x 2 4 5 + cubicTerm C x 3 4 5

/-- The twenty oriented triangle signs of the integral conference matrix, in
the order used by `triangleCubic`. -/
theorem conference_triangleSigns :
    triangleSign conferenceMatrix 0 1 2 = -1 ∧
    triangleSign conferenceMatrix 0 1 3 = -1 ∧
    triangleSign conferenceMatrix 0 1 4 = 1 ∧
    triangleSign conferenceMatrix 0 1 5 = 1 ∧
    triangleSign conferenceMatrix 0 2 3 = 1 ∧
    triangleSign conferenceMatrix 0 2 4 = -1 ∧
    triangleSign conferenceMatrix 0 2 5 = 1 ∧
    triangleSign conferenceMatrix 0 3 4 = 1 ∧
    triangleSign conferenceMatrix 0 3 5 = -1 ∧
    triangleSign conferenceMatrix 0 4 5 = -1 ∧
    triangleSign conferenceMatrix 1 2 3 = 1 ∧
    triangleSign conferenceMatrix 1 2 4 = 1 ∧
    triangleSign conferenceMatrix 1 2 5 = -1 ∧
    triangleSign conferenceMatrix 1 3 4 = -1 ∧
    triangleSign conferenceMatrix 1 3 5 = 1 ∧
    triangleSign conferenceMatrix 1 4 5 = -1 ∧
    triangleSign conferenceMatrix 2 3 4 = -1 ∧
    triangleSign conferenceMatrix 2 3 5 = -1 ∧
    triangleSign conferenceMatrix 2 4 5 = 1 ∧
    triangleSign conferenceMatrix 3 4 5 = 1 := by
  decide

/-- Transport of one integral triangle sign along the entrywise cast: if the
triangle product of the integral conference matrix on the ordered labels
`i, j, k` equals `z`, then the corresponding product for the base-changed
matrix equals the image of `z` in `R`. -/
private theorem cast_conference_triangleSign (R : Type*) [CommRing R]
    (i j k : Fin 6) (z : ℤ) (h : triangleSign conferenceMatrix i j k = z) :
    triangleSign (conferenceMatrixOver R) i j k = (z : R) := by
  simpa [triangleSign, conferenceMatrixOver] using
    congrArg (Int.castRingHom R) h

/-- Sum of the triangle signs through an ordered pair of labels.  Terms with
repeated labels may be retained because a conference matrix has zero
diagonal. -/
def pairTriangleSum {R : Type*} [CommRing R]
    (C : Matrix (Fin 6) (Fin 6) R) (i j : Fin 6) : R :=
  ∑ k, triangleSign C i j k

/-- Pair-triangle summation is an entry of the square, multiplied by the edge
joining the fixed pair. -/
theorem pairTriangleSum_eq_mul_mulApply {R : Type*} [CommRing R]
    (C : Matrix (Fin 6) (Fin 6) R) (hsymm : C.transpose = C)
    (i j : Fin 6) :
    pairTriangleSum C i j = C i j * (C * C) i j := by
  have hki : ∀ k, C k i = C i k := by
    intro k
    simpa [Matrix.transpose_apply] using
      (congrArg (fun M => M k i) hsymm).symm
  have hjk : ∀ k, C j k = C k j := by
    intro k
    simpa [Matrix.transpose_apply] using
      (congrArg (fun M => M j k) hsymm).symm
  calc
    pairTriangleSum C i j = C i j * ∑ k, C i k * C k j := by
      simp only [pairTriangleSum, triangleSign, Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro k _
      rw [hki k, hjk k]
      ring
    _ = C i j * (C * C) i j := by rw [Matrix.mul_apply]

/-- The off-diagonal conference equation is exactly pair balance for the
triangle tensor. -/
theorem pairTriangleSum_eq_zero {R : Type*} [CommRing R]
    (C : Matrix (Fin 6) (Fin 6) R) (a : R)
    (hsymm : C.transpose = C)
    (hsq : C * C = a • (1 : Matrix (Fin 6) (Fin 6) R))
    (i j : Fin 6) (hij : i ≠ j) :
    pairTriangleSum C i j = 0 := by
  calc
    pairTriangleSum C i j = C i j * (C * C) i j :=
      pairTriangleSum_eq_mul_mulApply C hsymm i j
    _ = C i j * (a • (1 : Matrix (Fin 6) (Fin 6) R)) i j := by rw [hsq]
    _ = 0 := by simp [hij]

/-- Conversely, pair balance together with the signed symmetric matrix axioms
forces the conference square. -/
theorem sq_eq_five_of_pairTriangleSum_eq_zero {R : Type*} [CommRing R]
    (C : Matrix (Fin 6) (Fin 6) R)
    (hsymm : C.transpose = C)
    (hdiag : ∀ i, C i i = 0)
    (hedge : ∀ i j, i ≠ j → C i j * C i j = 1)
    (hbalance : ∀ i j, i ≠ j → pairTriangleSum C i j = 0) :
    C * C = (5 : R) • (1 : Matrix (Fin 6) (Fin 6) R) := by
  have hsymm_apply : ∀ i j, C i j = C j i := by
    intro i j
    simpa [Matrix.transpose_apply] using
      congrArg (fun M => M j i) hsymm
  ext i j
  by_cases hij : i = j
  · subst j
    fin_cases i <;>
      simp [Matrix.mul_apply, Fin.sum_univ_succ, hdiag, hsymm_apply, hedge] <;>
      norm_num
  · have hpair := pairTriangleSum_eq_mul_mulApply C hsymm i j
    calc
      (C * C) i j = (C i j * C i j) * (C * C) i j := by
        rw [hedge i j hij, one_mul]
      _ = C i j * (C i j * (C * C) i j) := by ring
      _ = C i j * pairTriangleSum C i j := by rw [hpair]
      _ = 0 := by rw [hbalance i j hij, mul_zero]
      _ = ((5 : R) • (1 : Matrix (Fin 6) (Fin 6) R)) i j := by simp [hij]

/-- Pair balance for the golden triangle tensor after arbitrary commutative
base change. -/
theorem conference_pairTriangleSum_eq_zero (R : Type*) [CommRing R]
    (i j : Fin 6) (hij : i ≠ j) :
    pairTriangleSum (conferenceMatrixOver R) i j = 0 := by
  apply pairTriangleSum_eq_zero (C := conferenceMatrixOver R) (a := 5)
  · ext a b
    apply congrArg (fun z : ℤ => (z : R))
    simpa [Matrix.transpose_apply] using
      congrArg (fun M => M a b) conferenceMatrix_transpose
  · exact conferenceMatrixOver_sq R
  · exact hij

/-- Switching by signs whose squares are one leaves every triangle product
unchanged. -/
theorem triangleSign_switch {R : Type*} [CommRing R] (d : Fin 6 → R)
    (hd : ∀ i, d i * d i = 1) (C : Matrix (Fin 6) (Fin 6) R)
    (i j k : Fin 6) :
    triangleSign (switchMatrix d C) i j k = triangleSign C i j k := by
  calc
    triangleSign (switchMatrix d C) i j k =
        (d i * d i) * (d j * d j) * (d k * d k) * triangleSign C i j k := by
          simp only [triangleSign, switchMatrix]
          ring
    _ = triangleSign C i j k := by simp [hd]

/-- Diagonal sign switching leaves the oriented triangle cubic unchanged. -/
theorem triangleCubic_switch {R : Type*} [CommRing R] (d : Fin 6 → R)
    (hd : ∀ i, d i * d i = 1) (C : Matrix (Fin 6) (Fin 6) R)
    (x : Fin 6 → R) :
    triangleCubic (switchMatrix d C) x = triangleCubic C x := by
  simp only [triangleCubic, cubicTerm, triangleSign_switch d hd C]

/-- Reversing the conference matrix reverses the oriented cubic. -/
theorem triangleCubic_neg {R : Type*} [CommRing R]
    (C : Matrix (Fin 6) (Fin 6) R) (x : Fin 6 → R) :
    triangleCubic (-C) x = -triangleCubic C x := by
  simp only [triangleCubic, cubicTerm, triangleSign, Matrix.neg_apply]
  ring

/-- The golden triangle cubic is invariant under translation by the all-ones
vector, so it descends to the augmentation quotient. -/
theorem conference_triangleCubic_translate (R : Type*) [CommRing R]
    (x : Fin 6 → R) (u : R) :
    triangleCubic (conferenceMatrixOver R) (fun i => x i + u) =
      triangleCubic (conferenceMatrixOver R) x := by
  rcases conference_triangleSigns with
    ⟨h012z, h013z, h014z, h015z, h023z, h024z, h025z, h034z, h035z, h045z,
      h123z, h124z, h125z, h134z, h135z, h145z, h234z, h235z, h245z, h345z⟩
  have h012 : triangleSign (conferenceMatrixOver R) 0 1 2 = -1 := by
    simpa using cast_conference_triangleSign R 0 1 2 (-1) h012z
  have h013 : triangleSign (conferenceMatrixOver R) 0 1 3 = -1 := by
    simpa using cast_conference_triangleSign R 0 1 3 (-1) h013z
  have h014 : triangleSign (conferenceMatrixOver R) 0 1 4 = 1 := by
    simpa using cast_conference_triangleSign R 0 1 4 1 h014z
  have h015 : triangleSign (conferenceMatrixOver R) 0 1 5 = 1 := by
    simpa using cast_conference_triangleSign R 0 1 5 1 h015z
  have h023 : triangleSign (conferenceMatrixOver R) 0 2 3 = 1 := by
    simpa using cast_conference_triangleSign R 0 2 3 1 h023z
  have h024 : triangleSign (conferenceMatrixOver R) 0 2 4 = -1 := by
    simpa using cast_conference_triangleSign R 0 2 4 (-1) h024z
  have h025 : triangleSign (conferenceMatrixOver R) 0 2 5 = 1 := by
    simpa using cast_conference_triangleSign R 0 2 5 1 h025z
  have h034 : triangleSign (conferenceMatrixOver R) 0 3 4 = 1 := by
    simpa using cast_conference_triangleSign R 0 3 4 1 h034z
  have h035 : triangleSign (conferenceMatrixOver R) 0 3 5 = -1 := by
    simpa using cast_conference_triangleSign R 0 3 5 (-1) h035z
  have h045 : triangleSign (conferenceMatrixOver R) 0 4 5 = -1 := by
    simpa using cast_conference_triangleSign R 0 4 5 (-1) h045z
  have h123 : triangleSign (conferenceMatrixOver R) 1 2 3 = 1 := by
    simpa using cast_conference_triangleSign R 1 2 3 1 h123z
  have h124 : triangleSign (conferenceMatrixOver R) 1 2 4 = 1 := by
    simpa using cast_conference_triangleSign R 1 2 4 1 h124z
  have h125 : triangleSign (conferenceMatrixOver R) 1 2 5 = -1 := by
    simpa using cast_conference_triangleSign R 1 2 5 (-1) h125z
  have h134 : triangleSign (conferenceMatrixOver R) 1 3 4 = -1 := by
    simpa using cast_conference_triangleSign R 1 3 4 (-1) h134z
  have h135 : triangleSign (conferenceMatrixOver R) 1 3 5 = 1 := by
    simpa using cast_conference_triangleSign R 1 3 5 1 h135z
  have h145 : triangleSign (conferenceMatrixOver R) 1 4 5 = -1 := by
    simpa using cast_conference_triangleSign R 1 4 5 (-1) h145z
  have h234 : triangleSign (conferenceMatrixOver R) 2 3 4 = -1 := by
    simpa using cast_conference_triangleSign R 2 3 4 (-1) h234z
  have h235 : triangleSign (conferenceMatrixOver R) 2 3 5 = -1 := by
    simpa using cast_conference_triangleSign R 2 3 5 (-1) h235z
  have h245 : triangleSign (conferenceMatrixOver R) 2 4 5 = 1 := by
    simpa using cast_conference_triangleSign R 2 4 5 1 h245z
  have h345 : triangleSign (conferenceMatrixOver R) 3 4 5 = 1 := by
    simpa using cast_conference_triangleSign R 3 4 5 1 h345z
  simp only [triangleCubic, cubicTerm, h012, h013, h014, h015, h023, h024,
    h025, h034, h035, h045, h123, h124, h125, h134, h135, h145, h234,
    h235, h245, h345]
  ring

/-- For a symmetric signed matrix, the product of the four triangle signs on
four distinct labels is one. -/
theorem triangleSign_four_point {R : Type*} [CommRing R]
    (C : Matrix (Fin 6) (Fin 6) R)
    (hsymm : C.transpose = C)
    (hsq : ∀ i j, i ≠ j → C i j * C i j = 1)
    (i j k l : Fin 6)
    (hij : i ≠ j) (hik : i ≠ k) (hil : i ≠ l)
    (hjk : j ≠ k) (hjl : j ≠ l) (hkl : k ≠ l) :
    triangleSign C i j k * triangleSign C i j l *
      triangleSign C i k l * triangleSign C j k l = 1 := by
  have hji : C j i = C i j := by
    simpa [Matrix.transpose_apply] using (congrArg (fun M => M j i) hsymm).symm
  have hki : C k i = C i k := by
    simpa [Matrix.transpose_apply] using (congrArg (fun M => M k i) hsymm).symm
  have hli : C l i = C i l := by
    simpa [Matrix.transpose_apply] using (congrArg (fun M => M l i) hsymm).symm
  have hkj : C k j = C j k := by
    simpa [Matrix.transpose_apply] using (congrArg (fun M => M k j) hsymm).symm
  have hlj : C l j = C j l := by
    simpa [Matrix.transpose_apply] using (congrArg (fun M => M l j) hsymm).symm
  have hlk : C l k = C k l := by
    simpa [Matrix.transpose_apply] using (congrArg (fun M => M l k) hsymm).symm
  rw [show triangleSign C i j k = C i j * C j k * C i k by simp [triangleSign, hki],
      show triangleSign C i j l = C i j * C j l * C i l by simp [triangleSign, hli],
      show triangleSign C i k l = C i k * C k l * C i l by simp [triangleSign, hli],
      show triangleSign C j k l = C j k * C k l * C j l by simp [triangleSign, hlj]]
  calc
    _ = (C i j * C i j) * (C i k * C i k) * (C i l * C i l) *
        (C j k * C j k) * (C j l * C j l) * (C k l * C k l) := by ring
    _ = 1 := by simp [hsq i j hij, hsq i k hik, hsq i l hil,
      hsq j k hjk, hsq j l hjl, hsq k l hkl]

end ClebschGoldenConference
end RelativeConicArcs
