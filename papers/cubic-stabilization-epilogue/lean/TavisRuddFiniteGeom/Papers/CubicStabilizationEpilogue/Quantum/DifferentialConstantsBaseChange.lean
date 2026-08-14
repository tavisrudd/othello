import Mathlib.RingTheory.Flat.Equalizer
import Mathlib.LinearAlgebra.Basis.VectorSpace

/-!
# Differential constants under flat coefficient extension

Let `d : R →ₗ[k] R` be the linear operator underlying a derivation and let
`B` be a commutative `k`-algebra.  Because every module over a field is flat,
tensoring with `B` preserves the kernel of `d`: the constants of the extended
operator are exactly the scalar extensions of the original constants.  The
same fact is also exposed as preservation of an exact constants--derivative
pair.

This is the linear-algebra step used in the manuscript's coefficientwise
base-change lemma.  It does not construct a Levelt--Turrittin solution
algebra, a fundamental solution matrix, horizontal sections, or framed
monodromy.  All proofs are symbolic and kernel checked, with no external
computation or oracle.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Quantum

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

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
