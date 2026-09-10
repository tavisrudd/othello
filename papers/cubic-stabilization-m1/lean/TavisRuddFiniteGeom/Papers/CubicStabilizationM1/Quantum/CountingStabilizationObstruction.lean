import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.CountingPrimaryEndpoints

/-!
# Stabilized birational obstructions for the seventeen counting labels

Geometric endpoints are realized by full primary-block multisets, including
actual normalized rank-two counting connections. The projective-line formula
identifies their stabilized ledgers with two copies of the endpoint ledger.
Projective four-space has a ledger of rank-one point factors. Low-dimensional
center realizations and weak factorization force equality of exact-primary
weights for birational fourfolds. The computed nine nonzero endpoint weights
therefore obstruct stabilized rationality. Rationality of the eight controls
is a separate geometric input, not inferred from a zero invariant.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum

/-- Explicit geometric realization inputs for the finite counting-family
obstruction: block identifications, operation ledgers and weak factorization. -/
structure CountingStabilizationData (Variety Center Occurrence : Type*) where
  presentation : ExactPrimaryPresentation ℚ
  occurrences : OccurrenceIndexedLedger Variety Center Occurrence presentation.toBlockPresentation
  lowDimensionalRealizations : ∀ occurrence,
    occurrences.smoothCenter (occurrences.occurrenceSource occurrence) →
    occurrences.centerDimension (occurrences.occurrenceSource occurrence) ≤ 2 →
    ∃ model : LowDimensionalPrimaryModel ℚ,
      occurrences.occurrenceLedger occurrence=model.blocks.map presentation.toBlockPresentation.component
  birational : Setoid Variety
  factorization : BirationalFactorizationProvider occurrences presentation.fold 4 birational
  rankTwoEndpoints : ∀ label, RankTwoCountingEndpoint label
  endpoint : CountingMatrixLabel → Variety
  endpointRealization : ∀ label, occurrences.varietyLedger (endpoint label)=
    (countingEndpointBlocks rankTwoEndpoints label).map presentation.toBlockPresentation.component
  stabilized : CountingMatrixLabel → Variety
  stabilizedSmooth : ∀ label, occurrences.smoothProjective (stabilized label)
  stabilizedDimension : ∀ label, occurrences.dimension (stabilized label)=4
  projectiveLineFormula : ∀ label, occurrences.varietyLedger (stabilized label)=
    occurrences.varietyLedger (endpoint label)+occurrences.varietyLedger (endpoint label)
  projectiveFourSpace : Variety
  projectiveFourSmooth : occurrences.smoothProjective projectiveFourSpace
  projectiveFourDimension : occurrences.dimension projectiveFourSpace=4
  projectiveFourRealization : occurrences.varietyLedger projectiveFourSpace=
    ({pointPrimaryBlock,pointPrimaryBlock,pointPrimaryBlock,pointPrimaryBlock,pointPrimaryBlock} :
      Multiset (ExactPrimaryBlock ℚ)).map presentation.toBlockPresentation.component

/-- Stabilization doubles the exact signature derived from the actual full
endpoint block expression. -/
theorem CountingStabilizationData.stabilized_marker
    {Variety Center Occurrence : Type*} (data : CountingStabilizationData Variety Center Occurrence)
    (label : CountingMatrixLabel) :
    data.occurrences.varietyMarker data.presentation.fold (data.stabilized label)=
      2 • countingExactSignature label := by
  change data.presentation.fold (data.occurrences.varietyLedger (data.stabilized label))=_
  rw [data.projectiveLineFormula, map_add, data.endpointRealization,
    data.presentation.fold_blockMultiset, countingEndpointBlocks_weight, two_nsmul]

/-- The projective-four-space block realization has zero exact-primary weight. -/
theorem CountingStabilizationData.projectiveFour_marker_zero
    {Variety Center Occurrence : Type*} (data : CountingStabilizationData Variety Center Occurrence) :
    data.occurrences.varietyMarker data.presentation.fold data.projectiveFourSpace=0 := by
  change data.presentation.fold (data.occurrences.varietyLedger data.projectiveFourSpace)=0
  rw [data.projectiveFourRealization, data.presentation.fold_blockMultiset]
  simp [primaryBlockMultisetWeight, pointPrimaryBlock, ExactPrimaryBlock.weight]

/-- Each of the nine detected endpoints remains nonrational after one
projective-line stabilization: it is not birational to projective four-space. -/
theorem CountingStabilizationData.detected_not_stabilized_birational
    {Variety Center Occurrence : Type*} (data : CountingStabilizationData Variety Center Occurrence)
    (label : CountingMatrixLabel) (detected : label.detected=true) :
    ¬ data.birational.r (data.stabilized label) data.projectiveFourSpace := by
  intro related
  have equal := exactPrimary_marker_eq_of_birational data.presentation data.occurrences
    data.lowDimensionalRealizations 4 (Or.inr rfl) data.birational data.factorization
    (data.stabilizedSmooth label) data.projectiveFourSmooth
    (data.stabilizedDimension label) data.projectiveFourDimension related
  rw [data.stabilized_marker, data.projectiveFour_marker_zero] at equal
  exact (countingExactSignature_double_ne_zero_iff label).mpr detected equal

/-- Once rationality of the eight zero controls and the geometric implication
from rationality to stabilized birationality are supplied, the seventeen
family labels satisfy the claimed rational/nonrational dichotomy. -/
theorem CountingStabilizationData.rational_iff_control
    {Variety Center Occurrence : Type*} (data : CountingStabilizationData Variety Center Occurrence)
    (rational : CountingMatrixLabel → Prop)
    (rationalStabilizes : ∀ label, rational label →
      data.birational.r (data.stabilized label) data.projectiveFourSpace)
    (rationalControls : ∀ label, label.detected=false → rational label)
    (label : CountingMatrixLabel) : rational label ↔ label.detected=false := by
  constructor
  · intro h
    cases equation : label.detected with
    | false => rfl
    | true =>
      exact False.elim (data.detected_not_stabilized_birational label equation (rationalStabilizes label h))
  · exact rationalControls label

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum
