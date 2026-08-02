import RelativeConicArcs.AMELU.LocalGeneratorDecomposition

/-!
# Defect of a product unitary and the decomposition of approximate symmetries

The *defect* of a system operator `U` in a normalized state `ψ` is
`ε(U)² = 2 - 2|⟨ψ|U|ψ⟩|`, the squared distance from `U ψ` to the ray of `ψ`
after optimizing the global phase.  A system operator is an *exact ray
symmetry* of `ψ` when it maps `ψ` into its own complex line.

Two things are recorded here.

First, an unconditional lemma: the defect is unchanged when an exact ray
symmetry that is unitary is composed on either side.  Both invariances are
needed by the manuscript's decomposition argument, which measures the local
generators of an approximate symmetry from the nearest exact symmetry: the
factorization `U = g · ⊗_j exp(i h_j)` places the exact symmetry on the left, so
it is left invariance that transports the growth estimate to the translate.

Second, a hypothesis-explicit interface for the decomposition itself.  The
manuscript obtains a threshold `ε₀(ψ) > 0` from compactness of the projective
group of local factors together with finiteness of the zero set of the defect,
and that extraction is not formalized: it appears here as the field
`exists_nearby_symmetry` of `ApproximateDecompositionInputs`, which asserts that
every product unitary of defect below the threshold factors through an exact ray
symmetry with small traceless local generators.  The quadratic growth estimate
that converts the generator size into a defect bound is the second field.  The
terminal theorem composes the two into the manuscript's conclusion, and is
therefore a conditional formal interface rather than an unconditional theorem;
the threshold is not explicit and no compactness extraction is carried out in
Lean.

All arguments are symbolic and kernel checked.  The module contains no
generated data, native evaluation, axioms, or admitted declarations.
-/

namespace RelativeConicArcs.AMELU.Multipartite

open scoped BigOperators ComplexConjugate
open Finset Matrix

variable {Site Level : Type*} [Fintype Site] [DecidableEq Site]
  [Fintype Level] [DecidableEq Level]

omit [DecidableEq Level] in
/-- The inner product is conjugate linear in its first argument. -/
theorem stateInner_smul_left (c : ℂ) (φ ψ : Label Site Level → ℂ) :
    stateInner (c • φ) ψ = conj c * stateInner φ ψ := by
  unfold stateInner
  rw [Finset.mul_sum]
  refine Finset.sum_congr rfl fun x _ => ?_
  rw [Pi.smul_apply, smul_eq_mul, map_mul]
  ring

/-- A system operator preserving the complex line spanned by a state. -/
def IsRaySymmetry (ψ : Label Site Level → ℂ) (g : SystemOperator Site Level) : Prop :=
  ∃ lam : ℂ, g *ᵥ ψ = lam • ψ

/-- Column orthonormality of a system operator. -/
def IsUnitaryOperator (A : SystemOperator Site Level) : Prop :=
  Aᴴ * A = 1

/-- The squared defect of a system operator in a state: the squared distance
from the image of the state to the ray of the state, optimized over the global
phase. -/
noncomputable def defectSq (ψ : Label Site Level → ℂ)
    (A : SystemOperator Site Level) : ℝ :=
  2 - 2 * ‖expectation ψ A‖

/-- The eigenvalue of a unitary exact ray symmetry is unimodular, and the
adjoint symmetry has the inverse eigenvalue. -/
theorem raySymmetry_eigenvalue {ψ : Label Site Level → ℂ}
    (hnorm : stateInner ψ ψ = 1) {g : SystemOperator Site Level}
    (hg : IsUnitaryOperator g) {lam : ℂ} (hlam : g *ᵥ ψ = lam • ψ) :
    conj lam * lam = 1 ∧ gᴴ *ᵥ ψ = conj lam • ψ := by
  have hself : stateInner (g *ᵥ ψ) (g *ᵥ ψ) = 1 := by
    rw [stateInner_mulVec_left, Matrix.mulVec_mulVec, hg, Matrix.one_mulVec, hnorm]
  have hmod : conj lam * lam = 1 := by
    rw [hlam, stateInner_smul_left, stateInner_smul_right, hnorm, mul_one] at hself
    exact hself
  refine ⟨hmod, ?_⟩
  have hgg : gᴴ *ᵥ (g *ᵥ ψ) = ψ := by
    rw [Matrix.mulVec_mulVec, hg, Matrix.one_mulVec]
  rw [hlam, Matrix.mulVec_smul] at hgg
  have hlamne : lam ≠ 0 := by
    intro hzero
    rw [hzero, map_zero, zero_mul] at hmod
    exact zero_ne_one hmod
  have hscaled := congrArg (fun v : Label Site Level → ℂ => lam⁻¹ • v) hgg
  simp only [smul_smul, inv_mul_cancel₀ hlamne, one_smul] at hscaled
  rw [hscaled, inv_eq_of_mul_eq_one_left hmod]

/-- Composing a unitary exact ray symmetry on the left does not change the
defect. -/
theorem defectSq_symmetry_mul {ψ : Label Site Level → ℂ}
    (hnorm : stateInner ψ ψ = 1) {g : SystemOperator Site Level}
    (hg : IsUnitaryOperator g) (hsym : IsRaySymmetry ψ g)
    (V : SystemOperator Site Level) :
    defectSq ψ (g * V) = defectSq ψ V := by
  obtain ⟨lam, hlam⟩ := hsym
  obtain ⟨hmod, hadj⟩ := raySymmetry_eigenvalue hnorm hg hlam
  have hstep : stateInner (gᴴ *ᵥ ψ) (V *ᵥ ψ) = stateInner ψ (g *ᵥ (V *ᵥ ψ)) := by
    rw [stateInner_mulVec_left, Matrix.conjTranspose_conjTranspose]
  have hexp : expectation ψ (g * V) = lam * expectation ψ V := by
    rw [expectation_eq_stateInner, expectation_eq_stateInner, ← Matrix.mulVec_mulVec,
      ← hstep, hadj, stateInner_smul_left, Complex.conj_conj]
  have hlamnorm : ‖lam‖ = 1 := by
    have h1 : ‖conj lam * lam‖ = 1 := by rw [hmod, norm_one]
    rw [norm_mul, RCLike.norm_conj] at h1
    rcases mul_self_eq_one_iff.mp h1 with hone | hneg
    · exact hone
    · have hnn := norm_nonneg lam
      rw [hneg] at hnn
      linarith
  unfold defectSq
  rw [hexp, norm_mul, hlamnorm, one_mul]

omit [DecidableEq Level] in
/-- Composing a unitary exact ray symmetry on the right does not change the
defect. -/
theorem defectSq_mul_symmetry {ψ : Label Site Level → ℂ}
    {g : SystemOperator Site Level} (hsym : IsRaySymmetry ψ g)
    (hmod : ∀ lam : ℂ, g *ᵥ ψ = lam • ψ → ‖lam‖ = 1)
    (V : SystemOperator Site Level) :
    defectSq ψ (V * g) = defectSq ψ V := by
  obtain ⟨lam, hlam⟩ := hsym
  have hexp : expectation ψ (V * g) = lam * expectation ψ V := by
    rw [expectation_eq_stateInner, expectation_eq_stateInner, ← Matrix.mulVec_mulVec,
      hlam, Matrix.mulVec_smul, stateInner_smul_right]
  unfold defectSq
  rw [hexp, norm_mul, hmod lam hlam, one_mul]

/-- The squared product Frobenius norm of a family of local generators. -/
noncomputable def frobeniusSq (h : Site → LocalOperator Level) : ℝ :=
  ∑ j, ∑ a, ∑ b, Complex.normSq ((h j) a b)

/-- The two unformalized inputs of the manuscript's decomposition corollary.

The first field is the compactness extraction: a positive threshold below which
every product unitary factors as an exact ray symmetry followed by a product of
one-site exponentials with small traceless Hermitian generators.  The threshold
is not explicit and depends on the state; no compactness argument is carried out
in Lean.

The second field is the quadratic growth estimate of the manuscript's stability
theorem, in the form needed after the factorization: the product Frobenius norm
of the generators is controlled by the defect, with the constant `6q/5`. -/
structure ApproximateDecompositionInputs (ψ : Label Site Level → ℂ) where
  /-- The defect threshold produced by compactness. -/
  threshold : ℝ
  /-- The threshold is positive. -/
  threshold_pos : 0 < threshold
  /-- Below the threshold every product unitary factors through an exact ray
  symmetry, with traceless Hermitian local generators. -/
  exists_nearby_symmetry :
    ∀ U : Site → LocalOperator Level,
      defectSq ψ (tensorOperator U) < threshold →
        ∃ (g : SystemOperator Site Level) (h : Site → LocalOperator Level),
          IsRaySymmetry ψ g ∧ IsUnitaryOperator g ∧
            (∀ j, (h j).IsHermitian) ∧ (∀ j, (h j).trace = 0) ∧
            tensorOperator U =
              g * tensorOperator (fun j => NormedSpace.exp (Complex.I • h j))
  /-- The quadratic growth estimate of the stability theorem, applied to the
  generators produced by the factorization. -/
  frobeniusSq_le :
    ∀ h : Site → LocalOperator Level,
      (∀ j, (h j).IsHermitian) → (∀ j, (h j).trace = 0) →
        frobeniusSq h ≤
          (6 * (Fintype.card Level : ℝ) / 5) *
            defectSq ψ (tensorOperator (fun j => NormedSpace.exp (Complex.I • h j)))

/-- The manuscript's decomposition of approximate symmetries, derived from the
compactness threshold and the quadratic growth estimate.  Every product unitary
whose defect is below the threshold is an exact ray symmetry composed with a
product of one-site exponentials whose traceless Hermitian generators have
product Frobenius norm controlled by the defect of the original operator.  The
left invariance of the defect under the exact factor is what transports the
estimate to the translate. -/
theorem approximate_decomposition {ψ : Label Site Level → ℂ}
    (hnorm : stateInner ψ ψ = 1)
    (inputs : ApproximateDecompositionInputs ψ)
    (U : Site → LocalOperator Level)
    (hU : defectSq ψ (tensorOperator U) < inputs.threshold) :
    ∃ (g : SystemOperator Site Level) (h : Site → LocalOperator Level),
      IsRaySymmetry ψ g ∧ IsUnitaryOperator g ∧
        (∀ j, (h j).IsHermitian) ∧ (∀ j, (h j).trace = 0) ∧
        tensorOperator U =
          g * tensorOperator (fun j => NormedSpace.exp (Complex.I • h j)) ∧
        frobeniusSq h ≤
          (6 * (Fintype.card Level : ℝ) / 5) * defectSq ψ (tensorOperator U) := by
  obtain ⟨g, h, hsym, hgunit, hherm, htr, hfactor⟩ :=
    inputs.exists_nearby_symmetry U hU
  refine ⟨g, h, hsym, hgunit, hherm, htr, hfactor, ?_⟩
  have hgrowth := inputs.frobeniusSq_le h hherm htr
  have hdefect :
      defectSq ψ (tensorOperator (fun j => NormedSpace.exp (Complex.I • h j))) =
        defectSq ψ (tensorOperator U) := by
    rw [hfactor, defectSq_symmetry_mul hnorm hgunit hsym]
  rwa [hdefect] at hgrowth

end RelativeConicArcs.AMELU.Multipartite
