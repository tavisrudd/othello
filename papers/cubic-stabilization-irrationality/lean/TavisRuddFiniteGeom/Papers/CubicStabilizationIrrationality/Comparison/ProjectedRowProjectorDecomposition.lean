import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.RowedProjectorDecomposition

/-!
# Projector-restricted row comparison

A direct-sum comparison need not preserve a scalar row on the whole module.
For transport of row-visible marked support, it is enough that the rows agree
after applying the marked projectors.  The correction row may therefore be
nonzero on unmarked correction factors.

The terminal theorem proves that this restricted row square, the full
projector square, and a unit normalization preserve marked detection in both
directions.  The declarations are linear algebra; constructing the restricted
row square for a geometric quantum-module comparison is an external input.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.ProjectedRowProjectorDecomposition

open TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.RowedProjectorDecomposition

variable
    (R A V W C : Type*)
    [CommRing R]
    [AddCommGroup A] [Module R A]
    [AddCommGroup V] [Module R V]
    [AddCommGroup W] [Module R W]
    [AddCommGroup C] [Module R C]

/--
A direct-sum comparison whose row square is imposed only on the marked
projector images.  No row condition is imposed on the complementary
correction factors.
-/
structure Data where
  sourceProjector : Projector R V
  ambientProjector : Projector R W
  correctionProjector : Projector R C
  comparison : V ≃ₗ[R] W × C
  sourceRow : V →ₗ[R] A
  ambientRow : W →ₗ[R] A
  rowScale : Rˣ
  projectedRowComparison : ∀ x,
    sourceRow (sourceProjector.map x) =
      (rowScale : R) •
        ambientRow (ambientProjector.map (comparison x).1)
  projectorComparison : ∀ x,
    comparison (sourceProjector.map x) =
      (ambientProjector.map (comparison x).1,
        correctionProjector.map (comparison x).2)

namespace Data

variable {R A V W C}

/-- A full unit-scaled row comparison supplies the projector-restricted one. -/
def ofUnitScaled
    (data : RowedProjectorDecomposition.UnitScaledData R A V W C) :
    Data R A V W C where
  sourceProjector := data.sourceProjector
  ambientProjector := data.ambientProjector
  correctionProjector := data.correctionProjector
  comparison := data.comparison
  sourceRow := data.sourceRow
  ambientRow := data.ambientRow
  rowScale := data.rowScale
  projectedRowComparison := by
    intro x
    rw [data.rowComparison]
    have naturality := data.projectorComparison x
    simpa using congrArg
      (fun y => (data.rowScale : R) • data.ambientRow y.1) naturality
  projectorComparison := data.projectorComparison

/--
The projector-restricted row square and the projector square preserve
row-visible marked support in both directions.
-/
theorem detects_iff
    (data : Data R A V W C) :
    Detects R A data.sourceRow data.sourceProjector ↔
      Detects R A data.ambientRow data.ambientProjector := by
  constructor
  · rintro ⟨x, fixed, rowNonzero⟩
    refine ⟨(data.comparison x).1, ?_, ?_⟩
    · have naturality := data.projectorComparison x
      rw [fixed] at naturality
      exact (congrArg Prod.fst naturality).symm
    · intro ambientVanishes
      apply rowNonzero
      have comparisonRow := data.projectedRowComparison x
      rw [fixed] at comparisonRow
      have naturality := data.projectorComparison x
      rw [fixed] at naturality
      have ambientFixed :
          data.ambientProjector.map (data.comparison x).1 =
            (data.comparison x).1 := by
        simpa using (congrArg Prod.fst naturality).symm
      rw [ambientFixed, ambientVanishes] at comparisonRow
      simpa using comparisonRow
  · rintro ⟨x, fixed, rowNonzero⟩
    let sourceVector : V := data.comparison.symm (x, 0)
    have sourceFixed : data.sourceProjector.map sourceVector = sourceVector := by
      apply data.comparison.injective
      rw [data.projectorComparison]
      simp [sourceVector, fixed]
    refine ⟨sourceVector, sourceFixed, ?_⟩
    have scaledNonzero :
        (data.rowScale : R) • data.ambientRow x ≠ 0 := by
      intro scaledVanishes
      apply rowNonzero
      have unscaledVanishes := congrArg
        (fun y : A => (↑data.rowScale⁻¹ : R) • y) scaledVanishes
      simpa [smul_smul] using unscaledVanishes
    intro sourceVanishes
    apply scaledNonzero
    have comparisonRow := data.projectedRowComparison sourceVector
    rw [sourceFixed, sourceVanishes] at comparisonRow
    simpa [sourceVector, fixed] using comparisonRow.symm

/--
A marked source vector carried entirely by the correction coordinate has zero
source row under a projector-restricted row comparison.
-/
theorem sourceRow_eq_zero_of_marked_vector_with_zeroAmbientComponent
    (data : Data R A V W C) {x : V}
    (fixed : data.sourceProjector.map x = x)
    (ambientComponentZero : (data.comparison x).1 = 0) :
    data.sourceRow x = 0 := by
  have comparisonRow := data.projectedRowComparison x
  rw [fixed, ambientComponentZero] at comparisonRow
  simpa using comparisonRow

/--
A row-visible marked vector carried entirely by the correction coordinate
rules out a projector-restricted row comparison.
-/
theorem false_of_visible_marked_vector_with_zeroAmbientComponent
    (data : Data R A V W C) {x : V}
    (fixed : data.sourceProjector.map x = x)
    (ambientComponentZero : (data.comparison x).1 = 0)
    (rowNonzero : data.sourceRow x ≠ 0) : False := by
  apply rowNonzero
  exact data.sourceRow_eq_zero_of_marked_vector_with_zeroAmbientComponent
    fixed ambientComponentZero

/--
A detected source is incompatible with a zero ambient marked projector under
the projector-restricted row comparison.
-/
theorem false_of_source_detects_of_ambient_zero
    (data : Data R A V W C)
    (sourceDetects : Detects R A data.sourceRow data.sourceProjector)
    (ambientProjectorZero : data.ambientProjector = Projector.zero) : False := by
  have ambientDetects := data.detects_iff.mp sourceDetects
  rw [ambientProjectorZero] at ambientDetects
  exact not_detects_zero R A data.ambientRow ambientDetects

end Data

end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.ProjectedRowProjectorDecomposition
