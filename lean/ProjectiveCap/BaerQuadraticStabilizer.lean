import ProjectiveCap.BaerQuadraticUntwist
import ProjectiveCap.QuadraticNullCone

/-!
# Parabolic Baer obstruction

The null-cone stabilizer theorem is proved locally by untwisting the semilinear pullback and applying
quadratic null-cone rigidity in dimension at least five.  The resulting semisimilitude multiplier
feeds the already-formalized quadratic descent and fixed-point obstruction.
-/

namespace ProjectiveCap
namespace Projective
namespace BaerSemilinear

variable (F K : Type*) [Field F] [Fintype F] [Field K] [Fintype K] [Algebra F K]

omit [Fintype F] [Fintype K] in
/-- Membership in a projective quadric can be checked on any chosen nonzero representative. -/
theorem onQuadraticForm_mk_iff
    {V : Type*} [AddCommGroup V] [Module K V]
    (Q : QuadraticForm K V) {v : V} (hv : v ≠ 0) :
    OnQuadraticForm Q (Projectivization.mk K v hv) ↔ Q v = 0 := by
  constructor
  · intro hp
    have hrep := Projectivization.mk_rep (Projectivization.mk K v hv)
    obtain ⟨a, ha⟩ :=
      (Projectivization.mk_eq_mk_iff' K (Projectivization.mk K v hv).rep v
        (Projectivization.mk K v hv).rep_nonzero hv).mp hrep
    have ha0 : a ≠ 0 := by
      intro hzero
      apply (Projectivization.mk K v hv).rep_nonzero
      rw [← ha, hzero, zero_smul]
    unfold OnQuadraticForm at hp
    rw [← ha, QuadraticMap.map_smul] at hp
    exact (smul_eq_zero.mp hp).resolve_left (mul_ne_zero ha0 ha0)
  · exact onQuadraticForm_mk Q hv

/-- A relative-Frobenius semilinear map preserving the null cone of a nondegenerate quadratic form
in dimension at least five is a semisimilitude. -/
theorem exists_semisimilitudeMultiplier_of_preserves_zeroLocus
    {V : Type*} [AddCommGroup V] [Module K V] [FiniteDimensional K V]
    (hfinrank : Module.finrank F K = 2)
    (hchar : ringChar K ≠ 2) (hdim : 5 ≤ Module.finrank K V)
    (Q : QuadraticForm K V) (hQ : Q.Nondegenerate)
    (S : V →ₛₗ[FiniteHermitian.conjRingHom F K] V)
    (hzero : ∀ v, Q (S v) = 0 ↔ Q v = 0) :
    ∃ μ : K, μ ≠ 0 ∧ ∀ v, Q (S v) = μ * FiniteHermitian.conj F K (Q v) := by
  obtain ⟨c, hc, hform⟩ :=
    QuadraticNullCone.exists_nonzero_smul_eq_of_same_zeroLocus hchar hdim Q hQ
      (conjugatePullbackQuadraticForm F K hfinrank Q S) (fun v => by
        rw [conjugatePullbackQuadraticForm_eq_zero_iff]
        exact hzero v)
  exact exists_semisimilitudeMultiplier_of_conjugatePullback_eq_smul F K
    hfinrank Q S hc hform

/-- Coordinate Frobenius preserving a
nondegenerate quadratic zero locus fixes a point on that quadric in dimension at least five. -/
theorem hasFixedPointOn_quadric_of_coordinate_preserves_zeroLocus {n : ℕ}
    (hfinrank : Module.finrank F K = 2) (hchar : ringChar F ≠ 2) (hdim : 5 ≤ n)
    (Q : QuadraticForm K (Fin n → K)) (hQ : Q.Nondegenerate) (hQne : Q ≠ 0)
    (hzero : ∀ v, Q (coordinateFrobenius F K n v) = 0 ↔ Q v = 0) :
    HasFixedPointOn (OnQuadraticForm Q) (projectiveCoordinateFrobenius F K n hfinrank) := by
  have hcharK : ringChar K ≠ 2 := by
    rwa [← Algebra.ringChar_eq F K]
  obtain ⟨μ, _, hsemi⟩ :=
    exists_semisimilitudeMultiplier_of_preserves_zeroLocus F K
      hfinrank hcharK (by simpa using hdim) Q hQ
      (coordinateFrobenius F K n) hzero
  exact hasFixedPointOn_quadric_of_coordinate_semisimilitude F K hfinrank hchar (by omega)
    Q hQne μ hsemi

/-- A conditional closure of the coordinate parabolic Baer branch from zero-locus preservation. -/
theorem parabolic_coordinate_zeroLocus_route_not_fixedPointFree {m : ℕ} (hm : 2 ≤ m)
    (hfinrank : Module.finrank F K = 2) (hchar : ringChar F ≠ 2)
    (Q : QuadraticForm K (Fin (2 * m + 1) → K))
    (hQ : Q.Nondegenerate) (hQne : Q ≠ 0)
    (hzero : ∀ v,
      Q (coordinateFrobenius F K (2 * m + 1) v) = 0 ↔ Q v = 0) :
    ¬ FixedPointFreeOn (OnQuadraticForm Q)
        (projectiveCoordinateFrobenius F K (2 * m + 1) hfinrank) := by
  apply not_fixedPointFreeOn_of_hasFixedPointOn
  exact hasFixedPointOn_quadric_of_coordinate_preserves_zeroLocus F K hfinrank hchar
    (by omega) Q hQ hQne hzero

/-- Full Baer-semilinear parabolic obstruction in vector dimension at least five.  A projective
order-two relative-Frobenius representative preserving a nondegenerate quadric cannot act
fixed-point-freely on it. -/
theorem parabolic_baer_route_not_fixedPointFree
    {V : Type*} [AddCommGroup V] [Module K V] [FiniteDimensional K V] [Nontrivial V]
    (hfinrank : Module.finrank F K = 2) (hchar : ringChar F ≠ 2)
    (hdim : 5 ≤ Module.finrank K V)
    (Q : QuadraticForm K V) (hQ : Q.Nondegenerate)
    (S : V →ₛₗ[FiniteHermitian.conjRingHom F K] V) (c : K) (hc : c ≠ 0)
    (hS : ∀ v, S (S v) = c • v)
    (hzero : ∀ v, Q (S v) = 0 ↔ Q v = 0) :
    ¬ FixedPointFreeOn (OnQuadraticForm Q)
        (projectiveSemilinearSqScalar F K S c hc hS) := by
  let n := Module.finrank K V
  obtain ⟨e, he⟩ := exists_projectiveEquiv_conjugacy_of_sq_scalar F K hfinrank S c hc hS
  let Q₀ : QuadraticForm K (Fin n → K) := Q.comp e.toLinearMap
  have hcharK : ringChar K ≠ 2 := by
    rwa [← Algebra.ringChar_eq F K]
  letI : Invertible (2 : K) := invertibleOfNonzero (Ring.two_ne_zero hcharK)
  have hQ₀ : Q₀.Nondegenerate := by
    apply QuadraticMap.nondegenerate_polar_iff.mp
    have hp : Q₀.polarBilin = LinearMap.BilinForm.congr e.symm Q.polarBilin := by
      ext x y
      simp [Q₀, QuadraticMap.polarBilin_comp]
    rw [hp]
    exact LinearMap.BilinForm.Nondegenerate.congr e.symm
      (QuadraticMap.nondegenerate_polar_iff.mpr hQ)
  have hzero₀ (v : Fin n → K) :
      Q₀ (coordinateFrobenius F K n v) = 0 ↔ Q₀ v = 0 := by
    by_cases hv : v = 0
    · subst v
      simp
    have hev : e v ≠ 0 := by simpa using e.injective.ne hv
    have hSv : S (e v) ≠ 0 := by
      simpa using (injective_of_sq_smul S hc hS).ne hev
    have hcv : coordinateFrobenius F K n v ≠ 0 :=
      by simpa using (coordinateFrobenius_injective F K n).ne hv
    have hecv : e (coordinateFrobenius F K n v) ≠ 0 := by
      simpa using e.injective.ne hcv
    have hproj := he (Projectivization.mk K v hv)
    simp only [mapLinearEquiv_mk, projectiveSemilinearSqScalar_apply,
      projectiveCoordinateFrobenius_apply, Projectivization.map_mk] at hproj
    have hpiff : Q (S (e v)) = 0 ↔ Q (e (coordinateFrobenius F K n v)) = 0 := by
      rw [← onQuadraticForm_mk_iff K Q hSv,
        ← onQuadraticForm_mk_iff K Q hecv, hproj]
    change Q (e (coordinateFrobenius F K n v)) = 0 ↔ Q (e v) = 0
    exact hpiff.symm.trans (hzero (e v))
  have hQ₀ne : Q₀ ≠ 0 := by
    obtain ⟨x, y, _, _, hQx, hQy, hxy⟩ :=
      QuadraticNullCone.exists_normalized_isotropic_pair hcharK Q₀ hQ₀ (by
        simpa only [n, Module.finrank_fin_fun] using hdim.trans' (by omega))
    intro hzeroForm
    have hxyQ : Q₀ (x + y) = 1 := by
      rw [QuadraticMap.map_add Q₀, hQx, hQy, hxy]
      simp
    have := QuadraticMap.congr_fun hzeroForm (x + y)
    simp [hxyQ] at this
  have hfixed₀ :
      HasFixedPointOn (OnQuadraticForm Q₀)
        (projectiveCoordinateFrobenius F K n hfinrank) :=
    hasFixedPointOn_quadric_of_coordinate_preserves_zeroLocus F K hfinrank hchar
      (by simpa only [n] using hdim) Q₀ hQ₀ hQ₀ne hzero₀
  have hfixed :
      HasFixedPointOn (OnQuadraticForm Q)
        (projectiveSemilinearSqScalar F K S c hc hS) := by
    apply hasFixedPointOn_of_conjugate K (OnQuadraticForm Q₀) (OnQuadraticForm Q)
      (projectiveCoordinateFrobenius F K n hfinrank)
      (projectiveSemilinearSqScalar F K S c hc hS) (mapLinearEquiv e) he
    · intro p hp
      induction p using Projectivization.ind with
      | h v hv =>
          rw [mapLinearEquiv_mk]
          have hev : e v ≠ 0 := by simpa using e.injective.ne hv
          apply (onQuadraticForm_mk_iff K Q hev).2
          exact (onQuadraticForm_mk_iff K Q₀ hv).1 hp
    · exact hfixed₀
  exact not_fixedPointFreeOn_of_hasFixedPointOn hfixed

/-- Projective-board formulation of the full Baer-semilinear parabolic obstruction. -/
theorem parabolic_baer_boardStabilizer_not_fixedPointFree
    {V : Type*} [AddCommGroup V] [Module K V] [FiniteDimensional K V] [Nontrivial V]
    (hfinrank : Module.finrank F K = 2) (hchar : ringChar F ≠ 2)
    (hdim : 5 ≤ Module.finrank K V)
    (Q : QuadraticForm K V) (hQ : Q.Nondegenerate)
    (S : V →ₛₗ[FiniteHermitian.conjRingHom F K] V) (c : K) (hc : c ≠ 0)
    (hS : ∀ v, S (S v) = c • v)
    (hboard : ∀ x,
      OnQuadraticForm Q (projectiveSemilinearSqScalar F K S c hc hS x) ↔
        OnQuadraticForm Q x) :
    ¬ FixedPointFreeOn (OnQuadraticForm Q)
        (projectiveSemilinearSqScalar F K S c hc hS) := by
  apply parabolic_baer_route_not_fixedPointFree F K hfinrank hchar hdim Q hQ S c hc hS
  intro v
  by_cases hv : v = 0
  · subst v
    simp
  have hSv : S v ≠ 0 := by
    simpa using (injective_of_sq_smul S hc hS).ne hv
  have hp := hboard (Projectivization.mk K v hv)
  simp only [projectiveSemilinearSqScalar_apply, Projectivization.map_mk] at hp
  rw [onQuadraticForm_mk_iff K Q hSv, onQuadraticForm_mk_iff K Q hv] at hp
  exact hp

end BaerSemilinear
end Projective
end ProjectiveCap
