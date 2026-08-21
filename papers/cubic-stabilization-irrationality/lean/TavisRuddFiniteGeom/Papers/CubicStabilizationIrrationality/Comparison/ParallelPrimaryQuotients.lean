import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.PrimaryDetectionBaseChange
import Mathlib.RingTheory.Artinian.Module

/-!
# Parallel primary quotients of one marked representation

A chamber comparison need not identify the whole source with an ambient
factor plus corrections.  For a Boolean detected-primary invariant, it is
enough that the comparison cover the selected generalized-primary kernel,
intertwine the chosen based-loop action, and identify the marked rows up to a
unit.

This module combines that quotient argument with faithfully flat scalar
extension.  Two endpoint representations over unrelated coefficient rings
therefore have the same detected-primary Boolean when both are primary
quotients of scalar extensions of one marked representation.  The structure
records primary coverage explicitly; ordinary surjectivity alone need not
lift a vector in the kernel of a fixed power of a shifted operator through a
non-split extension.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.ParallelPrimaryQuotients

open MarkedLocalSystem
open PrimaryDetectionBaseChange
open RowedRepresentationDecomposition
open RowedRepresentationDecomposition.Data
open TensorProduct

universe uR uK uLoop uCore uEndpoint

variable
    {R : Type uR} [CommRing R]
    {Loop : Type uLoop} [Group Loop]
    {Core : Type uCore} [AddCommGroup Core] [Module R Core]
    (core : MarkedLocalSystem.Representation R Loop Core)

/-- A surjective intertwiner covers a selected generalized-primary kernel
when the corresponding source kernel and image span the source and the target
kernel and image are disjoint.  These are the two halves of the Fitting
decomposition actually used by the proof. -/
theorem primaryLift_of_surjective_of_fitting
    {K : Type uK} [CommRing K]
    {Source : Type uCore} [AddCommGroup Source] [Module K Source]
    {Endpoint : Type uEndpoint} [AddCommGroup Endpoint] [Module K Endpoint]
    (sourceMonodromy : Source ≃ₗ[K] Source)
    (endpointMonodromy : Endpoint ≃ₗ[K] Endpoint)
    (comparison : Source →ₗ[K] Endpoint)
    (eigenvalue : K) (exponent : ℕ)
    (naturality : ∀ x,
      comparison (sourceMonodromy x) = endpointMonodromy (comparison x))
    (comparisonSurjective : Function.Surjective comparison)
    (sourceSpans : Codisjoint
      (LinearMap.ker (shiftedOperator sourceMonodromy eigenvalue ^ exponent))
      (LinearMap.range (shiftedOperator sourceMonodromy eigenvalue ^ exponent)))
    (endpointSeparated : Disjoint
      (LinearMap.ker (shiftedOperator endpointMonodromy eigenvalue ^ exponent))
      (LinearMap.range (shiftedOperator endpointMonodromy eigenvalue ^ exponent))) :
    ∀ y,
      IsGeneralizedEigenvector endpointMonodromy eigenvalue exponent y →
        ∃ x,
          IsGeneralizedEigenvector sourceMonodromy eigenvalue exponent x ∧
            comparison x = y := by
  have shiftedNaturality : ∀ x,
      comparison (shiftedOperator sourceMonodromy eigenvalue x) =
        shiftedOperator endpointMonodromy eigenvalue (comparison x) := by
    intro x
    simp [shiftedOperator, naturality]
  have powerNaturality : ∀ n x,
      comparison ((shiftedOperator sourceMonodromy eigenvalue ^ n) x) =
        (shiftedOperator endpointMonodromy eigenvalue ^ n) (comparison x) := by
    intro n
    induction n with
    | zero => simp
    | succ n inductionHypothesis =>
        intro x
        rw [pow_succ, pow_succ, Module.End.mul_apply, Module.End.mul_apply]
        rw [inductionHypothesis, shiftedNaturality]
  intro y primary
  obtain ⟨x, comparisonValue⟩ := comparisonSurjective y
  obtain ⟨kernelPart, imagePart, kernelPartMem, imagePartMem, rfl⟩ :=
    Submodule.codisjoint_iff_exists_add_eq.mp sourceSpans x
  have endpointPrimary :
      y ∈ LinearMap.ker
        (shiftedOperator endpointMonodromy eigenvalue ^ exponent) := by
    change (shiftedOperator endpointMonodromy eigenvalue ^ exponent) y = 0
    rw [shiftedOperator_pow_apply]
    exact primary
  have kernelPartPrimary :
      comparison kernelPart ∈ LinearMap.ker
        (shiftedOperator endpointMonodromy eigenvalue ^ exponent) := by
    change
      (shiftedOperator endpointMonodromy eigenvalue ^ exponent)
        (comparison kernelPart) = 0
    rw [← powerNaturality]
    rw [kernelPartMem, map_zero]
  have imagePartRange :
      comparison imagePart ∈ LinearMap.range
        (shiftedOperator endpointMonodromy eigenvalue ^ exponent) := by
    obtain ⟨preimage, rfl⟩ := imagePartMem
    refine ⟨comparison preimage, ?_⟩
    exact (powerNaturality exponent preimage).symm
  have comparisonSum :
      comparison kernelPart + comparison imagePart = y := by
    simpa using comparisonValue
  have imagePartPrimary :
      comparison imagePart ∈ LinearMap.ker
        (shiftedOperator endpointMonodromy eigenvalue ^ exponent) := by
    rw [show comparison imagePart = y - comparison kernelPart by
      rw [← comparisonSum]
      abel]
    exact Submodule.sub_mem _ endpointPrimary kernelPartPrimary
  have imagePartVanishes : comparison imagePart = 0 :=
    Submodule.disjoint_def.mp endpointSeparated _ imagePartPrimary imagePartRange
  refine ⟨kernelPart, ?_, ?_⟩
  · unfold IsGeneralizedEigenvector
    rw [← shiftedOperator_pow_apply]
    exact kernelPartMem
  · simpa [imagePartVanishes] using comparisonSum

/-- For finite-dimensional vector spaces, a surjective intertwiner covers the
selected generalized-primary kernel at some common Fitting exponent. -/
theorem exists_exponent_primaryLift_of_surjective
    {K : Type uK} [Field K]
    {Source : Type uCore} [AddCommGroup Source] [Module K Source]
    [FiniteDimensional K Source]
    {Endpoint : Type uEndpoint} [AddCommGroup Endpoint] [Module K Endpoint]
    [FiniteDimensional K Endpoint]
    (sourceMonodromy : Source ≃ₗ[K] Source)
    (endpointMonodromy : Endpoint ≃ₗ[K] Endpoint)
    (comparison : Source →ₗ[K] Endpoint)
    (eigenvalue : K)
    (naturality : ∀ x,
      comparison (sourceMonodromy x) = endpointMonodromy (comparison x))
    (comparisonSurjective : Function.Surjective comparison) :
    ∃ exponent, ∀ y,
      IsGeneralizedEigenvector endpointMonodromy eigenvalue exponent y →
        ∃ x,
          IsGeneralizedEigenvector sourceMonodromy eigenvalue exponent x ∧
            comparison x = y := by
  let sourceShift := shiftedOperator sourceMonodromy eigenvalue
  let endpointShift := shiftedOperator endpointMonodromy eigenvalue
  have fitting := sourceShift.eventually_isCompl_ker_pow_range_pow.and
    endpointShift.eventually_isCompl_ker_pow_range_pow
  obtain ⟨exponent, sourceFitting, endpointFitting⟩ := fitting.exists
  exact ⟨exponent,
    primaryLift_of_surjective_of_fitting sourceMonodromy endpointMonodromy
      comparison eigenvalue exponent naturality comparisonSurjective
      sourceFitting.codisjoint endpointFitting.disjoint⟩

/-- One endpoint realization of a common marked representation at a selected
loop, eigenvalue, and nilpotence exponent.  The comparison is required to
cover that generalized-primary kernel rather than to split the whole endpoint
representation. -/
structure Branch
    (selectedLoop : Loop) (selectedEigenvalue : R) (selectedExponent : ℕ) where
  K : Type uK
  [coefficientRing : CommRing K]
  [scalarAlgebra : Algebra R K]
  [scalarFaithfullyFlat : Module.FaithfullyFlat R K]
  Endpoint : Type uEndpoint
  [endpointAddCommGroup : AddCommGroup Endpoint]
  [endpointModule : Module K Endpoint]
  endpoint : MarkedLocalSystem.Representation K Loop Endpoint
  comparison : (K ⊗[R] Core) →ₗ[K] Endpoint
  scale : Kˣ
  rowComparison : ∀ x,
    (baseChangeRepresentation core).row x =
      (scale : K) * endpoint.row (comparison x)
  monodromyComparison : ∀ x,
    comparison ((baseChangeRepresentation core).monodromy selectedLoop x) =
      endpoint.monodromy selectedLoop (comparison x)
  primaryLift : ∀ y,
    IsGeneralizedEigenvector (endpoint.monodromy selectedLoop)
        (algebraMap R K selectedEigenvalue) selectedExponent y →
      ∃ x,
        IsGeneralizedEigenvector
            ((baseChangeRepresentation core).monodromy selectedLoop)
            (algebraMap R K selectedEigenvalue) selectedExponent x ∧
          comparison x = y

attribute [instance] Branch.coefficientRing
attribute [instance] Branch.scalarAlgebra
attribute [instance] Branch.scalarFaithfullyFlat
attribute [instance] Branch.endpointAddCommGroup
attribute [instance] Branch.endpointModule

namespace Branch

/-- Construct a selected endpoint branch from ordinary surjectivity and the
two Fitting conditions used to lift the selected primary kernel. -/
noncomputable def ofSurjectiveOfFitting
    (selectedLoop : Loop) (selectedEigenvalue : R) (selectedExponent : ℕ)
    {K : Type uK} [CommRing K] [Algebra R K] [Module.FaithfullyFlat R K]
    {Endpoint : Type uEndpoint} [AddCommGroup Endpoint] [Module K Endpoint]
    (endpoint : MarkedLocalSystem.Representation K Loop Endpoint)
    (comparison : (K ⊗[R] Core) →ₗ[K] Endpoint)
    (scale : Kˣ)
    (rowComparison : ∀ x,
      (baseChangeRepresentation core).row x =
        (scale : K) * endpoint.row (comparison x))
    (monodromyComparison : ∀ x,
      comparison ((baseChangeRepresentation core).monodromy selectedLoop x) =
        endpoint.monodromy selectedLoop (comparison x))
    (comparisonSurjective : Function.Surjective comparison)
    (sourceSpans : Codisjoint
      (LinearMap.ker
        (shiftedOperator
          ((baseChangeRepresentation core).monodromy selectedLoop)
          (algebraMap R K selectedEigenvalue) ^ selectedExponent))
      (LinearMap.range
        (shiftedOperator
          ((baseChangeRepresentation core).monodromy selectedLoop)
          (algebraMap R K selectedEigenvalue) ^ selectedExponent)))
    (endpointSeparated : Disjoint
      (LinearMap.ker
        (shiftedOperator (endpoint.monodromy selectedLoop)
          (algebraMap R K selectedEigenvalue) ^ selectedExponent))
      (LinearMap.range
        (shiftedOperator (endpoint.monodromy selectedLoop)
          (algebraMap R K selectedEigenvalue) ^ selectedExponent))) :
    Branch core selectedLoop selectedEigenvalue selectedExponent where
  K := K
  Endpoint := Endpoint
  endpoint := endpoint
  comparison := comparison
  scale := scale
  rowComparison := rowComparison
  monodromyComparison := monodromyComparison
  primaryLift := primaryLift_of_surjective_of_fitting
    ((baseChangeRepresentation core).monodromy selectedLoop)
    (endpoint.monodromy selectedLoop) comparison
    (algebraMap R K selectedEigenvalue) selectedExponent
    monodromyComparison comparisonSurjective
    sourceSpans endpointSeparated

/-- The endpoint comparison carries generalized eigenvectors to generalized
eigenvectors for the same selected loop, eigenvalue, and exponent. -/
theorem comparison_isGeneralizedEigenvector
    (selectedLoop : Loop) (selectedEigenvalue : R) (selectedExponent : ℕ)
    (branch : Branch core selectedLoop selectedEigenvalue selectedExponent)
    (x : branch.K ⊗[R] Core)
    (primary : IsGeneralizedEigenvector
      ((baseChangeRepresentation core).monodromy selectedLoop)
      (algebraMap R branch.K selectedEigenvalue) selectedExponent x) :
    IsGeneralizedEigenvector (branch.endpoint.monodromy selectedLoop)
      (algebraMap R branch.K selectedEigenvalue) selectedExponent
      (branch.comparison x) := by
  have shiftedNaturality : ∀ y,
      branch.comparison
          (shiftedOperator
            ((baseChangeRepresentation core).monodromy selectedLoop)
            (algebraMap R branch.K selectedEigenvalue) y) =
        shiftedOperator (branch.endpoint.monodromy selectedLoop)
          (algebraMap R branch.K selectedEigenvalue) (branch.comparison y) := by
    intro y
    change branch.comparison
        ((baseChangeRepresentation core).monodromy selectedLoop y -
          algebraMap R branch.K selectedEigenvalue • y) =
      branch.endpoint.monodromy selectedLoop (branch.comparison y) -
        algebraMap R branch.K selectedEigenvalue • branch.comparison y
    rw [map_sub, branch.monodromyComparison, map_smul]
  have powerNaturality : ∀ n y,
      branch.comparison
          ((shiftedOperator
            ((baseChangeRepresentation core).monodromy selectedLoop)
            (algebraMap R branch.K selectedEigenvalue) ^ n) y) =
        (shiftedOperator (branch.endpoint.monodromy selectedLoop)
          (algebraMap R branch.K selectedEigenvalue) ^ n)
            (branch.comparison y) := by
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

/-- Unit-scaled row comparison and primary coverage identify the detected
generalized-primary Boolean of the local scalar extension with that of the
endpoint. -/
theorem endpoint_detects_iff_local_detects
    (loop : Loop) (eigenvalue : R) (exponent : ℕ)
    (branch : Branch core loop eigenvalue exponent) :
    DetectsGeneralizedEigenspace branch.endpoint.row
        (branch.endpoint.monodromy loop)
        (algebraMap R branch.K eigenvalue) exponent ↔
      DetectsGeneralizedEigenspace
        (baseChangeRepresentation core).row
        ((baseChangeRepresentation core).monodromy loop)
        (algebraMap R branch.K eigenvalue) exponent := by
  constructor
  · rintro ⟨y, primary, rowNonzero⟩
    obtain ⟨x, sourcePrimary, comparisonValue⟩ :=
      branch.primaryLift y primary
    refine ⟨x, sourcePrimary, ?_⟩
    rw [branch.rowComparison, comparisonValue]
    intro productVanishes
    apply rowNonzero
    have inverseProductVanishes :=
      congrArg (fun value => ((branch.scale⁻¹ : branch.Kˣ) : branch.K) * value)
        productVanishes
    simpa [mul_assoc] using inverseProductVanishes
  · rintro ⟨x, primary, rowNonzero⟩
    refine ⟨branch.comparison x,
      comparison_isGeneralizedEigenvector core loop eigenvalue exponent branch x primary, ?_⟩
    intro endpointRowVanishes
    apply rowNonzero
    rw [branch.rowComparison, endpointRowVanishes, mul_zero]

/-- A primary-covering endpoint branch preserves and reflects the detected
generalized-primary Boolean of the common marked representation. -/
theorem endpoint_detects_iff_core_detects
    (loop : Loop) (eigenvalue : R) (exponent : ℕ)
    (branch : Branch core loop eigenvalue exponent) :
    DetectsGeneralizedEigenspace branch.endpoint.row
        (branch.endpoint.monodromy loop)
        (algebraMap R branch.K eigenvalue) exponent ↔
      DetectsGeneralizedEigenspace core.row
        (core.monodromy loop) eigenvalue exponent :=
  (endpoint_detects_iff_local_detects core loop eigenvalue exponent branch).trans
    (detectsGeneralizedEigenspace_baseChange_iff
      core loop eigenvalue exponent)

/-- Endpoints over unrelated faithfully flat coefficient extensions have the
same detected-primary Boolean when both are primary quotients of the same
marked representation. -/
theorem endpoint_detects_iff_endpoint_detects
    (loop : Loop) (eigenvalue : R) (exponent : ℕ)
    (left right : Branch core loop eigenvalue exponent) :
    DetectsGeneralizedEigenspace left.endpoint.row
        (left.endpoint.monodromy loop)
        (algebraMap R left.K eigenvalue) exponent ↔
      DetectsGeneralizedEigenspace right.endpoint.row
        (right.endpoint.monodromy loop)
        (algebraMap R right.K eigenvalue) exponent :=
  (endpoint_detects_iff_core_detects core loop eigenvalue exponent left).trans
    (endpoint_detects_iff_core_detects core loop eigenvalue exponent right).symm

/-- A detected endpoint and an undetected endpoint cannot both be
primary-covering scalar realizations of one marked representation. -/
theorem false_of_left_detects_of_right_not_detects
    (loop : Loop) (eigenvalue : R) (exponent : ℕ)
    (left right : Branch core loop eigenvalue exponent)
    (leftDetects :
      DetectsGeneralizedEigenspace left.endpoint.row
        (left.endpoint.monodromy loop)
        (algebraMap R left.K eigenvalue) exponent)
    (rightDoesNotDetect :
      ¬ DetectsGeneralizedEigenspace right.endpoint.row
        (right.endpoint.monodromy loop)
        (algebraMap R right.K eigenvalue) exponent) :
    False :=
  rightDoesNotDetect
    ((endpoint_detects_iff_endpoint_detects
      core loop eigenvalue exponent left right).mp leftDetects)

end Branch

end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.ParallelPrimaryQuotients
