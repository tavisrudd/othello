import RelativeConicArcs.ClebschFiniteRootWeightSlice
import RelativeConicArcs.ClebschLucasCoefficientBasis

/-!
# From the finite-root action to the Lucas recurrence

The concrete simultaneous-translation action on a binary weight slice implies literally the
one-digit recurrence used in the Lucas coefficient model.  This module is the interface between
the group-action and coefficient-recurrence leaves.
-/

namespace RelativeConicArcs.ClebschFiniteRootRecurrenceBridge

open ClebschFiniteRootWeightSlice

noncomputable section

variable {K : Type*} [Field K] [Fintype K]

/-- Finite upper-root invariance implies the one-digit recurrence used by the Lucas coefficient
model whenever the slice width is below the field cardinality. -/
theorem finiteRootInvariant_satisfiesOneDigitRecurrence
    (h : ℕ) (hh : h < Fintype.card K) (alpha : Fin (h + 1) → K)
    (hinvariant : FiniteRootInvariant h alpha) :
    ClebschLucasCoefficientBasis.SatisfiesOneDigitRecurrence h alpha := by
  simpa [ClebschLucasCoefficientBasis.SatisfiesOneDigitRecurrence,
    SatisfiesWeightSliceRecurrence] using
    finiteRootInvariant_satisfiesWeightSliceRecurrence h hh alpha hinvariant

/-- Below the characteristic, the concrete finite-root fixed vectors are
exactly the solutions of the one-digit Lucas recurrence. -/
theorem finiteRootInvariant_iff_satisfiesOneDigitRecurrence
    {p h : ℕ} [CharP K p] (hp : h < p) (hh : h < Fintype.card K)
    (alpha : Fin (h + 1) → K) :
    FiniteRootInvariant h alpha ↔
      ClebschLucasCoefficientBasis.SatisfiesOneDigitRecurrence h alpha := by
  constructor
  · exact finiteRootInvariant_satisfiesOneDigitRecurrence h hh alpha
  · intro hrecurrence
    apply (finiteRootInvariant_iff_exists_scalar_alternatingBinomial h hh alpha).2
    refine ⟨alpha 0, funext fun m ↦ ?_⟩
    simpa [ClebschLucasCoefficientBasis.alternatingBinomialCoefficient,
      weightSliceAlternatingCoefficient] using
      ClebschLucasCoefficientBasis.oneDigitRecurrence_eq_scalar_alternatingBinomial
        hp alpha hrecurrence m

end

end RelativeConicArcs.ClebschFiniteRootRecurrenceBridge
