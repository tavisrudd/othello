import Mathlib.Algebra.BigOperators.Ring.Finset
import Mathlib.Algebra.BigOperators.Fin
import Mathlib.Data.Nat.Choose.Sum
import Mathlib.Data.Fintype.BigOperators
import Mathlib.Algebra.Ring.Parity
import Mathlib.Algebra.Module.LinearMap.Defs
import Mathlib.Tactic

/-!
# Signed moments and the trade filtration

Let `R` be a commutative ring, `ι` a finite index set, `ε : ι → R` a weight, and `φ : ι → R` a
scalar feature.  The associated *signed moments* are the weighted power sums

    Mⱼ(ε, φ) = ∑ᵢ εᵢ · φᵢ ^ j        (`signedMoment`),   j ∈ ℕ.

We say the pair `(ε, φ)` is *balanced through degree `s`* when `M₀ = ⋯ = M_s = 0`, and that it has
*exact strength `s`* when in addition `M_{s+1} ≠ 0`.  When `ε` is `±1`-valued these are signed
power-sum conditions; the vector-valued refinement of the final section is the one that specializes,
for an incidence feature, to the classical strength-`s` combinatorial trade.

This file develops the elementary algebra of these moments.

* `signedMoment_affine` — the binomial identity expressing the moments of an affinely
  reparametrized feature `a·φ + b` as a lower-triangular combination of the original moments.
* `signedMoment_affine_vanish` and `signedMoment_affine_succ` — **affine covariance**: an affine
  reparametrization preserves balance through degree `s`, and multiplies the leading moment
  `M_{s+1}` by the scalar `a^(s+1)`, independently of the translation `b`.  Hence exact strength is
  invariant under an invertible affine reparametrization.
* `signedMoment_one_translate` and `signedMoment_barycentre_cancel` — recentring the feature at a
  weighted barycentre annihilates the first moment.
* `signedMoment_antipodal_even` — a fixed-point-free involution under which the weight and the
  feature are both odd annihilates every even moment.
* `witness_exact_strength_two` — an explicit four-point configuration over `ℤ` that is balanced
  through degree two but has `M₃ = 12 ≠ 0`, showing the degree bounds above are sharp: balance
  through degree two does not force `M₃ = 0`.

For a vector-valued feature `φ : ι → V` the `j`-th moment is naturally a symmetric tensor in
`Sym^j V`.  Rather than construct symmetric powers, the final section represents it by its
associated symmetric `j`-linear form, evaluated on a tuple of linear functionals
(`vectorMomentForm`), and records that a single functional whose scalar shadow `ℓ ∘ φ` has nonzero
`j`-th moment already certifies the vector moment to be nonzero, even though a given functional may
fail to detect it.
-/

namespace RelativeConicArcs.ClebschMomentTrade

open Finset
open scoped BigOperators

variable {R : Type*} [CommRing R] {ι : Type*} [Fintype ι]

/-- The `j`-th signed moment (weighted power sum) `∑ᵢ εᵢ · φᵢ ^ j` of a scalar feature `φ` with
weight `ε`. -/
def signedMoment (ε φ : ι → R) (j : ℕ) : R := ∑ i, ε i * φ i ^ j

/-- The zeroth moment is the total weight `∑ᵢ εᵢ`. -/
theorem signedMoment_zero (ε φ : ι → R) : signedMoment ε φ 0 = ∑ i, ε i := by
  simp [signedMoment]

/-- **Binomial expansion under an affine reparametrization of the feature.**  For all `a b : R`,

    Mₙ(ε, a·φ + b) = ∑_{k=0}^{n} (n.choose k) · aᵏ · b^(n-k) · Mₖ(ε, φ);

the induced transformation of the moment sequence is lower triangular in the moment index. -/
theorem signedMoment_affine (ε φ : ι → R) (a b : R) (n : ℕ) :
    signedMoment ε (fun i => a * φ i + b) n
      = ∑ k ∈ range (n + 1),
          (n.choose k : R) * a ^ k * b ^ (n - k) * signedMoment ε φ k := by
  have expand : ∀ i, ε i * (a * φ i + b) ^ n
      = ∑ k ∈ range (n + 1),
          (n.choose k : R) * a ^ k * b ^ (n - k) * (ε i * φ i ^ k) := by
    intro i
    rw [add_pow, Finset.mul_sum]
    refine Finset.sum_congr rfl fun k _ => ?_
    rw [mul_pow]; ring
  calc
    signedMoment ε (fun i => a * φ i + b) n
        = ∑ i, ∑ k ∈ range (n + 1),
            (n.choose k : R) * a ^ k * b ^ (n - k) * (ε i * φ i ^ k) := by
          simp only [signedMoment]
          exact Finset.sum_congr rfl fun i _ => expand i
    _ = ∑ k ∈ range (n + 1), ∑ i,
            (n.choose k : R) * a ^ k * b ^ (n - k) * (ε i * φ i ^ k) := Finset.sum_comm
    _ = ∑ k ∈ range (n + 1),
            (n.choose k : R) * a ^ k * b ^ (n - k) * signedMoment ε φ k := by
          refine Finset.sum_congr rfl fun k _ => ?_
          simp only [signedMoment, Finset.mul_sum]

/-- If the moments through degree `n` all vanish, then so does the degree-`n` moment of every
affine reparametrization `a·φ + b` of the feature. -/
theorem signedMoment_affine_vanish (ε φ : ι → R) (a b : R) {n : ℕ}
    (h : ∀ k, k ≤ n → signedMoment ε φ k = 0) :
    signedMoment ε (fun i => a * φ i + b) n = 0 := by
  rw [signedMoment_affine]
  refine Finset.sum_eq_zero fun k hk => ?_
  rw [Finset.mem_range] at hk
  rw [h k (by omega)]; ring

/-- **Affine covariance of the leading moment.**  If `(ε, φ)` is balanced through degree `s`
(`Mₖ = 0` for `k ≤ s`), then the first higher moment transforms by the scalar `a^(s+1)` and is
independent of the translation `b`:

    M_{s+1}(ε, a·φ + b) = a^(s+1) · M_{s+1}(ε, φ).

In particular an invertible `a` preserves exact strength `s`. -/
theorem signedMoment_affine_succ (ε φ : ι → R) (a b : R) {s : ℕ}
    (h : ∀ k, k ≤ s → signedMoment ε φ k = 0) :
    signedMoment ε (fun i => a * φ i + b) (s + 1)
      = a ^ (s + 1) * signedMoment ε φ (s + 1) := by
  rw [signedMoment_affine, Finset.sum_eq_single (s + 1)]
  · simp [Nat.choose_self]
  · intro j hj hjne
    rw [Finset.mem_range] at hj
    rw [h j (by omega)]; ring
  · intro hc
    exact absurd (Finset.mem_range.mpr (by omega)) hc

/-- Translating the feature by `b` shifts the first moment by `b · M₀`:
`M₁(ε, φ - b) = M₁(ε, φ) - b · M₀(ε, φ)`. -/
theorem signedMoment_one_translate (ε φ : ι → R) (b : R) :
    signedMoment ε (fun i => φ i - b) 1
      = signedMoment ε φ 1 - b * signedMoment ε φ 0 := by
  simp only [signedMoment, pow_one, pow_zero, mul_one]
  rw [Finset.mul_sum, ← Finset.sum_sub_distrib]
  refine Finset.sum_congr rfl fun i _ => ?_
  ring

/-- **Recentring at a weighted barycentre annihilates the first moment.**  If `b` is a weighted
barycentre of `(ε, φ)`, that is `b · M₀ = M₁` (a unique such `b` exists when `M₀` is a unit), then
`M₁(ε, φ - b) = 0`. -/
theorem signedMoment_barycentre_cancel (ε φ : ι → R) (b : R)
    (h : b * signedMoment ε φ 0 = signedMoment ε φ 1) :
    signedMoment ε (fun i => φ i - b) 1 = 0 := by
  rw [signedMoment_one_translate, h, sub_self]

/-- **An odd involution annihilates every even moment.**  Suppose `J : ι → ι` is a fixed-point-free
involution under which the weight and the feature are both odd, `ε ∘ J = -ε` and `φ ∘ J = -φ`.
Then `Mₙ(ε, φ) = 0` for every even `n`: pairing each `i` with `J i`, the two contributions are
`εᵢ φᵢ^n` and `-εᵢ (-φᵢ)^n`, which cancel exactly when `n` is even. -/
theorem signedMoment_antipodal_even (ε φ : ι → R) (J : ι → ι)
    (hJ : Function.Involutive J) (hfree : ∀ i, J i ≠ i)
    (hε : ∀ i, ε (J i) = -ε i) (hφ : ∀ i, φ (J i) = -φ i)
    {n : ℕ} (hn : Even n) :
    signedMoment ε φ n = 0 := by
  simp only [signedMoment]
  refine Finset.sum_ninvolution J ?_ ?_ ?_ ?_
  · intro a
    rw [hε a, hφ a, hn.neg_pow]; ring
  · intro a _; exact hfree a
  · intro a; exact Finset.mem_univ _
  · intro a; exact hJ a

/-! ### Sharpness: a configuration of exact strength two

An explicit signed configuration on four points, over `ℤ`, that is balanced through degree two but
has nonzero third moment.  Equivalently its generating function
`∑ᵢ εᵢ · x ^ (φᵢ) = -x + 2·x² - 2·x⁴ + x⁵ = x·(x-1)³·(x+1)` has a root of multiplicity exactly three
at `x = 1`.  This shows the degree bounds in the affine-covariance results above cannot be improved:
balance through degree two does not force the third moment to vanish. -/

/-- Weights `-1, 2, -2, 1` of the four-point sharpness example. -/
def witnessWeight : Fin 4 → ℤ := ![-1, 2, -2, 1]

/-- Feature values `1, 2, 4, 5` of the four-point sharpness example. -/
def witnessValue : Fin 4 → ℤ := ![1, 2, 4, 5]

theorem witness_moment_zero : signedMoment witnessWeight witnessValue 0 = 0 := by
  simp only [signedMoment, Fin.sum_univ_four]; decide

theorem witness_moment_one : signedMoment witnessWeight witnessValue 1 = 0 := by
  simp only [signedMoment, Fin.sum_univ_four]; decide

theorem witness_moment_two : signedMoment witnessWeight witnessValue 2 = 0 := by
  simp only [signedMoment, Fin.sum_univ_four]; decide

theorem witness_moment_three : signedMoment witnessWeight witnessValue 3 = 12 := by
  simp only [signedMoment, Fin.sum_univ_four]; decide

/-- The four-point configuration `(witnessWeight, witnessValue)` is balanced through degree two but
has nonzero third moment; hence exact strength two is attained. -/
theorem witness_exact_strength_two :
    signedMoment witnessWeight witnessValue 0 = 0 ∧
      signedMoment witnessWeight witnessValue 1 = 0 ∧
        signedMoment witnessWeight witnessValue 2 = 0 ∧
          signedMoment witnessWeight witnessValue 3 ≠ 0 :=
  ⟨witness_moment_zero, witness_moment_one, witness_moment_two, by
    rw [witness_moment_three]; norm_num⟩

/-! ### Vector-valued features

For a feature `φ : ι → V` the `j`-th moment is naturally a symmetric tensor in `Sym^j V`.  Instead
of constructing symmetric powers we work with its associated symmetric `j`-linear form, evaluated on
a tuple of linear functionals. -/

section Vector

variable {V : Type*} [AddCommGroup V] [Module R V]

/-- The symmetric `j`-linear form of the `j`-th vector moment, evaluated on functionals
`ℓ : Fin j → (V →ₗ[R] R)`:  `∑ᵢ εᵢ · ∏ₖ ℓₖ(φᵢ)`. -/
def vectorMomentForm (ε : ι → R) (φ : ι → V) {j : ℕ} (ℓ : Fin j → (V →ₗ[R] R)) : R :=
  ∑ i, ε i * ∏ k, ℓ k (φ i)

/-- Evaluating on the constant tuple `(ℓ, …, ℓ)` recovers the `j`-th scalar moment of the shadow
`ℓ ∘ φ`. -/
theorem vectorMomentForm_diagonal (ε : ι → R) (φ : ι → V) (ℓ : V →ₗ[R] R) (j : ℕ) :
    vectorMomentForm ε φ (fun _ : Fin j => ℓ)
      = signedMoment ε (fun i => ℓ (φ i)) j := by
  simp only [vectorMomentForm, signedMoment, Finset.prod_const, Finset.card_univ,
    Fintype.card_fin]

/-- If some scalar shadow `ℓ ∘ φ` has nonzero `j`-th moment, then the `j`-th vector moment form is
nonzero — already on the constant tuple `(ℓ, …, ℓ)`.  Thus one functional suffices to certify that
the vector moment does not vanish, even though a given functional may fail to detect it. -/
theorem vectorMomentForm_ne_zero_of_shadow (ε : ι → R) (φ : ι → V) (ℓ : V →ₗ[R] R) (j : ℕ)
    (h : signedMoment ε (fun i => ℓ (φ i)) j ≠ 0) :
    vectorMomentForm ε φ (fun _ : Fin j => ℓ) ≠ 0 := by
  rw [vectorMomentForm_diagonal]; exact h

/-- **Covariance of scalar shadows.**  For a linear endomorphism `A` of `V` and a translation
`c : V`, the scalar shadow along `ℓ` of the transported feature `A ∘ φ + c` satisfies the binomial
identity in terms of the shadow of `A ∘ φ`.  This is the functional-shadow form of the covariance
of the `j`-th vector moment under `φ ↦ A ∘ φ + c`, obtained without symmetric powers. -/
theorem signedMoment_shadow_affine (ε : ι → R) (φ : ι → V) (A : V →ₗ[R] V) (c : V)
    (ℓ : V →ₗ[R] R) (n : ℕ) :
    signedMoment ε (fun i => ℓ (A (φ i) + c)) n
      = ∑ k ∈ range (n + 1),
          (n.choose k : R) * 1 ^ k * ℓ c ^ (n - k)
            * signedMoment ε (fun i => ℓ (A (φ i))) k := by
  have hfeat : (fun i => ℓ (A (φ i) + c)) = fun i => 1 * ℓ (A (φ i)) + ℓ c := by
    funext i; rw [map_add]; ring
  rw [hfeat]
  exact signedMoment_affine ε (fun i => ℓ (A (φ i))) 1 (ℓ c) n

end Vector

end RelativeConicArcs.ClebschMomentTrade
