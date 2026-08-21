import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.FixedPhaseReader
import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.LawfulReaderIndex
import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.ComponentReader
import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.CrossedEdgeComposition
import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.MonodromyImage
import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.ProjectedVariation
import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.ModelCrossedCoordinates
import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.RangeBaseChange
import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.SemilinearVariation
import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.HorizontalReader
import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.TraitHorizontalReader
import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.ProvenanceEdge

/-!
# Reviewer interface for the cubic-stabilization irrationality paper

The imported modules expose the typed fixed-phase reader interface, its
componentwise realization, the crossed-row algebra, and the closed-fibre
vanishing, composition, monodromy-image functoriality, and map-indexed
provenance witnesses. Projected monodromy variation is derived from a single
marked horizontal comparison of the common nearby-cycle spaces; the reduced
reader derives the model row from vector crossed coordinates and consumes
that comparison against an externally supplied actual receiver. Semilinear
specialization transports the directed variation without asserting that tensor
product commutes with monodromy-image formation; an explicit range base-change
certificate remains available for applications that require an image
equivalence. The trait-horizontal reader composes this specialization law with
the crossed-coordinate normal-factor calculation. Environment-indexed
endpoints compute the quantum path and share the phase, character, and
direction, so their compatibility certificate is derived rather than chosen.
-/
