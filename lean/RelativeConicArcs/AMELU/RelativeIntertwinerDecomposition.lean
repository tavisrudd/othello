import RelativeConicArcs.AMELU.ApproximateSymmetryDecomposition

/-!
# Relative decomposition around an exact product intertwiner

An exact product intertwiner from a normalized state ψ to a normalized state
φ identifies the exact-intertwiner set with a translate of the ray-symmetry
group of ψ.  The same translation identifies the two-state squared defect with
the one-state squared defect.  Consequently every hypothesis-explicit
decomposition theorem for approximate symmetries transfers to approximate
intertwiners with exactly the same threshold and generator-norm coefficient.

The analytic input remains explicit.  This module does not derive a cleaning
radius or a numerical stability coefficient; it proves that any such one-state
input is preserved without loss under translation by an exact base
intertwiner.

All arguments are symbolic and kernel checked.  The module contains no
generated data, native evaluation, axioms, or admitted declarations.
-/

namespace RelativeConicArcs.AMELU.Multipartite

open scoped BigOperators ComplexConjugate
open Finset Matrix

variable {Site Level : Type*} [Fintype Site] [DecidableEq Site]
  [Fintype Level] [DecidableEq Level]

/-- A system operator mapping the complex line spanned by ψ into the line
spanned by φ. -/
def IsRayIntertwiner (ψ φ : Label Site Level → ℂ)
    (B : SystemOperator Site Level) : Prop :=
  ∃ lam : ℂ, B *ᵥ ψ = lam • φ

/-- The squared distance from the image of ψ to the ray of φ, expressed
through their transition amplitude.  For normalized states and a unitary
operator this equals the phase-optimized squared Hilbert-space distance. -/
noncomputable def intertwinerDefectSq (ψ φ : Label Site Level → ℂ)
    (A : SystemOperator Site Level) : ℝ :=
  2 - 2 * ‖stateInner φ (A *ᵥ ψ)‖

/-- The scalar of a unitary exact ray intertwiner between normalized states is
unimodular, and the adjoint maps the target state back with the conjugate
scalar. -/
theorem rayIntertwiner_eigenvalue {ψ φ : Label Site Level → ℂ}
    (hψ : stateInner ψ ψ = 1) (hφ : stateInner φ φ = 1)
    {B : SystemOperator Site Level} (hB : IsUnitaryOperator B)
    {lam : ℂ} (hlam : B *ᵥ ψ = lam • φ) :
    conj lam * lam = 1 ∧ Bᴴ *ᵥ φ = conj lam • ψ := by
  have hself : stateInner (B *ᵥ ψ) (B *ᵥ ψ) = 1 := by
    rw [stateInner_mulVec_left, Matrix.mulVec_mulVec, hB, Matrix.one_mulVec, hψ]
  have hmod : conj lam * lam = 1 := by
    rw [hlam, stateInner_smul_left, stateInner_smul_right, hφ, mul_one] at hself
    exact hself
  refine ⟨hmod, ?_⟩
  have hBB : Bᴴ *ᵥ (B *ᵥ ψ) = ψ := by
    rw [Matrix.mulVec_mulVec, hB, Matrix.one_mulVec]
  rw [hlam, Matrix.mulVec_smul] at hBB
  have hlamne : lam ≠ 0 := by
    intro hzero
    rw [hzero, map_zero, zero_mul] at hmod
    exact zero_ne_one hmod
  have hscaled := congrArg (fun v : Label Site Level → ℂ => lam⁻¹ • v) hBB
  simp only [smul_smul, inv_mul_cancel₀ hlamne, one_smul] at hscaled
  rw [hscaled, inv_eq_of_mul_eq_one_left hmod]

/-- Left translation by a unitary exact base intertwiner identifies the
two-state defect with the one-state defect. -/
theorem intertwinerDefectSq_intertwiner_mul {ψ φ : Label Site Level → ℂ}
    (hψ : stateInner ψ ψ = 1) (hφ : stateInner φ φ = 1)
    {B : SystemOperator Site Level} (hB : IsUnitaryOperator B)
    (hinter : IsRayIntertwiner ψ φ B) (V : SystemOperator Site Level) :
    intertwinerDefectSq ψ φ (B * V) = defectSq ψ V := by
  obtain ⟨lam, hlam⟩ := hinter
  obtain ⟨hmod, hadj⟩ := rayIntertwiner_eigenvalue hψ hφ hB hlam
  have hstep :
      stateInner (Bᴴ *ᵥ φ) (V *ᵥ ψ) =
        stateInner φ (B *ᵥ (V *ᵥ ψ)) := by
    rw [stateInner_mulVec_left, Matrix.conjTranspose_conjTranspose]
  have hamp :
      stateInner φ ((B * V) *ᵥ ψ) = lam * expectation ψ V := by
    rw [← Matrix.mulVec_mulVec, ← hstep, hadj, stateInner_smul_left,
      Complex.conj_conj, expectation_eq_stateInner]
  have hlamnorm : ‖lam‖ = 1 := by
    have h1 : ‖conj lam * lam‖ = 1 := by rw [hmod, norm_one]
    rw [norm_mul, RCLike.norm_conj] at h1
    rcases mul_self_eq_one_iff.mp h1 with hone | hneg
    · exact hone
    · have hnn := norm_nonneg lam
      rw [hneg] at hnn
      linarith
  unfold intertwinerDefectSq defectSq
  rw [hamp, norm_mul, hlamnorm, one_mul]

omit [DecidableEq Level] in
/-- Multiplying an exact base intertwiner by an exact ray symmetry of its
source gives another exact intertwiner with the same target. -/
theorem IsRayIntertwiner.mul_symmetry {ψ φ : Label Site Level → ℂ}
    {B g : SystemOperator Site Level}
    (hB : IsRayIntertwiner ψ φ B) (hg : IsRaySymmetry ψ g) :
    IsRayIntertwiner ψ φ (B * g) := by
  obtain ⟨lam, hlam⟩ := hB
  obtain ⟨mu, hmu⟩ := hg
  refine ⟨mu * lam, ?_⟩
  rw [← Matrix.mulVec_mulVec, hmu, Matrix.mulVec_smul, hlam, smul_smul, mul_comm]

/-- Products of unitary system operators are unitary. -/
theorem IsUnitaryOperator.mul {A B : SystemOperator Site Level}
    (hA : IsUnitaryOperator A) (hB : IsUnitaryOperator B) :
    IsUnitaryOperator (A * B) := by
  unfold IsUnitaryOperator at hA hB ⊢
  rw [Matrix.conjTranspose_mul]
  calc
    Bᴴ * Aᴴ * (A * B) = Bᴴ * (Aᴴ * A) * B := by simp only [mul_assoc]
    _ = 1 := by rw [hA, mul_one, hB]

/-- The two-state decomposition obtained by translating a one-state
decomposition through an exact product base intertwiner.  The threshold and
the squared generator-norm coefficient are exactly those supplied by the
one-state input. -/
theorem relative_approximate_decomposition {ψ φ : Label Site Level → ℂ}
    (hψ : stateInner ψ ψ = 1) (hφ : stateInner φ φ = 1)
    (inputs : ApproximateDecompositionInputs ψ)
    (B U : Site → LocalOperator Level)
    (hBunit : IsUnitaryOperator (tensorOperator B))
    (hBinter : IsRayIntertwiner ψ φ (tensorOperator B))
    (hU : intertwinerDefectSq ψ φ (tensorOperator U) < inputs.threshold) :
    ∃ (H : SystemOperator Site Level) (h : Site → LocalOperator Level),
      IsRayIntertwiner ψ φ H ∧ IsUnitaryOperator H ∧ IsProductOperator H ∧
        (∀ j, (h j).IsHermitian) ∧ (∀ j, (h j).trace = 0) ∧
        tensorOperator U =
          H * tensorOperator (fun j => NormedSpace.exp (Complex.I • h j)) ∧
        frobeniusSq h ≤
          inputs.coefficient * intertwinerDefectSq ψ φ (tensorOperator U) := by
  let V : Site → LocalOperator Level := fun j => (B j)ᴴ * U j
  have hVop :
      tensorOperator V = (tensorOperator B)ᴴ * tensorOperator U := by
    rw [tensorOperator_conjTranspose, tensorOperator_mul]
  have hBB : tensorOperator B * (tensorOperator B)ᴴ = 1 :=
    mul_eq_one_comm.mp hBunit
  have hBU : tensorOperator B * tensorOperator V = tensorOperator U := by
    rw [hVop, ← mul_assoc, hBB, one_mul]
  have hdef :
      defectSq ψ (tensorOperator V) =
        intertwinerDefectSq ψ φ (tensorOperator U) := by
    rw [← hBU, intertwinerDefectSq_intertwiner_mul hψ hφ hBunit hBinter]
  have hVsmall : defectSq ψ (tensorOperator V) < inputs.threshold := by
    rwa [hdef]
  obtain ⟨g, h, hgsym, hgunit, hgprod, hherm, htr, hfactor, hbound⟩ :=
    approximate_decomposition hψ inputs V hVsmall
  have hBprod : IsProductOperator (tensorOperator B) := ⟨B, rfl⟩
  refine ⟨tensorOperator B * g, h, hBinter.mul_symmetry hgsym,
    hBunit.mul hgunit, hBprod.mul hgprod,
    hherm, htr, ?_, ?_⟩
  · calc
      tensorOperator U = tensorOperator B * tensorOperator V := hBU.symm
      _ = tensorOperator B *
          (g * tensorOperator (fun j => NormedSpace.exp (Complex.I • h j))) := by
            rw [hfactor]
      _ = (tensorOperator B * g) *
          tensorOperator (fun j => NormedSpace.exp (Complex.I • h j)) :=
            (mul_assoc _ _ _).symm
  · rwa [hdef] at hbound

end RelativeConicArcs.AMELU.Multipartite
