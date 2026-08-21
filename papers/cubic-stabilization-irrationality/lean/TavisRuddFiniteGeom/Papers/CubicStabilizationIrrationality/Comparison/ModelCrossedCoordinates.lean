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

/-- The incoming monodromy image and its occurrence-specific source
realization. -/
structure IncomingCoordinates
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
  sourceValue : M₀ →ₛₗ[specialize] Nearby
  sourceToIncomingImage : M₀ →ₛₗ[specialize]
    LinearMap.range (defectOperator incoming.toLinearMap)
  sourceToIncomingImage_value : ∀ x,
    (sourceToIncomingImage x).1 = sourceValue x
  sourceToIncomingImage_surjective : Function.Surjective sourceToIncomingImage

/-- The target monodromy and the vector crossed-coordinate equation, relative
to an incoming-image realization. -/
structure TargetCoordinates
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
    (Nearby : Type uV) [AddCommGroup Nearby] [Module k Nearby]
    (incomingCoordinates : IncomingCoordinates R k specialize edge Nearby) where
  targetMonodromy : Nearby ≃ₗ[k] Nearby
  targetCommonValue : C₁ →ₛₗ[specialize] Nearby
  targetMovingValue : M₁ →ₛₗ[specialize] Nearby
  targetDefectCoordinates : ∀ x,
    defectOperator targetMonodromy.toLinearMap (incomingCoordinates.sourceValue x) =
      incomingCoordinates.sourceValue x - targetMovingValue (edge.movingMap x) -
        targetCommonValue (edge.crossedMap x)

/-- The scalar row and its source, common, and moving coordinate laws. -/
structure RowCoordinates
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
    (Nearby : Type uV) [AddCommGroup Nearby] [Module k Nearby]
    (incomingCoordinates : IncomingCoordinates R k specialize edge Nearby)
    (targetCoordinates : TargetCoordinates R k specialize edge Nearby incomingCoordinates) where
  row : Nearby →ₗ[k] k
  sourceRowCoordinates : ∀ x,
    row (incomingCoordinates.sourceValue x) = specialize (edge.sourceMovingRow x)
  targetCommonRowCoordinates : ∀ x,
    row (targetCoordinates.targetCommonValue x) = specialize (edge.targetCommonRow x)
  targetMovingRowCoordinates : ∀ x,
    row (targetCoordinates.targetMovingValue x) = specialize (edge.targetMovingRow x)

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

/-- Assemble the full coordinate model from the incoming-image, target-vector,
and row-coordinate capabilities. -/
def ofParts
    (incomingCoordinates : IncomingCoordinates R k specialize edge Nearby)
    (targetCoordinates : TargetCoordinates R k specialize edge Nearby incomingCoordinates)
    (rowCoordinates :
      RowCoordinates R k specialize edge Nearby incomingCoordinates targetCoordinates) :
    Coordinates R k specialize edge Nearby where
  incoming := incomingCoordinates.incoming
  targetMonodromy := targetCoordinates.targetMonodromy
  row := rowCoordinates.row
  sourceValue := incomingCoordinates.sourceValue
  targetCommonValue := targetCoordinates.targetCommonValue
  targetMovingValue := targetCoordinates.targetMovingValue
  sourceToIncomingImage := incomingCoordinates.sourceToIncomingImage
  sourceToIncomingImage_value := incomingCoordinates.sourceToIncomingImage_value
  sourceToIncomingImage_surjective := incomingCoordinates.sourceToIncomingImage_surjective
  targetDefectCoordinates := targetCoordinates.targetDefectCoordinates
  sourceRowCoordinates := rowCoordinates.sourceRowCoordinates
  targetCommonRowCoordinates := rowCoordinates.targetCommonRowCoordinates
  targetMovingRowCoordinates := rowCoordinates.targetMovingRowCoordinates

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

/-- If both crossed target coordinates of a source value vanish, invertibility
of target monodromy forces the realized source value itself to vanish. This is
a necessary vector-level condition not implied by the scalar crossed-row law. -/
theorem sourceValue_eq_zero_of_crossedMap_eq_zero_of_movingMap_eq_zero
    (coordinates : Coordinates R k specialize edge Nearby) (x : M₀)
    (crossedVanishes : edge.crossedMap x = 0)
    (movingVanishes : edge.movingMap x = 0) :
    coordinates.sourceValue x = 0 := by
  have coordinateLaw := coordinates.targetDefectCoordinates x
  rw [crossedVanishes, movingVanishes, map_zero, map_zero, sub_zero] at coordinateLaw
  simp only [sub_zero] at coordinateLaw
  unfold defectOperator at coordinateLaw
  change coordinates.sourceValue x -
      coordinates.targetMonodromy (coordinates.sourceValue x) =
    coordinates.sourceValue x at coordinateLaw
  have monodromyVanishes :
      coordinates.targetMonodromy (coordinates.sourceValue x) = 0 :=
    sub_eq_self.mp coordinateLaw
  exact coordinates.targetMonodromy.injective (by simpa using monodromyVanishes)

/-- The same kernel condition in the canonical incoming-image submodule. -/
theorem sourceToIncomingImage_eq_zero_of_crossedMap_eq_zero_of_movingMap_eq_zero
    (coordinates : Coordinates R k specialize edge Nearby) (x : M₀)
    (crossedVanishes : edge.crossedMap x = 0)
    (movingVanishes : edge.movingMap x = 0) :
    coordinates.sourceToIncomingImage x = 0 := by
  apply Subtype.ext
  rw [coordinates.sourceToIncomingImage_value,
    coordinates.sourceValue_eq_zero_of_crossedMap_eq_zero_of_movingMap_eq_zero x
      crossedVanishes movingVanishes]
  rfl

/-- If the map onto the canonical incoming image is also injective, the
crossed and moving maps are jointly injective. Thus a faithful coordinate
model requires more than the scalar row identity. -/
theorem crossedMap_movingMap_jointly_injective
    (coordinates : Coordinates R k specialize edge Nearby)
    (sourceImageInjective : Function.Injective coordinates.sourceToIncomingImage) :
    ∀ x, edge.crossedMap x = 0 → edge.movingMap x = 0 → x = 0 := by
  intro x crossedVanishes movingVanishes
  apply sourceImageInjective
  rw [coordinates.sourceToIncomingImage_eq_zero_of_crossedMap_eq_zero_of_movingMap_eq_zero x
    crossedVanishes movingVanishes, map_zero]

end Coordinates

end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.ModelCrossedCoordinates
