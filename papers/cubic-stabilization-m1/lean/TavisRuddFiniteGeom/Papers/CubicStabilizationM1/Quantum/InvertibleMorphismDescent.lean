import Mathlib.Tactic
import Mathlib.Algebra.MvPolynomial.Funext
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic

/-!
# Descent of an invertible element in a matrix morphism space

For a finite family of matrices over an infinite field, the determinant of
its generic linear combination is a multivariate polynomial. If a linear
combination becomes invertible after coefficient extension, this polynomial
is nonzero, hence some linear combination over the original field already
has nonzero determinant. Applied to a basis of a rational Hodge-morphism
space, this gives rational descent once the geometric scalar-extension
identification of that morphism space is supplied.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum

/-- The determinant polynomial on the span of a finite matrix family. -/
noncomputable def matrixCombinationDeterminant
    {K ι n : Type*} [CommRing K] [Fintype ι] [Fintype n] [DecidableEq n]
    (family : ι → Matrix n n K) : MvPolynomial ι K :=
  Matrix.det (fun i j => ∑ t, MvPolynomial.C (family t i j) * MvPolynomial.X t)

/-- Evaluation of the determinant polynomial is exactly the determinant of
the corresponding scalar-extended linear combination. -/
theorem matrixCombinationDeterminant_eval
    {K L ι n : Type*} [CommRing K] [CommRing L] [Fintype ι] [Fintype n] [DecidableEq n]
    (family : ι → Matrix n n K) (extension : K →+* L) (coefficient : ι → L) :
    MvPolynomial.eval₂Hom extension coefficient (matrixCombinationDeterminant family) =
      (∑ t, coefficient t • (family t).map extension).det := by
  unfold matrixCombinationDeterminant
  rw [RingHom.map_det]
  congr 1
  ext i j
  simp [Matrix.map_apply, Matrix.sum_apply, Matrix.smul_apply, mul_comm]

/-- An invertible scalar-extended combination forces an invertible combination
over the original infinite field. The conclusion exhibits original-field
coefficients, not only a nonzero determinant polynomial. -/
theorem exists_invertible_matrixCombination_over_base
    {K L ι n : Type*} [Field K] [Infinite K] [CommRing L]
    [Fintype ι] [Fintype n] [DecidableEq n]
    (family : ι → Matrix n n K) (extension : K →+* L)
    (extendedCoefficient : ι → L)
    (extendedInvertible : (∑ t, extendedCoefficient t • (family t).map extension).det ≠ 0) :
    ∃ coefficient : ι → K, (∑ t, coefficient t • family t).det ≠ 0 := by
  classical
  by_contra none
  have vanish : ∀ coefficient : ι → K, (∑ t, coefficient t • family t).det=0 := by
    simpa only [not_exists, not_not] using none
  have polynomialZero : matrixCombinationDeterminant family=0 := by
    apply MvPolynomial.funext
    intro coefficient
    have h := matrixCombinationDeterminant_eval family (RingHom.id K) coefficient
    simpa [vanish coefficient] using h
  have h := matrixCombinationDeterminant_eval family extension extendedCoefficient
  rw [polynomialZero, map_zero] at h
  exact extendedInvertible h.symm

/-- Invertibility descends inside an actual linear subspace of matrices when
the extended invertible matrix is expressed using finitely many of its members. -/
theorem matrixMorphismSubspace_contains_invertible
    {K L ι n : Type*} [Field K] [Infinite K] [CommRing L]
    [Fintype ι] [Fintype n] [DecidableEq n]
    (morphisms : Submodule K (Matrix n n K))
    (family : ι → Matrix n n K) (members : ∀ t, family t ∈ morphisms)
    (extension : K →+* L) (extendedCoefficient : ι → L)
    (extendedInvertible : (∑ t, extendedCoefficient t • (family t).map extension).det ≠ 0) :
    ∃ matrix ∈ morphisms, matrix.det ≠ 0 := by
  obtain ⟨coefficient,invertible⟩ := exists_invertible_matrixCombination_over_base
    family extension extendedCoefficient extendedInvertible
  exact ⟨∑ t, coefficient t • family t,
    Submodule.sum_mem _ (fun t _ => morphisms.smul_mem _ (members t)),invertible⟩

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum
