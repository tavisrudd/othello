import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.RankTwoResidueMarker

/-!
# Low-dimensional nullity for the rank-two residue marker

This module connects the direct residue-marker fold to the geometric induction
used for centers of dimension at most two.  A supplied intrinsic center marker
vanishes on seed objects and obeys the projective-bundle and point-blowup
formulas.  A classification witness builds every relevant center from those
three cases.  A final comparison identifies each actual QDM occurrence marker
with the intrinsic marker of its source center.

The resulting theorem supplies exactly the occurrence-nullity field required by
the common categorical descent context.  It does not construct varieties,
QDM blocks, minimal models, projective bundles, blowups, or comparison maps.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Applications

universe u v w x

/-- Geometric operations and the intrinsic direct residue marker used in the
low-dimensional center induction.  Seed centers comprise the point, curve,
nef-canonical surface, and projective-plane cases in the geometric argument. -/
structure RankTwoResidueCenterGeometry (Center : Type v) where
  isSeed : Center → Prop
  IsProjectiveBundle : ℕ → Center → Center → Prop
  IsPointBlowup : Center → Center → Prop
  intrinsicMarker : Center → ℕ

/-- The inductive construction of a low-dimensional center from a seed, a
positive-rank projective bundle, or a point blowup. -/
inductive RankTwoResidueCenterConstruction
    {Center : Type v} (geometry : RankTwoResidueCenterGeometry Center) :
    Center → Prop
  | seed {center : Center} :
      geometry.isSeed center → RankTwoResidueCenterConstruction geometry center
  | projectiveBundle (rank : ℕ) (positiveRank : 0 < rank)
      {base total : Center} :
      geometry.IsProjectiveBundle rank base total →
      RankTwoResidueCenterConstruction geometry base →
        RankTwoResidueCenterConstruction geometry total
  | blowupAtPoint {base total : Center} :
      geometry.IsPointBlowup base total →
      RankTwoResidueCenterConstruction geometry base →
        RankTwoResidueCenterConstruction geometry total

/-- Geometric, operation-formula, and occurrence-comparison premises used to
deduce direct residue-marker nullity for all actual centers in dimension four. -/
structure RankTwoResidueLowDimensionalInput
    {K : Type x} [CommRing K]
    {Variety : Type u} {Center : Type v} {Occurrence : Type w}
    (presentation : Quantum.RankTwoResiduePresentation K)
    (data : Quantum.OccurrenceIndexedLedger Variety Center Occurrence
      presentation.toBlockPresentation)
    (geometry : RankTwoResidueCenterGeometry Center) where
  classification : ∀ center,
    data.smoothCenter center → data.centerDimension center + 2 ≤ 4 →
      RankTwoResidueCenterConstruction geometry center
  seedMarkerZero : ∀ center,
    geometry.isSeed center → geometry.intrinsicMarker center = 0
  projectiveBundleFormula : ∀ rank, 0 < rank → ∀ base total,
    geometry.IsProjectiveBundle rank base total →
      geometry.intrinsicMarker total = rank * geometry.intrinsicMarker base
  pointBlowupFormula : ∀ base total,
    geometry.IsPointBlowup base total →
      geometry.intrinsicMarker total = geometry.intrinsicMarker base
  occurrenceComparison : ∀ occurrence,
    data.occurrenceMarker presentation.fold occurrence =
      geometry.intrinsicMarker (data.occurrenceSource occurrence)

/-- The intrinsic direct residue marker vanishes on every center produced by
the supplied low-dimensional construction. -/
theorem rankTwoResidue_intrinsicCenterMarker_eq_zero
    {Center : Type v} (geometry : RankTwoResidueCenterGeometry Center)
    {center : Center}
    (seedMarkerZero : ∀ seed,
      geometry.isSeed seed → geometry.intrinsicMarker seed = 0)
    (projectiveBundleFormula : ∀ rank, 0 < rank → ∀ base total,
      geometry.IsProjectiveBundle rank base total →
        geometry.intrinsicMarker total = rank * geometry.intrinsicMarker base)
    (pointBlowupFormula : ∀ base total,
      geometry.IsPointBlowup base total →
        geometry.intrinsicMarker total = geometry.intrinsicMarker base)
    (construction : RankTwoResidueCenterConstruction geometry center) :
    geometry.intrinsicMarker center = 0 := by
  induction construction with
  | seed seed => exact seedMarkerZero _ seed
  | projectiveBundle rank positiveRank bundle baseConstruction inductionHypothesis =>
      rw [projectiveBundleFormula rank positiveRank _ _ bundle, inductionHypothesis]
      simp
  | blowupAtPoint blowup baseConstruction inductionHypothesis =>
      rw [pointBlowupFormula _ _ blowup]
      exact inductionHypothesis

/-- Classification, the intrinsic operation formulas, and faithful occurrence
comparison imply the exact low-dimensional occurrence-nullity premise consumed
by categorical descent in ambient dimension four. -/
theorem rankTwoResidue_lowDimensionalOccurrenceNullity
    {K : Type x} [CommRing K]
    {Variety : Type u} {Center : Type v} {Occurrence : Type w}
    (presentation : Quantum.RankTwoResiduePresentation K)
    (data : Quantum.OccurrenceIndexedLedger Variety Center Occurrence
      presentation.toBlockPresentation)
    (geometry : RankTwoResidueCenterGeometry Center)
    (input : RankTwoResidueLowDimensionalInput presentation data geometry) :
    Quantum.LowDimensionalOccurrenceNullity data presentation.fold 4 := by
  intro occurrence centerSmooth centerDimension
  rw [input.occurrenceComparison occurrence]
  exact rankTwoResidue_intrinsicCenterMarker_eq_zero geometry
    input.seedMarkerZero input.projectiveBundleFormula input.pointBlowupFormula
    (input.classification (data.occurrenceSource occurrence)
      centerSmooth centerDimension)

/-- Construct the complete direct residue-marker descent context from a
factorization provider and the classified low-dimensional center inputs. -/
noncomputable def rankTwoResidueMarkerContextOfLowDimensionalInput
    {K : Type x} [CommRing K]
    {Variety : Type u} {Center : Type v} {Occurrence : Type w}
    (presentation : Quantum.RankTwoResiduePresentation K)
    (data : Quantum.OccurrenceIndexedLedger Variety Center Occurrence
      presentation.toBlockPresentation)
    (birational : Setoid Variety)
    (provider : Quantum.BirationalFactorizationProvider
      data presentation.fold 4 birational)
    (geometry : RankTwoResidueCenterGeometry Center)
    (input : RankTwoResidueLowDimensionalInput presentation data geometry) :
    Quantum.RankTwoResidueMarkerContext K Variety Center Occurrence where
  presentation := presentation
  data := data
  birational := birational
  provider := provider
  centerNullity := rankTwoResidue_lowDimensionalOccurrenceNullity
    presentation data geometry input

end Applications

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
