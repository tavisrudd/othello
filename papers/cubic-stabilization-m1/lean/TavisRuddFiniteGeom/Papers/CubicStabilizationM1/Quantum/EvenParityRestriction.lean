import Mathlib.LinearAlgebra.FiniteDimensional.Basic

/-!
# Restriction of a parity-preserving comparison to the even carrier

An even-bulk quantum connection still has the full cohomology as its carrier
unless the carrier is separately restricted to even cohomology.  The direct
rank-two residue marker uses that even carrier.  This module records the
linear-algebra bridge needed from an external comparison: an invertible linear
map which preserves parity in both directions restricts to a linear
equivalence of the designated even submodules.

The submodules are abstract.  Lean does not construct cohomology, the parity
decomposition of a quantum connection, or the Iritani and Iritani--Koto
comparison maps.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace Quantum

universe u v w

variable {R : Type u} [Semiring R]
  {V : Type v} [AddCommMonoid V] [Module R V]
  {W : Type w} [AddCommMonoid W] [Module R W]

/-- An invertible linear comparison together with the exact assertion that it
preserves membership in the chosen even submodules in both directions. -/
structure ParityPreservingLinearEquiv
    (evenSource : Submodule R V) (evenTarget : Submodule R W) where
  toLinearEquiv : V ≃ₗ[R] W
  map_mem_iff : ∀ vector, vector ∈ evenSource ↔ toLinearEquiv vector ∈ evenTarget

namespace ParityPreservingLinearEquiv

/-- The restriction of a parity-preserving linear equivalence to the chosen
even submodules. -/
def evenLinearMap {evenSource : Submodule R V} {evenTarget : Submodule R W}
    (comparison : ParityPreservingLinearEquiv evenSource evenTarget) :
    evenSource →ₗ[R] evenTarget where
  toFun vector := ⟨comparison.toLinearEquiv vector.1,
    (comparison.map_mem_iff vector.1).mp vector.2⟩
  map_add' left right := by
    ext
    exact comparison.toLinearEquiv.map_add left.1 right.1
  map_smul' scalar vector := by
    ext
    exact comparison.toLinearEquiv.map_smul scalar vector.1

/-- The restricted even map is injective. -/
theorem evenLinearMap_injective
    {evenSource : Submodule R V} {evenTarget : Submodule R W}
    (comparison : ParityPreservingLinearEquiv evenSource evenTarget) :
    Function.Injective comparison.evenLinearMap := by
  intro left right equality
  apply Subtype.ext
  exact comparison.toLinearEquiv.injective (congrArg Subtype.val equality)

/-- The restricted even map is surjective.  The inverse image under the full
equivalence is even because parity preservation was assumed as an equivalence,
not only as a forward implication. -/
theorem evenLinearMap_surjective
    {evenSource : Submodule R V} {evenTarget : Submodule R W}
    (comparison : ParityPreservingLinearEquiv evenSource evenTarget) :
    Function.Surjective comparison.evenLinearMap := by
  intro target
  let source : V := comparison.toLinearEquiv.symm target.1
  have sourceEven : source ∈ evenSource := by
    apply (comparison.map_mem_iff source).mpr
    simp [source]
  refine ⟨⟨source, sourceEven⟩, ?_⟩
  apply Subtype.ext
  simp [evenLinearMap, source]

/-- A parity-preserving equivalence of full carriers induces an equivalence of
their even carriers. -/
noncomputable def evenLinearEquiv
    {evenSource : Submodule R V} {evenTarget : Submodule R W}
    (comparison : ParityPreservingLinearEquiv evenSource evenTarget) :
    evenSource ≃ₗ[R] evenTarget :=
  LinearEquiv.ofBijective comparison.evenLinearMap
    ⟨comparison.evenLinearMap_injective, comparison.evenLinearMap_surjective⟩

end ParityPreservingLinearEquiv

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
