import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.NumericalNovikov
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.CompletedNovikovSupport

/-!
# Numerical pushforward on completed Novikov coefficient families

Let a homomorphism from an effective homology monoid to an effective numerical
monoid preserve a natural-number degree, and suppose every bounded homological
degree set is finite.  This module proves that coefficientwise summation over
the exact finite fibers sends completed homological coefficient families to
completed numerical coefficient families.

This is the coefficient-level additive extension appearing in the numerical
Novikov base-change lemma.  No topology or inverse-limit object is represented,
so continuity is not asserted.  The module also does not construct completed
convolution multiplication, quantum products, Gromov--Witten invariants,
Novikov derivations, or the Iritani comparison maps and their inverses.  All
proofs are symbolic and kernel checked, with no external computation or oracle.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Quantum

open scoped BigOperators

variable {Homology Numerical R : Type*}

namespace NumericallyFiniteEffectiveQuotient

variable [AddCommMonoid Homology] [AddCommMonoid Numerical]

/-- Numerical coefficient pushforward preserves the completion support
condition: below a numerical degree cutoff, a nonzero output coefficient can
occur only in the finite image of the bounded homological set. -/
noncomputable def completedCoefficientPushforward
    (data : NumericallyFiniteEffectiveQuotient
      (Homology := Homology) (Numerical := Numerical))
    [AddCommGroup R]
    (series : CompletedNovikovSeries Homology R data.homologicalDegree) :
    CompletedNovikovSeries Numerical R data.numericalDegree where
  coefficient := data.coefficientPushforward series.coefficient
  finite_below cutoff := by
    classical
    refine ((data.bounded_homological cutoff).toFinset.image
      data.quotient).finite_toSet.subset ?_
    intro numerical membership
    rcases membership with ⟨coefficient_nonzero, degree_le⟩
    by_contra numerical_not_image
    apply coefficient_nonzero
    rw [data.coefficientPushforward_apply]
    apply Finset.sum_eq_zero
    intro homological homological_mem
    by_contra homological_nonzero
    apply numerical_not_image
    apply Finset.mem_image.mpr
    refine ⟨homological, ?_, ?_⟩
    · simpa only [Set.Finite.mem_toFinset, Set.mem_setOf_eq] using (show
        data.homologicalDegree homological ≤ cutoff by
        rw [← data.degree_compatible homological,
          (data.mem_fiber_iff homological numerical).mp homological_mem]
        exact degree_le)
    · exact (data.mem_fiber_iff homological numerical).mp homological_mem

/-- The completed numerical coefficient has the exact finite-fiber formula. -/
theorem completedCoefficientPushforward_apply
    (data : NumericallyFiniteEffectiveQuotient
      (Homology := Homology) (Numerical := Numerical))
    [AddCommGroup R]
    (series : CompletedNovikovSeries Homology R data.homologicalDegree)
    (numerical : Numerical) :
    (data.completedCoefficientPushforward series).coefficient numerical =
      ∑ homological ∈ data.fiber numerical, series.coefficient homological :=
  rfl

/-- Additivity of completed numerical coefficient pushforward. -/
theorem completedCoefficientPushforward_add
    (data : NumericallyFiniteEffectiveQuotient
      (Homology := Homology) (Numerical := Numerical))
    [AddCommGroup R]
    (left right : CompletedNovikovSeries Homology R data.homologicalDegree) :
    data.completedCoefficientPushforward (left + right) =
      data.completedCoefficientPushforward left +
        data.completedCoefficientPushforward right := by
  apply CompletedNovikovSeries.ext
  exact data.coefficientPushforward.map_add left.coefficient right.coefficient

/-- Coefficient-filtration compatibility: agreement of two homological
families through a degree cutoff implies agreement of their numerical
pushforwards through the same cutoff.  This is the exact finite-level property
used by the inverse-limit argument, without introducing a topology or an
inverse-limit object. -/
theorem completedCoefficientPushforward_eq_below_of_eq_below
    (data : NumericallyFiniteEffectiveQuotient
      (Homology := Homology) (Numerical := Numerical))
    [AddCommGroup R]
    (left right : CompletedNovikovSeries Homology R data.homologicalDegree)
    (cutoff : ℕ)
    (equal_below : ∀ homological,
      data.homologicalDegree homological ≤ cutoff →
        left.coefficient homological = right.coefficient homological) :
    ∀ numerical, data.numericalDegree numerical ≤ cutoff →
      (data.completedCoefficientPushforward left).coefficient numerical =
        (data.completedCoefficientPushforward right).coefficient numerical := by
  intro numerical numerical_below
  rw [data.completedCoefficientPushforward_apply,
    data.completedCoefficientPushforward_apply]
  apply Finset.sum_congr rfl
  intro homological homological_mem
  apply equal_below homological
  rw [← data.degree_compatible homological,
    (data.mem_fiber_iff homological numerical).mp homological_mem]
  exact numerical_below

end NumericallyFiniteEffectiveQuotient

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
