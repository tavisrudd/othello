import Mathlib.Tactic
import Mathlib.LinearAlgebra.Dimension.Finrank

/-!
# Isotropic vectors in a positive one-dimensional intersection space

In a one-dimensional real vector space, a bilinear form positive on one
nonzero generator has no nonzero isotropic vector. Therefore a construction
assigning a nonzero isotropic cohomology class to every nonzero holomorphic
one-form forces that one-form space to vanish. The differential-form and
Kähler-class construction of that class is an explicit geometric premise,
not replaced by a premise asserting irregularity zero.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum

/-- A positive generator of a one-dimensional real intersection space excludes
nonzero isotropic vectors. No nondegeneracy premise is needed separately. -/
theorem positiveLine_isotropic_eq_zero
    {V : Type*} [AddCommGroup V] [Module ℝ V]
    (pairing : V →ₗ[ℝ] V →ₗ[ℝ] ℝ) (generator : V)
    (dimension : Module.finrank ℝ V=1) (positive : 0 < pairing generator generator)
    (x : V) (isotropic : pairing x x=0) : x=0 := by
  have generatorNonzero : generator ≠ 0 := by
    intro zero
    simp [zero] at positive
  have spanning := (finrank_eq_one_iff_of_nonzero' (K := ℝ) generator generatorNonzero).mp dimension
  obtain ⟨c,rfl⟩ := spanning x
  have coefficient : c=0 := by
    have h : c*c*pairing generator generator=0 := by simpa [mul_assoc] using isotropic
    have square : c*c=0 := (mul_eq_zero.mp h).resolve_right (ne_of_gt positive)
    exact (mul_self_eq_zero.mp square)
  simp [coefficient]

/-- If every nonzero element of a vector space produces a nonzero isotropic
class in a positive one-dimensional real space, that vector space is zero. -/
theorem oneFormSpace_eq_zero_of_positiveLine
    {V W : Type*} [AddCommGroup V] [Module ℝ V] [Zero W]
    (pairing : V →ₗ[ℝ] V →ₗ[ℝ] ℝ) (generator : V)
    (dimension : Module.finrank ℝ V=1) (positive : 0 < pairing generator generator)
    (isotropicClass : ∀ form : W, form ≠ 0 → ∃ x : V, x ≠ 0 ∧ pairing x x=0) :
    ∀ form : W, form=0 := by
  intro form
  by_contra nonzero
  obtain ⟨x,hx,isotropic⟩ := isotropicClass form nonzero
  exact hx (positiveLine_isotropic_eq_zero pairing generator dimension positive x isotropic)

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum
