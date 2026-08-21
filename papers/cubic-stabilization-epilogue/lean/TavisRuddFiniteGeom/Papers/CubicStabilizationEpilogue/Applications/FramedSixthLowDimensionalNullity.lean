import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Applications.LowDimensionalVanishing
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.FramedSixthMarker

/-!
# Actual-occurrence nullity for the framed sixth-root marker

The low-dimensional framed-monodromy theorem proves that every admissible
specialization of a point, curve, or surface has zero primitive-sixth
multiplicity.  This module supplies the adapter from that theorem to the actual
center occurrences in the effective QDM ledger.  Each occurrence names its
specialization, proves admissibility, and identifies the folded occurrence
marker with the specialized framed-monodromy multiplicity.

The adapter produces the center-nullity field consumed by the common
categorical descent theorem in any fixed ambient dimension at most four.  It
does not construct the comparison specialization or its QDM identification.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Applications

universe u v w

/-- Identification of every actual framed-ledger occurrence with a strictly
Novikov-admissible specialization of its source center. -/
structure FramedSixthOccurrenceInput
    {Variety : Type u} {Center : Type v} {Occurrence : Type w}
    (presentation : Quantum.FramedSixthPresentation)
    (data : Quantum.OccurrenceIndexedLedger Variety Center Occurrence
      presentation.toBlockPresentation)
    (geometry : LowDimensionalVanishingGeometry Center) where
  specialization : (occurrence : Occurrence) →
    geometry.Specialization (data.occurrenceSource occurrence)
  sourceIsLowDimensional : ∀ center,
    data.smoothCenter center → data.centerDimension center + 2 ≤ 4 →
      geometry.isPointCurveOrSurface center
  specializationAdmissible : ∀ occurrence,
    geometry.isStrictlyNovikovAdmissible (data.occurrenceSource occurrence)
      (specialization occurrence)
  occurrenceComparison : ∀ occurrence,
    data.occurrenceMarker presentation.fold occurrence =
      (geometry.specializedMonodromy (data.occurrenceSource occurrence)
        (specialization occurrence)).sixthMultiplicity

/-- The classified low-dimensional framed-monodromy theorem and the
actual-occurrence adapter imply the nullity premise for every ambient
dimension at most four. -/
theorem framedSixth_lowDimensionalOccurrenceNullity
    {Variety : Type u} {Center : Type v} {Occurrence : Type w}
    {ambientDimension : ℕ} (ambientDimensionAtMostFour : ambientDimension ≤ 4)
    (presentation : Quantum.FramedSixthPresentation)
    (data : Quantum.OccurrenceIndexedLedger Variety Center Occurrence
      presentation.toBlockPresentation)
    (geometry : LowDimensionalVanishingGeometry Center)
    (vanishingInput : LowDimensionalVanishingInput geometry)
    (occurrenceInput : FramedSixthOccurrenceInput presentation data geometry) :
    Quantum.LowDimensionalOccurrenceNullity data presentation.fold
      ambientDimension := by
  intro occurrence centerSmooth centerDimension
  rw [occurrenceInput.occurrenceComparison occurrence]
  apply lowDimensionalMultiplicity_eq_zero_of_classification_and_tagging
    geometry vanishingInput (data.occurrenceSource occurrence)
  · apply occurrenceInput.sourceIsLowDimensional
    · exact centerSmooth
    · exact centerDimension.trans ambientDimensionAtMostFour
  · exact occurrenceInput.specializationAdmissible occurrence

/-- Construct the complete framed marker context from a factorization provider,
the classified low-dimensional vanishing theorem, and the occurrence adapter. -/
noncomputable def framedSixthMarkerContextOfLowDimensionalInput
    {Variety : Type u} {Center : Type v} {Occurrence : Type w}
    {ambientDimension : ℕ} (ambientDimensionAtMostFour : ambientDimension ≤ 4)
    (presentation : Quantum.FramedSixthPresentation)
    (data : Quantum.OccurrenceIndexedLedger Variety Center Occurrence
      presentation.toBlockPresentation)
    (birational : Setoid Variety)
    (provider : Quantum.BirationalFactorizationProvider data presentation.fold
      ambientDimension birational)
    (geometry : LowDimensionalVanishingGeometry Center)
    (vanishingInput : LowDimensionalVanishingInput geometry)
    (occurrenceInput : FramedSixthOccurrenceInput presentation data geometry) :
    Quantum.FramedSixthMarkerContext ambientDimension Variety Center Occurrence where
  ambientDimensionAtMostFour := ambientDimensionAtMostFour
  presentation := presentation
  data := data
  birational := birational
  provider := provider
  centerNullity := framedSixth_lowDimensionalOccurrenceNullity
    ambientDimensionAtMostFour presentation data geometry vanishingInput
      occurrenceInput

end Applications

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
