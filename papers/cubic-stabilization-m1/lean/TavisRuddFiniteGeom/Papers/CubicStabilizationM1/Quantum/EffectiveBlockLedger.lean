import Mathlib.Data.Multiset.Sum
import Mathlib.Tactic

/-!
# Effective ledgers of regular-isomorphism classes

A block presentation consists of a type of blocks and the equivalence relation
of regular isomorphism.  Its component type is the quotient by that relation;
equivalently, it is the set of connected components of the thin groupoid whose
isomorphisms are the related pairs.  The effective ledger is the free
commutative additive monoid on those components, represented by multisets.

Every component weight with values in a commutative additive monoid extends
uniquely to an additive fold on the effective ledger.  Thus occurrence
multiplicities are retained, while no subtraction, cancellation, or group
completion is used.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace Quantum

universe u v

/-- A type of blocks together with regular isomorphism as an equivalence
relation. -/
structure BlockPresentation where
  Block : Type u
  regularIsomorphism : Setoid Block

namespace BlockPresentation

/-- The regular-isomorphism component of a presented block. -/
def Component (presentation : BlockPresentation.{u}) : Type u :=
  Quotient presentation.regularIsomorphism

/-- The component represented by a block. -/
def component (presentation : BlockPresentation.{u})
    (block : presentation.Block) : presentation.Component :=
  Quotient.mk presentation.regularIsomorphism block

/-- The effective free commutative monoid on regular-isomorphism components. -/
abbrev EffectiveLedger (presentation : BlockPresentation.{u}) : Type u :=
  Multiset presentation.Component

/-- A block weight invariant under regular isomorphism descends to components. -/
def descendWeight {A : Type v} (presentation : BlockPresentation.{u})
    (weight : presentation.Block → A)
    (invariant : ∀ {left right},
      presentation.regularIsomorphism.r left right → weight left = weight right) :
    presentation.Component → A :=
  Quotient.lift weight (fun _ _ relation => invariant relation)

/-- A weight on components extends additively to the effective ledger. -/
def fold {A : Type v} [AddCommMonoid A]
    (presentation : BlockPresentation.{u})
    (weight : presentation.Component → A) : presentation.EffectiveLedger →+ A where
  toFun ledger := (ledger.map weight).sum
  map_zero' := rfl
  map_add' left right := by simp

/-- A regular-isomorphism-invariant block weight extends additively to the
effective ledger. -/
def foldBlocks {A : Type v} [AddCommMonoid A]
    (presentation : BlockPresentation.{u})
    (weight : presentation.Block → A)
    (invariant : ∀ {left right},
      presentation.regularIsomorphism.r left right → weight left = weight right) :
    presentation.EffectiveLedger →+ A :=
  presentation.fold (presentation.descendWeight weight invariant)

/-- A blockwise matching between two effective ledgers across which a chosen
fold is preserved.  The matching is data, rather than an equality of ledgers:
its paired components may differ, as happens when regular scalar extension or
formal coordinate transport changes the component representative.  Repeated
pairs retain occurrence multiplicity. -/
structure FoldCompatibleLedgerComparison {A : Type v} [AddCommMonoid A]
    (presentation : BlockPresentation.{u})
    (fold : presentation.EffectiveLedger →+ A)
    (left right : presentation.EffectiveLedger) where
  matching : Multiset (presentation.Component × presentation.Component)
  leftLedger : matching.map Prod.fst = left
  rightLedger : matching.map Prod.snd = right
  preservesFold : ∀ pair ∈ matching,
    fold ({pair.1} : presentation.EffectiveLedger) =
      fold ({pair.2} : presentation.EffectiveLedger)

namespace FoldCompatibleLedgerComparison

/-- A blockwise fold-compatible comparison gives equality only after applying
the chosen fold.  No equality of components or effective ledgers is assumed. -/
theorem fold_eq {A : Type v} [AddCommMonoid A]
    (presentation : BlockPresentation.{u})
    (fold : presentation.EffectiveLedger →+ A)
    {left right : presentation.EffectiveLedger}
    (comparison : FoldCompatibleLedgerComparison presentation fold left right) :
    fold left = fold right := by
  have matchedFold :
      ∀ matching : Multiset (presentation.Component × presentation.Component),
        (∀ pair ∈ matching,
          fold ({pair.1} : presentation.EffectiveLedger) =
            fold ({pair.2} : presentation.EffectiveLedger)) →
        fold (matching.map Prod.fst) = fold (matching.map Prod.snd) := by
    intro matching preserves
    induction matching using Multiset.induction_on with
    | empty => simp
    | cons pair tail inductionHypothesis =>
        have headPreserved : fold ({pair.1} : presentation.EffectiveLedger) =
            fold ({pair.2} : presentation.EffectiveLedger) :=
          preserves pair (by simp)
        have tailPreserved : ∀ entry ∈ tail,
            fold ({entry.1} : presentation.EffectiveLedger) =
              fold ({entry.2} : presentation.EffectiveLedger) := by
          intro entry membership
          exact preserves entry (by simp [membership])
        simp only [Multiset.map_cons]
        calc
          fold (pair.1 ::ₘ tail.map Prod.fst) =
              fold ({pair.1} : presentation.EffectiveLedger) +
                fold (tail.map Prod.fst) := by
            rw [← Multiset.singleton_add, map_add]
          _ = fold ({pair.2} : presentation.EffectiveLedger) +
                fold (tail.map Prod.snd) := by
            rw [headPreserved, inductionHypothesis tailPreserved]
          _ = fold (pair.2 ::ₘ tail.map Prod.snd) := by
            rw [← Multiset.singleton_add, map_add]
  calc
    fold left = fold (comparison.matching.map Prod.fst) := by
      rw [comparison.leftLedger]
    _ = fold (comparison.matching.map Prod.snd) :=
      matchedFold comparison.matching comparison.preservesFold
    _ = fold right := by rw [comparison.rightLedger]

end FoldCompatibleLedgerComparison

/-- Descending an invariant weight and evaluating it on a represented component
recovers the original block weight. -/
@[simp]
theorem descendWeight_component {A : Type v}
    (presentation : BlockPresentation.{u})
    (weight : presentation.Block → A)
    (invariant : ∀ {left right},
      presentation.regularIsomorphism.r left right → weight left = weight right)
    (block : presentation.Block) :
    presentation.descendWeight weight invariant (presentation.component block) =
      weight block :=
  rfl

/-- The additive fold sends the empty effective ledger to zero. -/
@[simp]
theorem fold_zero {A : Type v} [AddCommMonoid A]
    (presentation : BlockPresentation.{u})
    (weight : presentation.Component → A) :
    presentation.fold weight 0 = 0 :=
  rfl

/-- Folding the sum of two effective ledgers adds their folded values. -/
@[simp]
theorem fold_add {A : Type v} [AddCommMonoid A]
    (presentation : BlockPresentation.{u})
    (weight : presentation.Component → A)
    (left right : presentation.EffectiveLedger) :
    presentation.fold weight (left + right) =
      presentation.fold weight left + presentation.fold weight right :=
  (presentation.fold weight).map_add left right

/-- The additive fold evaluates a singleton ledger by its component weight. -/
@[simp]
theorem fold_singleton {A : Type v} [AddCommMonoid A]
    (presentation : BlockPresentation.{u})
    (weight : presentation.Component → A)
    (component : presentation.Component) :
    presentation.fold weight ({component} : presentation.EffectiveLedger) =
      weight component := by
  simp [fold]

/-- Folding the singleton component represented by a block recovers the
invariant weight of that block. -/
@[simp]
theorem foldBlocks_singleton {A : Type v} [AddCommMonoid A]
    (presentation : BlockPresentation.{u})
    (weight : presentation.Block → A)
    (invariant : ∀ {left right},
      presentation.regularIsomorphism.r left right → weight left = weight right)
    (block : presentation.Block) :
    presentation.foldBlocks weight invariant
        ({presentation.component block} : presentation.EffectiveLedger) =
      weight block := by
  simp [foldBlocks]

/-- An additive map out of the effective ledger is determined by its values on
singleton components. -/
theorem fold_singleton_values {A : Type v} [AddCommMonoid A]
    (presentation : BlockPresentation.{u})
    (homomorphism : presentation.EffectiveLedger →+ A)
    (ledger : presentation.EffectiveLedger) :
    presentation.fold
        (fun component => homomorphism ({component} : presentation.EffectiveLedger))
        ledger =
      homomorphism ledger := by
  induction ledger using Multiset.induction_on with
  | empty => simp
  | cons component tail inductionHypothesis =>
      calc
        presentation.fold
              (fun entry => homomorphism ({entry} : presentation.EffectiveLedger))
              (component ::ₘ tail) =
            presentation.fold
              (fun entry => homomorphism ({entry} : presentation.EffectiveLedger))
              (({component} : presentation.EffectiveLedger) + tail) := by
                rw [Multiset.singleton_add]
        _ = presentation.fold
              (fun entry => homomorphism ({entry} : presentation.EffectiveLedger))
              ({component} : presentation.EffectiveLedger) +
            presentation.fold
              (fun entry => homomorphism ({entry} : presentation.EffectiveLedger))
              tail := by rw [map_add]
        _ = homomorphism ({component} : presentation.EffectiveLedger) +
            homomorphism tail := by rw [presentation.fold_singleton, inductionHypothesis]
        _ = homomorphism
              (({component} : presentation.EffectiveLedger) + tail) := by
                rw [homomorphism.map_add]
        _ = homomorphism (component ::ₘ tail) := by rw [Multiset.singleton_add]

/-- The additive fold is the unique additive extension of a prescribed
component weight. -/
theorem fold_unique {A : Type v} [AddCommMonoid A]
    (presentation : BlockPresentation.{u})
    (weight : presentation.Component → A)
    (homomorphism : presentation.EffectiveLedger →+ A)
    (onSingleton : ∀ component,
      homomorphism ({component} : presentation.EffectiveLedger) = weight component) :
    homomorphism = presentation.fold weight := by
  ext component
  rw [onSingleton, presentation.fold_singleton]

end BlockPresentation

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
