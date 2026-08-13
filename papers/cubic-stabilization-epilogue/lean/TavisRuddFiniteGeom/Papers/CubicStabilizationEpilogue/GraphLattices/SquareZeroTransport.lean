import Mathlib.LinearAlgebra.ExteriorAlgebra.Basic
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.MatrixOfIdeals

/-!
# Decomposable two-forms and injective square-zero transport

This module isolates the two algebraic facts in the manuscript's cohomological
square-zero step: a decomposable alternating two-form squares to zero, and an
injective ring pullback reflects square-zero identities.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace GraphLattices

/-- A decomposable two-form in an exterior algebra has square zero.  A scalar
coefficient may be absorbed into either vector, so this also covers scalar
multiples of decomposable two-forms. -/
theorem exterior_decomposableTwoForm_sq_zero
    {R M : Type*} [CommRing R] [AddCommGroup M] [Module R M]
    (first second : M) :
    (ExteriorAlgebra.ι R first * ExteriorAlgebra.ι R second) ^ 2 = 0 := by
  rw [pow_two]
  have swap :
      ExteriorAlgebra.ι R second * ExteriorAlgebra.ι R first =
        -(ExteriorAlgebra.ι R first * ExteriorAlgebra.ι R second) :=
    eq_neg_of_add_eq_zero_left
      (ExteriorAlgebra.ι_add_mul_swap (R := R) second first)
  calc
    (ExteriorAlgebra.ι R first * ExteriorAlgebra.ι R second) *
        (ExteriorAlgebra.ι R first * ExteriorAlgebra.ι R second) =
      ExteriorAlgebra.ι R first *
        (ExteriorAlgebra.ι R second * ExteriorAlgebra.ι R first) *
          ExteriorAlgebra.ι R second := by noncomm_ring
    _ = ExteriorAlgebra.ι R first *
        (-(ExteriorAlgebra.ι R first * ExteriorAlgebra.ι R second)) *
          ExteriorAlgebra.ι R second := by rw [swap]
    _ = 0 := by
      simp only [mul_neg, ← mul_assoc,
        ExteriorAlgebra.ι_sq_zero, zero_mul, neg_zero]

/-- An injective ring homomorphism reflects a square-zero identity. -/
theorem squareZero_of_injective_ringHom
    {Target Source : Type*} [Ring Target] [Ring Source]
    (pullback : Target →+* Source) (pullbackInjective : Function.Injective pullback)
    (element : Target) (sourceSquareZero : pullback element * pullback element = 0) :
    element * element = 0 := by
  apply pullbackInjective
  rw [map_mul, sourceSquareZero, map_zero]

/-- If an injective pullback intertwines target and source realizations, then
source square-zero for every internal rank-one class supplies the target
square-zero hypothesis needed by all-degree assembly. -/
theorem rankOneSquareZero_of_injectivePullback
    {Index R Target Source : Type*} [CommRing R]
    [CommRing Target] [CommRing Source]
    (uniformizer : R) (diagonal : Index → ℕ) (cross : Index → Index → ℕ)
    (targetRealization : Matrix Index Index R →+ Target)
    (sourceRealization : Matrix Index Index R →+ Source)
    (pullback : Target →+* Source) (pullbackInjective : Function.Injective pullback)
    (realizationCompatible : ∀ candidate,
      pullback (targetRealization candidate) = sourceRealization candidate)
    (sourceRankOneSquareZero : ∀ candidate,
      candidate ∈ weightedRankOneSet uniformizer diagonal cross →
        sourceRealization candidate * sourceRealization candidate = 0) :
    ∀ candidate,
      candidate ∈ weightedRankOneSet uniformizer diagonal cross →
        targetRealization candidate * targetRealization candidate = 0 := by
  intro candidate member
  apply squareZero_of_injective_ringHom pullback pullbackInjective
  rw [realizationCompatible]
  exact sourceRankOneSquareZero candidate member

end GraphLattices

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
