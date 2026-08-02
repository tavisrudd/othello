import Mathlib.Algebra.Order.BigOperators.Group.Finset
import Mathlib.Data.Complex.BigOperators
import Mathlib.Analysis.RCLike.Basic
import Mathlib.LinearAlgebra.Matrix.Hermitian
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Ring
import RelativeConicArcs.AMELU.SiteOperators

/-!
# The second-moment isometry of a 2-uniform state

A pure state of finitely many sites, each of local dimension
`q = Fintype.card Level`, is *2-uniform* when every reduced density operator on
one or two sites is the normalized identity.  `IsTwoUniform` records that
condition in expectation form: the state is a unit vector, the expectation of a
local operator `A` placed at a single site is `Tr(A)/q`, and the expectation of
`A` at a site `j` together with `B` at a distinct site `k` is
`Tr(A)Tr(B)/q²`.  Because operators of the form `A` at `j` and `A ⊗ B` at
`{j, k}` span all operators on one and on two sites, these expectation
identities are equivalent to the reduced density operators being `q⁻¹ I` and
`q⁻² I`; the equivalence with a partial-trace presentation is not formalized
here.

The main result is the polarized second-moment identity.  For traceless local
operators `h j` and `h' j`, with the `h j` Hermitian, and for the summed local
generators `M = Σ_j h_j^{(j)}` and `M' = Σ_j h'^{(j)}_j`, the expectation of
`M` vanishes and

  ⟪M ψ, M' ψ⟫ = q⁻¹ Σ_j Tr(h_j h'_j).

Both the cross-site cancellation and the absence of an error term are exactly
the 2-uniformity hypothesis.  Specializing to `h' = h` shows that
`(h_1, …, h_n) ↦ √q · M ψ` is an isometry from the traceless local generators
with the product Frobenius form into the state space, and in particular that
`M ψ = 0` forces every `h_j` to vanish.

All arguments are symbolic and kernel checked.  The module contains no
generated data, native evaluation, axioms, or admitted declarations.
-/

namespace RelativeConicArcs.AMELU.Multipartite

open scoped BigOperators ComplexConjugate
open Finset Matrix

variable {Site Level : Type*} [Fintype Site] [DecidableEq Site]
  [Fintype Level] [DecidableEq Level]

/-- The Hermitian inner product of two amplitude functions, conjugate-linear in
the first argument. -/
noncomputable def stateInner (φ ψ : Label Site Level → ℂ) : ℂ :=
  ∑ x, conj (φ x) * ψ x

/-- The expectation of a system operator in an amplitude function. -/
noncomputable def expectation (ψ : Label Site Level → ℂ)
    (A : SystemOperator Site Level) : ℂ :=
  ∑ y, ∑ x, conj (ψ y) * (A y x * ψ x)

omit [DecidableEq Level] in
/-- The double-sum definition of the expectation agrees with the inner product
of the state against its image under the operator. -/
theorem expectation_eq_stateInner (ψ : Label Site Level → ℂ)
    (A : SystemOperator Site Level) :
    expectation ψ A = stateInner ψ (A *ᵥ ψ) := by
  unfold expectation stateInner
  refine Finset.sum_congr rfl fun y _ => ?_
  rw [Matrix.mulVec_apply_eq_sum, Finset.mul_sum]

omit [DecidableEq Level] in
/-- The zero operator has zero expectation. -/
@[simp]
theorem expectation_zero (ψ : Label Site Level → ℂ) :
    expectation ψ (0 : SystemOperator Site Level) = 0 := by
  unfold expectation
  simp

omit [DecidableEq Level] in
/-- Expectation is additive in the operator. -/
theorem expectation_add (ψ : Label Site Level → ℂ)
    (A B : SystemOperator Site Level) :
    expectation ψ (A + B) = expectation ψ A + expectation ψ B := by
  unfold expectation
  rw [← Finset.sum_add_distrib]
  refine Finset.sum_congr rfl fun y _ => ?_
  rw [← Finset.sum_add_distrib]
  refine Finset.sum_congr rfl fun x _ => ?_
  rw [Matrix.add_apply]
  ring

omit [DecidableEq Level] in
/-- Expectation is additive over a finite sum of system operators. -/
theorem expectation_sum {ι : Type*} (ψ : Label Site Level → ℂ) (s : Finset ι)
    (A : ι → SystemOperator Site Level) :
    expectation ψ (∑ i ∈ s, A i) = ∑ i ∈ s, expectation ψ (A i) := by
  classical
  induction s using Finset.induction_on with
  | empty => simp
  | insert a s ha ih =>
      rw [Finset.sum_insert ha, Finset.sum_insert ha, expectation_add, ih]

/-- Dividing every summand by a fixed scalar divides the sum. -/
private theorem sum_div_const {ι : Type*} (s : Finset ι) (f : ι → ℂ) (c : ℂ) :
    ∑ i ∈ s, f i / c = (∑ i ∈ s, f i) / c := by
  simp only [div_eq_mul_inv, ← Finset.sum_mul]

omit [DecidableEq Level] in
/-- Moving a system operator across the inner product replaces it by its
conjugate transpose. -/
theorem stateInner_mulVec_left (A : SystemOperator Site Level)
    (φ ψ : Label Site Level → ℂ) :
    stateInner (A *ᵥ φ) ψ = stateInner φ (Aᴴ *ᵥ ψ) := by
  unfold stateInner
  simp only [Matrix.mulVec_apply_eq_sum, map_sum, map_mul,
    Finset.sum_mul, Finset.mul_sum]
  rw [Finset.sum_comm]
  refine Finset.sum_congr rfl fun x _ => ?_
  refine Finset.sum_congr rfl fun y _ => ?_
  have hstar : (star (A y x) : ℂ) = conj (A y x) := rfl
  rw [Matrix.conjTranspose_apply, hstar]
  ring

/-- A state of `n` sites of local dimension `q` is 2-uniform when it is a unit
vector, every single-site expectation is the normalized trace, and the
expectation of local operators placed at two distinct sites is the product of
normalized traces.  Equivalently, every reduced density operator on one site is
`q⁻¹ I` and every reduced density operator on two sites is `q⁻² I`. -/
structure IsTwoUniform (ψ : Label Site Level → ℂ) : Prop where
  /-- The amplitude function is a unit vector. -/
  normalized : stateInner ψ ψ = 1
  /-- Every one-site reduced density operator is the normalized identity. -/
  single : ∀ (j : Site) (A : LocalOperator Level),
    expectation ψ (siteOperator j A) = A.trace / (Fintype.card Level : ℂ)
  /-- Every two-site reduced density operator is the normalized identity. -/
  pair : ∀ (j k : Site), j ≠ k → ∀ A B : LocalOperator Level,
    expectation ψ (siteOperator j A * siteOperator k B) =
      A.trace * B.trace / ((Fintype.card Level : ℂ) ^ 2)

/-- The one-site condition is implied by the two-site condition as soon as a
second site exists: place the identity at that second site. -/
theorem single_of_pair [Nonempty Level] (ψ : Label Site Level → ℂ)
    (hpair : ∀ (j k : Site), j ≠ k → ∀ A B : LocalOperator Level,
      expectation ψ (siteOperator j A * siteOperator k B) =
        A.trace * B.trace / ((Fintype.card Level : ℂ) ^ 2))
    {j k : Site} (hjk : j ≠ k) (A : LocalOperator Level) :
    expectation ψ (siteOperator j A) = A.trace / (Fintype.card Level : ℂ) := by
  have hq : (Fintype.card Level : ℂ) ≠ 0 := by
    exact_mod_cast Nat.cast_ne_zero.mpr Fintype.card_ne_zero
  have h := hpair j k hjk A 1
  rw [siteOperator_one, mul_one, Matrix.trace_one] at h
  rw [h, pow_two, ← div_div, mul_div_assoc, div_self hq, mul_one]

/-- The sum of local generators `M = Σ_j h_j^{(j)}`. -/
noncomputable def localGeneratorSum (h : Site → LocalOperator Level) :
    SystemOperator Site Level :=
  ∑ j, siteOperator j (h j)

omit [Fintype Level] in
/-- The conjugate transpose of a sum of local generators is the sum of the
conjugate transposed local generators. -/
theorem conjTranspose_localGeneratorSum (h : Site → LocalOperator Level) :
    (localGeneratorSum h)ᴴ = localGeneratorSum fun j => (h j)ᴴ := by
  unfold localGeneratorSum
  rw [Matrix.conjTranspose_sum]
  exact Finset.sum_congr rfl fun j _ => siteOperator_conjTranspose j (h j)

omit [Fintype Level] in
/-- A sum of Hermitian local generators is Hermitian. -/
theorem localGeneratorSum_isHermitian {h : Site → LocalOperator Level}
    (hherm : ∀ j, (h j).IsHermitian) : (localGeneratorSum h).IsHermitian := by
  unfold Matrix.IsHermitian
  rw [conjTranspose_localGeneratorSum]
  exact congrArg localGeneratorSum (funext fun j => hherm j)

/-- The expectation of a sum of local generators is the normalized sum of the
local traces. -/
theorem expectation_localGeneratorSum {ψ : Label Site Level → ℂ}
    (hψ : IsTwoUniform ψ) (h : Site → LocalOperator Level) :
    expectation ψ (localGeneratorSum h) =
      (∑ j, (h j).trace) / (Fintype.card Level : ℂ) := by
  unfold localGeneratorSum
  rw [expectation_sum, ← sum_div_const]
  exact Finset.sum_congr rfl fun j _ => hψ.single j (h j)

/-- Traceless local generators have vanishing expectation. -/
theorem expectation_localGeneratorSum_eq_zero {ψ : Label Site Level → ℂ}
    (hψ : IsTwoUniform ψ) {h : Site → LocalOperator Level}
    (htr : ∀ j, (h j).trace = 0) :
    expectation ψ (localGeneratorSum h) = 0 := by
  rw [expectation_localGeneratorSum hψ h]
  simp [htr]

/-- The polarized second-moment identity.  For traceless local generators, with
the first family Hermitian, the inner product of the two generated vectors is
the normalized product Frobenius pairing of the local generators.  The cross
terms cancel exactly because every two-site reduced density operator is the
normalized identity, and the diagonal terms are evaluated by the one-site
condition.  Tracelessness of the second family is not needed: the cross terms
already vanish through the first. -/
theorem stateInner_localGeneratorSum_mulVec {ψ : Label Site Level → ℂ}
    (hψ : IsTwoUniform ψ) {h h' : Site → LocalOperator Level}
    (hherm : ∀ j, (h j).IsHermitian) (htr : ∀ j, (h j).trace = 0) :
    stateInner (localGeneratorSum h *ᵥ ψ) (localGeneratorSum h' *ᵥ ψ) =
      (∑ j, (h j * h' j).trace) / (Fintype.card Level : ℂ) := by
  have hadj :
      stateInner (localGeneratorSum h *ᵥ ψ) (localGeneratorSum h' *ᵥ ψ) =
        expectation ψ (localGeneratorSum h * localGeneratorSum h') := by
    rw [stateInner_mulVec_left, localGeneratorSum_isHermitian hherm,
      Matrix.mulVec_mulVec, expectation_eq_stateInner]
  rw [hadj]
  have hexpand : localGeneratorSum h * localGeneratorSum h' =
      ∑ j : Site, ∑ k : Site, siteOperator j (h j) * siteOperator k (h' k) := by
    unfold localGeneratorSum
    rw [Finset.sum_mul]
    exact Finset.sum_congr rfl fun j _ => Finset.mul_sum _ _ _
  rw [hexpand, expectation_sum, ← sum_div_const]
  refine Finset.sum_congr rfl fun j _ => ?_
  rw [expectation_sum, Finset.sum_eq_single j]
  · rw [← siteOperator_mul, hψ.single j (h j * h' j)]
  · intro k _ hk
    rw [hψ.pair j k (Ne.symm hk) (h j) (h' k), htr j, zero_mul, zero_div]
  · intro hmem
    exact absurd (Finset.mem_univ j) hmem

omit [DecidableEq Level] in
/-- The Frobenius square of a Hermitian local operator, written as the trace of
its square. -/
theorem trace_mul_self_of_isHermitian {A : LocalOperator Level}
    (hA : A.IsHermitian) :
    (A * A).trace = ∑ a, ∑ b, (Complex.normSq (A a b) : ℂ) := by
  rw [Matrix.trace]
  refine Finset.sum_congr rfl fun a _ => ?_
  rw [Matrix.diag_apply, Matrix.mul_apply]
  refine Finset.sum_congr rfl fun b _ => ?_
  have hAb : A a b = conj (A b a) := by
    conv_lhs => rw [← hA]
    rw [Matrix.conjTranspose_apply]
    rfl
  rw [hAb, Complex.normSq_eq_conj_mul_self]
  simp [mul_comm]

/-- The squared norm of the generated vector is the normalized product
Frobenius form of the local generators. -/
theorem stateInner_self_localGeneratorSum_mulVec {ψ : Label Site Level → ℂ}
    (hψ : IsTwoUniform ψ) {h : Site → LocalOperator Level}
    (hherm : ∀ j, (h j).IsHermitian) (htr : ∀ j, (h j).trace = 0) :
    stateInner (localGeneratorSum h *ᵥ ψ) (localGeneratorSum h *ᵥ ψ) =
      (∑ j, ∑ a, ∑ b, (Complex.normSq ((h j) a b) : ℂ)) /
        (Fintype.card Level : ℂ) := by
  rw [stateInner_localGeneratorSum_mulVec hψ hherm htr]
  congr 1
  exact Finset.sum_congr rfl fun j _ => trace_mul_self_of_isHermitian (hherm j)

/-- The isometry is injective: a family of traceless Hermitian local generators
annihilating a 2-uniform state is identically zero. -/
theorem eq_zero_of_localGeneratorSum_mulVec_eq_zero [Nonempty Level]
    {ψ : Label Site Level → ℂ}
    (hψ : IsTwoUniform ψ) {h : Site → LocalOperator Level}
    (hherm : ∀ j, (h j).IsHermitian) (htr : ∀ j, (h j).trace = 0)
    (hzero : localGeneratorSum h *ᵥ ψ = 0) :
    ∀ j, h j = 0 := by
  have hq : (Fintype.card Level : ℂ) ≠ 0 := by
    exact_mod_cast Nat.cast_ne_zero.mpr Fintype.card_ne_zero
  have hnorm := stateInner_self_localGeneratorSum_mulVec hψ hherm htr
  rw [hzero] at hnorm
  have hzero' : (∑ j, ∑ a, ∑ b, (Complex.normSq ((h j) a b) : ℂ)) = 0 := by
    have hz : stateInner (0 : Label Site Level → ℂ) 0 = 0 := by
      unfold stateInner; simp
    rw [hz] at hnorm
    exact (div_eq_zero_iff.mp hnorm.symm).resolve_right hq
  have hreal : (∑ j, ∑ a, ∑ b, Complex.normSq ((h j) a b)) = 0 := by
    have hcast : ((∑ j, ∑ a, ∑ b, Complex.normSq ((h j) a b) : ℝ) : ℂ) = 0 := by
      simp only [Complex.ofReal_sum]
      exact hzero'
    exact Complex.ofReal_eq_zero.mp hcast
  intro j
  ext a b
  have hpos : ∀ j' : Site, (0 : ℝ) ≤ ∑ a, ∑ b, Complex.normSq ((h j') a b) :=
    fun j' => Finset.sum_nonneg fun a _ =>
      Finset.sum_nonneg fun b _ => Complex.normSq_nonneg _
  have hj := (Finset.sum_eq_zero_iff_of_nonneg fun j' _ => hpos j').mp hreal j
    (Finset.mem_univ j)
  have hposa : ∀ a' : Level, (0 : ℝ) ≤ ∑ b, Complex.normSq ((h j) a' b) :=
    fun a' => Finset.sum_nonneg fun b _ => Complex.normSq_nonneg _
  have ha := (Finset.sum_eq_zero_iff_of_nonneg fun a' _ => hposa a').mp hj a
    (Finset.mem_univ a)
  have hb := (Finset.sum_eq_zero_iff_of_nonneg
    fun b' _ => Complex.normSq_nonneg ((h j) a b')).mp ha b (Finset.mem_univ b)
  rw [Matrix.zero_apply]
  exact Complex.normSq_eq_zero.mp hb

end RelativeConicArcs.AMELU.Multipartite
