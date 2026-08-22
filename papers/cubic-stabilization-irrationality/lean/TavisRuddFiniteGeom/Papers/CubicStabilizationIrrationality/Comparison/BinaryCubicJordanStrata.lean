import Mathlib

/-!
# Jordan strata of a binary cubic Frobenius algebra

Let a graded Frobenius algebra have dimensions `(1, 2, 2, 1)`, with divisor
basis `u, v`, dual degree-four basis `uDual, vDual`, and top class `point`.
Write its polarized top-degree structure constants as

`a = integral(u^3)`, `b = integral(u^2*v)`,
`c = integral(u*v^2)`, and `d = integral(v^3)`.

When three is invertible, the corresponding binary cubic polynomial is

`F(u,v) = a*u^3 + 3*b*u^2*v + 3*c*u*v^2 + d*v^3`,

and multiplication by `u` depends only on `a`, `b`, and `c`.  This file gives
explicit invertible chain bases for its five possible nilpotent Jordan types.
The certificates are uniform over an arbitrary field and are checked by
matrix multiplication; no external classification or computation is used.

The parameter `d` does not occur because it affects multiplication by `v`,
not multiplication by the chosen divisor `u`.  The results classify this one
operator only.  They do not identify a geometric Kummer divisor with `u`,
relate `u` to an Euler class, or construct a degeneration of Frobenius
algebras.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.BinaryCubicJordanStrata

/-- Indices for the ordered basis `(1, u, v, uDual, vDual, point)`. -/
abbrev CubicIndex := Fin 6

variable {K : Type*} [Field K]

/-- Multiplication by the first divisor in the ordered basis
`(1, u, v, uDual, vDual, point)`. -/
def divisorMultiplication (a b c : K) : Matrix CubicIndex CubicIndex K :=
  !![0, 0, 0, 0, 0, 0;
     1, 0, 0, 0, 0, 0;
     0, 0, 0, 0, 0, 0;
     0, a, b, 0, 0, 0;
     0, b, c, 0, 0, 0;
     0, 0, 0, 1, 0, 0]

/-- The bilinear form on the divisor space obtained by multiplying with
`alpha*u + beta*v` and pairing with the top class. -/
def divisorPairingMatrix (a b c d alpha beta : K) : Matrix (Fin 2) (Fin 2) K :=
  !![alpha * a + beta * b, alpha * b + beta * c;
     alpha * b + beta * c, alpha * c + beta * d]

/-- In the fully degenerate row `a=b=c=0`, every divisor pairing is singular.
Consequently this row cannot contain a hard-Lefschetz divisor. -/
theorem fullyDegenerate_divisorPairing_det_zero (d alpha beta : K) :
    (divisorPairingMatrix 0 0 0 d alpha beta).det = 0 := by
  simp [divisorPairingMatrix, Matrix.det_fin_two]

/-- A matrix certificate that `operator` has the displayed Jordan matrix.
Both inverse identities are included so no determinant criterion is trusted. -/
structure JordanCertificate
    (operator jordan : Matrix CubicIndex CubicIndex K) where
  basisChange : Matrix CubicIndex CubicIndex K
  inverseChange : Matrix CubicIndex CubicIndex K
  inverse_mul : inverseChange * basisChange = 1
  mul_inverse : basisChange * inverseChange = 1
  intertwines : operator * basisChange = basisChange * jordan

/-- The nilpotent Jordan matrix `J4 direct-sum J2`. -/
def jordanFourTwo : Matrix CubicIndex CubicIndex K :=
  !![0, 1, 0, 0, 0, 0;
     0, 0, 1, 0, 0, 0;
     0, 0, 0, 1, 0, 0;
     0, 0, 0, 0, 0, 0;
     0, 0, 0, 0, 0, 1;
     0, 0, 0, 0, 0, 0]

/-- The nilpotent Jordan matrix `J4 direct-sum J1 direct-sum J1`. -/
def jordanFourOneOne : Matrix CubicIndex CubicIndex K :=
  !![0, 1, 0, 0, 0, 0;
     0, 0, 1, 0, 0, 0;
     0, 0, 0, 1, 0, 0;
     0, 0, 0, 0, 0, 0;
     0, 0, 0, 0, 0, 0;
     0, 0, 0, 0, 0, 0]

/-- The nilpotent Jordan matrix `J3 direct-sum J3`. -/
def jordanThreeThree : Matrix CubicIndex CubicIndex K :=
  !![0, 1, 0, 0, 0, 0;
     0, 0, 1, 0, 0, 0;
     0, 0, 0, 0, 0, 0;
     0, 0, 0, 0, 1, 0;
     0, 0, 0, 0, 0, 1;
     0, 0, 0, 0, 0, 0]

/-- The nilpotent Jordan matrix with three blocks of size two. -/
def jordanTwoTwoTwo : Matrix CubicIndex CubicIndex K :=
  !![0, 1, 0, 0, 0, 0;
     0, 0, 0, 0, 0, 0;
     0, 0, 0, 1, 0, 0;
     0, 0, 0, 0, 0, 0;
     0, 0, 0, 0, 0, 1;
     0, 0, 0, 0, 0, 0]

/-- The nilpotent Jordan matrix with two blocks of size two and two fixed
one-dimensional blocks. -/
def jordanTwoTwoOneOne : Matrix CubicIndex CubicIndex K :=
  !![0, 1, 0, 0, 0, 0;
     0, 0, 0, 0, 0, 0;
     0, 0, 0, 1, 0, 0;
     0, 0, 0, 0, 0, 0;
     0, 0, 0, 0, 0, 0;
     0, 0, 0, 0, 0, 0]

section FourTwo

private def fourTwoBasis (a b c : K) : Matrix CubicIndex CubicIndex K :=
  let delta := a * c - b ^ 2
  !![0, 0, 0, 1, 0, 0;
     0, 0, 1, 0, 0, -b;
     0, 0, 0, 0, 0, a;
     0, a, 0, 0, 0, 0;
     0, b, 0, 0, delta, 0;
     a, 0, 0, 0, 0, 0]

private def fourTwoInverse (a b c : K) : Matrix CubicIndex CubicIndex K :=
  let delta := a * c - b ^ 2
  !![0, 0, 0, 0, 0, 1 / a;
     0, 0, 0, 1 / a, 0, 0;
     0, 1, b / a, 0, 0, 0;
     1, 0, 0, 0, 0, 0;
     0, 0, 0, -b / (a * delta), 1 / delta, 0;
     0, 0, 1 / a, 0, 0, 0]

/-- If `a` and the determinant `a*c-b^2` are nonzero, multiplication by
`u` has Jordan type `J4 direct-sum J2`. -/
def fourTwoCertificate (a b c : K) (ha : a ≠ 0)
    (hdelta : a * c - b ^ 2 ≠ 0) :
    JordanCertificate (divisorMultiplication a b c) jordanFourTwo := by
  refine ⟨fourTwoBasis a b c, fourTwoInverse a b c, ?_, ?_, ?_⟩
  all_goals
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp [fourTwoBasis, fourTwoInverse, divisorMultiplication, jordanFourTwo,
        Matrix.mul_apply, Fin.sum_univ_succ] <;>
      field_simp [ha, hdelta] <;> ring

end FourTwo

section FourOneOne

private def fourOneOneBasis (a b : K) : Matrix CubicIndex CubicIndex K :=
  !![0, 0, 0, 1, 0, 0;
     0, 0, 1, 0, 0, -b;
     0, 0, 0, 0, 0, a;
     0, a, 0, 0, 0, 0;
     0, b, 0, 0, 1, 0;
     a, 0, 0, 0, 0, 0]

private def fourOneOneInverse (a b : K) : Matrix CubicIndex CubicIndex K :=
  !![0, 0, 0, 0, 0, 1 / a;
     0, 0, 0, 1 / a, 0, 0;
     0, 1, b / a, 0, 0, 0;
     1, 0, 0, 0, 0, 0;
     0, 0, 0, -b / a, 1, 0;
     0, 0, 1 / a, 0, 0, 0]

/-- If `a` is nonzero and `a*c-b^2` vanishes, multiplication by `u` has
Jordan type `J4 direct-sum J1 direct-sum J1`. -/
def fourOneOneCertificate (a b c : K) (ha : a ≠ 0)
    (hdelta : a * c - b ^ 2 = 0) :
    JordanCertificate (divisorMultiplication a b c) jordanFourOneOne := by
  refine ⟨fourOneOneBasis a b, fourOneOneInverse a b, ?_, ?_, ?_⟩
  all_goals
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp [fourOneOneBasis, fourOneOneInverse, divisorMultiplication,
        jordanFourOneOne, Matrix.mul_apply, Fin.sum_univ_succ] <;>
      field_simp [ha] <;> ring_nf
  all_goals simpa [sub_eq_add_neg, add_comm, mul_comm] using hdelta

end FourOneOne

section ThreeThree

private def threeThreeBasis (b c : K) : Matrix CubicIndex CubicIndex K :=
  !![0, 0, 1, 0, 0, 0;
     0, 1, 0, 0, 0, 0;
     0, 0, 0, 0, 0, 1;
     0, 0, 0, 0, b, 0;
     b, 0, 0, 0, c, 0;
     0, 0, 0, b, 0, 0]

private def threeThreeInverse (b c : K) : Matrix CubicIndex CubicIndex K :=
  !![0, 0, 0, -c / (b * b), 1 / b, 0;
     0, 1, 0, 0, 0, 0;
     1, 0, 0, 0, 0, 0;
     0, 0, 0, 0, 0, 1 / b;
     0, 0, 0, 1 / b, 0, 0;
     0, 0, 1, 0, 0, 0]

/-- If `a=0` and `b` is nonzero, multiplication by `u` has Jordan type
`J3 direct-sum J3`. -/
def threeThreeCertificate (b c : K) (hb : b ≠ 0) :
    JordanCertificate (divisorMultiplication 0 b c) jordanThreeThree := by
  refine ⟨threeThreeBasis b c, threeThreeInverse b c, ?_, ?_, ?_⟩
  all_goals
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp [threeThreeBasis, threeThreeInverse, divisorMultiplication,
        jordanThreeThree, Matrix.mul_apply, Fin.sum_univ_succ] <;>
      field_simp [hb] <;> ring

end ThreeThree

section TwoTwoTwo

private def twoTwoTwoBasis (c : K) : Matrix CubicIndex CubicIndex K :=
  !![0, 1, 0, 0, 0, 0;
     1, 0, 0, 0, 0, 0;
     0, 0, 0, 1, 0, 0;
     0, 0, 0, 0, 0, 1;
     0, 0, c, 0, 0, 0;
     0, 0, 0, 0, 1, 0]

private def twoTwoTwoInverse (c : K) : Matrix CubicIndex CubicIndex K :=
  !![0, 1, 0, 0, 0, 0;
     1, 0, 0, 0, 0, 0;
     0, 0, 0, 0, 1 / c, 0;
     0, 0, 1, 0, 0, 0;
     0, 0, 0, 0, 0, 1;
     0, 0, 0, 1, 0, 0]

/-- If `a=b=0` and `c` is nonzero, multiplication by `u` has three
nilpotent Jordan blocks of size two. -/
def twoTwoTwoCertificate (c : K) (hc : c ≠ 0) :
    JordanCertificate (divisorMultiplication 0 0 c) jordanTwoTwoTwo := by
  refine ⟨twoTwoTwoBasis c, twoTwoTwoInverse c, ?_, ?_, ?_⟩
  all_goals
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp [twoTwoTwoBasis, twoTwoTwoInverse, divisorMultiplication,
        jordanTwoTwoTwo, Matrix.mul_apply, Fin.sum_univ_succ] <;>
      field_simp [hc]

end TwoTwoTwo

section TwoTwoOneOne

private def twoTwoOneOneBasis : Matrix CubicIndex CubicIndex K :=
  !![0, 1, 0, 0, 0, 0;
     1, 0, 0, 0, 0, 0;
     0, 0, 0, 0, 1, 0;
     0, 0, 0, 1, 0, 0;
     0, 0, 0, 0, 0, 1;
     0, 0, 1, 0, 0, 0]

private def twoTwoOneOneInverse : Matrix CubicIndex CubicIndex K :=
  !![0, 1, 0, 0, 0, 0;
     1, 0, 0, 0, 0, 0;
     0, 0, 0, 0, 0, 1;
     0, 0, 0, 1, 0, 0;
     0, 0, 1, 0, 0, 0;
     0, 0, 0, 0, 1, 0]

/-- If `a=b=c=0`, multiplication by `u` has two Jordan blocks of size two
and two one-dimensional zero blocks. -/
def twoTwoOneOneCertificate :
    JordanCertificate (divisorMultiplication (0 : K) 0 0) jordanTwoTwoOneOne := by
  refine ⟨twoTwoOneOneBasis, twoTwoOneOneInverse, ?_, ?_, ?_⟩
  all_goals
    ext i j
    fin_cases i <;> fin_cases j <;>
      norm_num [twoTwoOneOneBasis, twoTwoOneOneInverse, divisorMultiplication,
        jordanTwoTwoOneOne, Matrix.mul_apply, Fin.sum_univ_succ]

end TwoTwoOneOne

end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.BinaryCubicJordanStrata
