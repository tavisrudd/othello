import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.LowDimensionalPrimaryExpressions
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.OccurrenceIndexedMarker

/-!
# Exact-primary descent from geometric block realizations

Point, curve and surface block expressions have zero exact-primary weight by
proved seed calculations. A geometric realization identifies each actual
low-dimensional occurrence ledger with one such block expression. This gives
occurrence nullity and then birational invariance in dimensions three and
four through the supplied weak-factorization provider. The geometric block
realizations and operation comparisons remain explicit inputs; zero markers
and birational invariance are conclusions, not input fields.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum

/-- The low-dimensional block models entering center nullity. -/
inductive LowDimensionalPrimaryModel (K : Type*) [Field K] [CharZero K]
  | point
  | curve (seed : CurvePrimarySeed K)
  | surface (expression : SurfacePrimaryExpression K)

/-- The actual finite block multiset of a low-dimensional model. -/
def LowDimensionalPrimaryModel.blocks {K : Type*} [Field K] [CharZero K] :
    LowDimensionalPrimaryModel K → Multiset (ExactPrimaryBlock K)
  | .point => {pointPrimaryBlock}
  | .curve seed => seed.blocks
  | .surface expression => expression.blocks

/-- The model weight is zero by point, curve and surface computations. -/
theorem LowDimensionalPrimaryModel.weight_zero
    {K : Type*} [Field K] [CharZero K] (model : LowDimensionalPrimaryModel K) :
    primaryBlockMultisetWeight model.blocks=0 := by
  cases model with
  | point => simp [blocks, primaryBlockMultisetWeight, pointPrimaryBlock, ExactPrimaryBlock.weight]
  | curve seed => exact seed.weight_zero
  | surface expression => exact expression.weight_zero

/-- Realizing a block multiset as an effective ledger commutes with its fold. -/
theorem ExactPrimaryPresentation.fold_blockMultiset
    {K : Type*} [Field K] [CharZero K] (presentation : ExactPrimaryPresentation K)
    (blocks : Multiset (ExactPrimaryBlock K)) :
    presentation.fold (blocks.map presentation.toBlockPresentation.component)=
      primaryBlockMultisetWeight blocks := by
  let component : ExactPrimaryBlock K → presentation.toBlockPresentation.Component :=
    presentation.toBlockPresentation.component
  change presentation.fold (blocks.map component)=primaryBlockMultisetWeight blocks
  induction blocks using Multiset.induction_on with
  | empty => simp [primaryBlockMultisetWeight]
  | @cons block blocks ih =>
    rw [Multiset.map_cons, ← Multiset.singleton_add, map_add]
    rw [show presentation.fold {component block}=block.weight from presentation.fold_singleton block, ih]
    simp [primaryBlockMultisetWeight, add_comm]

/-- Actual ledger identifications with proved low-dimensional block models
imply occurrence nullity in every ambient dimension at most four. -/
theorem exactPrimary_lowDimensionalOccurrenceNullity
    {K Variety Center Occurrence : Type*} [Field K] [CharZero K]
    (presentation : ExactPrimaryPresentation K)
    (data : OccurrenceIndexedLedger Variety Center Occurrence presentation.toBlockPresentation)
    (realizations : ∀ occurrence,
      data.smoothCenter (data.occurrenceSource occurrence) →
      data.centerDimension (data.occurrenceSource occurrence) ≤ 2 →
      ∃ model : LowDimensionalPrimaryModel K,
        data.occurrenceLedger occurrence=model.blocks.map presentation.toBlockPresentation.component)
    (ambientDimension : ℕ) (atMostFour : ambientDimension ≤ 4) :
    LowDimensionalOccurrenceNullity data presentation.fold ambientDimension := by
  intro occurrence smooth dimension
  obtain ⟨model,realization⟩ := realizations occurrence smooth (by omega)
  change presentation.fold (data.occurrenceLedger occurrence)=0
  rw [realization, presentation.fold_blockMultiset]
  exact model.weight_zero

/-- Exact-primary markers are invariant along supplied projective weak
factorizations in ambient dimension three or four. Nullity is derived from
actual low-dimensional block realizations, with no seed-marker-zero premise. -/
theorem exactPrimary_marker_eq_of_birational
    {K Variety Center Occurrence : Type*} [Field K] [CharZero K]
    (presentation : ExactPrimaryPresentation K)
    (data : OccurrenceIndexedLedger Variety Center Occurrence presentation.toBlockPresentation)
    (realizations : ∀ occurrence,
      data.smoothCenter (data.occurrenceSource occurrence) →
      data.centerDimension (data.occurrenceSource occurrence) ≤ 2 →
      ∃ model : LowDimensionalPrimaryModel K,
        data.occurrenceLedger occurrence=model.blocks.map presentation.toBlockPresentation.component)
    (dimension : ℕ) (threeOrFour : dimension=3 ∨ dimension=4)
    (birational : Setoid Variety)
    (provider : BirationalFactorizationProvider data presentation.fold dimension birational)
    {left right : Variety}
    (leftSmooth : data.smoothProjective left) (rightSmooth : data.smoothProjective right)
    (leftDimension : data.dimension left=dimension) (rightDimension : data.dimension right=dimension)
    (related : birational.r left right) :
    data.varietyMarker presentation.fold left=data.varietyMarker presentation.fold right :=
  BirationalFactorizationProvider.marker_eq_of_related data presentation.fold dimension birational provider
    (exactPrimary_lowDimensionalOccurrenceNullity presentation data realizations dimension (by omega))
    leftSmooth rightSmooth leftDimension rightDimension related

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum
