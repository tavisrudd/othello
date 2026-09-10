import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.MultiplicativeDivisorCharacters
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.CompletedCoefficientExtension
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.CompletedDivisorSubstitution
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.FixedBaseCoordinateEquivalences

/-!
# Faithful completed exponential ring maps

An additive integral divisor pairing and a multiplicative nonzero scalar
weight define a unital map from the completed Novikov ring to the completed
numerical ring with multivariate formal coefficients. The map is constructed
by coefficient extension, the proved multiplicative character, and finite-fiber
pushforward. Its injectivity follows from actual integral line restrictions.
Polynomial bulk/unit coordinates can then be extended and translated without
losing injectivity. Geometric divisor pairings and base identifications are
not constructed here.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum

/-- The product of a scalar monomial weight and the constructed divisor character. -/
noncomputable def weightedIntegralPairingCharacter
    {Curve K : Type*} [AddCommMonoid Curve] [Field K] [CharZero K] {rank : ℕ}
    (pairing : Curve →+ (Fin rank → ℤ)) (weight : Multiplicative Curve →* K) :
    Multiplicative Curve →* MvPowerSeries (Fin rank) K :=
  (MvPowerSeries.C.toMonoidHom.comp weight) * integralPairingCharacter pairing

/-- The actual completed exponential substitution as a unital ring homomorphism. -/
noncomputable def completedExponentialRingHom
    {Curve TargetCurve K : Type*} [AddCommMonoid Curve] [AddCommMonoid TargetCurve]
    [Field K] [CharZero K] {rank : ℕ}
    (data : CompletedNumericalQuotient Curve TargetCurve)
    (pairing : Curve →+ (Fin rank → ℤ)) (weight : Multiplicative Curve →* K) :
    data.homologicalGrading.CompletedNovikovRing K →+*
      data.numericalGrading.CompletedNovikovRing (MvPowerSeries (Fin rank) K) :=
  data.completedPushforwardRingHom.comp
    ((completedDivisorSubstitutionRingHom data.homologicalGrading
      (weightedIntegralPairingCharacter pairing weight)).comp
        (completedCoefficientExtensionRingHom data.homologicalGrading MvPowerSeries.C))

/-- The coefficient formula of the constructed ring homomorphism is the
finite-fiber sum of weighted divisor characters. -/
theorem completedExponentialRingHom_coefficient
    {Curve TargetCurve K : Type*} [AddCommMonoid Curve] [AddCommMonoid TargetCurve]
    [Field K] [CharZero K] {rank : ℕ}
    (data : CompletedNumericalQuotient Curve TargetCurve)
    (pairing : Curve →+ (Fin rank → ℤ)) (weight : Multiplicative Curve →* K)
    (series : data.homologicalGrading.CompletedNovikovRing K) (target : TargetCurve) :
    (completedExponentialRingHom data pairing weight series).coefficient target =
      ∑ curve ∈ data.coefficientData.fiber target,
        (MvPowerSeries.C (weight (.ofAdd curve)) * multiplicativeDivisorCharacter (pairing curve)) *
          MvPowerSeries.C (series.coefficient curve) := rfl

/-- Integral line restriction of each output coefficient gives the actual
directional completed pushforward used in finite-fiber separation. -/
theorem completedExponentialRingHom_lineRestriction
    {Curve TargetCurve K : Type*} [AddCommMonoid Curve] [AddCommMonoid TargetCurve]
    [Field K] [CharZero K] {rank : ℕ}
    (data : CompletedNumericalQuotient Curve TargetCurve)
    (pairing : Curve →+ (Fin rank → ℤ)) (weight : Multiplicative Curve →* K)
    (direction : Fin rank → ℤ)
    (series : data.homologicalGrading.CompletedNovikovRing K) (target : TargetCurve) :
    integralLineRestriction direction
      ((completedExponentialRingHom data pairing weight series).coefficient target) =
      (completedDirectionalTaggedPushforward data.coefficientData pairing
        (fun curve => weight (.ofAdd curve)) direction series).coefficient target := by
  simp only [completedExponentialRingHom_coefficient,
    completedDirectionalTaggedPushforward_coefficient, map_sum, map_mul,
    integralLineRestriction_multiplicativeCharacter]
  apply Finset.sum_congr rfl
  intro curve membership
  have constants (c : K) : integralLineRestriction direction (MvPowerSeries.C c) = PowerSeries.C c := by
    simp [integralLineRestriction, MvPowerSeries.substAlgHom_apply,
      MvPowerSeries.subst_C, PowerSeries.C]
  rw [constants, constants]
  rw [mul_comm _ (PowerSeries.C (series.coefficient curve)), ← mul_assoc, ← map_mul,
    ← PowerSeries.smul_eq_C_mul]

/-- The completed exponential ring homomorphism is injective when its
integral pairing is injective and every multiplicative scalar weight is nonzero. -/
theorem completedExponentialRingHom_injective
    {Curve TargetCurve K : Type*} [AddCommMonoid Curve] [AddCommMonoid TargetCurve]
    [Field K] [CharZero K] {rank : ℕ}
    (data : CompletedNumericalQuotient Curve TargetCurve)
    (pairing : Curve →+ (Fin rank → ℤ)) (injective : Function.Injective pairing)
    (weight : Multiplicative Curve →* K) (nonzero : ∀ curve, weight (.ofAdd curve) ≠ 0) :
    Function.Injective (completedExponentialRingHom data pairing weight) := by
  intro left right equal
  apply completedDirectionalTaggedPushforward_jointly_injective data.coefficientData
    pairing injective (fun curve => weight (.ofAdd curve)) nonzero
  funext direction
  apply CompletedNovikovSeries.ext
  funext target
  rw [← completedExponentialRingHom_lineRestriction,
    ← completedExponentialRingHom_lineRestriction, equal]

/-- Retained polynomial bulk/unit coordinates can be extended along the
faithful completed ring map and independently translated, preserving injectivity. -/
theorem completedExponentialRingHom_polynomialTranslation_injective
    {Curve TargetCurve K σ : Type*} [AddCommMonoid Curve] [AddCommMonoid TargetCurve]
    [Field K] [CharZero K] {rank : ℕ}
    (data : CompletedNumericalQuotient Curve TargetCurve)
    (pairing : Curve →+ (Fin rank → ℤ)) (injective : Function.Injective pairing)
    (weight : Multiplicative Curve →* K) (nonzero : ∀ curve, weight (.ofAdd curve) ≠ 0)
    (shift : σ → data.numericalGrading.CompletedNovikovRing (MvPowerSeries (Fin rank) K)) :
    Function.Injective (fun p : MvPolynomial σ (data.homologicalGrading.CompletedNovikovRing K) =>
      polynomialCoordinateTranslation shift (MvPolynomial.map (completedExponentialRingHom data pairing weight) p)) :=
  polynomialCoefficientExtension_translation_injective _
    (completedExponentialRingHom_injective data pairing injective weight nonzero) shift

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum
