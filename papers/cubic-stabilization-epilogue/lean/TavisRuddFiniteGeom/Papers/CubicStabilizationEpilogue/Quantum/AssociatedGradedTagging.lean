import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.CompletedNovikovSupport

/-!
# Associated-graded interface for divisor tagging

This module isolates the filtered-ring input used after the finite
lowest-support argument in divisor tagging.  A coefficient-level completed
Novikov series has coefficients in a characteristic-zero field `K`.  An
injective integral divisor-pairing vector defines the exponential tags.  A
specialization supplies a nonzero initial coefficient for every monomial and
an initial-form detector after each integral one-parameter direction.

The decisive compatibility field says that the detected initial form of the
tagged image is exactly the finite exponential combination on the formalized
lowest support.  Lean then proves that the tagged image of every nonzero
series is nonzero, and therefore that the tagged map reflects zero.

The interface does not represent a filtered target ring, its associated graded
ring, a valuation, or the geometric Novikov specialization.  It assumes proxy
detector, coefficient, and compatibility data; Lean derives nonvanishing and
injectivity.  Showing that the manuscript's filtered specialization and domain
associated graded produce these data remains unformalized.  All proofs are
symbolic and kernel checked, with no external computation or oracle.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Quantum

open scoped BigOperators

/-- Proxy initial-form data consumed by the divisor-tagging noncancellation
argument.  `taggedImage` is the multivariable tagged image.  For each integral
one-parameter direction, `initialFormAfterDirection` is a supplied function to
power series over `K`; no filtration or associated graded object occurs in the
type. -/
structure AssociatedGradedTaggingInput
    (Curve K Target : Type*) [Field K] [CharZero K] [AddCommGroup Target]
    (length : Curve → ℕ) (rank : ℕ) where
  pairingVector : Curve → Fin rank → ℤ
  pairingVector_injective : Function.Injective pairingVector
  monomialInitialCoefficient : Curve → K
  monomialInitialCoefficient_ne_zero : ∀ degree,
    monomialInitialCoefficient degree ≠ 0
  taggedImage : CompletedNovikovSeries Curve K length →+ Target
  initialFormAfterDirection : (Fin rank → ℤ) → Target → PowerSeries K
  initialForm_zero : ∀ direction, initialFormAfterDirection direction 0 = 0
  initialForm_taggedImage :
    ∀ (series : CompletedNovikovSeries Curve K length)
      (_series_nonzero : series ≠ 0) (direction : Fin rank → ℤ),
      initialFormAfterDirection direction (taggedImage series) =
        ∑ degree : series.lowestSupport,
          (series.coefficient degree * monomialInitialCoefficient degree) •
            formalExponentialCharacter
              ((∑ coordinate, direction coordinate *
                pairingVector degree coordinate : ℤ) : K)

namespace AssociatedGradedTaggingInput

/-- Exact associated-graded divisor-tagging conclusion: every nonzero
completed series has nonzero multivariable tagged image.  The integral
one-parameter direction is chosen from the series's finite lowest support;
the tagged image itself is fixed and independent of that choice. -/
theorem taggedImage_ne_zero
    {Curve K Target : Type*} [Field K] [CharZero K] [AddCommGroup Target]
    {length : Curve → ℕ} {rank : ℕ}
    (input : AssociatedGradedTaggingInput Curve K Target length rank)
    (series : CompletedNovikovSeries Curve K length)
    (series_nonzero : series ≠ 0) :
    input.taggedImage series ≠ 0 := by
  have coefficient_nonzero : series.coefficient ≠ 0 := by
    intro coefficient_zero
    exact series_nonzero (series.eq_zero_iff.mpr coefficient_zero)
  obtain ⟨direction, _, exponential_nonzero⟩ :=
    series.exists_integralDirection_lowestSupport_exponentialSum_ne_zero
      (K := K) coefficient_nonzero input.pairingVector
      input.pairingVector_injective
  intro tagged_zero
  have initial_zero : input.initialFormAfterDirection direction
      (input.taggedImage series) = 0 := by
    rw [tagged_zero, input.initialForm_zero]
  have leading_nonzero : ∀ degree : series.lowestSupport,
      series.coefficient degree * input.monomialInitialCoefficient degree ≠ 0 := by
    intro degree
    exact mul_ne_zero
      (series.mem_lowestSupport_iff degree |>.mp degree.property).1
      (input.monomialInitialCoefficient_ne_zero degree)
  exact exponential_nonzero
    (fun degree ↦ series.coefficient degree *
      input.monomialInitialCoefficient degree)
    leading_nonzero <| by
      rw [← input.initialForm_taggedImage series series_nonzero direction]
      exact initial_zero

/-- The tagged map reflects zero.  Together with the supplied fact that zero
maps to zero, this is the pointed-set form of completed-series injectivity
needed in the manuscript's comparison argument. -/
theorem taggedImage_eq_zero_iff
    {Curve K Target : Type*} [Field K] [CharZero K] [AddCommGroup Target]
    {length : Curve → ℕ} {rank : ℕ}
    (input : AssociatedGradedTaggingInput Curve K Target length rank)
    (series : CompletedNovikovSeries Curve K length) :
    input.taggedImage series = 0 ↔ series = 0 := by
  constructor
  · intro tagged_zero
    by_contra series_nonzero
    exact input.taggedImage_ne_zero series series_nonzero tagged_zero
  · rintro rfl
    exact input.taggedImage.map_zero

/-- Full injectivity of the completed-series tagged map.  Apply the nonzero
theorem to the difference of two series and use additivity of `taggedImage`. -/
theorem taggedImage_injective
    {Curve K Target : Type*} [Field K] [CharZero K] [AddCommGroup Target]
    {length : Curve → ℕ} {rank : ℕ}
    (input : AssociatedGradedTaggingInput Curve K Target length rank) :
    Function.Injective input.taggedImage := by
  intro left right tagged_equal
  apply sub_eq_zero.mp
  by_contra difference_nonzero
  apply input.taggedImage_ne_zero (left - right) difference_nonzero
  rw [map_sub, tagged_equal, sub_self]

end AssociatedGradedTaggingInput

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
