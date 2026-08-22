import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.EffectiveBlockLedger

/-!
# Effective block ledgers insensitive to grading suspension

Quantum-D-module comparison maps can be homogeneous of nonzero degree even
when they preserve the underlying connection, pairing, and centered Euler
operator.  A ledger whose block type remembers an absolute cohomological
grading therefore cannot treat such a comparison as a degree-zero regular
isomorphism.

This module records the correction explicitly.  A suspension action shifts a
regular-isomorphism component by an integer degree.  A comparison matches each
component on the left with a suspended component on the right, and a fold is
admissible when its singleton value is unchanged by every suspension.  The
resulting comparison gives equality after folding.  Forgetting absolute
grading is the trivial suspension action; retaining grading requires the
nontrivial action and the same invariance law.

The construction is purely categorical.  It does not assert that a geometric
comparison exists or identify the degree of any external comparison map.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Quantum

universe u v

namespace BlockPresentation

/-- An additive integer suspension action on regular-isomorphism components.
The order convention is `shift (first + second) = shift first ∘ shift second`;
commutativity of integer addition makes the opposite convention equivalent. -/
structure ComponentSuspension (presentation : BlockPresentation.{u}) where
  shift : ℤ → presentation.Component → presentation.Component
  shift_zero : ∀ component, shift 0 component = component
  shift_add : ∀ first second component,
    shift (first + second) component = shift first (shift second component)

/-- Forgetting absolute grading gives the trivial suspension action. -/
def ComponentSuspension.trivial (presentation : BlockPresentation.{u}) :
    ComponentSuspension presentation where
  shift := fun _ component => component
  shift_zero := fun _ => rfl
  shift_add := fun _ _ _ => rfl

/-- A fold is suspension-invariant when shifting one component by any integer
degree does not change the folded value of its singleton ledger. -/
def ComponentSuspension.FoldInvariant {A : Type v} [AddCommMonoid A]
    {presentation : BlockPresentation.{u}}
    (suspension : ComponentSuspension presentation)
    (fold : presentation.EffectiveLedger →+ A) : Prop :=
  ∀ degree component,
    fold ({suspension.shift degree component} : presentation.EffectiveLedger) =
      fold ({component} : presentation.EffectiveLedger)

/-- Every fold is invariant under the trivial suspension action. -/
theorem ComponentSuspension.foldInvariant_trivial
    {A : Type v} [AddCommMonoid A]
    (presentation : BlockPresentation.{u})
    (fold : presentation.EffectiveLedger →+ A) :
    (ComponentSuspension.trivial presentation).FoldInvariant fold := by
  intro degree component
  rfl

/-- One pair of components in a homogeneous comparison, together with the
integer suspension needed on the right component. -/
structure SuspendedComponentPair {presentation : BlockPresentation.{u}}
    (suspension : ComponentSuspension presentation) where
  left : presentation.Component
  right : presentation.Component
  degree : ℤ
  related : left = suspension.shift degree right

/-- A multiplicity-preserving matching of two ledgers by homogeneous
component comparisons.  Repeated entries remain repeated in the multiset. -/
structure SuspensionCompatibleLedgerComparison
    (presentation : BlockPresentation.{u})
    (suspension : ComponentSuspension presentation)
    (left right : presentation.EffectiveLedger) where
  matching : Multiset (SuspendedComponentPair suspension)
  leftLedger : matching.map SuspendedComponentPair.left = left
  rightLedger : matching.map SuspendedComponentPair.right = right

namespace SuspensionCompatibleLedgerComparison

/-- A suspension-compatible matching becomes an ordinary fold-compatible
matching as soon as the fold is invariant under suspension. -/
def toFoldCompatible {A : Type v} [AddCommMonoid A]
    {presentation : BlockPresentation.{u}}
    {suspension : ComponentSuspension presentation}
    {left right : presentation.EffectiveLedger}
    (comparison : SuspensionCompatibleLedgerComparison presentation suspension left right)
    (fold : presentation.EffectiveLedger →+ A)
    (invariant : suspension.FoldInvariant fold) :
    FoldCompatibleLedgerComparison presentation fold left right where
  matching := comparison.matching.map fun pair => (pair.left, pair.right)
  leftLedger := by
    rw [Multiset.map_map]
    simpa using comparison.leftLedger
  rightLedger := by
    rw [Multiset.map_map]
    simpa using comparison.rightLedger
  preservesFold := by
    intro pair membership
    simp only [Multiset.mem_map] at membership
    obtain ⟨suspendedPair, inMatching, equality⟩ := membership
    cases equality
    rw [suspendedPair.related]
    exact invariant suspendedPair.degree suspendedPair.right

/-- Homogeneous component matching preserves every suspension-invariant fold.
This is the ledger equality used when an external comparison has nonzero
homogeneous degree. -/
theorem fold_eq {A : Type v} [AddCommMonoid A]
    {presentation : BlockPresentation.{u}}
    {suspension : ComponentSuspension presentation}
    (fold : presentation.EffectiveLedger →+ A)
    (invariant : suspension.FoldInvariant fold)
    {left right : presentation.EffectiveLedger}
    (comparison : SuspensionCompatibleLedgerComparison presentation suspension left right) :
    fold left = fold right :=
  (comparison.toFoldCompatible fold invariant).fold_eq presentation fold

end SuspensionCompatibleLedgerComparison

end BlockPresentation

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
