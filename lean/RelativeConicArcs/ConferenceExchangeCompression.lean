import Mathlib.Data.Matrix.Block
import Mathlib.Data.Real.Basic
import Mathlib.LinearAlgebra.Matrix.Charpoly.Basic
import Mathlib.LinearAlgebra.Matrix.Trace
import Mathlib.Tactic.LinearCombination

/-!
# Compressions of a controlled conference operator between its eigenframes

Let `C` be a symmetric matrix with `C * C = q • 1` and `s * s = q`, so that
`Q = s⁻¹ • C` is an involution with eigenvalues `±1` and eigenprojections
`(1 ± Q) / 2`.  A diagonal control between ordered orthonormal frames for the
two eigenspaces produces the transfer block studied in six-mode interferometry:
if the columns of `Qp` and `Qm` are such frames, the transfer is
`K = Qmᵀ * D * Qp` for the diagonal control `D`.

This module supplies the matrix identities relating that transfer to the block
data of a cut.  For the sign involution `cutInvolution` of a two-block
splitting, the commutator with the block matrix is computed in closed form, and
its square is block diagonal with the two cross Gram matrices of the cut on the
diagonal.  On the transfer side, `Kᵀ * K` is the compression of the
control-conjugated complementary eigenprojection, and the commutator of the
control with the involution acts on the positive eigenspace as twice the
compression appearing in that exchange operator.

Conventions:

* `cutInvolution` is the diagonal sign matrix that is `1` on the first block and
  `-1` on the second; complementing the cut negates it and changes no result
  below.
* A frame `Qp` for the positive eigenspace is a matrix with `Qpᵀ * Qp = 1` and
  `Qp * Qpᵀ = positiveProjection Q`; these two conditions say exactly that its
  columns are an orthonormal basis of that eigenspace.
* All results are matrix identities over the real numbers; no eigenvalue,
  singular-value, or spectral-theorem input is used.
-/

namespace RelativeConicArcs
namespace ConferenceExchange

open Matrix

section Projections

variable {m : Type*} [Fintype m] [DecidableEq m]

/-- The projection onto the `+1` eigenspace of an involution. -/
noncomputable def positiveProjection (Q : Matrix m m ℝ) : Matrix m m ℝ := (2⁻¹ : ℝ) • (1 + Q)

/-- The projection onto the `-1` eigenspace of an involution. -/
noncomputable def negativeProjection (Q : Matrix m m ℝ) : Matrix m m ℝ := (2⁻¹ : ℝ) • (1 - Q)

omit [Fintype m] in
theorem positiveProjection_add_negativeProjection (Q : Matrix m m ℝ) :
    positiveProjection Q + negativeProjection Q = 1 := by
  simp [positiveProjection, negativeProjection, smul_add, smul_sub]
  module

theorem positiveProjection_mul_self (Q : Matrix m m ℝ) (hQ : Q * Q = 1) :
    positiveProjection Q * positiveProjection Q = positiveProjection Q := by
  simp only [positiveProjection, Matrix.smul_mul, Matrix.mul_smul, add_mul, mul_add,
    Matrix.one_mul, Matrix.mul_one, hQ]
  module

theorem negativeProjection_mul_self (Q : Matrix m m ℝ) (hQ : Q * Q = 1) :
    negativeProjection Q * negativeProjection Q = negativeProjection Q := by
  simp only [negativeProjection, Matrix.smul_mul, Matrix.mul_smul, sub_mul, mul_sub,
    Matrix.one_mul, Matrix.mul_one, hQ]
  module

theorem positiveProjection_mul_negativeProjection (Q : Matrix m m ℝ) (hQ : Q * Q = 1) :
    positiveProjection Q * negativeProjection Q = 0 := by
  simp only [positiveProjection, negativeProjection, Matrix.smul_mul, Matrix.mul_smul,
    add_mul, mul_sub, Matrix.one_mul, Matrix.mul_one, hQ]
  module

end Projections

section CutBlocks

variable {ι : Type*} [Fintype ι] [DecidableEq ι]

/-- The sign involution of a two-block cut: `1` on the first block and `-1` on
the second. -/
def cutInvolution (ι : Type*) [DecidableEq ι] : Matrix (ι ⊕ ι) (ι ⊕ ι) ℝ :=
  fromBlocks 1 0 0 (-1)

omit [Fintype ι] in
@[simp]
theorem cutInvolution_transpose : (cutInvolution ι)ᵀ = cutInvolution ι := by
  simp [cutInvolution, Matrix.fromBlocks_transpose]

theorem cutInvolution_mul_self : cutInvolution ι * cutInvolution ι = 1 := by
  simp [cutInvolution, Matrix.fromBlocks_multiply, Matrix.fromBlocks_one]

/-- The commutator of the cut involution with a block matrix isolates the cross
block. -/
theorem cutInvolution_commutator (A R S E : Matrix ι ι ℝ) :
    cutInvolution ι * fromBlocks A R S E - fromBlocks A R S E * cutInvolution ι
      = fromBlocks 0 ((2 : ℝ) • R) (-((2 : ℝ) • S)) 0 := by
  simp only [cutInvolution, Matrix.fromBlocks_multiply, Matrix.one_mul, Matrix.mul_one,
    Matrix.zero_mul, Matrix.mul_zero, add_zero, zero_add, neg_mul, mul_neg]
  ext i j
  cases i <;> cases j <;> simp [two_smul, sub_eq_add_neg]

/-- The square of that commutator is block diagonal, with the two cross Gram
matrices of the cut on the diagonal. -/
theorem cutInvolution_commutator_sq (A R E : Matrix ι ι ℝ) :
    (cutInvolution ι * fromBlocks A R Rᵀ E - fromBlocks A R Rᵀ E * cutInvolution ι)
        * (cutInvolution ι * fromBlocks A R Rᵀ E - fromBlocks A R Rᵀ E * cutInvolution ι)
      = fromBlocks (-((4 : ℝ) • (R * Rᵀ))) 0 0 (-((4 : ℝ) • (Rᵀ * R))) := by
  rw [cutInvolution_commutator, Matrix.fromBlocks_multiply]
  refine Matrix.fromBlocks_inj.2 ⟨?_, ?_, ?_, ?_⟩ <;>
    simp [smul_smul] <;> module

end CutBlocks

section Compression

variable {m ι : Type*} [Fintype m] [DecidableEq m] [Fintype ι] [DecidableEq ι]

/-- The transfer block of a diagonal control between ordered orthonormal frames
for the two eigenspaces of an involution. -/
def transferBlock (D : Matrix m m ℝ) (Qp Qm : Matrix m ι ℝ) : Matrix ι ι ℝ :=
  Qmᵀ * D * Qp

omit [DecidableEq ι] in
/-- The exchange operator of a transfer block is the compression of the
control-conjugated complementary eigenprojection. -/
theorem transferBlock_gram (Q D : Matrix m m ℝ) (Qp Qm : Matrix m ι ℝ)
    (hD : Dᵀ = D) (hQm : Qm * Qmᵀ = negativeProjection Q) :
    (transferBlock D Qp Qm)ᵀ * transferBlock D Qp Qm
      = Qpᵀ * (D * negativeProjection Q * D) * Qp := by
  simp only [transferBlock, Matrix.transpose_mul, Matrix.transpose_transpose, hD,
    Matrix.mul_assoc]
  rw [← Matrix.mul_assoc Qm Qmᵀ, hQm]

omit [Fintype ι] [DecidableEq ι] in
/-- The commutator of the control with the involution acts on the positive
eigenspace as twice the compression appearing in the exchange operator. -/
theorem commutator_mul_positiveProjection (Q D : Matrix m m ℝ) (hQ : Q * Q = 1) :
    (D * Q - Q * D) * positiveProjection Q
      = (2 : ℝ) • (negativeProjection Q * D * positiveProjection Q) := by
  simp only [positiveProjection, negativeProjection, Matrix.mul_smul, Matrix.smul_mul,
    sub_mul, mul_sub, mul_add, add_mul, Matrix.mul_one, Matrix.one_mul,
    Matrix.mul_assoc, hQ]
  module

end Compression

end ConferenceExchange
end RelativeConicArcs
