import Mathlib.FieldTheory.Finite.Trace
import Mathlib.LinearAlgebra.Dimension.RankNullity
import Mathlib.LinearAlgebra.SesquilinearForm.Basic

/-!
# Finite Hermitian spaces

This file develops the finite-field Hermitian input for the mirror-boundary program. We use the
canonical relative Frobenius of a quadratic finite-field extension as conjugation. A Hermitian form
is represented by a sesquilinear form whose diagonal values are explicitly in the base field.
-/

namespace ProjectiveCap
namespace FiniteHermitian

variable (F K : Type*) [Field F] [Fintype F] [Field K] [Fintype K] [Algebra F K]

/-- The canonical conjugation of a finite extension: relative Frobenius `x ↦ x ^ #F`. In a
quadratic extension this is the nontrivial order-two automorphism. -/
noncomputable def conj : K ≃ₐ[F] K :=
  FiniteField.frobeniusAlgEquivOfAlgebraic F K

theorem conj_apply (x : K) : conj F K x = x ^ Fintype.card F := rfl

/-- Conjugation as a ring homomorphism, for the semilinear-map API. -/
noncomputable def conjRingHom : K →+* K := (conj F K).toRingEquiv.toRingHom

@[simp]
theorem conjRingHom_apply (x : K) : conjRingHom F K x = conj F K x := rfl

/-- In a quadratic finite-field extension, the field norm is `conj(x) * x`. -/
theorem algebraMap_norm_eq_conj_mul (hfinrank : Module.finrank F K = 2) (x : K) :
    algebraMap F K (Algebra.norm F x) = conj F K x * x := by
  rw [FiniteField.algebraMap_norm_eq_prod_pow, hfinrank]
  norm_num [Finset.prod_range_succ, conj_apply, mul_comm]

/-- The norm of a nonsquare in a quadratic finite-field extension is a nonsquare. Equivalently,
if the norm is a square in the base field, the original element is a square. -/
theorem isSquare_of_isSquare_norm (hfinrank : Module.finrank F K = 2)
    (hchar : ringChar F ≠ 2) {c : K} (hc : c ≠ 0)
    (hnorm : IsSquare (Algebra.norm F c)) : IsSquare c := by
  have hcharK : ringChar K ≠ 2 := by
    rwa [← Algebra.ringChar_eq F K]
  have hnorm0 : Algebra.norm F c ≠ 0 := by
    intro hzero
    have h := congrArg (algebraMap F K : F →+* K) hzero
    rw [algebraMap_norm_eq_conj_mul F K hfinrank] at h
    simp [hc] at h
  have hpowF := (FiniteField.isSquare_iff hchar hnorm0).mp hnorm
  have hpowK :
      (algebraMap F K (Algebra.norm F c)) ^ (Fintype.card F / 2) = 1 := by
    simpa using congrArg (algebraMap F K) hpowF
  rw [FiniteField.algebraMap_norm_eq_pow, Nat.card_eq_fintype_card,
    Nat.card_eq_fintype_card, ← pow_mul] at hpowK
  have hcard : Fintype.card K = Fintype.card F ^ 2 := by
    calc
      Fintype.card K = Fintype.card F ^ Module.finrank F K :=
        Module.card_eq_pow_finrank
      _ = Fintype.card F ^ 2 := by rw [hfinrank]
  have hquot :
      (Fintype.card K - 1) / (Fintype.card F - 1) = Fintype.card F + 1 := by
    rw [hcard]
    have hq : 1 < Fintype.card F := Fintype.one_lt_card
    have hqone : 1 ≤ Fintype.card F := hq.le
    have hsub : Fintype.card F - 1 + 1 = Fintype.card F := Nat.sub_add_cancel hqone
    have hfactor : Fintype.card F ^ 2 - 1 =
        (Fintype.card F - 1) * (Fintype.card F + 1) := by
      have hsq : 1 ≤ Fintype.card F ^ 2 := by nlinarith
      apply (Nat.sub_eq_iff_eq_add hsq).mpr
      nlinarith
    rw [hfactor, Nat.mul_div_cancel_left _ (by omega : 0 < Fintype.card F - 1)]
  have hexponent :
      ((Fintype.card K - 1) / (Fintype.card F - 1)) * (Fintype.card F / 2) =
        Fintype.card K / 2 := by
    rw [hquot, hcard]
    have hoddF := Nat.two_mul_odd_div_two (FiniteField.odd_card_of_char_ne_two hchar)
    have hoddK := Nat.two_mul_odd_div_two (FiniteField.odd_card_of_char_ne_two hcharK)
    rw [hcard] at hoddK
    let k := Fintype.card F / 2
    have hqpos : 0 < Fintype.card F := Fintype.card_pos
    have hq : Fintype.card F = 2 * k + 1 := by omega
    have hk : Fintype.card F ^ 2 / 2 = 2 * k ^ 2 + 2 * k := by
      have hpoly : 2 * (2 * k ^ 2 + 2 * k) + 1 = (2 * k + 1) ^ 2 := by ring
      rw [hq] at hoddK
      rw [show (2 * k + 1) ^ 2 = 4 * k ^ 2 + 4 * k + 1 by ring] at hoddK
      rw [hq]
      omega
    have hkdiv : (2 * k + 1) / 2 = k := by omega
    rw [hk, hq, hkdiv]
    ring
  apply (FiniteField.isSquare_iff hcharK hc).mpr
  rwa [hexponent] at hpowK

/-- Every base-field scalar is a conjugate norm `conj(a) * a`. -/
theorem exists_conj_mul_self_eq_algebraMap (hfinrank : Module.finrank F K = 2) (b : F) :
    ∃ a : K, conj F K a * a = algebraMap F K b := by
  obtain ⟨a, ha⟩ := FiniteField.norm_surjective F K b
  refine ⟨a, ?_⟩
  rw [← algebraMap_norm_eq_conj_mul F K hfinrank, ha]

variable {F K}
variable {V : Type*} [AddCommGroup V] [Module K V] [FiniteDimensional K V]

/-- A Hermitian form over the finite extension `K/F`, expressed using relative Frobenius in the
first argument. -/
abbrev Form : Type _ :=
  V →ₛₗ[conjRingHom F K] V →ₗ[K] K

/-- Strict Hermitian interface: conjugate symmetry plus the statement that every diagonal value
lies in the base field. The latter is normally derived from the fixed-field theorem for relative
Frobenius; keeping it explicit makes that bridge auditable. -/
structure IsHermitian (B : Form (F := F) (K := K) (V := V)) : Prop where
  symm : B.IsSymm
  diagonal_mem_base : ∀ x : V, ∃ b : F, algebraMap F K b = B x x

namespace IsHermitian

omit [FiniteDimensional K V] in
theorem restrict {B : Form (F := F) (K := K) (V := V)} (hB : IsHermitian B)
    (W : Submodule K V) : IsHermitian (B.domRestrict₁₂ W W) where
  symm := hB.symm.domRestrict W
  diagonal_mem_base x := hB.diagonal_mem_base x

end IsHermitian

omit [FiniteDimensional K V] in
/-- A finite Hermitian space of dimension at least two has a nonzero isotropic vector. The proof
orthogonalizes a linearly independent pair and uses surjectivity of the quadratic field norm. -/
theorem exists_ne_zero_self_eq_zero (hfinrank : Module.finrank F K = 2)
    (B : Form (F := F) (K := K) (V := V)) (hB : IsHermitian B)
    (hdim : 2 ≤ Module.finrank K V) :
    ∃ v : V, v ≠ 0 ∧ B v v = 0 := by
  letI : Nontrivial V :=
    Module.nontrivial_of_finrank_pos (lt_of_lt_of_le Nat.zero_lt_two hdim)
  obtain ⟨x, hx⟩ := exists_ne (0 : V)
  by_cases hxx : B x x = 0
  · exact ⟨x, hx, hxx⟩
  obtain ⟨y, hxyLI⟩ :=
    exists_linearIndependent_pair_of_one_lt_finrank (R := K) (M := V) (by omega) hx
  let d : K := B x y / B x x
  let z : V := y - d • x
  have hxz : B x z = 0 := by
    simp only [z, map_sub, map_smul, smul_eq_mul, d]
    field_simp
    ring
  have hzx : B z x = 0 := hB.symm.isRefl.eq_zero hxz
  have hz : z ≠ 0 := by
    intro hz0
    have hy : y = d • x := sub_eq_zero.mp hz0
    have hrel : (-d) • x + (1 : K) • y = 0 := by rw [one_smul, hy]; module
    have hcoeff := (LinearIndependent.pair_iff.mp hxyLI) (-d) 1 hrel
    exact one_ne_zero hcoeff.2
  by_cases hzz : B z z = 0
  · exact ⟨z, hz, hzz⟩
  obtain ⟨bx, hbx⟩ := hB.diagonal_mem_base x
  obtain ⟨bz, hbz⟩ := hB.diagonal_mem_base z
  have hbz0 : bz ≠ 0 := by
    intro hbzZero
    apply hzz
    rw [← hbz, hbzZero, map_zero]
  let target : F := -bx / bz
  obtain ⟨a, ha⟩ := exists_conj_mul_self_eq_algebraMap F K hfinrank target
  let v : V := x + a • z
  have hv : v ≠ 0 := by
    intro hv0
    have happ := congrArg (fun w => B x w) hv0
    simp only [v, map_add, map_smul, hxz, smul_zero, add_zero, map_zero] at happ
    exact hxx happ
  refine ⟨v, hv, ?_⟩
  have hvv : B v v = B x x + (conj F K a * a) * B z z := by
    simp only [v, map_add, LinearMap.add_apply, LinearMap.map_smulₛₗ,
      conjRingHom_apply, map_smul, LinearMap.smul_apply, smul_eq_mul]
    change B x x + conj F K a * B z x + a * (B x z + conj F K a * B z z) =
      B x x + (conj F K a * a) * B z z
    rw [hxz, hzx]
    ring
  rw [hvv, ha, ← hbx, ← hbz, ← map_mul, ← map_add]
  rw [← map_zero (algebraMap F K)]
  congr 1
  dsimp only [target]
  field_simp [hbz0]
  ring

omit [FiniteDimensional K V] in
/-- A linear similitude of a nondegenerate Hermitian form whose square is `c I` forces `c` to be a
square. The multiplier is taken in the base field, as in the standard general-unitary group. The
key identity is `Norm(c) = μ²`, followed by quadratic-extension norm-square reflection. -/
theorem isSquare_scalar_of_similitude_sq [Nontrivial V]
    (hfinrank : Module.finrank F K = 2) (hchar : ringChar F ≠ 2)
    (B : Form (F := F) (K := K) (V := V)) (hB : B.Nondegenerate)
    (g : V ≃ₗ[K] V) (c : K) (μ : F)
    (hg : ∀ v, g (g v) = c • v)
    (hsim : ∀ x y, B (g x) (g y) = algebraMap F K μ * B x y) :
    IsSquare c := by
  have hc : c ≠ 0 := by
    intro hc0
    obtain ⟨v, hv⟩ := exists_ne (0 : V)
    have hgg : g (g v) ≠ 0 := by simp [hv]
    exact hgg (by simp [hg, hc0])
  obtain ⟨x, hx⟩ := exists_ne (0 : V)
  have hxy : ∃ y, B x y ≠ 0 := by
    by_contra! hzero
    exact hx (hB.1 x hzero)
  obtain ⟨y, hxy⟩ := hxy
  have hcoeff : conj F K c * c = algebraMap F K μ * algebraMap F K μ := by
    apply mul_right_cancel₀ hxy
    calc
      (conj F K c * c) * B x y = B (c • x) (c • y) := by
        simp only [LinearMap.map_smulₛₗ, conjRingHom_apply, map_smul,
          LinearMap.smul_apply, smul_eq_mul]
        ring
      _ = B (g (g x)) (g (g y)) := by rw [hg, hg]
      _ = algebraMap F K μ * B (g x) (g y) := hsim (g x) (g y)
      _ = (algebraMap F K μ * algebraMap F K μ) * B x y := by rw [hsim]; ring
  have hnorm : Algebra.norm F c = μ * μ := by
    apply (algebraMap F K).injective
    rw [algebraMap_norm_eq_conj_mul F K hfinrank, hcoeff, map_mul]
  apply isSquare_of_isSquare_norm F K hfinrank hchar hc
  exact ⟨μ, hnorm⟩

omit [FiniteDimensional K V] in
/-- Therefore a nonsquare scalar cannot occur as the square of a Hermitian similitude with
base-field multiplier. This is the nonsplit linear obstruction needed by C86. -/
theorem no_similitude_sq_nonsquare [Nontrivial V]
    (hfinrank : Module.finrank F K = 2) (hchar : ringChar F ≠ 2)
    (B : Form (F := F) (K := K) (V := V)) (hB : B.Nondegenerate)
    (g : V ≃ₗ[K] V) (c : K) (μ : F)
    (hg : ∀ v, g (g v) = c • v)
    (hsim : ∀ x y, B (g x) (g y) = algebraMap F K μ * B x y)
    (hnonsquare : ¬ IsSquare c) : False :=
  hnonsquare (isSquare_scalar_of_similitude_sq hfinrank hchar B hB g c μ hg hsim)

end FiniteHermitian
end ProjectiveCap
