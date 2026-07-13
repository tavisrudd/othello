import RelativeConicArcs.ProjectiveConjugation
import Mathlib.FieldTheory.Finite.Basic

/-!
# Quadratic Frobenius as projective incidence conjugation

For a quadratic extension of finite fields, the relative Frobenius has order two.  Applying it
coordinatewise therefore gives the concrete involutive projective incidence structure used in the
Baer-extension theorem.
-/

namespace RelativeConicArcs
namespace QuadraticFrobenius

open FiniteGeom.BaerCompletion

variable (F E : Type*) [Field F] [Fintype F] [Field E] [Finite E] [Algebra F E]
  [Algebra.IsAlgebraic F E]

/-- Relative Frobenius, forgetting only its `F`-algebra structure. -/
noncomputable def frobeniusRingEquiv : E ≃+* E :=
  (FiniteField.frobeniusAlgEquivOfAlgebraic F E).toRingEquiv

/-- In a quadratic finite-field extension, relative Frobenius is an involution. -/
theorem frobenius_involutive (hdeg : Module.finrank F E = 2) :
    Function.Involutive (frobeniusRingEquiv F E) := by
  intro a
  let σ := FiniteField.frobeniusAlgEquivOfAlgebraic F E
  have hord : orderOf σ = 2 := by
    rw [FiniteField.orderOf_frobeniusAlgEquivOfAlgebraic F E, hdeg]
  have hp := pow_orderOf_eq_one σ
  rw [hord] at hp
  have ha := DFunLike.congr_fun hp a
  simpa [σ, frobeniusRingEquiv, pow_two] using ha

/-- The concrete coordinate Frobenius incidence involution on points and dual lines of
`PG(2,E)`. -/
noncomputable def incidence (hdeg : Module.finrank F E = 2) :
    InvolutiveIncidence
      (ProjectiveConjugation.Point E) (ProjectiveConjugation.Point E) :=
  ProjectiveConjugation.involutiveIncidence (frobeniusRingEquiv F E)
    (frobenius_involutive F E hdeg)

end QuadraticFrobenius
end RelativeConicArcs
