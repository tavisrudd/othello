import RelativeConicArcs.AMELU.StabilizerDictionary

/-!
# Fixed-party logical symplectic kernels

For a six-party equal-phase CSS tensor, fixing the party labels leaves a
subgroup of the one-qudit symplectic group in each encoder view.  This module
isolates the elementary algebra behind the dichotomy between the full group
`SL₂(𝔽)` and its diagonal split torus.

`LogicalPhaseInputs` records the geometric propagation statements.  Every
kernel block is special linear, every split-torus block propagates, a conic
six-arc propagates every special-linear block, and a kernel block with a
nonzero off-diagonal entry forces the conic condition.  These are explicit
hypotheses rather than axioms.  The terminal theorem proves that the kernel is
the full special-linear set on the conic locus and exactly the split torus off
it.

All proofs are kernel checked.  This module uses no generated data, native
evaluation, project-specific axioms, or admitted declarations.
-/

namespace RelativeConicArcs.AMELU

open Matrix Set

/-- A one-qudit linear action on the two-dimensional Pauli label plane. -/
abbrev LogicalBlock (𝔽 : Type*) := Matrix (Fin 2) (Fin 2) 𝔽

/-- The determinant-one condition on a logical Pauli-plane block. -/
def IsSpecialLinearBlock [CommRing 𝔽] (A : LogicalBlock 𝔽) : Prop :=
  A.det = 1

/-- The diagonal symplectic block `diag(a,a⁻¹)`. -/
def splitTorusBlock [Field 𝔽] (a : 𝔽ˣ) : LogicalBlock 𝔽 :=
  !![(a : 𝔽), 0; 0, (a⁻¹ : 𝔽ˣ)]

/-- Membership in the diagonal split torus of `SL₂(𝔽)`. -/
def IsSplitTorusBlock [Field 𝔽] (A : LogicalBlock 𝔽) : Prop :=
  ∃ a : 𝔽ˣ, A = splitTorusBlock a

/-- The anti-diagonal determinant-one block that represents the nontrivial
Weyl-group element of the diagonal split torus. -/
def splitTorusWeylBlock [Ring 𝔽] : LogicalBlock 𝔽 :=
  !![0, -1; 1, 0]

/-- Every split-torus block has determinant one. -/
theorem splitTorusBlock_isSpecialLinear [Field 𝔽] (a : 𝔽ˣ) :
    IsSpecialLinearBlock (splitTorusBlock a) := by
  simp [IsSpecialLinearBlock, splitTorusBlock, Matrix.det_fin_two]

/-- The anti-diagonal Weyl block has determinant one. -/
theorem splitTorusWeylBlock_isSpecialLinear [CommRing 𝔽] :
    IsSpecialLinearBlock (splitTorusWeylBlock (𝔽 := 𝔽)) := by
  simp [IsSpecialLinearBlock, splitTorusWeylBlock, Matrix.det_fin_two]

/-- The square of the anti-diagonal Weyl block is minus the identity.  Thus
its linear order is four in odd characteristic, although its class modulo the
split torus has order two. -/
theorem splitTorusWeylBlock_mul_self [CommRing 𝔽] :
    splitTorusWeylBlock (𝔽 := 𝔽) * splitTorusWeylBlock =
      -(1 : LogicalBlock 𝔽) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [splitTorusWeylBlock, Matrix.mul_apply, Fin.sum_univ_succ]

/-- The anti-diagonal Weyl block conjugates the split-torus parameter to its
inverse, expressed without choosing a matrix inverse. -/
theorem splitTorusWeylBlock_mul_splitTorusBlock [Field 𝔽] (a : 𝔽ˣ) :
    splitTorusWeylBlock (𝔽 := 𝔽) * splitTorusBlock a =
      splitTorusBlock a⁻¹ * splitTorusWeylBlock := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [splitTorusWeylBlock, splitTorusBlock, Matrix.mul_apply,
      Fin.sum_univ_succ]

/-- A determinant-one diagonal `2 × 2` matrix is a split-torus block. -/
theorem isSplitTorusBlock_of_specialLinear_of_offDiagonal_eq_zero
    [Field 𝔽] {A : LogicalBlock 𝔽}
    (hdet : IsSpecialLinearBlock A)
    (h01 : A 0 1 = 0) (h10 : A 1 0 = 0) :
    IsSplitTorusBlock A := by
  have hprod : A 0 0 * A 1 1 = 1 := by
    simpa [IsSpecialLinearBlock, Matrix.det_fin_two, h01, h10] using hdet
  have h00 : A 0 0 ≠ 0 := by
    intro h
    rw [h] at hprod
    simp at hprod
  let a : 𝔽ˣ := Units.mk0 (A 0 0) h00
  refine ⟨a, ?_⟩
  ext i j
  fin_cases i <;> fin_cases j
  · rfl
  · simpa [splitTorusBlock] using h01
  · simpa [splitTorusBlock] using h10
  · change A 1 1 = ((a⁻¹ : 𝔽ˣ) : 𝔽)
    apply (mul_left_cancel₀ h00)
    rw [hprod]
    simp [a, h00]

/-- The four geometric propagation facts needed to identify a fixed-party
logical kernel.  The proposition `isConic` may be instantiated by any precise
conic/GRS criterion for the ordered six-arc. -/
structure LogicalPhaseInputs
    (𝔽 : Type*) [Field 𝔽]
    (kernel : Set (LogicalBlock 𝔽)) (isConic : Prop) : Prop where
  /-- Every fixed-party logical block is symplectic, hence determinant one. -/
  kernel_specialLinear :
    ∀ ⦃A⦄, A ∈ kernel → IsSpecialLinearBlock A
  /-- Diagonal determinant-one blocks always propagate through the six
  parties. -/
  splitTorus_subset_kernel :
    ∀ A, IsSplitTorusBlock A → A ∈ kernel
  /-- On the conic/GRS locus, the dual multipliers propagate every
  determinant-one anchor block. -/
  conic_specialLinear_subset_kernel :
    isConic → ∀ A, IsSpecialLinearBlock A → A ∈ kernel
  /-- A propagated block with either off-diagonal coefficient nonzero forces
  the conic/Gale-fixed condition. -/
  offDiagonal_kernel_implies_conic :
    ∀ ⦃A⦄, A ∈ kernel →
      (A 0 1 ≠ 0 ∨ A 1 0 ≠ 0) → isConic

/-- Assuming `LogicalPhaseInputs`, the fixed-party kernel is `SL₂(𝔽)` on the
conic locus and the diagonal split torus off it. -/
theorem fixedPartyKernel_eq_specialLinear_or_splitTorus
    [Field 𝔽] {kernel : Set (LogicalBlock 𝔽)} {isConic : Prop}
    (inputs : LogicalPhaseInputs 𝔽 kernel isConic) :
    (isConic →
      kernel = {A | IsSpecialLinearBlock A}) ∧
    (¬ isConic →
      kernel = {A | IsSplitTorusBlock A}) := by
  constructor
  · intro hconic
    ext A
    constructor
    · intro hA
      exact inputs.kernel_specialLinear hA
    · intro hA
      exact inputs.conic_specialLinear_subset_kernel hconic A hA
  · intro hnonconic
    ext A
    constructor
    · intro hA
      have h01 : A 0 1 = 0 := by
        by_contra h
        exact hnonconic (inputs.offDiagonal_kernel_implies_conic hA (Or.inl h))
      have h10 : A 1 0 = 0 := by
        by_contra h
        exact hnonconic (inputs.offDiagonal_kernel_implies_conic hA (Or.inr h))
      exact isSplitTorusBlock_of_specialLinear_of_offDiagonal_eq_zero
        (inputs.kernel_specialLinear hA) h01 h10
    · exact inputs.splitTorus_subset_kernel A

end RelativeConicArcs.AMELU
