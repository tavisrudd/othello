import Mathlib.Algebra.Polynomial.Roots
import Mathlib.RingTheory.Polynomial.Basic
import Mathlib.Algebra.Polynomial.Eval.SMul
import Mathlib.LinearAlgebra.Pi
import FiniteGeom.Code

/-!
# Reed–Solomon / evaluation codes and the MDS distance lower bound (`FiniteGeom` base)

The distance **lower**-bound tool for the coding lane — the direction that Singleton
(`FiniteGeom.Code.singleton_bound`, an *upper* bound) does not supply and that the real
min-distance claims (the `q = 9` seed, the uniform `q = 3^h` family) turn on.

The mathematical heart is one classical fact: a nonzero polynomial of degree `< k` vanishes
at fewer than `k` of the `n` distinct evaluation points (`card_eval_zero_le_natDegree`), so
its evaluation vector has Hamming weight `≥ n - (k-1)`. Packaged as the **Reed–Solomon code**
`rsCode pts k` (evaluations of `degreeLT k` polynomials at `n` distinct points), this gives
`n - (k-1) ≤ d(rsCode pts k)` (`rsCode_minDist_ge`). Combined with `singleton_bound` this is the
MDS property; the equality direction (needing `finrank (rsCode) = k`) is a later job.

Pure finite algebra, no imported input; every result `#print axioms`-clean.
-/

namespace FiniteGeom

open Finset Polynomial

variable {n : ℕ} {𝔽 : Type*} [Field 𝔽] [DecidableEq 𝔽]

/-- A nonzero polynomial `p` vanishes at at most `deg p` of the distinct points `pts`, because
the vanishing points map injectively to distinct roots of `p`, of which there are `≤ deg p`. -/
theorem card_eval_zero_le_natDegree {p : 𝔽[X]} (hp : p ≠ 0) {pts : Fin n → 𝔽}
    (hpts : Function.Injective pts) :
    #(univ.filter fun i => p.eval (pts i) = 0) ≤ p.natDegree := by
  calc #(univ.filter fun i => p.eval (pts i) = 0)
      = #((univ.filter fun i => p.eval (pts i) = 0).image pts) :=
        (Finset.card_image_of_injective _ hpts).symm
    _ ≤ #p.roots.toFinset := by
        apply Finset.card_le_card
        intro x hx
        simp only [Finset.mem_image, Finset.mem_filter, Finset.mem_univ, true_and] at hx
        obtain ⟨i, hi, rfl⟩ := hx
        rw [Multiset.mem_toFinset, mem_roots hp]
        exact hi
    _ ≤ Multiset.card p.roots := p.roots.toFinset_card_le
    _ ≤ p.natDegree := card_roots' p

/-- Evaluation of polynomials at the points `pts`, as an `𝔽`-linear map `𝔽[X] → (Fin n → 𝔽)`. -/
noncomputable def evalPi (pts : Fin n → 𝔽) : 𝔽[X] →ₗ[𝔽] (Fin n → 𝔽) :=
  LinearMap.pi fun i => Polynomial.leval (pts i)

omit [DecidableEq 𝔽] in
@[simp] theorem evalPi_apply (pts : Fin n → 𝔽) (p : 𝔽[X]) (i : Fin n) :
    evalPi pts p i = p.eval (pts i) := rfl

/-- The **Reed–Solomon code** `RS_k(pts)`: evaluation vectors of polynomials of degree `< k`
at the `n` points `pts`. -/
noncomputable def rsCode (pts : Fin n → 𝔽) (k : ℕ) : Submodule 𝔽 (Fin n → 𝔽) :=
  Submodule.map (evalPi pts) (degreeLT 𝔽 k)

/-- **Weight lower bound.** Every nonzero RS codeword has Hamming weight `≥ n - (k-1)`: it is
the evaluation of a nonzero degree-`< k` polynomial, which vanishes at `≤ k-1` of the `n`
distinct points, so it is nonzero at `≥ n-(k-1)` of them. -/
theorem rsCode_hammingNorm_ge {pts : Fin n → 𝔽} (hpts : Function.Injective pts) {k : ℕ}
    {c : Fin n → 𝔽} (hc : c ∈ rsCode pts k) (hcne : c ≠ 0) :
    n - (k - 1) ≤ hammingNorm c := by
  obtain ⟨p, hpmem, hpc⟩ := hc
  have hp0 : p ≠ 0 := by
    rintro rfl
    rw [map_zero] at hpc
    exact hcne hpc.symm
  have hci : ∀ i, c i = p.eval (pts i) := fun i => by rw [← hpc, evalPi_apply]
  have hdeg : p.natDegree < k := (natDegree_lt_iff_degree_lt hp0).mpr ((mem_degreeLT).mp hpmem)
  have hz : #(univ.filter fun i => c i = 0) ≤ p.natDegree := by
    have h := card_eval_zero_le_natDegree hp0 hpts
    simpa only [← hci] using h
  -- `hammingNorm c` is by definition the count of nonzero coordinates.
  have hnorm : hammingNorm c = #(univ.filter fun i => c i ≠ 0) := rfl
  -- the nonzero and zero coordinate sets cover all `n` coordinates.
  have hunion : (univ.filter fun i => c i ≠ 0) ∪ (univ.filter fun i => c i = 0)
      = (univ : Finset (Fin n)) := by
    ext i
    simp only [Finset.mem_union, Finset.mem_filter, Finset.mem_univ, true_and, iff_true]
    by_cases h : c i = 0
    · exact Or.inr h
    · exact Or.inl h
  have hcard : n ≤ #(univ.filter fun i => c i ≠ 0) + #(univ.filter fun i => c i = 0) := by
    calc n = (univ : Finset (Fin n)).card := by rw [Finset.card_univ, Fintype.card_fin]
      _ = ((univ.filter fun i => c i ≠ 0) ∪ (univ.filter fun i => c i = 0)).card := by rw [hunion]
      _ ≤ _ := Finset.card_union_le _ _
  rw [← hnorm] at hcard
  omega

/-- **Reed–Solomon distance lower bound** (the MDS direction): for `1 ≤ k` and `1 ≤ n`,
`n - (k-1) ≤ d(RS_k(pts))`. Uses `le_minDist` with the per-codeword `rsCode_hammingNorm_ge`;
the code is nontrivial because the constant polynomial `1` evaluates to the nonzero all-ones
word. With `singleton_bound` (`d + k ≤ n+1`, i.e. `d ≤ n-k+1`) this pins `d = n-k+1` when
`k ≤ n`: Reed–Solomon codes are MDS. -/
theorem rsCode_minDist_ge {pts : Fin n → 𝔽} (hpts : Function.Injective pts) {k : ℕ}
    (hk : 1 ≤ k) (hn : 1 ≤ n) : n - (k - 1) ≤ minDist (rsCode pts k) := by
  apply le_minDist
  · -- `rsCode ≠ ⊥`: the all-ones word (evaluation of the constant `1`) is a nonzero codeword.
    rw [Submodule.ne_bot_iff]
    refine ⟨fun _ => 1, ?_, ?_⟩
    · rw [rsCode, Submodule.mem_map]
      refine ⟨(1 : 𝔽[X]), ?_, ?_⟩
      · rw [mem_degreeLT, degree_one]; exact_mod_cast (show (0 : ℕ) < k by omega)
      · funext i; rw [evalPi_apply]; simp
    · intro h
      have := congrFun h ⟨0, hn⟩
      simp at this
  · intro c hc hcne
    exact rsCode_hammingNorm_ge hpts hc hcne

/-- **Dimension of a Reed–Solomon code.** For `k ≤ n` distinct points, `RS_k(pts)` has
dimension `k`: evaluation is injective on degree-`< k` polynomials (a nonzero such polynomial
cannot vanish at all `n ≥ k` points), so `RS_k` is the injective image of `degreeLT 𝔽 k`, whose
dimension is `k`. -/
theorem finrank_rsCode {pts : Fin n → 𝔽} (hpts : Function.Injective pts) {k : ℕ} (hk : k ≤ n) :
    Module.finrank 𝔽 (rsCode pts k) = k := by
  haveI : Module.Finite 𝔽 (degreeLT 𝔽 k) := Module.Finite.equiv (degreeLTEquiv 𝔽 k).symm
  set g : degreeLT 𝔽 k →ₗ[𝔽] (Fin n → 𝔽) := (evalPi pts).comp (degreeLT 𝔽 k).subtype with hg
  have hginj : Function.Injective g := by
    rw [← LinearMap.ker_eq_bot, Submodule.eq_bot_iff]
    intro x hx
    rw [LinearMap.mem_ker] at hx
    by_contra hxne
    have hval : (x : 𝔽[X]) ≠ 0 := fun h => hxne (Submodule.coe_eq_zero.mp h)
    have hdeg : (x : 𝔽[X]).natDegree < k :=
      (natDegree_lt_iff_degree_lt hval).mpr ((mem_degreeLT).mp x.2)
    have hall : ∀ i, (x : 𝔽[X]).eval (pts i) = 0 := fun i => by
      have := congrFun hx i
      simpa [hg, LinearMap.comp_apply, evalPi_apply] using this
    have hcard : #(univ.filter fun i => (x : 𝔽[X]).eval (pts i) = 0) = n := by
      rw [Finset.filter_true_of_mem (fun i _ => hall i), Finset.card_univ, Fintype.card_fin]
    have hle := card_eval_zero_le_natDegree hval hpts
    rw [hcard] at hle
    omega
  have hrange : LinearMap.range g = rsCode pts k := by
    unfold rsCode
    rw [hg, LinearMap.range_comp, Submodule.range_subtype]
  calc Module.finrank 𝔽 (rsCode pts k)
      = Module.finrank 𝔽 (LinearMap.range g) := by rw [hrange]
    _ = Module.finrank 𝔽 (degreeLT 𝔽 k) := LinearMap.finrank_range_of_inj hginj
    _ = Module.finrank 𝔽 (Fin k → 𝔽) := (degreeLTEquiv 𝔽 k).finrank_eq
    _ = k := by rw [Module.finrank_pi, Fintype.card_fin]

/-- **Reed–Solomon codes are MDS.** For `1 ≤ k ≤ n` distinct points, `RS_k(pts)` meets the
Singleton bound with equality: `d + k = n + 1`. The lower bound `n-(k-1) ≤ d`
(`rsCode_minDist_ge`) and the Singleton upper bound `d + k ≤ n + 1` (`singleton_bound`, using
`finrank_rsCode`) pin `d = n - k + 1`. -/
theorem rsCode_isMDS {pts : Fin n → 𝔽} (hpts : Function.Injective pts) {k : ℕ}
    (hk1 : 1 ≤ k) (hkn : k ≤ n) : IsMDS (rsCode pts k) := by
  unfold IsMDS
  rw [finrank_rsCode hpts hkn]
  have hlow := rsCode_minDist_ge hpts hk1 (by omega : 1 ≤ n)
  have hup := singleton_bound (rsCode pts k)
  rw [finrank_rsCode hpts hkn] at hup
  omega

end FiniteGeom
