import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.HorizontalReader
import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.LawfulReaderIndex
import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.MarkedMonodromyDiagram
import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.SemilinearVariation

/-!
# Trait-horizontal reader for directed projected variation

Crossed coordinates over the trait identify the model projected variation
with the algebraic crossed defect before specialization. A marked semilinear
comparison to an externally supplied fixed-phase receiver then transports the
specialized variation. The proof consumes only spanning of the specialized
incoming image, not an isomorphism between a tensor product of the trait image
and the fibre image.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.TraitHorizontalReader

open FixedPhaseReader
open HorizontalReader
open LawfulReaderIndex
open MarkedMonodromyDiagram
open ModelCrossedCoordinates
open MonodromyImage
open ProjectedVariation
open SemilinearVariation

universe uι uR uk uC₀ uC₁ uM₀ uM₁ uModel uActual uCert

/-- Trait-level crossed coordinates, an external fixed-phase receiver, and one
marked semilinear comparison between them. -/
structure Reader
    (R : Type uR) (k : Type uk) [CommRing R] [CommRing k]
    (specialize : R →+* k)
    {Occurrence CoeffParameter ChamberPath QdmPath Phase Character Direction : Type uι}
    (environment : ReaderEnvironment R k Occurrence CoeffParameter ChamberPath QdmPath Direction)
    (phase : PhaseTag Phase) (character : CharacterTag Character)
    (direction : DirectionTag Direction)
    (sourceEndpoint targetEndpoint :
      Endpoint R k environment specialize phase character direction)
    {C₀ : Type uC₀} {C₁ : Type uC₁} {M₀ : Type uM₀} {M₁ : Type uM₁}
    [AddCommGroup C₀] [Module R C₀]
    [AddCommGroup C₁] [Module R C₁]
    [AddCommGroup M₀] [Module R M₀]
    [AddCommGroup M₁] [Module R M₁]
    (edge : CrossedEdge R sourceEndpoint.index targetEndpoint.index C₀ C₁ M₀ M₁)
    (ModelNearby : Type uModel) (ActualNearby : Type uActual)
    [AddCommGroup ModelNearby] [Module R ModelNearby]
    [AddCommGroup ActualNearby] [Module k ActualNearby]
    (PacketCertificate :
      ReaderIndex Occurrence CoeffParameter ChamberPath QdmPath Phase Character Direction →
      ReaderIndex Occurrence CoeffParameter ChamberPath QdmPath Phase Character Direction →
      Type uCert)
    (actual : DirectedFixedPhaseReceiver k PacketCertificate sourceEndpoint.index
      targetEndpoint.index ActualNearby) where
  model : Coordinates R R (RingHom.id R) edge ModelNearby
  horizontal : SemilinearMorphism specialize
    (Diagram.ofOperators (source := sourceEndpoint.index) (target := targetEndpoint.index)
      model.incoming model.targetMonodromy model.row)
    (Diagram.ofOperators (source := sourceEndpoint.index) (target := targetEndpoint.index)
      actual.incoming actual.targetMonodromy actual.row)
  incomingImageSpans :
    Submodule.span k (Set.range horizontal.toSpecialization.incomingImageMap) = ⊤

namespace Reader

variable
    {R : Type uR} {k : Type uk} [CommRing R] [CommRing k]
    {specialize : R →+* k}
    {Occurrence CoeffParameter ChamberPath QdmPath Phase Character Direction : Type uι}
    {environment : ReaderEnvironment R k Occurrence CoeffParameter ChamberPath QdmPath Direction}
    {phase : PhaseTag Phase} {character : CharacterTag Character}
    {direction : DirectionTag Direction}
    {sourceEndpoint targetEndpoint :
      Endpoint R k environment specialize phase character direction}
    {C₀ : Type uC₀} {C₁ : Type uC₁} {M₀ : Type uM₀} {M₁ : Type uM₁}
    [AddCommGroup C₀] [Module R C₀]
    [AddCommGroup C₁] [Module R C₁]
    [AddCommGroup M₀] [Module R M₀]
    [AddCommGroup M₁] [Module R M₁]
    {edge : CrossedEdge R sourceEndpoint.index targetEndpoint.index C₀ C₁ M₀ M₁}
    {ModelNearby : Type uModel} {ActualNearby : Type uActual}
    [AddCommGroup ModelNearby] [Module R ModelNearby]
    [AddCommGroup ActualNearby] [Module k ActualNearby]
    {PacketCertificate :
      ReaderIndex Occurrence CoeffParameter ChamberPath QdmPath Phase Character Direction →
      ReaderIndex Occurrence CoeffParameter ChamberPath QdmPath Phase Character Direction →
      Type uCert}
    {actual : DirectedFixedPhaseReceiver k PacketCertificate sourceEndpoint.index
      targetEndpoint.index ActualNearby}

/-- Construct a trait-horizontal reader from a surjective ambient semilinear
comparison. Surjectivity supplies the incoming-image spanning field. -/
def ofSurjective
    (model : Coordinates R R (RingHom.id R) edge ModelNearby)
    (horizontal : SemilinearMorphism specialize
      (Diagram.ofOperators (source := sourceEndpoint.index) (target := targetEndpoint.index)
        model.incoming model.targetMonodromy model.row)
      (Diagram.ofOperators (source := sourceEndpoint.index) (target := targetEndpoint.index)
        actual.incoming actual.targetMonodromy actual.row))
    (mapSurjective : Function.Surjective horizontal.map) :
    Reader R k specialize environment phase character direction sourceEndpoint
      targetEndpoint edge ModelNearby ActualNearby PacketCertificate actual where
  model := model
  horizontal := horizontal
  incomingImageSpans :=
    horizontal.toSpecialization.incomingImageSpan_eq_top_of_surjective mapSurjective

/-- A zero trait normal makes every value of the model variation vanish after
scalar specialization. -/
theorem specializedModelVariation_eq_zero
    (reader : Reader R k specialize environment phase character direction sourceEndpoint
      targetEndpoint edge ModelNearby ActualNearby PacketCertificate actual)
    (normalVanishes : specialize edge.normal = 0)
    (x : LinearMap.range (defectOperator reader.model.incoming.toLinearMap)) :
    specialize
      (projectedVariation reader.model.incoming.toLinearMap
        reader.model.targetMonodromy.toLinearMap
        reader.model.row x) = 0 := by
  obtain ⟨sourceValue, rfl⟩ := reader.model.sourceToIncomingImage_surjective x
  rw [reader.model.projectedVariation_sourceToIncomingImage]
  rw [LinearMap.congr_fun edge.defect_eq_normal_smul sourceValue,
    LinearMap.smul_apply, smul_eq_mul]
  simp [normalVanishes]

/-- A zero trait normal kills directed projected variation on the externally
supplied fibre receiver. -/
theorem actualVariation_eq_zero
    (reader : Reader R k specialize environment phase character direction sourceEndpoint
      targetEndpoint edge ModelNearby ActualNearby PacketCertificate actual)
    (normalVanishes : specialize edge.normal = 0) :
    projectedVariation actual.incoming.toLinearMap actual.targetMonodromy.toLinearMap
      actual.row = 0 :=
  reader.horizontal.toSpecialization.projectedVariation_eq_zero_of_incomingImageSpan_eq_top
    reader.incomingImageSpans (reader.specializedModelVariation_eq_zero normalVanishes)

end Reader

/-- Existence of the typed trait-horizontal comparison for a fixed external
receiver. -/
def Goal
    (R : Type uR) (k : Type uk) [CommRing R] [CommRing k]
    (specialize : R →+* k)
    {Occurrence CoeffParameter ChamberPath QdmPath Phase Character Direction : Type uι}
    (environment : ReaderEnvironment R k Occurrence CoeffParameter ChamberPath QdmPath Direction)
    (phase : PhaseTag Phase) (character : CharacterTag Character)
    (direction : DirectionTag Direction)
    (sourceEndpoint targetEndpoint :
      Endpoint R k environment specialize phase character direction)
    {C₀ : Type uC₀} {C₁ : Type uC₁} {M₀ : Type uM₀} {M₁ : Type uM₁}
    [AddCommGroup C₀] [Module R C₀]
    [AddCommGroup C₁] [Module R C₁]
    [AddCommGroup M₀] [Module R M₀]
    [AddCommGroup M₁] [Module R M₁]
    (edge : CrossedEdge R sourceEndpoint.index targetEndpoint.index C₀ C₁ M₀ M₁)
    (ModelNearby : Type uModel) (ActualNearby : Type uActual)
    [AddCommGroup ModelNearby] [Module R ModelNearby]
    [AddCommGroup ActualNearby] [Module k ActualNearby]
    (PacketCertificate :
      ReaderIndex Occurrence CoeffParameter ChamberPath QdmPath Phase Character Direction →
      ReaderIndex Occurrence CoeffParameter ChamberPath QdmPath Phase Character Direction →
      Type uCert)
    (actual : DirectedFixedPhaseReceiver k PacketCertificate sourceEndpoint.index
      targetEndpoint.index ActualNearby) : Prop :=
  Nonempty (Reader R k specialize environment phase character direction sourceEndpoint
    targetEndpoint edge ModelNearby ActualNearby PacketCertificate actual)

end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.TraitHorizontalReader
