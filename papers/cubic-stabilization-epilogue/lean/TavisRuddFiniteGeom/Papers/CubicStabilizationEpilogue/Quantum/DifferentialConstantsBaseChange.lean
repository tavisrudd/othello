import Mathlib.RingTheory.Flat.Equalizer
import Mathlib.LinearAlgebra.Basis.VectorSpace
import Mathlib.LinearAlgebra.TensorProduct.Tower
import Mathlib.RingTheory.Derivation.Basic
import Mathlib.RingTheory.TensorProduct.Basic

/-!
# Differential constants under flat coefficient extension

Let `d : R →ₗ[k] R` be the linear operator underlying a derivation and let
`B` be a commutative `k`-algebra.  Because every module over a field is flat,
tensoring with `B` preserves the kernel of `d`: the constants of the extended
operator are exactly the scalar extensions of the original constants.  The
same fact is also exposed as preservation of an exact constants--derivative
pair.

When `R` is a commutative `k`-algebra and the operator is a derivation, Lean
also constructs the induced `B`-derivation on `B ⊗[k] R`.  On pure tensors it
sends `b ⊗ r` to `b ⊗ d(r)`, satisfies the Leibniz rule, kills the coefficient
algebra `B`, and has the kernel described by the preceding flat base-change
theorem.

This is the linear-algebra step used in the manuscript's coefficientwise
base-change lemma.  It does not construct a Levelt--Turrittin solution
algebra, a fundamental solution matrix, horizontal sections, or framed
monodromy.  All proofs are symbolic and kernel checked, with no external
computation or oracle.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Quantum

open TensorProduct

/-- Flat coefficient extension identifies the kernel of the extended
derivative with the image of the tensor-extended original kernel. -/
theorem differentialConstants_baseChange
    {k R B : Type*} [Field k] [AddCommGroup R] [Module k R]
    [CommRing B] [Algebra k B]
    (derivative : R →ₗ[k] R) :
    LinearMap.ker (derivative.lTensor B) =
      LinearMap.range ((LinearMap.ker derivative).subtype.lTensor B) := by
  letI : Module.Free k B := Module.Free.of_divisionRing k B
  letI : Module.Flat k B := Module.Flat.of_free
  rw [← LinearMap.exact_iff]
  exact Module.Flat.lTensor_exact B
    (LinearMap.exact_subtype_ker_map derivative)

/-- More generally, an exact pair presenting the original constants remains
exact after coefficient extension.  When `constants : k →ₗ[k] R` is the
inclusion of the original constant field and
`Exact constants derivative`, this says that the extended constants are
precisely its `B`-span. -/
theorem differentialConstants_exact_baseChange
    {k C R B : Type*} [Field k]
    [AddCommGroup C] [Module k C]
    [AddCommGroup R] [Module k R]
    [CommRing B] [Algebra k B]
    (constants : C →ₗ[k] R) (derivative : R →ₗ[k] R)
    (exact : Function.Exact constants derivative) :
    Function.Exact
      (constants.lTensor B) (derivative.lTensor B) := by
  letI : Module.Free k B := Module.Free.of_divisionRing k B
  letI : Module.Flat k B := Module.Flat.of_free
  exact Module.Flat.lTensor_exact B exact

/-- The coefficient extension of a derivation.  It differentiates the right
tensor factor and fixes the coefficient algebra `B`. -/
noncomputable def differentialDerivationBaseChange
    {k R B : Type*} [CommRing k]
    [CommRing R] [Algebra k R]
    [CommRing B] [Algebra k B]
    (derivative : Derivation k R R) :
    Derivation B (B ⊗[k] R) (B ⊗[k] R) where
  toLinearMap := AlgebraTensorModule.lTensor B B derivative.toLinearMap
  map_one_eq_zero' := by
    simp [Algebra.TensorProduct.one_def]
  leibniz' left right := by
    induction left using TensorProduct.induction_on with
    | zero => simp
    | add left₁ left₂ ih₁ ih₂ =>
        simp only [add_mul, map_add, add_smul, ih₁, ih₂]
        simp only [smul_eq_mul]
        ring
    | tmul b r =>
        induction right using TensorProduct.induction_on with
        | zero => simp
        | add right₁ right₂ ih₁ ih₂ =>
            simp only [mul_add, map_add, add_smul, ih₁, ih₂]
            simp only [smul_eq_mul]
            ring
        | tmul c s =>
            simp [Algebra.TensorProduct.tmul_mul_tmul,
              Derivation.leibniz, TensorProduct.tmul_add,
              mul_comm]

/-- On a pure tensor, coefficient extension applies the original derivation to
the right tensor factor. -/
@[simp]
theorem differentialDerivationBaseChange_tmul
    {k R B : Type*} [CommRing k]
    [CommRing R] [Algebra k R]
    [CommRing B] [Algebra k B]
    (derivative : Derivation k R R) (coefficient : B) (value : R) :
    differentialDerivationBaseChange derivative (coefficient ⊗ₜ[k] value) =
      coefficient ⊗ₜ[k] derivative value :=
  rfl

/-- The extended derivation vanishes on the coefficient algebra. -/
@[simp]
theorem differentialDerivationBaseChange_algebraMap
    {k R B : Type*} [CommRing k]
    [CommRing R] [Algebra k R]
    [CommRing B] [Algebra k B]
    (derivative : Derivation k R R) (coefficient : B) :
    differentialDerivationBaseChange derivative
        (algebraMap B (B ⊗[k] R) coefficient) = 0 := by
  rw [Algebra.TensorProduct.algebraMap_apply]
  simp

/-- The constants of the extended derivation form a `B`-subalgebra of the
tensor-product coefficient ring. -/
noncomputable def differentialDerivationConstantsSubalgebra
    {k R B : Type*} [CommRing k]
    [CommRing R] [Algebra k R]
    [CommRing B] [Algebra k B]
    (derivative : Derivation k R R) : Subalgebra B (B ⊗[k] R) where
  carrier := { value | differentialDerivationBaseChange derivative value = 0 }
  mul_mem' {left right} hleft hright := by
    change differentialDerivationBaseChange derivative (left * right) = 0
    rw [Derivation.leibniz, hleft, hright]
    simp
  one_mem' := Derivation.map_one_eq_zero _
  add_mem' {left right} hleft hright := by
    change differentialDerivationBaseChange derivative (left + right) = 0
    rw [map_add, hleft, hright, add_zero]
  zero_mem' := map_zero _
  algebraMap_mem' coefficient :=
    differentialDerivationBaseChange_algebraMap derivative coefficient

/-- Membership in the constant subalgebra is exactly vanishing under the
extended derivation. -/
@[simp]
theorem mem_differentialDerivationConstantsSubalgebra_iff
    {k R B : Type*} [CommRing k]
    [CommRing R] [Algebra k R]
    [CommRing B] [Algebra k B]
    (derivative : Derivation k R R) (value : B ⊗[k] R) :
    value ∈ differentialDerivationConstantsSubalgebra derivative ↔
      differentialDerivationBaseChange derivative value = 0 :=
  Iff.rfl

/-- Over a field, an element is constant for the extended derivation exactly
when it lies in the image of the scalar-extended original kernel. -/
theorem differentialDerivationConstants_baseChange_iff
    {k R B : Type*} [Field k]
    [CommRing R] [Algebra k R]
    [CommRing B] [Algebra k B]
    (derivative : Derivation k R R) (value : B ⊗[k] R) :
    differentialDerivationBaseChange derivative value = 0 ↔
      value ∈ LinearMap.range
        ((LinearMap.ker derivative.toLinearMap).subtype.lTensor B) := by
  change derivative.toLinearMap.lTensor B value = 0 ↔ _
  rw [← LinearMap.mem_ker,
    differentialConstants_baseChange (B := B) derivative.toLinearMap]

/-- As a set, the constant subalgebra of the extended derivation is precisely
the image of the tensor-extended original kernel. -/
theorem differentialDerivationConstantsSubalgebra_coe
    {k R B : Type*} [Field k]
    [CommRing R] [Algebra k R]
    [CommRing B] [Algebra k B]
    (derivative : Derivation k R R) :
    (differentialDerivationConstantsSubalgebra (B := B) derivative : Set (B ⊗[k] R)) =
      LinearMap.range
        ((LinearMap.ker derivative.toLinearMap).subtype.lTensor B) := by
  ext value
  exact differentialDerivationConstants_baseChange_iff derivative value

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
