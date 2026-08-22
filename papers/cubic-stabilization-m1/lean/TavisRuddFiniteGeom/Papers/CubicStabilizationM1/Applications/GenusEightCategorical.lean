import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Applications.CubicResidueMarkerOneStep
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.FramedSixthMarker

/-!
# Genus-eight transport through the categorical marker spine

Kuznetsov's rank-two projectivizations give two uses of the common
occurrence-indexed descent theorem.  The direct residue-marker context proves
irrationality after one projective-line stabilization by transporting the
cubic obstruction across the flop.  The finer framed context compares the two
projectivizations and cancels their common rank-two multiplicity to obtain
`ν₆(V) = 2`.

The varieties, bundles, flop, projective-bundle formulas, and rationality
transport are explicit data.  This module constructs none of them and makes no
claim about more than one projective-line stabilization.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace Applications

universe u v w x

/-- The objects named by the genus-eight construction. -/
structure GenusEightCategoricalGeometry (Variety : Type u) where
  associatedPfaffianCubic : Variety → Variety
  fanoRankTwoBundleTotalSpace : Variety → Variety
  cubicRankTwoBundleTotalSpace : Variety → Variety

/-- Exact birational inputs for transporting the direct cubic obstruction to
the genus-eight carrier. -/
structure GenusEightResidueTransportInput
    {K : Type x} [CommRing K]
    {Variety : Type u} {Center : Type v} {Occurrence : Type w}
    (context : Quantum.RankTwoResidueMarkerContext K Variety Center Occurrence)
    (geometry : GenusEightCategoricalGeometry Variety)
    (productWithProjectiveLine : Variety → Variety)
    (Rational : Variety → Prop) (fano : Variety) : Prop where
  fanoBundleBirationalProduct : context.birational.r
    (geometry.fanoRankTwoBundleTotalSpace fano) (productWithProjectiveLine fano)
  cubicBundleBirationalProduct : context.birational.r
    (geometry.cubicRankTwoBundleTotalSpace fano)
    (productWithProjectiveLine (geometry.associatedPfaffianCubic fano))
  bundleFlopBirational : context.birational.r
    (geometry.fanoRankTwoBundleTotalSpace fano)
    (geometry.cubicRankTwoBundleTotalSpace fano)
  rational_of_birational : ∀ {source target},
    context.birational.r source target → Rational source → Rational target

/-- The one-projective-line stabilization of the genus-eight carrier is
birational to that of its associated cubic. -/
theorem genusEight_stabilization_birational_cubicStabilization_of_residueContext
    {K : Type x} [CommRing K]
    {Variety : Type u} {Center : Type v} {Occurrence : Type w}
    {context : Quantum.RankTwoResidueMarkerContext K Variety Center Occurrence}
    {geometry : GenusEightCategoricalGeometry Variety}
    {productWithProjectiveLine : Variety → Variety}
    {Rational : Variety → Prop} {fano : Variety}
    (input : GenusEightResidueTransportInput context geometry
      productWithProjectiveLine Rational fano) :
    context.birational.r (productWithProjectiveLine fano)
      (productWithProjectiveLine (geometry.associatedPfaffianCubic fano)) :=
  context.birational.trans
    (context.birational.symm input.fanoBundleBirationalProduct)
    (context.birational.trans input.bundleFlopBirational
      input.cubicBundleBirationalProduct)

/-- Unconditional genus-eight one-step irrationality as a direct specialization
of the residue-marker categorical spine. -/
theorem genusEight_oneProjectiveLine_not_rational_of_residueContext
    {K : Type x} [CommRing K]
    {Variety : Type u} {Center : Type v} {Occurrence : Type w}
    (context : Quantum.RankTwoResidueMarkerContext K Variety Center Occurrence)
    (geometry : GenusEightCategoricalGeometry Variety)
    (productWithProjectiveLine : Variety → Variety)
    (projectiveFourSpace : Variety) (Rational : Variety → Prop)
    (fano : Variety)
    (transport : GenusEightResidueTransportInput context geometry
      productWithProjectiveLine Rational fano)
    (cubicInput : CubicResidueMarkerOneStepInput context
      productWithProjectiveLine projectiveFourSpace Rational
      (geometry.associatedPfaffianCubic fano)) :
    ¬ Rational (productWithProjectiveLine fano) := by
  intro rational
  have cubicRational :
      Rational (productWithProjectiveLine (geometry.associatedPfaffianCubic fano)) :=
    transport.rational_of_birational
      (genusEight_stabilization_birational_cubicStabilization_of_residueContext
        transport) rational
  exact
    (cubicThreefold_oneProjectiveLine_not_rational_of_residueMarker context
      productWithProjectiveLine projectiveFourSpace Rational
      (geometry.associatedPfaffianCubic fano) cubicInput) cubicRational

/-- Exact conditional framed inputs for comparing the two rank-two
projectivizations. -/
structure GenusEightFramedTransportInput
    {Variety : Type u} {Center : Type v} {Occurrence : Type w}
    (context : Quantum.FramedSixthMarkerContext 4 Variety Center Occurrence)
    (geometry : GenusEightCategoricalGeometry Variety) (fano : Variety) : Prop where
  fanoDimension : context.data.dimension fano = 3
  cubicDimension :
    context.data.dimension (geometry.associatedPfaffianCubic fano) = 3
  fanoBundleFormula : Quantum.ProjectiveBundleMarkerFormula
    context.data context.presentation.fold fano
      (geometry.fanoRankTwoBundleTotalSpace fano) 2
  cubicBundleFormula : Quantum.ProjectiveBundleMarkerFormula
    context.data context.presentation.fold (geometry.associatedPfaffianCubic fano)
      (geometry.cubicRankTwoBundleTotalSpace fano) 2
  bundleFlopBirational : context.birational.r
    (geometry.fanoRankTwoBundleTotalSpace fano)
    (geometry.cubicRankTwoBundleTotalSpace fano)
  cubicMarker : context.marker (geometry.associatedPfaffianCubic fano) = 2

/-- Conditional equality `ν₆(V) = 2`, obtained by applying the framed
categorical descent theorem to the two projectivizations and cancelling their
common rank-two multiplicity. -/
theorem genusEight_framedSixthMarker_eq_two_of_categoricalFlop
    {Variety : Type u} {Center : Type v} {Occurrence : Type w}
    (context : Quantum.FramedSixthMarkerContext 4 Variety Center Occurrence)
    (geometry : GenusEightCategoricalGeometry Variety) (fano : Variety)
    (input : GenusEightFramedTransportInput context geometry fano) :
    context.marker fano = 2 := by
  have fanoBundleDimension :
      context.data.dimension (geometry.fanoRankTwoBundleTotalSpace fano) = 4 := by
    rw [input.fanoBundleFormula.dimensionFormula, input.fanoDimension]
  have cubicBundleDimension :
      context.data.dimension (geometry.cubicRankTwoBundleTotalSpace fano) = 4 := by
    rw [input.cubicBundleFormula.dimensionFormula, input.cubicDimension]
  have bundleMarkerEquality := context.marker_eq_of_birational
    input.fanoBundleFormula.totalSmooth input.cubicBundleFormula.totalSmooth
    fanoBundleDimension cubicBundleDimension input.bundleFlopBirational
  change context.data.varietyMarker context.presentation.fold
      (geometry.fanoRankTwoBundleTotalSpace fano) =
    context.data.varietyMarker context.presentation.fold
      (geometry.cubicRankTwoBundleTotalSpace fano) at bundleMarkerEquality
  rw [input.fanoBundleFormula.markerFormula,
    input.cubicBundleFormula.markerFormula] at bundleMarkerEquality
  have cubicMarker := input.cubicMarker
  change context.data.varietyMarker context.presentation.fold
    (geometry.associatedPfaffianCubic fano) = 2 at cubicMarker
  rw [cubicMarker] at bundleMarkerEquality
  change context.data.varietyMarker context.presentation.fold fano = 2
  simp only [two_nsmul] at bundleMarkerEquality
  omega

end Applications

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
