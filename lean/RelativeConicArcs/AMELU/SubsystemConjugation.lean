import RelativeConicArcs.AMELU.SubsystemWeylBasis

/-!
# Product conjugation in subsystem Weyl coordinates

Tensor products of local matrices multiply and conjugate componentwise.
Consequently, conjugation by a product unitary acts on the product-Weyl
coordinate basis as the independent tensor product of the local
Weyl-coordinate conjugation maps.

All arguments are symbolic and kernel checked.  The module contains no
generated data, native evaluation, axioms, or admitted declarations.
-/

namespace RelativeConicArcs.AMELU

open scoped ComplexConjugate
open Finset Matrix

variable {𝔽 : Type*} [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽]

/-- Tensor product of local matrices on a finite subsystem. -/
def subsystemTensorMatrix (S : Finset Party)
    (A : S → LocalMatrix 𝔽) : SubsystemMatrix 𝔽 S :=
  fun y x => ∏ i : S, A i (y i) (x i)

omit [Field 𝔽] [DecidableEq 𝔽] in
/-- Tensor products multiply componentwise. -/
theorem subsystemTensorMatrix_mul
    (S : Finset Party) (A B : S → LocalMatrix 𝔽) :
    subsystemTensorMatrix S A * subsystemTensorMatrix S B =
      subsystemTensorMatrix S (fun i => A i * B i) := by
  classical
  ext y x
  rw [Matrix.mul_apply]
  change
    (∑ z : S → 𝔽,
      (∏ i : S, A i (y i) (z i)) *
        ∏ i : S, B i (z i) (x i)) =
      ∏ i : S, (A i * B i) (y i) (x i)
  rw [show
      (∑ z : S → 𝔽,
        (∏ i : S, A i (y i) (z i)) *
          ∏ i : S, B i (z i) (x i)) =
        ∑ z : S → 𝔽,
          ∏ i : S, A i (y i) (z i) * B i (z i) (x i) by
            apply Finset.sum_congr rfl
            intro z _
            rw [Finset.prod_mul_distrib]]
  let f : ∀ i : S, 𝔽 → ℂ :=
    fun i z => A i (y i) z * B i z (x i)
  change
    (∑ z : S → 𝔽, ∏ i : S, f i (z i)) =
      ∏ i : S, ∑ z : 𝔽, f i z
  rw [← Fintype.prod_sum]

omit [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽] in
/-- Conjugate transpose of a tensor product is componentwise. -/
theorem subsystemTensorMatrix_conjTranspose
    (S : Finset Party) (A : S → LocalMatrix 𝔽) :
    (subsystemTensorMatrix S A).conjTranspose =
      subsystemTensorMatrix S (fun i => (A i).conjTranspose) := by
  classical
  ext y x
  simp [subsystemTensorMatrix, Matrix.conjTranspose_apply]

omit [Field 𝔽] in
/-- A tensor product of unitary local matrices is unitary. -/
theorem subsystemTensorMatrix_isUnitary
    (S : Finset Party) (U : S → LocalMatrix 𝔽)
    (hU : ∀ i, IsUnitaryMatrix (U i)) :
    IsUnitaryMatrix (subsystemTensorMatrix S U) := by
  intro x y
  rw [show
      (∑ z : S → 𝔽,
        conj (subsystemTensorMatrix S U z x) *
          subsystemTensorMatrix S U z y) =
        ∑ z : S → 𝔽,
          ∏ i : S, conj (U i (z i) (x i)) * U i (z i) (y i) by
            apply Finset.sum_congr rfl
            intro z _
            simp [subsystemTensorMatrix, map_prod,
              Finset.prod_mul_distrib]]
  let f : ∀ i : S, 𝔽 → ℂ :=
    fun i z => conj (U i z (x i)) * U i z (y i)
  change
    (∑ z : S → 𝔽, ∏ i : S, f i (z i)) =
      if x = y then 1 else 0
  rw [← Fintype.prod_sum]
  have hlocal :
      ∀ i : S, (∑ z : 𝔽, f i z) =
        if x i = y i then 1 else 0 := by
    intro i
    exact hU i (x i) (y i)
  simp_rw [hlocal]
  by_cases hxy : x = y
  · subst y
    simp
  · rw [if_neg hxy]
    have hpoint : ∃ i : S, x i ≠ y i := by
      by_contra hpoint
      push Not at hpoint
      exact hxy (funext hpoint)
    obtain ⟨i, hi⟩ := hpoint
    rw [Finset.prod_eq_zero (Finset.mem_univ i) (if_neg hi)]

omit [Fintype 𝔽] in
/-- Product-Weyl matrices are tensor products of the local Weyl
matrices. -/
theorem subsystemWeylMatrix_eq_tensor
    (w : WeylConvention 𝔽) (S : Finset Party)
    (v : S → 𝔽 × 𝔽) :
    subsystemWeylMatrix w S v =
      subsystemTensorMatrix S
        (fun i => weylMatrix w (v i).1 (v i).2) :=
  rfl

/-- Conjugation of a product Weyl matrix is the tensor product of the
local conjugates. -/
theorem subsystemTensor_conjugation_weylMatrix
    (w : WeylConvention 𝔽) (S : Finset Party)
    (U : S → LocalMatrix 𝔽) (v : S → 𝔽 × 𝔽) :
    subsystemTensorMatrix S U * subsystemWeylMatrix w S v *
        (subsystemTensorMatrix S U).conjTranspose =
      subsystemTensorMatrix S
        (fun i => U i * weylMatrix w (v i).1 (v i).2 *
          (U i).conjTranspose) := by
  rw [subsystemWeylMatrix_eq_tensor,
    subsystemTensorMatrix_conjTranspose,
    subsystemTensorMatrix_mul, subsystemTensorMatrix_mul]

omit [DecidableEq 𝔽] in
/-- The subsystem product-Weyl functional factors on a tensor product
of local matrices. -/
theorem subsystemWeylFunctional_tensor
    (w : WeylConvention 𝔽) (S : Finset Party)
    (v : S → 𝔽 × 𝔽) (A : S → LocalMatrix 𝔽) :
    subsystemWeylFunctional w S v (subsystemTensorMatrix S A) =
      ∏ i : S,
        ((Fintype.card 𝔽 : ℂ)⁻¹ *
          weylFourierFunctional w (v i).1 (v i).2 (A i)) := by
  classical
  change
    ((Fintype.card 𝔽 : ℂ) ^ S.card)⁻¹ *
        (∑ x : S → 𝔽,
          (∏ i : S, w.character (-(v i).2 * x i)) *
            ∏ i : S, A i (x i + (v i).1) (x i)) =
      ∏ i : S,
        ((Fintype.card 𝔽 : ℂ)⁻¹ *
          ∑ z : 𝔽,
            w.character (-(v i).2 * z) *
              A i (z + (v i).1) z)
  rw [show
      (∑ x : S → 𝔽,
        (∏ i : S, w.character (-(v i).2 * x i)) *
          ∏ i : S, A i (x i + (v i).1) (x i)) =
        ∑ x : S → 𝔽,
          ∏ i : S,
            (w.character (-(v i).2 * x i) *
              A i (x i + (v i).1) (x i)) by
          apply Finset.sum_congr rfl
          intro x _
          rw [Finset.prod_mul_distrib]]
  let f : ∀ i : S, 𝔽 → ℂ :=
    fun i z =>
      w.character (-(v i).2 * z) *
        A i (z + (v i).1) z
  change
    ((Fintype.card 𝔽 : ℂ) ^ S.card)⁻¹ *
        (∑ x : S → 𝔽, ∏ i : S, f i (x i)) =
      ∏ i : S,
        ((Fintype.card 𝔽 : ℂ)⁻¹ * ∑ z : 𝔽, f i z)
  rw [← Fintype.prod_sum]
  rw [Finset.prod_mul_distrib]
  have hcard :
      ∏ _i : S, ((Fintype.card 𝔽 : ℂ)⁻¹) =
        ((Fintype.card 𝔽 : ℂ) ^ S.card)⁻¹ := by
    simp [Finset.prod_const]
  rw [hcard]

/-- Product-unitary conjugation as an equivalence on subsystem matrices. -/
noncomputable def subsystemUnitaryConjugationEquiv
    (S : Finset Party) (U : S → LocalMatrix 𝔽)
    (hU : ∀ i, IsUnitaryMatrix (U i)) :
    SubsystemMatrix 𝔽 S ≃ₗ[ℂ] SubsystemMatrix 𝔽 S :=
  unitaryConjugationLinearEquiv (subsystemTensorMatrix S U)
    (subsystemTensorMatrix_isUnitary S U hU)

/-- Product-unitary conjugation as an equivalence on subsystem
product-Weyl coordinates. -/
noncomputable def subsystemUnitaryConjugationWeylEquiv
    (w : WeylConvention 𝔽) (S : Finset Party)
    (U : S → LocalMatrix 𝔽) (hU : ∀ i, IsUnitaryMatrix (U i)) :
    ((S → 𝔽 × 𝔽) → ℂ) ≃ₗ[ℂ] ((S → 𝔽 × 𝔽) → ℂ) :=
  (subsystemWeylCoordinateEquiv w S).symm ≪≫ₗ
    subsystemUnitaryConjugationEquiv S U hU ≪≫ₗ
      subsystemWeylCoordinateEquiv w S

/-- On a product-Weyl coordinate vector, product conjugation has the
product of the four local coordinate amplitudes. -/
theorem subsystemUnitaryConjugationWeylEquiv_coordinateVector
    (w : WeylConvention 𝔽) (S : Finset Party)
    (U : S → LocalMatrix 𝔽) (hU : ∀ i, IsUnitaryMatrix (U i))
    (v u : S → 𝔽 × 𝔽) :
    subsystemUnitaryConjugationWeylEquiv w S U hU
        (coordinateVector v 1) u =
      ∏ i : S,
        unitaryConjugationWeylEquiv w (U i) (hU i)
          (coordinateVector (v i) 1) (u i) := by
  classical
  have hin :
      (subsystemWeylCoordinateEquiv w S).symm
          (coordinateVector v 1) =
        subsystemWeylMatrix w S v := by
    apply (subsystemWeylCoordinateEquiv w S).injective
    rw [(subsystemWeylCoordinateEquiv w S).apply_symm_apply]
    symm
    ext t
    rw [subsystemWeylCoordinateEquiv_apply,
      subsystemWeylFunctional_subsystemWeylMatrix]
    simp [coordinateVector, eq_comm]
  change
    subsystemWeylCoordinateEquiv w S
        (subsystemTensorMatrix S U *
          (subsystemWeylCoordinateEquiv w S).symm
            (coordinateVector v 1) *
          (subsystemTensorMatrix S U).conjTranspose) u = _
  rw [hin, subsystemTensor_conjugation_weylMatrix,
    subsystemWeylCoordinateEquiv_apply,
    subsystemWeylFunctional_tensor]
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
  have hfunctional :
      (Fintype.card 𝔽 : ℂ)⁻¹ *
          weylFourierFunctional w (u i).1 (u i).2
            (U i * weylMatrix w (v i).1 (v i).2 *
              (U i).conjTranspose) =
        weylCoordinateEquiv w
          (U i * weylMatrix w (v i).1 (v i).2 *
            (U i).conjTranspose) (u i) := by
    exact (weylCoordinateEquiv_apply w
      (U i * weylMatrix w (v i).1 (v i).2 *
        (U i).conjTranspose) (u i)).symm
  exact hfunctional

end RelativeConicArcs.AMELU
