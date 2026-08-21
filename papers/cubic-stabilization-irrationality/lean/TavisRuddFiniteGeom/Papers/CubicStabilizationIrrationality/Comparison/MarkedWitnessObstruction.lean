import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.PrimaryDetectionBaseChange

/-!
# One-sided marked-primary obstruction

A comparison to an endpoint with no marked selected-primary support does not
need surjectivity or primary coverage. A detected primary vector in the
source maps to a primary vector at the endpoint. A scalar row factorization
prevents that image from having zero endpoint row.

The first theorem is the same-ring row-factorized consumer. A second theorem
combines it with the existing faithfully flat base-change interface for a
common marked core.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.MarkedWitnessObstruction

open MarkedLocalSystem
open PrimaryDetectionBaseChange
open RowedRepresentationDecomposition
open RowedRepresentationDecomposition.Data
open TensorProduct

universe uR uK uLoop uSource uMiddle uEndpoint uCore

/-- A one-sided comparison of two marked representations over the same ring.
The scalar need not be a unit for the source-to-endpoint implication. -/
structure Data
    (K : Type uK) [CommRing K]
    (Loop : Type uLoop) [Group Loop]
    (Source : Type uSource) [AddCommGroup Source] [Module K Source]
    (Endpoint : Type uEndpoint) [AddCommGroup Endpoint] [Module K Endpoint]
    (source : MarkedLocalSystem.Representation K Loop Source)
    (endpoint : MarkedLocalSystem.Representation K Loop Endpoint)
    (selectedLoop : Loop) where
  comparison : Source →ₗ[K] Endpoint
  rowScale : K
  rowComparison : ∀ x,
    source.row x = rowScale * endpoint.row (comparison x)
  monodromyComparison : ∀ x,
    comparison (source.monodromy selectedLoop x) =
      endpoint.monodromy selectedLoop (comparison x)

namespace Data

variable
    {K : Type uK} [CommRing K]
    {Loop : Type uLoop} [Group Loop]
    {Source : Type uSource} [AddCommGroup Source] [Module K Source]
    {Endpoint : Type uEndpoint} [AddCommGroup Endpoint] [Module K Endpoint]
    {source : MarkedLocalSystem.Representation K Loop Source}
    {endpoint : MarkedLocalSystem.Representation K Loop Endpoint}
    {selectedLoop : Loop}

/-- Composable one-sided comparisons assemble downstream. The intermediate
marked representation and selected loop are shared by the type, while the
row factors multiply in traversal order. -/
def comp
    {Middle : Type uMiddle} [AddCommGroup Middle] [Module K Middle]
    {middle : MarkedLocalSystem.Representation K Loop Middle}
    (second : Data K Loop Middle Endpoint middle endpoint selectedLoop)
    (first : Data K Loop Source Middle source middle selectedLoop) :
    Data K Loop Source Endpoint source endpoint selectedLoop where
  comparison := second.comparison.comp first.comparison
  rowScale := first.rowScale * second.rowScale
  rowComparison := by
    intro x
    rw [first.rowComparison, second.rowComparison]
    simp only [LinearMap.coe_comp, Function.comp_apply]
    rw [mul_assoc]
  monodromyComparison := by
    intro x
    simp only [LinearMap.coe_comp, Function.comp_apply]
    rw [first.monodromyComparison, second.monodromyComparison]

/-- The selected comparison sends every generalized-primary vector to a
generalized-primary vector with the same eigenvalue and exponent. -/
theorem comparison_isGeneralizedEigenvector
    (data : Data K Loop Source Endpoint source endpoint selectedLoop)
    (eigenvalue : K) (exponent : ℕ) (x : Source)
    (primary : IsGeneralizedEigenvector
      (source.monodromy selectedLoop) eigenvalue exponent x) :
    IsGeneralizedEigenvector
      (endpoint.monodromy selectedLoop) eigenvalue exponent
      (data.comparison x) := by
  have shiftedNaturality : ∀ y,
      data.comparison
          (shiftedOperator (source.monodromy selectedLoop) eigenvalue y) =
        shiftedOperator (endpoint.monodromy selectedLoop) eigenvalue
          (data.comparison y) := by
    intro y
    change data.comparison
        (source.monodromy selectedLoop y - eigenvalue • y) =
      endpoint.monodromy selectedLoop (data.comparison y) -
        eigenvalue • data.comparison y
    rw [map_sub, data.monodromyComparison, map_smul]
  have powerNaturality : ∀ n y,
      data.comparison
          ((shiftedOperator (source.monodromy selectedLoop) eigenvalue ^ n) y) =
        (shiftedOperator (endpoint.monodromy selectedLoop) eigenvalue ^ n)
          (data.comparison y) := by
    intro n
    induction n with
    | zero => simp
    | succ n inductionHypothesis =>
        intro y
        rw [pow_succ, pow_succ, Module.End.mul_apply, Module.End.mul_apply]
        rw [inductionHypothesis, shiftedNaturality]
  unfold IsGeneralizedEigenvector at primary ⊢
  rw [← shiftedOperator_pow_apply] at primary ⊢
  rw [← powerNaturality]
  simp [primary]

/-- A same-ring one-sided marked comparison transports detected-primary
support from its source to its endpoint. -/
theorem endpoint_detects_of_source_detects
    (data : Data K Loop Source Endpoint source endpoint selectedLoop)
    (eigenvalue : K) (exponent : ℕ)
    (sourceDetects : DetectsGeneralizedEigenspace source.row
      (source.monodromy selectedLoop) eigenvalue exponent) :
    DetectsGeneralizedEigenspace endpoint.row
      (endpoint.monodromy selectedLoop) eigenvalue exponent := by
  obtain ⟨x, primary, rowNonzero⟩ := sourceDetects
  refine ⟨data.comparison x,
    comparison_isGeneralizedEigenvector data eigenvalue exponent x primary, ?_⟩
  intro endpointRowVanishes
  apply rowNonzero
  rw [data.rowComparison, endpointRowVanishes, mul_zero]

end Data

variable
    {R : Type uR} [CommRing R]
    {Loop : Type uLoop} [Group Loop]
    {Core : Type uCore} [AddCommGroup Core] [Module R Core]
    (core : MarkedLocalSystem.Representation R Loop Core)

/-- Faithfully flat base change supplies the detected local source consumed
by the same-ring row-factorized theorem. -/
theorem endpoint_detects_of_core_detects
    {K : Type uK} [CommRing K] [Algebra R K] [Module.FaithfullyFlat R K]
    {Endpoint : Type uEndpoint} [AddCommGroup Endpoint] [Module K Endpoint]
    (endpoint : MarkedLocalSystem.Representation K Loop Endpoint)
    (selectedLoop : Loop) (selectedEigenvalue : R) (exponent : ℕ)
    (data : Data K Loop (K ⊗[R] Core) Endpoint
      (baseChangeRepresentation core) endpoint selectedLoop)
    (coreDetects : DetectsGeneralizedEigenspace core.row
      (core.monodromy selectedLoop) selectedEigenvalue exponent) :
    DetectsGeneralizedEigenspace endpoint.row
      (endpoint.monodromy selectedLoop)
      (algebraMap R K selectedEigenvalue) exponent := by
  apply Data.endpoint_detects_of_source_detects data
  exact (detectsGeneralizedEigenspace_baseChange_iff
    core selectedLoop selectedEigenvalue exponent).2 coreDetects

/-- A detected marked core cannot admit a one-sided marked comparison to an
endpoint whose row has no selected generalized-primary support. -/
theorem false_of_core_detects_of_endpoint_not_detects
    {K : Type uK} [CommRing K] [Algebra R K] [Module.FaithfullyFlat R K]
    {Endpoint : Type uEndpoint} [AddCommGroup Endpoint] [Module K Endpoint]
    (endpoint : MarkedLocalSystem.Representation K Loop Endpoint)
    (selectedLoop : Loop) (selectedEigenvalue : R) (exponent : ℕ)
    (data : Data K Loop (K ⊗[R] Core) Endpoint
      (baseChangeRepresentation core) endpoint selectedLoop)
    (coreDetects : DetectsGeneralizedEigenspace core.row
      (core.monodromy selectedLoop) selectedEigenvalue exponent)
    (endpointDoesNotDetect : ¬ DetectsGeneralizedEigenspace endpoint.row
      (endpoint.monodromy selectedLoop)
      (algebraMap R K selectedEigenvalue) exponent) : False :=
  endpointDoesNotDetect
    (endpoint_detects_of_core_detects core endpoint selectedLoop
      selectedEigenvalue exponent data coreDetects)

end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.MarkedWitnessObstruction
