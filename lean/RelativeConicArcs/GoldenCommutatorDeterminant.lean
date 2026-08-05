import RelativeConicArcs.ClebschOperatorShadows
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic
import Mathlib.Tactic.Ring

/-!
# The determinant of an order-six skew-symmetric matrix as a Pfaffian square

For a matrix `A` of size six over a commutative ring whose transpose is `-A`
and whose diagonal vanishes, the determinant equals the square of the
first-row Pfaffian expansion `pfaffianSix` fixed in
`RelativeConicArcs.GoldenCommutatorPfaffian`.  Both sides are polynomials in
the fifteen strictly-upper-triangular entries, so the identity is proved by
writing an arbitrary such matrix in terms of those fifteen entries and
comparing the expanded determinant with the expanded Pfaffian square.  No
characteristic assumption and no invertibility assumption is used: the
diagonal is required to vanish rather than deduced from skewness, which would
need `2` to be a nonzerodivisor.

Specializing to the bracket matrix `(xᵢ-xⱼ)Cᵢⱼ` of the fixed order-six
integral conference matrix turns the Pfaffian identity of
`RelativeConicArcs.ClebschOperatorShadows` into the determinant identity
`det = 16 · Z²`, where `Z` is the triangle-holonomy cubic of that conference
matrix.  This is the determinantal shadow of the same cubic whose Pfaffian
shadow that module records.
-/

namespace RelativeConicArcs.GoldenCommutatorDeterminant

open RelativeConicArcs.ClebschGoldenConference
open RelativeConicArcs.GoldenCommutatorPfaffian
open RelativeConicArcs.GoldenMatchingCubics

/-- The order-six skew-symmetric matrix with vanishing diagonal whose
strictly-upper-triangular entries are the fifteen given ring elements, listed
in row-major order. -/
def skewOfUpperEntries {R : Type*} [CommRing R]
    (a01 a02 a03 a04 a05 a12 a13 a14 a15 a23 a24 a25 a34 a35 a45 : R) :
    Matrix (Fin 6) (Fin 6) R :=
  !![    0,   a01,   a02,   a03,   a04, a05;
      -a01,     0,   a12,   a13,   a14, a15;
      -a02,  -a12,     0,   a23,   a24, a25;
      -a03,  -a13,  -a23,     0,   a34, a35;
      -a04,  -a14,  -a24,  -a34,     0, a45;
      -a05,  -a15,  -a25,  -a35,  -a45,   0]

/-- The determinant of the skew-symmetric matrix on fifteen free entries is
the square of its first-row Pfaffian expansion. -/
theorem det_skewOfUpperEntries_eq_pfaffianSix_sq {R : Type*} [CommRing R]
    (a01 a02 a03 a04 a05 a12 a13 a14 a15 a23 a24 a25 a34 a35 a45 : R) :
    Matrix.det (skewOfUpperEntries a01 a02 a03 a04 a05 a12 a13 a14 a15 a23
        a24 a25 a34 a35 a45) =
      pfaffianSix (skewOfUpperEntries a01 a02 a03 a04 a05 a12 a13 a14 a15 a23
        a24 a25 a34 a35 a45) ^ 2 := by
  rw [Matrix.det_succ_row_zero]
  simp [skewOfUpperEntries, pfaffianSix, Matrix.det_succ_row_zero,
    Fin.sum_univ_succ, Fin.succAbove]
  ring

/-- Every order-six matrix with vanishing diagonal whose transpose is its
negative is the matrix determined by its fifteen strictly-upper-triangular
entries. -/
theorem eq_skewOfUpperEntries {R : Type*} [CommRing R]
    (A : Matrix (Fin 6) (Fin 6) R)
    (hskew : ∀ i j, A j i = -A i j) (hdiag : ∀ i, A i i = 0) :
    A = skewOfUpperEntries (A 0 1) (A 0 2) (A 0 3) (A 0 4) (A 0 5) (A 1 2)
      (A 1 3) (A 1 4) (A 1 5) (A 2 3) (A 2 4) (A 2 5) (A 3 4) (A 3 5)
      (A 4 5) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp only [skewOfUpperEntries, Matrix.of_apply, Matrix.cons_val',
      Matrix.empty_val', Matrix.cons_val_fin_one, Fin.isValue] <;>
    first
      | rfl
      | exact hdiag _
      | exact hskew _ _

/-- The determinant of an order-six skew-symmetric matrix with vanishing
diagonal is the square of its Pfaffian, in the first-row sign convention of
`pfaffianSix`. -/
theorem det_eq_pfaffianSix_sq {R : Type*} [CommRing R]
    (A : Matrix (Fin 6) (Fin 6) R)
    (hskew : ∀ i j, A j i = -A i j) (hdiag : ∀ i, A i i = 0) :
    Matrix.det A = pfaffianSix A ^ 2 := by
  rw [eq_skewOfUpperEntries A hskew hdiag]
  exact det_skewOfUpperEntries_eq_pfaffianSix_sq _ _ _ _ _ _ _ _ _ _ _ _ _ _ _

/-- The bracket matrix of a symmetric coefficient matrix is skew-symmetric
entrywise. -/
theorem bracketMatrix_skew {R : Type*} [CommRing R]
    (C : Matrix (Fin 6) (Fin 6) R) (x : Fin 6 → R)
    (hC : C.transpose = C) (i j : Fin 6) :
    bracketMatrix C x j i = -bracketMatrix C x i j := by
  have hij : C j i = C i j := congrFun (congrFun hC i) j
  simp [bracketMatrix, bracket, hij]
  ring

/-- The bracket matrix has vanishing diagonal, since the bracket of a
coordinate with itself is zero. -/
theorem bracketMatrix_diag {R : Type*} [CommRing R]
    (C : Matrix (Fin 6) (Fin 6) R) (x : Fin 6 → R) (i : Fin 6) :
    bracketMatrix C x i i = 0 := by
  simp [bracketMatrix, bracket]

/-- The fixed order-six integral conference matrix is symmetric. -/
theorem conferenceMatrixOver_transpose (R : Type*) [CommRing R] :
    (conferenceMatrixOver R).transpose = conferenceMatrixOver R := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [conferenceMatrixOver, conferenceMatrix]

/-- The determinant of the commutator bracket matrix of the fixed conference
matrix is sixteen times the square of its triangle-holonomy cubic.  This is
the determinantal companion of the Pfaffian identity
`RelativeConicArcs.ClebschOperatorShadows.pfaffianSix_conferenceBracket_eq_four_triangleCubic`. -/
theorem det_conferenceBracket_eq_sixteen_triangleCubic_sq
    {R : Type*} [CommRing R] (x : Fin 6 → R) :
    Matrix.det (bracketMatrix (conferenceMatrixOver R) x) =
      16 * triangleCubic (conferenceMatrixOver R) x ^ 2 := by
  rw [det_eq_pfaffianSix_sq _
      (bracketMatrix_skew _ x (conferenceMatrixOver_transpose R))
      (bracketMatrix_diag _ x),
    ClebschOperatorShadows.pfaffianSix_conferenceBracket_eq_four_triangleCubic]
  ring

end RelativeConicArcs.GoldenCommutatorDeterminant
