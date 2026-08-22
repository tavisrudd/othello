import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Algebra.Group.Pi.Basic
import Mathlib.Data.Set.Finite.Basic

/-!
# Finite coefficient sums for numerical Novikov quotients

This module formalizes the finiteness mechanism that makes coefficientwise
pushforward from homological to numerical effective classes well defined.
It does not construct the completed monoid-ring multiplication or the quantum
connection over it.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace Quantum

open scoped BigOperators

variable {Homology Numerical : Type*}

/-- A quotient of effective homological classes by numerical equivalence,
together with compatible degree functions and finite bounded homological
pieces. -/
structure NumericallyFiniteEffectiveQuotient
    [AddCommMonoid Homology] [AddCommMonoid Numerical] where
  quotient : Homology →+ Numerical
  homologicalDegree : Homology → ℕ
  numericalDegree : Numerical → ℕ
  degree_compatible : ∀ degree,
    numericalDegree (quotient degree) = homologicalDegree degree
  bounded_homological : ∀ cutoff,
    Set.Finite {degree | homologicalDegree degree ≤ cutoff}

namespace NumericallyFiniteEffectiveQuotient

variable [AddCommMonoid Homology] [AddCommMonoid Numerical]

/-- The finite set of homological classes over one numerical class, cut out
inside the bounded-degree piece determined by that numerical class. -/
noncomputable def fiber
    (data : NumericallyFiniteEffectiveQuotient
      (Homology := Homology) (Numerical := Numerical))
    (numerical : Numerical) : Finset Homology := by
  classical
  exact
    (data.bounded_homological (data.numericalDegree numerical)).toFinset.filter
      fun homological ↦ data.quotient homological = numerical

/-- Membership in the finite fiber is exactly equality after numerical
quotient; the degree cutoff is automatic from degree compatibility. -/
theorem mem_fiber_iff
    (data : NumericallyFiniteEffectiveQuotient
      (Homology := Homology) (Numerical := Numerical))
    (homological : Homology) (numerical : Numerical) :
    homological ∈ data.fiber numerical ↔
      data.quotient homological = numerical := by
  classical
  simp only [fiber, Finset.mem_filter, Set.Finite.mem_toFinset]
  constructor
  · intro membership
    exact membership.2
  · intro equality
    constructor
    · change data.homologicalDegree homological ≤ data.numericalDegree numerical
      rw [← data.degree_compatible homological, equality]
    · exact equality

/-- Coefficientwise pushforward: the coefficient at a numerical class is the
finite sum of all homological coefficients in its fiber. -/
noncomputable def coefficientPushforward
    (data : NumericallyFiniteEffectiveQuotient
      (Homology := Homology) (Numerical := Numerical))
    {R : Type*} [AddCommMonoid R] :
    (Homology → R) →+ (Numerical → R) where
  toFun series numerical := ∑ degree ∈ data.fiber numerical, series degree
  map_zero' := by
    ext numerical
    simp
  map_add' left right := by
    ext numerical
    simp [Finset.sum_add_distrib]

/-- The pushforward coefficient has the displayed finite-fiber formula. -/
theorem coefficientPushforward_apply
    (data : NumericallyFiniteEffectiveQuotient
      (Homology := Homology) (Numerical := Numerical))
    {R : Type*} [AddCommMonoid R]
    (series : Homology → R) (numerical : Numerical) :
    data.coefficientPushforward series numerical =
      ∑ degree ∈ data.fiber numerical, series degree :=
  rfl

end NumericallyFiniteEffectiveQuotient

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
