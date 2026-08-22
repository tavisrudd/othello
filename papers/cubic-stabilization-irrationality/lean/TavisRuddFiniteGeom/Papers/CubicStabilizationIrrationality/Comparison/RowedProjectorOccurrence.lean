import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.RowedProjectorPath

/-!
# Occurrence equivalences for rowed marked projectors

This module isolates two algebraic constructions needed to compare repeated
occurrences of a quantum module.  An `OccurrenceEquivalence` identifies two
rowed marked-projector data by one linear equivalence, one unit-scaled row
equation, and one projector equation.  A `CommonSourceEdgePresentation`
constructs a rowed direct-sum edge from two presentations of the same source.

The terminal theorems derive detection invariance and the exact edge record
from these data.  They do not construct the geometric occurrence maps,
coefficient extensions, quantum modules, rows, or marked projectors.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.RowedProjectorOccurrence

open RowedProjectorDecomposition RowedProjectorPath

universe uR uA uVertex uCarrier uSource

/-- An equivalence between two occurrences of one rowed marked-projector
datum.  Both compatibility equations refer to the same linear equivalence. -/
structure OccurrenceEquivalence
    {R : Type uR} [CommRing R]
    {A : Type uA} [AddCommGroup A] [Module R A]
    (source target : VertexDatum.{uR, uA, uCarrier} R A) where
  map : source.Carrier ≃ₗ[R] target.Carrier
  rowScale : Rˣ
  rowComparison : ∀ x,
    source.row x = (rowScale : R) • target.row (map x)
  projectorComparison : ∀ x,
    map (source.projector.map x) = target.projector.map (map x)

namespace OccurrenceEquivalence

variable
    {R : Type uR} [CommRing R]
    {A : Type uA} [AddCommGroup A] [Module R A]
    {source target : VertexDatum.{uR, uA, uCarrier} R A}

/-- The row and projector equations for an occurrence equivalence may be
checked on a basis of the source carrier. -/
def ofBasisSquares
    {Index : Type*}
    (basis : Module.Basis Index R source.Carrier)
    (map : source.Carrier ≃ₗ[R] target.Carrier)
    (rowScale : Rˣ)
    (rowOnBasis : ∀ index,
      source.row (basis index) =
        (rowScale : R) • target.row (map (basis index)))
    (projectorOnBasis : ∀ index,
      map (source.projector.map (basis index)) =
        target.projector.map (map (basis index))) :
    OccurrenceEquivalence source target where
  map := map
  rowScale := rowScale
  rowComparison := by
    have equality : source.row =
        (rowScale : R) • target.row.comp map.toLinearMap := by
      exact basis.ext fun index ↦ by simpa using rowOnBasis index
    exact LinearMap.congr_fun equality
  projectorComparison := by
    have equality : map.toLinearMap.comp source.projector.map =
        target.projector.map.comp map.toLinearMap := by
      exact basis.ext fun index ↦ by simpa using projectorOnBasis index
    exact LinearMap.congr_fun equality

/-- Equivalent occurrences have the same row-visible marked support. -/
theorem detects_iff
    (equivalence : OccurrenceEquivalence source target) :
    Detects R A source.row source.projector ↔
      Detects R A target.row target.projector := by
  constructor
  · rintro ⟨x, fixed, rowNonzero⟩
    refine ⟨equivalence.map x, ?_, ?_⟩
    · rw [← equivalence.projectorComparison, fixed]
    · intro targetVanishes
      apply rowNonzero
      rw [equivalence.rowComparison, targetVanishes]
      simp
  · rintro ⟨y, fixed, rowNonzero⟩
    let x := equivalence.map.symm y
    refine ⟨x, ?_, ?_⟩
    · apply equivalence.map.injective
      rw [equivalence.projectorComparison]
      simp [x, fixed]
    · have scaledNonzero :
          (equivalence.rowScale : R) • target.row y ≠ 0 := by
        intro scaledVanishes
        apply rowNonzero
        have unscaledVanishes := congrArg
          (fun value : A => (↑equivalence.rowScale⁻¹ : R) • value)
          scaledVanishes
        simpa [smul_smul] using unscaledVanishes
      intro sourceVanishes
      apply scaledNonzero
      have comparisonRow := equivalence.rowComparison x
      rw [sourceVanishes] at comparisonRow
      simpa [x] using comparisonRow.symm

end OccurrenceEquivalence

/-- Two presentations of one source which use the exact rows and projectors
of a fixed vertex family.  The resulting endpoint comparison is therefore the
same map for the row and projector equations. -/
structure CommonSourceEdgePresentation
    {R : Type uR} [CommRing R]
    {A : Type uA} [AddCommGroup A] [Module R A]
    {Vertex : Type uVertex}
    (system : Vertex → VertexDatum.{uR, uA, uCarrier} R A)
    (source target : Vertex)
    (S : Type uSource) [AddCommGroup S] [Module R S] where
  Correction : Type uCarrier
  [correctionAddCommGroup : AddCommGroup Correction]
  [correctionModule : Module R Correction]
  commonProjector : Projector R S
  correctionProjector : Projector R Correction
  sourcePresentation : S ≃ₗ[R] (system source).Carrier
  targetPresentation : S ≃ₗ[R] (system target).Carrier × Correction
  rowScale : Rˣ
  rowOnCommonSource : ∀ s,
    (system source).row (sourcePresentation s) =
      (rowScale : R) • (system target).row (targetPresentation s).1
  sourceProjectorNaturality : ∀ s,
    sourcePresentation (commonProjector.map s) =
      (system source).projector.map (sourcePresentation s)
  targetProjectorNaturality : ∀ s,
    targetPresentation (commonProjector.map s) =
      ((system target).projector.map (targetPresentation s).1,
        correctionProjector.map (targetPresentation s).2)

attribute [instance] CommonSourceEdgePresentation.correctionAddCommGroup
attribute [instance] CommonSourceEdgePresentation.correctionModule

namespace CommonSourceEdgePresentation

variable
    {R : Type uR} [CommRing R]
    {A : Type uA} [AddCommGroup A] [Module R A]
    {Vertex : Type uVertex}
    (system : Vertex → VertexDatum.{uR, uA, uCarrier} R A)
    {source target : Vertex}
    {S : Type uSource} [AddCommGroup S] [Module R S]

/-- Two exact common-source presentations construct one typed direct-sum
edge carrying both compatibility equations. -/
def toEdge
    (presentation : CommonSourceEdgePresentation system source target S) :
    Edge system source target where
  Correction := presentation.Correction
  correctionProjector := presentation.correctionProjector
  comparison := presentation.sourcePresentation.symm.trans
    presentation.targetPresentation
  rowScale := presentation.rowScale
  rowComparison := by
    intro x
    let s := presentation.sourcePresentation.symm x
    simpa [s] using presentation.rowOnCommonSource s
  projectorComparison := by
    intro x
    let s := presentation.sourcePresentation.symm x
    have sourceLift :
        presentation.sourcePresentation.symm
            ((system source).projector.map x) =
          presentation.commonProjector.map s := by
      apply presentation.sourcePresentation.injective
      simpa [s] using (presentation.sourceProjectorNaturality s).symm
    change presentation.targetPresentation
        (presentation.sourcePresentation.symm
          ((system source).projector.map x)) =
      ((system target).projector.map
          (presentation.targetPresentation
            (presentation.sourcePresentation.symm x)).1,
        presentation.correctionProjector.map
          (presentation.targetPresentation
            (presentation.sourcePresentation.symm x)).2)
    rw [sourceLift]
    simpa [s] using presentation.targetProjectorNaturality s

end CommonSourceEdgePresentation

end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.RowedProjectorOccurrence
