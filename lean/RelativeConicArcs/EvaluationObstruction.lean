import Mathlib.LinearAlgebra.Pi

/-!
# Evaluation obstructions for prescribed exceptional loci

This file isolates the linear-algebra pattern used by the `GF(16)` quadratic leaf certificates.
It applies to any finite-dimensional linear system of forms, and in fact does not require finite
dimension: injective evaluation on an uncovered set kills the candidate form, while a selected
evaluation functional in the span of the uncovered evaluations forces a hit on the selected set.
-/

namespace RelativeConicArcs

section Evaluation

variable {K V X : Type*} [CommSemiring K] [AddCommMonoid V] [Module K V]

/-- Evaluation on a finite set, assembled from an arbitrary family of linear functionals. -/
noncomputable def evaluationMap (ev : X → V →ₗ[K] K) (U : Finset X) :
    V →ₗ[K] (U → K) :=
  LinearMap.pi fun u => ev u.1

@[simp] theorem evaluationMap_apply (ev : X → V →ₗ[K] K) (U : Finset X)
    (f : V) (u : U) : evaluationMap ev U f u = ev u.1 f := rfl

/-- If evaluation on `U` is injective, a form vanishing throughout `U` is zero. -/
theorem eq_zero_of_evaluationMap_injective (ev : X → V →ₗ[K] K) (U : Finset X)
    (hinj : Function.Injective (evaluationMap ev U)) {f : V}
    (hvanish : ∀ u ∈ U, ev u f = 0) : f = 0 := by
  apply hinj
  ext u
  simp [hvanish u.1 u.2]

/-- A selected evaluation functional expressed as a linear combination of evaluations on `U`
transfers vanishing on `U` to the selected point. -/
theorem evaluation_eq_zero_of_eq_sum (ev : X → V →ₗ[K] K) (U : Finset X)
    (a : X) (c : X → K)
    (hspan : ev a = ∑ u ∈ U, c u • ev u) {f : V}
    (hvanish : ∀ u ∈ U, ev u f = 0) : ev a f = 0 := by
  rw [hspan]
  simp only [LinearMap.sum_apply, LinearMap.smul_apply]
  exact Finset.sum_eq_zero fun u hu => by rw [hvanish u hu, smul_zero]

end Evaluation

end RelativeConicArcs
