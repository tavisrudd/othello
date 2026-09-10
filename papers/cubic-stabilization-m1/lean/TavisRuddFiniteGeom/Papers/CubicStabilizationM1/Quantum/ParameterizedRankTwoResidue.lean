import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.AtomicRankTwoFlatRigidity
import Mathlib.LinearAlgebra.Matrix.Charpoly.Basic
import Mathlib.Algebra.CharZero.Infinite

/-!
# A parameterized four-dimensional system and its rank-two residue

Let `a,b,q` belong to a characteristic-zero field, with `q(2a+b)` nonzero.
Consider `z² ∂z y = (U + zD)y`, where U has successive subdiagonal entries one,
upper entries `aq,bq,aq` and top-right entry `a²q²`, and
`D = diag(3,1,-1,-3)/2`. A rational change of basis splits U into a complementary
rank-two block and the nonzero square-zero block `[[0,1],[0,0]]`.

The displayed off-diagonal first gauge coefficient cancels the off-diagonal
grading blocks. The diagonal second-order correction gives the lower-left
modified-residue entry `-4a²/(2a+b)²`. The resulting residue has discriminant
`4(b-2a)/(2a+b)`. Every identity is a field or matrix identity proved in Lean;
the parameters are arbitrary subject to the displayed nonvanishing conditions.

These are finite coefficient identities. No quantum product, variety, formal
spectral decomposition, or exponent-to-monodromy correspondence is constructed.
The passage from the exhibited finite coefficients to an entire normalized
formal gauge is not asserted by these calculations.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1
namespace Quantum

open Matrix

variable {K : Type*} [Field K] [CharZero K]

/-- The four-dimensional leading matrix, in its ordered cyclic basis. -/
def parameterizedEulerMatrix (a b q : K) : Matrix (Fin 4) (Fin 4) K :=
  !![0, a*q, 0, a^2*q^2; 1, 0, b*q, 0; 0, 1, 0, a*q; 0, 0, 1, 0]

/-- The grading coefficient, in descending half-integral grading. -/
def parameterizedGradingMatrix : Matrix (Fin 4) (Fin 4) K :=
  !![3/2, 0, 0, 0; 0, 1/2, 0, 0; 0, 0, -1/2, 0; 0, 0, 0, -3/2]

/-- Columns spanning the complementary and zero-primary blocks, in that order. -/
def parameterizedBlockBasis (a b q : K) : Matrix (Fin 4) (Fin 4) K :=
  !![a*q, 0, 0, -(a+b)*q; 0, (a+b)*q, -a*q, 0; 1, 0, 0, 1; 0, 1, 1, 0]

/-- The rational inverse of the block basis when `q(2a+b)` is nonzero. -/
def parameterizedBlockBasisInverse (a b q : K) : Matrix (Fin 4) (Fin 4) K :=
  !![1/((2*a+b)*q), 0, (a+b)/(2*a+b), 0;
     0, 1/((2*a+b)*q), 0, a/(2*a+b);
     0, -1/((2*a+b)*q), 0, (a+b)/(2*a+b);
     -1/((2*a+b)*q), 0, a/(2*a+b), 0]

/-- The leading operator in the rational block basis. -/
def parameterizedEulerBlocks (a b q : K) : Matrix (Fin 4) (Fin 4) K :=
  !![0, (2*a+b)*q, 0, 0; 1, 0, 0, 0; 0, 0, 0, 1; 0, 0, 0, 0]

/-- The grading coefficient in the rational block basis. -/
def parameterizedGradingBlocks (a b : K) : Matrix (Fin 4) (Fin 4) K :=
  !![(2*a-b)/(2*(2*a+b)), 0, 0, -2*(a+b)/(2*a+b);
     0, (b-2*a)/(2*(2*a+b)), -2*a/(2*a+b), 0;
     0, -2*(a+b)/(2*a+b), -(2*a+3*b)/(2*(2*a+b)), 0;
     -2*a/(2*a+b), 0, 0, (2*a+3*b)/(2*(2*a+b))]

/-- The normalized first gauge coefficient, with both diagonal blocks zero. -/
def parameterizedGaugeFirst (a b q : K) : Matrix (Fin 4) (Fin 4) K :=
  !![0, 0, 2*a/(2*a+b), 0; 0, 0, 0, 2/(q*(2*a+b));
     -2/(q*(2*a+b)), 0, 0, 0; 0, -2*a/(2*a+b), 0, 0]

/-- The block-diagonal coefficient at first order after the first gauge. -/
def parameterizedReducedFirst (a b : K) : Matrix (Fin 4) (Fin 4) K :=
  !![(2*a-b)/(2*(2*a+b)), 0, 0, 0;
     0, (b-2*a)/(2*(2*a+b)), 0, 0;
     0, 0, -(2*a+3*b)/(2*(2*a+b)), 0;
     0, 0, 0, (2*a+3*b)/(2*(2*a+b))]

/-- The second coefficient before the commutator with the second gauge.
The last subtraction is the contribution of differentiating the first gauge. -/
def parameterizedSecondCorrection (a b q : K) : Matrix (Fin 4) (Fin 4) K :=
  parameterizedGradingBlocks a b * parameterizedGaugeFirst a b q
    - parameterizedGaugeFirst a b q * parameterizedReducedFirst a b
    - parameterizedGaugeFirst a b q

/-- The residue in the zero block after modification by `diag(1,z)`. -/
def parameterizedModifiedResidue (a b : K) : Matrix (Fin 2) (Fin 2) K :=
  !![-(2*a+3*b)/(2*(2*a+b)), 1;
     -4*a^2/(2*a+b)^2, (b-2*a)/(2*(2*a+b))]

omit [CharZero K] in
/-- The determinant of the rational block basis. -/
theorem parameterizedBlockBasis_det (a b q : K) :
    (parameterizedBlockBasis a b q).det = -(2*a+b)^2*q^2 := by
  simp [parameterizedBlockBasis, Matrix.det_succ_row_zero, Fin.sum_univ_succ,
    Fin.succAbove, Matrix.submatrix_apply]
  ring

omit [CharZero K] in
/-- The displayed basis and inverse are two-sided inverses on the exact
parameter domain needed for separating the zero-primary block. -/
theorem parameterizedBlockBasis_inverse {a b q : K}
    (sumNonzero : 2*a+b ≠ 0) (qNonzero : q ≠ 0) :
    parameterizedBlockBasis a b q * parameterizedBlockBasisInverse a b q = 1 ∧
      parameterizedBlockBasisInverse a b q * parameterizedBlockBasis a b q = 1 := by
  constructor <;> ext row column <;> fin_cases row <;> fin_cases column <;>
    simp [parameterizedBlockBasis, parameterizedBlockBasisInverse, Matrix.mul_apply,
      Fin.sum_univ_four] <;> field_simp [sumNonzero, qNonzero, (by simpa [mul_comm] using sumNonzero : a*2+b ≠ 0)] <;> ring

omit [CharZero K] in
/-- The basis intertwines the leading matrix with the separated blocks. -/
theorem parameterizedEulerMatrix_mul_blockBasis (a b q : K) :
    parameterizedEulerMatrix a b q * parameterizedBlockBasis a b q =
      parameterizedBlockBasis a b q * parameterizedEulerBlocks a b q := by
  ext row column
  fin_cases row <;> fin_cases column <;>
    simp [parameterizedEulerMatrix, parameterizedBlockBasis, parameterizedEulerBlocks,
      Matrix.mul_apply, Fin.sum_univ_four] <;> ring

/-- The basis also transports the grading coefficient to the displayed blocks. -/
theorem parameterizedGradingMatrix_mul_blockBasis {a b q : K}
    (sumNonzero : 2*a+b ≠ 0) :
    parameterizedGradingMatrix * parameterizedBlockBasis a b q =
      parameterizedBlockBasis a b q * parameterizedGradingBlocks a b := by
  ext row column
  fin_cases row <;> fin_cases column <;>
    simp [parameterizedGradingMatrix, parameterizedBlockBasis, parameterizedGradingBlocks,
      Matrix.mul_apply, Fin.sum_univ_four] <;> field_simp [sumNonzero, (by simpa [mul_comm] using sumNonzero : a*2+b ≠ 0)] <;> ring

omit [CharZero K] in
/-- Both first-order Sylvester equations hold at once: the first gauge removes
the off-diagonal grading blocks and leaves exactly the displayed diagonal ones. -/
theorem parameterizedReduction_first_order {a b q : K}
    (sumNonzero : 2*a+b ≠ 0) (qNonzero : q ≠ 0) :
    parameterizedGradingBlocks a b + parameterizedEulerBlocks a b q * parameterizedGaugeFirst a b q
      - parameterizedGaugeFirst a b q * parameterizedEulerBlocks a b q =
        parameterizedReducedFirst a b := by
  ext row column
  fin_cases row <;> fin_cases column <;>
    simp [parameterizedGradingBlocks, parameterizedEulerBlocks, parameterizedGaugeFirst,
      parameterizedReducedFirst] <;>
    field_simp [sumNonzero, qNonzero, (by simpa [mul_comm] using sumNonzero : a*2+b ≠ 0)] <;> ring

omit [CharZero K] in
/-- The lower-left coefficient of the zero block at second order is the
cross-block product; the derivative and within-block products vanish there. -/
theorem parameterizedSecondCorrection_lowerLeft (a b q : K) :
    parameterizedSecondCorrection a b q 3 2 = -4*a^2/(2*a+b)^2 := by
  simp [parameterizedSecondCorrection, parameterizedGradingBlocks, parameterizedGaugeFirst,
    parameterizedReducedFirst]
  simp only [div_eq_mul_inv, ← inv_pow]
  ring

omit [CharZero K] in
/-- The commutator with any second gauge coefficient has zero lower-left entry
in the zero block: the last leading row and the third leading column vanish. -/
theorem parameterizedEulerBlocks_commutator_lowerLeft (a b q : K)
    (secondGauge : Matrix (Fin 4) (Fin 4) K) :
    (parameterizedEulerBlocks a b q * secondGauge
      - secondGauge * parameterizedEulerBlocks a b q) 3 2 = 0 := by
  simp [parameterizedEulerBlocks, Matrix.mul_apply, Fin.sum_univ_four,
    Matrix.vecMul, dotProduct]

omit [CharZero K] in
/-- In the order-two gauge equation, an arbitrary original second coefficient
contributes its zero-block lower-left entry additively. The second gauge
commutator contributes zero to that entry, without a normalization assumption
on the second gauge. -/
theorem parameterizedReduction_second_order_lowerLeft (a b q : K)
    (originalSecond secondGauge reducedSecond : Matrix (Fin 4) (Fin 4) K)
    (gaugeEquation : reducedSecond = originalSecond + parameterizedSecondCorrection a b q
      + (parameterizedEulerBlocks a b q * secondGauge
        - secondGauge * parameterizedEulerBlocks a b q)) :
    reducedSecond 3 2 = originalSecond 3 2 - 4*a^2/(2*a+b)^2 := by
  rw [gaugeEquation]
  simp only [Matrix.add_apply, parameterizedSecondCorrection_lowerLeft,
    parameterizedEulerBlocks_commutator_lowerLeft, add_zero]
  ring

/-- The modified residue obtained from the zero-block leading coefficient,
first reduced coefficient and second correction is the displayed parameterized
matrix. An arbitrary second gauge commutator does not affect its lower-left
entry. -/
theorem parameterizedModifiedResidue_from_coefficients {a b q : K}
    (sumNonzero : 2*a+b ≠ 0) :
    (!![(parameterizedReducedFirst a b) 2 2, (parameterizedEulerBlocks a b q) 2 3;
        (parameterizedSecondCorrection a b q) 3 2,
        (parameterizedReducedFirst a b) 3 3 - 1] : Matrix (Fin 2) (Fin 2) K)
      = parameterizedModifiedResidue a b := by
  rw [parameterizedSecondCorrection_lowerLeft]
  ext row column
  fin_cases row <;> fin_cases column <;>
    simp [parameterizedReducedFirst, parameterizedEulerBlocks, parameterizedModifiedResidue]
  field_simp [sumNonzero, (by simpa [mul_comm] using sumNonzero : a*2+b ≠ 0)]
  ring

/-- The trace and determinant determine the monic quadratic indicial polynomial
of the displayed residue, namely `T²+T+(10a-3b)/(4(2a+b))`. -/
theorem parameterizedModifiedResidue_trace_det {a b : K}
    (sumNonzero : 2*a+b ≠ 0) :
    Matrix.trace (parameterizedModifiedResidue a b) = -1 ∧
      (parameterizedModifiedResidue a b).det = (10*a-3*b)/(4*(2*a+b)) := by
  constructor <;>
    simp [parameterizedModifiedResidue, Matrix.trace_fin_two, Matrix.det_fin_two] <;>
    field_simp [sumNonzero, (by simpa [mul_comm] using sumNonzero : a*2+b ≠ 0)] <;> ring

/-- The exact residue discriminant, with no restriction on resonance. -/
theorem parameterizedModifiedResidue_discriminant {a b : K}
    (sumNonzero : 2*a+b ≠ 0) :
    residueDiscriminant (parameterizedModifiedResidue a b) = 4*(b-2*a)/(2*a+b) := by
  obtain ⟨traceValue, detValue⟩ := parameterizedModifiedResidue_trace_det sumNonzero
  rw [residueDiscriminant, traceValue, detValue]
  field_simp [sumNonzero, (by simpa [mul_comm] using sumNonzero : a*2+b ≠ 0)]
  ring

/-- The four index-two numerical specializations, including the discriminant-one
case and the zero-discriminant rational control. These are values of explicit
rational matrices, without a geometric identification of the inputs. -/
theorem parameterizedModifiedResidue_fano_values :
    residueDiscriminant (parameterizedModifiedResidue (240 : ℚ) 1248) = 16/9 ∧
      residueDiscriminant (parameterizedModifiedResidue (48 : ℚ) 160) = 1 ∧
      residueDiscriminant (parameterizedModifiedResidue (24 : ℚ) 60) = 4/9 ∧
      residueDiscriminant (parameterizedModifiedResidue (16 : ℚ) 32) = 0 := by
  norm_num [parameterizedModifiedResidue, residueDiscriminant,
    Matrix.trace_fin_two, Matrix.det_fin_two]

/-- The characteristic polynomial of the original four-dimensional leading
matrix is `T²(T²-(2a+b)q)`, including all degenerate parameter values. -/
theorem parameterizedEulerMatrix_charpoly (a b q : K) :
    (parameterizedEulerMatrix a b q).charpoly =
      Polynomial.X^2 * (Polynomial.X^2 - Polynomial.C ((2*a+b)*q)) := by
  apply Polynomial.funext
  intro t
  rw [Matrix.eval_charpoly]
  simp [parameterizedEulerMatrix, Matrix.det_succ_row_zero, Fin.sum_univ_succ,
    Fin.succAbove, Matrix.submatrix_apply, Matrix.scalar, Matrix.diagonal, Matrix.vecHead, Matrix.vecTail]
  ring

/-- The characteristic polynomial of the computed modified residue, as an
identity in the polynomial ring over the parameter field. -/
theorem parameterizedModifiedResidue_charpoly {a b : K}
    (sumNonzero : 2*a+b ≠ 0) :
    (parameterizedModifiedResidue a b).charpoly =
      Polynomial.X^2 + Polynomial.X + Polynomial.C ((10*a-3*b)/(4*(2*a+b))) := by
  apply Polynomial.funext
  intro t
  rw [Matrix.eval_charpoly]
  simp [parameterizedModifiedResidue, Matrix.det_fin_two, Matrix.scalar, Matrix.diagonal, Matrix.vecHead, Matrix.vecTail]
  field_simp [sumNonzero, (by simpa [mul_comm] using sumNonzero : a*2+b ≠ 0)]
  ring

end Quantum
end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
