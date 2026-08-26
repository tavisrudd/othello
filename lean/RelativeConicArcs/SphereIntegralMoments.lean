import Mathlib.MeasureTheory.Constructions.HaarToSphere
import Mathlib.MeasureTheory.Measure.Haar.InnerProductSpace
import Mathlib.Topology.Algebra.MvPolynomial
import RelativeConicArcs.SphericalMomentFunctional

/-!
# Normalized integration on the unit two-sphere

This module sets up normalized surface integration for the analytic bridge to
the algebraic moment functional used by the harmonic packet.  The surface
measure is Mathlib's polar-decomposition measure `volume.toSphere` on the unit
sphere in real three-space.
-/

namespace RelativeConicArcs.SphereIntegralMoments

open MeasureTheory Metric Set MvPolynomial
open RelativeConicArcs.SphericalMomentFunctional

/-- The unit two-sphere in Euclidean three-space. -/
abbrev Sphere3 := Metric.sphere (0 : EuclideanSpace ℝ (Fin 3)) 1

/-- Surface measure supplied by polar decomposition of Lebesgue measure. -/
noncomputable def sphereMeasure : Measure Sphere3 :=
  Measure.toSphere (volume : Measure (EuclideanSpace ℝ (Fin 3)))

noncomputable instance sphereMeasure_neZero : NeZero sphereMeasure :=
  ⟨by
    unfold sphereMeasure
    exact Measure.toSphere_ne_zero
      (volume : Measure (EuclideanSpace ℝ (Fin 3)))
  ⟩

noncomputable instance sphereMeasure_isFinite : IsFiniteMeasure sphereMeasure := by
  unfold sphereMeasure
  infer_instance

/-- Evaluation of a ternary polynomial on the unit sphere. -/
noncomputable def evalOnSphere (p : MvPolynomial (Fin 3) ℝ) (x : Sphere3) : ℝ :=
  eval (fun i => x.1 i) p

theorem continuous_evalOnSphere (p : MvPolynomial (Fin 3) ℝ) :
    Continuous (evalOnSphere p) := by
  unfold evalOnSphere
  refine (MvPolynomial.continuous_eval p).comp ?_
  apply continuous_pi
  intro i
  have hi : Continuous (fun y : EuclideanSpace ℝ (Fin 3) => y i) :=
    PiLp.continuous_apply (p := (2 : ENNReal)) (fun _ : Fin 3 => ℝ) i
  exact hi.comp continuous_subtype_val

theorem integrable_evalOnSphere (p : MvPolynomial (Fin 3) ℝ) :
    Integrable (evalOnSphere p) sphereMeasure := by
  simpa only [integrableOn_univ] using
    (continuous_evalOnSphere p).continuousOn.integrableOn_compact
      (μ := sphereMeasure) isCompact_univ

/-- Total surface mass. -/
noncomputable def sphereMass : ℝ := sphereMeasure.real univ

theorem sphereMass_pos : 0 < sphereMass := by
  exact measureReal_univ_pos

/-- Normalized surface integration of a ternary polynomial. -/
noncomputable def normalizedSphereIntegral (p : MvPolynomial (Fin 3) ℝ) : ℝ :=
  (∫ x, evalOnSphere p x ∂sphereMeasure) / sphereMass

/-- Normalized surface integration sends the constant one to one. -/
theorem normalizedSphereIntegral_one : normalizedSphereIntegral 1 = 1 := by
  have hm : sphereMeasure.real univ ≠ 0 := by
    simpa [sphereMass] using sphereMass_pos.ne'
  rw [normalizedSphereIntegral]
  simp [evalOnSphere, sphereMass, hm]

end RelativeConicArcs.SphereIntegralMoments
