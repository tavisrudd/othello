import ProjectiveCap.BaerQuadraticDescent
import Mathlib.LinearAlgebra.QuadraticForm.Radical

/-!
# Untwisting a quadratic Baer stabilizer

This file separates the semilinear bookkeeping from the geometric rigidity theorem.  Pulling a
quadratic form through a relative-Frobenius semilinear map and conjugating its values produces an
ordinary quadratic form over the extension field.  Consequently, the Baer stabilizer theorem
reduces to the purely quadratic statement that two forms with the same null cone are proportional.
-/

namespace ProjectiveCap
namespace Projective
namespace BaerSemilinear

variable (F K : Type*) [Field F] [Fintype F] [Field K] [Fintype K] [Algebra F K]

variable {V : Type*} [AddCommGroup V] [Module K V]

private theorem polar_conj_comp_semilinear
    (Q : QuadraticForm K V)
    (S : V →ₛₗ[FiniteHermitian.conjRingHom F K] V) (x y : V) :
    QuadraticMap.polar (fun v => FiniteHermitian.conj F K (Q (S v))) x y =
      FiniteHermitian.conj F K (QuadraticMap.polar Q (S x) (S y)) := by
  simp only [QuadraticMap.polar, map_add, map_sub]

/-- The ordinary quadratic form obtained by conjugating the values of the semilinear pullback
`Q ∘ S`. -/
noncomputable def conjugatePullbackQuadraticForm
    (hfinrank : Module.finrank F K = 2)
    (Q : QuadraticForm K V)
    (S : V →ₛₗ[FiniteHermitian.conjRingHom F K] V) : QuadraticForm K V :=
  QuadraticMap.ofPolar (fun v => FiniteHermitian.conj F K (Q (S v)))
    (fun a x => by
      simp only [LinearMap.map_smulₛₗ, FiniteHermitian.conjRingHom_apply,
        QuadraticMap.map_smul, map_mul, smul_eq_mul]
      rw [conj_involutive F K hfinrank a])
    (fun x x' y => by
      simp only [polar_conj_comp_semilinear F K, map_add,
        QuadraticMap.polar_add_left])
    (fun a x y => by
      simp only [polar_conj_comp_semilinear F K, LinearMap.map_smulₛₗ,
        FiniteHermitian.conjRingHom_apply, QuadraticMap.polar_smul_left, map_mul,
        smul_eq_mul]
      rw [conj_involutive F K hfinrank a])

@[simp]
theorem conjugatePullbackQuadraticForm_apply
    (hfinrank : Module.finrank F K = 2)
    (Q : QuadraticForm K V)
    (S : V →ₛₗ[FiniteHermitian.conjRingHom F K] V) (v : V) :
    conjugatePullbackQuadraticForm F K hfinrank Q S v =
      FiniteHermitian.conj F K (Q (S v)) :=
  rfl

theorem conjugatePullbackQuadraticForm_eq_zero_iff
    (hfinrank : Module.finrank F K = 2)
    (Q : QuadraticForm K V)
    (S : V →ₛₗ[FiniteHermitian.conjRingHom F K] V) (v : V) :
    conjugatePullbackQuadraticForm F K hfinrank Q S v = 0 ↔ Q (S v) = 0 := by
  rw [conjugatePullbackQuadraticForm_apply]
  exact map_eq_zero_iff (FiniteHermitian.conj F K) (FiniteHermitian.conj F K).injective

/-- Proportionality of the untwisted pullback to `Q` supplies the required semisimilitude
multiplier.  This is the final bookkeeping step after null-cone rigidity. -/
theorem exists_semisimilitudeMultiplier_of_conjugatePullback_eq_smul
    (hfinrank : Module.finrank F K = 2)
    (Q : QuadraticForm K V)
    (S : V →ₛₗ[FiniteHermitian.conjRingHom F K] V)
    {c : K} (hc : c ≠ 0)
    (hform : conjugatePullbackQuadraticForm F K hfinrank Q S = c • Q) :
    ∃ μ : K, μ ≠ 0 ∧
      ∀ v, Q (S v) = μ * FiniteHermitian.conj F K (Q v) := by
  refine ⟨FiniteHermitian.conj F K c, (map_ne_zero (FiniteHermitian.conj F K)).2 hc, ?_⟩
  intro v
  have hv := QuadraticMap.congr_fun hform v
  change FiniteHermitian.conj F K (Q (S v)) = c * Q v at hv
  have hc := congrArg (FiniteHermitian.conj F K) hv
  rw [map_mul, conj_involutive F K hfinrank (Q (S v))] at hc
  exact hc

end BaerSemilinear
end Projective
end ProjectiveCap
