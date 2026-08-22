import Mathlib
import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.RowedProjectorDecomposition

/-!
# Exact rational certificate for the marked cubic block

This file checks the finite rational data used to recognize the separated
rank-two cubic block.  Its nilpotent part is nonzero and squares to zero; the modified residue has
trace `-1`, determinant `5/36`, and discriminant `4/9`, and the degree-zero
row is nonzero on the block.

These are kernel-reduced rational identities.  The identification of these
matrices with the corresponding quantum-module block is an external geometric
input; the declarations do not compute Gromov--Witten invariants.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.CubicBlockCertificate

open TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.RowedProjectorDecomposition

/-- The nonzero nilpotent endomorphism of the separated rank-two block. -/
def nilpotentPart : Matrix (Fin 2) (Fin 2) ℚ :=
  !![0, 1; 0, 0]

/-- The modified residue on the separated rank-two block at the normalized
rational point. -/
def modifiedResidue : Matrix (Fin 2) (Fin 2) ℚ :=
  !![-19 / 18, 2; -8 / 81, 1 / 18]

/-- The normalized degree-zero row on the separated rank-two block. -/
def rankRow : (Fin 2 → ℚ) →ₗ[ℚ] ℚ where
  toFun vector := -7 * vector 1
  map_add' := by
    intro left right
    simp [mul_add]
  map_smul' := by
    intro scalar vector
    simp [smul_eq_mul]
    ring

/-- The nilpotent part is not the zero matrix. -/
theorem nilpotentPart_ne_zero : nilpotentPart ≠ 0 := by
  intro equality
  have entryEquality := congrFun (congrFun equality 0) 1
  norm_num [nilpotentPart] at entryEquality

/-- The square of the displayed nilpotent part is zero. -/
theorem nilpotentPart_sq_eq_zero : nilpotentPart * nilpotentPart = 0 := by
  ext i j
  fin_cases i <;> fin_cases j <;> norm_num [nilpotentPart, Matrix.mul_apply]

/-- The modified residue has trace `-1`. -/
theorem modifiedResidue_trace : modifiedResidue.trace = -1 := by
  norm_num [modifiedResidue, Matrix.trace]

/-- The modified residue has determinant `5/36`. -/
theorem modifiedResidue_det : modifiedResidue.det = 5 / 36 := by
  norm_num [modifiedResidue, Matrix.det_fin_two]

/-- The trace-discriminant of the modified residue is `4/9`, hence nonzero. -/
theorem modifiedResidue_discriminant :
    modifiedResidue.trace ^ 2 - 4 * modifiedResidue.det = 4 / 9 := by
  rw [modifiedResidue_trace, modifiedResidue_det]
  norm_num

/-- The normalized degree-zero row detects the identity projector on the
rank-two block. -/
theorem rankRow_detects :
    Detects ℚ ℚ rankRow
      (Projector.identity (R := ℚ) (M := Fin 2 → ℚ)) := by
  refine ⟨![0, 1], ?_, ?_⟩
  · simp [Projector.identity]
  · norm_num [rankRow]

/-- The marked cubic block remains row-visible after tensoring with any
auxiliary module carrying a vector of row value one. -/
theorem rankRow_tensor_detects
    {U : Type*} [AddCommGroup U] [Module ℚ U]
    (rowU : U →ₗ[ℚ] ℚ) (u : U) (rowU_one : rowU u = 1) :
    Detects ℚ ℚ
      (tensorRow ℚ rankRow rowU)
      ((Projector.identity (R := ℚ) (M := Fin 2 → ℚ)).tensorIdentity) :=
  detects_tensorIdentity ℚ rankRow rowU
    (Projector.identity (R := ℚ) (M := Fin 2 → ℚ))
    rankRow_detects u rowU_one

end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.CubicBlockCertificate
