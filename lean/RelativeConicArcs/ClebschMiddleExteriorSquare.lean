import RelativeConicArcs.ClebschMiddleExteriorSupport
import RelativeConicArcs.ClebschMiddleExteriorSquareRows012To023
import RelativeConicArcs.ClebschMiddleExteriorSquareRows024To045
import RelativeConicArcs.ClebschMiddleExteriorSquareRows123To135
import RelativeConicArcs.ClebschMiddleExteriorSquareRows145To345

/-!
# Square of the middle-exterior return

This leaf assembles the two square identities for signed Hodge complementation
and the determinant-defined middle-exterior return.  The Hodge square is a
structural argument from the parity of complementary label sums; the return
square is assembled from the twenty row identities, each of which is a kernel
decision on the determinant-defined entries.  No return matrix or generated
certificate is stored here, and no compiled evaluation is used.
-/

namespace RelativeConicArcs
namespace ClebschMiddleExterior

open Matrix
open scoped Matrix

set_option maxRecDepth 10000

/-- Middle-degree Hodge complementation squares to minus the identity.  The
matrix has one nonzero entry in each row, at the complementary label, so the
product collapses to that single term, whose sign is
`hodgeSign_mul_complement`. -/
theorem hodgeMatrix_sq :
    hodgeMatrix * hodgeMatrix = -(1 : Matrix (Fin 20) (Fin 20) ℤ) := by
  ext S T
  rw [Matrix.mul_apply,
    Finset.sum_eq_single (complementIndex S)
      (fun U _ hU => by simp [hodgeMatrix, hU]) (by simp)]
  by_cases h : T = S
  · subst h
    simp only [hodgeMatrix, complementIndex_involutive T, if_true,
      Matrix.neg_apply, Matrix.one_apply_eq]
    rw [neg_mul_neg]
    exact hodgeSign_mul_complement T
  · have hzero : hodgeMatrix (complementIndex S) T = 0 := by
      simp only [hodgeMatrix, complementIndex_involutive S]
      exact if_neg h
    rw [hzero, mul_zero, Matrix.neg_apply, Matrix.one_apply_ne (Ne.symm h),
      neg_zero]

/-- The middle-exterior return satisfies `K² = 125I`. -/
theorem middleExterior_sq :
    middleExterior * middleExterior =
      125 • (1 : Matrix (Fin 20) (Fin 20) ℤ) := by
  ext S T
  fin_cases S
  · exact middleExterior_sq_row_012 T
  · exact middleExterior_sq_row_013 T
  · exact middleExterior_sq_row_014 T
  · exact middleExterior_sq_row_015 T
  · exact middleExterior_sq_row_023 T
  · exact middleExterior_sq_row_024 T
  · exact middleExterior_sq_row_025 T
  · exact middleExterior_sq_row_034 T
  · exact middleExterior_sq_row_035 T
  · exact middleExterior_sq_row_045 T
  · exact middleExterior_sq_row_123 T
  · exact middleExterior_sq_row_124 T
  · exact middleExterior_sq_row_125 T
  · exact middleExterior_sq_row_134 T
  · exact middleExterior_sq_row_135 T
  · exact middleExterior_sq_row_145 T
  · exact middleExterior_sq_row_234 T
  · exact middleExterior_sq_row_235 T
  · exact middleExterior_sq_row_245 T
  · exact middleExterior_sq_row_345 T

end ClebschMiddleExterior
end RelativeConicArcs
