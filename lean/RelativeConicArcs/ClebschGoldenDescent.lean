import RelativeConicArcs.ClebschGoldenConference
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic
import Mathlib.Tactic.NormNum.NatFactorial

/-!
# Restriction-of-scalars matrices for the golden operator

Multiplication by a square root of five has companion matrix
`[[0, 5], [1, 0]]`.  A map with golden coefficients `a + s b` descends to
`[[a, 5b], [b, a]]`; these two matrices commute.  The six-dimensional
degree-ten comparison is recorded independently as an integral intertwiner.

The generic identities are symbolic ring proofs.  The displayed integral
intertwiner and determinant are checked by native decision from their literal
matrices.  No generated data or external axiom is used.
-/

namespace RelativeConicArcs
namespace ClebschGoldenDescent

open Matrix
open scoped Matrix
open ClebschGoldenConference

/-- Companion matrix for multiplication by a square root of five. -/
def goldenCompanion {R : Type*} [CommRing R] : Matrix (Fin 2) (Fin 2) R :=
  !![0, 5; 1, 0]

/-- Restriction of scalars of the coefficient `a + s b`. -/
def descendedCoefficient {R : Type*} [CommRing R] (a b : R) :
    Matrix (Fin 2) (Fin 2) R :=
  !![a, 5 * b; b, a]

/-- The golden companion squares to five. -/
theorem goldenCompanion_sq {R : Type*} [CommRing R] :
    (goldenCompanion : Matrix (Fin 2) (Fin 2) R) * goldenCompanion =
      (5 : R) • (1 : Matrix (Fin 2) (Fin 2) R) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [goldenCompanion, Matrix.mul_apply, Fin.sum_univ_succ]

/-- Restriction-of-scalars coefficient matrices commute with multiplication
by the golden generator. -/
theorem goldenCompanion_mul_descendedCoefficient {R : Type*} [CommRing R]
    (a b : R) :
    (goldenCompanion : Matrix (Fin 2) (Fin 2) R) * descendedCoefficient a b =
      descendedCoefficient a b * goldenCompanion := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [goldenCompanion, descendedCoefficient, Matrix.mul_apply,
      Fin.sum_univ_succ]
  all_goals ring

/-- The integral companion matrix on three copies of the golden algebra. -/
def degreeTenCompanion : Matrix (Fin 6) (Fin 6) ℤ :=
  !![0, 0, 0, 5, 0, 0;
     0, 0, 0, 0, 5, 0;
     0, 0, 0, 0, 0, 5;
     1, 0, 0, 0, 0, 0;
     0, 1, 0, 0, 0, 0;
     0, 0, 1, 0, 0, 0]

/-- Integral comparison from the companion basis to the signed-axis basis. -/
def degreeTenComparison : Matrix (Fin 6) (Fin 6) ℤ :=
  !![1, 0, 0, 0, 1, 1;
     0, 1, 0, 1, 0, -1;
     0, 0, 1, 1, -1, 0;
     0, 0, 0, 1, -1, 1;
     0, 0, 0, -1, -1, 1;
     0, 0, 0, -1, -1, -1]

/-- The signed-axis conference matrix intertwines the degree-ten comparison
with the three-copy companion matrix. -/
theorem conference_mul_degreeTenComparison :
    conferenceMatrix * degreeTenComparison =
      degreeTenComparison * degreeTenCompanion := by
  native_decide

/-- The comparison lattice has index four. -/
theorem degreeTenComparison_det : Matrix.det degreeTenComparison = 4 := by
  native_decide

/-- Exact conversion from the raw third-transvectant/Fischer scalar to the
normalized transvectant and Bombieri--Fischer scalar. -/
theorem normalizedReturnScalar :
    (211625906798592000 : ℚ) * (1 / 950400) ^ 2 *
      (((10 : ℕ).factorial : ℚ) / ((16 : ℕ).factorial : ℚ)) = 64 / 1575 := by
  norm_num

end ClebschGoldenDescent
end RelativeConicArcs
