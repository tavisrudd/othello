import Mathlib.LinearAlgebra.Dual.BaseChange
import Mathlib.RingTheory.Flat.Equalizer
import Mathlib.RingTheory.Flat.FaithfullyFlat.Basic
import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.RowedRepresentationDecomposition

/-!
# Faithfully flat base change of a row-detected primary block

Opposite Novikov completions can both extend one rational coefficient field
without embedding into one another.  This module proves that the Boolean used
by the stabilization telescope is unchanged by such a faithfully flat scalar
extension.

The proof does not choose generalized eigenvectors after completion.  Flatness
identifies the completed generalized-primary kernel with the scalar extension
of the original kernel, while faithfulness prevents the marked row from
becoming zero.  Thus the conservativity field in `ParallelScalarExtensions`
is automatic for an honest faithfully flat base change of one finite marked
representation.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.PrimaryDetectionBaseChange

open TensorProduct
open MarkedLocalSystem
open RowedRepresentationDecomposition
open RowedRepresentationDecomposition.Data

universe uR uK uLoop uV

variable
    {R : Type uR} [CommRing R]
    {K : Type uK} [CommRing K] [Algebra R K]
    {Loop : Type uLoop} [Group Loop]
    {V : Type uV} [AddCommGroup V] [Module R V]

/-- The marked representation obtained by scalar extension. -/
noncomputable def baseChangeRepresentation
    (representation : MarkedLocalSystem.Representation R Loop V) :
    MarkedLocalSystem.Representation K Loop (K ⊗[R] V) where
  monodromy :=
    { toFun := fun loop => (representation.monodromy loop).baseChange R K V V
      map_one' := by
        ext value
        simp
      map_mul' := by
        intro first second
        ext value
        simp [LinearEquiv.baseChange_mul] }
  row := Module.Dual.baseChange K representation.row

/-- The shifted monodromy endomorphism presenting one generalized-primary
kernel. -/
def shiftedOperator
    (monodromy : V ≃ₗ[R] V) (eigenvalue : R) : V →ₗ[R] V :=
  monodromy.toLinearMap - eigenvalue • LinearMap.id

@[simp]
theorem shiftedOperator_apply
    (monodromy : V ≃ₗ[R] V) (eigenvalue : R) (x : V) :
    shiftedOperator monodromy eigenvalue x = monodromy x - eigenvalue • x :=
  rfl

/-- The iterated shifted operator agrees with the function-iterate convention
used by `IsGeneralizedEigenvector`. -/
theorem shiftedOperator_pow_apply
    (monodromy : V ≃ₗ[R] V) (eigenvalue : R) (n : ℕ) (x : V) :
    (shiftedOperator monodromy eigenvalue ^ n) x =
      (((fun y => monodromy y - eigenvalue • y)^[n]) x) := by
  induction n generalizing x with
  | zero => rfl
  | succ n inductionHypothesis =>
      rw [pow_succ, Module.End.mul_apply, Function.iterate_succ_apply]
      exact inductionHypothesis (monodromy x - eigenvalue • x)

/-- Scalar extension commutes with the shifted monodromy endomorphism. -/
theorem shiftedOperator_baseChange
    (monodromy : V ≃ₗ[R] V) (eigenvalue : R) :
    (shiftedOperator monodromy eigenvalue).baseChange K =
      shiftedOperator (monodromy.baseChange R K V V) (algebraMap R K eigenvalue) := by
  ext value
  simp [shiftedOperator, sub_eq_add_neg, Algebra.smul_def]

/-- Scalar extension commutes with every power of the shifted monodromy. -/
theorem shiftedOperator_pow_baseChange
    (monodromy : V ≃ₗ[R] V) (eigenvalue : R) (n : ℕ) :
    (shiftedOperator monodromy eigenvalue ^ n).baseChange K =
      shiftedOperator (monodromy.baseChange R K V V)
          (algebraMap R K eigenvalue) ^ n := by
  rw [LinearMap.baseChange_pow, shiftedOperator_baseChange]

/-- A row which vanishes on the original generalized-primary kernel also
vanishes on its flat scalar extension. -/
theorem baseChangedRow_vanishes_on_primary
    [Module.Flat R K]
    (row : V →ₗ[R] R)
    (monodromy : V ≃ₗ[R] V) (eigenvalue : R) (n : ℕ)
    (vanishes : ∀ x,
      IsGeneralizedEigenvector monodromy eigenvalue n x → row x = 0)
    (y : K ⊗[R] V)
    (primary : IsGeneralizedEigenvector
      (monodromy.baseChange R K V V) (algebraMap R K eigenvalue) n y) :
    Module.Dual.baseChange K row y = 0 := by
  let shiftedPower : V →ₗ[R] V := shiftedOperator monodromy eigenvalue ^ n
  have primaryKernel :
      y ∈ LinearMap.ker (shiftedPower.baseChange K) := by
    change shiftedPower.baseChange K y = 0
    rw [show shiftedPower = shiftedOperator monodromy eigenvalue ^ n from rfl]
    rw [shiftedOperator_pow_baseChange]
    exact (shiftedOperator_pow_apply
      (monodromy.baseChange R K V V) (algebraMap R K eigenvalue) n y).trans primary
  let kernelValue : LinearMap.ker (shiftedPower.baseChange K) := ⟨y, primaryKernel⟩
  let tensorKernel : K ⊗[R] LinearMap.ker shiftedPower :=
    (LinearMap.tensorKerEquiv K K shiftedPower).symm kernelValue
  have underlying :
      (LinearMap.ker shiftedPower).subtype.lTensor K tensorKernel = y := by
    simp [kernelValue, tensorKernel]
  rw [← underlying]
  induction tensorKernel with
  | zero => simp
  | add left right leftVanishes rightVanishes => simp [leftVanishes, rightVanishes]
  | tmul scalar x =>
      have sourcePrimary :
          IsGeneralizedEigenvector monodromy eigenvalue n x.1 := by
        unfold IsGeneralizedEigenvector
        rw [← shiftedOperator_pow_apply]
        exact x.2
      simp [vanishes x.1 sourcePrimary]

/-- Faithfully flat scalar extension preserves and reflects the Boolean that
the marked row detects a chosen generalized-primary block. -/
theorem detectsGeneralizedEigenspace_baseChange_iff
    [Module.FaithfullyFlat R K]
    (representation : MarkedLocalSystem.Representation R Loop V)
    (loop : Loop) (eigenvalue : R) (n : ℕ) :
    DetectsGeneralizedEigenspace
        (baseChangeRepresentation representation).row
        ((baseChangeRepresentation representation).monodromy loop)
        (algebraMap R K eigenvalue) n ↔
      DetectsGeneralizedEigenspace representation.row
        (representation.monodromy loop) eigenvalue n := by
  constructor
  · rintro ⟨y, primary, rowNonzero⟩
    by_contra sourceDoesNotDetect
    have sourceRowVanishes : ∀ x,
        IsGeneralizedEigenvector (representation.monodromy loop) eigenvalue n x →
          representation.row x = 0 := by
      intro x sourcePrimary
      by_contra sourceRowNonzero
      exact sourceDoesNotDetect ⟨x, sourcePrimary, sourceRowNonzero⟩
    exact rowNonzero
      (baseChangedRow_vanishes_on_primary representation.row
        (representation.monodromy loop) eigenvalue n sourceRowVanishes y primary)
  · rintro ⟨x, primary, rowNonzero⟩
    refine ⟨(1 : K) ⊗ₜ[R] x, ?_, ?_⟩
    · unfold IsGeneralizedEigenvector at primary ⊢
      rw [← shiftedOperator_pow_apply] at primary ⊢
      change
        (shiftedOperator
          ((representation.monodromy loop).baseChange R K V V)
          (algebraMap R K eigenvalue) ^ n) ((1 : K) ⊗ₜ[R] x) = 0
      rw [← shiftedOperator_pow_baseChange]
      simp [primary]
    · have baseChangedNonzero :
          algebraMap R K (representation.row x) ≠ 0 :=
        by
          simpa using
            (FaithfulSMul.algebraMap_injective R K).ne rowNonzero
      simpa [baseChangeRepresentation, Algebra.algebraMap_eq_smul_one] using
        baseChangedNonzero

end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.PrimaryDetectionBaseChange
