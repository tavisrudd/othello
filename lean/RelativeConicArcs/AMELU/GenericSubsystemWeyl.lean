import RelativeConicArcs.AMELU.GenericMarginal
import RelativeConicArcs.AMELU.PartialTraceCovariance
import Mathlib.LinearAlgebra.FiniteDimensional.Lemmas

/-!
# Product Weyl coordinates on arbitrary finite party sets

Product Weyl matrices form a basis of the operator space on a finite family
of qudits.  In these coordinates, conjugation by a tensor product of local
unitaries is the tensor product of the corresponding one-qudit coordinate
maps.  The index type is arbitrary, so the construction applies to every
retained `(m+1)`-set.

All arguments are symbolic and kernel checked.  The module contains no
generated data, native evaluation, axioms, or admitted declarations.
-/

namespace RelativeConicArcs.AMELU

open scoped ComplexConjugate
open Finset Matrix Module

variable {𝔽 : Type*} [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽]
variable {ι : Type*} [Fintype ι] [DecidableEq ι]

/-- Matrices on the computational basis of a finite family of qudits. -/
abbrev FiniteProductMatrix (𝔽 : Type*) (ι : Type*) :=
  Matrix (ι → 𝔽) (ι → 𝔽) ℂ

/-- Tensor product of a finite family of local matrices. -/
def finiteProductTensorMatrix
    (A : ι → LocalMatrix 𝔽) : FiniteProductMatrix 𝔽 ι :=
  fun y x => ∏ i, A i (y i) (x i)

/-- Product Weyl matrix on a finite family of qudits. -/
def finiteProductWeylMatrix
    (w : WeylConvention 𝔽) (v : ι → 𝔽 × 𝔽) :
    FiniteProductMatrix 𝔽 ι :=
  finiteProductTensorMatrix
    (fun i => weylMatrix w (v i).1 (v i).2)

/-- Normalized coordinate functional for the product Weyl basis. -/
noncomputable def finiteProductWeylFunctional
    (w : WeylConvention 𝔽) (v : ι → 𝔽 × 𝔽) :
    FiniteProductMatrix 𝔽 ι →ₗ[ℂ] ℂ where
  toFun M :=
    ((Fintype.card 𝔽 : ℂ) ^ Fintype.card ι)⁻¹ *
      ∑ x : ι → 𝔽,
        (∏ i, w.character (-(v i).2 * x i)) *
          M (fun i => x i + (v i).1) x
  map_add' A B := by
    simp [mul_add, Finset.sum_add_distrib]
  map_smul' z A := by
    simp only [RingHom.id_apply, smul_eq_mul, Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro x _
    rw [show
      (z • A) (fun i => x i + (v i).1) x =
        z * A (fun i => x i + (v i).1) x by rfl]
    ring

/-- The product Weyl functional isolates one product Weyl matrix. -/
theorem finiteProductWeylFunctional_weylMatrix
    (w : WeylConvention 𝔽) (v u : ι → 𝔽 × 𝔽) :
    finiteProductWeylFunctional w v (finiteProductWeylMatrix w u) =
      if v = u then 1 else 0 := by
  classical
  change
    ((Fintype.card 𝔽 : ℂ) ^ Fintype.card ι)⁻¹ *
      (∑ x : ι → 𝔽,
        (∏ i, w.character (-(v i).2 * x i)) *
          ∏ i,
            weylMatrix w (u i).1 (u i).2
              (x i + (v i).1) (x i)) =
      if v = u then 1 else 0
  rw [show
      (∑ x : ι → 𝔽,
        (∏ i, w.character (-(v i).2 * x i)) *
          ∏ i,
            weylMatrix w (u i).1 (u i).2
              (x i + (v i).1) (x i)) =
        ∑ x : ι → 𝔽,
          ∏ i,
            (w.character (-(v i).2 * x i) *
              weylMatrix w (u i).1 (u i).2
                (x i + (v i).1) (x i)) by
          apply Finset.sum_congr rfl
          intro x _
          rw [Finset.prod_mul_distrib]]
  let f : ∀ i : ι, 𝔽 → ℂ :=
    fun i z =>
      w.character (-(v i).2 * z) *
        weylMatrix w (u i).1 (u i).2 (z + (v i).1) z
  change
    ((Fintype.card 𝔽 : ℂ) ^ Fintype.card ι)⁻¹ *
        (∑ x : ι → 𝔽, ∏ i, f i (x i)) =
      if v = u then 1 else 0
  rw [← Fintype.prod_sum]
  have hlocal : ∀ i : ι,
      (∑ z : 𝔽, f i z) =
        if v i = u i then (Fintype.card 𝔽 : ℂ) else 0 := by
    intro i
    change
      weylFourierFunctional w (v i).1 (v i).2
          (weylMatrix w (u i).1 (u i).2) =
        if v i = u i then (Fintype.card 𝔽 : ℂ) else 0
    simpa [Prod.ext_iff] using
      weylFourierFunctional_weylMatrix w
        (v i).1 (v i).2 (u i).1 (u i).2
  simp_rw [hlocal]
  by_cases hvu : v = u
  · subst u
    simp
  · rw [if_neg hvu]
    obtain ⟨i, hi⟩ : ∃ i : ι, v i ≠ u i := by
      by_contra hpoint
      push Not at hpoint
      exact hvu (funext hpoint)
    rw [Finset.prod_eq_zero (Finset.mem_univ i) (if_neg hi)]
    simp

/-- Product Weyl matrices are linearly independent. -/
theorem finiteProductWeylMatrix_linearIndependent
    (w : WeylConvention 𝔽) :
    LinearIndependent ℂ (finiteProductWeylMatrix (ι := ι) w) := by
  classical
  rw [Fintype.linearIndependent_iff]
  intro g hsum v
  have hzero :=
    congrArg (fun M => finiteProductWeylFunctional w v M) hsum
  simp only [map_sum, map_smul, map_zero] at hzero
  simp_rw [finiteProductWeylFunctional_weylMatrix] at hzero
  simpa using hzero

/-- Product Weyl matrices form a basis of the full operator space. -/
noncomputable def finiteProductWeylBasis
    (w : WeylConvention 𝔽) :
    Basis (ι → 𝔽 × 𝔽) ℂ (FiniteProductMatrix 𝔽 ι) :=
  basisOfLinearIndependentOfCardEqFinrank
    (finiteProductWeylMatrix_linearIndependent w) (by
      simp [FiniteProductMatrix, Module.finrank_matrix, Fintype.card_prod]
      ring)

@[simp]
theorem finiteProductWeylBasis_apply
    (w : WeylConvention 𝔽) (v : ι → 𝔽 × 𝔽) :
    finiteProductWeylBasis w v = finiteProductWeylMatrix w v := by
  classical
  rw [finiteProductWeylBasis,
    coe_basisOfLinearIndependentOfCardEqFinrank]

/-- Product-Weyl coordinates of an operator on a finite family. -/
noncomputable def finiteProductWeylCoordinateEquiv
    (w : WeylConvention 𝔽) :
    FiniteProductMatrix 𝔽 ι ≃ₗ[ℂ] ((ι → 𝔽 × 𝔽) → ℂ) :=
  (finiteProductWeylBasis w).repr ≪≫ₗ
    Finsupp.linearEquivFunOnFinite ℂ ℂ (ι → 𝔽 × 𝔽)

/-- A product-Weyl coordinate is the normalized shifted-diagonal
Fourier functional. -/
theorem finiteProductWeylCoordinateEquiv_apply
    (w : WeylConvention 𝔽) (M : FiniteProductMatrix 𝔽 ι)
    (v : ι → 𝔽 × 𝔽) :
    finiteProductWeylCoordinateEquiv w M v =
      finiteProductWeylFunctional w v M := by
  classical
  change (finiteProductWeylBasis w).repr M v =
    finiteProductWeylFunctional w v M
  symm
  calc
    _ = finiteProductWeylFunctional w v
        (∑ u, (finiteProductWeylBasis w).repr M u •
          finiteProductWeylBasis w u) := by
            rw [(finiteProductWeylBasis w).sum_repr]
    _ = ∑ u, (finiteProductWeylBasis w).repr M u *
        finiteProductWeylFunctional w v
          (finiteProductWeylBasis w u) := by simp
    _ = (finiteProductWeylBasis w).repr M v := by
      rw [Fintype.sum_eq_single v]
      · rw [finiteProductWeylBasis_apply,
          finiteProductWeylFunctional_weylMatrix]
        simp
      · intro u huv
        rw [finiteProductWeylBasis_apply,
          finiteProductWeylFunctional_weylMatrix, if_neg]
        simp
        exact Ne.symm huv

omit [Field 𝔽] [DecidableEq 𝔽] in
/-- Tensor products multiply componentwise. -/
theorem finiteProductTensorMatrix_mul
    (A B : ι → LocalMatrix 𝔽) :
    finiteProductTensorMatrix A * finiteProductTensorMatrix B =
      finiteProductTensorMatrix (fun i => A i * B i) := by
  classical
  ext y x
  rw [Matrix.mul_apply]
  change
    (∑ z : ι → 𝔽,
      (∏ i, A i (y i) (z i)) * ∏ i, B i (z i) (x i)) =
      ∏ i, (A i * B i) (y i) (x i)
  rw [show
      (∑ z : ι → 𝔽,
        (∏ i, A i (y i) (z i)) * ∏ i, B i (z i) (x i)) =
        ∑ z : ι → 𝔽,
          ∏ i, A i (y i) (z i) * B i (z i) (x i) by
            apply Finset.sum_congr rfl
            intro z _
            rw [Finset.prod_mul_distrib]]
  let f : ∀ i : ι, 𝔽 → ℂ :=
    fun i z => A i (y i) z * B i z (x i)
  change
    (∑ z : ι → 𝔽, ∏ i, f i (z i)) =
      ∏ i, ∑ z : 𝔽, f i z
  rw [← Fintype.prod_sum]

omit [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽] [DecidableEq ι] in
/-- Conjugate transpose of a finite tensor product is componentwise. -/
theorem finiteProductTensorMatrix_conjTranspose
    (A : ι → LocalMatrix 𝔽) :
    (finiteProductTensorMatrix A).conjTranspose =
      finiteProductTensorMatrix (fun i => (A i).conjTranspose) := by
  classical
  ext y x
  simp [finiteProductTensorMatrix, Matrix.conjTranspose_apply]

omit [Field 𝔽] in
/-- A tensor product of unitary local matrices is unitary. -/
theorem finiteProductTensorMatrix_isUnitary
    (U : ι → LocalMatrix 𝔽) (hU : ∀ i, IsUnitaryMatrix (U i)) :
    IsUnitaryMatrix (finiteProductTensorMatrix U) := by
  intro x y
  rw [show
      (∑ z,
        conj (finiteProductTensorMatrix U z x) *
          finiteProductTensorMatrix U z y) =
        ∑ z : ι → 𝔽,
          ∏ i, conj (U i (z i) (x i)) * U i (z i) (y i) by
            apply Finset.sum_congr rfl
            intro z _
            simp [finiteProductTensorMatrix, map_prod,
              Finset.prod_mul_distrib]]
  let f : ∀ i : ι, 𝔽 → ℂ :=
    fun i z => conj (U i z (x i)) * U i z (y i)
  change
    (∑ z : ι → 𝔽, ∏ i, f i (z i)) =
      if x = y then 1 else 0
  rw [← Fintype.prod_sum]
  have hlocal : ∀ i : ι,
      (∑ z : 𝔽, f i z) = if x i = y i then 1 else 0 := by
    intro i
    exact hU i (x i) (y i)
  simp_rw [hlocal]
  by_cases hxy : x = y
  · subst y
    simp
  · rw [if_neg hxy]
    obtain ⟨i, hi⟩ : ∃ i, x i ≠ y i := by
      by_contra hpoint
      push Not at hpoint
      exact hxy (funext hpoint)
    rw [Finset.prod_eq_zero (Finset.mem_univ i) (if_neg hi)]

/-- Conjugation of a product Weyl matrix is the tensor product of the local
conjugates. -/
theorem finiteProductTensor_conjugation_weylMatrix
    (w : WeylConvention 𝔽) (U : ι → LocalMatrix 𝔽)
    (v : ι → 𝔽 × 𝔽) :
    finiteProductTensorMatrix U * finiteProductWeylMatrix w v *
        (finiteProductTensorMatrix U).conjTranspose =
      finiteProductTensorMatrix
        (fun i => U i * weylMatrix w (v i).1 (v i).2 *
          (U i).conjTranspose) := by
  rw [finiteProductWeylMatrix, finiteProductTensorMatrix_conjTranspose,
    finiteProductTensorMatrix_mul, finiteProductTensorMatrix_mul]

omit [DecidableEq 𝔽] in
/-- The product-Weyl functional factors on a tensor product of local
matrices. -/
theorem finiteProductWeylFunctional_tensor
    (w : WeylConvention 𝔽) (v : ι → 𝔽 × 𝔽)
    (A : ι → LocalMatrix 𝔽) :
    finiteProductWeylFunctional w v (finiteProductTensorMatrix A) =
      ∏ i,
        ((Fintype.card 𝔽 : ℂ)⁻¹ *
          weylFourierFunctional w (v i).1 (v i).2 (A i)) := by
  classical
  change
    ((Fintype.card 𝔽 : ℂ) ^ Fintype.card ι)⁻¹ *
        (∑ x : ι → 𝔽,
          (∏ i, w.character (-(v i).2 * x i)) *
            ∏ i, A i (x i + (v i).1) (x i)) =
      ∏ i,
        ((Fintype.card 𝔽 : ℂ)⁻¹ *
          ∑ z : 𝔽,
            w.character (-(v i).2 * z) *
              A i (z + (v i).1) z)
  rw [show
      (∑ x : ι → 𝔽,
        (∏ i, w.character (-(v i).2 * x i)) *
          ∏ i, A i (x i + (v i).1) (x i)) =
        ∑ x : ι → 𝔽,
          ∏ i,
            (w.character (-(v i).2 * x i) *
              A i (x i + (v i).1) (x i)) by
          apply Finset.sum_congr rfl
          intro x _
          rw [Finset.prod_mul_distrib]]
  let f : ∀ i : ι, 𝔽 → ℂ :=
    fun i z =>
      w.character (-(v i).2 * z) *
        A i (z + (v i).1) z
  change
    ((Fintype.card 𝔽 : ℂ) ^ Fintype.card ι)⁻¹ *
        (∑ x : ι → 𝔽, ∏ i, f i (x i)) =
      ∏ i, ((Fintype.card 𝔽 : ℂ)⁻¹ * ∑ z : 𝔽, f i z)
  rw [← Fintype.prod_sum, Finset.prod_mul_distrib]
  simp [Finset.prod_const]

/-- Product-unitary conjugation as a linear equivalence on finite-product
operator matrices. -/
noncomputable def finiteProductUnitaryConjugationEquiv
    (U : ι → LocalMatrix 𝔽) (hU : ∀ i, IsUnitaryMatrix (U i)) :
    FiniteProductMatrix 𝔽 ι ≃ₗ[ℂ] FiniteProductMatrix 𝔽 ι :=
  unitaryConjugationLinearEquiv (finiteProductTensorMatrix U)
    (finiteProductTensorMatrix_isUnitary U hU)

/-- Product-unitary conjugation transported to product-Weyl coordinates. -/
noncomputable def finiteProductUnitaryConjugationWeylEquiv
    (w : WeylConvention 𝔽)
    (U : ι → LocalMatrix 𝔽) (hU : ∀ i, IsUnitaryMatrix (U i)) :
    ((ι → 𝔽 × 𝔽) → ℂ) ≃ₗ[ℂ] ((ι → 𝔽 × 𝔽) → ℂ) :=
  (finiteProductWeylCoordinateEquiv w).symm ≪≫ₗ
    finiteProductUnitaryConjugationEquiv U hU ≪≫ₗ
      finiteProductWeylCoordinateEquiv w

/-- On a product-Weyl coordinate vector, product conjugation factors into
the local one-qudit coordinate amplitudes. -/
theorem finiteProductUnitaryConjugationWeylEquiv_coordinateVector
    (w : WeylConvention 𝔽)
    (U : ι → LocalMatrix 𝔽) (hU : ∀ i, IsUnitaryMatrix (U i))
    (v u : ι → 𝔽 × 𝔽) :
    finiteProductUnitaryConjugationWeylEquiv w U hU
        (coordinateVector v 1) u =
      ∏ i,
        unitaryConjugationWeylEquiv w (U i) (hU i)
          (coordinateVector (v i) 1) (u i) := by
  classical
  have hin :
      (finiteProductWeylCoordinateEquiv w).symm
          (coordinateVector v 1) =
        finiteProductWeylMatrix w v := by
    apply (finiteProductWeylCoordinateEquiv w).injective
    rw [(finiteProductWeylCoordinateEquiv w).apply_symm_apply]
    symm
    ext t
    rw [finiteProductWeylCoordinateEquiv_apply,
      finiteProductWeylFunctional_weylMatrix]
    simp [coordinateVector, eq_comm]
  change
    finiteProductWeylCoordinateEquiv w
        (finiteProductTensorMatrix U *
          (finiteProductWeylCoordinateEquiv w).symm
            (coordinateVector v 1) *
          (finiteProductTensorMatrix U).conjTranspose) u = _
  rw [hin, finiteProductTensor_conjugation_weylMatrix,
    finiteProductWeylCoordinateEquiv_apply,
    finiteProductWeylFunctional_tensor]
  apply Finset.prod_congr rfl
  intro i _
  rw [unitaryConjugationWeylEquiv]
  change
    (Fintype.card 𝔽 : ℂ)⁻¹ *
        weylFourierFunctional w (u i).1 (u i).2
          (U i * weylMatrix w (v i).1 (v i).2 *
            (U i).conjTranspose) =
      weylCoordinateEquiv w
        (U i * (weylCoordinateEquiv w).symm
            (coordinateVector (v i) 1) *
          (U i).conjTranspose) (u i)
  have hlocalIn :
      (weylCoordinateEquiv w).symm
          (coordinateVector (v i) 1) =
        weylMatrix w (v i).1 (v i).2 := by
    apply (weylCoordinateEquiv w).injective
    rw [(weylCoordinateEquiv w).apply_symm_apply,
      weylCoordinateEquiv_weylMatrix]
  rw [hlocalIn]
  exact (weylCoordinateEquiv_apply w
    (U i * weylMatrix w (v i).1 (v i).2 *
      (U i).conjTranspose) (u i)).symm

end RelativeConicArcs.AMELU
