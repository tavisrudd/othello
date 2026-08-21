import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.MarkedWitnessObstruction
import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.ParallelPrimaryQuotients

/-!
# One global marked source with two endpoint maps

This module types the Stokes-free global-cobordism route.  One marked source
maps to a detected endpoint and to an endpoint with no marked selected-primary
support.  Only the detected-endpoint map must lift its selected primary
vectors; the empty-endpoint map is the one-sided comparison from
`MarkedWitnessObstruction` and needs no surjectivity.

The structure is a conditional consumer.  It does not construct an AKMW
cobordism, a Gu--Yu--Yu Fourier map, a common coefficient field, a selected
deck/shift action, or a rank-row identity.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.GlobalCommonSourceObstruction

open MarkedLocalSystem
open PrimaryDetectionBaseChange
open RowedRepresentationDecomposition
open RowedRepresentationDecomposition.Data
open TensorProduct

universe uR uK uEmptyK uLoop uCore uCommon uDetected uEmpty

/-- A primary-covering realization of one endpoint from a common marked
source.  The unit row scale is used only to reflect row nonvanishing from the
detected endpoint back to the common source. -/
structure DetectedEndpointLift
    (K : Type uK) [CommRing K]
    (Loop : Type uLoop) [Group Loop]
    (Common : Type uCommon) [AddCommGroup Common] [Module K Common]
    (Detected : Type uDetected) [AddCommGroup Detected] [Module K Detected]
    (common : MarkedLocalSystem.Representation K Loop Common)
    (detected : MarkedLocalSystem.Representation K Loop Detected)
    (selectedLoop : Loop) (selectedEigenvalue : K)
    (selectedExponent : ℕ) where
  comparison : Common →ₗ[K] Detected
  rowScale : Kˣ
  rowComparison : ∀ x,
    common.row x = (rowScale : K) * detected.row (comparison x)
  monodromyComparison : ∀ x,
    comparison (common.monodromy selectedLoop x) =
      detected.monodromy selectedLoop (comparison x)
  primaryLift : ∀ y,
    IsGeneralizedEigenvector (detected.monodromy selectedLoop)
        selectedEigenvalue selectedExponent y →
      ∃ x,
        IsGeneralizedEigenvector (common.monodromy selectedLoop)
            selectedEigenvalue selectedExponent x ∧
          comparison x = y

namespace DetectedEndpointLift

variable
    {K : Type uK} [CommRing K]
    {Loop : Type uLoop} [Group Loop]
    {Common : Type uCommon} [AddCommGroup Common] [Module K Common]
    {Detected : Type uDetected} [AddCommGroup Detected] [Module K Detected]
    {common : MarkedLocalSystem.Representation K Loop Common}
    {detected : MarkedLocalSystem.Representation K Loop Detected}
    {selectedLoop : Loop} {selectedEigenvalue : K}
    {selectedExponent : ℕ}

/-- A detected endpoint witness lifts to a detected witness in the common
marked source. -/
theorem common_detects_of_endpoint_detects
    (lift : DetectedEndpointLift K Loop Common Detected common detected
      selectedLoop selectedEigenvalue selectedExponent)
    (endpointDetects : DetectsGeneralizedEigenspace detected.row
      (detected.monodromy selectedLoop) selectedEigenvalue selectedExponent) :
    DetectsGeneralizedEigenspace common.row
      (common.monodromy selectedLoop) selectedEigenvalue selectedExponent := by
  obtain ⟨y, endpointPrimary, endpointRowNonzero⟩ := endpointDetects
  obtain ⟨x, commonPrimary, comparisonValue⟩ :=
    lift.primaryLift y endpointPrimary
  refine ⟨x, commonPrimary, ?_⟩
  rw [lift.rowComparison, comparisonValue]
  intro productVanishes
  apply endpointRowNonzero
  have inverseProductVanishes :=
    congrArg (fun value => ((lift.rowScale⁻¹ : Kˣ) : K) * value)
      productVanishes
  simpa [mul_assoc] using inverseProductVanishes

/-- Ordinary surjectivity constructs the primary-lift field at any exponent
where the source and endpoint shifted operators have the two Fitting
conditions used by `primaryLift_of_surjective_of_fitting`. -/
noncomputable def ofSurjectiveOfFitting
    (common : MarkedLocalSystem.Representation K Loop Common)
    (detected : MarkedLocalSystem.Representation K Loop Detected)
    (selectedLoop : Loop) (selectedEigenvalue : K) (selectedExponent : ℕ)
    (comparison : Common →ₗ[K] Detected)
    (rowScale : Kˣ)
    (rowComparison : ∀ x,
      common.row x = (rowScale : K) * detected.row (comparison x))
    (monodromyComparison : ∀ x,
      comparison (common.monodromy selectedLoop x) =
        detected.monodromy selectedLoop (comparison x))
    (comparisonSurjective : Function.Surjective comparison)
    (sourceSpans : Codisjoint
      (LinearMap.ker
        (shiftedOperator (common.monodromy selectedLoop)
          selectedEigenvalue ^ selectedExponent))
      (LinearMap.range
        (shiftedOperator (common.monodromy selectedLoop)
          selectedEigenvalue ^ selectedExponent)))
    (endpointSeparated : Disjoint
      (LinearMap.ker
        (shiftedOperator (detected.monodromy selectedLoop)
          selectedEigenvalue ^ selectedExponent))
      (LinearMap.range
        (shiftedOperator (detected.monodromy selectedLoop)
          selectedEigenvalue ^ selectedExponent))) :
    DetectedEndpointLift K Loop Common Detected common detected
      selectedLoop selectedEigenvalue selectedExponent where
  comparison := comparison
  rowScale := rowScale
  rowComparison := rowComparison
  monodromyComparison := monodromyComparison
  primaryLift := ParallelPrimaryQuotients.primaryLift_of_surjective_of_fitting
    (common.monodromy selectedLoop) (detected.monodromy selectedLoop)
    comparison selectedEigenvalue selectedExponent monodromyComparison
    comparisonSurjective sourceSpans endpointSeparated

end DetectedEndpointLift

/-- The exact global-source package: a primary-covering map to the endpoint
where detection is known, and only a one-sided marked map to the endpoint
where detection is absent. -/
structure Data
    (K : Type uK) [CommRing K]
    (Loop : Type uLoop) [Group Loop]
    (Common : Type uCommon) [AddCommGroup Common] [Module K Common]
    (Detected : Type uDetected) [AddCommGroup Detected] [Module K Detected]
    (Empty : Type uEmpty) [AddCommGroup Empty] [Module K Empty]
    (common : MarkedLocalSystem.Representation K Loop Common)
    (detected : MarkedLocalSystem.Representation K Loop Detected)
    (empty : MarkedLocalSystem.Representation K Loop Empty)
    (selectedLoop : Loop) (selectedEigenvalue : K)
    (selectedExponent : ℕ) where
  detectedLift : DetectedEndpointLift K Loop Common Detected common detected
    selectedLoop selectedEigenvalue selectedExponent
  emptyComparison : MarkedWitnessObstruction.Data K Loop Common Empty
    common empty selectedLoop

namespace Data

variable
    {K : Type uK} [CommRing K]
    {Loop : Type uLoop} [Group Loop]
    {Common : Type uCommon} [AddCommGroup Common] [Module K Common]
    {Detected : Type uDetected} [AddCommGroup Detected] [Module K Detected]
    {Empty : Type uEmpty} [AddCommGroup Empty] [Module K Empty]
    {common : MarkedLocalSystem.Representation K Loop Common}
    {detected : MarkedLocalSystem.Representation K Loop Detected}
    {empty : MarkedLocalSystem.Representation K Loop Empty}
    {selectedLoop : Loop} {selectedEigenvalue : K}
    {selectedExponent : ℕ}

/-- A detected source endpoint and a row-undetected target endpoint cannot be
realized by one global marked source with the two stated maps. -/
theorem false_of_detectedEndpoint_of_emptyEndpoint
    (data : Data K Loop Common Detected Empty common detected empty
      selectedLoop selectedEigenvalue selectedExponent)
    (detectedEndpointDetects : DetectsGeneralizedEigenspace detected.row
      (detected.monodromy selectedLoop) selectedEigenvalue selectedExponent)
    (emptyEndpointDoesNotDetect : ¬ DetectsGeneralizedEigenspace empty.row
      (empty.monodromy selectedLoop) selectedEigenvalue selectedExponent) :
    False := by
  have commonDetects := data.detectedLift.common_detects_of_endpoint_detects
    detectedEndpointDetects
  exact emptyEndpointDoesNotDetect
    (data.emptyComparison.endpoint_detects_of_source_detects
      selectedEigenvalue selectedExponent commonDetects)

end Data

/-- The coefficient-loose global-source package.  The detected endpoint and
the empty endpoint may live over unrelated faithfully flat scalar extensions
of one rational marked core. -/
structure ScalarData
    (R : Type uR) [CommRing R]
    (Loop : Type uLoop) [Group Loop]
    (Core : Type uCore) [AddCommGroup Core] [Module R Core]
    (core : MarkedLocalSystem.Representation R Loop Core)
    (selectedLoop : Loop) (selectedEigenvalue : R)
    (selectedExponent : ℕ) where
  detectedBranch : ParallelPrimaryQuotients.Branch.{uR, uK, uLoop, uCore,
    uDetected} core selectedLoop selectedEigenvalue selectedExponent
  KEmpty : Type uEmptyK
  [emptyCoefficientRing : CommRing KEmpty]
  [emptyScalarAlgebra : Algebra R KEmpty]
  [emptyScalarFaithfullyFlat : Module.FaithfullyFlat R KEmpty]
  Empty : Type uEmpty
  [emptyAddCommGroup : AddCommGroup Empty]
  [emptyModule : Module KEmpty Empty]
  emptyEndpoint : MarkedLocalSystem.Representation KEmpty Loop Empty
  emptyComparison : MarkedWitnessObstruction.Data KEmpty Loop
    (KEmpty ⊗[R] Core) Empty (baseChangeRepresentation core) emptyEndpoint
      selectedLoop

attribute [instance] ScalarData.emptyCoefficientRing
attribute [instance] ScalarData.emptyScalarAlgebra
attribute [instance] ScalarData.emptyScalarFaithfullyFlat
attribute [instance] ScalarData.emptyAddCommGroup
attribute [instance] ScalarData.emptyModule

namespace ScalarData

variable
    {R : Type uR} [CommRing R]
    {Loop : Type uLoop} [Group Loop]
    {Core : Type uCore} [AddCommGroup Core] [Module R Core]
    (core : MarkedLocalSystem.Representation R Loop Core)
    {selectedLoop : Loop} {selectedEigenvalue : R}
    {selectedExponent : ℕ}

/-- Endpoint detection over one branch field and endpoint non-detection over
another cannot both arise from one rational marked core. -/
theorem false_of_detectedEndpoint_of_emptyEndpoint
    (data : ScalarData R Loop Core core selectedLoop selectedEigenvalue
      selectedExponent)
    (detectedEndpointDetects : DetectsGeneralizedEigenspace
      data.detectedBranch.endpoint.row
      (data.detectedBranch.endpoint.monodromy selectedLoop)
      (algebraMap R data.detectedBranch.K selectedEigenvalue)
      selectedExponent)
    (emptyEndpointDoesNotDetect : ¬ DetectsGeneralizedEigenspace
      data.emptyEndpoint.row (data.emptyEndpoint.monodromy selectedLoop)
      (algebraMap R data.KEmpty selectedEigenvalue) selectedExponent) :
    False := by
  have coreDetects :=
    (data.detectedBranch.endpoint_detects_iff_core_detects core selectedLoop
      selectedEigenvalue selectedExponent).mp detectedEndpointDetects
  exact emptyEndpointDoesNotDetect
    (MarkedWitnessObstruction.endpoint_detects_of_core_detects core
      data.emptyEndpoint selectedLoop selectedEigenvalue selectedExponent
      data.emptyComparison coreDetects)

end ScalarData

end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.GlobalCommonSourceObstruction
