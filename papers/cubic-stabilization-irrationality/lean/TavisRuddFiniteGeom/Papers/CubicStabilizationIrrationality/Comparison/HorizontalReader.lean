import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.ModelCrossedCoordinates

/-!
# Horizontal reader for directed projected variation

The actual directed receiver is an external parameter, not data chosen by a
reader witness. Model projected variation is derived from vector-valued
crossed-coordinate equations. One marked horizontal comparison then
transports model vanishing to the supplied actual receiver; only its induced
map on the incoming monodromy image must be surjective.

The crossed-coordinate model, the actual receiver identification, and the
horizontal comparison remain hypotheses. The module does not assert that
monodromy-image formation commutes with a non-flat specialization.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.HorizontalReader

open FixedPhaseReader
open MonodromyImage
open ProjectedVariation
open ModelCrossedCoordinates

universe uι uR uk uC₀ uC₁ uM₀ uM₁ uModel uActual uCert

/-- The pre-existing directed fixed-phase receiver consumed by the theorem.
Its occurrence indices are part of its type. -/
structure DirectedFixedPhaseReceiver
    (k : Type uk) [CommRing k]
    {Occurrence CoeffParameter ChamberPath QdmPath Phase Character Direction : Type uι}
    (PacketCertificate :
      ReaderIndex Occurrence CoeffParameter ChamberPath QdmPath Phase Character Direction →
      ReaderIndex Occurrence CoeffParameter ChamberPath QdmPath Phase Character Direction →
      Type uCert)
    (source target : ReaderIndex Occurrence CoeffParameter ChamberPath QdmPath Phase
      Character Direction)
    (Nearby : Type uActual) [AddCommGroup Nearby] [Module k Nearby] where
  incoming : Nearby ≃ₗ[k] Nearby
  targetMonodromy : Nearby ≃ₗ[k] Nearby
  row : Nearby →ₗ[k] k
  packetCertificate : PacketCertificate source target

/-- A reader from specialized crossed coordinates to one externally supplied
directed fixed-phase receiver. -/
structure Reader
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
    (environment : ReaderEnvironment R k Occurrence CoeffParameter ChamberPath QdmPath Direction)
    (ModelNearby : Type uModel) (ActualNearby : Type uActual)
    [AddCommGroup ModelNearby] [Module k ModelNearby]
    [AddCommGroup ActualNearby] [Module k ActualNearby]
    (PacketCertificate :
      ReaderIndex Occurrence CoeffParameter ChamberPath QdmPath Phase Character Direction →
      ReaderIndex Occurrence CoeffParameter ChamberPath QdmPath Phase Character Direction →
      Type uCert)
    (actual : DirectedFixedPhaseReceiver k PacketCertificate source target ActualNearby) where
  compatibility : ReaderCompatibility R k environment specialize source target
  model : Coordinates R k specialize edge ModelNearby
  horizontalMap : ModelNearby →ₗ[k] ActualNearby
  horizontalIncoming :
    Intertwines horizontalMap model.incoming.toLinearMap actual.incoming.toLinearMap
  horizontalTarget :
    Intertwines horizontalMap model.targetMonodromy.toLinearMap
      actual.targetMonodromy.toLinearMap
  incomingImageMap_surjective : Function.Surjective
    (imageMap horizontalMap model.incoming.toLinearMap actual.incoming.toLinearMap
      horizontalIncoming)
  rowCompatible : actual.row.comp horizontalMap = model.row

namespace Reader

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
    {environment : ReaderEnvironment R k Occurrence CoeffParameter ChamberPath QdmPath Direction}
    {ModelNearby : Type uModel} {ActualNearby : Type uActual}
    [AddCommGroup ModelNearby] [Module k ModelNearby]
    [AddCommGroup ActualNearby] [Module k ActualNearby]
    {PacketCertificate :
      ReaderIndex Occurrence CoeffParameter ChamberPath QdmPath Phase Character Direction →
      ReaderIndex Occurrence CoeffParameter ChamberPath QdmPath Phase Character Direction →
      Type uCert}
    {actual : DirectedFixedPhaseReceiver k PacketCertificate source target ActualNearby}

/-- A zero specialized normal kills the intrinsic model projected variation.
The scalar reading is derived from the vector crossed-coordinate equations. -/
theorem modelVariation_eq_zero
    (reader : Reader R k specialize edge environment ModelNearby ActualNearby
      PacketCertificate actual)
    (normalVanishes : specialize edge.normal = 0) :
    projectedVariation reader.model.incoming.toLinearMap
      reader.model.targetMonodromy.toLinearMap
      reader.model.row = 0 := by
  apply LinearMap.ext
  intro y
  obtain ⟨x, rfl⟩ := reader.model.sourceToIncomingImage_surjective y
  calc
    projectedVariation reader.model.incoming.toLinearMap
      reader.model.targetMonodromy.toLinearMap
        reader.model.row (reader.model.sourceToIncomingImage x) =
        specialize (edge.defect x) :=
      reader.model.projectedVariation_sourceToIncomingImage x
    _ = specialize (edge.normal * edge.sourceMovingRow x) := by
      rw [LinearMap.congr_fun edge.defect_eq_normal_smul x,
        LinearMap.smul_apply, smul_eq_mul]
    _ = 0 := by simp [normalVanishes]

/-- A zero specialized normal kills the directed projected variation on the
externally supplied actual receiver. -/
theorem actualVariation_eq_zero
    (reader : Reader R k specialize edge environment ModelNearby ActualNearby
      PacketCertificate actual)
    (normalVanishes : specialize edge.normal = 0) :
    projectedVariation actual.incoming.toLinearMap actual.targetMonodromy.toLinearMap
      actual.row = 0 :=
  projectedVariation_eq_zero_of_imageMap_surjective
    reader.horizontalMap
    reader.model.incoming.toLinearMap reader.model.targetMonodromy.toLinearMap
    actual.incoming.toLinearMap actual.targetMonodromy.toLinearMap
    reader.horizontalIncoming reader.horizontalTarget
    reader.model.row actual.row reader.rowCompatible
    reader.incomingImageMap_surjective
    (reader.modelVariation_eq_zero normalVanishes)

end Reader

/-- The reduced analytic goal for one fixed actual receiver. -/
def Goal
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
    (environment : ReaderEnvironment R k Occurrence CoeffParameter ChamberPath QdmPath Direction)
    (ModelNearby : Type uModel) (ActualNearby : Type uActual)
    [AddCommGroup ModelNearby] [Module k ModelNearby]
    [AddCommGroup ActualNearby] [Module k ActualNearby]
    (PacketCertificate :
      ReaderIndex Occurrence CoeffParameter ChamberPath QdmPath Phase Character Direction →
      ReaderIndex Occurrence CoeffParameter ChamberPath QdmPath Phase Character Direction →
      Type uCert)
    (actual : DirectedFixedPhaseReceiver k PacketCertificate source target ActualNearby) : Prop :=
  Nonempty (Reader R k specialize edge environment ModelNearby ActualNearby
    PacketCertificate actual)

end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.HorizontalReader
