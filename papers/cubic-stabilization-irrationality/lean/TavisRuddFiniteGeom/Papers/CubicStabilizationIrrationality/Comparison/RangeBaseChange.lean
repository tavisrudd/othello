import Mathlib.LinearAlgebra.TensorProduct.Basic
import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.MonodromyImage

/-!
# Exact base change for a monodromy image

An ambient operator square does not imply that its image commutes with base
change. This interface records both the ambient scalar-extension equivalence
and the separate equivalence between the scalar extension of the integral
image and the image of the specialized operator. The inclusion square makes
the latter equivalence a certificate about the actual submodules, rather than
an abstract isomorphism of modules of the same rank.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.RangeBaseChange

open scoped TensorProduct

universe uR uk uV uVk

variable
    (R : Type uR) (k : Type uk) [CommRing R] [CommRing k] [Algebra R k]
    (specialize : R →+* k)
    (V : Type uV) (Vk : Type uVk)
    [AddCommGroup V] [Module R V]
    [AddCommGroup Vk] [Module k Vk]

/-- Exact scalar extension for one operator and its image. -/
structure Certificate
    (operatorR : V →ₗ[R] V) (operatorK : Vk →ₗ[k] Vk) where
  specialization_agrees : algebraMap R k = specialize
  ambient : (k ⊗[R] V) ≃ₗ[k] Vk
  image : (k ⊗[R] LinearMap.range operatorR) ≃ₗ[k]
    LinearMap.range operatorK
  operatorSquare : ∀ x : k ⊗[R] V,
    ambient (TensorProduct.map LinearMap.id operatorR x) =
      operatorK (ambient x)
  imageInclusionSquare : ∀ x : k ⊗[R] LinearMap.range operatorR,
    ambient (TensorProduct.map LinearMap.id (LinearMap.range operatorR).subtype x) =
      (image x).1

end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.RangeBaseChange
