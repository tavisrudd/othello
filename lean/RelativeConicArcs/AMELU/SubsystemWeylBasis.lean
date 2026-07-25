import RelativeConicArcs.AMELU.MarginalWeylExpansion
import Mathlib.LinearAlgebra.FiniteDimensional.Lemmas

/-!
# Product Weyl bases on finite subsystems

The product of the single-party Weyl bases is a basis of the matrix
space on any finite subsystem.  Its coordinate functional is the
multivariate shifted-diagonal Fourier transform used by
`marginalWeylCoefficient`.

All arguments are symbolic and kernel checked.  The module contains no
generated data, native evaluation, axioms, or admitted declarations.
-/

namespace RelativeConicArcs.AMELU

open Finset Matrix Module

variable {𝔽 : Type*} [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽]

/-- Matrices on the computational basis of a finite party subsystem. -/
abbrev SubsystemMatrix (𝔽 : Type*) (S : Finset Party) :=
  Matrix (S → 𝔽) (S → 𝔽) ℂ

/-- Product Weyl matrix on a subsystem. -/
def subsystemWeylMatrix (w : WeylConvention 𝔽) (S : Finset Party)
    (v : S → 𝔽 × 𝔽) : SubsystemMatrix 𝔽 S :=
  fun y x => ∏ i : S, weylMatrix w (v i).1 (v i).2 (y i) (x i)

/-- Normalized product-Weyl coordinate functional. -/
noncomputable def subsystemWeylFunctional
    (w : WeylConvention 𝔽) (S : Finset Party)
    (v : S → 𝔽 × 𝔽) : SubsystemMatrix 𝔽 S →ₗ[ℂ] ℂ where
  toFun M :=
    ((Fintype.card 𝔽 : ℂ) ^ S.card)⁻¹ *
      ∑ x : S → 𝔽,
        (∏ i : S, w.character (-(v i).2 * x i)) *
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

/-- The subsystem Fourier functional isolates one product Weyl matrix. -/
theorem subsystemWeylFunctional_subsystemWeylMatrix
    (w : WeylConvention 𝔽) (S : Finset Party)
    (v u : S → 𝔽 × 𝔽) :
    subsystemWeylFunctional w S v (subsystemWeylMatrix w S u) =
      if v = u then 1 else 0 := by
  classical
  change
    ((Fintype.card 𝔽 : ℂ) ^ S.card)⁻¹ *
      (∑ x : S → 𝔽,
        (∏ i : S, w.character (-(v i).2 * x i)) *
          ∏ i : S,
            weylMatrix w (u i).1 (u i).2
              (x i + (v i).1) (x i)) =
      if v = u then 1 else 0
  rw [show
      (∑ x : S → 𝔽,
        (∏ i : S, w.character (-(v i).2 * x i)) *
          ∏ i : S,
            weylMatrix w (u i).1 (u i).2
              (x i + (v i).1) (x i)) =
        ∑ x : S → 𝔽,
          ∏ i : S,
            (w.character (-(v i).2 * x i) *
              weylMatrix w (u i).1 (u i).2
                (x i + (v i).1) (x i)) by
          apply Finset.sum_congr rfl
          intro x _
          rw [Finset.prod_mul_distrib]]
  let f : ∀ i : S, 𝔽 → ℂ :=
    fun i z =>
      w.character (-(v i).2 * z) *
        weylMatrix w (u i).1 (u i).2 (z + (v i).1) z
  change
    ((Fintype.card 𝔽 : ℂ) ^ S.card)⁻¹ *
        (∑ x : S → 𝔽, ∏ i : S, f i (x i)) =
      if v = u then 1 else 0
  rw [← Fintype.prod_sum]
  have hlocal : ∀ i : S,
      (∑ z : 𝔽,
        f i z) =
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
    have hpoint : ∃ i : S, v i ≠ u i := by
      by_contra hpoint
      push Not at hpoint
      exact hvu (funext hpoint)
    obtain ⟨i, hi⟩ := hpoint
    rw [Finset.prod_eq_zero (Finset.mem_univ i) (if_neg hi)]
    simp

/-- Product Weyl matrices on a subsystem are linearly independent. -/
theorem subsystemWeylMatrix_linearIndependent
    (w : WeylConvention 𝔽) (S : Finset Party) :
    LinearIndependent ℂ (subsystemWeylMatrix w S) := by
  classical
  rw [Fintype.linearIndependent_iff]
  intro g hsum v
  have hzero :=
    congrArg (fun M => subsystemWeylFunctional w S v M) hsum
  simp only [map_sum, map_smul, map_zero] at hzero
  simp_rw [subsystemWeylFunctional_subsystemWeylMatrix] at hzero
  simpa using hzero

/-- Product Weyl matrices form a basis of the full subsystem matrix
space. -/
noncomputable def subsystemWeylBasis
    (w : WeylConvention 𝔽) (S : Finset Party) :
    Basis (S → 𝔽 × 𝔽) ℂ (SubsystemMatrix 𝔽 S) :=
  basisOfLinearIndependentOfCardEqFinrank
    (subsystemWeylMatrix_linearIndependent w S) (by
      simp [SubsystemMatrix, Module.finrank_matrix, Fintype.card_prod]
      ring)

@[simp]
theorem subsystemWeylBasis_apply
    (w : WeylConvention 𝔽) (S : Finset Party) (v : S → 𝔽 × 𝔽) :
    subsystemWeylBasis w S v = subsystemWeylMatrix w S v := by
  classical
  rw [subsystemWeylBasis, coe_basisOfLinearIndependentOfCardEqFinrank]

/-- Product-Weyl coordinates of a subsystem matrix. -/
noncomputable def subsystemWeylCoordinateEquiv
    (w : WeylConvention 𝔽) (S : Finset Party) :
    SubsystemMatrix 𝔽 S ≃ₗ[ℂ] ((S → 𝔽 × 𝔽) → ℂ) :=
  (subsystemWeylBasis w S).repr ≪≫ₗ
    Finsupp.linearEquivFunOnFinite ℂ ℂ (S → 𝔽 × 𝔽)

/-- The basis coordinate is the normalized shifted-diagonal Fourier
functional. -/
theorem subsystemWeylCoordinateEquiv_apply
    (w : WeylConvention 𝔽) (S : Finset Party)
    (M : SubsystemMatrix 𝔽 S) (v : S → 𝔽 × 𝔽) :
    subsystemWeylCoordinateEquiv w S M v =
      subsystemWeylFunctional w S v M := by
  classical
  change (subsystemWeylBasis w S).repr M v =
    subsystemWeylFunctional w S v M
  symm
  calc
    subsystemWeylFunctional w S v M =
        subsystemWeylFunctional w S v
          (∑ u, (subsystemWeylBasis w S).repr M u •
            subsystemWeylBasis w S u) := by
              rw [(subsystemWeylBasis w S).sum_repr]
    _ = ∑ u, (subsystemWeylBasis w S).repr M u *
          subsystemWeylFunctional w S v
            (subsystemWeylBasis w S u) := by
              simp
    _ = (subsystemWeylBasis w S).repr M v := by
      rw [Fintype.sum_eq_single v]
      · rw [subsystemWeylBasis_apply,
          subsystemWeylFunctional_subsystemWeylMatrix]
        simp
      · intro u huv
        rw [subsystemWeylBasis_apply,
          subsystemWeylFunctional_subsystemWeylMatrix, if_neg]
        simp
        exact Ne.symm huv

/-- The marginal coefficient defined from amplitudes is exactly the
product-Weyl basis coordinate of the reduced matrix. -/
theorem marginalWeylCoefficient_eq_subsystemCoordinate
    (w : WeylConvention 𝔽) (ψ : State 𝔽)
    (S : Finset Party) (v : S → 𝔽 × 𝔽) :
    marginalWeylCoefficient w ψ S v =
      subsystemWeylCoordinateEquiv w S
        (fun x y => marginalEntry ψ S x y) v := by
  rw [subsystemWeylCoordinateEquiv_apply]
  rfl

end RelativeConicArcs.AMELU
