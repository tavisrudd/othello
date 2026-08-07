import RelativeConicArcs.GoldenCommutatorDeterminant
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.Module
import Mathlib.Tactic.Ring

/-!
# The cross-golden block of the fixed conference matrix

Let `R` be a commutative ring in which two is invertible and which carries an
invertible element `s` with `s * s = 5`, and let `C` be the fixed order-six
integral conference matrix, base changed to `R`.  The two golden projectors are
`P± = (1 ± s⁻¹ C)/2`; they are symmetric, sum to the identity, and are
idempotent because `C * C = 5 • 1`.  For a vector `x` of coordinates write `Dₓ`
for the diagonal matrix it defines and

  `B(x) = P₋ Dₓ P₊`

for the cross-golden block, the compression of `Dₓ` from the spectral space on
which `C` acts by `s` to the spectral space on which it acts by `-s`.

The commutator `Dₓ C - C Dₓ` equals `2 s (B(x) - B(x)ᵀ)`.  That identity uses
only the symmetry of `C`; the two triple products in which the conference
matrix occurs twice cancel, and what survives is twice the commutator.  Since
the commutator is an order-six matrix, taking determinants multiplies the
right-hand side by `(2 s)⁶ = 8000`, while the determinant of the commutator is
sixteen times the square of the triangle-holonomy cubic `Z` of `C`.  Cancelling
the invertible factor sixteen gives

  `Z(x)² = 500 · det (B(x) - B(x)ᵀ)`.

The matrix `B(x) - B(x)ᵀ` is skew-symmetric with vanishing diagonal, so its
determinant is the square of its Pfaffian and the identity above becomes
`Z(x)² = (10 s · Pf (B(x) - B(x)ᵀ))²`.  Over an integral domain that gives
`Z(x) = ± 10 s · Pf (B(x) - B(x)ᵀ)`.  The sign is not determined by these
hypotheses: replacing `s` by `-s` exchanges the two projectors and negates the
Pfaffian, so the sign records an orientation of the two spectral spaces rather
than a property of `C`.

No statement here chooses bases for the two spectral spaces.  The Pfaffian of
`B(x) - B(x)ᵀ` is the basis-free stand-in for the determinant of the induced
map between them; the comparison with the determinant of a three-by-three
matrix representing that map in a chosen pair of orthonormal frames is not
formalized.
-/

namespace RelativeConicArcs.CrossGoldenDeterminant

open RelativeConicArcs.ClebschGoldenConference
open RelativeConicArcs.GoldenCommutatorPfaffian
open RelativeConicArcs.GoldenCommutatorDeterminant

variable {R : Type*} [CommRing R]

/-- The bracket matrix of a coefficient matrix is the commutator of that matrix
with the diagonal matrix of the coordinates. -/
theorem bracketMatrix_eq_commutator (C : Matrix (Fin 6) (Fin 6) R) (x : Fin 6 → R) :
    bracketMatrix C x = Matrix.diagonal x * C - C * Matrix.diagonal x := by
  ext i j
  simp only [bracketMatrix, GoldenMatchingCubics.bracket, Matrix.sub_apply,
    Matrix.diagonal_mul, Matrix.mul_diagonal]
  ring

/-- The antisymmetric combination of the two compressions of a matrix `D`
through the complementary combinations `c (1 ∓ A)`.  The two triple products in
which `A` occurs twice cancel, so only twice the commutator of `D` with `A`
survives.  Nothing is assumed about `A` and `D`. -/
private theorem compression_sub_transpose {n : Type*} [Fintype n] [DecidableEq n]
    (c : R) (A D : Matrix n n R) :
    (c • ((1 : Matrix n n R) - A)) * D * (c • ((1 : Matrix n n R) + A)) -
        (c • ((1 : Matrix n n R) + A)) * D * (c • ((1 : Matrix n n R) - A)) =
      (2 * c * c) • (D * A - A * D) := by
  simp only [Matrix.smul_mul, Matrix.mul_smul, Matrix.sub_mul, Matrix.mul_sub,
    Matrix.add_mul, Matrix.mul_add, Matrix.one_mul, Matrix.mul_one]
  module

variable [Invertible (2 : R)] (s : R) [Invertible s]

/-- The golden projector attached to a sign `ε` and a square root `s` of five:
the matrix `(1 + ε s⁻¹ C)/2` built from the fixed conference matrix. -/
def goldenProjector (ε : R) : Matrix (Fin 6) (Fin 6) R :=
  ⅟(2 : R) • ((1 : Matrix (Fin 6) (Fin 6) R) + (ε * ⅟s) • conferenceMatrixOver R)

/-- Both golden projectors are symmetric. -/
theorem goldenProjector_transpose (ε : R) :
    (goldenProjector s ε).transpose = goldenProjector s ε := by
  simp only [goldenProjector, Matrix.transpose_smul, Matrix.transpose_add,
    Matrix.transpose_one, conferenceMatrixOver_transpose]

/-- The two golden projectors sum to the identity. -/
theorem goldenProjector_add_neg :
    goldenProjector s 1 + goldenProjector s (-1) = 1 := by
  have h : goldenProjector s 1 + goldenProjector s (-1) =
      (⅟(2 : R) * 2) • (1 : Matrix (Fin 6) (Fin 6) R) := by
    simp only [goldenProjector]
    module
  rw [h, invOf_mul_self, one_smul]

/-- Each golden projector is idempotent, because the conference matrix squares
to `5 • 1` and `s` is a square root of five. -/
theorem goldenProjector_mul_self (hs : s * s = 5) (ε : R) (hε : ε * ε = 1) :
    goldenProjector s ε * goldenProjector s ε = goldenProjector s ε := by
  set A : Matrix (Fin 6) (Fin 6) R := (ε * ⅟s) • conferenceMatrixOver R with hA
  have hinv : ε * ⅟s * ε * ⅟s * 5 = 1 := by
    have h5 : (5 : R) = s * s := hs.symm
    calc ε * ⅟s * ε * ⅟s * 5 = (ε * ε) * ((⅟s * s) * (⅟s * s)) := by
          rw [h5]; ring
      _ = 1 := by rw [invOf_mul_self, hε]; ring
  have hAA : A * A = 1 := by
    rw [hA, Matrix.smul_mul, Matrix.mul_smul, smul_smul, conferenceMatrixOver_sq,
      smul_smul, ← mul_assoc, hinv, one_smul]
  have hexp : goldenProjector s ε * goldenProjector s ε =
      (2 * ⅟(2 : R) * ⅟(2 : R)) • ((1 : Matrix (Fin 6) (Fin 6) R) + A) := by
    simp only [goldenProjector, ← hA, Matrix.smul_mul, Matrix.mul_smul,
      Matrix.add_mul, Matrix.mul_add, Matrix.one_mul, Matrix.mul_one, hAA]
    module
  rw [hexp, show 2 * ⅟(2 : R) * ⅟(2 : R) = ⅟(2 : R) by
    rw [mul_invOf_self, one_mul], goldenProjector, hA]

/-- The cross-golden block at a point: the diagonal matrix of the coordinates,
compressed from the spectral space on which the conference matrix acts by `s`
to the spectral space on which it acts by `-s`. -/
def crossGoldenBlock (x : Fin 6 → R) : Matrix (Fin 6) (Fin 6) R :=
  goldenProjector s (-1) * Matrix.diagonal x * goldenProjector s 1

/-- The transpose of the cross-golden block is the opposite compression. -/
theorem crossGoldenBlock_transpose (x : Fin 6 → R) :
    (crossGoldenBlock s x).transpose =
      goldenProjector s 1 * Matrix.diagonal x * goldenProjector s (-1) := by
  simp only [crossGoldenBlock, Matrix.transpose_mul, goldenProjector_transpose,
    Matrix.diagonal_transpose, Matrix.mul_assoc]

/-- The commutator of the diagonal matrix of the coordinates with the
conference matrix is `2 s` times the antisymmetric part of the cross-golden
block.  This is the block form of the commutator relative to the golden
splitting: the commutator exchanges the two spectral spaces, and the two
exchanges it induces are the cross-golden block and its negative transpose. -/
theorem bracketMatrix_eq_smul_sub_transpose (x : Fin 6 → R) :
    bracketMatrix (conferenceMatrixOver R) x =
      (2 * s) • (crossGoldenBlock s x - (crossGoldenBlock s x).transpose) := by
  have hneg : goldenProjector s (-1) =
      ⅟(2 : R) • ((1 : Matrix (Fin 6) (Fin 6) R) - ⅟s • conferenceMatrixOver R) := by
    simp only [goldenProjector, neg_mul, one_mul, neg_smul, sub_eq_add_neg]
  have hpos : goldenProjector s 1 =
      ⅟(2 : R) • ((1 : Matrix (Fin 6) (Fin 6) R) + ⅟s • conferenceMatrixOver R) := by
    simp only [goldenProjector, one_mul]
  have hcomm : crossGoldenBlock s x - (crossGoldenBlock s x).transpose =
      (2 * ⅟(2 : R) * ⅟(2 : R)) •
        (Matrix.diagonal x * (⅟s • conferenceMatrixOver R) -
          (⅟s • conferenceMatrixOver R) * Matrix.diagonal x) := by
    rw [crossGoldenBlock_transpose, crossGoldenBlock, hneg, hpos]
    exact compression_sub_transpose _ _ _
  rw [hcomm, bracketMatrix_eq_commutator]
  rw [Matrix.mul_smul, Matrix.smul_mul, ← smul_sub, smul_smul, smul_smul]
  rw [show 2 * s * (2 * ⅟(2 : R) * ⅟(2 : R)) * ⅟s = 1 by
    calc 2 * s * (2 * ⅟(2 : R) * ⅟(2 : R)) * ⅟s
        = (2 * ⅟(2 : R)) * (2 * ⅟(2 : R)) * (s * ⅟s) := by ring
      _ = 1 := by rw [mul_invOf_self, mul_invOf_self]; ring]
  rw [one_smul]

/-- The square of the triangle-holonomy cubic of the fixed conference matrix is
five hundred times the determinant of the antisymmetric part of the cross-golden
block. -/
theorem triangleCubic_sq_eq_five_hundred_mul_det (hs : s * s = 5) (x : Fin 6 → R) :
    triangleCubic (conferenceMatrixOver R) x ^ 2 =
      500 * Matrix.det (crossGoldenBlock s x - (crossGoldenBlock s x).transpose) := by
  have hdet : 16 * triangleCubic (conferenceMatrixOver R) x ^ 2 =
      (2 * s) ^ 6 *
        Matrix.det (crossGoldenBlock s x - (crossGoldenBlock s x).transpose) := by
    rw [← det_conferenceBracket_eq_sixteen_triangleCubic_sq,
      bracketMatrix_eq_smul_sub_transpose s x, Matrix.det_smul]
    simp
  have hpow : (2 * s) ^ 6 = 8000 := by
    have h2 : s ^ 2 = 5 := by rw [pow_two, hs]
    calc (2 * s) ^ 6 = 64 * (s ^ 2) ^ 3 := by ring
      _ = 8000 := by rw [h2]; norm_num
  rw [hpow] at hdet
  have h16 : IsUnit (16 : R) := by
    have h : (16 : R) = 2 ^ 4 := by norm_num
    rw [h]
    exact (isUnit_of_invertible (2 : R)).pow 4
  refine h16.mul_left_cancel ?_
  rw [hdet]
  ring

/-- The antisymmetric part of the cross-golden block is skew-symmetric with
vanishing diagonal, so its determinant is the square of its Pfaffian and the
identity above is a comparison of squares: the triangle-holonomy cubic and
`10 s` times that Pfaffian have the same square. -/
theorem triangleCubic_sq_eq_pfaffian_sq (hs : s * s = 5) (x : Fin 6 → R) :
    triangleCubic (conferenceMatrixOver R) x ^ 2 =
      (10 * s *
        pfaffianSix (crossGoldenBlock s x - (crossGoldenBlock s x).transpose)) ^ 2 := by
  set M := crossGoldenBlock s x - (crossGoldenBlock s x).transpose with hM
  have hskew : ∀ i j, M j i = -M i j := by
    intro i j
    simp only [hM, Matrix.sub_apply, Matrix.transpose_apply]
    ring
  have hdiag : ∀ i, M i i = 0 := by
    intro i
    simp only [hM, Matrix.sub_apply, Matrix.transpose_apply]
    ring
  rw [triangleCubic_sq_eq_five_hundred_mul_det s hs x, det_eq_pfaffianSix_sq M hskew hdiag]
  have h5 : (5 : R) = s * s := hs.symm
  calc (500 : R) * pfaffianSix M ^ 2 = 100 * (5 : R) * pfaffianSix M ^ 2 := by norm_num
    _ = (10 * s * pfaffianSix M) ^ 2 := by rw [h5]; ring

/-- Over an integral domain the comparison of squares has the two expected
roots: the triangle-holonomy cubic is `± 10 s` times the Pfaffian of the
antisymmetric part of the cross-golden block.  The sign is a choice of
orientation and is not determined by the hypotheses, since replacing `s` by
`-s` exchanges the two golden projectors and negates the Pfaffian. -/
theorem triangleCubic_eq_or_eq_neg [IsDomain R] (hs : s * s = 5) (x : Fin 6 → R) :
    triangleCubic (conferenceMatrixOver R) x =
        10 * s *
          pfaffianSix (crossGoldenBlock s x - (crossGoldenBlock s x).transpose) ∨
      triangleCubic (conferenceMatrixOver R) x =
        -(10 * s *
          pfaffianSix (crossGoldenBlock s x - (crossGoldenBlock s x).transpose)) := by
  have h := triangleCubic_sq_eq_pfaffian_sq s hs x
  have h0 : (triangleCubic (conferenceMatrixOver R) x -
        10 * s * pfaffianSix (crossGoldenBlock s x - (crossGoldenBlock s x).transpose)) *
      (triangleCubic (conferenceMatrixOver R) x +
        10 * s * pfaffianSix (crossGoldenBlock s x - (crossGoldenBlock s x).transpose)) = 0 := by
    linear_combination h
  rcases mul_eq_zero.mp h0 with h1 | h1
  · exact Or.inl (sub_eq_zero.mp h1)
  · exact Or.inr (eq_neg_of_add_eq_zero_left h1)

end RelativeConicArcs.CrossGoldenDeterminant
