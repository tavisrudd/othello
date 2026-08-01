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

end

end RelativeConicArcs.ClebschFiniteRootRecurrenceBridge
