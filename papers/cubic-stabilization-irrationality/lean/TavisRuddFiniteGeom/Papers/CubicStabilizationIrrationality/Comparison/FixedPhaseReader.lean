import Mathlib

/-!
# Fixed-phase comparison readers

This module isolates the algebraic input needed to transport one directed
fixed-phase row across a wall comparison. The coefficient-specialization
parameter, chamber-groupoid path, quantum/deck path, phase, and occurrence are
independent indices. A reader can only be applied to the crossed edge carrying
the same endpoint indices.

The formal theorem proves that a crossed row whose normal factor vanishes on
the closed fibre gives a zero actual projected row. It does not construct the
comparison with a quantum connection. That construction is represented by
`VerticalReaderGoal`, whose witness contains the path compatibility and
closed-reading equations displayed below.
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

/-- The independent labels determining one endpoint of a fixed-phase
comparison. The coefficient parameter and the two path notions have distinct
types, so a parameter specialization cannot be supplied as a path
identification. -/
structure ReaderIndex
    (Occurrence CoeffParameter ChamberPath QdmPath Phase : Type uι) where
  occurrence : OccurrenceTag Occurrence
  coeffParameter : CoeffParameterTag CoeffParameter
  chamberPath : ChamberPathTag ChamberPath
  qdmPath : QdmPathTag QdmPath
  phase : PhaseTag Phase

/-- An upper-triangular comparison together with its source and target rows.
The four carrier modules remain explicit because the common and moving
summands need not agree across a wall. -/
structure CrossedEdge
    (R : Type uR) [CommRing R]
    {Occurrence CoeffParameter ChamberPath QdmPath Phase : Type uι}
    (source target : ReaderIndex Occurrence CoeffParameter ChamberPath QdmPath Phase)
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
    {Occurrence CoeffParameter ChamberPath QdmPath Phase : Type uι}
    {source target : ReaderIndex Occurrence CoeffParameter ChamberPath QdmPath Phase}
    {C₀ : Type uC₀} {C₁ : Type uC₁} {M₀ : Type uM₀} {M₁ : Type uM₁}
    [AddCommGroup C₀] [Module R C₀]
    [AddCommGroup C₁] [Module R C₁]
    [AddCommGroup M₀] [Module R M₀]
    [AddCommGroup M₁] [Module R M₁]

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
    {Occurrence CoeffParameter ChamberPath QdmPath Phase : Type uι}
    {source target : ReaderIndex Occurrence CoeffParameter ChamberPath QdmPath Phase}
    {C₀ : Type uC₀} {C₁ : Type uC₁} {M₀ : Type uM₀} {M₁ : Type uM₁}
    [AddCommGroup C₀] [Module R C₀]
    [AddCommGroup C₁] [Module R C₁]
    [AddCommGroup M₀] [Module R M₀]
    [AddCommGroup M₁] [Module R M₁]
    (edge : CrossedEdge R source target C₀ C₁ M₀ M₁)
    (PathCompatible :
      ReaderIndex Occurrence CoeffParameter ChamberPath QdmPath Phase →
      ReaderIndex Occurrence CoeffParameter ChamberPath QdmPath Phase → Prop)
    (ActualIncoming : Type uA)
    [AddCommGroup ActualIncoming] [Module k ActualIncoming] where
  pathCompatible : PathCompatible source target
  sourceToActual : M₀ →ₛₗ[specialize] ActualIncoming
  actualProjectedRow : ActualIncoming →ₗ[k] k
  orientation : kˣ
  closedReading : ∀ x,
    actualProjectedRow (sourceToActual x) =
      (orientation : k) * specialize (edge.defect x)

/-- The exact identification problem. A witness supplies an
occurrence-specific path certificate and the comparison with the actual
packet. -/
def VerticalReaderGoal
    (R : Type uR) (k : Type uk) [CommRing R] [CommRing k]
    (specialize : R →+* k)
    {Occurrence CoeffParameter ChamberPath QdmPath Phase : Type uι}
    {source target : ReaderIndex Occurrence CoeffParameter ChamberPath QdmPath Phase}
    {C₀ : Type uC₀} {C₁ : Type uC₁} {M₀ : Type uM₀} {M₁ : Type uM₁}
    [AddCommGroup C₀] [Module R C₀]
    [AddCommGroup C₁] [Module R C₁]
    [AddCommGroup M₀] [Module R M₀]
    [AddCommGroup M₁] [Module R M₁]
    (edge : CrossedEdge R source target C₀ C₁ M₀ M₁)
    (PathCompatible :
      ReaderIndex Occurrence CoeffParameter ChamberPath QdmPath Phase →
      ReaderIndex Occurrence CoeffParameter ChamberPath QdmPath Phase → Prop)
    (ActualIncoming : Type uA)
    [AddCommGroup ActualIncoming] [Module k ActualIncoming] : Prop :=
  Nonempty (PacketReader R k specialize edge PathCompatible ActualIncoming)

/-- Once the vertical reader exists and the normal factor vanishes on the
closed fibre, the actual directed projected row vanishes. -/
theorem actualProjectedRow_eq_zero
    {R : Type uR} {k : Type uk} [CommRing R] [CommRing k]
    {specialize : R →+* k}
    {Occurrence CoeffParameter ChamberPath QdmPath Phase : Type uι}
    {source target : ReaderIndex Occurrence CoeffParameter ChamberPath QdmPath Phase}
    {C₀ : Type uC₀} {C₁ : Type uC₁} {M₀ : Type uM₀} {M₁ : Type uM₁}
    [AddCommGroup C₀] [Module R C₀]
    [AddCommGroup C₁] [Module R C₁]
    [AddCommGroup M₀] [Module R M₀]
    [AddCommGroup M₁] [Module R M₁]
    {edge : CrossedEdge R source target C₀ C₁ M₀ M₁}
    {PathCompatible :
      ReaderIndex Occurrence CoeffParameter ChamberPath QdmPath Phase →
      ReaderIndex Occurrence CoeffParameter ChamberPath QdmPath Phase → Prop}
    {ActualIncoming : Type uA}
    [AddCommGroup ActualIncoming] [Module k ActualIncoming]
    (reader : PacketReader R k specialize edge PathCompatible ActualIncoming)
    (normalVanishes : specialize edge.normal = 0) :
    ∀ x, reader.actualProjectedRow (reader.sourceToActual x) = 0 := by
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
