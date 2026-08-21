import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.FramedMultiplicity
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.OccurrenceIndexedMarker

/-!
# The framed primitive-sixth marker as an effective-ledger fold

A framed block retains its formal-monodromy matrix for one turn of the
original loop and a marked small section.  Its weight is the algebraic
multiplicity of the two primitive sixth roots.  A supplied regular-isomorphism
relation is required to preserve this weight, so it descends to components and
extends to the effective ledger by the same additive fold used by the
unframed residue marker.

A context packages the conditional comparison and center-nullity data
in ambient dimension four.  Its birational-invariance theorem specializes the
generic occurrence-indexed descent theorem; no framed QDM construction or
comparison theorem is asserted here.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

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

/-- The framed-marker inputs needed for categorical descent in ambient
dimension four.  The QDM comparison provider and center nullity remain
explicit premises. -/
structure FramedSixthMarkerContext
    (Variety : Type u) (Center : Type v) (Occurrence : Type w) where
  presentation : FramedSixthPresentation
  data : OccurrenceIndexedLedger Variety Center Occurrence
    presentation.toBlockPresentation
  birational : Setoid Variety
  provider : BirationalFactorizationProvider data presentation.fold 4 birational
  centerNullity : LowDimensionalOccurrenceNullity data presentation.fold 4

namespace FramedSixthMarkerContext

variable {Variety : Type u} {Center : Type v} {Occurrence : Type w}

/-- The primitive-sixth framed marker of a variety. -/
noncomputable def marker
    (context : FramedSixthMarkerContext Variety Center Occurrence)
    (variety : Variety) : ℕ :=
  context.data.varietyMarker context.presentation.fold variety

/-- The framed primitive-sixth marker is birationally invariant in dimension
four under the supplied occurrence-indexed QDM formulas and center nullity. -/
theorem marker_eq_of_birational
    (context : FramedSixthMarkerContext Variety Center Occurrence)
    {left right : Variety}
    (leftSmooth : context.data.smoothProjective left)
    (rightSmooth : context.data.smoothProjective right)
    (leftDimension : context.data.dimension left = 4)
    (rightDimension : context.data.dimension right = 4)
    (related : context.birational.r left right) :
    context.marker left = context.marker right :=
  by
    have _ := leftSmooth
    have _ := rightSmooth
    have _ := leftDimension
    have _ := rightDimension
    exact context.provider.marker_eq_of_related context.data context.presentation.fold 4
      context.birational context.centerNullity related

end FramedSixthMarkerContext

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
