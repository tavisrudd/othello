import RelativeConicArcs.AMELU.OrderedFourConjugation
import RelativeConicArcs.AMELU.PartialTraceCovariance

/-!
# Reduced-matrix covariance for six-party amplitude states

Splitting a six-party basis label into subsystem and environment
coordinates identifies the `localAction` of `Definitions` with a Kronecker
product acting on the assembled state vector.  The reduced matrix
`marginalEntry` is the partial trace of the corresponding rank-one density
matrix.  The generic partial-trace identity therefore gives covariance under
local product unitaries, with the chosen global phase cancelling by its
norm-one hypothesis.

All arguments are symbolic and kernel checked.  The module contains no
generated data, native evaluation, axioms, or admitted declarations.
-/

namespace RelativeConicArcs.AMELU

open scoped Kronecker ComplexConjugate
open Finset Matrix

variable {𝔽 : Type*} [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽]

/-- A six-party state in subsystem/environment product coordinates. -/
def assembledState (ψ : State 𝔽) (S : Finset Party) :
    ((S → 𝔽) × ((i : {i : Party // i ∉ S}) → 𝔽)) → ℂ :=
  fun p => ψ (assembleLabel S p.1 p.2)

/-- Rank-one density matrix of a finite vector. -/
def vectorDensity {ι : Type*} (ξ : ι → ℂ) : Matrix ι ι ℂ :=
  fun x y => ξ x * conj (ξ y)

/-- Tensor product of the local matrices on the environment-coordinate
subtype used by `assembleLabel`. -/
def environmentTensorMatrix (S : Finset Party)
    (U : Party → LocalMatrix 𝔽) :
    Matrix (((i : {i : Party // i ∉ S}) → 𝔽))
      (((i : {i : Party // i ∉ S}) → 𝔽)) ℂ :=
  fun y x => ∏ i : {i : Party // i ∉ S}, U i.1 (y i) (x i)

omit [Field 𝔽] in
/-- The environment tensor matrix is unitary when all local factors
are unitary. -/
theorem environmentTensorMatrix_isUnitary
    (S : Finset Party) (U : Party → LocalMatrix 𝔽)
    (hU : ∀ i, IsUnitaryMatrix (U i)) :
    IsUnitaryMatrix (environmentTensorMatrix S U) := by
  intro x y
  rw [show
      (∑ z,
        conj (environmentTensorMatrix S U z x) *
          environmentTensorMatrix S U z y) =
        ∑ z : ((i : {i : Party // i ∉ S}) → 𝔽),
          ∏ i, conj (U i.1 (z i) (x i)) *
            U i.1 (z i) (y i) by
              apply Finset.sum_congr rfl
              intro z _
              simp [environmentTensorMatrix, map_prod,
                Finset.prod_mul_distrib]]
  let f : ∀ i : {i : Party // i ∉ S}, 𝔽 → ℂ :=
    fun i z => conj (U i.1 z (x i)) * U i.1 z (y i)
  change
    (∑ z : ((i : {i : Party // i ∉ S}) → 𝔽),
      ∏ i, f i (z i)) = if x = y then 1 else 0
  rw [← Fintype.prod_sum]
  have hlocal :
      ∀ i, (∑ z, f i z) = if x i = y i then 1 else 0 := by
    intro i
    exact hU i.1 (x i) (y i)
  simp_rw [hlocal]
  by_cases hxy : x = y
  · subst y
    simp
  · rw [if_neg hxy]
    have hpoint : ∃ i, x i ≠ y i := by
      by_contra hpoint
      push Not at hpoint
      exact hxy (funext hpoint)
    obtain ⟨i, hi⟩ := hpoint
    rw [Finset.prod_eq_zero (Finset.mem_univ i) (if_neg hi)]

/-- Density matrix of a matrix-vector product is matrix
conjugation. -/
theorem vectorDensity_mulVec
    {ι : Type*} [Fintype ι]
    (A : Matrix ι ι ℂ) (ξ : ι → ℂ) :
    vectorDensity (A *ᵥ ξ) = A * vectorDensity ξ * Aᴴ := by
  classical
  ext x y
  simp only [vectorDensity, Matrix.mulVec, dotProduct,
    Matrix.mul_apply, Matrix.conjTranspose_apply, map_sum, map_mul]
  simp_rw [Finset.sum_mul, Finset.mul_sum]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro a _
  apply Finset.sum_congr rfl
  intro b _
  rw [show star (A y a) = (starRingEnd ℂ) (A y a) by rfl]
  ring

omit [Field 𝔽] [DecidableEq 𝔽] in
/-- In assembled coordinates, `localAction` is the Kronecker product of the
subsystem and environment tensor matrices. -/
theorem assembledState_localAction
    (U : Party → LocalMatrix 𝔽) (ψ : State 𝔽)
    (S : Finset Party) :
    assembledState (localAction U ψ) S =
      ((subsystemTensorMatrix S (fun i => U i.1)) ⊗ₖ
        environmentTensorMatrix S U) *ᵥ
          assembledState ψ S := by
  classical
  funext p
  rcases p with ⟨x, e⟩
  unfold assembledState localAction
  rw [← sum_assembleLabel S]
  simp only [Matrix.mulVec, dotProduct]
  rw [Fintype.sum_prod_type]
  simp only [Matrix.kronecker_apply, subsystemTensorMatrix,
    environmentTensorMatrix]
  apply Finset.sum_congr rfl
  intro a _
  apply Finset.sum_congr rfl
  intro d _
  let g : Party → ℂ :=
    fun i => U i (assembleLabel S x e i)
      (assembleLabel S a d i)
  rw [← Finset.prod_mul_prod_compl S g]
  rw [Finset.prod_subtype (p := fun i : Party => i ∈ S)
    S (fun _ => Iff.rfl) g]
  rw [Finset.prod_subtype (p := fun i : Party => i ∉ S) Sᶜ (by
    intro i
    simp) g]
  have hSprod :
      (∏ i : S,
        U i.1 (assembleLabel S x e i.1)
          (assembleLabel S a d i.1)) =
        ∏ i : S, U i.1 (x i) (a i) := by
    apply Finset.prod_congr rfl
    intro i _
    simp [assembleLabel, i.2]
  have hEprod :
      (∏ i : {i : Party // i ∉ S},
        U i.1 (assembleLabel S x e i.1)
          (assembleLabel S a d i.1)) =
        ∏ i : {i : Party // i ∉ S},
          U i.1 (e i) (d i) := by
    apply Finset.prod_congr rfl
    intro i _
    simp [assembleLabel, i.2]
  apply congrArg (fun z : ℂ => z * ψ (assembleLabel S a d))
  exact congrArg₂ (· * ·) hSprod hEprod

omit [Field 𝔽] [DecidableEq 𝔽] in
/-- `marginalEntry` is the partial trace of the assembled rank-one density
matrix. -/
theorem partialTraceSecond_vectorDensity_assembledState
    (ψ : State 𝔽) (S : Finset Party) :
    partialTraceSecond (vectorDensity (assembledState ψ S)) =
      fun x y => marginalEntry ψ S x y := by
  rfl

omit [Field 𝔽] in
/-- Reduced matrices transform by conjugation with the retained tensor factor
under `localAction`. -/
theorem marginalEntry_localAction
    (U : Party → LocalMatrix 𝔽) (hU : ∀ i, IsUnitaryMatrix (U i))
    (ψ : State 𝔽) (S : Finset Party) :
    (fun x y => marginalEntry (localAction U ψ) S x y) =
      subsystemUnitaryConjugationEquiv S
        (fun i => U i.1) (fun i => hU i.1)
        (fun x y => marginalEntry ψ S x y) := by
  classical
  let A := subsystemTensorMatrix S (fun i => U i.1)
  let B := environmentTensorMatrix S U
  have hBunitary : IsUnitaryMatrix B :=
    environmentTensorMatrix_isUnitary S U hU
  calc
    (fun x y => marginalEntry (localAction U ψ) S x y) =
        partialTraceSecond
          (vectorDensity (assembledState (localAction U ψ) S)) :=
      (partialTraceSecond_vectorDensity_assembledState
        (localAction U ψ) S).symm
    _ = partialTraceSecond
        (vectorDensity (((A ⊗ₖ B) *ᵥ assembledState ψ S))) := by
      rw [← assembledState_localAction U ψ S]
    _ = partialTraceSecond
        ((A ⊗ₖ B) * vectorDensity (assembledState ψ S) *
          (A ⊗ₖ B)ᴴ) := by
      rw [vectorDensity_mulVec]
    _ = A * partialTraceSecond
        (vectorDensity (assembledState ψ S)) * Aᴴ :=
      partialTraceSecond_product_conjugation A B
        (vectorDensity (assembledState ψ S))
        (conjTranspose_mul_self_eq_one_of_isUnitaryMatrix hBunitary)
    _ = subsystemUnitaryConjugationEquiv S
        (fun i => U i.1) (fun i => hU i.1)
        (fun x y => marginalEntry ψ S x y) := by
      rw [partialTraceSecond_vectorDensity_assembledState]
      rfl

omit [Field 𝔽] [DecidableEq 𝔽] in
/-- Multiplying a state by a norm-one phase does not change any reduced
matrix. -/
theorem marginalEntry_smul_of_normSq_eq_one
    (phase : ℂ) (hphase : Complex.normSq phase = 1)
    (ψ : State 𝔽) (S : Finset Party) :
    (fun x y => marginalEntry (phase • ψ) S x y) =
      fun x y => marginalEntry ψ S x y := by
  funext x y
  unfold marginalEntry
  apply Finset.sum_congr rfl
  intro e _
  change
    (phase * ψ (assembleLabel S x e)) *
        conj (phase * ψ (assembleLabel S y e)) =
      ψ (assembleLabel S x e) * conj (ψ (assembleLabel S y e))
  rw [map_mul]
  have hphase' : phase * conj phase = 1 := by
    rw [Complex.mul_conj, hphase]
    norm_num
  rw [show
    (phase * ψ (assembleLabel S x e)) *
        (conj phase * conj (ψ (assembleLabel S y e))) =
      (phase * conj phase) *
        (ψ (assembleLabel S x e) *
          conj (ψ (assembleLabel S y e))) by ring,
    hphase', one_mul]

omit [Field 𝔽] in
/-- A local-unitary state equality yields the corresponding reduced
matrix conjugation after the global phase is removed. -/
theorem marginalEntry_eq_product_conjugation_of_localAction_eq
    (U : Party → LocalMatrix 𝔽) (hU : ∀ i, IsUnitaryMatrix (U i))
    (phase : ℂ) (hphase : Complex.normSq phase = 1)
    (ψ φ : State 𝔽)
    (hstate : localAction U ψ = phase • φ)
    (S : Finset Party) :
    subsystemUnitaryConjugationEquiv S
        (fun i => U i.1) (fun i => hU i.1)
        (fun x y => marginalEntry ψ S x y) =
      fun x y => marginalEntry φ S x y := by
  rw [← marginalEntry_localAction U hU ψ S, hstate,
    marginalEntry_smul_of_normSq_eq_one phase hphase φ S]

end RelativeConicArcs.AMELU
