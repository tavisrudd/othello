import RelativeConicArcs.AMELU.WeylBasis
import Mathlib.LinearAlgebra.Matrix.NonsingularInverse

/-!
# Unitary conjugation in Weyl coordinates

The column-orthonormal matrix convention used for local unitaries implies
both matrix inverse identities.  Conjugation by such a matrix is therefore
a complex linear equivalence of the full operator space.  Composing this
equivalence with the finite-field Weyl basis gives an invertible linear
map on Weyl-coordinate functions.

The terminal criterion states the exact bridge needed for local Clifford
rigidity: if this coordinate action carries every nonzero coordinate axis
to a coordinate axis, then the unitary normalizes every Weyl axis and is
Clifford in the repository convention.

All arguments are symbolic and kernel checked.  The module contains no
generated data, native evaluation, axioms, or admitted declarations.
-/

namespace RelativeConicArcs.AMELU

open Matrix Module

variable {𝔽 : Type*} [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽]

omit [Field 𝔽] in
/-- Column orthonormality is the matrix identity `UᴴU=1`. -/
theorem conjTranspose_mul_self_eq_one_of_isUnitaryMatrix
    {U : LocalMatrix 𝔽} (hU : IsUnitaryMatrix U) :
    U.conjTranspose * U = 1 := by
  ext x y
  simpa [Matrix.mul_apply, Matrix.conjTranspose_apply, Matrix.one_apply]
    using hU x y

omit [Field 𝔽] in
/-- For a finite square matrix, column orthonormality also gives
`UUᴴ=1`. -/
theorem self_mul_conjTranspose_eq_one_of_isUnitaryMatrix
    {U : LocalMatrix 𝔽} (hU : IsUnitaryMatrix U) :
    U * U.conjTranspose = 1 := by
  exact mul_eq_one_comm.mp
    (conjTranspose_mul_self_eq_one_of_isUnitaryMatrix hU)

/-- Conjugation `A ↦ UAUᴴ` by a unitary matrix, as a complex linear
equivalence of the full matrix space. -/
noncomputable def unitaryConjugationLinearEquiv
    (U : LocalMatrix 𝔽) (hU : IsUnitaryMatrix U) :
    LocalMatrix 𝔽 ≃ₗ[ℂ] LocalMatrix 𝔽 where
  toFun A := U * A * U.conjTranspose
  invFun A := U.conjTranspose * A * U
  left_inv A := by
    change U.conjTranspose * (U * A * U.conjTranspose) * U = A
    calc
      U.conjTranspose * (U * A * U.conjTranspose) * U =
          (U.conjTranspose * U) * A * (U.conjTranspose * U) := by
            noncomm_ring
      _ = A := by
        rw [conjTranspose_mul_self_eq_one_of_isUnitaryMatrix hU]
        simp
  right_inv A := by
    change U * (U.conjTranspose * A * U) * U.conjTranspose = A
    calc
      U * (U.conjTranspose * A * U) * U.conjTranspose =
          (U * U.conjTranspose) * A * (U * U.conjTranspose) := by
            noncomm_ring
      _ = A := by
        rw [self_mul_conjTranspose_eq_one_of_isUnitaryMatrix hU]
        simp
  map_add' A B := by
    simp [Matrix.mul_add, Matrix.add_mul]
  map_smul' z A := by
    simp

/-- In Weyl coordinates, unitary conjugation is an invertible complex
linear map on functions indexed by `𝔽 × 𝔽`. -/
noncomputable def unitaryConjugationWeylEquiv
    (w : WeylConvention 𝔽) (U : LocalMatrix 𝔽)
    (hU : IsUnitaryMatrix U) :
    (𝔽 × 𝔽 → ℂ) ≃ₗ[ℂ] (𝔽 × 𝔽 → ℂ) :=
  (weylCoordinateEquiv w).symm ≪≫ₗ
    unitaryConjugationLinearEquiv U hU ≪≫ₗ
      weylCoordinateEquiv w

/-- The Weyl-coordinate conjugation equivalence fixes the coordinate
vector of the identity matrix. -/
theorem unitaryConjugationWeylEquiv_identity
    (w : WeylConvention 𝔽) (U : LocalMatrix 𝔽)
    (hU : IsUnitaryMatrix U) :
    unitaryConjugationWeylEquiv w U hU (coordinateVector (0, 0) 1) =
      coordinateVector (0, 0) 1 := by
  classical
  rw [← weylCoordinateEquiv_weylMatrix w (0, 0)]
  simp [unitaryConjugationWeylEquiv, unitaryConjugationLinearEquiv,
    weylMatrix_zero_zero,
    self_mul_conjTranspose_eq_one_of_isUnitaryMatrix hU]

/-- A matrix has a nonzero coordinate vector in the Weyl basis exactly
when it lies on the corresponding Weyl matrix axis. -/
theorem weylCoordinate_axis_iff_sameMatrixAxis
    (w : WeylConvention 𝔽) (A : LocalMatrix 𝔽) (v : 𝔽 × 𝔽) :
    (∃ z, z ≠ 0 ∧
        weylCoordinateEquiv w A = coordinateVector v z) ↔
      SameMatrixAxis A (weylMatrix w v.1 v.2) := by
  classical
  constructor
  · rintro ⟨z, hz, hcoord⟩
    refine ⟨z, hz, ?_⟩
    apply (weylCoordinateEquiv w).injective
    rw [map_smul, weylCoordinateEquiv_weylMatrix]
    calc
      weylCoordinateEquiv w A = coordinateVector v z := hcoord
      _ = z • coordinateVector v 1 := by
        ext u
        simp [coordinateVector]
  · rintro ⟨z, hz, rfl⟩
    refine ⟨z, hz, ?_⟩
    rw [map_smul, weylCoordinateEquiv_weylMatrix]
    ext u
    simp [coordinateVector]

/-- If unitary conjugation carries every Weyl coordinate axis to a
coordinate axis, then the unitary is Clifford. -/
theorem isCliffordMatrix_of_weylCoordinate_axes
    (w : WeylConvention 𝔽) (U : LocalMatrix 𝔽)
    (hU : IsUnitaryMatrix U)
    (haxes :
      ∀ v : 𝔽 × 𝔽,
        IsNonzeroCoordinateAxis
          (unitaryConjugationWeylEquiv w U hU
            (coordinateVector v 1))) :
    IsCliffordMatrix w U := by
  refine ⟨hU, ?_⟩
  intro a b
  obtain ⟨v, z, hz, hv⟩ := haxes (a, b)
  have hin :
      (weylCoordinateEquiv w).symm (coordinateVector (a, b) 1) =
        weylMatrix w a b := by
    apply (weylCoordinateEquiv w).injective
    calc
      weylCoordinateEquiv w
          ((weylCoordinateEquiv w).symm (coordinateVector (a, b) 1)) =
          coordinateVector (a, b) 1 :=
        (weylCoordinateEquiv w).apply_symm_apply _
      _ = weylCoordinateEquiv w (weylMatrix w a b) :=
        (weylCoordinateEquiv_weylMatrix w (a, b)).symm
  change
    weylCoordinateEquiv w
        (U * (weylCoordinateEquiv w).symm
          (coordinateVector (a, b) 1) * U.conjTranspose) =
      coordinateVector v z at hv
  rw [hin] at hv
  refine ⟨v.1, v.2, ?_⟩
  rw [← weylCoordinate_axis_iff_sameMatrixAxis]
  refine ⟨z, hz, ?_⟩
  simpa [unitaryConjugationWeylEquiv, unitaryConjugationLinearEquiv,
    matrixProduct] using hv

end RelativeConicArcs.AMELU
