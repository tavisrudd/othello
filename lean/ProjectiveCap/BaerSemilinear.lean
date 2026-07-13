import ProjectiveCap.MirrorBoundary
import Mathlib.FieldTheory.Galois.Basic
import Mathlib.LinearAlgebra.Basis.VectorSpace

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
open Module

namespace ProjectiveCap
namespace Projective
namespace BaerSemilinear

variable (F K : Type*) [Field F] [Fintype F] [Field K] [Fintype K] [Algebra F K]

section FixedVectors

variable {K V : Type*} [Field K] [AddCommGroup V] [Module K V]
variable {σ : K →+* K} (S : V →ₛₗ[σ] V)

/-- Vectors fixed literally, rather than merely projectively, by a semilinear map. -/
def fixedVectors : Set V := {v | S v = v}

/-- A semilinear map whose square is a nonzero scalar is injective. -/
theorem injective_of_sq_smul {c : K} (hc : c ≠ 0) (hS : ∀ v, S (S v) = c • v) :
    Function.Injective S := by
  intro u v huv
  have h := congrArg S huv
  rw [hS, hS] at h
  exact smul_right_injective V hc h

/-- The square scalar of a semilinear map is fixed by the scalar automorphism. -/
theorem scalar_fixed_of_sq_smul [Nontrivial V] {c : K} (hc : c ≠ 0)
    (hS : ∀ v, S (S v) = c • v) : σ c = c := by
  have hSinj : Function.Injective S := injective_of_sq_smul S hc hS
  obtain ⟨v, hv⟩ := exists_ne (0 : V)
  have hSv : S v ≠ 0 := by
    intro hzero
    exact hv (hSinj (by simpa using hzero))
  apply smul_left_injective K hSv
  calc
    σ c • S v = S (c • v) := (map_smulₛₗ S c v).symm
    _ = S (S (S v)) := (congrArg S (hS v)).symm
    _ = c • S v := hS (S v)

/-- For a nontrivial involutive scalar automorphism, the fixed vectors of an involutive
semilinear map span the entire vector space over the large field.  This is the constructive core
of nonabelian Hilbert 90 in the order-two case.

For each `v`, both `v + S v` and `β • v + S (β • v)` are fixed.  Since
`β ≠ σ β`, these two vectors recover `v` by a two-by-two scalar calculation. -/
theorem span_fixedVectors_eq_top (hS : Function.Involutive S) {β : K} (hβ : β ≠ σ β) :
    Submodule.span K (fixedVectors S) = ⊤ := by
  apply top_unique
  intro v _
  let u : V := v + S v
  let w : V := β • v + S (β • v)
  have hu : u ∈ fixedVectors S := by
    change S u = u
    simp only [u, map_add, hS v, add_comm]
  have hw : w ∈ fixedVectors S := by
    change S w = w
    simp only [w, map_add, hS (β • v), add_comm]
  have hu_span : u ∈ Submodule.span K (fixedVectors S) := Submodule.subset_span hu
  have hw_span : w ∈ Submodule.span K (fixedVectors S) := Submodule.subset_span hw
  let b : K := (β - σ β)⁻¹
  let a : K := -b * σ β
  have hdiff : β - σ β ≠ 0 := sub_ne_zero.mpr hβ
  have hab : a + b * β = 1 := by
    calc
      a + b * β = b * (β - σ β) := by simp only [a]; ring
      _ = 1 := by simp only [b]; exact inv_mul_cancel₀ hdiff
  have habσ : a + b * σ β = 0 := by simp only [a]; ring
  have hv : a • u + b • w = v := by
    calc
      a • u + b • w = (a + b * β) • v + (a + b * σ β) • S v := by
        simp only [u, w, map_smulₛₗ, smul_add, smul_smul]
        module
      _ = v := by rw [hab, habσ, one_smul, zero_smul, add_zero]
  rw [← hv]
  exact Submodule.add_mem _ (Submodule.smul_mem _ a hu_span) (Submodule.smul_mem _ b hw_span)

/-- A spanning fixed-vector set contains a basis consisting entirely of fixed vectors. -/
theorem exists_fixed_basis (hS : Function.Involutive S) {β : K} (hβ : β ≠ σ β) :
    ∃ (s : Set V) (b : Basis s K V), ∀ i, S (b i) = b i := by
  have hspan : (⊤ : Submodule K V) ≤ Submodule.span K (fixedVectors S) := by
    rw [span_fixedVectors_eq_top S hS hβ]
  let b := Basis.ofSpan hspan
  refine ⟨_, b, fun i => ?_⟩
  exact Basis.ofSpan_subset hspan ⟨i, rfl⟩

end FixedVectors

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

/-- A quadratic relative Frobenius is nontrivial, hence moves some scalar. -/
theorem exists_ne_conj (hfinrank : Module.finrank F K = 2) :
    ∃ β : K, β ≠ FiniteHermitian.conj F K β := by
  by_contra! h
  have heq : FiniteHermitian.conj F K = 1 := by
    ext β
    simpa using (h β).symm
  dsimp only [FiniteHermitian.conj] at heq
  have horder := FiniteField.orderOf_frobeniusAlgEquivOfAlgebraic F K
  rw [hfinrank, heq, orderOf_one] at horder
  omega

/-- In a quadratic finite-field extension, the fixed field of relative Frobenius is exactly the
image of the base field. -/
theorem exists_algebraMap_eq_of_conj_eq (hfinrank : Module.finrank F K = 2)
    {x : K} (hx : FiniteHermitian.conj F K x = x) :
    ∃ a : F, algebraMap F K a = x := by
  rw [← Set.mem_range]
  apply (IsGalois.mem_range_algebraMap_iff_fixed (F := F) (E := K) x).2
  intro f
  obtain ⟨n, rfl⟩ :=
    (FiniteField.bijective_frobeniusAlgEquivOfAlgebraic_pow F K).surjective f
  have hn : n.1 = 0 ∨ n.1 = 1 := by omega
  rcases hn with hn | hn
  · simp [hn]
  · simpa [hn, FiniteHermitian.conj] using hx

section GeneralConjugacy

variable {V : Type*} [AddCommGroup V] [Module K V] [FiniteDimensional K V]

/-- An involutive semilinear map over quadratic relative Frobenius has a basis of fixed vectors.
In that basis it is exactly coordinatewise Frobenius. -/
theorem exists_linearEquiv_conjugating_coordinateFrobenius
    (hfinrank : Module.finrank F K = 2)
    (S : V →ₛₗ[FiniteHermitian.conjRingHom F K] V) (hS : Function.Involutive S) :
    ∃ e : (Fin (Module.finrank K V) → K) ≃ₗ[K] V,
      ∀ x, S (e x) = e (coordinateFrobenius F K (Module.finrank K V) x) := by
  obtain ⟨β, hβ⟩ := exists_ne_conj F K hfinrank
  obtain ⟨ι, b, hb⟩ := exists_fixed_basis S hS hβ
  letI : Fintype ι := FiniteDimensional.fintypeBasisIndex b
  have hcard : Fintype.card ι = Module.finrank K V :=
    (Module.finrank_eq_card_basis b).symm
  let reindex : ι ≃ Fin (Module.finrank K V) := Fintype.equivFinOfCardEq hcard
  let bfin : Basis (Fin (Module.finrank K V)) K V := b.reindex reindex
  have hbfin (i : Fin (Module.finrank K V)) : S (bfin i) = bfin i := by
    simpa only [bfin, Basis.reindex_apply] using hb (reindex.symm i)
  let e : (Fin (Module.finrank K V) → K) ≃ₗ[K] V := bfin.equivFun.symm
  refine ⟨e, fun x => ?_⟩
  change S (bfin.equivFun.symm x) =
    bfin.equivFun.symm (coordinateFrobenius F K (Module.finrank K V) x)
  rw [bfin.equivFun_symm_apply, bfin.equivFun_symm_apply, map_sum]
  apply Finset.sum_congr rfl
  intro i _
  rw [map_smulₛₗ, hbfin]
  rfl

end GeneralConjugacy

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

/-- The projective involution induced by any literally involutive semilinear map. -/
noncomputable def projectiveSemilinearInvolution
    {V : Type*} [AddCommGroup V] [Module K V]
    (S : V →ₛₗ[FiniteHermitian.conjRingHom F K] V) (hS : Function.Involutive S) :
    Point K V ≃ Point K V :=
  let f := Projectivization.map S hS.injective
  let hinv : Function.Involutive f := by
    intro x
    induction x using Projectivization.ind with
    | h v hv =>
        dsimp only [f]
        rw [Projectivization.map_mk, Projectivization.map_mk]
        have hne : S (S v) ≠ 0 := by rw [hS v]; exact hv
        apply (Projectivization.mk_eq_mk_iff' K _ v hne hv).mpr
        exact ⟨1, by simp [hS v]⟩
  { toFun := f
    invFun := f
    left_inv := hinv
    right_inv := hinv }

@[simp]
theorem projectiveSemilinearInvolution_apply
    {V : Type*} [AddCommGroup V] [Module K V]
    (S : V →ₛₗ[FiniteHermitian.conjRingHom F K] V) (hS : Function.Involutive S)
    (x : Point K V) :
    projectiveSemilinearInvolution F K S hS x = Projectivization.map S hS.injective x := rfl

/-- The projective involution induced by a semilinear representative whose square is a nonzero
scalar. -/
noncomputable def projectiveSemilinearSqScalar
    {V : Type*} [AddCommGroup V] [Module K V]
    (S : V →ₛₗ[FiniteHermitian.conjRingHom F K] V) (c : K) (hc : c ≠ 0)
    (hS : ∀ v, S (S v) = c • v) : Point K V ≃ Point K V :=
  let hinj : Function.Injective S := injective_of_sq_smul S hc hS
  let f := Projectivization.map S hinj
  let hinv : Function.Involutive f := by
    intro x
    induction x using Projectivization.ind with
    | h v hv =>
        dsimp only [f]
        rw [Projectivization.map_mk, Projectivization.map_mk]
        have hSS : S (S v) ≠ 0 := by rw [hS]; exact smul_ne_zero hc hv
        apply (Projectivization.mk_eq_mk_iff' K _ v hSS hv).mpr
        exact ⟨c, (hS v).symm⟩
  { toFun := f
    invFun := f
    left_inv := hinv
    right_inv := hinv }

@[simp]
theorem projectiveSemilinearSqScalar_apply
    {V : Type*} [AddCommGroup V] [Module K V]
    (S : V →ₛₗ[FiniteHermitian.conjRingHom F K] V) (c : K) (hc : c ≠ 0)
    (hS : ∀ v, S (S v) = c • v) (x : Point K V) :
    projectiveSemilinearSqScalar F K S c hc hS x =
      Projectivization.map S (injective_of_sq_smul S hc hS) x := rfl

/-- Projective form of constructive order-two semilinear descent: every literally involutive
relative-Frobenius semilinear map is linearly conjugate to coordinate Frobenius. -/
theorem exists_projective_conjugacy_to_coordinateFrobenius
    {V : Type*} [AddCommGroup V] [Module K V] [FiniteDimensional K V]
    (hfinrank : Module.finrank F K = 2)
    (S : V →ₛₗ[FiniteHermitian.conjRingHom F K] V) (hS : Function.Involutive S) :
    ∃ e : (Fin (Module.finrank K V) → K) ≃ₗ[K] V,
      ∀ x,
        projectiveSemilinearInvolution F K S hS (mapLinearEquiv e x) =
          mapLinearEquiv e
            (projectiveCoordinateFrobenius F K (Module.finrank K V) hfinrank x) := by
  obtain ⟨e, he⟩ := exists_linearEquiv_conjugating_coordinateFrobenius F K hfinrank S hS
  refine ⟨e, fun x => ?_⟩
  induction x using Projectivization.ind with
  | h v hv =>
      simp only [mapLinearEquiv_mk, projectiveSemilinearInvolution_apply,
        projectiveCoordinateFrobenius_apply, Projectivization.map_mk]
      have hSe : S (e v) ≠ 0 := by
        simpa using hS.injective.ne (e.injective.ne hv)
      have hcv : coordinateFrobenius F K (Module.finrank K V) v ≠ 0 := by
        simpa using (coordinateFrobenius_injective F K (Module.finrank K V)).ne hv
      have hecv : e (coordinateFrobenius F K (Module.finrank K V) v) ≠ 0 := by
        simpa using e.injective.ne hcv
      apply (Projectivization.mk_eq_mk_iff' K (S (e v))
        (e (coordinateFrobenius F K (Module.finrank K V) v)) hSe hecv).mpr
      exact ⟨1, by simp [he v]⟩

/-- If the square scalar of a semilinear representative is a nonzero base-field scalar, a scalar
rescaling makes the representative literally involutive. -/
theorem exists_scalar_normalization_of_sq_algebraMap
    {V : Type*} [AddCommGroup V] [Module K V]
    (hfinrank : Module.finrank F K = 2)
    (S : V →ₛₗ[FiniteHermitian.conjRingHom F K] V) (c : F) (hc : c ≠ 0)
    (hS : ∀ v, S (S v) = algebraMap F K c • v) :
    ∃ d : K, d ≠ 0 ∧ Function.Involutive (d • S) := by
  obtain ⟨d, hd⟩ :=
    FiniteHermitian.exists_conj_mul_self_eq_algebraMap F K hfinrank c⁻¹
  have hcinvK : algebraMap F K c⁻¹ ≠ 0 := by
    simpa using (algebraMap F K).injective.ne (inv_ne_zero hc)
  have hd0 : d ≠ 0 := by
    intro hdZero
    rw [hdZero, map_zero, zero_mul] at hd
    exact hcinvK hd.symm
  refine ⟨d, hd0, fun v => ?_⟩
  change d • S (d • S v) = v
  rw [map_smulₛₗ, hS, smul_smul, smul_smul]
  simp only [FiniteHermitian.conjRingHom_apply]
  have hcoeff : d * FiniteHermitian.conj F K d * algebraMap F K c = 1 := by
    rw [mul_comm d, hd, ← map_mul, inv_mul_cancel₀ hc, map_one]
  rw [hcoeff, one_smul]

/-- Constructive projective descent when the square scalar is explicitly in the fixed base field.
This packages scalar normalization with the fixed-basis conjugacy theorem. -/
theorem exists_projective_conjugacy_of_sq_algebraMap
    {V : Type*} [AddCommGroup V] [Module K V] [FiniteDimensional K V]
    (hfinrank : Module.finrank F K = 2)
    (S : V →ₛₗ[FiniteHermitian.conjRingHom F K] V) (c : F) (hc : c ≠ 0)
    (hS : ∀ v, S (S v) = algebraMap F K c • v) :
    ∃ e : (Fin (Module.finrank K V) → K) ≃ₗ[K] V,
      ∀ x,
        Projectivization.map S (injective_of_sq_smul S
            (by simpa using (algebraMap F K).injective.ne hc) hS)
            (mapLinearEquiv e x) =
          mapLinearEquiv e
            (projectiveCoordinateFrobenius F K (Module.finrank K V) hfinrank x) := by
  obtain ⟨d, hd0, hdS⟩ :=
    exists_scalar_normalization_of_sq_algebraMap F K hfinrank S c hc hS
  have hcK : algebraMap F K c ≠ 0 := by
    simpa using (algebraMap F K).injective.ne hc
  have hSinj : Function.Injective S := injective_of_sq_smul S hcK hS
  let T : V →ₛₗ[FiniteHermitian.conjRingHom F K] V := d • S
  have hT : Function.Involutive T := hdS
  obtain ⟨e, he⟩ := exists_projective_conjugacy_to_coordinateFrobenius F K hfinrank T hT
  refine ⟨e, fun x => ?_⟩
  rw [← he x]
  induction mapLinearEquiv e x using Projectivization.ind with
  | h v hv =>
      rw [projectiveSemilinearInvolution_apply, Projectivization.map_mk,
        Projectivization.map_mk]
      apply (Projectivization.mk_eq_mk_iff' K (S v) (T v)
        (by
          intro hzero
          exact hv (hSinj (by simpa using hzero)))
        (by
          have hSv : S v ≠ 0 := by intro hzero; exact hv (hSinj (by simpa using hzero))
          exact smul_ne_zero hd0 hSv)).mpr
      exact ⟨d⁻¹, by simp [T, hd0]⟩

/-- Full constructive order-two Baer descent: if a relative-Frobenius semilinear representative
squares to any nonzero scalar, its projective action is linearly conjugate to coordinate
Frobenius.  The scalar is proved Frobenius-fixed, descended to the base field, normalized by norm
surjectivity, and then handled by the fixed-basis theorem. -/
theorem exists_projective_conjugacy_of_sq_scalar
    {V : Type*} [AddCommGroup V] [Module K V] [FiniteDimensional K V] [Nontrivial V]
    (hfinrank : Module.finrank F K = 2)
    (S : V →ₛₗ[FiniteHermitian.conjRingHom F K] V) (c : K) (hc : c ≠ 0)
    (hS : ∀ v, S (S v) = c • v) :
    ∃ e : (Fin (Module.finrank K V) → K) ≃ₗ[K] V,
      ∀ x,
        Projectivization.map S (injective_of_sq_smul S hc hS) (mapLinearEquiv e x) =
          mapLinearEquiv e
            (projectiveCoordinateFrobenius F K (Module.finrank K V) hfinrank x) := by
  have hcfix : FiniteHermitian.conj F K c = c := by
    exact scalar_fixed_of_sq_smul S hc hS
  obtain ⟨cF, hcF⟩ := exists_algebraMap_eq_of_conj_eq F K hfinrank hcfix
  have hcF0 : cF ≠ 0 := by
    intro hzero
    apply hc
    rw [← hcF, hzero, map_zero]
  subst c
  exact exists_projective_conjugacy_of_sq_algebraMap F K hfinrank S cF hcF0 hS

/-- Equivalence-valued form of the full Baer descent theorem, ready for the fixed-point-on-board
API. -/
theorem exists_projectiveEquiv_conjugacy_of_sq_scalar
    {V : Type*} [AddCommGroup V] [Module K V] [FiniteDimensional K V] [Nontrivial V]
    (hfinrank : Module.finrank F K = 2)
    (S : V →ₛₗ[FiniteHermitian.conjRingHom F K] V) (c : K) (hc : c ≠ 0)
    (hS : ∀ v, S (S v) = c • v) :
    ∃ e : (Fin (Module.finrank K V) → K) ≃ₗ[K] V,
      ∀ x,
        projectiveSemilinearSqScalar F K S c hc hS (mapLinearEquiv e x) =
          mapLinearEquiv e
            (projectiveCoordinateFrobenius F K (Module.finrank K V) hfinrank x) := by
  obtain ⟨e, he⟩ := exists_projective_conjugacy_of_sq_scalar F K hfinrank S c hc hS
  exact ⟨e, fun x => by simpa using he x⟩

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

/-- Pull a Hermitian form back along a linear equivalence. -/
noncomputable def pullbackHermitian
    {V W : Type*} [AddCommGroup V] [Module K V] [AddCommGroup W] [Module K W]
    (B : FiniteHermitian.Form (F := F) (K := K) (V := V)) (e : W ≃ₗ[K] V) :
    FiniteHermitian.Form (F := F) (K := K) (V := W) :=
  (B.comp e.toLinearMap).compl₂ e.toLinearMap

theorem pullbackHermitian_apply
    {V W : Type*} [AddCommGroup V] [Module K V] [AddCommGroup W] [Module K W]
    (B : FiniteHermitian.Form (F := F) (K := K) (V := V)) (e : W ≃ₗ[K] V)
    (x y : W) : pullbackHermitian F K B e x y = B (e x) (e y) := rfl

/-- Hermitian structure is preserved by linear change of coordinates. -/
theorem isHermitian_pullback
    {V W : Type*} [AddCommGroup V] [Module K V] [AddCommGroup W] [Module K W]
    (B : FiniteHermitian.Form (F := F) (K := K) (V := V))
    (hB : FiniteHermitian.IsHermitian B) (e : W ≃ₗ[K] V) :
    FiniteHermitian.IsHermitian (pullbackHermitian F K B e) where
  symm := ⟨fun x y => by exact hB.symm.eq (e x) (e y)⟩
  diagonal_mem_base x := by
    simpa [pullbackHermitian_apply] using hB.diagonal_mem_base (e x)

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

/-- Full Baer-semilinear Hermitian obstruction. Every projective order-two representative twisted
by relative Frobenius fixes a point on every Hermitian board of vector dimension at least three.
No board-preservation hypothesis is needed for the intersection statement. -/
theorem hermitian_baer_route_not_fixedPointFree
    {V : Type*} [AddCommGroup V] [Module K V] [FiniteDimensional K V] [Nontrivial V]
    (hfinrank : Module.finrank F K = 2) (hchar : ringChar F ≠ 2)
    (hdim : 3 ≤ Module.finrank K V)
    (B : FiniteHermitian.Form (F := F) (K := K) (V := V))
    (hB : FiniteHermitian.IsHermitian B)
    (S : V →ₛₗ[FiniteHermitian.conjRingHom F K] V) (c : K) (hc : c ≠ 0)
    (hS : ∀ v, S (S v) = c • v) :
    ¬ FixedPointFreeOn (OnHermitianForm B)
        (projectiveSemilinearSqScalar F K S c hc hS) := by
  obtain ⟨e, he⟩ := exists_projectiveEquiv_conjugacy_of_sq_scalar F K hfinrank S c hc hS
  let B₀ := pullbackHermitian F K B e
  have hB₀ : FiniteHermitian.IsHermitian B₀ := isHermitian_pullback F K B hB e
  let QF := hermitianBaseQuadraticForm F K B₀ hB₀
  obtain ⟨v, hv, hQv⟩ :=
    FiniteQuadraticIsotropy.exists_ne_zero_quadraticForm_eq_zero hchar QF (by
      simpa only [Module.finrank_fin_fun] using hdim)
  let z : Fin (Module.finrank K V) → K := baseLift F K (Module.finrank K V) v
  have hz : z ≠ 0 := baseLift_ne_zero F K (Module.finrank K V) hv
  let p : Point K (Fin (Module.finrank K V) → K) := Projectivization.mk K z hz
  have hpcoord : projectiveCoordinateFrobenius F K (Module.finrank K V) hfinrank p = p :=
    projectiveCoordinateFrobenius_fixed_baseLift F K (Module.finrank K V) hfinrank hv
  have hpboard : OnHermitianForm B (mapLinearEquiv e p) := by
    rw [show mapLinearEquiv e p = Projectivization.mk K (e z) (by simp [hz]) by
      simp [p, mapLinearEquiv_mk]]
    apply onHermitianForm_mk B (by simp [hz])
    have hbase := algebraMap_hermitianBaseQuadraticForm F K B₀ hB₀ v
    rw [hQv, map_zero] at hbase
    exact hbase.symm
  apply not_fixedPointFreeOn_of_hasFixedPointOn
  refine ⟨mapLinearEquiv e p, hpboard, ?_⟩
  rw [he p, hpcoord]

end BaerSemilinear
end Projective
end ProjectiveCap
