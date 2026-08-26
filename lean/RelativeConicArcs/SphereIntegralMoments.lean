import Mathlib.MeasureTheory.Constructions.HaarToSphere
import Mathlib.MeasureTheory.Measure.Haar.InnerProductSpace
import Mathlib.Analysis.SpecialFunctions.Gaussian.GaussianIntegral
import Mathlib.MeasureTheory.Integral.Gamma
import Mathlib.MeasureTheory.Integral.IntegralEqImproper
import Mathlib.MeasureTheory.Integral.Pi
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

private noncomputable def gaussianKernel (x : ℝ) : ℝ :=
  Real.exp (-(1 / 2 : ℝ) * x ^ 2)

private lemma integrable_pow_mul_gaussianKernel (n : ℕ) :
    Integrable (fun x : ℝ => x ^ n * gaussianKernel x) := by
  simpa [gaussianKernel, Real.rpow_natCast] using
    (integrable_rpow_mul_exp_neg_mul_sq (b := (1 / 2 : ℝ)) (by norm_num)
      (s := (n : ℝ)) (lt_of_lt_of_le (by norm_num) (Nat.cast_nonneg n)))

private lemma gaussianKernel_hasDerivAt (x : ℝ) :
    HasDerivAt gaussianKernel (-x * gaussianKernel x) x := by
  have hin : HasDerivAt (fun y : ℝ => -(1 / 2 : ℝ) * y ^ 2) (-x) x := by
    simpa [pow_two] using ((hasDerivAt_pow 2 x).const_mul (-(1 / 2 : ℝ)))
  change HasDerivAt (fun y : ℝ => Real.exp (-(1 / 2 : ℝ) * y ^ 2))
    (-x * Real.exp (-(1 / 2 : ℝ) * x ^ 2)) x
  simpa [Function.comp_def, mul_comm] using
    ((Real.hasDerivAt_exp (-(1 / 2 : ℝ) * x ^ 2)).comp x hin)

/-- The unnormalized one-dimensional Gaussian moments obey the double-factorial
recursion used by `momentFactor`. -/
private lemma integral_pow_mul_gaussianKernel_add_two (n : ℕ) :
    (∫ x : ℝ, x ^ (n + 2) * gaussianKernel x) =
      (n + 1 : ℝ) * ∫ x : ℝ, x ^ n * gaussianKernel x := by
  have hparts := MeasureTheory.integral_mul_deriv_eq_deriv_mul_of_integrable
    (u := fun x : ℝ => x ^ (n + 1))
    (u' := fun x : ℝ => (n + 1 : ℝ) * x ^ n)
    (v := gaussianKernel)
    (v' := fun x : ℝ => -x * gaussianKernel x)
    (fun x _ => by simpa using hasDerivAt_pow (n + 1) x)
    (fun x _ => gaussianKernel_hasDerivAt x)
    (by
      convert (integrable_pow_mul_gaussianKernel (n + 2)).neg using 1
      ext x
      simp [pow_succ]
      ring)
    (by
      convert (integrable_pow_mul_gaussianKernel n).const_mul (n + 1 : ℝ) using 1
      ext x
      simp
      ring)
    (integrable_pow_mul_gaussianKernel (n + 1))
  calc
    (∫ x : ℝ, x ^ (n + 2) * gaussianKernel x) =
        -∫ x : ℝ, x ^ (n + 1) * (-x * gaussianKernel x) := by
      rw [← integral_neg]
      congr 1
      funext x
      simp [pow_succ]
      ring
    _ = ∫ x : ℝ, (n + 1 : ℝ) * x ^ n * gaussianKernel x := by rw [hparts]; simp
    _ = (n + 1 : ℝ) * ∫ x : ℝ, x ^ n * gaussianKernel x := by
      rw [← integral_const_mul]
      congr 1
      funext x
      ring

private noncomputable def gaussianMass : ℝ :=
  ∫ x : ℝ, gaussianKernel x

private lemma integral_mul_gaussianKernel :
    (∫ x : ℝ, x * gaussianKernel x) = 0 := by
  have h := integral_neg_eq_self (μ := (volume : Measure ℝ))
    (f := fun x : ℝ => x * gaussianKernel x)
  have hk : ∀ x : ℝ, gaussianKernel (-x) = gaussianKernel x := by
    intro x
    simp [gaussianKernel]
  have : -(∫ x : ℝ, x * gaussianKernel x) = ∫ x : ℝ, x * gaussianKernel x := by
    calc
      -(∫ x : ℝ, x * gaussianKernel x) = ∫ x : ℝ, -(x * gaussianKernel x) := by
        rw [integral_neg]
      _ = ∫ x : ℝ, (-x) * gaussianKernel (-x) := by
        congr 1
        funext x
        rw [hk]
        ring
      _ = ∫ x : ℝ, x * gaussianKernel x := h
  linarith

/-- Every one-dimensional standard Gaussian monomial moment is its
double-factorial weight times the common Gaussian mass. -/
private lemma integral_pow_mul_gaussianKernel (n : ℕ) :
    (∫ x : ℝ, x ^ n * gaussianKernel x) = momentFactor n * gaussianMass := by
  induction n using Nat.twoStepInduction with
  | zero => simp [gaussianMass]
  | one => simp [integral_mul_gaussianKernel, momentFactor]
  | more n hn _ =>
      rw [integral_pow_mul_gaussianKernel_add_two, hn, momentFactor_add_two]
      ring

private lemma integral_pi_monomial_mul_gaussianKernel (a : Fin 3 →₀ ℕ) :
    (∫ x : Fin 3 → ℝ, (∏ i, x i ^ a i) * ∏ i, gaussianKernel (x i)) =
      momentWeight a * gaussianMass ^ 3 := by
  simp_rw [← Finset.prod_mul_distrib]
  change (∫ x : Fin 3 → ℝ, ∏ i, (fun y : ℝ => y ^ a i * gaussianKernel y) (x i)) = _
  rw [integral_fintype_prod_volume_eq_prod
      (f := fun i (y : ℝ) => y ^ a i * gaussianKernel y),
    Finset.prod_congr rfl (fun i _ => integral_pow_mul_gaussianKernel (a i)),
    Finset.prod_mul_distrib]
  simp [momentWeight, Fintype.card_fin]

private lemma prod_gaussianKernel_eq_norm (x : Fin 3 → ℝ) :
    (∏ i, gaussianKernel (x i)) =
      Real.exp (-(1 / 2 : ℝ) * ‖WithLp.toLp 2 x‖ ^ 2) := by
  rw [show (∏ i, gaussianKernel (x i)) =
      ∏ i, Real.exp (-(1 / 2 : ℝ) * x i ^ 2) by rfl,
    ← Real.exp_sum]
  congr 1
  rw [EuclideanSpace.norm_eq, Real.sq_sqrt (Finset.sum_nonneg fun _ _ => sq_nonneg _)]
  simp only [Real.norm_eq_abs, sq_abs]
  rw [← Finset.mul_sum]

private noncomputable def gaussianPolynomialIntegral
    (p : MvPolynomial (Fin 3) ℝ) : ℝ :=
  ∫ x : EuclideanSpace ℝ (Fin 3),
    eval (fun i => x i) p * Real.exp (-(1 / 2 : ℝ) * ‖x‖ ^ 2)

private lemma gaussianPolynomialIntegral_monomial (a : Fin 3 →₀ ℕ) (c : ℝ) :
    gaussianPolynomialIntegral (monomial a c) =
      c * momentWeight a * gaussianMass ^ 3 := by
  rw [gaussianPolynomialIntegral,
    ← (PiLp.volume_preserving_toLp (Fin 3)).integral_comp
      (MeasurableEquiv.toLp 2 _).measurableEmbedding]
  simp only [eval_monomial]
  simp_rw [← prod_gaussianKernel_eq_norm]
  simp_rw [Finsupp.prod_fintype _ _ (fun _ => pow_zero _)]
  rw [show (∫ x : Fin 3 → ℝ, c * (∏ i, x i ^ a i) * ∏ i, gaussianKernel (x i)) =
      c * ∫ x : Fin 3 → ℝ, (∏ i, x i ^ a i) * ∏ i, gaussianKernel (x i) by
        simp_rw [mul_assoc]
        rw [integral_const_mul],
    integral_pi_monomial_mul_gaussianKernel]
  ring

private lemma integrable_gaussianPolynomial_monomial (a : Fin 3 →₀ ℕ) (c : ℝ) :
    Integrable (fun x : EuclideanSpace ℝ (Fin 3) =>
      eval (fun i => x i) (monomial a c) *
        Real.exp (-(1 / 2 : ℝ) * ‖x‖ ^ 2)) := by
  rw [← (PiLp.volume_preserving_toLp (Fin 3)).integrable_comp_emb
    (MeasurableEquiv.toLp 2 _).measurableEmbedding]
  simp only [Function.comp_def, eval_monomial]
  simp_rw [← prod_gaussianKernel_eq_norm]
  simp_rw [Finsupp.prod_fintype _ _ (fun _ => pow_zero _)]
  have hp : Integrable (fun x : Fin 3 → ℝ =>
      ∏ i, (fun y : ℝ => y ^ a i * gaussianKernel y) (x i)) :=
    Integrable.fintype_prod (fun i => integrable_pow_mul_gaussianKernel (a i))
  rw [volume_pi]
  convert hp.const_mul c using 1
  · rfl
  · funext x
    rw [Finset.prod_mul_distrib, mul_assoc]
  · exact volume_pi.symm

private lemma integrable_gaussianPolynomial (p : MvPolynomial (Fin 3) ℝ) :
    Integrable (fun x : EuclideanSpace ℝ (Fin 3) =>
      eval (fun i => x i) p * Real.exp (-(1 / 2 : ℝ) * ‖x‖ ^ 2)) := by
  induction p using MvPolynomial.induction_on' with
  | monomial a c => exact integrable_gaussianPolynomial_monomial a c
  | add p q hp hq =>
      refine (hp.add hq).congr ?_
      filter_upwards with x
      simp only [map_add, add_mul, Pi.add_apply]

/-- Cartesian Gaussian integration realizes the algebraically defined moment
functional, up to the common zeroth-moment mass in each coordinate. -/
private lemma gaussianPolynomialIntegral_eq_gaussianMoment (p : MvPolynomial (Fin 3) ℝ) :
    gaussianPolynomialIntegral p = gaussianMoment p * gaussianMass ^ 3 := by
  induction p using MvPolynomial.induction_on' with
  | monomial a c =>
      rw [gaussianPolynomialIntegral_monomial, gaussianMoment_monomial]
  | add p q hp hq =>
      calc
        gaussianPolynomialIntegral (p + q) =
            gaussianPolynomialIntegral p + gaussianPolynomialIntegral q := by
          unfold gaussianPolynomialIntegral
          simp_rw [map_add, add_mul]
          rw [integral_add (integrable_gaussianPolynomial p)
            (integrable_gaussianPolynomial q)]
        _ = gaussianMoment (p + q) * gaussianMass ^ 3 := by
          rw [hp, hq, map_add, add_mul]

private lemma eval_smul_of_isHomogeneous {p : MvPolynomial (Fin 3) ℝ} {d : ℕ}
    (hp : p.IsHomogeneous d) (r : ℝ) (x : Fin 3 → ℝ) :
    eval (fun i => r * x i) p = r ^ d * eval x p := by
  induction hp using IsWeightedHomogeneous.induction_on with
  | zero => simp
  | add p q _ _ hp hq => simp only [map_add, hp, hq, mul_add]
  | monomial a c ha =>
      simp only [eval_monomial]
      simp_rw [Finsupp.prod_fintype _ _ (fun _ => pow_zero _), mul_pow,
        Finset.prod_mul_distrib]
      rw [Finset.prod_pow_eq_pow_sum]
      have ha' : ∑ i, a i = d := by
        simpa [Finsupp.weight_apply, Finsupp.sum_fintype] using ha
      rw [ha']
      ring

private noncomputable def radialMoment (d : ℕ) : ℝ :=
  ∫ r in Ioi (0 : ℝ), r ^ (d + 2) * gaussianKernel r

private lemma radialMoment_formula (d : ℕ) :
    radialMoment d =
      (1 / 2 : ℝ) ^ (-(d + 2 + 1 : ℝ) / 2) * (1 / 2 : ℝ) *
        Real.Gamma ((d + 2 + 1 : ℝ) / 2) := by
  have h := integral_rpow_mul_exp_neg_mul_rpow (p := (2 : ℝ)) (q := (d + 2 : ℝ))
    (b := (1 / 2 : ℝ)) (by norm_num)
      (by have hd : (0 : ℝ) ≤ d := Nat.cast_nonneg d; linarith) (by norm_num)
  unfold radialMoment gaussianKernel
  convert h using 1
  apply setIntegral_congr_fun measurableSet_Ioi
  intro r hr
  change r ^ (d + 2 : ℕ) * Real.exp (-(1 / 2 : ℝ) * r ^ 2) =
    r ^ (d + 2 : ℝ) * Real.exp (-(1 / 2 : ℝ) * r ^ 2)
  congr 1
  rw [show (d + 2 : ℝ) = ((d + 2 : ℕ) : ℝ) by norm_num, Real.rpow_natCast]
  exact congrArg Real.exp <| congrArg (fun z : ℝ => -(1 / 2 : ℝ) * z)
    (Real.rpow_two r).symm

private lemma radialMoment_add_two (d : ℕ) :
    radialMoment (d + 2) = (d + 3 : ℝ) * radialMoment d := by
  rw [radialMoment_formula, radialMoment_formula]
  have harg : ((d + 2 : ℕ) : ℝ) + 2 + 1 = (d : ℝ) + 2 + 1 + 2 := by
    push_cast
    ring
  rw [show (((d + 2 : ℕ) : ℝ) + 2 + 1) / 2 =
      ((d : ℝ) + 2 + 1) / 2 + 1 by rw [harg]; ring,
    Real.Gamma_add_one (by positivity : ((d : ℝ) + 2 + 1) / 2 ≠ 0)]
  have hbase : (0 : ℝ) < 1 / 2 := by norm_num
  rw [show -(((d + 2 : ℕ) : ℝ) + 2 + 1) / 2 =
      -((d : ℝ) + 2 + 1) / 2 - 1 by rw [harg]; ring,
    Real.rpow_sub_one hbase.ne']
  field_simp
  ring

private lemma radialMoment_two_mul (k : ℕ) :
    radialMoment (2 * k) = momentFactor (2 * k + 2) * radialMoment 0 := by
  induction k with
  | zero => simp [momentFactor]
  | succ k hk =>
      rw [show 2 * (k + 1) = 2 * k + 2 by omega, radialMoment_add_two, hk]
      rw [momentFactor_add_two (2 * k + 2)]
      push_cast
      ring

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
