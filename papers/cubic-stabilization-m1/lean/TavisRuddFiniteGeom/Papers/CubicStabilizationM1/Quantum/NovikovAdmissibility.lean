import Mathlib.Topology.Algebra.Ring.Basic
import Mathlib.Topology.UniformSpace.CompleteSeparated

/-!
# Strict Novikov admissibility: algebraic core

The manuscript uses a complete separated valued domain and a positive proper
valuation law on effective numerical monomials.  This module packages those
conditions without constructing a completed monoid ring or its associated
graded ring.  The global multiplicativity field is the no-cancellation input
used from the associated-graded domain condition.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace Quantum

variable {Curve Target : Type*}

/-- Data and laws for the algebraic core of a strictly Novikov-admissible
monomial specialization.  `Curve` is the effective numerical monoid and
`Target` is a complete separated topological domain. -/
structure StrictNovikovAdmissible
    [AddCommMonoid Curve] [CommRing Target] [IsDomain Target]
    [UniformSpace Target] [CompleteSpace Target] [T2Space Target]
    [IsTopologicalRing Target] where
  monomialImage : Curve → Target
  monomialImage_zero : monomialImage 0 = 1
  monomialImage_add : ∀ left right,
    monomialImage (left + right) = monomialImage left * monomialImage right
  monomialImage_ne_zero : ∀ degree, monomialImage degree ≠ 0
  length : Curve → ℕ
  valuation : Target → ℕ
  valuation_law : ∀ degree, valuation (monomialImage degree) = length degree
  positive : ∀ degree, degree ≠ 0 → 0 < length degree
  proper : ∀ cutoff, Set.Finite {degree | length degree ≤ cutoff}
  valuation_mul : ∀ {left right : Target}, left ≠ 0 → right ≠ 0 →
    valuation (left * right) = valuation left + valuation right

/-- Integral divisor tags that separate numerical curve classes make the
tagged monomial map injective, even when the untagged target monomials collide.
This is the individual-class separation step underlying divisor tagging; it
does not prove separation of linear combinations or completed series. -/
theorem StrictNovikovAdmissible.injective_taggedMonomial
    [AddCommMonoid Curve] [CommRing Target] [IsDomain Target]
    [UniformSpace Target] [CompleteSpace Target] [T2Space Target]
    [IsTopologicalRing Target]
    (specialization : StrictNovikovAdmissible (Curve := Curve) (Target := Target))
    {Tag : Type*} (divisorTag : Curve → Tag) (separates : Function.Injective divisorTag) :
    Function.Injective (fun degree ↦ (specialization.monomialImage degree,
      divisorTag degree)) := by
  intro left right equality
  exact separates (congrArg Prod.snd equality)

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
