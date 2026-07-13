import ProjectiveCap.BaerSemilinear

/-!
# Quadratic-form descent for Baer involutions

This file develops the form-theoretic half of the parabolic Baer obstruction.  It first normalizes
a coordinate-Frobenius semisimilitude by the order-two scalar Hilbert-90 calculation, then descends
the normalized quadratic form to the Frobenius fixed field.
-/

namespace ProjectiveCap
namespace Projective
namespace BaerSemilinear

variable (F K : Type*) [Field F] [Fintype F] [Field K] [Fintype K] [Algebra F K]

/-- Elementary order-two scalar Hilbert 90 in the orientation needed to normalize a form. -/
theorem exists_conj_eq_mul_of_conj_mul_eq_one
    (hfinrank : Module.finrank F K = 2) {μ : K}
    (hμ : FiniteHermitian.conj F K μ * μ = 1) :
    ∃ a : K, a ≠ 0 ∧ FiniteHermitian.conj F K a = a * μ := by
  by_cases hneg : μ = -1
  · obtain ⟨β, hβ⟩ := exists_ne_conj F K hfinrank
    let a := β - FiniteHermitian.conj F K β
    have ha : a ≠ 0 := sub_ne_zero.mpr hβ
    refine ⟨a, ha, ?_⟩
    simp only [a, map_sub, conj_involutive F K hfinrank β, hneg, mul_neg, mul_one]
    ring
  · let a := 1 + FiniteHermitian.conj F K μ
    have ha : a ≠ 0 := by
      intro hzero
      have hconjμ : FiniteHermitian.conj F K μ = -1 := by
        dsimp only [a] at hzero
        linear_combination hzero
      have := congrArg (FiniteHermitian.conj F K) hconjμ
      simp only [conj_involutive F K hfinrank μ, map_neg, map_one] at this
      exact hneg this
    refine ⟨a, ha, ?_⟩
    simp only [a, map_add, map_one, conj_involutive F K hfinrank μ]
    calc
      1 + μ = (1 + FiniteHermitian.conj F K μ) * μ := by
        rw [add_mul, one_mul, hμ, add_comm]

/-- The base-field value of a quadratic form known to be Frobenius-fixed on base-coordinate
vectors. -/
noncomputable def descendedQuadraticValue {n : ℕ}
    (hfinrank : Module.finrank F K = 2)
    (Q : QuadraticForm K (Fin n → K))
    (hfixed : ∀ v : Fin n → F,
      FiniteHermitian.conj F K (Q (baseLift F K n v)) = Q (baseLift F K n v))
    (v : Fin n → F) : F :=
  (exists_algebraMap_eq_of_conj_eq F K hfinrank (hfixed v)).choose

theorem algebraMap_descendedQuadraticValue {n : ℕ}
    (hfinrank : Module.finrank F K = 2)
    (Q : QuadraticForm K (Fin n → K))
    (hfixed : ∀ v : Fin n → F,
      FiniteHermitian.conj F K (Q (baseLift F K n v)) = Q (baseLift F K n v))
    (v : Fin n → F) :
    algebraMap F K (descendedQuadraticValue F K hfinrank Q hfixed v) =
      Q (baseLift F K n v) :=
  (exists_algebraMap_eq_of_conj_eq F K hfinrank (hfixed v)).choose_spec

/-- A quadratic form whose base-coordinate values are Frobenius-fixed descends to a quadratic form
over the base field. -/
noncomputable def descendedQuadraticForm {n : ℕ}
    (hfinrank : Module.finrank F K = 2)
    (Q : QuadraticForm K (Fin n → K))
    (hfixed : ∀ v : Fin n → F,
      FiniteHermitian.conj F K (Q (baseLift F K n v)) = Q (baseLift F K n v)) :
    QuadraticForm F (Fin n → F) :=
  QuadraticMap.ofPolar (descendedQuadraticValue F K hfinrank Q hfixed)
    (fun a x => by
      apply (algebraMap F K).injective
      simp only [smul_eq_mul, map_mul,
        algebraMap_descendedQuadraticValue F K hfinrank Q hfixed]
      rw [baseLift_smul, QuadraticMap.map_smul]
      simp [smul_eq_mul])
    (fun x x' y => by
      apply (algebraMap F K).injective
      simp only [QuadraticMap.polar, map_sub, map_add,
        algebraMap_descendedQuadraticValue F K hfinrank Q hfixed, baseLift_add]
      exact Q.polar_add_left _ _ _)
    (fun a x y => by
      apply (algebraMap F K).injective
      simp only [QuadraticMap.polar, smul_eq_mul, map_sub, map_mul,
        algebraMap_descendedQuadraticValue F K hfinrank Q hfixed,
        baseLift_add, baseLift_smul]
      change QuadraticMap.polar Q ((algebraMap F K a) • baseLift F K n x)
          (baseLift F K n y) =
        algebraMap F K a * QuadraticMap.polar Q (baseLift F K n x) (baseLift F K n y)
      simpa [smul_eq_mul] using Q.polar_smul_left (algebraMap F K a) (baseLift F K n x)
        (baseLift F K n y))

@[simp]
theorem algebraMap_descendedQuadraticForm {n : ℕ}
    (hfinrank : Module.finrank F K = 2)
    (Q : QuadraticForm K (Fin n → K))
    (hfixed : ∀ v : Fin n → F,
      FiniteHermitian.conj F K (Q (baseLift F K n v)) = Q (baseLift F K n v))
    (v : Fin n → F) :
    algebraMap F K (descendedQuadraticForm F K hfinrank Q hfixed v) =
      Q (baseLift F K n v) :=
  algebraMap_descendedQuadraticValue F K hfinrank Q hfixed v

/-- The multiplier of a nonzero quadratic Frobenius-semisimilitude has norm one. -/
theorem conj_mul_eq_one_of_quadratic_semisimilitude {n : ℕ}
    (hfinrank : Module.finrank F K = 2)
    (Q : QuadraticForm K (Fin n → K)) (hQ : Q ≠ 0) (μ : K)
    (hsemi : ∀ v,
      Q (coordinateFrobenius F K n v) = μ * FiniteHermitian.conj F K (Q v)) :
    FiniteHermitian.conj F K μ * μ = 1 := by
  obtain ⟨v, hQv⟩ : ∃ v, Q v ≠ 0 := by
    by_contra! hzero
    apply hQ
    ext v
    simpa using hzero v
  have htwice := hsemi (coordinateFrobenius F K n v)
  rw [coordinateFrobenius_involutive F K n hfinrank v, hsemi] at htwice
  simp only [map_mul, conj_involutive F K hfinrank (Q v)] at htwice
  apply mul_right_cancel₀ hQv
  calc
    (FiniteHermitian.conj F K μ * μ) * Q v =
        μ * (FiniteHermitian.conj F K μ * Q v) := by ring
    _ = Q v := htwice.symm
    _ = 1 * Q v := by rw [one_mul]

/-- A coordinate Frobenius semisimilitude of a nonzero quadratic form in dimension at least three
fixes a point on its projective quadric. -/
theorem hasFixedPointOn_quadric_of_coordinate_semisimilitude {n : ℕ}
    (hfinrank : Module.finrank F K = 2) (hchar : ringChar F ≠ 2)
    (hdim : 3 ≤ n) (Q : QuadraticForm K (Fin n → K)) (hQ : Q ≠ 0) (μ : K)
    (hsemi : ∀ v,
      Q (coordinateFrobenius F K n v) = μ * FiniteHermitian.conj F K (Q v)) :
    HasFixedPointOn (OnQuadraticForm Q) (projectiveCoordinateFrobenius F K n hfinrank) := by
  have hnorm := conj_mul_eq_one_of_quadratic_semisimilitude F K hfinrank Q hQ μ hsemi
  obtain ⟨a, ha, hconjA⟩ := exists_conj_eq_mul_of_conj_mul_eq_one F K hfinrank hnorm
  let Qa : QuadraticForm K (Fin n → K) := a • Q
  have hfixed (v : Fin n → F) :
      FiniteHermitian.conj F K (Qa (baseLift F K n v)) = Qa (baseLift F K n v) := by
    have hsemiBase := hsemi (baseLift F K n v)
    rw [coordinateFrobenius_baseLift] at hsemiBase
    change FiniteHermitian.conj F K (a * Q (baseLift F K n v)) =
      a * Q (baseLift F K n v)
    calc
      FiniteHermitian.conj F K (a * Q (baseLift F K n v)) =
          FiniteHermitian.conj F K a * FiniteHermitian.conj F K (Q (baseLift F K n v)) :=
        map_mul _ _ _
      _ = a * (μ * FiniteHermitian.conj F K (Q (baseLift F K n v))) := by
        rw [hconjA]
        ring
      _ = a * Q (baseLift F K n v) := by rw [← hsemiBase]
  let QF := descendedQuadraticForm F K hfinrank Qa hfixed
  obtain ⟨v, hv, hQv⟩ :=
    FiniteQuadraticIsotropy.exists_ne_zero_quadraticForm_eq_zero hchar QF (by
      simpa only [Module.finrank_fin_fun] using hdim)
  have hz : baseLift F K n v ≠ 0 := baseLift_ne_zero F K n hv
  have hQa : Qa (baseLift F K n v) = 0 := by
    have hdesc := algebraMap_descendedQuadraticForm F K hfinrank Qa hfixed v
    rw [hQv, map_zero] at hdesc
    exact hdesc.symm
  have hQbase : Q (baseLift F K n v) = 0 := by
    change a * Q (baseLift F K n v) = 0 at hQa
    exact (mul_eq_zero.mp hQa).resolve_left ha
  refine ⟨Projectivization.mk K (baseLift F K n v) hz,
    onQuadraticForm_mk Q hz hQbase, ?_⟩
  exact projectiveCoordinateFrobenius_fixed_baseLift F K n hfinrank hv

/-- Coordinate semisimilitude obstruction for a descended parabolic-dimensional quadratic board. -/
theorem parabolic_coordinate_semisimilitude_route_not_fixedPointFree {m : ℕ} (hm : 1 ≤ m)
    (hfinrank : Module.finrank F K = 2) (hchar : ringChar F ≠ 2)
    (Q : QuadraticForm K (Fin (2 * m + 1) → K)) (hQ : Q ≠ 0) (μ : K)
    (hsemi : ∀ v,
      Q (coordinateFrobenius F K (2 * m + 1) v) =
        μ * FiniteHermitian.conj F K (Q v)) :
    ¬ FixedPointFreeOn (OnQuadraticForm Q)
        (projectiveCoordinateFrobenius F K (2 * m + 1) hfinrank) := by
  apply not_fixedPointFreeOn_of_hasFixedPointOn
  apply hasFixedPointOn_quadric_of_coordinate_semisimilitude F K hfinrank hchar (by omega)
    Q hQ μ hsemi

end BaerSemilinear
end Projective
end ProjectiveCap
