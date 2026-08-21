import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.CanVariationCoverage
import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.HorizontalReader

/-!
# Crossed coordinates from can and variation maps

An incoming can/variation diagram supplies the canonical source realization
and coverage of the incoming monodromy image whenever can covers the packet
modulo the kernel of variation. A target monodromy whose action on that source
realization has the crossed and moving components of the edge then supplies
the target vector coordinates. The three row restrictions complete the
crossed-coordinate model.

This construction uses the selected monodromies themselves. It imposes no
finite-order relation on the target monodromy. The can and variation maps are
normalized so that both composites are identity minus monodromy; a source
using the opposite sign must change one of these maps before applying the
construction.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.CanVariationCoordinates

open CanVariationCoverage
open FixedPhaseReader
open HorizontalReader
open ModelCrossedCoordinates
open MonodromyImage

universe uι uR uC₀ uC₁ uM₀ uM₁ uV uCert

variable
    {R : Type uR} [CommRing R]
    {Occurrence CoeffParameter ChamberPath QdmPath Phase Character Direction : Type uι}
    {source target : ReaderIndex Occurrence CoeffParameter ChamberPath QdmPath Phase
      Character Direction}
    {C₀ : Type uC₀} {C₁ : Type uC₁} {M₀ : Type uM₀} {M₁ : Type uM₁}
    [AddCommGroup C₀] [Module R C₀]
    [AddCommGroup C₁] [Module R C₁]
    [AddCommGroup M₀] [Module R M₀]
    [AddCommGroup M₁] [Module R M₁]
    {edge : CrossedEdge R source target C₀ C₁ M₀ M₁}
    {Nearby : Type uV} [AddCommGroup Nearby] [Module R Nearby]

/-- Regard a linear map as a semilinear map over the identity ring
homomorphism. -/
def identitySemilinear {A B : Type*}
    [AddCommGroup A] [Module R A] [AddCommGroup B] [Module R B]
    (map : A →ₗ[R] B) : A →ₛₗ[RingHom.id R] B where
  toFun := map
  map_add' := map.map_add
  map_smul' scalar value := by simp

/-- The identity-semilinear wrapper evaluates as its underlying linear map. -/
@[simp]
theorem identitySemilinear_apply {A B : Type*}
    [AddCommGroup A] [Module R A] [AddCommGroup B] [Module R B]
    (map : A →ₗ[R] B) (value : A) :
    identitySemilinear map value = map value :=
  rfl

namespace IncomingCoordinates

/-- A can/variation factorization whose can map covers variation
supplies the incoming-image coordinates.  The exact condition is that every
variation value have a representative in the image of can. -/
def ofCanVariation
    (incoming : Nearby ≃ₗ[R] Nearby)
    (packetOperator : M₀ →ₗ[R] M₀)
    (diagram : Diagram incoming.toLinearMap packetOperator)
    (canCoverage : diagram.CanCoversVariation) :
    IncomingCoordinates R R (RingHom.id R) edge Nearby where
  incoming := incoming
  sourceValue := identitySemilinear diagram.variation
  sourceToIncomingImage :=
    identitySemilinear
      (diagram.variationToAmbientRangeOfCanCoverage canCoverage)
  sourceToIncomingImage_value := by intro value; rfl
  sourceToIncomingImage_surjective :=
    diagram.variationToAmbientRangeOfCanCoverage_surjective canCoverage

end IncomingCoordinates

namespace TargetCoordinates

/-- If the selected target monodromy sends every incoming variation value to
the crossed-plus-moving target coordinates, its identity-minus action has the
required vector defect formula. -/
def ofTargetTransport
    (incomingCoordinates :
      IncomingCoordinates R R (RingHom.id R) edge Nearby)
    (targetMonodromy : Nearby ≃ₗ[R] Nearby)
    (targetCommonValue : C₁ →ₗ[R] Nearby)
    (targetMovingValue : M₁ →ₗ[R] Nearby)
    (targetTransport : ∀ x,
      targetMonodromy (incomingCoordinates.sourceValue x) =
        targetMovingValue (edge.movingMap x) +
          targetCommonValue (edge.crossedMap x)) :
    TargetCoordinates R R (RingHom.id R) edge Nearby incomingCoordinates where
  targetMonodromy := targetMonodromy
  targetCommonValue := identitySemilinear targetCommonValue
  targetMovingValue := identitySemilinear targetMovingValue
  targetDefectCoordinates := by
    intro value
    change incomingCoordinates.sourceValue value -
        targetMonodromy (incomingCoordinates.sourceValue value) =
      incomingCoordinates.sourceValue value - targetMovingValue (edge.movingMap value) -
        targetCommonValue (edge.crossedMap value)
    rw [targetTransport]
    abel

end TargetCoordinates

namespace RowCoordinates

/-- The three restrictions of one row to the source, target-common, and
target-moving coordinates complete the scalar part of the model. -/
def ofLinearRestrictions
    (incomingCoordinates :
      IncomingCoordinates R R (RingHom.id R) edge Nearby)
    (targetCoordinates :
      TargetCoordinates R R (RingHom.id R) edge Nearby incomingCoordinates)
    (row : Nearby →ₗ[R] R)
    (sourceRow : ∀ x,
      row (incomingCoordinates.sourceValue x) = edge.sourceMovingRow x)
    (targetCommonRow : ∀ x,
      row (targetCoordinates.targetCommonValue x) = edge.targetCommonRow x)
    (targetMovingRow : ∀ x,
      row (targetCoordinates.targetMovingValue x) = edge.targetMovingRow x) :
    RowCoordinates R R (RingHom.id R) edge Nearby
      incomingCoordinates targetCoordinates where
  row := row
  sourceRowCoordinates := by simpa using sourceRow
  targetCommonRowCoordinates := by simpa using targetCommonRow
  targetMovingRowCoordinates := by simpa using targetMovingRow

end RowCoordinates

/-- Assemble crossed coordinates from can/variation coverage, target
transport, and the three row restrictions on named maps. -/
def coordinates
    (incoming : Nearby ≃ₗ[R] Nearby)
    (packetOperator : M₀ →ₗ[R] M₀)
    (diagram : Diagram incoming.toLinearMap packetOperator)
    (canCoverage : diagram.CanCoversVariation)
    (targetMonodromy : Nearby ≃ₗ[R] Nearby)
    (targetCommonValue : C₁ →ₗ[R] Nearby)
    (targetMovingValue : M₁ →ₗ[R] Nearby)
    (targetTransport : ∀ x,
      targetMonodromy (diagram.variation x) =
        targetMovingValue (edge.movingMap x) +
          targetCommonValue (edge.crossedMap x))
    (row : Nearby →ₗ[R] R)
    (sourceRow : ∀ x, row (diagram.variation x) = edge.sourceMovingRow x)
    (targetCommonRow : ∀ x,
      row (targetCommonValue x) = edge.targetCommonRow x)
    (targetMovingRow : ∀ x,
      row (targetMovingValue x) = edge.targetMovingRow x) :
    Coordinates R R (RingHom.id R) edge Nearby := by
  let incomingCoordinates := IncomingCoordinates.ofCanVariation
    (edge := edge) incoming packetOperator diagram canCoverage
  let targetCoordinates := TargetCoordinates.ofTargetTransport
    (edge := edge) incomingCoordinates targetMonodromy targetCommonValue targetMovingValue
    (by simpa only [incomingCoordinates, IncomingCoordinates.ofCanVariation,
      identitySemilinear_apply] using targetTransport)
  exact Coordinates.ofParts incomingCoordinates targetCoordinates
    (RowCoordinates.ofLinearRestrictions incomingCoordinates targetCoordinates row
      (by simpa only [incomingCoordinates, IncomingCoordinates.ofCanVariation,
        identitySemilinear_apply] using sourceRow)
      (by simpa only [targetCoordinates, TargetCoordinates.ofTargetTransport,
        identitySemilinear_apply] using targetCommonRow)
      (by simpa only [targetCoordinates, TargetCoordinates.ofTargetTransport,
        identitySemilinear_apply] using targetMovingRow))

/-- Can/variation and crossed-coordinate data attached to one externally
supplied fixed-phase receiver. The packet certificate remains external; this
record cannot choose replacement ambient monodromies or a replacement row. -/
structure FixedReceiverCertificate
    (PacketCertificate :
      ReaderIndex Occurrence CoeffParameter ChamberPath QdmPath Phase Character Direction →
      ReaderIndex Occurrence CoeffParameter ChamberPath QdmPath Phase Character Direction →
      Type uCert)
    (actual : DirectedFixedPhaseReceiver R PacketCertificate source target Nearby) where
  packetMonodromy : M₀ ≃ₗ[R] M₀
  diagram : Diagram actual.incoming.toLinearMap packetMonodromy.toLinearMap
  canCoverage : diagram.CanCoversVariation
  targetCommonValue : C₁ →ₗ[R] Nearby
  targetMovingValue : M₁ →ₗ[R] Nearby
  targetTransport : ∀ x,
    actual.targetMonodromy (diagram.variation x) =
      targetMovingValue (edge.movingMap x) + targetCommonValue (edge.crossedMap x)
  sourceRow : ∀ x, actual.row (diagram.variation x) = edge.sourceMovingRow x
  targetCommonRow : ∀ x,
    actual.row (targetCommonValue x) = edge.targetCommonRow x
  targetMovingRow : ∀ x,
    actual.row (targetMovingValue x) = edge.targetMovingRow x

namespace FixedReceiverCertificate

variable
    {PacketCertificate :
      ReaderIndex Occurrence CoeffParameter ChamberPath QdmPath Phase Character Direction →
      ReaderIndex Occurrence CoeffParameter ChamberPath QdmPath Phase Character Direction →
      Type uCert}
    {actual : DirectedFixedPhaseReceiver R PacketCertificate source target Nearby}

/-- The fixed receiver certificate constructs crossed coordinates on the
receiver's own nearby module, using its own monodromies and row. -/
def toCoordinates
    (certificate : FixedReceiverCertificate (edge := edge) PacketCertificate actual) :
    Coordinates R R (RingHom.id R) edge Nearby :=
  coordinates actual.incoming certificate.packetMonodromy.toLinearMap
    certificate.diagram certificate.canCoverage
    actual.targetMonodromy certificate.targetCommonValue certificate.targetMovingValue
    certificate.targetTransport actual.row certificate.sourceRow
    certificate.targetCommonRow certificate.targetMovingRow

/-- When the crossed normal vanishes, the certificate proves that the
directed projected variation of the externally supplied receiver is zero on
its whole incoming monodromy image. -/
theorem projectedVariation_eq_zero
    (certificate : FixedReceiverCertificate (edge := edge) PacketCertificate actual)
    (normalVanishes : edge.normal = 0) :
    ProjectedVariation.projectedVariation actual.incoming.toLinearMap
      actual.targetMonodromy.toLinearMap actual.row = 0 := by
  let coordinates := certificate.toCoordinates
  change ProjectedVariation.projectedVariation coordinates.incoming.toLinearMap
      coordinates.targetMonodromy.toLinearMap coordinates.row = 0
  apply LinearMap.ext
  intro value
  obtain ⟨sourceValue, sourceEquation⟩ :=
    coordinates.sourceToIncomingImage_surjective value
  rw [← sourceEquation,
    coordinates.projectedVariation_sourceToIncomingImage]
  have defectFormula := LinearMap.congr_fun edge.defect_eq_normal_smul sourceValue
  rw [defectFormula, normalVanishes]
  simp

end FixedReceiverCertificate

/-- A source-facing form of the fixed-receiver certificate. The target common
and moving maps are the two coordinate restrictions of one window map. Hence
the vector input is one comparison square between the selected target
monodromy and the full crossed window edge. -/
structure FixedReceiverWindowCertificate
    (PacketCertificate :
      ReaderIndex Occurrence CoeffParameter ChamberPath QdmPath Phase Character Direction →
      ReaderIndex Occurrence CoeffParameter ChamberPath QdmPath Phase Character Direction →
      Type uCert)
    (actual : DirectedFixedPhaseReceiver R PacketCertificate source target Nearby) where
  packetMonodromy : M₀ ≃ₗ[R] M₀
  diagram : Diagram actual.incoming.toLinearMap packetMonodromy.toLinearMap
  canCoverage : diagram.CanCoversVariation
  targetWindowValue : C₁ × M₁ →ₗ[R] Nearby
  targetWindowReading : ∀ x,
    actual.targetMonodromy (diagram.variation x) =
      targetWindowValue (edge.movingTargetMap x)
  sourceRow : ∀ x, actual.row (diagram.variation x) = edge.sourceMovingRow x
  targetWindowRow : ∀ value,
    actual.row (targetWindowValue value) =
      edge.targetCommonRow value.1 + edge.targetMovingRow value.2

namespace FixedReceiverWindowCertificate

variable
    {PacketCertificate :
      ReaderIndex Occurrence CoeffParameter ChamberPath QdmPath Phase Character Direction →
      ReaderIndex Occurrence CoeffParameter ChamberPath QdmPath Phase Character Direction →
      Type uCert}
    {actual : DirectedFixedPhaseReceiver R PacketCertificate source target Nearby}

/-- Restriction of the target window realization to the common coordinate. -/
def targetCommonValue
    (certificate : FixedReceiverWindowCertificate (edge := edge) PacketCertificate actual) :
    C₁ →ₗ[R] Nearby where
  toFun value := certificate.targetWindowValue (value, 0)
  map_add' left right := by
    simpa using certificate.targetWindowValue.map_add (left, 0) (right, 0)
  map_smul' scalar value := by
    simpa using certificate.targetWindowValue.map_smul scalar (value, 0)

/-- Restriction of the target window realization to the moving coordinate. -/
def targetMovingValue
    (certificate : FixedReceiverWindowCertificate (edge := edge) PacketCertificate actual) :
    M₁ →ₗ[R] Nearby where
  toFun value := certificate.targetWindowValue (0, value)
  map_add' left right := by
    simpa using certificate.targetWindowValue.map_add (0, left) (0, right)
  map_smul' scalar value := by
    simpa using certificate.targetWindowValue.map_smul scalar (0, value)

/-- The window comparison square and window row square imply the component
certificate consumed by the coordinate theorem. -/
def toFixedReceiverCertificate
    (certificate : FixedReceiverWindowCertificate (edge := edge) PacketCertificate actual) :
    FixedReceiverCertificate (edge := edge) PacketCertificate actual where
  packetMonodromy := certificate.packetMonodromy
  diagram := certificate.diagram
  canCoverage := certificate.canCoverage
  targetCommonValue := certificate.targetCommonValue
  targetMovingValue := certificate.targetMovingValue
  targetTransport := by
    intro value
    rw [certificate.targetWindowReading]
    change certificate.targetWindowValue (edge.movingTargetMap value) =
      certificate.targetWindowValue (0, edge.movingMap value) +
        certificate.targetWindowValue (edge.crossedMap value, 0)
    rw [← map_add]
    congr 1
    ext <;> simp [CrossedEdge.movingTargetMap, add_comm]
  sourceRow := certificate.sourceRow
  targetCommonRow := by
    intro value
    simpa [targetCommonValue] using certificate.targetWindowRow (value, 0)
  targetMovingRow := by
    intro value
    simpa [targetMovingValue] using certificate.targetWindowRow (0, value)

/-- The source-facing window certificate constructs crossed coordinates on
the externally supplied receiver. -/
def toCoordinates
    (certificate : FixedReceiverWindowCertificate (edge := edge) PacketCertificate actual) :
    Coordinates R R (RingHom.id R) edge Nearby :=
  certificate.toFixedReceiverCertificate.toCoordinates

/-- A zero crossed normal kills the projected variation after the one window
comparison square and the two row restrictions have been supplied. -/
theorem projectedVariation_eq_zero
    (certificate : FixedReceiverWindowCertificate (edge := edge) PacketCertificate actual)
    (normalVanishes : edge.normal = 0) :
    ProjectedVariation.projectedVariation actual.incoming.toLinearMap
      actual.targetMonodromy.toLinearMap actual.row = 0 :=
  certificate.toFixedReceiverCertificate.projectedVariation_eq_zero normalVanishes

end FixedReceiverWindowCertificate

/-- A row-scaled window certificate on an externally supplied receiver. The
same scalar multiplies the source and target window rows; it need not be a
unit for the one-way vanishing theorem. -/
structure ScaledFixedReceiverWindowCertificate
    (PacketCertificate :
      ReaderIndex Occurrence CoeffParameter ChamberPath QdmPath Phase Character Direction →
      ReaderIndex Occurrence CoeffParameter ChamberPath QdmPath Phase Character Direction →
      Type uCert)
    (actual : DirectedFixedPhaseReceiver R PacketCertificate source target Nearby) where
  packetMonodromy : M₀ ≃ₗ[R] M₀
  diagram : Diagram actual.incoming.toLinearMap packetMonodromy.toLinearMap
  canCoverage : diagram.CanCoversVariation
  targetWindowValue : C₁ × M₁ →ₗ[R] Nearby
  targetWindowReading : ∀ x,
    actual.targetMonodromy (diagram.variation x) =
      targetWindowValue (edge.movingTargetMap x)
  rowScale : R
  sourceRow : ∀ x,
    actual.row (diagram.variation x) = rowScale * edge.sourceMovingRow x
  targetWindowRow : ∀ value,
    actual.row (targetWindowValue value) =
      rowScale *
        (edge.targetCommonRow value.1 + edge.targetMovingRow value.2)

namespace ScaledFixedReceiverWindowCertificate

variable
    {PacketCertificate :
      ReaderIndex Occurrence CoeffParameter ChamberPath QdmPath Phase Character Direction →
      ReaderIndex Occurrence CoeffParameter ChamberPath QdmPath Phase Character Direction →
      Type uCert}
    {actual : DirectedFixedPhaseReceiver R PacketCertificate source target Nearby}

/-- A zero crossed normal kills the actual projected variation even when all
window row identifications carry one common scalar factor. -/
theorem projectedVariation_eq_zero
    (certificate :
      ScaledFixedReceiverWindowCertificate (edge := edge) PacketCertificate actual)
    (normalVanishes : edge.normal = 0) :
    ProjectedVariation.projectedVariation actual.incoming.toLinearMap
      actual.targetMonodromy.toLinearMap actual.row = 0 := by
  apply LinearMap.ext
  intro value
  obtain ⟨sourceValue, sourceEquation⟩ :=
    certificate.diagram.variationToAmbientRangeOfCanCoverage_surjective
      certificate.canCoverage value
  have valueEquation : value.1 = certificate.diagram.variation sourceValue :=
    congrArg Subtype.val sourceEquation.symm
  change actual.row (defectOperator actual.targetMonodromy.toLinearMap value.1) = 0
  rw [valueEquation]
  change actual.row (certificate.diagram.variation sourceValue -
    actual.targetMonodromy (certificate.diagram.variation sourceValue)) = 0
  rw [certificate.targetWindowReading, map_sub, certificate.sourceRow,
    certificate.targetWindowRow]
  change certificate.rowScale * edge.sourceMovingRow sourceValue -
      certificate.rowScale *
        (edge.targetCommonRow (edge.crossedMap sourceValue) +
          edge.targetMovingRow (edge.movingMap sourceValue)) = 0
  have defectFormula := LinearMap.congr_fun edge.defect_eq_normal_smul sourceValue
  calc
    certificate.rowScale * edge.sourceMovingRow sourceValue -
        certificate.rowScale *
          (edge.targetCommonRow (edge.crossedMap sourceValue) +
            edge.targetMovingRow (edge.movingMap sourceValue)) =
      certificate.rowScale * edge.defect sourceValue := by
        simp only [CrossedEdge.defect, LinearMap.sub_apply, LinearMap.comp_apply]
        ring
    _ = certificate.rowScale *
        (edge.normal * edge.sourceMovingRow sourceValue) := by
          rw [defectFormula]
          simp
    _ = 0 := by rw [normalVanishes]; ring

end ScaledFixedReceiverWindowCertificate

end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.CanVariationCoordinates
