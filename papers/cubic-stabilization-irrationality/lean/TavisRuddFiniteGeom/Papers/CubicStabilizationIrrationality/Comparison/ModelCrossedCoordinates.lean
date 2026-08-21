import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.ProjectedVariation
import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.FixedPhaseReader

/-!
# Crossed coordinates for a monodromy-image model

This module derives the scalar projected-variation reading from component
equations on the model nearby-cycle space. The source, target-common, and
target-moving coordinate maps are specialized separately. The decisive
identity is a vector equation for the target identity-minus-monodromy
operator, not the vanishing of the consumed row.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.ModelCrossedCoordinates

open FixedPhaseReader
open MonodromyImage
open ProjectedVariation

universe uι uR uk uC₀ uC₁ uM₀ uM₁ uV

/-- Specialized crossed coordinates inside one canonical monodromy-image
model. -/
structure Coordinates
    (R : Type uR) (k : Type uk) [CommRing R] [CommRing k]
    (specialize : R →+* k)
    {Occurrence CoeffParameter ChamberPath QdmPath Phase Character Direction : Type uι}
    {source target : ReaderIndex Occurrence CoeffParameter ChamberPath QdmPath Phase
      Character Direction}
    {C₀ : Type uC₀} {C₁ : Type uC₁} {M₀ : Type uM₀} {M₁ : Type uM₁}
    [AddCommGroup C₀] [Module R C₀]
    [AddCommGroup C₁] [Module R C₁]
    [AddCommGroup M₀] [Module R M₀]
    [AddCommGroup M₁] [Module R M₁]
    (edge : CrossedEdge R source target C₀ C₁ M₀ M₁)
    (Nearby : Type uV) [AddCommGroup Nearby] [Module k Nearby] where
  incoming : Nearby ≃ₗ[k] Nearby
  targetMonodromy : Nearby ≃ₗ[k] Nearby
  row : Nearby →ₗ[k] k
  sourceValue : M₀ →ₛₗ[specialize] Nearby
  targetCommonValue : C₁ →ₛₗ[specialize] Nearby
  targetMovingValue : M₁ →ₛₗ[specialize] Nearby
  sourceToIncomingImage : M₀ →ₛₗ[specialize]
    LinearMap.range (defectOperator incoming.toLinearMap)
  sourceToIncomingImage_value : ∀ x,
    (sourceToIncomingImage x).1 = sourceValue x
  sourceToIncomingImage_surjective : Function.Surjective sourceToIncomingImage
  targetDefectCoordinates : ∀ x,
    defectOperator targetMonodromy.toLinearMap (sourceValue x) =
      sourceValue x - targetMovingValue (edge.movingMap x) -
        targetCommonValue (edge.crossedMap x)
  sourceRowCoordinates : ∀ x,
    row (sourceValue x) = specialize (edge.sourceMovingRow x)
  targetCommonRowCoordinates : ∀ x,
    row (targetCommonValue x) = specialize (edge.targetCommonRow x)
  targetMovingRowCoordinates : ∀ x,
    row (targetMovingValue x) = specialize (edge.targetMovingRow x)

namespace Coordinates

variable
    {R : Type uR} {k : Type uk} [CommRing R] [CommRing k]
    {specialize : R →+* k}
    {Occurrence CoeffParameter ChamberPath QdmPath Phase Character Direction : Type uι}
    {source target : ReaderIndex Occurrence CoeffParameter ChamberPath QdmPath Phase
      Character Direction}
    {C₀ : Type uC₀} {C₁ : Type uC₁} {M₀ : Type uM₀} {M₁ : Type uM₁}
    [AddCommGroup C₀] [Module R C₀]
    [AddCommGroup C₁] [Module R C₁]
    [AddCommGroup M₀] [Module R M₀]
    [AddCommGroup M₁] [Module R M₁]
    {edge : CrossedEdge R source target C₀ C₁ M₀ M₁}
    {Nearby : Type uV} [AddCommGroup Nearby] [Module k Nearby]

/-- The vector coordinate equations imply the specialized scalar
crossed-defect reading. -/
theorem projectedVariation_sourceToIncomingImage
    (coordinates : Coordinates R k specialize edge Nearby) (x : M₀) :
    projectedVariation coordinates.incoming.toLinearMap
      coordinates.targetMonodromy.toLinearMap
      coordinates.row (coordinates.sourceToIncomingImage x) =
        specialize (edge.defect x) := by
  change coordinates.row
      (defectOperator coordinates.targetMonodromy.toLinearMap
        (coordinates.sourceToIncomingImage x).1) = specialize (edge.defect x)
  rw [coordinates.sourceToIncomingImage_value,
    coordinates.targetDefectCoordinates]
  simp only [map_sub, coordinates.sourceRowCoordinates,
    coordinates.targetMovingRowCoordinates,
    coordinates.targetCommonRowCoordinates]
  simp [CrossedEdge.defect]

end Coordinates

end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.ModelCrossedCoordinates
