import Mathlib.Analysis.Matrix.Normed
import Mathlib.Analysis.Normed.Algebra.MatrixExponential
import Mathlib.Analysis.SpecialFunctions.Exponential
import Mathlib.Analysis.Calculus.Deriv.Comp
import RelativeConicArcs.AMELU.TwoUniformIsometry

/-!
# No continuous local symmetry of a 2-uniform state

Let `ψ` be a 2-uniform state of finitely many sites of local dimension
`q = Fintype.card Level`.  A one-parameter group of product unitaries acting on
`ψ` has the form `t ↦ exp (t • X)` with `X = i(M + cI)`, where `M = Σ_j h_j^{(j)}`
is a sum of traceless Hermitian local generators and `c` is real: the traceless
and scalar parts of the Hermitian local generators are separated, the scalar
parts are collected into `cI`, and operators at distinct sites commute so that a
product of one-site exponentials is a single exponential.

The theorem below says that such a one-parameter group can fix the ray of `ψ`
only when every traceless part vanishes, so that the generator is the scalar
`icI` and the group is a group of global phases.  The proof is the manuscript
argument: pairing the derivative at the identity against `M ψ` and using the
polarized second-moment identity leaves `‖M ψ‖² = 0`, which the isometry turns
into `h_j = 0` for every site.

What is *not* formalized here is the passage from an abstract one-parameter
subgroup of the symmetry group to a generator of the displayed form, and the
passage from a trivial Lie algebra to finiteness of the symmetry group modulo
global phase; both use Lie theory of closed subgroups, which is outside the
present development.  The hypothesis is therefore stated directly for a
one-parameter group with a generator of summed local form.

All arguments are symbolic and kernel checked.  The module contains no
generated data, native evaluation, axioms, or admitted declarations.
-/

namespace RelativeConicArcs.AMELU.Multipartite

open scoped BigOperators ComplexConjugate Matrix.Norms.Operator
open Finset Matrix

variable {Site Level : Type*} [Fintype Site] [DecidableEq Site]
  [Fintype Level] [DecidableEq Level]

/-- Pairing a fixed vector against the image of a state under a varying system
operator, as a continuous complex-linear functional on operators. -/
private noncomputable def pairingCLM (v ψ : Label Site Level → ℂ) :
    SystemOperator Site Level →L[ℂ] ℂ :=
  LinearMap.toContinuousLinearMap
    { toFun := fun A => stateInner v (A *ᵥ ψ)
      map_add' := by
        intro A B
        rw [show (A + B) *ᵥ ψ = A *ᵥ ψ + B *ᵥ ψ from Matrix.add_mulVec A B ψ,
          stateInner_add_right]
      map_smul' := by
        intro c A
        rw [show (c • A) *ᵥ ψ = c • (A *ᵥ ψ) from Matrix.smul_mulVec c A ψ,
          stateInner_smul_right]
        rfl }

omit [DecidableEq Level] in
private theorem pairingCLM_apply (v ψ : Label Site Level → ℂ)
    (A : SystemOperator Site Level) :
    pairingCLM v ψ A = stateInner v (A *ᵥ ψ) :=
  rfl

/-- A one-parameter group of product unitaries whose generator has summed local
form and which fixes the ray of a 2-uniform state has vanishing traceless
parts.  Consequently its generator is a scalar and the group consists of global
phases. -/
theorem localGenerator_eq_zero_of_ray_invariant [Nonempty Level]
    {ψ : Label Site Level → ℂ} (hψ : IsTwoUniform ψ)
    {h : Site → LocalOperator Level} (c : ℝ)
    (hherm : ∀ j, (h j).IsHermitian) (htr : ∀ j, (h j).trace = 0)
    (hray : ∀ t : ℝ, ∃ lam : ℂ,
      NormedSpace.exp
          (t • (Complex.I • (localGeneratorSum h + (c : ℂ) • (1 : SystemOperator Site Level))))
            *ᵥ ψ = lam • ψ) :
    ∀ j, h j = 0 := by
  classical
  set M : SystemOperator Site Level := localGeneratorSum h with hM
  set X : SystemOperator Site Level :=
    Complex.I • (M + (c : ℂ) • (1 : SystemOperator Site Level)) with hX
  set L := pairingCLM (M *ᵥ ψ) ψ with hL
  -- The generated vector is orthogonal to the state.
  have hMψ : stateInner (M *ᵥ ψ) ψ = 0 := by
    rw [stateInner_mulVec_left, localGeneratorSum_isHermitian hherm,
      ← expectation_eq_stateInner]
    exact expectation_localGeneratorSum_eq_zero hψ htr
  -- Along the one-parameter group the pairing is identically zero.
  have hzeroFun : ∀ t : ℝ, L (NormedSpace.exp (t • X)) = 0 := by
    intro t
    obtain ⟨lam, hlam⟩ := hray t
    rw [hL, pairingCLM_apply, hlam, stateInner_smul_right, hMψ, mul_zero]
  -- Differentiating at the identity.
  have hexp : HasDerivAt (fun t : ℝ => NormedSpace.exp (t • X))
      (NormedSpace.exp ((0 : ℝ) • X) * X) 0 :=
    hasDerivAt_exp_smul_const X (0 : ℝ)
  have hcomp : HasDerivAt (fun t : ℝ => L (NormedSpace.exp (t • X)))
      (L (NormedSpace.exp ((0 : ℝ) • X) * X)) 0 :=
    (L.restrictScalars ℝ).hasFDerivAt.comp_hasDerivAt 0 hexp
  have hconst : HasDerivAt (fun t : ℝ => L (NormedSpace.exp (t • X))) 0 0 := by
    have : (fun t : ℝ => L (NormedSpace.exp (t • X))) = fun _ : ℝ => (0 : ℂ) :=
      funext hzeroFun
    rw [this]
    exact hasDerivAt_const 0 0
  have hLX : L X = 0 := by
    have huniq := hcomp.unique hconst
    rwa [zero_smul, NormedSpace.exp_zero, one_mul] at huniq
  -- Unwinding the pairing gives a vanishing norm.
  have hsplit : stateInner (M *ᵥ ψ) (X *ᵥ ψ) =
      Complex.I * (stateInner (M *ᵥ ψ) (M *ᵥ ψ) + (c : ℂ) * stateInner (M *ᵥ ψ) ψ) := by
    rw [hX, Matrix.smul_mulVec, stateInner_smul_right, Matrix.add_mulVec,
      stateInner_add_right, Matrix.smul_mulVec, Matrix.one_mulVec,
      stateInner_smul_right]
  have hnorm : stateInner (M *ᵥ ψ) (M *ᵥ ψ) = 0 := by
    have h0 : stateInner (M *ᵥ ψ) (X *ᵥ ψ) = 0 := by
      rw [← pairingCLM_apply (M *ᵥ ψ) ψ X, ← hL]
      exact hLX
    rw [hsplit, hMψ, mul_zero, add_zero] at h0
    exact (mul_eq_zero.mp h0).resolve_left Complex.I_ne_zero
  exact eq_zero_of_stateInner_self_eq_zero hψ hherm htr hnorm

/-- Under the hypotheses of the discreteness theorem the generator itself is the
scalar `i c I`: the summed local generator vanishes. -/
theorem localGeneratorSum_eq_zero_of_ray_invariant [Nonempty Level]
    {ψ : Label Site Level → ℂ} (hψ : IsTwoUniform ψ)
    {h : Site → LocalOperator Level} (c : ℝ)
    (hherm : ∀ j, (h j).IsHermitian) (htr : ∀ j, (h j).trace = 0)
    (hray : ∀ t : ℝ, ∃ lam : ℂ,
      NormedSpace.exp
          (t • (Complex.I • (localGeneratorSum h + (c : ℂ) • (1 : SystemOperator Site Level))))
            *ᵥ ψ = lam • ψ) :
    localGeneratorSum h = 0 := by
  have hzero := localGenerator_eq_zero_of_ray_invariant hψ c hherm htr hray
  unfold localGeneratorSum
  refine Finset.sum_eq_zero fun j _ => ?_
  rw [hzero j, siteOperator_zero]

end RelativeConicArcs.AMELU.Multipartite
