import RelativeConicArcs.AMELU.Definitions
import RelativeConicArcs.AMELU.DiagonalTensor
import Mathlib.LinearAlgebra.Basis.Basic
import Mathlib.LinearAlgebra.FiniteDimensional.Lemmas
import Mathlib.LinearAlgebra.Finsupp.Defs

/-!
# The finite-field Weyl matrices as an operator basis

For a finite field `𝔽` and a nontrivial additive character `χ`, the
`|𝔽|²` matrices

`W(a,b) eₓ = χ(bx)e_{x+a}`

form a complex basis of all `𝔽 × 𝔽` matrices.  A Fourier functional on
the `a`-shifted diagonal isolates the coefficient of `W(a,b)`.  The
resulting basis equivalence supplies coordinates for local conjugation
without choosing an inner product on the operator space.

All arguments are symbolic and kernel checked.  The module contains no
generated data, native evaluation, axioms, or admitted declarations.
-/

namespace RelativeConicArcs.AMELU

open Finset Matrix Module

variable {𝔽 : Type*} [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽]

omit [DecidableEq 𝔽] in
private theorem additiveCharacter_sum_eq_zero (w : WeylConvention 𝔽) :
    ∑ x : 𝔽, w.character x = 0 := by
  apply AddChar.sum_eq_zero_iff_ne_zero.mpr
  intro hzero
  apply w.character_nontrivial
  rw [hzero]
  rfl

/-- Orthogonality of a nontrivial additive character after multiplication
by a field element. -/
theorem sum_character_mul (w : WeylConvention 𝔽) (a : 𝔽) :
    ∑ x : 𝔽, w.character (a * x) =
      if a = 0 then (Fintype.card 𝔽 : ℂ) else 0 := by
  classical
  by_cases ha : a = 0
  · subst a
    simp
  · let e : 𝔽 ≃ 𝔽 :=
      { toFun := fun x => a * x
        invFun := fun y => a⁻¹ * y
        left_inv := fun x => by simp [ha]
        right_inv := fun y => by simp [ha] }
    rw [if_neg ha]
    calc
      (∑ x : 𝔽, w.character (a * x)) =
          ∑ y : 𝔽, w.character y :=
        Fintype.sum_equiv e _ _ (fun x => rfl)
      _ = 0 := additiveCharacter_sum_eq_zero w

/-- The unnormalized Fourier coefficient on the `a`-shifted matrix
diagonal, as a complex linear functional. -/
noncomputable def weylFourierFunctional (w : WeylConvention 𝔽)
    (a b : 𝔽) : LocalMatrix 𝔽 →ₗ[ℂ] ℂ where
  toFun A := ∑ x : 𝔽, w.character (-b * x) * A (x + a) x
  map_add' A B := by
    simp [mul_add, Finset.sum_add_distrib]
  map_smul' z A := by
    simp [Finset.mul_sum, mul_left_comm]

/-- The Fourier functional isolates one Weyl matrix, with value
`|𝔽|` on that matrix and zero on every other Weyl matrix. -/
theorem weylFourierFunctional_weylMatrix (w : WeylConvention 𝔽)
    (a b c d : 𝔽) :
    weylFourierFunctional w a b (weylMatrix w c d) =
      if a = c ∧ b = d then (Fintype.card 𝔽 : ℂ) else 0 := by
  classical
  change
    (∑ x : 𝔽,
      w.character (-b * x) *
        (if x + a = x + c then w.character (d * x) else 0)) =
      if a = c ∧ b = d then (Fintype.card 𝔽 : ℂ) else 0
  by_cases hac : a = c
  · subst c
    simp only [if_pos, ← AddChar.map_add_eq_mul]
    have harg (x : 𝔽) : -b * x + d * x = (d - b) * x := by ring
    simp_rw [harg]
    rw [sum_character_mul]
    by_cases hbd : b = d
    · simp [hbd]
    · have hdb : d - b ≠ 0 := sub_ne_zero.mpr (Ne.symm hbd)
      simp [hbd, hdb]
  · simp [hac]

/-- The finite-field Weyl matrices are linearly independent over `ℂ`. -/
theorem weylMatrix_linearIndependent (w : WeylConvention 𝔽) :
    LinearIndependent ℂ (fun v : 𝔽 × 𝔽 => weylMatrix w v.1 v.2) := by
  classical
  rw [Fintype.linearIndependent_iff]
  intro g hsum v
  have hzero :=
    congrArg (fun A => weylFourierFunctional w v.1 v.2 A) hsum
  simp only [map_sum, map_smul, map_zero] at hzero
  simp_rw [weylFourierFunctional_weylMatrix] at hzero
  have hcard : (Fintype.card 𝔽 : ℂ) ≠ 0 := by
    exact_mod_cast Fintype.card_ne_zero
  have hisolate :
      (∑ u : 𝔽 × 𝔽,
        g u • if v.1 = u.1 ∧ v.2 = u.2
          then (Fintype.card 𝔽 : ℂ) else 0) =
        g v * (Fintype.card 𝔽 : ℂ) := by
    rw [Fintype.sum_eq_single v]
    · simp
    · intro u huv
      have hnot : ¬(v.1 = u.1 ∧ v.2 = u.2) := by
        intro h
        exact huv (Prod.ext h.1.symm h.2.symm)
      simp [hnot]
  rw [hisolate] at hzero
  exact (mul_eq_zero.mp hzero).resolve_right hcard

/-- The Weyl matrices, indexed by their two field labels, form a basis
of the full single-party matrix space. -/
noncomputable def weylBasis (w : WeylConvention 𝔽) :
    Basis (𝔽 × 𝔽) ℂ (LocalMatrix 𝔽) :=
  basisOfLinearIndependentOfCardEqFinrank
    (weylMatrix_linearIndependent w) (by
      simp [LocalMatrix, Module.finrank_matrix])

@[simp]
theorem weylBasis_apply (w : WeylConvention 𝔽) (v : 𝔽 × 𝔽) :
    weylBasis w v = weylMatrix w v.1 v.2 := by
  classical
  rw [weylBasis, coe_basisOfLinearIndependentOfCardEqFinrank]

/-- Weyl coordinates give a linear equivalence from single-party
matrices to functions on the two-dimensional field label space. -/
noncomputable def weylCoordinateEquiv (w : WeylConvention 𝔽) :
    LocalMatrix 𝔽 ≃ₗ[ℂ] (𝔽 × 𝔽 → ℂ) :=
  (weylBasis w).repr ≪≫ₗ Finsupp.linearEquivFunOnFinite ℂ ℂ (𝔽 × 𝔽)

/-- A Weyl matrix has the corresponding coordinate vector. -/
theorem weylCoordinateEquiv_weylMatrix (w : WeylConvention 𝔽)
    (v : 𝔽 × 𝔽) :
    weylCoordinateEquiv w (weylMatrix w v.1 v.2) =
      coordinateVector v 1 := by
  classical
  ext u
  change ((weylBasis w).repr (weylMatrix w v.1 v.2)) u =
    coordinateVector v 1 u
  rw [← weylBasis_apply w v]
  simpa [coordinateVector, eq_comm] using
    (weylBasis w).repr_self_apply v u

end RelativeConicArcs.AMELU
