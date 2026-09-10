import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.CompletedExponentialPushforward
import Mathlib.RingTheory.PowerSeries.Exp
import Mathlib.RingTheory.PowerSeries.Substitution

/-!
# Multivariate divisor characters and integral line restriction

The exponential of an integral divisor pairing is constructed by substituting
its linear form into the formal exponential series. Restriction along an
integral line produces the one-variable exponential character. Consequently
finite relations among distinct integral pairing vectors have zero
coefficients. All substitutions satisfy the zero-constant-term condition.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum

/-- The factorial-normalized character agrees with the rescaled formal exponential. -/
theorem formalExponentialCharacter_eq_rescale_exp
    {K : Type*} [Field K] [CharZero K] (a : K) :
    formalExponentialCharacter a = PowerSeries.rescale a (PowerSeries.exp K) := by
  ext n
  simp [formalExponentialCharacter, PowerSeries.coeff_exp, div_eq_mul_inv]

/-- The linear divisor form corresponding to an integral pairing vector. -/
noncomputable def integralDivisorLinearForm
    {K : Type*} [Field K] [CharZero K] {rank : ℕ}
    (vector : Fin rank → ℤ) : MvPowerSeries (Fin rank) K :=
  ∑ j, (vector j : K) • MvPowerSeries.X j

/-- A divisor linear form has zero constant coefficient and is substitutable. -/
theorem integralDivisorLinearForm_hasSubst
    {K : Type*} [Field K] [CharZero K] {rank : ℕ} (vector : Fin rank → ℤ) :
    PowerSeries.HasSubst (integralDivisorLinearForm (K := K) vector) := by
  apply PowerSeries.HasSubst.of_constantCoeff_zero
  simp [integralDivisorLinearForm]

/-- The multivariate exponential character of an integral pairing vector. -/
noncomputable def multivariateExponentialCharacter
    {K : Type*} [Field K] [CharZero K] {rank : ℕ}
    (vector : Fin rank → ℤ) : MvPowerSeries (Fin rank) K :=
  PowerSeries.subst (integralDivisorLinearForm vector) (PowerSeries.exp K)

/-- Integral line substitution has zero constant coefficients in every variable. -/
theorem integralLine_hasSubst
    {K : Type*} [Field K] [CharZero K] {rank : ℕ} (direction : Fin rank → ℤ) :
    MvPowerSeries.HasSubst (fun j => (direction j : K) • (PowerSeries.X : PowerSeries K)) := by
  apply MvPowerSeries.hasSubst_of_constantCoeff_zero
  intro j
  simp [PowerSeries.X]

/-- Restriction of multivariate power series to an integral one-parameter line. -/
noncomputable def integralLineRestriction
    {K : Type*} [Field K] [CharZero K] {rank : ℕ} (direction : Fin rank → ℤ) :
    MvPowerSeries (Fin rank) K →ₐ[K] PowerSeries K :=
  MvPowerSeries.substAlgHom (integralLine_hasSubst direction)

/-- Restriction of the divisor linear form is its integral dot product times the parameter. -/
theorem integralLineRestriction_linearForm
    {K : Type*} [Field K] [CharZero K] {rank : ℕ}
    (direction vector : Fin rank → ℤ) :
    integralLineRestriction direction (integralDivisorLinearForm (K := K) vector) =
      ((∑ j, direction j * vector j : ℤ) : K) • PowerSeries.X := by
  simp [integralLineRestriction, integralDivisorLinearForm, map_sum,
    MvPowerSeries.substAlgHom_apply,
    MvPowerSeries.subst_X, integralLine_hasSubst, smul_smul, Finset.sum_smul, mul_comm]

/-- Integral line restriction sends an actual multivariate character to the
factorial-normalized character with the corresponding dot-product exponent. -/
theorem integralLineRestriction_character
    {K : Type*} [Field K] [CharZero K] {rank : ℕ}
    (direction vector : Fin rank → ℤ) :
    integralLineRestriction direction (multivariateExponentialCharacter (K := K) vector) =
      formalExponentialCharacter ((∑ j, direction j * vector j : ℤ) : K) := by
  rw [multivariateExponentialCharacter, integralLineRestriction,
    MvPowerSeries.substAlgHom_apply, PowerSeries.subst,
    MvPowerSeries.subst_comp_subst_apply (integralDivisorLinearForm_hasSubst (K := K) vector).const
      (integralLine_hasSubst (K := K) direction)]
  have h := integralLineRestriction_linearForm (K := K) direction vector
  simp only [integralLineRestriction, MvPowerSeries.substAlgHom_apply] at h
  simp only [h]
  exact (PowerSeries.rescale_eq_subst
    ((∑ j, direction j * vector j : ℤ) : K) (PowerSeries.exp K)).symm.trans
      (formalExponentialCharacter_eq_rescale_exp _).symm

/-- Distinct integral pairing vectors give linearly independent multivariate
characters on every finite index set. The proof restricts an actual relation
to all integral lines and applies the proved finite Vandermonde separation. -/
theorem multivariateExponentialCharacters_independent
    {K ι : Type*} [Field K] [CharZero K] [Fintype ι] {rank : ℕ}
    (vector : ι → Fin rank → ℤ) (injective : Function.Injective vector)
    (coefficient : ι → K)
    (relation : ∑ i, coefficient i • multivariateExponentialCharacter (K := K) (vector i) = 0) :
    coefficient=0 := by
  apply coefficients_zero_of_all_integral_character_relations vector injective coefficient
  intro direction
  have h := congrArg (integralLineRestriction direction) relation
  simpa only [map_sum, map_smul, map_zero, integralLineRestriction_character] using h

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum
