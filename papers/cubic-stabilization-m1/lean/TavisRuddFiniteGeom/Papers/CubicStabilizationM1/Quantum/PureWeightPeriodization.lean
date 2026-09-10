import Mathlib.Tactic
import Mathlib.Data.Finsupp.Basic

/-!
# Recovery of a fixed weight after Tate periodization

An integral twist action changes the weight by minus twice its parameter.
Its orbit quotient therefore identifies no two distinct labels of the same
fixed weight. The proof extracts the actual twist from orbit equality and
forces its parameter to be zero. Consequently periodization is injective on
finite simple-multiplicity vectors supported in that fixed weight. This is
the orbit bookkeeping used to recover pure weight-three objects; construction
of Hodge simple labels and their weight function remains external.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum

/-- An actual integral action on simple labels, with its zero and composition laws. -/
structure IntegralTwistAction (Label : Type*) where
  twist : ℤ → Label → Label
  zero : ∀ label, twist 0 label=label
  add : ∀ m n label, twist (m+n) label=twist m (twist n label)

/-- The orbit relation identifies precisely labels joined by an integral twist. -/
def IntegralTwistAction.orbitSetoid {Label : Type*} (action : IntegralTwistAction Label) : Setoid Label where
  r left right := ∃ n : ℤ, action.twist n left=right
  iseqv := ⟨fun label => ⟨0,action.zero label⟩,
    by
      rintro left right ⟨n,hn⟩
      refine ⟨-n,?_⟩
      rw [← hn, ← action.add, neg_add_cancel, action.zero],
    by
      rintro left middle right ⟨n,hn⟩ ⟨m,hm⟩
      exact ⟨m+n,by rw [action.add,hn,hm]⟩⟩

/-- Periodize a label from a fixed pure-weight slice. -/
def IntegralTwistAction.pureWeightMap
    {Label : Type*} (action : IntegralTwistAction Label) (weight : Label → ℤ) (fixedWeight : ℤ) :
    {label // weight label=fixedWeight} → Quotient action.orbitSetoid :=
  fun label => Quotient.mk action.orbitSetoid label.val

/-- Equality after periodization of fixed-weight labels forces the actual
twist to be zero and hence the original labels to be equal. -/
theorem IntegralTwistAction.pureWeightMap_injective
    {Label : Type*} (action : IntegralTwistAction Label) (weight : Label → ℤ)
    (shift : ∀ n label, weight (action.twist n label)=weight label-2*n) (fixedWeight : ℤ) :
    Function.Injective (action.pureWeightMap weight fixedWeight) := by
  intro left right equal
  obtain ⟨n,hn⟩ := Quotient.exact equal
  have weights := congrArg weight hn
  rw [shift,left.property,right.property] at weights
  have zero : n=0 := by omega
  rw [zero,action.zero] at hn
  exact Subtype.ext hn

/-- Finite simple multiplicities in one fixed weight are recovered uniquely
from their periodized multiplicities. No nonzero Tate twist is discarded
when lifting the equality back to the pure category. -/
theorem IntegralTwistAction.pureWeightMultiplicity_injective
    {Label : Type*} (action : IntegralTwistAction Label) (weight : Label → ℤ)
    (shift : ∀ n label, weight (action.twist n label)=weight label-2*n) (fixedWeight : ℤ) :
    Function.Injective (Finsupp.mapDomain (action.pureWeightMap weight fixedWeight) :
      ({label // weight label=fixedWeight} →₀ ℕ) → Quotient action.orbitSetoid →₀ ℕ) :=
  Finsupp.mapDomain_injective (action.pureWeightMap_injective weight shift fixedWeight)

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum
