import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.MultivariateExponentialCharacters

/-!
# Faithful completed multivariate exponential pushforward

Each source coefficient is multiplied by its actual multivariate divisor
exponential and a nonzero scalar weight, then summed over a finite numerical
fiber. Integral line restriction of this constructed coefficient is exactly
the directional pushforward. The resulting map on completed series is
injective. The input degree-compatible quotient and integral divisor pairing
are algebraic data; their geometric realization is not part of this module.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum

/-- Tag every completed coefficient by its multivariate divisor exponential. -/
noncomputable def completedMultivariateTag
    {Curve K : Type*} [Field K] [CharZero K] {length : Curve → ℕ} {rank : ℕ}
    (vector : Curve → Fin rank → ℤ) (weight : Curve → K)
    (series : CompletedNovikovSeries Curve K length) :
    CompletedNovikovSeries Curve (MvPowerSeries (Fin rank) K) length where
  coefficient curve := (series.coefficient curve * weight curve) •
    multivariateExponentialCharacter (vector curve)
  finite_below cutoff := (series.finite_below cutoff).subset <| by
    intro curve h
    refine ⟨?_,h.2⟩
    intro zero
    exact h.1 (by simp [zero])

/-- The completed multivariate pushforward, defined using the actual finite
fibers of the degree-compatible class map. -/
noncomputable def completedMultivariateTaggedPushforward
    {Curve TargetCurve K : Type*} [AddCommMonoid Curve] [AddCommMonoid TargetCurve]
    [Field K] [CharZero K] {rank : ℕ}
    (data : NumericallyFiniteEffectiveQuotient (Homology := Curve) (Numerical := TargetCurve))
    (vector : Curve → Fin rank → ℤ) (weight : Curve → K)
    (series : CompletedNovikovSeries Curve K data.homologicalDegree) :
    CompletedNovikovSeries TargetCurve (MvPowerSeries (Fin rank) K) data.numericalDegree :=
  data.completedCoefficientPushforward (completedMultivariateTag vector weight series)

/-- A target coefficient is precisely the finite sum over its source fiber. -/
theorem completedMultivariateTaggedPushforward_coefficient
    {Curve TargetCurve K : Type*} [AddCommMonoid Curve] [AddCommMonoid TargetCurve]
    [Field K] [CharZero K] {rank : ℕ}
    (data : NumericallyFiniteEffectiveQuotient (Homology := Curve) (Numerical := TargetCurve))
    (vector : Curve → Fin rank → ℤ) (weight : Curve → K)
    (series : CompletedNovikovSeries Curve K data.homologicalDegree) (target : TargetCurve) :
    (completedMultivariateTaggedPushforward data vector weight series).coefficient target =
      ∑ curve ∈ data.fiber target, (series.coefficient curve * weight curve) •
        multivariateExponentialCharacter (vector curve) := rfl

/-- Integral line restriction of a constructed target coefficient is the
corresponding coefficient of the directional completed pushforward. -/
theorem completedMultivariateTaggedPushforward_lineRestriction
    {Curve TargetCurve K : Type*} [AddCommMonoid Curve] [AddCommMonoid TargetCurve]
    [Field K] [CharZero K] {rank : ℕ}
    (data : NumericallyFiniteEffectiveQuotient (Homology := Curve) (Numerical := TargetCurve))
    (vector : Curve → Fin rank → ℤ) (weight : Curve → K) (direction : Fin rank → ℤ)
    (series : CompletedNovikovSeries Curve K data.homologicalDegree) (target : TargetCurve) :
    integralLineRestriction direction
        ((completedMultivariateTaggedPushforward data vector weight series).coefficient target) =
      (completedDirectionalTaggedPushforward data vector weight direction series).coefficient target := by
  simp only [completedMultivariateTaggedPushforward_coefficient,
    completedDirectionalTaggedPushforward_coefficient, map_sum, map_smul,
    integralLineRestriction_character]

/-- The actual completed multivariate map is injective: equality can be
restricted to every integral line, where finite-fiber Vandermonde separation
has already proved joint injectivity. No injectivity of this map is a premise. -/
theorem completedMultivariateTaggedPushforward_injective
    {Curve TargetCurve K : Type*} [AddCommMonoid Curve] [AddCommMonoid TargetCurve]
    [Field K] [CharZero K] {rank : ℕ}
    (data : NumericallyFiniteEffectiveQuotient (Homology := Curve) (Numerical := TargetCurve))
    (vector : Curve → Fin rank → ℤ) (injective : Function.Injective vector)
    (weight : Curve → K) (nonzero : ∀ curve, weight curve ≠ 0) :
    Function.Injective (completedMultivariateTaggedPushforward data vector weight) := by
  intro left right equal
  apply completedDirectionalTaggedPushforward_jointly_injective data vector injective weight nonzero
  funext direction
  apply CompletedNovikovSeries.ext
  funext target
  rw [← completedMultivariateTaggedPushforward_lineRestriction,
    ← completedMultivariateTaggedPushforward_lineRestriction, equal]

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum
