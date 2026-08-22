import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.EffectiveBlockLedger
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Tactic

/-!
# Occurrence-indexed marker descent

This module isolates the categorical bookkeeping used by marker arguments in
weak factorization.  A variety and every actual comparison occurrence receive
effective block ledgers.  An arbitrary additive fold supplies their marker
values.  A blowup formula keeps its `c - 1` center occurrences separately
indexed until after the fold.

If all smooth centers of dimension at most `d - 2` have zero occurrence
markers, each blowup or blowdown link in ambient dimension `d` preserves the
marker.  Preservation then telescopes along a factorization chain and descends
to the quotient by the supplied birational equivalence relation.  Only the
additive monoid laws are used; no cancellation is required.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace Quantum

open scoped BigOperators

universe u v w x y

/-- Ledger data for varieties and for the actual specialized center
occurrences appearing in operation formulas. -/
structure OccurrenceIndexedLedger
    (Variety : Type u) (Center : Type v) (Occurrence : Type w)
    (presentation : BlockPresentation.{x}) where
  varietyLedger : Variety → presentation.EffectiveLedger
  occurrenceLedger : Occurrence → presentation.EffectiveLedger
  occurrenceSource : Occurrence → Center
  dimension : Variety → ℕ
  centerDimension : Center → ℕ
  smoothProjective : Variety → Prop
  smoothCenter : Center → Prop

namespace OccurrenceIndexedLedger

variable {Variety : Type u} {Center : Type v} {Occurrence : Type w}
variable {presentation : BlockPresentation.{x}}

/-- The marker of a variety obtained by folding its effective ledger. -/
def varietyMarker {A : Type y} [AddCommMonoid A]
    (data : OccurrenceIndexedLedger Variety Center Occurrence presentation)
    (fold : presentation.EffectiveLedger →+ A) (variety : Variety) : A :=
  fold (data.varietyLedger variety)

/-- The marker of one actual specialized center occurrence. -/
def occurrenceMarker {A : Type y} [AddCommMonoid A]
    (data : OccurrenceIndexedLedger Variety Center Occurrence presentation)
    (fold : presentation.EffectiveLedger →+ A) (occurrence : Occurrence) : A :=
  fold (data.occurrenceLedger occurrence)

end OccurrenceIndexedLedger

/-- The folded numerical content of a projective-bundle comparison.  The
geometric comparison theorem is supplied as data rather than asserted here. -/
structure ProjectiveBundleMarkerFormula
    {Variety : Type u} {Center : Type v} {Occurrence : Type w}
    {presentation : BlockPresentation.{x}}
    (data : OccurrenceIndexedLedger Variety Center Occurrence presentation)
    {A : Type y} [AddCommMonoid A]
    (fold : presentation.EffectiveLedger →+ A)
    (base total : Variety) (rank : ℕ) : Prop where
  baseSmooth : data.smoothProjective base
  totalSmooth : data.smoothProjective total
  rankPositive : 1 ≤ rank
  dimensionFormula : data.dimension total = data.dimension base + rank - 1
  markerFormula : data.varietyMarker fold total = rank • data.varietyMarker fold base

/-- A projective-bundle block matching across which the fold is preserved
produces the folded projective-bundle marker formula.  The comparison itself
is an explicit input: this theorem checks the categorical additivity step and
does not construct the geometric QDM comparison. -/
theorem projectiveBundleMarkerFormula_of_ledgerComparison
    {Variety : Type u} {Center : Type v} {Occurrence : Type w}
    {presentation : BlockPresentation.{x}}
    (data : OccurrenceIndexedLedger Variety Center Occurrence presentation)
    {A : Type y} [AddCommMonoid A]
    (fold : presentation.EffectiveLedger →+ A)
    (base total : Variety) (rank : ℕ)
    (baseSmooth : data.smoothProjective base)
    (totalSmooth : data.smoothProjective total)
    (rankPositive : 1 ≤ rank)
    (dimensionFormula : data.dimension total = data.dimension base + rank - 1)
    (comparison : BlockPresentation.FoldCompatibleLedgerComparison
      presentation fold (data.varietyLedger total)
        (rank • data.varietyLedger base)) :
    ProjectiveBundleMarkerFormula data fold base total rank where
  baseSmooth := baseSmooth
  totalSmooth := totalSmooth
  rankPositive := rankPositive
  dimensionFormula := dimensionFormula
  markerFormula := by
    change fold (data.varietyLedger total) = rank • fold (data.varietyLedger base)
    calc
      fold (data.varietyLedger total) =
          fold (rank • data.varietyLedger base) :=
        comparison.fold_eq presentation fold
      _ = rank • fold (data.varietyLedger base) := by simp

/-- A directed blowup formula from `lower` to `upper`.  The function
`occurrence` names every one of the `codimension - 1` comparison occurrences;
it is not replaced by a set of possible marker values. -/
structure OccurrenceBlowupStep
    {Variety : Type u} {Center : Type v} {Occurrence : Type w}
    {presentation : BlockPresentation.{x}}
    (data : OccurrenceIndexedLedger Variety Center Occurrence presentation)
    {A : Type y} [AddCommMonoid A]
    (fold : presentation.EffectiveLedger →+ A)
    (ambientDimension : ℕ) (lower upper : Variety) where
  center : Center
  codimension : ℕ
  occurrence : Fin (codimension - 1) → Occurrence
  occurrenceSource : ∀ index, data.occurrenceSource (occurrence index) = center
  lowerSmooth : data.smoothProjective lower
  upperSmooth : data.smoothProjective upper
  centerSmooth : data.smoothCenter center
  lowerDimension : data.dimension lower = ambientDimension
  upperDimension : data.dimension upper = ambientDimension
  codimensionAtLeastTwo : 2 ≤ codimension
  centerAmbientDimension :
    data.centerDimension center + codimension = ambientDimension
  markerFormula :
    data.varietyMarker fold upper = data.varietyMarker fold lower +
      ∑ index, data.occurrenceMarker fold (occurrence index)

/-- An occurrence-indexed block matching across which the fold is preserved
gives the folded blowup marker formula, with every center occurrence retained
separately. -/
theorem blowupMarkerFormula_of_ledgerComparison
    {Variety : Type u} {Center : Type v} {Occurrence : Type w}
    {presentation : BlockPresentation.{x}}
    (data : OccurrenceIndexedLedger Variety Center Occurrence presentation)
    {A : Type y} [AddCommMonoid A]
    (fold : presentation.EffectiveLedger →+ A)
    (lower upper : Variety) {codimension : ℕ}
    (occurrence : Fin (codimension - 1) → Occurrence)
    (comparison : BlockPresentation.FoldCompatibleLedgerComparison
      presentation fold (data.varietyLedger upper)
        (data.varietyLedger lower +
          ∑ index, data.occurrenceLedger (occurrence index))) :
    data.varietyMarker fold upper = data.varietyMarker fold lower +
      ∑ index, data.occurrenceMarker fold (occurrence index) := by
  change fold (data.varietyLedger upper) =
    fold (data.varietyLedger lower) +
      ∑ index, fold (data.occurrenceLedger (occurrence index))
  calc
    fold (data.varietyLedger upper) =
        fold (data.varietyLedger lower +
          ∑ index, data.occurrenceLedger (occurrence index)) :=
      comparison.fold_eq presentation fold
    _ = fold (data.varietyLedger lower) +
        ∑ index, fold (data.occurrenceLedger (occurrence index)) := by simp

/-- Package an occurrence-indexed fold-compatible block matching and the
geometric metadata into the directed blowup step consumed by categorical
descent. -/
def occurrenceBlowupStep_of_ledgerComparison
    {Variety : Type u} {Center : Type v} {Occurrence : Type w}
    {presentation : BlockPresentation.{x}}
    (data : OccurrenceIndexedLedger Variety Center Occurrence presentation)
    {A : Type y} [AddCommMonoid A]
    (fold : presentation.EffectiveLedger →+ A)
    (ambientDimension : ℕ) (lower upper : Variety)
    (center : Center) (codimension : ℕ)
    (occurrence : Fin (codimension - 1) → Occurrence)
    (occurrenceSource :
      ∀ index, data.occurrenceSource (occurrence index) = center)
    (lowerSmooth : data.smoothProjective lower)
    (upperSmooth : data.smoothProjective upper)
    (centerSmooth : data.smoothCenter center)
    (lowerDimension : data.dimension lower = ambientDimension)
    (upperDimension : data.dimension upper = ambientDimension)
    (codimensionAtLeastTwo : 2 ≤ codimension)
    (centerAmbientDimension :
      data.centerDimension center + codimension = ambientDimension)
    (comparison : BlockPresentation.FoldCompatibleLedgerComparison
      presentation fold (data.varietyLedger upper)
        (data.varietyLedger lower +
          ∑ index, data.occurrenceLedger (occurrence index))) :
    OccurrenceBlowupStep data fold ambientDimension lower upper where
  center := center
  codimension := codimension
  occurrence := occurrence
  occurrenceSource := occurrenceSource
  lowerSmooth := lowerSmooth
  upperSmooth := upperSmooth
  centerSmooth := centerSmooth
  lowerDimension := lowerDimension
  upperDimension := upperDimension
  codimensionAtLeastTwo := codimensionAtLeastTwo
  centerAmbientDimension := centerAmbientDimension
  markerFormula :=
    blowupMarkerFormula_of_ledgerComparison data fold lower upper occurrence
      comparison

/-- Vanishing for every actual occurrence whose smooth source has codimension
at least two in ambient dimension `d`. -/
def LowDimensionalOccurrenceNullity
    {Variety : Type u} {Center : Type v} {Occurrence : Type w}
    {presentation : BlockPresentation.{x}}
    (data : OccurrenceIndexedLedger Variety Center Occurrence presentation)
    {A : Type y} [AddCommMonoid A]
    (fold : presentation.EffectiveLedger →+ A) (d : ℕ) : Prop :=
  ∀ occurrence,
    data.smoothCenter (data.occurrenceSource occurrence) →
    data.centerDimension (data.occurrenceSource occurrence) + 2 ≤ d →
    data.occurrenceMarker fold occurrence = 0

namespace OccurrenceBlowupStep

variable {Variety : Type u} {Center : Type v} {Occurrence : Type w}
variable {presentation : BlockPresentation.{x}}
variable (data : OccurrenceIndexedLedger Variety Center Occurrence presentation)
variable {A : Type y} [AddCommMonoid A]
variable (fold : presentation.EffectiveLedger →+ A)
variable {d : ℕ} {lower upper : Variety}

/-- Low-dimensional occurrence nullity removes every correction term in one
directed blowup formula. -/
theorem marker_eq
    (step : OccurrenceBlowupStep data fold d lower upper)
    (nullity : LowDimensionalOccurrenceNullity data fold d) :
    data.varietyMarker fold upper = data.varietyMarker fold lower := by
  have centerBound : data.centerDimension step.center + 2 ≤ d := by
    calc
      data.centerDimension step.center + 2 ≤
          data.centerDimension step.center + step.codimension :=
        Nat.add_le_add_left step.codimensionAtLeastTwo _
      _ = d := step.centerAmbientDimension
  have occurrenceZero : ∀ index,
      data.occurrenceMarker fold (step.occurrence index) = 0 := by
    intro index
    apply nullity
    · simpa [step.occurrenceSource index] using step.centerSmooth
    · simpa [step.occurrenceSource index] using centerBound
  rw [step.markerFormula]
  simp [occurrenceZero]

end OccurrenceBlowupStep

/-- One unoriented link in a weak-factorization chain. -/
inductive OccurrenceBlowupLink
    {Variety : Type u} {Center : Type v} {Occurrence : Type w}
    {presentation : BlockPresentation.{x}}
    (data : OccurrenceIndexedLedger Variety Center Occurrence presentation)
    {A : Type y} [AddCommMonoid A]
    (fold : presentation.EffectiveLedger →+ A) (d : ℕ) :
    Variety → Variety → Type (max u v w x y)
  | forward {lower upper}
      (step : OccurrenceBlowupStep data fold d lower upper) :
      OccurrenceBlowupLink data fold d lower upper
  | backward {lower upper}
      (step : OccurrenceBlowupStep data fold d lower upper) :
      OccurrenceBlowupLink data fold d upper lower

namespace OccurrenceBlowupLink

variable {Variety : Type u} {Center : Type v} {Occurrence : Type w}
variable {presentation : BlockPresentation.{x}}
variable (data : OccurrenceIndexedLedger Variety Center Occurrence presentation)
variable {A : Type y} [AddCommMonoid A]
variable (fold : presentation.EffectiveLedger →+ A)
variable {d : ℕ} {left right : Variety}

/-- Every oriented blowup or blowdown link preserves the folded marker under
the common center-nullity hypothesis. -/
theorem marker_eq
    (link : OccurrenceBlowupLink data fold d left right)
    (nullity : LowDimensionalOccurrenceNullity data fold d) :
    data.varietyMarker fold left = data.varietyMarker fold right := by
  cases link with
  | forward step => exact (step.marker_eq data fold nullity).symm
  | backward step => exact step.marker_eq data fold nullity

end OccurrenceBlowupLink

/-- A composable chain of occurrence-indexed blowup and blowdown links. -/
inductive OccurrenceFactorizationChain
    {Variety : Type u} {Center : Type v} {Occurrence : Type w}
    {presentation : BlockPresentation.{x}}
    (data : OccurrenceIndexedLedger Variety Center Occurrence presentation)
    {A : Type y} [AddCommMonoid A]
    (fold : presentation.EffectiveLedger →+ A) (d : ℕ) :
    Variety → Variety → Type (max u v w x y)
  | refl (variety : Variety) : OccurrenceFactorizationChain data fold d variety variety
  | step {source middle target}
      (link : OccurrenceBlowupLink data fold d source middle)
      (tail : OccurrenceFactorizationChain data fold d middle target) :
      OccurrenceFactorizationChain data fold d source target

namespace OccurrenceFactorizationChain

variable {Variety : Type u} {Center : Type v} {Occurrence : Type w}
variable {presentation : BlockPresentation.{x}}
variable (data : OccurrenceIndexedLedger Variety Center Occurrence presentation)
variable {A : Type y} [AddCommMonoid A]
variable (fold : presentation.EffectiveLedger →+ A)
variable {d : ℕ} {source target : Variety}

/-- Marker preservation telescopes along an occurrence-indexed factorization
chain. -/
theorem marker_eq
    (chain : OccurrenceFactorizationChain data fold d source target)
    (nullity : LowDimensionalOccurrenceNullity data fold d) :
    data.varietyMarker fold source = data.varietyMarker fold target := by
  induction chain with
  | refl => rfl
  | step link tail inductionHypothesis =>
      exact (link.marker_eq data fold nullity).trans inductionHypothesis

end OccurrenceFactorizationChain

/-- A factorization provider for a chosen birational equivalence relation. -/
structure BirationalFactorizationProvider
    {Variety : Type u} {Center : Type v} {Occurrence : Type w}
    {presentation : BlockPresentation.{x}}
    (data : OccurrenceIndexedLedger Variety Center Occurrence presentation)
    {A : Type y} [AddCommMonoid A]
    (fold : presentation.EffectiveLedger →+ A) (d : ℕ)
    (birational : Setoid Variety) where
  factorization : ∀ {left right},
    data.smoothProjective left → data.smoothProjective right →
    data.dimension left = d → data.dimension right = d →
    birational.r left right →
      Nonempty (OccurrenceFactorizationChain data fold d left right)

namespace BirationalFactorizationProvider

variable {Variety : Type u} {Center : Type v} {Occurrence : Type w}
variable {presentation : BlockPresentation.{x}}
variable (data : OccurrenceIndexedLedger Variety Center Occurrence presentation)
variable {A : Type y} [AddCommMonoid A]
variable (fold : presentation.EffectiveLedger →+ A) (d : ℕ)
variable (birational : Setoid Variety)

/-- The generic categorical marker theorem: a factorization provider and
low-dimensional occurrence nullity make the folded marker birationally
invariant in ambient dimension `d`. -/
theorem marker_eq_of_related
    (provider : BirationalFactorizationProvider data fold d birational)
    (nullity : LowDimensionalOccurrenceNullity data fold d)
    {left right : Variety}
    (leftSmooth : data.smoothProjective left)
    (rightSmooth : data.smoothProjective right)
    (leftDimension : data.dimension left = d)
    (rightDimension : data.dimension right = d)
    (related : birational.r left right) :
    data.varietyMarker fold left = data.varietyMarker fold right := by
  obtain ⟨chain⟩ := provider.factorization leftSmooth rightSmooth
    leftDimension rightDimension related
  exact chain.marker_eq data fold nullity

/-- Smooth projective objects of the fixed ambient dimension on which the
birational marker descends. -/
abbrev SmoothAmbientObject :=
  {variety : Variety // data.smoothProjective variety ∧ data.dimension variety = d}

/-- The birational setoid restricted to smooth projective objects of the fixed
ambient dimension. -/
def smoothAmbientBirational : Setoid (SmoothAmbientObject data d) where
  r left right := birational.r left.1 right.1
  iseqv := {
    refl := fun _ => birational.refl _
    symm := fun relation => birational.symm relation
    trans := fun leftMiddle middleRight => birational.trans leftMiddle middleRight
  }

/-- The object-set descent map from fixed-dimensional smooth birational
classes to marker values. -/
def descendedMarker
    (provider : BirationalFactorizationProvider data fold d birational)
    (nullity : LowDimensionalOccurrenceNullity data fold d) :
    Quotient (smoothAmbientBirational data d birational) → A :=
  Quotient.lift (fun variety => data.varietyMarker fold variety.1)
    (fun left right related =>
      provider.marker_eq_of_related data fold d birational nullity
        left.2.1 right.2.1 left.2.2 right.2.2 related)

/-- The descended marker evaluates a represented birational class by the
marker of its representative. -/
@[simp]
theorem descendedMarker_mk
    (provider : BirationalFactorizationProvider data fold d birational)
    (nullity : LowDimensionalOccurrenceNullity data fold d)
    (variety : SmoothAmbientObject data d) :
    provider.descendedMarker data fold d birational nullity
        (Quotient.mk (smoothAmbientBirational data d birational) variety) =
      data.varietyMarker fold variety.1 :=
  rfl

end BirationalFactorizationProvider

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
