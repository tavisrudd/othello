import Mathlib.LinearAlgebra.FiniteDimensional.Lemmas

/-!
# The dimension squeeze behind stabilizer-AME full-Weyl marginals

For a pure stabilizer state on `2m` parties, restriction of its label
Lagrangian to the complement of an `(m+1)`-party set has a kernel of
dimension at least one local Pauli-label space.  The AME condition makes
projection of that kernel to any retained party injective.  Rank-nullity
therefore forces the projection to be bijective.

The theorem below isolates this dimension squeeze.  It applies over the
prime field to arbitrary additive prime-power stabilizers and over the
alphabet field to field-linear stabilizers.  The physical application
takes:

* `E` to be the stabilizer-label space;
* `W` to be the Pauli labels on the omitted `m-1` parties;
* `V` to be the Pauli-label space of one retained party;
* `outside` to be restriction to the omitted parties; and
* `localProjection` to be projection of `ker outside` to the retained party.

The AME condition supplies injectivity of `localProjection`, because its kernel
would be a nonzero stabilizer supported on at most `m` parties.

This module is symbolic and kernel checked.  It contains no generated
data, native evaluation, axioms, or admitted declarations.
-/

namespace RelativeConicArcs.AMELU

variable {𝕜 E W V : Type*}
  [Field 𝕜]
  [AddCommGroup E] [Module 𝕜 E] [FiniteDimensional 𝕜 E]
  [AddCommGroup W] [Module 𝕜 W] [FiniteDimensional 𝕜 W]
  [AddCommGroup V] [Module 𝕜 V] [FiniteDimensional 𝕜 V]

/-- If the source dimension is the sum of the outside-label and one-site
label dimensions, injectivity of the one-site projection on the outside
kernel forces that projection to be bijective. -/
theorem stabilizerAME_kernelToLocal_bijective
    (outside : E →ₗ[𝕜] W)
    (localProjection : LinearMap.ker outside →ₗ[𝕜] V)
    (hfinrank :
      Module.finrank 𝕜 E =
        Module.finrank 𝕜 W + Module.finrank 𝕜 V)
    (hinjective : Function.Injective localProjection) :
    Function.Bijective localProjection := by
  have hrange_le :
      Module.finrank 𝕜 (LinearMap.range outside) ≤
        Module.finrank 𝕜 W :=
    Submodule.finrank_le _
  have hrank_nullity := LinearMap.finrank_range_add_finrank_ker outside
  have hlower :
      Module.finrank 𝕜 V ≤
        Module.finrank 𝕜 (LinearMap.ker outside) := by
    omega
  have hupper :
      Module.finrank 𝕜 (LinearMap.ker outside) ≤
        Module.finrank 𝕜 V :=
    LinearMap.finrank_le_finrank_of_injective hinjective
  have heq :
      Module.finrank 𝕜 (LinearMap.ker outside) =
        Module.finrank 𝕜 V :=
    Nat.le_antisymm hupper hlower
  refine ⟨hinjective, ?_⟩
  exact
    (LinearMap.injective_iff_surjective_of_finrank_eq_finrank heq).mp
      hinjective

/-- Under the same hypotheses, the supported stabilizer-label kernel has
exactly one local Pauli-label space of dimension. -/
theorem stabilizerAME_finrank_ker_eq_local
    (outside : E →ₗ[𝕜] W)
    (localProjection : LinearMap.ker outside →ₗ[𝕜] V)
    (hfinrank :
      Module.finrank 𝕜 E =
        Module.finrank 𝕜 W + Module.finrank 𝕜 V)
    (hinjective : Function.Injective localProjection) :
    Module.finrank 𝕜 (LinearMap.ker outside) =
      Module.finrank 𝕜 V := by
  have hbij :=
    stabilizerAME_kernelToLocal_bijective
      outside localProjection hfinrank hinjective
  exact
    LinearEquiv.finrank_eq
      (LinearEquiv.ofBijective localProjection hbij)

end RelativeConicArcs.AMELU
