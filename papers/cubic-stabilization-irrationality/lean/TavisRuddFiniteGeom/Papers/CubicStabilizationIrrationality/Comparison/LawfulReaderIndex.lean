import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.FixedPhaseReader

/-!
# Environment-indexed fixed-phase endpoints

An endpoint constructed here stores a coefficient specialization certificate,
but does not store an independently chosen quantum path, phase, character, or
direction. The quantum path is computed from the chamber path by the supplied
reader environment, while the other three labels are shared parameters. Two
such endpoints therefore satisfy the fixed-phase reader compatibility laws by
construction.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.LawfulReaderIndex

open FixedPhaseReader

universe uι uR uk

/-- An endpoint indexed by one coefficient trait and shared phase, character,
and direction labels. -/
structure Endpoint
    (R : Type uR) (k : Type uk) [CommRing R] [CommRing k]
    {Occurrence CoeffParameter ChamberPath QdmPath Phase Character Direction : Type uι}
    (environment : ReaderEnvironment R k Occurrence CoeffParameter ChamberPath QdmPath Direction)
    (specialize : R →+* k)
    (phase : PhaseTag Phase) (character : CharacterTag Character)
    (direction : DirectionTag Direction) where
  occurrence : OccurrenceTag Occurrence
  coeffParameter : CoeffParameterTag CoeffParameter
  chamberPath : ChamberPathTag ChamberPath
  coefficientSpecialization :
    environment.coefficientSpecialization occurrence.value coeffParameter.value = specialize

namespace Endpoint

variable
    {R : Type uR} {k : Type uk} [CommRing R] [CommRing k]
    {Occurrence CoeffParameter ChamberPath QdmPath Phase Character Direction : Type uι}
    {environment :
      ReaderEnvironment R k Occurrence CoeffParameter ChamberPath QdmPath Direction}
    {specialize : R →+* k}
    {phase : PhaseTag Phase} {character : CharacterTag Character}
    {direction : DirectionTag Direction}

/-- The raw reader index determined by an environment-indexed endpoint. Its
quantum path is the image of its chamber path in the named direction. -/
def index
    (endpoint : Endpoint R k environment specialize phase character direction) :
    ReaderIndex Occurrence CoeffParameter ChamberPath QdmPath Phase Character Direction where
  occurrence := endpoint.occurrence
  coeffParameter := endpoint.coeffParameter
  chamberPath := endpoint.chamberPath
  qdmPath :=
    ⟨environment.chamberToQdmPath endpoint.occurrence.value endpoint.chamberPath.value
      direction.value⟩
  phase := phase
  character := character
  direction := direction

@[simp]
theorem index_coefficientSpecialization
    (endpoint : Endpoint R k environment specialize phase character direction) :
    environment.coefficientSpecialization endpoint.index.occurrence.value
      endpoint.index.coeffParameter.value = specialize :=
  endpoint.coefficientSpecialization

@[simp]
theorem index_qdmPath
    (endpoint : Endpoint R k environment specialize phase character direction) :
    environment.chamberToQdmPath endpoint.index.occurrence.value
      endpoint.index.chamberPath.value endpoint.index.direction.value =
        endpoint.index.qdmPath.value :=
  rfl

/-- Two endpoints with the same environment, coefficient trait, phase,
character, and direction satisfy the reader compatibility laws. -/
theorem compatibility
    (source target : Endpoint R k environment specialize phase character direction) :
    ReaderCompatibility R k environment specialize source.index target.index where
  sourceCoefficient := source.coefficientSpecialization
  targetCoefficient := target.coefficientSpecialization
  sourcePath := rfl
  targetPath := rfl
  phasePreserved := rfl
  characterPreserved := rfl
  directionPreserved := rfl

end Endpoint

end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.LawfulReaderIndex
