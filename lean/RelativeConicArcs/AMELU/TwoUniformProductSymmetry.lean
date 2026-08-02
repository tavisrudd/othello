import RelativeConicArcs.AMELU.LocalGeneratorDecomposition
import RelativeConicArcs.AMELU.TwoUniformDiscreteness

/-!
# Continuous product-unitary symmetries of a 2-uniform state are scalar

Let `ψ` be a 2-uniform state of finitely many sites of local dimension
`q = Fintype.card Level`, and let `H j` be Hermitian local operators.  The
product unitaries `⊗_j exp(i t H_j)`, `t` real, form a one-parameter group of
product unitaries, and every one-parameter group of product unitaries with a
differentiable lift to the local factors has this form.

The theorem states that such a group fixes the ray of `ψ` only when every
`H j` is a scalar multiple of the identity, that is, when every product unitary
in the group acts by a global phase.  The proof combines three ingredients: the
traceless/scalar splitting of the Hermitian local generators, the
single-exponential identity for a product of one-site exponentials, and the
polarized second-moment identity of a 2-uniform state.

The remaining step of the manuscript's discreteness theorem — that a compact
symmetry group with trivial Lie algebra is finite modulo global phase — belongs
to the Lie theory of closed subgroups and is not formalized here.

All arguments are symbolic and kernel checked.  The module contains no
generated data, native evaluation, axioms, or admitted declarations.
-/

namespace RelativeConicArcs.AMELU.Multipartite

open scoped BigOperators ComplexConjugate
open Finset Matrix

variable {Site Level : Type*} [Fintype Site] [DecidableEq Site]
  [Fintype Level] [DecidableEq Level]

omit [Fintype Level] in
/-- Scaling every local generator scales the summed local generator. -/
theorem localGeneratorSum_smul (z : ℂ) (H : Site → LocalOperator Level) :
    localGeneratorSum (fun j => z • H j) = z • localGeneratorSum H := by
  unfold localGeneratorSum
  rw [Finset.smul_sum]
  exact Finset.sum_congr rfl fun j _ => siteOperator_smul j z (H j)

omit [DecidableEq Level] in
/-- The trace of a Hermitian matrix is a real number. -/
theorem trace_isReal_of_isHermitian {A : LocalOperator Level} (hA : A.IsHermitian) :
    (A.trace) = ((A.trace.re : ℝ) : ℂ) := by
  refine (Complex.conj_eq_iff_re.mp ?_).symm
  have : star (A.trace) = A.trace := by rw [← Matrix.trace_conjTranspose, hA]
  exact this

/-- A one-parameter group of product unitaries fixing the ray of a 2-uniform
state has scalar local generators: every `H j` equals its normalized trace times
the identity.  Equivalently, the group acts by global phases. -/
theorem tracelessPart_eq_zero_of_productUnitary_ray_invariant [Nonempty Level]
    {ψ : Label Site Level → ℂ} (hψ : IsTwoUniform ψ)
    {H : Site → LocalOperator Level} (hherm : ∀ j, (H j).IsHermitian)
    (hray : ∀ t : ℝ, ∃ lam : ℂ,
      tensorOperator (fun j => NormedSpace.exp ((t : ℂ) • (Complex.I • H j))) *ᵥ ψ
        = lam • ψ) :
    ∀ j, tracelessPart (H j) = 0 := by
  classical
  set h : Site → LocalOperator Level := fun j => tracelessPart (H j) with hh
  have hherm' : ∀ j, (h j).IsHermitian := fun j => isHermitian_tracelessPart (hherm j)
  have htr : ∀ j, (h j).trace = 0 := fun j => trace_tracelessPart (H j)
  -- The scalar part of the generator is real.
  set c : ℝ := ((∑ j, (H j).trace) / (Fintype.card Level : ℂ)).re with hc
  have hcreal : ((∑ j, (H j).trace) / (Fintype.card Level : ℂ)) = (c : ℂ) := by
    refine (Complex.conj_eq_iff_re.mp ?_).symm
    have htrsum : star (∑ j, (H j).trace) = ∑ j, (H j).trace := by
      rw [star_sum]
      exact Finset.sum_congr rfl fun j _ => by
        rw [← Matrix.trace_conjTranspose, hherm j]
    have hqstar : star ((Fintype.card Level : ℂ)) = (Fintype.card Level : ℂ) := by simp
    have := star_div₀ (∑ j, (H j).trace) ((Fintype.card Level : ℂ))
    rw [htrsum, hqstar] at this
    exact this
  -- Rewrite the product unitaries as exponentials of the split generator.
  have hexp : ∀ t : ℝ,
      tensorOperator (fun j => NormedSpace.exp ((t : ℂ) • (Complex.I • H j))) =
        NormedSpace.exp
          (t • (Complex.I • (localGeneratorSum h + (c : ℂ) • (1 : SystemOperator Site Level)))) := by
    intro t
    rw [tensorOperator_exp (fun j => (t : ℂ) • (Complex.I • H j)),
      localGeneratorSum_smul, localGeneratorSum_smul,
      localGeneratorSum_eq_traceless_add_scalar H, hcreal, hh]
    congr 1
  refine localGenerator_eq_zero_of_ray_invariant hψ c hherm' htr ?_
  intro t
  obtain ⟨lam, hlam⟩ := hray t
  exact ⟨lam, by rw [← hexp t]; exact hlam⟩

end RelativeConicArcs.AMELU.Multipartite
