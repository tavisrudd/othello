import Mathlib

/-!
# Fixed-phase comparison readers

This module isolates the algebraic input needed to transport one directed
fixed-phase row across a wall comparison. The coefficient-specialization
parameter, chamber-groupoid path, quantum/deck path, phase, and occurrence are
independent indices. A reader can only be applied to the crossed edge carrying
the same endpoint indices.

The formal theorem proves that a crossed row whose normal factor vanishes on
the closed fibre gives zero after evaluating the fixed projected row on every
realized source input. It does not construct the comparison with a quantum
connection. That construction is represented by `VerticalReaderGoal`, whose
witness contains the path compatibility and closed-reading equations displayed
below. Surjectivity needed for global packet vanishing is imposed by the
componentwise interface.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.FixedPhaseReader

universe uι uR uk uC₀ uC₁ uM₀ uM₁ uA

/-- An occurrence label, kept distinct from every other reader index even when
the underlying label carriers coincide. -/
structure OccurrenceTag (α : Type uι) where
  value : α

/-- A coefficient-specialization label. -/
structure CoeffParameterTag (α : Type uι) where
  value : α

/-- A chamber-groupoid path label. -/
structure ChamberPathTag (α : Type uι) where
  value : α

/-- A quantum or deck path label. -/
structure QdmPathTag (α : Type uι) where
  value : α

/-- A fixed-phase label. -/
structure PhaseTag (α : Type uι) where
  value : α

/-- A formal or deck-character label. -/
structure CharacterTag (α : Type uι) where
  value : α

/-- An oriented traversal label. -/
structure DirectionTag (α : Type uι) where
  value : α

/-- The independent labels determining one endpoint of a fixed-phase
comparison. The coefficient parameter and the two path notions have distinct
types, so a parameter specialization cannot be supplied as a path
identification. -/
structure ReaderIndex
    (Occurrence CoeffParameter ChamberPath QdmPath Phase Character Direction : Type uι) where
  occurrence : OccurrenceTag Occurrence
  coeffParameter : CoeffParameterTag CoeffParameter
  chamberPath : ChamberPathTag ChamberPath
  qdmPath : QdmPathTag QdmPath
  phase : PhaseTag Phase
  character : CharacterTag Character
  direction : DirectionTag Direction

/-- The orientation of the projected variation is an involutive unit. Over a
field of characteristic different from two this restricts it to a sign. -/
structure OrientationSign (k : Type uk) [CommRing k] where
  unit : kˣ
  involutive : (unit : k) * (unit : k) = 1

/-- The trusted interpretation of coefficient labels and chamber paths. The
coefficient trait and the QDM/deck path are separate functions. -/
structure ReaderEnvironment
    (R : Type uR) (k : Type uk) [CommRing R] [CommRing k]
    (Occurrence CoeffParameter ChamberPath QdmPath Direction : Type uι) where
  coefficientSpecialization : Occurrence → CoeffParameter → R →+* k
  chamberToQdmPath : Occurrence → ChamberPath → Direction → QdmPath

/-- Exact equations certifying that one indexed edge is read in the named
coefficient trait and along the named QDM/deck path. -/
structure ReaderCompatibility
    (R : Type uR) (k : Type uk) [CommRing R] [CommRing k]
    {Occurrence CoeffParameter ChamberPath QdmPath Phase Character Direction : Type uι}
    (environment : ReaderEnvironment R k Occurrence CoeffParameter ChamberPath QdmPath Direction)
    (specialize : R →+* k)
    (source target : ReaderIndex Occurrence CoeffParameter ChamberPath QdmPath Phase
      Character Direction) : Prop where
  sourceCoefficient :
    environment.coefficientSpecialization source.occurrence.value
      source.coeffParameter.value = specialize
  targetCoefficient :
    environment.coefficientSpecialization target.occurrence.value
      target.coeffParameter.value = specialize
  sourcePath :
    environment.chamberToQdmPath source.occurrence.value source.chamberPath.value
      source.direction.value = source.qdmPath.value
  targetPath :
    environment.chamberToQdmPath target.occurrence.value target.chamberPath.value
      target.direction.value = target.qdmPath.value
  phasePreserved : source.phase = target.phase
  characterPreserved : source.character = target.character
  directionPreserved : source.direction = target.direction

/-- An upper-triangular comparison together with its source and target rows.
The four carrier modules remain explicit because the common and moving
summands need not agree across a wall. -/
structure CrossedEdge
    (R : Type uR) [CommRing R]
    {Occurrence CoeffParameter ChamberPath QdmPath Phase Character Direction : Type uι}
    (source target : ReaderIndex Occurrence CoeffParameter ChamberPath QdmPath Phase
      Character Direction)
    (C₀ : Type uC₀) (C₁ : Type uC₁) (M₀ : Type uM₀) (M₁ : Type uM₁)
    [AddCommGroup C₀] [Module R C₀]
    [AddCommGroup C₁] [Module R C₁]
    [AddCommGroup M₀] [Module R M₀]
    [AddCommGroup M₁] [Module R M₁] where
  commonMap : C₀ →ₗ[R] C₁
  crossedMap : M₀ →ₗ[R] C₁
  movingMap : M₀ →ₗ[R] M₁
  sourceCommonRow : C₀ →ₗ[R] R
  targetCommonRow : C₁ →ₗ[R] R
  sourceMovingRow : M₀ →ₗ[R] R
  targetMovingRow : M₁ →ₗ[R] R
  normal : R
  commonRowInvariant : targetCommonRow.comp commonMap = sourceCommonRow
  crossedRowLaw :
    targetCommonRow.comp crossedMap + targetMovingRow.comp movingMap =
      (1 - normal) • sourceMovingRow

namespace CrossedEdge

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

/-- The full upper-triangular comparison represented by the common, crossed,
and moving blocks of an edge. -/
def fullMap
    (edge : CrossedEdge R source target C₀ C₁ M₀ M₁) :
    C₀ × M₀ →ₗ[R] C₁ × M₁ where
  toFun value :=
    (edge.commonMap value.1 + edge.crossedMap value.2,
      edge.movingMap value.2)
  map_add' left right := by
    ext <;> simp [add_assoc, add_left_comm, add_comm]
  map_smul' scalar value := by
    ext <;> simp

/-- The crossed and moving blocks on one moving source input, regarded as a
single map into the target common-plus-moving module. -/
def movingTargetMap
    (edge : CrossedEdge R source target C₀ C₁ M₀ M₁) :
    M₀ →ₗ[R] C₁ × M₁ where
  toFun value := (edge.crossedMap value, edge.movingMap value)
  map_add' left right := by ext <;> simp
  map_smul' scalar value := by ext <;> simp

/-- Injectivity of the full block comparison forces the crossed and moving
blocks to be jointly injective on a moving input. -/
theorem crossedMap_movingMap_jointly_injective_of_fullMap_injective
    (edge : CrossedEdge R source target C₀ C₁ M₀ M₁)
    (fullMapInjective : Function.Injective edge.fullMap) :
    ∀ x, edge.crossedMap x = 0 → edge.movingMap x = 0 → x = 0 := by
  intro x crossedVanishes movingVanishes
  have fullMapVanishes : edge.fullMap (0, x) = 0 := by
    ext <;> simp [fullMap, crossedVanishes, movingVanishes]
  have sourceVanishes : (0, x) = (0 : C₀ × M₀) :=
    fullMapInjective (by simpa only [map_zero] using fullMapVanishes)
  exact congrArg Prod.snd sourceVanishes

/-- The provenance-sensitive row defect on a moving source input. -/
def defect
    (edge : CrossedEdge R source target C₀ C₁ M₀ M₁) : M₀ →ₗ[R] R :=
  edge.sourceMovingRow -
    edge.targetMovingRow.comp edge.movingMap -
      edge.targetCommonRow.comp edge.crossedMap

/-- The crossed row law is equivalent to divisibility of the defect by the
normal parameter. -/
theorem defect_eq_normal_smul
    (edge : CrossedEdge R source target C₀ C₁ M₀ M₁) :
    edge.defect = edge.normal • edge.sourceMovingRow := by
  apply LinearMap.ext
  intro x
  have rowLaw := LinearMap.congr_fun edge.crossedRowLaw x
  simp only [defect, LinearMap.sub_apply, LinearMap.add_apply,
    LinearMap.comp_apply, LinearMap.smul_apply, smul_eq_mul] at rowLaw ⊢
  calc
    edge.sourceMovingRow x - edge.targetMovingRow (edge.movingMap x) -
        edge.targetCommonRow (edge.crossedMap x) =
      edge.sourceMovingRow x -
        (edge.targetCommonRow (edge.crossedMap x) +
          edge.targetMovingRow (edge.movingMap x)) := by ring
    _ = edge.sourceMovingRow x -
        (1 - edge.normal) * edge.sourceMovingRow x := by rw [rowLaw]
    _ = edge.normal * edge.sourceMovingRow x := by ring

end CrossedEdge

/-- A realization of a crossed source edge in an actual fixed-phase packet.
The path relation is supplied externally; the structure requires its witness
for these exact source and target indices. The closed-reading equation is the
geometric or analytic input. -/
structure PacketReader
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
    (ActualIncoming : Type uA)
    [AddCommGroup ActualIncoming] [Module k ActualIncoming]
    (actualProjectedRow : ActualIncoming →ₗ[k] k) where
  compatibility : ReaderCompatibility R k environment specialize source target
  sourceToActual : M₀ →ₛₗ[specialize] ActualIncoming
  orientation : OrientationSign k
  closedReading : ∀ x,
    actualProjectedRow (sourceToActual x) =
      (orientation.unit : k) * specialize (edge.defect x)

/-- The exact identification problem. A witness supplies an
occurrence-specific path certificate and the comparison with the actual
packet. -/
def VerticalReaderGoal
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
    (ActualIncoming : Type uA)
    [AddCommGroup ActualIncoming] [Module k ActualIncoming]
    (actualProjectedRow : ActualIncoming →ₗ[k] k) : Prop :=
  Nonempty (PacketReader R k specialize edge environment
    ActualIncoming actualProjectedRow)

/-- Once the vertical reader exists and the normal factor vanishes on the
closed fibre, the fixed directed projected row vanishes on the realized source
inputs. -/
theorem actualProjectedRow_eq_zero
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
    {ActualIncoming : Type uA}
    [AddCommGroup ActualIncoming] [Module k ActualIncoming]
    {actualProjectedRow : ActualIncoming →ₗ[k] k}
    (reader : PacketReader R k specialize edge environment
      ActualIncoming actualProjectedRow)
    (normalVanishes : specialize edge.normal = 0) :
    ∀ x, actualProjectedRow (reader.sourceToActual x) = 0 := by
  intro x
  rw [reader.closedReading]
  have defectFormula := LinearMap.congr_fun edge.defect_eq_normal_smul x
  rw [defectFormula, LinearMap.smul_apply, smul_eq_mul,
    map_mul, normalVanishes, zero_mul, mul_zero]

/-- A free typed path generated by local comparison steps. Endpoint matching
is enforced by the indices. -/
inductive TypedReaderPath {Index : Type uι} (Step : Index → Index → Type*) :
    Index → Index → Type _
  | refl (index : Index) : TypedReaderPath Step index index
  | cons {source middle target}
      (step : Step source middle)
      (tail : TypedReaderPath Step middle target) :
      TypedReaderPath Step source target

namespace TypedReaderPath

/-- Concatenation of typed reader paths. -/
def append {Index : Type uι} {Step : Index → Index → Type*}
    {source middle target : Index}
    (first : TypedReaderPath Step source middle)
    (second : TypedReaderPath Step middle target) :
    TypedReaderPath Step source target :=
  match first with
  | .refl _ => second
  | .cons step tail => .cons step (append tail second)

end TypedReaderPath

end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.FixedPhaseReader
