import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.MarkedLocalSystem
import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.TraitHorizontalReader

/-!
# Selected local-system realization of a trait-horizontal reader

A marked morphism of whole based-loop representations can supply every
two-loop horizontal comparison. To obtain the directed reader for one
occurrence, one must additionally identify the two loop operators and the
marked row selected from each representation with the model and actual
directed diagrams.

This module isolates those two diagram identifications. Once supplied, the
same global horizontal map is selected on both sides and constructs the
trait-horizontal reader. Surjectivity of the ambient semilinear map is a
sufficient coverage hypothesis. The construction does not identify a QDM or
Fourier--Laplace local system with either representation.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.SelectedLocalSystemReader

open FixedPhaseReader
open HorizontalReader
open LawfulReaderIndex
open MarkedLocalSystem
open MarkedMonodromyDiagram
open ModelCrossedCoordinates
open TraitHorizontalReader

universe uι uLoop uLoop' uR uk uC₀ uC₁ uM₀ uM₁ uModel uActual uModelRep uActualRep uCert

/-- Identification of the diagram selected from a based-loop representation
with one independently specified endpoint-indexed directed diagram. -/
structure DiagramIdentification
    (K : Type uR) [CommRing K]
    {Loop : Type uLoop} [Group Loop]
    {Index : Type uι} (source target : Index)
    {V : Type uModel} [AddCommGroup V] [Module K V]
    (representation : MarkedLocalSystem.Representation K Loop V)
    (assignment : LoopAssignment Index Loop)
    (diagram : Diagram K source target V) : Prop where
  selectedDiagram :
    representation.select source target (assignment.loop source) (assignment.loop target) =
      diagram

namespace DiagramIdentification

variable
    {R : Type uR} {k : Type uk} [CommRing R] [CommRing k]
    {specialize : R →+* k}
    {Loop : Type uLoop} {Loop' : Type uLoop'} [Group Loop] [Group Loop']
    {loopMap : Loop →* Loop'}
    {Index : Type uι} {source target : Index}
    {V : Type uModel} {W : Type uActual}
    [AddCommGroup V] [Module R V]
    [AddCommGroup W] [Module k W]
    {domain : MarkedLocalSystem.Representation R Loop V}
    {codomain : MarkedLocalSystem.Representation k Loop' W}
    {assignment : LoopAssignment Index Loop}
    {domainDiagram : Diagram R source target V}
    {codomainDiagram : Diagram k source target W}

/-- Select a whole-local-system horizontal morphism at one assigned loop pair
and transport it through the two supplied diagram identifications. -/
def selectedMorphism
    (domainIdentification :
      DiagramIdentification R source target domain assignment domainDiagram)
    (codomainIdentification :
      DiagramIdentification k source target codomain (assignment.map loopMap) codomainDiagram)
    (horizontal : SemilinearHorizontal specialize loopMap domain codomain) :
    SemilinearMorphism specialize domainDiagram codomainDiagram := by
  rw [← domainIdentification.selectedDiagram, ← codomainIdentification.selectedDiagram]
  exact horizontal.selectAssigned assignment source target

@[simp]
theorem selectedMorphism_map
    (domainIdentification :
      DiagramIdentification R source target domain assignment domainDiagram)
    (codomainIdentification :
      DiagramIdentification k source target codomain (assignment.map loopMap) codomainDiagram)
    (horizontal : SemilinearHorizontal specialize loopMap domain codomain) :
    (domainIdentification.selectedMorphism codomainIdentification horizontal).map = horizontal.map :=
  by
    rcases domainIdentification with ⟨rfl⟩
    rcases codomainIdentification with ⟨rfl⟩
    rfl

end DiagramIdentification

/-- Select a whole-local-system horizontal morphism and transport it through
marked gauge equivalences to independently chosen model and actual frames. -/
def selectedGaugeMorphism
    {R : Type uR} {k : Type uk} [CommRing R] [CommRing k]
    {specialize : R →+* k}
    {Loop : Type uLoop} {Loop' : Type uLoop'} [Group Loop] [Group Loop']
    {loopMap : Loop →* Loop'}
    {Index : Type uι} {source target : Index}
    {ModelRepresentationNearby : Type uModelRep}
    {ActualRepresentationNearby : Type uActualRep}
    {ModelNearby : Type uModel} {ActualNearby : Type uActual}
    [AddCommGroup ModelRepresentationNearby] [Module R ModelRepresentationNearby]
    [AddCommGroup ActualRepresentationNearby] [Module k ActualRepresentationNearby]
    [AddCommGroup ModelNearby] [Module R ModelNearby]
    [AddCommGroup ActualNearby] [Module k ActualNearby]
    {domain : MarkedLocalSystem.Representation R Loop ModelRepresentationNearby}
    {codomain : MarkedLocalSystem.Representation k Loop' ActualRepresentationNearby}
    {assignment : LoopAssignment Index Loop}
    {modelDiagram : Diagram R source target ModelNearby}
    {actualDiagram : Diagram k source target ActualNearby}
    (modelEquivalence : DiagramEquivalence R
      (domain.select source target (assignment.loop source) (assignment.loop target)) modelDiagram)
    (actualEquivalence : DiagramEquivalence k
      (codomain.select source target (loopMap (assignment.loop source))
        (loopMap (assignment.loop target))) actualDiagram)
    (horizontal : SemilinearHorizontal specialize loopMap domain codomain) :
    SemilinearMorphism specialize modelDiagram actualDiagram :=
  (horizontal.selectAssigned assignment source target).transport
    modelEquivalence actualEquivalence

/-- Ambient surjectivity survives selection and marked gauge transport. -/
theorem selectedGaugeMorphism_map_surjective
    {R : Type uR} {k : Type uk} [CommRing R] [CommRing k]
    {specialize : R →+* k}
    {Loop : Type uLoop} {Loop' : Type uLoop'} [Group Loop] [Group Loop']
    {loopMap : Loop →* Loop'}
    {Index : Type uι} {source target : Index}
    {ModelRepresentationNearby : Type uModelRep}
    {ActualRepresentationNearby : Type uActualRep}
    {ModelNearby : Type uModel} {ActualNearby : Type uActual}
    [AddCommGroup ModelRepresentationNearby] [Module R ModelRepresentationNearby]
    [AddCommGroup ActualRepresentationNearby] [Module k ActualRepresentationNearby]
    [AddCommGroup ModelNearby] [Module R ModelNearby]
    [AddCommGroup ActualNearby] [Module k ActualNearby]
    {domain : MarkedLocalSystem.Representation R Loop ModelRepresentationNearby}
    {codomain : MarkedLocalSystem.Representation k Loop' ActualRepresentationNearby}
    {assignment : LoopAssignment Index Loop}
    {modelDiagram : Diagram R source target ModelNearby}
    {actualDiagram : Diagram k source target ActualNearby}
    (modelEquivalence : DiagramEquivalence R
      (domain.select source target (assignment.loop source) (assignment.loop target)) modelDiagram)
    (actualEquivalence : DiagramEquivalence k
      (codomain.select source target (loopMap (assignment.loop source))
        (loopMap (assignment.loop target))) actualDiagram)
    (horizontal : SemilinearHorizontal specialize loopMap domain codomain)
    (surjective : Function.Surjective horizontal.map) :
    Function.Surjective (selectedGaugeMorphism modelEquivalence actualEquivalence horizontal).map :=
  SemilinearMorphism.transport_map_surjective modelEquivalence actualEquivalence
    (horizontal.selectAssigned assignment source target) surjective

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
    {Loop : Type uLoop} {Loop' : Type uLoop'} [Group Loop] [Group Loop']
    {loopMap : Loop →* Loop'}
    {domain : MarkedLocalSystem.Representation R Loop ModelNearby}
    {codomain : MarkedLocalSystem.Representation k Loop' ActualNearby}
    {assignment : LoopAssignment
      (ReaderIndex Occurrence CoeffParameter ChamberPath QdmPath Phase Character Direction) Loop}

/-- Construct the trait-horizontal reader from one whole-local-system
horizontal morphism, the two selected-diagram identifications, and coverage
of the selected incoming monodromy image. -/
def ofMarkedLocalSystemWithImageSpan
    (model : Coordinates R R (RingHom.id R) edge ModelNearby)
    (domainIdentification : DiagramIdentification R sourceEndpoint.index targetEndpoint.index
      domain assignment
      (Diagram.ofOperators model.incoming model.targetMonodromy model.row))
    (codomainIdentification : DiagramIdentification k sourceEndpoint.index targetEndpoint.index
      codomain (assignment.map loopMap)
      (Diagram.ofOperators actual.incoming actual.targetMonodromy actual.row))
    (horizontal : SemilinearHorizontal specialize loopMap domain codomain)
    (imageSpans : Submodule.span k
      (Set.range
        (domainIdentification.selectedMorphism codomainIdentification horizontal).toSpecialization.incomingImageMap) =
      ⊤) :
    TraitHorizontalReader.Reader R k specialize environment phase character direction
      sourceEndpoint targetEndpoint edge ModelNearby ActualNearby PacketCertificate actual where
  model := model
  horizontal := domainIdentification.selectedMorphism codomainIdentification horizontal
  incomingImageSpans := imageSpans

/-- Ambient surjectivity is a sufficient implementation of incoming-image
coverage for a selected whole-local-system comparison. -/
def ofMarkedLocalSystemOfSurjective
    (model : Coordinates R R (RingHom.id R) edge ModelNearby)
    (domainIdentification : DiagramIdentification R sourceEndpoint.index targetEndpoint.index
      domain assignment
      (Diagram.ofOperators model.incoming model.targetMonodromy model.row))
    (codomainIdentification : DiagramIdentification k sourceEndpoint.index targetEndpoint.index
      codomain (assignment.map loopMap)
      (Diagram.ofOperators actual.incoming actual.targetMonodromy actual.row))
    (horizontal : SemilinearHorizontal specialize loopMap domain codomain)
    (mapSurjective : Function.Surjective horizontal.map) :
    TraitHorizontalReader.Reader R k specialize environment phase character direction
      sourceEndpoint targetEndpoint edge ModelNearby ActualNearby PacketCertificate actual :=
  ofMarkedLocalSystemWithImageSpan model domainIdentification codomainIdentification horizontal
    ((domainIdentification.selectedMorphism codomainIdentification horizontal).toSpecialization.incomingImageSpan_eq_top_of_surjective
      (by
        simpa only [SemilinearMorphism.toSpecialization_map,
          DiagramIdentification.selectedMorphism_map] using mapSurjective))

end Reader

namespace GaugeReader

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
    {ModelRepresentationNearby : Type uModelRep}
    {ActualRepresentationNearby : Type uActualRep}
    {ModelNearby : Type uModel} {ActualNearby : Type uActual}
    [AddCommGroup ModelRepresentationNearby] [Module R ModelRepresentationNearby]
    [AddCommGroup ActualRepresentationNearby] [Module k ActualRepresentationNearby]
    [AddCommGroup ModelNearby] [Module R ModelNearby]
    [AddCommGroup ActualNearby] [Module k ActualNearby]
    {PacketCertificate :
      ReaderIndex Occurrence CoeffParameter ChamberPath QdmPath Phase Character Direction →
      ReaderIndex Occurrence CoeffParameter ChamberPath QdmPath Phase Character Direction →
      Type uCert}
    {actual : DirectedFixedPhaseReceiver k PacketCertificate sourceEndpoint.index
      targetEndpoint.index ActualNearby}
    {Loop : Type uLoop} {Loop' : Type uLoop'} [Group Loop] [Group Loop']
    {loopMap : Loop →* Loop'}
    {domain : MarkedLocalSystem.Representation R Loop ModelRepresentationNearby}
    {codomain : MarkedLocalSystem.Representation k Loop' ActualRepresentationNearby}
    {assignment : LoopAssignment
      (ReaderIndex Occurrence CoeffParameter ChamberPath QdmPath Phase Character Direction) Loop}

/-- Construct the trait-horizontal reader after transporting the selected
whole-local-system comparison into independently chosen model and actual
frames. -/
def ofMarkedLocalSystemWithImageSpan
    (model : Coordinates R R (RingHom.id R) edge ModelNearby)
    (modelEquivalence : DiagramEquivalence R
      (domain.select sourceEndpoint.index targetEndpoint.index
        (assignment.loop sourceEndpoint.index) (assignment.loop targetEndpoint.index))
      (Diagram.ofOperators model.incoming model.targetMonodromy model.row))
    (actualEquivalence : DiagramEquivalence k
      (codomain.select sourceEndpoint.index targetEndpoint.index
        (loopMap (assignment.loop sourceEndpoint.index))
        (loopMap (assignment.loop targetEndpoint.index)))
      (Diagram.ofOperators actual.incoming actual.targetMonodromy actual.row))
    (horizontal : SemilinearHorizontal specialize loopMap domain codomain)
    (imageSpans : Submodule.span k
      (Set.range
        (selectedGaugeMorphism modelEquivalence actualEquivalence horizontal).toSpecialization.incomingImageMap) =
      ⊤) :
    TraitHorizontalReader.Reader R k specialize environment phase character direction
      sourceEndpoint targetEndpoint edge ModelNearby ActualNearby PacketCertificate actual where
  model := model
  horizontal := selectedGaugeMorphism modelEquivalence actualEquivalence horizontal
  incomingImageSpans := imageSpans

/-- Ambient surjectivity is preserved by the two marked gauge equivalences and
therefore supplies incoming-image coverage in the chosen frames. -/
def ofMarkedLocalSystemOfSurjective
    (model : Coordinates R R (RingHom.id R) edge ModelNearby)
    (modelEquivalence : DiagramEquivalence R
      (domain.select sourceEndpoint.index targetEndpoint.index
        (assignment.loop sourceEndpoint.index) (assignment.loop targetEndpoint.index))
      (Diagram.ofOperators model.incoming model.targetMonodromy model.row))
    (actualEquivalence : DiagramEquivalence k
      (codomain.select sourceEndpoint.index targetEndpoint.index
        (loopMap (assignment.loop sourceEndpoint.index))
        (loopMap (assignment.loop targetEndpoint.index)))
      (Diagram.ofOperators actual.incoming actual.targetMonodromy actual.row))
    (horizontal : SemilinearHorizontal specialize loopMap domain codomain)
    (surjective : Function.Surjective horizontal.map) :
    TraitHorizontalReader.Reader R k specialize environment phase character direction
      sourceEndpoint targetEndpoint edge ModelNearby ActualNearby PacketCertificate actual :=
  TraitHorizontalReader.Reader.ofSurjective model
    (selectedGaugeMorphism modelEquivalence actualEquivalence horizontal)
    (selectedGaugeMorphism_map_surjective modelEquivalence actualEquivalence horizontal surjective)

end GaugeReader

end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.SelectedLocalSystemReader
