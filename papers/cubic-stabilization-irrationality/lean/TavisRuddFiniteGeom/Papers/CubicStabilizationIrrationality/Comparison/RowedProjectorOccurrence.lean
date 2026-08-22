import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.RowedProjectorPath

/-!
# Occurrence equivalences for rowed marked projectors

This module isolates three algebraic constructions needed to compare repeated
occurrences of a quantum module.  An `OccurrenceEquivalence` identifies two
rowed marked-projector data by one linear equivalence, one unit-scaled row
equation, and one projector equation.  A `CommonSourceEdgePresentation`
constructs a rowed direct-sum edge from two presentations of the same source.
A `FaithfulScalarEdge` fixes both endpoint rows and projectors definitionally
as scalar extensions of native data, leaving only the direct-sum comparison
and its two compatibility squares to be supplied.

The terminal theorems derive detection invariance and the exact edge record
from these data.  They do not construct the geometric occurrence maps,
coefficient extensions, quantum modules, rows, or marked projectors.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.RowedProjectorOccurrence

open RowedProjectorDecomposition RowedProjectorPath
open scoped TensorProduct

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

/-- A faithfully flat edge comparison between scalar extensions preserves the
intrinsic row-visible marked-support predicate over the native coefficient
ring.  The four equality hypotheses identify the local rows and projectors
with the scalar extensions used by the edge comparison. -/
theorem detects_iff_of_faithful_edge
    {R K : Type*} [CommRing R] [CommRing K]
    [Algebra R K] [Module.FaithfullyFlat R K]
    {A V W C : Type*}
    [AddCommGroup A] [Module R A]
    [AddCommGroup V] [Module R V]
    [AddCommGroup W] [Module R W]
    [AddCommGroup C] [Module K C]
    (sourceRow : V →ₗ[R] A) (targetRow : W →ₗ[R] A)
    (sourceProjector : Projector R V)
    (targetProjector : Projector R W)
    (edgeData : UnitScaledData K (K ⊗[R] A)
      (K ⊗[R] V) (K ⊗[R] W) C)
    (localSourceRow :
      edgeData.sourceRow = baseChangeRow R A sourceRow)
    (localTargetRow :
      edgeData.ambientRow = baseChangeRow R A targetRow)
    (localSourceProjector :
      edgeData.sourceProjector = sourceProjector.baseChange)
    (localTargetProjector :
      edgeData.ambientProjector = targetProjector.baseChange) :
    Detects R A sourceRow sourceProjector ↔
      Detects R A targetRow targetProjector := by
  calc
    Detects R A sourceRow sourceProjector ↔
        Detects K (K ⊗[R] A) (baseChangeRow R A sourceRow)
          sourceProjector.baseChange :=
      (detects_baseChange_iff R A sourceRow sourceProjector).symm
    _ ↔ Detects K (K ⊗[R] A) edgeData.sourceRow
          edgeData.sourceProjector := by
      rw [localSourceRow, localSourceProjector]
    _ ↔ Detects K (K ⊗[R] A) edgeData.ambientRow
          edgeData.ambientProjector := edgeData.detects_iff
    _ ↔ Detects K (K ⊗[R] A) (baseChangeRow R A targetRow)
          targetProjector.baseChange := by
      rw [localTargetRow, localTargetProjector]
    _ ↔ Detects R A targetRow targetProjector :=
      detects_baseChange_iff R A targetRow targetProjector

/-- A direct-sum edge over a faithfully flat scalar extension of two fixed
native endpoint data.  The endpoint rows and projectors are not fields: they
are definitionally the scalar extensions of the supplied native data.  Thus a
value of this type can vary only the correction factor, comparison, unit row
scale, and the two compatibility squares. -/
structure FaithfulScalarEdge
    {R : Type uR} [CommRing R]
    {A : Type uA} [AddCommGroup A] [Module R A]
    {Vertex : Type uVertex}
    (system : Vertex → VertexDatum.{uR, uA, uCarrier} R A)
    (source target : Vertex)
    (K : Type*) [CommRing K] [Algebra R K]
    [Module.FaithfullyFlat R K] where
  Correction : Type uCarrier
  [correctionAddCommGroup : AddCommGroup Correction]
  [correctionModule : Module K Correction]
  correctionProjector : Projector K Correction
  comparison : (K ⊗[R] (system source).Carrier) ≃ₗ[K]
    (K ⊗[R] (system target).Carrier) × Correction
  rowScale : Kˣ
  rowComparison : ∀ x,
    baseChangeRow R A (system source).row x =
      (rowScale : K) •
        baseChangeRow R A (system target).row (comparison x).1
  projectorComparison : ∀ x,
    comparison ((system source).projector.baseChange.map x) =
      ((system target).projector.baseChange.map (comparison x).1,
        correctionProjector.map (comparison x).2)

attribute [instance] FaithfulScalarEdge.correctionAddCommGroup
attribute [instance] FaithfulScalarEdge.correctionModule

namespace FaithfulScalarEdge

variable
    {R : Type uR} [CommRing R]
    {A : Type uA} [AddCommGroup A] [Module R A]
    {Vertex : Type uVertex}
    (system : Vertex → VertexDatum.{uR, uA, uCarrier} R A)
    {source target : Vertex}
    {K : Type*} [CommRing K] [Algebra R K]
    [Module.FaithfullyFlat R K]

/-- Forgetting the native endpoint indices gives the scalar-extended one-edge
consumer datum. -/
noncomputable def toUnitScaledData
    (edge : FaithfulScalarEdge system source target K) :
    UnitScaledData K (K ⊗[R] A)
      (K ⊗[R] (system source).Carrier)
      (K ⊗[R] (system target).Carrier) edge.Correction where
  sourceProjector := (system source).projector.baseChange
  ambientProjector := (system target).projector.baseChange
  correctionProjector := edge.correctionProjector
  comparison := edge.comparison
  sourceRow := baseChangeRow R A (system source).row
  ambientRow := baseChangeRow R A (system target).row
  rowScale := edge.rowScale
  rowComparison := edge.rowComparison
  projectorComparison := edge.projectorComparison

/-- A faithfully flat scalar edge preserves the intrinsic detection predicate
of its native endpoints. -/
theorem detectsAt_iff
    (edge : FaithfulScalarEdge system source target K) :
    DetectsAt system source ↔ DetectsAt system target := by
  exact detects_iff_of_faithful_edge
    (system source).row (system target).row
    (system source).projector (system target).projector
    (edge.toUnitScaledData system) rfl rfl rfl rfl

/-- A faithfully flat scalar edge supplies the proposition-valued edge used
by the intrinsic path telescope. -/
theorem toIntrinsicEdge
    (edge : FaithfulScalarEdge system source target K) :
    IntrinsicEdge (DetectsAt system) source target where
  property_iff := edge.detectsAt_iff system

/-- The two compatibility squares of a faithfully flat scalar edge may be
verified on a basis of its scalar-extended source. -/
noncomputable def ofBasisSquares
    {Index : Type*}
    (basis : Module.Basis Index K (K ⊗[R] (system source).Carrier))
    {Correction : Type uCarrier}
    [AddCommGroup Correction] [Module K Correction]
    (correctionProjector : Projector K Correction)
    (comparison : (K ⊗[R] (system source).Carrier) ≃ₗ[K]
      (K ⊗[R] (system target).Carrier) × Correction)
    (rowScale : Kˣ)
    (rowOnBasis : ∀ index,
      baseChangeRow R A (system source).row (basis index) =
        (rowScale : K) •
          baseChangeRow R A (system target).row (comparison (basis index)).1)
    (projectorOnBasis : ∀ index,
      comparison ((system source).projector.baseChange.map (basis index)) =
        ((system target).projector.baseChange.map
            (comparison (basis index)).1,
          correctionProjector.map (comparison (basis index)).2)) :
    FaithfulScalarEdge system source target K where
  Correction := Correction
  correctionProjector := correctionProjector
  comparison := comparison
  rowScale := rowScale
  rowComparison := by
    have equality : baseChangeRow R A (system source).row =
        (rowScale : K) •
          (baseChangeRow R A (system target).row).comp
            (LinearMap.fst K
              (K ⊗[R] (system target).Carrier) Correction |>.comp
                comparison.toLinearMap) := by
      exact basis.ext fun index ↦ by simpa using rowOnBasis index
    exact LinearMap.congr_fun equality
  projectorComparison := by
    have equality : comparison.toLinearMap.comp
          (system source).projector.baseChange.map =
        (LinearMap.prod
          ((system target).projector.baseChange.map.comp
            (LinearMap.fst K
              (K ⊗[R] (system target).Carrier) Correction))
          (correctionProjector.map.comp
            (LinearMap.snd K
              (K ⊗[R] (system target).Carrier) Correction))).comp
          comparison.toLinearMap := by
      exact basis.ext fun index ↦ by simpa using projectorOnBasis index
    exact LinearMap.congr_fun equality

/-- A basis row equation and one polynomial operator intertwining construct a
faithful scalar edge.  The polynomial presentations replace the separate
projector-square check. -/
noncomputable def ofBasisRowAndPolynomialProjector
    {Index : Type*}
    (basis : Module.Basis Index K (K ⊗[R] (system source).Carrier))
    {Correction : Type uCarrier}
    [AddCommGroup Correction] [Module K Correction]
    (correctionProjector : Projector K Correction)
    (comparison : (K ⊗[R] (system source).Carrier) ≃ₗ[K]
      (K ⊗[R] (system target).Carrier) × Correction)
    (rowScale : Kˣ)
    (rowOnBasis : ∀ index,
      baseChangeRow R A (system source).row (basis index) =
        (rowScale : K) •
          baseChangeRow R A (system target).row (comparison (basis index)).1)
    (sourceOperator : Module.End K
      (K ⊗[R] (system source).Carrier))
    (targetOperator : Module.End K
      ((K ⊗[R] (system target).Carrier) × Correction))
    (operatorComparison : ∀ x,
      comparison (sourceOperator x) = targetOperator (comparison x))
    (polynomial : Polynomial K)
    (sourcePolynomial : (system source).projector.baseChange.map =
      Polynomial.aeval sourceOperator polynomial)
    (targetPolynomial :
      (system target).projector.baseChange.map.prodMap
          correctionProjector.map =
        Polynomial.aeval targetOperator polynomial) :
    FaithfulScalarEdge system source target K := by
  refine ofBasisSquares system basis correctionProjector comparison rowScale
    rowOnBasis ?_
  intro index
  have naturality := intertwines_aeval K comparison.toLinearMap
    sourceOperator targetOperator operatorComparison polynomial (basis index)
  rw [← sourcePolynomial, ← targetPolynomial] at naturality
  simpa using naturality

end FaithfulScalarEdge

end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.RowedProjectorOccurrence
