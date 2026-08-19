import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.QuarticDiscriminantDerivations
import Mathlib.Analysis.Complex.Polynomial.Basic
import Mathlib.LinearAlgebra.Eigenspace.Zero
import Mathlib.LinearAlgebra.Matrix.Charpoly.Coeff

/-!
# Separation of a rank-four spectrum by the discriminant of its characteristic polynomial

Let `M` be an endomorphism of a four-dimensional complex vector space whose
characteristic polynomial is the monic quartic

  `X ^ 4 + l₃ X ^ 3 + l₂ X ^ 2 + l₁ X + l₀`.

This module proves that a nonvanishing discriminant of that quartic forces every
maximal generalized eigenspace of `M` to be at most one-dimensional.  The count
of four distinct eigenvalues is not formalized.

The route is the classical one.  Over the complex numbers the quartic splits, so
it is the product of four monic linear factors; comparing coefficients writes
`l₀, …, l₃` as the signed elementary symmetric functions of the four roots, and
the universal identity of `QuarticDiscriminantDerivations` then evaluates the
discriminant as the squared product of the six pairwise root differences.  A
nonzero discriminant therefore makes the four roots pairwise distinct, so the
multiset of roots has no repetition and every root multiplicity is at most one.
The dimension of a maximal generalized eigenspace is the multiplicity of the
eigenvalue in the characteristic polynomial, which gives the statement about `M`.

The module also proves a bound valid at a degenerate quartic: if the quartic is
`(X - r) ^ 2 (X - c) (X - d)` with `c ≠ r` and `d ≠ r` — no relation between `c`
and `d` is assumed — then no root has multiplicity three or more, and `r` has
multiplicity exactly two.  That is the shape a degenerate specialization of a
Hirzebruch surface produces.

Lean constructs no quantum connection and no Euler multiplication here; `M` is
an arbitrary complex matrix and its characteristic polynomial is a hypothesis.
The module sits in the `Quantum` namespace, which collects the linear-algebraic
facts the manuscript's quantum-connection arguments consume; none of them
mentions a connection.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Quantum

open Polynomial

/-- The monic quartic `X ^ 4 + l₃ X ^ 3 + l₂ X ^ 2 + l₁ X + l₀`, with
coefficients listed in ascending degree. -/
noncomputable def monicQuartic (l₀ l₁ l₂ l₃ : ℂ) : Polynomial ℂ :=
  X ^ 4 + C l₃ * X ^ 3 + C l₂ * X ^ 2 + C l₁ * X + C l₀

/-- The constant coefficient of the monic quartic is the argument recording it. -/
@[simp]
theorem monicQuartic_coeff_zero (l₀ l₁ l₂ l₃ : ℂ) :
    (monicQuartic l₀ l₁ l₂ l₃).coeff 0 = l₀ := by
  simp [monicQuartic]

/-- The linear coefficient of the monic quartic is the argument recording it. -/
@[simp]
theorem monicQuartic_coeff_one (l₀ l₁ l₂ l₃ : ℂ) :
    (monicQuartic l₀ l₁ l₂ l₃).coeff 1 = l₁ := by
  simp [monicQuartic]

/-- The quadratic coefficient of the monic quartic is the argument recording it. -/
@[simp]
theorem monicQuartic_coeff_two (l₀ l₁ l₂ l₃ : ℂ) :
    (monicQuartic l₀ l₁ l₂ l₃).coeff 2 = l₂ := by
  simp [monicQuartic]

/-- The cubic coefficient of the monic quartic is the argument recording it. -/
@[simp]
theorem monicQuartic_coeff_three (l₀ l₁ l₂ l₃ : ℂ) :
    (monicQuartic l₀ l₁ l₂ l₃).coeff 3 = l₃ := by
  simp [monicQuartic]

/-- The monic quartic has degree four. -/
theorem monicQuartic_natDegree (l₀ l₁ l₂ l₃ : ℂ) :
    (monicQuartic l₀ l₁ l₂ l₃).natDegree = 4 := by
  unfold monicQuartic
  compute_degree!

/-- The monic quartic is monic. -/
theorem monicQuartic_monic (l₀ l₁ l₂ l₃ : ℂ) : (monicQuartic l₀ l₁ l₂ l₃).Monic := by
  unfold monicQuartic
  monicity!

/-- Two monic quartics with the same polynomial value have the same
coefficients. -/
theorem monicQuartic_injective {a₀ a₁ a₂ a₃ b₀ b₁ b₂ b₃ : ℂ}
    (equal : monicQuartic a₀ a₁ a₂ a₃ = monicQuartic b₀ b₁ b₂ b₃) :
    a₀ = b₀ ∧ a₁ = b₁ ∧ a₂ = b₂ ∧ a₃ = b₃ :=
  ⟨by simpa using congrArg (fun p => Polynomial.coeff p 0) equal,
   by simpa using congrArg (fun p => Polynomial.coeff p 1) equal,
   by simpa using congrArg (fun p => Polynomial.coeff p 2) equal,
   by simpa using congrArg (fun p => Polynomial.coeff p 3) equal⟩

/-- A product of four monic linear factors, expanded: the coefficients are the
elementary symmetric functions of the roots with alternating signs. -/
theorem prod_four_linear_eq_monicQuartic (r₀ r₁ r₂ r₃ : ℂ) :
    (X - C r₀) * (X - C r₁) * (X - C r₂) * (X - C r₃)
      = monicQuartic (r₀ * r₁ * r₂ * r₃)
          (-(r₀ * r₁ * r₂ + r₀ * r₁ * r₃ + r₀ * r₂ * r₃ + r₁ * r₂ * r₃))
          (r₀ * r₁ + r₀ * r₂ + r₀ * r₃ + r₁ * r₂ + r₁ * r₃ + r₂ * r₃)
          (-(r₀ + r₁ + r₂ + r₃)) := by
  simp only [monicQuartic, map_add, map_mul, map_neg]
  ring

/-- The discriminant of a monic complex quartic is the squared product of the
pairwise differences of its four roots.  The statement also exhibits the quartic
as the product of the four corresponding linear factors and identifies its root
multiset with `{r₀, r₁, r₂, r₃}`; both are consumed downstream. -/
theorem monicQuartic_discriminant_eq_squared_root_differences (l₀ l₁ l₂ l₃ : ℂ) :
    ∃ r₀ r₁ r₂ r₃ : ℂ,
      monicQuartic l₀ l₁ l₂ l₃ = (X - C r₀) * (X - C r₁) * (X - C r₂) * (X - C r₃) ∧
        (monicQuartic l₀ l₁ l₂ l₃).roots = {r₀, r₁, r₂, r₃} ∧
        quarticDiscriminant l₀ l₁ l₂ l₃ =
          ((r₀ - r₁) * (r₀ - r₂) * (r₀ - r₃) * (r₁ - r₂) * (r₁ - r₃) * (r₂ - r₃)) ^ 2 := by
  classical
  have monic := monicQuartic_monic l₀ l₁ l₂ l₃
  have card : (monicQuartic l₀ l₁ l₂ l₃).roots.card = 4 := by
    rw [IsAlgClosed.card_roots_eq_natDegree, monicQuartic_natDegree]
  obtain ⟨r₀, r₁, r₂, r₃, hroots⟩ := Multiset.card_eq_four.mp card
  have factored : monicQuartic l₀ l₁ l₂ l₃
      = (X - C r₀) * (X - C r₁) * (X - C r₂) * (X - C r₃) := by
    have split := (IsAlgClosed.splits (monicQuartic l₀ l₁ l₂ l₃)).eq_prod_roots_of_monic monic
    rw [hroots] at split
    simpa [mul_assoc] using split
  refine ⟨r₀, r₁, r₂, r₃, factored, hroots, ?_⟩
  obtain ⟨e₀, e₁, e₂, e₃⟩ :=
    monicQuartic_injective (factored.trans (prod_four_linear_eq_monicQuartic r₀ r₁ r₂ r₃))
  subst e₀; subst e₁; subst e₂; subst e₃
  exact quarticDiscriminant_eq_squared_root_differences r₀ r₁ r₂ r₃

/-- A monic complex quartic with nonvanishing discriminant has only simple
roots. -/
theorem monicQuartic_rootMultiplicity_le_one (l₀ l₁ l₂ l₃ : ℂ)
    (nondegenerate : quarticDiscriminant l₀ l₁ l₂ l₃ ≠ 0) (value : ℂ) :
    (monicQuartic l₀ l₁ l₂ l₃).rootMultiplicity value ≤ 1 := by
  classical
  obtain ⟨r₀, r₁, r₂, r₃, _, hroots, discriminant⟩ :=
    monicQuartic_discriminant_eq_squared_root_differences l₀ l₁ l₂ l₃
  rw [discriminant] at nondegenerate
  have product : (r₀ - r₁) * (r₀ - r₂) * (r₀ - r₃) * (r₁ - r₂) * (r₁ - r₃) * (r₂ - r₃) ≠ 0 :=
    fun vanishing => nondegenerate (by rw [vanishing]; ring)
  have distinct : r₀ ≠ r₁ ∧ r₀ ≠ r₂ ∧ r₀ ≠ r₃ ∧ r₁ ≠ r₂ ∧ r₁ ≠ r₃ ∧ r₂ ≠ r₃ := by
    refine ⟨?_, ?_, ?_, ?_, ?_, ?_⟩ <;> intro equality <;> apply product <;>
      rw [equality] <;> ring
  obtain ⟨d₀₁, d₀₂, d₀₃, d₁₂, d₁₃, d₂₃⟩ := distinct
  have nodup : ({r₀, r₁, r₂, r₃} : Multiset ℂ).Nodup := by
    simp [Multiset.nodup_cons, d₀₁, d₀₂, d₀₃, d₁₂, d₁₃, d₂₃]
  rw [← Polynomial.count_roots, hroots]
  exact Multiset.nodup_iff_count_le_one.mp nodup value

/-- Every maximal generalized eigenspace of a four-by-four complex matrix whose
characteristic polynomial is a monic quartic of nonvanishing discriminant has
dimension at most one: the spectral decomposition consists of four blocks of
rank one. -/
theorem finrank_maxGenEigenspace_le_one_of_quarticDiscriminant_ne_zero
    (operator : Matrix (Fin 4) (Fin 4) ℂ) (l₀ l₁ l₂ l₃ : ℂ)
    (characteristic : operator.charpoly = monicQuartic l₀ l₁ l₂ l₃)
    (nondegenerate : quarticDiscriminant l₀ l₁ l₂ l₃ ≠ 0) (value : ℂ) :
    Module.finrank ℂ (Module.End.maxGenEigenspace (Matrix.toLin' operator) value) ≤ 1 := by
  rw [LinearMap.finrank_maxGenEigenspace_eq, Matrix.charpoly_toLin', characteristic]
  exact monicQuartic_rootMultiplicity_le_one l₀ l₁ l₂ l₃ nondegenerate value

/-- A quartic of the form `(X - r) ^ 2 (X - c) (X - d)` with `c ≠ r` and `d ≠ r`
has every root multiplicity at most two.  No relation between `c` and `d` is
assumed.  Instantiating this at a degenerate Euler quartic requires the
distinctness hypotheses separately; that is done in the module on the Euler
spectrum of a Hirzebruch surface. -/
theorem rootMultiplicity_le_two_of_squared_linear_mul_quadratic
    {repeated first second : ℂ} (firstNe : first ≠ repeated) (secondNe : second ≠ repeated)
    (value : ℂ) :
    (((X - C repeated) ^ 2) * ((X - C first) * (X - C second))).rootMultiplicity value ≤ 2 := by
  classical
  have nonzero : (((X - C repeated) ^ 2) * ((X - C first) * (X - C second))) ≠ 0 :=
    mul_ne_zero (pow_ne_zero _ (X_sub_C_ne_zero repeated))
      (mul_ne_zero (X_sub_C_ne_zero first) (X_sub_C_ne_zero second))
  have squared : ((X - C repeated) ^ 2 : Polynomial ℂ) = (X - C repeated) * (X - C repeated) :=
    sq (X - C repeated)
  have expand : rootMultiplicity value (((X - C repeated) ^ 2) * ((X - C first) * (X - C second)))
      = rootMultiplicity value (X - C repeated) + rootMultiplicity value (X - C repeated)
        + (rootMultiplicity value (X - C first) + rootMultiplicity value (X - C second)) := by
    rw [squared] at nonzero ⊢
    rw [rootMultiplicity_mul nonzero,
      rootMultiplicity_mul (mul_ne_zero (X_sub_C_ne_zero repeated) (X_sub_C_ne_zero repeated)),
      rootMultiplicity_mul (mul_ne_zero (X_sub_C_ne_zero first) (X_sub_C_ne_zero second))]
  have firstBound : rootMultiplicity value (X - C first) ≤ 1 :=
    rootMultiplicity_le_one_of_separable separable_X_sub_C value
  have secondBound : rootMultiplicity value (X - C second) ≤ 1 :=
    rootMultiplicity_le_one_of_separable separable_X_sub_C value
  have repeatedBound : rootMultiplicity value (X - C repeated) ≤ 1 :=
    rootMultiplicity_le_one_of_separable separable_X_sub_C value
  rw [expand]
  by_cases atRepeated : value = repeated
  · have zeroFirst : rootMultiplicity value (X - C first) = 0 :=
      rootMultiplicity_eq_zero (by
        simp only [IsRoot, eval_sub, eval_X, eval_C, sub_eq_zero, atRepeated]
        exact fun h => firstNe h.symm)
    have zeroSecond : rootMultiplicity value (X - C second) = 0 :=
      rootMultiplicity_eq_zero (by
        simp only [IsRoot, eval_sub, eval_X, eval_C, sub_eq_zero, atRepeated]
        exact fun h => secondNe h.symm)
    omega
  · have zeroRepeated : rootMultiplicity value (X - C repeated) = 0 :=
      rootMultiplicity_eq_zero (by
        simp only [IsRoot, eval_sub, eval_X, eval_C, sub_eq_zero]
        exact atRepeated)
    omega

/-- The repeated factor of such a quartic contributes root multiplicity exactly
two.  Nothing about eigenspace dimensions is asserted here: the statement is
about the polynomial, and the two remaining factors are not assumed distinct from
each other. -/
theorem rootMultiplicity_eq_two_of_squared_linear_mul_quadratic
    {repeated first second : ℂ} (firstNe : first ≠ repeated) (secondNe : second ≠ repeated) :
    (((X - C repeated) ^ 2) * ((X - C first) * (X - C second))).rootMultiplicity repeated = 2 := by
  classical
  have nonzero : (((X - C repeated) ^ 2) * ((X - C first) * (X - C second))) ≠ 0 :=
    mul_ne_zero (pow_ne_zero _ (X_sub_C_ne_zero repeated))
      (mul_ne_zero (X_sub_C_ne_zero first) (X_sub_C_ne_zero second))
  have squared : ((X - C repeated) ^ 2 : Polynomial ℂ) = (X - C repeated) * (X - C repeated) :=
    sq (X - C repeated)
  have expand :
      rootMultiplicity repeated (((X - C repeated) ^ 2) * ((X - C first) * (X - C second)))
        = rootMultiplicity repeated (X - C repeated) + rootMultiplicity repeated (X - C repeated)
          + (rootMultiplicity repeated (X - C first)
            + rootMultiplicity repeated (X - C second)) := by
    rw [squared] at nonzero ⊢
    rw [rootMultiplicity_mul nonzero,
      rootMultiplicity_mul (mul_ne_zero (X_sub_C_ne_zero repeated) (X_sub_C_ne_zero repeated)),
      rootMultiplicity_mul (mul_ne_zero (X_sub_C_ne_zero first) (X_sub_C_ne_zero second))]
  have self : rootMultiplicity repeated (X - C repeated) = 1 := rootMultiplicity_X_sub_C_self
  have zeroFirst : rootMultiplicity repeated (X - C first) = 0 :=
    rootMultiplicity_eq_zero (by
      simp only [IsRoot, eval_sub, eval_X, eval_C, sub_eq_zero]
      exact fun h => firstNe h.symm)
  have zeroSecond : rootMultiplicity repeated (X - C second) = 0 :=
    rootMultiplicity_eq_zero (by
      simp only [IsRoot, eval_sub, eval_X, eval_C, sub_eq_zero]
      exact fun h => secondNe h.symm)
  omega

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
