import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.FixedPhaseReader

/-!
# Composition of crossed-edge defects

The crossed block is a provenance-sensitive Writer term. For two composable
upper-triangular comparisons, the composite defect is the first defect plus
the second defect precomposed with the first moving map. Consequently any
additive specialization killing both local defects also kills the composite.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.CrossedEdgeComposition

open FixedPhaseReader

universe uι uR uk uC₀ uC₁ uC₂ uM₀ uM₁ uM₂

variable
    {R : Type uR} [CommRing R]
    {Occurrence CoeffParameter ChamberPath QdmPath Phase Character Direction : Type uι}
    {index₀ index₁ index₂ :
      ReaderIndex Occurrence CoeffParameter ChamberPath QdmPath Phase Character Direction}
    {C₀ : Type uC₀} {C₁ : Type uC₁} {C₂ : Type uC₂}
    {M₀ : Type uM₀} {M₁ : Type uM₁} {M₂ : Type uM₂}
    [AddCommGroup C₀] [Module R C₀]
    [AddCommGroup C₁] [Module R C₁]
    [AddCommGroup C₂] [Module R C₂]
    [AddCommGroup M₀] [Module R M₀]
    [AddCommGroup M₁] [Module R M₁]
    [AddCommGroup M₂] [Module R M₂]

/-- The crossed block of the composite upper-triangular comparison. -/
def compositeCrossedMap
    (first : CrossedEdge R index₀ index₁ C₀ C₁ M₀ M₁)
    (second : CrossedEdge R index₁ index₂ C₁ C₂ M₁ M₂) : M₀ →ₗ[R] C₂ :=
  second.commonMap.comp first.crossedMap +
    second.crossedMap.comp first.movingMap

/-- The moving block of the composite comparison. -/
def compositeMovingMap
    (first : CrossedEdge R index₀ index₁ C₀ C₁ M₀ M₁)
    (second : CrossedEdge R index₁ index₂ C₁ C₂ M₁ M₂) : M₀ →ₗ[R] M₂ :=
  second.movingMap.comp first.movingMap

/-- The provenance-sensitive row defect of the composite blocks. -/
def compositeDefect
    (first : CrossedEdge R index₀ index₁ C₀ C₁ M₀ M₁)
    (second : CrossedEdge R index₁ index₂ C₁ C₂ M₁ M₂) : M₀ →ₗ[R] R :=
  first.sourceMovingRow -
    second.targetMovingRow.comp (compositeMovingMap first second) -
      second.targetCommonRow.comp (compositeCrossedMap first second)

/-- The crossed defects obey the upper-triangular Writer law. The two row
equalities are the typed shared-vertex reindexing certificates. -/
theorem compositeDefect_eq
    (first : CrossedEdge R index₀ index₁ C₀ C₁ M₀ M₁)
    (second : CrossedEdge R index₁ index₂ C₁ C₂ M₁ M₂)
    (commonRowsAgree : second.sourceCommonRow = first.targetCommonRow)
    (movingRowsAgree : second.sourceMovingRow = first.targetMovingRow) :
    compositeDefect first second =
      first.defect + second.defect.comp first.movingMap := by
  apply LinearMap.ext
  intro x
  have commonAt :
      second.targetCommonRow (second.commonMap (first.crossedMap x)) =
        first.targetCommonRow (first.crossedMap x) := by
    calc
      second.targetCommonRow (second.commonMap (first.crossedMap x)) =
          second.sourceCommonRow (first.crossedMap x) :=
        LinearMap.congr_fun second.commonRowInvariant (first.crossedMap x)
      _ = first.targetCommonRow (first.crossedMap x) :=
        LinearMap.congr_fun commonRowsAgree (first.crossedMap x)
  have movingAt :
      second.sourceMovingRow (first.movingMap x) =
        first.targetMovingRow (first.movingMap x) :=
    LinearMap.congr_fun movingRowsAgree (first.movingMap x)
  simp only [compositeDefect, compositeMovingMap, compositeCrossedMap,
    CrossedEdge.defect, LinearMap.sub_apply, LinearMap.add_apply,
    LinearMap.comp_apply, map_add]
  rw [commonAt, movingAt]
  ring

/-- A scalar specialization killing both local crossed defects also kills the
composite crossed defect. -/
theorem specialize_compositeDefect_eq_zero
    {k : Type uk} [CommRing k] (specialize : R →+* k)
    (first : CrossedEdge R index₀ index₁ C₀ C₁ M₀ M₁)
    (second : CrossedEdge R index₁ index₂ C₁ C₂ M₁ M₂)
    (commonRowsAgree : second.sourceCommonRow = first.targetCommonRow)
    (movingRowsAgree : second.sourceMovingRow = first.targetMovingRow)
    (firstVanishes : ∀ x, specialize (first.defect x) = 0)
    (secondVanishes : ∀ x, specialize (second.defect x) = 0) :
    ∀ x, specialize (compositeDefect first second x) = 0 := by
  intro x
  have writerLaw := LinearMap.congr_fun
    (compositeDefect_eq first second commonRowsAgree movingRowsAgree) x
  rw [writerLaw, LinearMap.add_apply, LinearMap.comp_apply, map_add,
    firstVanishes, secondVanishes, zero_add]

end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.CrossedEdgeComposition
