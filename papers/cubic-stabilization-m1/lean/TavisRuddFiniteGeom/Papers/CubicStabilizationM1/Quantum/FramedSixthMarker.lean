import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.FramedMultiplicity
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.OccurrenceIndexedMarker

/-!
# The framed primitive-sixth marker as an effective-ledger fold

A framed block retains its formal-monodromy matrix for one turn of the
original loop and a marked small section.  Its weight is the algebraic
multiplicity of the two primitive sixth roots.  A supplied regular-isomorphism
relation is required to preserve this weight, so it descends to components and
extends to the effective ledger by the same additive fold used by the
unframed residue marker.

A context packages the conditional comparison and center-nullity data in one
fixed ambient dimension at most four.  Its birational-invariance theorem
specializes the generic occurrence-indexed descent theorem; no framed QDM
construction or comparison theorem is asserted here.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace Quantum

universe u v w

/-- A formal-monodromy block retaining a marked small section and the original
unramified loop framing. -/
structure FramedSixthBlock where
  monodromy : FramedMonodromyMatrix
  markedSmallSection : Fin monodromy.rank → ℂ

namespace FramedSixthBlock

/-- The primitive-sixth algebraic multiplicity of a framed block. -/
noncomputable def weight (block : FramedSixthBlock) : ℕ :=
  block.monodromy.sixthMultiplicity

end FramedSixthBlock

/-- A regular-isomorphism presentation of framed blocks, including the exact
premise that primitive-sixth multiplicity is invariant. -/
structure FramedSixthPresentation where
  regularIsomorphism : Setoid FramedSixthBlock
  weight_invariant : ∀ {left right}, regularIsomorphism.r left right →
    left.weight = right.weight

namespace FramedSixthPresentation

/-- The effective-ledger block presentation underlying the framed marker. -/
def toBlockPresentation (presentation : FramedSixthPresentation) :
    BlockPresentation where
  Block := FramedSixthBlock
  regularIsomorphism := presentation.regularIsomorphism

/-- The natural-valued fold counting primitive-sixth multiplicity with block
and occurrence multiplicity. -/
noncomputable def fold (presentation : FramedSixthPresentation) :
    presentation.toBlockPresentation.EffectiveLedger →+ ℕ :=
  presentation.toBlockPresentation.foldBlocks FramedSixthBlock.weight
    presentation.weight_invariant

end FramedSixthPresentation

/-- The framed-marker inputs needed for categorical descent in one ambient
dimension at most four.  The QDM comparison provider and center nullity remain
explicit premises. -/
structure FramedSixthMarkerContext
    (ambientDimension : ℕ)
    (Variety : Type u) (Center : Type v) (Occurrence : Type w) where
  ambientDimensionAtMostFour : ambientDimension ≤ 4
  presentation : FramedSixthPresentation
  data : OccurrenceIndexedLedger Variety Center Occurrence
    presentation.toBlockPresentation
  birational : Setoid Variety
  provider : BirationalFactorizationProvider data presentation.fold
    ambientDimension birational
  centerNullity : LowDimensionalOccurrenceNullity data presentation.fold
    ambientDimension

namespace FramedSixthMarkerContext

variable {Variety : Type u} {Center : Type v} {Occurrence : Type w}
variable {ambientDimension : ℕ}

/-- The primitive-sixth framed marker of a variety. -/
noncomputable def marker
    (context : FramedSixthMarkerContext ambientDimension Variety Center Occurrence)
    (variety : Variety) : ℕ :=
  context.data.varietyMarker context.presentation.fold variety

/-- The framed primitive-sixth marker is birationally invariant in the fixed
ambient dimension under the supplied occurrence-indexed QDM formulas and
center nullity. -/
theorem marker_eq_of_birational
    (context : FramedSixthMarkerContext ambientDimension Variety Center Occurrence)
    {left right : Variety}
    (leftSmooth : context.data.smoothProjective left)
    (rightSmooth : context.data.smoothProjective right)
    (leftDimension : context.data.dimension left = ambientDimension)
    (rightDimension : context.data.dimension right = ambientDimension)
    (related : context.birational.r left right) :
    context.marker left = context.marker right :=
  context.provider.marker_eq_of_related context.data context.presentation.fold
    ambientDimension
    context.birational context.centerNullity leftSmooth rightSmooth
      leftDimension rightDimension related

end FramedSixthMarkerContext

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
