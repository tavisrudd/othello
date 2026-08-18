import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.CubicPacket
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.AtomicResidueDiscriminant

/-!
# The small even block reduction of a cubic threefold

Let `X` be a smooth cubic threefold, `P` its hyperplane class, and `q` the
Novikov variable of the line class.  In the ordered classical basis
`1, P, P^2, P^3` the small even horizontal system is

  `z^2 ∂_z S = (K + z G) S`,

with `K` the doubled Euler multiplication matrix and `G` the grading matrix
`(3, 1, -1, -3) / 2`.  This is the system displayed in J. Cai, *The cubic
threefold is symplectically irrational*, arXiv:2608.01577 (2026), Section 3;
it is the only imported cubic datum.  Throughout, `r` is a square root of
`3 q`, so `q = r ^ 2 / 3`, and every matrix below is written in `r`.

The module carries out the reduction in three steps, each an exact identity
proved by matrix arithmetic.

* The constant change of basis `C`, of determinant `-486 r ^ 5`, conjugates `K`
  to `diag (6 r, -6 r, J)` with `J = !![0, 2; 0, 0]`.  So the Euler
  multiplication has eigenvalues `6 r`, `-6 r`, and a double eigenvalue `0`
  whose generalized eigenspace is a single rank-two Jordan block, and it
  conjugates `G` to the explicit matrix recorded here.

* Two orders of the normalized gauge `I + z A₁ + z ^ 2 A₂`, whose positive
  coefficients are block-off-diagonal for the partition `{0}, {1}, {2, 3}`,
  make the first and second coefficients of the transformed system block
  diagonal.  The transformed rank-two block is `J + z D + z ^ 2 E` with
  `D = diag (-19 / 18, 19 / 18)` and `E = !![0, -14 / (81 r ^ 2); -8 / 81, 0]`.
  The gauge coefficients are those forced by the Sylvester equations between
  blocks with distinct scalar spectra; here they are supplied explicitly and
  the resulting identities are verified.

* The canonical elementary modification of the rank-two block, implemented by
  the lattice change of basis `diag (1, z)`, has residue
  `!![-19 / 18, 2; -8 / 81, 1 / 18]`, of trace `-1` and determinant `5 / 36`.
  Its characteristic polynomial is therefore the rank-two indicial polynomial
  `X ^ 2 + X + 5 / 36`, with exponents `-1 / 6` and `-5 / 6`, and its residue
  discriminant is `4 / 9`.

Lean proves the displayed algebra only.  It does not construct the quantum
connection, does not prove that the displayed `K` and `G` are the small even
connection of a cubic threefold, and does not prove that the residue exponents
are the exponents of the framed formal monodromy; the passage from a
regular-singular residue to formal monodromy remains external.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Quantum

open Matrix

variable {K : Type*} [Field K] [CharZero K]

/-- The doubled Euler multiplication matrix of the small even quantum
connection of a smooth cubic threefold, in the ordered classical basis
`1, P, P^2, P^3`, written in `r` with `q = r ^ 2 / 3`. -/
def cubicEulerMatrix (r : K) : Matrix (Fin 4) (Fin 4) K :=
  !![0, 4 * r ^ 2, 0, 8 * r ^ 4;
     2, 0, 10 * r ^ 2, 0;
     0, 2, 0, 4 * r ^ 2;
     0, 0, 2, 0]

/-- The grading matrix of the small even quantum connection in the same basis. -/
def cubicGradingMatrix : Matrix (Fin 4) (Fin 4) K :=
  !![3 / 2, 0, 0, 0;
     0, 1 / 2, 0, 0;
     0, 0, -1 / 2, 0;
     0, 0, 0, -3 / 2]

/-- The constant change of basis separating the two nonzero Euler eigenvalues
from the rank-two zero block. -/
def cubicBlockBasis (r : K) : Matrix (Fin 4) (Fin 4) K :=
  !![6 * r ^ 3, -6 * r ^ 3, 0, -7 * r ^ 2;
     7 * r ^ 2, 7 * r ^ 2, -2 * r ^ 2, 0;
     3 * r, -3 * r, 0, 1;
     1, 1, 1, 0]

/-- The Euler matrix in the separated basis: the two simple eigenvalues
`6 r` and `-6 r`, and a single rank-two Jordan block at the eigenvalue zero. -/
def cubicEulerBlockForm (r : K) : Matrix (Fin 4) (Fin 4) K :=
  !![6 * r, 0, 0, 0;
     0, -6 * r, 0, 0;
     0, 0, 0, 2;
     0, 0, 0, 0]

/-- The grading matrix in the separated basis. -/
def cubicGradingBlockForm (r : K) : Matrix (Fin 4) (Fin 4) K :=
  !![0, 1 / 18, -2 / 9, -7 / (27 * r);
     1 / 18, 0, -2 / 9, 7 / (27 * r);
     -14 / 9, -14 / 9, -19 / 18, 0;
     -4 * r / 3, 4 * r / 3, 0, 19 / 18]

/-- The first coefficient of the normalized gauge, block-off-diagonal for the
partition `{0}, {1}, {2, 3}`. -/
def cubicGaugeFirst (r : K) : Matrix (Fin 4) (Fin 4) K :=
  !![0, -1 / (216 * r), 1 / (27 * r), 1 / (18 * r ^ 2);
     1 / (216 * r), 0, -1 / (27 * r), 1 / (18 * r ^ 2);
     -1 / (3 * r), 1 / (3 * r), 0, 0;
     -2 / 9, -2 / 9, 0, 0]

/-- The second coefficient of the normalized gauge, block-off-diagonal for the
same partition. -/
def cubicGaugeSecond (r : K) : Matrix (Fin 4) (Fin 4) K :=
  !![0, 23 / (23328 * r ^ 2), 0, 1 / (54 * r ^ 3);
     23 / (23328 * r ^ 2), 0, 0, -1 / (54 * r ^ 3);
     73 / (648 * r ^ 2), 73 / (648 * r ^ 2), 0, 0;
     -1 / (972 * r), 1 / (972 * r), 0, 0]

/-- The first coefficient of the reduced system: block diagonal, with rank-two
block `diag (-19 / 18, 19 / 18)`. -/
def cubicReducedFirst : Matrix (Fin 4) (Fin 4) K :=
  !![0, 0, 0, 0;
     0, 0, 0, 0;
     0, 0, -19 / 18, 0;
     0, 0, 0, 19 / 18]

/-- The second coefficient of the reduced system: block diagonal, with
rank-two block `!![0, -14 / (81 r ^ 2); -8 / 81, 0]`. -/
def cubicReducedSecond (r : K) : Matrix (Fin 4) (Fin 4) K :=
  !![19 / (144 * r), 0, 0, 0;
     0, -19 / (144 * r), 0, 0;
     0, 0, 0, -14 / (81 * r ^ 2);
     0, 0, -8 / 81, 0]

/-- The determinant of the separating change of basis, nonzero for `r ≠ 0`. -/
theorem cubicBlockBasis_det (r : K) :
    (cubicBlockBasis r).det = -486 * r ^ 5 := by
  simp [cubicBlockBasis, Matrix.det_succ_row_zero, Fin.sum_univ_succ, Fin.succAbove,
    Matrix.submatrix_apply]
  ring

/-- The change of basis conjugates the Euler matrix to its separated form. -/
theorem cubicEulerMatrix_mul_blockBasis (r : K) :
    cubicEulerMatrix r * cubicBlockBasis r =
      cubicBlockBasis r * cubicEulerBlockForm r := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [cubicEulerMatrix, cubicBlockBasis, cubicEulerBlockForm, Matrix.mul_apply,
      Fin.sum_univ_four] <;> ring

set_option maxHeartbeats 800000 in
/-- The change of basis conjugates the grading matrix to its separated form. -/
theorem cubicGradingMatrix_mul_blockBasis (r : K) (hr : r ≠ 0) :
    cubicGradingMatrix * cubicBlockBasis r =
      cubicBlockBasis r * cubicGradingBlockForm r := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [cubicGradingMatrix, cubicBlockBasis, cubicGradingBlockForm, Matrix.mul_apply,
      Fin.sum_univ_four] <;> field_simp <;> ring

set_option maxHeartbeats 800000 in
/-- First order of the normalized reduction: the commutator of the separated
Euler matrix with the first gauge coefficient cancels the off-diagonal blocks
of the separated grading matrix. -/
theorem cubicReduction_first_order (r : K) (hr : r ≠ 0) :
    cubicEulerBlockForm r * cubicGaugeFirst r -
        cubicGaugeFirst r * cubicEulerBlockForm r + cubicGradingBlockForm r =
      cubicReducedFirst := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [cubicEulerBlockForm, cubicGaugeFirst, cubicGradingBlockForm, cubicReducedFirst,
      Matrix.mul_apply, Fin.sum_univ_four] <;> field_simp <;> ring

set_option maxHeartbeats 1600000 in
/-- Second order of the normalized reduction.  The second gauge coefficient
cancels the off-diagonal blocks of the second-order source term, leaving the
block-diagonal second coefficient of the reduced system. -/
theorem cubicReduction_second_order (r : K) (hr : r ≠ 0) :
    cubicEulerBlockForm r * cubicGaugeSecond r -
        cubicGaugeSecond r * cubicEulerBlockForm r +
        (cubicGradingBlockForm r * cubicGaugeFirst r -
          cubicGaugeFirst r * cubicReducedFirst - cubicGaugeFirst r) =
      cubicReducedSecond r := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [cubicEulerBlockForm, cubicGaugeSecond, cubicGaugeFirst, cubicGradingBlockForm,
      cubicReducedFirst, cubicReducedSecond, Matrix.mul_apply, Fin.sum_univ_four] <;>
    field_simp <;> ring

/-- The residue at `u = 0` of the canonical elementary modification of a
rank-two block `u⁻¹ N + A + u B + ⋯` whose leading term is square-zero with
image the first coordinate line.  The modification is the lattice change of
basis `diag (1, u)`; conjugating multiplies the entry in position `(i, j)` by
`u ^ (j - i)`, so the pole of `u⁻¹ N` becomes the constant `N 0 1`, the entry
`B 1 0` survives, the entries `A 0 0` and `A 1 1` are unchanged, and the
logarithmic term of the change of basis subtracts `1` in position `(1, 1)`. -/
def modifiedBlockResidue (N A B : Matrix (Fin 2) (Fin 2) K) :
    Matrix (Fin 2) (Fin 2) K :=
  !![A 0 0, N 0 1; B 1 0, A 1 1 - 1]

/-- The leading, regular, and second coefficients of the reduced rank-two zero
block, read off the separated system. -/
def cubicZeroBlockLeading : Matrix (Fin 2) (Fin 2) K := !![0, 2; 0, 0]

/-- The regular coefficient of the reduced rank-two zero block. -/
def cubicZeroBlockRegular : Matrix (Fin 2) (Fin 2) K := !![-19 / 18, 0; 0, 19 / 18]

/-- The second coefficient of the reduced rank-two zero block. -/
def cubicZeroBlockSecond (r : K) : Matrix (Fin 2) (Fin 2) K :=
  !![0, -14 / (81 * r ^ 2); -8 / 81, 0]

/-- The three coefficients above are the rank-two block of the reduced system. -/
theorem cubicZeroBlock_eq_reduced_blocks (r : K) (i j : Fin 2) :
    cubicZeroBlockLeading (K := K) i j =
        cubicEulerBlockForm r i.succ.succ j.succ.succ ∧
      cubicZeroBlockRegular (K := K) i j =
        cubicReducedFirst i.succ.succ j.succ.succ ∧
      cubicZeroBlockSecond r i j = cubicReducedSecond r i.succ.succ j.succ.succ := by
  fin_cases i <;> fin_cases j <;>
    exact ⟨rfl, rfl, rfl⟩

/-- The residue of the canonical elementary modification of the cubic zero
block. -/
theorem cubicModifiedBlockResidue (r : K) :
    modifiedBlockResidue (cubicZeroBlockLeading (K := K)) cubicZeroBlockRegular
        (cubicZeroBlockSecond r) =
      !![-19 / 18, 2; -8 / 81, 1 / 18] := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [modifiedBlockResidue, cubicZeroBlockLeading, cubicZeroBlockRegular,
      cubicZeroBlockSecond] <;> norm_num

/-- The trace and determinant of that residue. -/
theorem cubicModifiedBlockResidue_trace_det (r : K) :
    (modifiedBlockResidue (cubicZeroBlockLeading (K := K)) cubicZeroBlockRegular
        (cubicZeroBlockSecond r)).trace = -1 ∧
      (modifiedBlockResidue (cubicZeroBlockLeading (K := K)) cubicZeroBlockRegular
        (cubicZeroBlockSecond r)).det = 5 / 36 := by
  rw [cubicModifiedBlockResidue r]
  constructor
  · simp [Matrix.trace_fin_two]
    norm_num
  · simp [Matrix.det_fin_two]
    norm_num

/-- The characteristic polynomial of the modified residue of the cubic zero
block is the rank-two indicial polynomial `X ^ 2 + X + 5 / 36`, whose roots are
the exponents `-1 / 6` and `-5 / 6`. -/
theorem cubicModifiedBlockResidue_indicialPolynomial (r : ℚ) :
    cubicIndicialPolynomial =
      ((Polynomial.X ^ 2 -
        Polynomial.C
          (modifiedBlockResidue (cubicZeroBlockLeading (K := ℚ))
            (cubicZeroBlockRegular (K := ℚ)) (cubicZeroBlockSecond r)).trace * Polynomial.X +
        Polynomial.C
          (modifiedBlockResidue (cubicZeroBlockLeading (K := ℚ))
            (cubicZeroBlockRegular (K := ℚ)) (cubicZeroBlockSecond r)).det :
              Polynomial ℚ)) := by
  rw [(cubicModifiedBlockResidue_trace_det r).1, (cubicModifiedBlockResidue_trace_det r).2]
  unfold cubicIndicialPolynomial
  simp only [map_neg, map_one]
  ring

/-- The residue discriminant of the cubic zero block, computed from the reduced
block data rather than assumed. -/
theorem residueDiscriminant_cubicModifiedBlockResidue (r : K) :
    residueDiscriminant
        (modifiedBlockResidue (cubicZeroBlockLeading (K := K)) cubicZeroBlockRegular
          (cubicZeroBlockSecond r)) = 4 / 9 := by
  unfold residueDiscriminant
  rw [(cubicModifiedBlockResidue_trace_det r).1, (cubicModifiedBlockResidue_trace_det r).2]
  norm_num

/-- The zero block of the separated Euler matrix is a single rank-two Jordan
block: it is nonzero and squares to zero. -/
theorem cubicZeroBlockLeading_sq_eq_zero_and_ne_zero :
    cubicZeroBlockLeading (K := K) * cubicZeroBlockLeading = 0 ∧
      cubicZeroBlockLeading (K := K) ≠ 0 := by
  constructor
  · ext i j
    fin_cases i <;> fin_cases j <;>
      simp [cubicZeroBlockLeading, Matrix.mul_apply, Fin.sum_univ_two]
  · intro contradiction
    have entry := congrFun (congrFun contradiction 0) 1
    simp [cubicZeroBlockLeading] at entry

/-- The residue matrix asserted in the manuscript's cubic computation is the
residue of the canonical elementary modification of the reduced rank-two zero
block. -/
theorem cubicZeroPacketResidue_eq_modifiedBlockResidue (r : ℚ) :
    cubicZeroPacketResidue =
      modifiedBlockResidue (cubicZeroBlockLeading (K := ℚ)) cubicZeroBlockRegular
        (cubicZeroBlockSecond r) := by
  rw [cubicModifiedBlockResidue r]
  ext i j
  fin_cases i <;> fin_cases j <;> simp [cubicZeroPacketResidue]

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
