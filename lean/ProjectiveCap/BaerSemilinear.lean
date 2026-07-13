import ProjectiveCap.MirrorBoundary

/-!
# The coordinate Baer involution

This file isolates the part of the Baer-semilinear boundary argument that does not require a
classification theorem.  Over a quadratic finite-field extension, coordinatewise relative
Frobenius induces a projective involution.  Every point represented by a vector over the base
field is fixed.  Consequently, a quadratic or Hermitian board whose restriction to those vectors
is a base-field quadratic form has a fixed point as soon as that restricted form has dimension at
least three.

Reducing an arbitrary order-two semilinear collineation to this coordinate model is a separate
nonabelian Galois-descent statement; it is deliberately not assumed here.
-/

open scoped LinearAlgebra.Projectivization

namespace ProjectiveCap
namespace Projective
namespace BaerSemilinear

variable (F K : Type*) [Field F] [Fintype F] [Field K] [Fintype K] [Algebra F K]

/-- Coordinatewise relative Frobenius as a semilinear map. -/
noncomputable def coordinateFrobenius (n : ℕ) :
    (Fin n → K) →ₛₗ[FiniteHermitian.conjRingHom F K] (Fin n → K) where
  toFun v i := FiniteHermitian.conj F K (v i)
  map_add' x y := by ext i; simp
  map_smul' c x := by ext i; simp [FiniteHermitian.conjRingHom]

theorem coordinateFrobenius_injective (n : ℕ) :
    Function.Injective (coordinateFrobenius F K n) := by
  intro x y h
  ext i
  exact (FiniteHermitian.conj F K).injective (congrFun h i)

/-- Relative Frobenius is an involution when the extension degree is two. -/
theorem conj_involutive (hfinrank : Module.finrank F K = 2) :
    Function.Involutive (FiniteHermitian.conj F K) := by
  intro x
  have hpow : (FiniteHermitian.conj F K) ^ 2 = 1 := by
    rw [← hfinrank, ← FiniteField.orderOf_frobeniusAlgEquivOfAlgebraic]
    exact pow_orderOf_eq_one _
  exact DFunLike.congr_fun hpow x

theorem coordinateFrobenius_involutive (n : ℕ)
    (hfinrank : Module.finrank F K = 2) :
    Function.Involutive (coordinateFrobenius F K n) := by
  intro v
  ext i
  exact conj_involutive F K hfinrank (v i)

/-- The projective involution induced by coordinatewise relative Frobenius. -/
noncomputable def projectiveCoordinateFrobenius (n : ℕ)
    (hfinrank : Module.finrank F K = 2) :
    Point K (Fin n → K) ≃ Point K (Fin n → K) :=
  let f := Projectivization.map (coordinateFrobenius F K n)
    (coordinateFrobenius_injective F K n)
  let hinv : Function.Involutive f := by
      intro x
      induction x using Projectivization.ind with
      | h v hv =>
          dsimp only [f]
          rw [Projectivization.map_mk, Projectivization.map_mk]
          have hne : coordinateFrobenius F K n (coordinateFrobenius F K n v) ≠ 0 := by
            rw [coordinateFrobenius_involutive F K n hfinrank v]
            exact hv
          apply (Projectivization.mk_eq_mk_iff' K _ v hne hv).mpr
          exact ⟨1, by simp [coordinateFrobenius_involutive F K n hfinrank v]⟩
  { toFun := f
    invFun := f
    left_inv := hinv
    right_inv := hinv }

@[simp]
theorem projectiveCoordinateFrobenius_apply (n : ℕ)
    (hfinrank : Module.finrank F K = 2) (x : Point K (Fin n → K)) :
    projectiveCoordinateFrobenius F K n hfinrank x =
      Projectivization.map (coordinateFrobenius F K n)
        (coordinateFrobenius_injective F K n) x := rfl

/-- Coordinatewise inclusion of the base vector space into the extension vector space. -/
def baseLift (n : ℕ) (v : Fin n → F) : Fin n → K :=
  fun i => algebraMap F K (v i)

omit [Fintype F] [Fintype K] in
theorem baseLift_injective (n : ℕ) : Function.Injective (baseLift F K n) := by
  intro x y h
  ext i
  exact (algebraMap F K).injective (congrFun h i)

omit [Fintype F] [Fintype K] in
theorem baseLift_ne_zero (n : ℕ) {v : Fin n → F} (hv : v ≠ 0) :
    baseLift F K n v ≠ 0 := by
  intro h
  apply hv
  apply baseLift_injective F K n
  rw [h]
  ext i
  simp [baseLift]

@[simp]
theorem coordinateFrobenius_baseLift (n : ℕ) (v : Fin n → F) :
    coordinateFrobenius F K n (baseLift F K n v) = baseLift F K n v := by
  ext i
  exact (FiniteHermitian.conj F K).commutes (v i)

/-- The base-field value of a Hermitian form on a base-coordinate vector. -/
noncomputable def hermitianBaseValue {n : ℕ}
    (B : FiniteHermitian.Form (F := F) (K := K) (V := Fin n → K))
    (hB : FiniteHermitian.IsHermitian B) (v : Fin n → F) : F :=
  (hB.diagonal_mem_base (baseLift F K n v)).choose

theorem algebraMap_hermitianBaseValue {n : ℕ}
    (B : FiniteHermitian.Form (F := F) (K := K) (V := Fin n → K))
    (hB : FiniteHermitian.IsHermitian B) (v : Fin n → F) :
    algebraMap F K (hermitianBaseValue F K B hB v) =
      B (baseLift F K n v) (baseLift F K n v) :=
  (hB.diagonal_mem_base (baseLift F K n v)).choose_spec

omit [Fintype F] [Fintype K] in
theorem baseLift_smul {n : ℕ} (a : F) (v : Fin n → F) :
    baseLift F K n (a • v) = algebraMap F K a • baseLift F K n v := by
  ext i
  simp [baseLift]

omit [Fintype F] [Fintype K] in
theorem baseLift_add {n : ℕ} (v w : Fin n → F) :
    baseLift F K n (v + w) = baseLift F K n v + baseLift F K n w := by
  ext i
  simp [baseLift]

/-- Restricting a Hermitian diagonal to base-coordinate vectors gives a quadratic form over the
fixed field.  This construction removes any separate descent hypothesis from the coordinate
Hermitian intersection theorem. -/
noncomputable def hermitianBaseQuadraticForm {n : ℕ}
    (B : FiniteHermitian.Form (F := F) (K := K) (V := Fin n → K))
    (hB : FiniteHermitian.IsHermitian B) : QuadraticForm F (Fin n → F) :=
  QuadraticMap.ofPolar (hermitianBaseValue F K B hB)
    (fun a x => by
      apply (algebraMap F K).injective
      simp only [smul_eq_mul, map_mul, algebraMap_hermitianBaseValue]
      rw [baseLift_smul]
      simp only [LinearMap.map_smulₛₗ, FiniteHermitian.conjRingHom_apply, map_smul,
        LinearMap.smul_apply, smul_eq_mul]
      rw [(FiniteHermitian.conj F K).commutes]
      ring)
    (fun x x' y => by
      apply (algebraMap F K).injective
      simp only [QuadraticMap.polar, map_sub, map_add, algebraMap_hermitianBaseValue,
        baseLift_add]
      simp only [LinearMap.add_apply]
      ring)
    (fun a x y => by
      apply (algebraMap F K).injective
      simp only [QuadraticMap.polar, smul_eq_mul, map_sub, map_add, map_mul,
        algebraMap_hermitianBaseValue, baseLift_add, baseLift_smul]
      simp only [LinearMap.add_apply,
        LinearMap.map_smulₛₗ, FiniteHermitian.conjRingHom_apply, map_smul,
        LinearMap.smul_apply, smul_eq_mul]
      rw [(FiniteHermitian.conj F K).commutes]
      ring)

@[simp]
theorem algebraMap_hermitianBaseQuadraticForm {n : ℕ}
    (B : FiniteHermitian.Form (F := F) (K := K) (V := Fin n → K))
    (hB : FiniteHermitian.IsHermitian B) (v : Fin n → F) :
    algebraMap F K (hermitianBaseQuadraticForm F K B hB v) =
      B (baseLift F K n v) (baseLift F K n v) :=
  algebraMap_hermitianBaseValue F K B hB v

theorem projectiveCoordinateFrobenius_fixed_baseLift (n : ℕ)
    (hfinrank : Module.finrank F K = 2) {v : Fin n → F} (hv : v ≠ 0) :
    projectiveCoordinateFrobenius F K n hfinrank
        (Projectivization.mk K (baseLift F K n v) (baseLift_ne_zero F K n hv)) =
      Projectivization.mk K (baseLift F K n v) (baseLift_ne_zero F K n hv) := by
  rw [projectiveCoordinateFrobenius_apply]
  rw [Projectivization.map_mk]
  apply (Projectivization.mk_eq_mk_iff' K
    (coordinateFrobenius F K n (baseLift F K n v)) (baseLift F K n v)
    (by rw [coordinateFrobenius_baseLift]; exact baseLift_ne_zero F K n hv)
    (baseLift_ne_zero F K n hv)).mpr
  exact ⟨1, by simp [coordinateFrobenius_baseLift F K n v]⟩

omit [Fintype K] in
/-- Fixed points transfer through a projective conjugacy, provided the conjugacy carries the
coordinate-model board into the target board.  This is the exact interface needed from a future
classification/descent theorem for a general Baer-semilinear collineation. -/
theorem hasFixedPointOn_of_conjugate {n : ℕ}
    {W : Type*} [AddCommGroup W] [Module K W]
    (Q₀ : Point K (Fin n → K) → Prop) (Q : Point K W → Prop)
    (τ : Point K (Fin n → K) ≃ Point K (Fin n → K)) (σ : Point K W ≃ Point K W)
    (e : Point K (Fin n → K) ≃ Point K W)
    (hconj : ∀ x, σ (e x) = e (τ x)) (hboard : ∀ x, Q₀ x → Q (e x))
    (hfixed : HasFixedPointOn Q₀ τ) : HasFixedPointOn Q σ := by
  obtain ⟨x, hxQ, hxfix⟩ := hfixed
  refine ⟨e x, hboard x hxQ, ?_⟩
  rw [hconj, hxfix]

/-- A descended zero locus meets the fixed Baer subgeometry.  The compatibility hypothesis is the
precise descent datum used by this coordinate argument. -/
theorem hasFixedPointOn_descended_quadraticForm {n : ℕ}
    (hfinrank : Module.finrank F K = 2) (hchar : ringChar F ≠ 2)
    (QF : QuadraticForm F (Fin n → F)) (QK : QuadraticForm K (Fin n → K))
    (hrestrict : ∀ v, QK (baseLift F K n v) = algebraMap F K (QF v))
    (hdim : 3 ≤ n) :
    HasFixedPointOn (OnQuadraticForm QK) (projectiveCoordinateFrobenius F K n hfinrank) := by
  obtain ⟨v, hv, hQv⟩ :=
    FiniteQuadraticIsotropy.exists_ne_zero_quadraticForm_eq_zero hchar QF (by simpa using hdim)
  let hvK : baseLift F K n v ≠ 0 := baseLift_ne_zero F K n hv
  refine ⟨Projectivization.mk K (baseLift F K n v) hvK, ?_, ?_⟩
  · apply onQuadraticForm_mk QK hvK
    rw [hrestrict, hQv, map_zero]
  · exact projectiveCoordinateFrobenius_fixed_baseLift F K n hfinrank hv

/-- Coordinate-Frobenius obstruction for a descended parabolic board. -/
theorem parabolic_coordinate_baer_route_not_fixedPointFree {m : ℕ} (hm : 1 ≤ m)
    (hfinrank : Module.finrank F K = 2) (hchar : ringChar F ≠ 2)
    (QF : QuadraticForm F (Fin (2 * m + 1) → F))
    (QK : QuadraticForm K (Fin (2 * m + 1) → K))
    (hrestrict : ∀ v, QK (baseLift F K (2 * m + 1) v) = algebraMap F K (QF v)) :
    ¬ FixedPointFreeOn (OnQuadraticForm QK)
        (projectiveCoordinateFrobenius F K (2 * m + 1) hfinrank) := by
  apply not_fixedPointFreeOn_of_hasFixedPointOn
  apply hasFixedPointOn_descended_quadraticForm F K hfinrank hchar QF QK hrestrict
  omega

/-- Coordinate-Frobenius obstruction for a Hermitian board whose restriction to the fixed
base-coordinate space is represented by a quadratic form over the base field. -/
theorem hermitian_coordinate_baer_route_not_fixedPointFree_of_restriction
    {k : ℕ} (hk : 2 ≤ k)
    (hfinrank : Module.finrank F K = 2) (hchar : ringChar F ≠ 2)
    (QF : QuadraticForm F (Fin (k + 1) → F))
    (B : FiniteHermitian.Form (F := F) (K := K) (V := Fin (k + 1) → K))
    (hrestrict : ∀ v, B (baseLift F K (k + 1) v) (baseLift F K (k + 1) v) =
      algebraMap F K (QF v)) :
    ¬ FixedPointFreeOn (OnHermitianForm B)
        (projectiveCoordinateFrobenius F K (k + 1) hfinrank) := by
  apply not_fixedPointFreeOn_of_hasFixedPointOn
  obtain ⟨v, hv, hQv⟩ :=
    FiniteQuadraticIsotropy.exists_ne_zero_quadraticForm_eq_zero hchar QF (by
      simp only [Module.finrank_fin_fun]
      omega)
  let hvK : baseLift F K (k + 1) v ≠ 0 := baseLift_ne_zero F K (k + 1) hv
  refine ⟨Projectivization.mk K (baseLift F K (k + 1) v) hvK, ?_, ?_⟩
  · apply onHermitianForm_mk B hvK
    rw [hrestrict, hQv, map_zero]
  · exact projectiveCoordinateFrobenius_fixed_baseLift F K (k + 1) hfinrank hv

/-- Every coordinate Baer involution fixes a point on every nontrivial Hermitian board.  The
base-field quadratic restriction is constructed from the Hermitian axioms above, rather than
assumed as external descent data. -/
theorem hermitian_coordinate_baer_route_not_fixedPointFree {k : ℕ} (hk : 2 ≤ k)
    (hfinrank : Module.finrank F K = 2) (hchar : ringChar F ≠ 2)
    (B : FiniteHermitian.Form (F := F) (K := K) (V := Fin (k + 1) → K))
    (hB : FiniteHermitian.IsHermitian B) :
    ¬ FixedPointFreeOn (OnHermitianForm B)
        (projectiveCoordinateFrobenius F K (k + 1) hfinrank) := by
  apply hermitian_coordinate_baer_route_not_fixedPointFree_of_restriction F K hk hfinrank hchar
    (hermitianBaseQuadraticForm F K B hB) B
  intro v
  exact (algebraMap_hermitianBaseQuadraticForm F K B hB v).symm

end BaerSemilinear
end Projective
end ProjectiveCap
