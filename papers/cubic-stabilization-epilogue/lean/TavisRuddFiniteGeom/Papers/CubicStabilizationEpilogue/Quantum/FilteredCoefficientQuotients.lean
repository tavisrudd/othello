import Mathlib.RingTheory.Ideal.Quotient.Defs

/-!
# Quotients of a decreasing ideal filtration

A decreasing sequence of ideals in a commutative ring gives coefficient rings
at finite levels and canonical reduction maps from level `n + 1` to level `n`.
An endomorphism preserving every ideal descends to every quotient, and the
descended endomorphisms commute with reduction.  Thus the coefficient rings,
reductions, and compatible substitutions used by a finite-level formal base
shift can be constructed from explicit filtered-ring data.

This module does not construct the manuscript's coefficient ring or its
filtration, prove completeness or separatedness, identify the quotients with
geometric coefficient rings, or construct monodromy matrices and gauges.  All
proofs are symbolic and kernel checked, with no external computation or oracle.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Quantum

universe u

/-- A decreasing natural-number-indexed ideal filtration of a commutative
ring. -/
structure DecreasingIdealFiltration (R : Type u) [CommRing R] where
  ideal : ℕ → Ideal R
  antitone : Antitone ideal

namespace DecreasingIdealFiltration

/-- The coefficient ring obtained by quotienting by the ideal at a given
level. -/
abbrev QuotientRing {R : Type u} [CommRing R]
    (filtration : DecreasingIdealFiltration R) (level : ℕ) :=
  R ⧸ filtration.ideal level

/-- The canonical reduction from the quotient at level `n + 1` to the quotient
at level `n`. -/
def reduction {R : Type u} [CommRing R]
    (filtration : DecreasingIdealFiltration R) (level : ℕ) :
    filtration.QuotientRing (level + 1) →+* filtration.QuotientRing level :=
  Ideal.Quotient.factor (filtration.antitone (Nat.le_succ level))

/-- Reduction sends the class of a ring element to its class at the lower
level. -/
@[simp]
theorem reduction_mk {R : Type u} [CommRing R]
    (filtration : DecreasingIdealFiltration R) (level : ℕ) (value : R) :
    filtration.reduction level
        (Ideal.Quotient.mk (filtration.ideal (level + 1)) value) =
      Ideal.Quotient.mk (filtration.ideal level) value :=
  Ideal.Quotient.factor_mk _ _

/-- A ring endomorphism preserving each ideal of a decreasing filtration. -/
structure PreservingEndomorphism {R : Type u} [CommRing R]
    (filtration : DecreasingIdealFiltration R) where
  toRingHom : R →+* R
  maps_mem : ∀ level value, value ∈ filtration.ideal level →
    toRingHom value ∈ filtration.ideal level

namespace PreservingEndomorphism

/-- The endomorphism induced on one quotient ring. -/
def quotientEndomorphism {R : Type u} [CommRing R]
    {filtration : DecreasingIdealFiltration R}
    (endomorphism : filtration.PreservingEndomorphism) (level : ℕ) :
    filtration.QuotientRing level →+* filtration.QuotientRing level :=
  Ideal.Quotient.lift (filtration.ideal level)
    ((Ideal.Quotient.mk (filtration.ideal level)).comp endomorphism.toRingHom)
    (by
      intro value hvalue
      rw [RingHom.comp_apply, Ideal.Quotient.eq_zero_iff_mem]
      exact endomorphism.maps_mem level value hvalue)

/-- The quotient endomorphism sends the class of a ring element to the class
of its image. -/
@[simp]
theorem quotientEndomorphism_mk {R : Type u} [CommRing R]
    {filtration : DecreasingIdealFiltration R}
    (endomorphism : filtration.PreservingEndomorphism) (level : ℕ)
    (value : R) :
    endomorphism.quotientEndomorphism level
        (Ideal.Quotient.mk (filtration.ideal level) value) =
      Ideal.Quotient.mk (filtration.ideal level)
        (endomorphism.toRingHom value) :=
  rfl

/-- The quotient endomorphisms commute with every adjacent reduction map. -/
theorem reduction_quotientEndomorphism {R : Type u} [CommRing R]
    {filtration : DecreasingIdealFiltration R}
    (endomorphism : filtration.PreservingEndomorphism) (level : ℕ)
    (coefficient : filtration.QuotientRing (level + 1)) :
    filtration.reduction level
        (endomorphism.quotientEndomorphism (level + 1) coefficient) =
      endomorphism.quotientEndomorphism level
        (filtration.reduction level coefficient) := by
  induction coefficient using Quotient.inductionOn' with
  | _ value => rfl

end PreservingEndomorphism

end DecreasingIdealFiltration

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
