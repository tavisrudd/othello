import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.FixedPhaseReader

/-!
# Componentwise fixed-phase readers

The one-equation packet reader is useful as a consumer but too compressed as
an identification interface. This module exposes the comparison squares, row
squares, source-surjectivity certificate, and the separate equation identifying
the pre-existing consumed row with the oriented component defect. The actual
source, common-output, and moving-output spaces remain different types.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.ComponentReader

open FixedPhaseReader

universe uι uR uk uC₀ uC₁ uM₀ uM₁ uS uC uM

/-- An occurrence-specific realization of the crossed edge after scalar
specialization. Each map and row is tied to the same indexed source edge. -/
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
    (ActualSource : Type uS) (ActualCommon : Type uC) (ActualMoving : Type uM)
    [AddCommGroup ActualSource] [Module k ActualSource]
    [AddCommGroup ActualCommon] [Module k ActualCommon]
    [AddCommGroup ActualMoving] [Module k ActualMoving]
    (consumedRow : ActualSource →ₗ[k] k) where
  compatibility : ReaderCompatibility R k environment specialize source target
  sourceRealization : M₀ →ₛₗ[specialize] ActualSource
  sourceRealization_surjective : Function.Surjective sourceRealization
  commonRealization : C₁ →ₛₗ[specialize] ActualCommon
  movingRealization : M₁ →ₛₗ[specialize] ActualMoving
  actualCrossedMap : ActualSource →ₗ[k] ActualCommon
  actualMovingMap : ActualSource →ₗ[k] ActualMoving
  actualSourceRow : ActualSource →ₗ[k] k
  actualCommonRow : ActualCommon →ₗ[k] k
  actualMovingRow : ActualMoving →ₗ[k] k
  orientation : OrientationSign k
  consumedRowEquation :
    consumedRow = (orientation.unit : k) •
      (actualSourceRow - actualMovingRow.comp actualMovingMap -
        actualCommonRow.comp actualCrossedMap)
  crossedMapCommutes : ∀ x,
    actualCrossedMap (sourceRealization x) =
      commonRealization (edge.crossedMap x)
  movingMapCommutes : ∀ x,
    actualMovingMap (sourceRealization x) =
      movingRealization (edge.movingMap x)
  sourceRowCommutes : ∀ x,
    actualSourceRow (sourceRealization x) =
      specialize (edge.sourceMovingRow x)
  commonRowCommutes : ∀ x,
    actualCommonRow (commonRealization x) =
      specialize (edge.targetCommonRow x)
  movingRowCommutes : ∀ x,
    actualMovingRow (movingRealization x) =
      specialize (edge.targetMovingRow x)

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
    {ActualSource : Type uS} {ActualCommon : Type uC} {ActualMoving : Type uM}
    [AddCommGroup ActualSource] [Module k ActualSource]
    [AddCommGroup ActualCommon] [Module k ActualCommon]
    [AddCommGroup ActualMoving] [Module k ActualMoving]
    {consumedRow : ActualSource →ₗ[k] k}

/-- The actual row defect computed from the three realized component rows. -/
def actualDefect
    (reader : Reader R k specialize edge environment
      ActualSource ActualCommon ActualMoving consumedRow) : ActualSource →ₗ[k] k :=
  reader.actualSourceRow -
    reader.actualMovingRow.comp reader.actualMovingMap -
      reader.actualCommonRow.comp reader.actualCrossedMap

/-- The component comparison and row squares imply the compressed
closed-reading equation before orientation. -/
theorem actualDefect_sourceRealization
    (reader : Reader R k specialize edge environment
      ActualSource ActualCommon ActualMoving consumedRow) (x : M₀) :
    reader.actualDefect (reader.sourceRealization x) =
      specialize (edge.defect x) := by
  change
    reader.actualSourceRow (reader.sourceRealization x) -
        reader.actualMovingRow (reader.actualMovingMap (reader.sourceRealization x)) -
      reader.actualCommonRow (reader.actualCrossedMap (reader.sourceRealization x)) = _
  rw [reader.sourceRowCommutes, reader.movingMapCommutes,
    reader.crossedMapCommutes, reader.movingRowCommutes,
    reader.commonRowCommutes]
  simp [CrossedEdge.defect]

/-- The component reader induces the compressed packet reader consumed by the
closed-fibre theorem. -/
def toPacketReader
    (reader : Reader R k specialize edge environment
      ActualSource ActualCommon ActualMoving consumedRow) :
    PacketReader R k specialize edge environment ActualSource consumedRow where
  compatibility := reader.compatibility
  sourceToActual := reader.sourceRealization
  orientation := reader.orientation
  closedReading := by
    intro x
    calc
      consumedRow (reader.sourceRealization x) =
          ((reader.orientation.unit : k) • reader.actualDefect)
            (reader.sourceRealization x) :=
        LinearMap.congr_fun reader.consumedRowEquation (reader.sourceRealization x)
      _ = (reader.orientation.unit : k) * specialize (edge.defect x) := by
        rw [LinearMap.smul_apply, smul_eq_mul,
          reader.actualDefect_sourceRealization]

/-- The componentwise identification and a vanishing normal imply vanishing
of the actual directed projected row. -/
theorem actualProjectedRow_eq_zero
    (reader : Reader R k specialize edge environment
      ActualSource ActualCommon ActualMoving consumedRow)
    (normalVanishes : specialize edge.normal = 0) :
    ∀ x, consumedRow (reader.toPacketReader.sourceToActual x) = 0 :=
  FixedPhaseReader.actualProjectedRow_eq_zero reader.toPacketReader normalVanishes

/-- Surjectivity of the source realization upgrades generatorwise vanishing
to vanishing on the entire actual incoming packet. -/
theorem actualProjectedRow_eq_zero_on_actualSource
    (reader : Reader R k specialize edge environment
      ActualSource ActualCommon ActualMoving consumedRow)
    (normalVanishes : specialize edge.normal = 0) :
    consumedRow = 0 := by
  apply LinearMap.ext
  intro y
  obtain ⟨x, rfl⟩ := reader.sourceRealization_surjective y
  exact reader.actualProjectedRow_eq_zero normalVanishes x

end Reader

/-- The componentwise form of the vertical identification problem. -/
def ComponentReaderGoal
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
    (ActualSource : Type uS) (ActualCommon : Type uC) (ActualMoving : Type uM)
    [AddCommGroup ActualSource] [Module k ActualSource]
    [AddCommGroup ActualCommon] [Module k ActualCommon]
    [AddCommGroup ActualMoving] [Module k ActualMoving]
    (consumedRow : ActualSource →ₗ[k] k) : Prop :=
  Nonempty (Reader R k specialize edge environment
    ActualSource ActualCommon ActualMoving consumedRow)

end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.ComponentReader
