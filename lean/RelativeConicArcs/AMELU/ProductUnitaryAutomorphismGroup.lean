import RelativeConicArcs.AMELU.ProductUnitarySymmetryTopology
import Mathlib.Topology.Algebra.Group.Quotient

/-!
# Groups of product-unitary symmetries

Product-unitary symmetries of a tensor form a group under composition of
their tensor-product actions.  If party permutations are displayed, the
group law is the corresponding semidirect-product law: the left permutation
reindexes the local factors of the right symmetry.

Independent unit-modulus scalar matrices form a normal subgroup.  The
quotient by this phase torus is therefore an honest quotient group, rather
than only a quotient type.  The quotient projection is a group
homomorphism, and the finite projective-coordinate maps used to detect
components respect multiplication.

All arguments are symbolic and kernel checked.  The module contains no
generated data, native evaluation, axioms, or admitted declarations.
-/

namespace RelativeConicArcs.AMELU

open Matrix

noncomputable section

variable {m : ℕ} {𝔽 : Type*}
  [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽]

omit [Field 𝔽] in
/-- Column orthonormality follows from the matrix identity `UᴴU=1`. -/
theorem isUnitaryMatrix_of_conjTranspose_mul_self_eq_one
    {U : LocalMatrix 𝔽} (hU : U.conjTranspose * U = 1) :
    IsUnitaryMatrix U := by
  intro x y
  have hxy := congrFun (congrFun hU x) y
  simpa [Matrix.mul_apply, Matrix.conjTranspose_apply, Matrix.one_apply]
    using hxy

omit [Field 𝔽] in
/-- The identity matrix is unitary. -/
theorem isUnitaryMatrix_one :
    IsUnitaryMatrix (1 : LocalMatrix 𝔽) := by
  apply isUnitaryMatrix_of_conjTranspose_mul_self_eq_one
  simp

omit [Field 𝔽] in
/-- A product of unitary matrices is unitary. -/
theorem IsUnitaryMatrix.mul {U V : LocalMatrix 𝔽}
    (hU : IsUnitaryMatrix U) (hV : IsUnitaryMatrix V) :
    IsUnitaryMatrix (U * V) := by
  apply isUnitaryMatrix_of_conjTranspose_mul_self_eq_one
  rw [Matrix.conjTranspose_mul]
  calc
    V.conjTranspose * U.conjTranspose * (U * V) =
        V.conjTranspose * (U.conjTranspose * U) * V := by
          noncomm_ring
    _ = 1 := by
      rw [conjTranspose_mul_self_eq_one_of_isUnitaryMatrix hU,
        Matrix.mul_one,
        conjTranspose_mul_self_eq_one_of_isUnitaryMatrix hV]

omit [Field 𝔽] in
/-- The conjugate transpose of a unitary matrix is unitary. -/
theorem IsUnitaryMatrix.conjTranspose {U : LocalMatrix 𝔽}
    (hU : IsUnitaryMatrix U) :
    IsUnitaryMatrix U.conjTranspose := by
  apply isUnitaryMatrix_of_conjTranspose_mul_self_eq_one
  rw [Matrix.conjTranspose_conjTranspose]
  exact self_mul_conjTranspose_eq_one_of_isUnitaryMatrix hU

omit [Field 𝔽] [DecidableEq 𝔽] in
/-- Tensor-product local actions compose coordinatewise. -/
theorem genericLocalAction_mul
    (U V : GenericParty m → LocalMatrix 𝔽) (ψ : GenericState m 𝔽) :
    genericLocalAction (fun i => U i * V i) ψ =
      genericLocalAction U (genericLocalAction V ψ) := by
  classical
  ext y
  simp [genericLocalAction, Matrix.mul_apply, Fintype.prod_sum,
    Finset.sum_mul, Finset.mul_sum, Finset.prod_mul_distrib]
  rw [Finset.sum_comm]
  congr 1
  funext x
  congr 1
  funext z
  ring

omit [Field 𝔽] in
/-- The identity family acts trivially. -/
theorem genericLocalAction_one (ψ : GenericState m 𝔽) :
    genericLocalAction (1 : GenericParty m → LocalMatrix 𝔽) ψ = ψ := by
  classical
  ext y
  unfold genericLocalAction
  rw [Finset.sum_eq_single y]
  · simp
  · intro x _ hxy
    have hne : ∃ i, y i ≠ x i := by
      by_contra h
      push Not at h
      exact hxy (funext h).symm
    obtain ⟨i, hi⟩ := hne
    apply mul_eq_zero_of_left
    apply Finset.prod_eq_zero (Finset.mem_univ i)
    simp [hi]
  · simp

omit [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽] in
/-- A party permutation acts linearly on state amplitudes. -/
theorem genericPermuteState_smul
    (π : Equiv.Perm (GenericParty m)) (z : ℂ)
    (ψ : GenericState m 𝔽) :
    genericPermuteState π (z • ψ) =
      z • genericPermuteState π ψ := by
  rfl

omit [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽] in
/-- Party permutations compose with the group multiplication convention. -/
theorem genericPermuteState_mul
    (π τ : Equiv.Perm (GenericParty m)) (ψ : GenericState m 𝔽) :
    genericPermuteState π (genericPermuteState τ ψ) =
      genericPermuteState (π * τ) ψ := by
  rfl

omit [Field 𝔽] [DecidableEq 𝔽] in
/-- A party permutation reindexes a tensor-product local action. -/
theorem genericPermuteState_genericLocalAction
    (π : Equiv.Perm (GenericParty m))
    (U : GenericParty m → LocalMatrix 𝔽) (ψ : GenericState m 𝔽) :
    genericPermuteState π (genericLocalAction U ψ) =
      genericLocalAction (fun i => U (π.symm i))
        (genericPermuteState π ψ) := by
  classical
  ext y
  unfold genericPermuteState genericPermuteLabel genericLocalAction
  let e : (GenericParty m → 𝔽) ≃ (GenericParty m → 𝔽) :=
    Equiv.piCongrLeft' (fun _ : GenericParty m => 𝔽) π
  let g := fun x : GenericParty m → 𝔽 =>
    (∏ i, U (π.symm i) (y i) (x i)) *
      ψ fun i => x (π i)
  calc
    _ = ∑ x, g (e x) := by
      apply Finset.sum_congr rfl
      intro x _
      dsimp [g, e]
      simp only [Equiv.piCongrLeft'_apply, Equiv.symm_apply_apply]
      change
        (∏ i, U i (y (π i)) (x i)) * ψ x =
          (∏ i, U (π.symm i) (y i) (x (π.symm i))) * ψ x
      congr 1
      simpa using
        (Equiv.prod_comp (e := (π : GenericParty m ≃ GenericParty m))
          (fun i => U (π.symm i) (y i) (x (π.symm i))))
    _ = _ := e.sum_comp g

omit [Field 𝔽] [DecidableEq 𝔽] in
/-- A tensor-product local action is complex linear in the state. -/
theorem genericLocalAction_smul
    (U : GenericParty m → LocalMatrix 𝔽) (z : ℂ)
    (ψ : GenericState m 𝔽) :
    genericLocalAction U (z • ψ) =
      z • genericLocalAction U ψ := by
  classical
  ext y
  simp [genericLocalAction, Finset.mul_sum, mul_assoc, mul_comm]

/-! The following operations are the composition and inverse laws of the
tensor-product action. -/

/-- Product of fixed-party product-unitary automorphisms. -/
noncomputable def genericProductUnitaryAutomorphismMul
    {ψ : GenericState m 𝔽}
    (A B : GenericProductUnitaryAutomorphism ψ) :
    GenericProductUnitaryAutomorphism ψ := by
  refine ⟨fun i => A.1 i * B.1 i, fun i => A.2.1 i |>.mul (B.2.1 i), ?_⟩
  obtain ⟨a, ha, hA⟩ := A.2.2
  obtain ⟨b, hb, hB⟩ := B.2.2
  refine ⟨a * b, by simpa [map_mul] using congrArg₂ (· * ·) ha hb, ?_⟩
  rw [genericLocalAction_mul, hB, genericLocalAction_smul, hA, smul_smul]
  rw [mul_comm]

/-- Inverse of a fixed-party product-unitary automorphism. -/
noncomputable def genericProductUnitaryAutomorphismInv
    {ψ : GenericState m 𝔽}
    (A : GenericProductUnitaryAutomorphism ψ) :
    GenericProductUnitaryAutomorphism ψ := by
  refine ⟨fun i => (A.1 i).conjTranspose,
    fun i => (A.2.1 i).conjTranspose, ?_⟩
  obtain ⟨a, ha, hA⟩ := A.2.2
  refine ⟨star a, by simpa [map_star] using congrArg star ha, ?_⟩
  have hcomp :=
    congrArg (genericLocalAction (fun i => (A.1 i).conjTranspose)) hA
  rw [← genericLocalAction_mul] at hcomp
  have hleft :
      (fun i => (A.1 i).conjTranspose * A.1 i) =
        (1 : GenericParty m → LocalMatrix 𝔽) := by
    funext i
    exact conjTranspose_mul_self_eq_one_of_isUnitaryMatrix (A.2.1 i)
  rw [hleft, genericLocalAction_one, genericLocalAction_smul] at hcomp
  let φ := genericLocalAction (fun i => (A.1 i).conjTranspose) ψ
  change φ = star a • ψ
  calc
    φ = (star a * a) • φ := by
      rw [show star a * a = 1 by
        simpa [← Complex.normSq_eq_conj_mul_self] using ha]
      simp
    _ = star a • (a • φ) := by rw [smul_smul]
    _ = star a • ψ := by rw [← hcomp]

noncomputable instance (ψ : GenericState m 𝔽) :
    Mul (GenericProductUnitaryAutomorphism ψ) :=
  ⟨genericProductUnitaryAutomorphismMul⟩

noncomputable instance (ψ : GenericState m 𝔽) :
    One (GenericProductUnitaryAutomorphism ψ) :=
  ⟨genericIdentityAutomorphism ψ⟩

noncomputable instance (ψ : GenericState m 𝔽) :
    Inv (GenericProductUnitaryAutomorphism ψ) :=
  ⟨genericProductUnitaryAutomorphismInv⟩

omit [Field 𝔽] in
@[simp]
theorem genericProductUnitaryAutomorphism_mul_apply
    {ψ : GenericState m 𝔽}
    (A B : GenericProductUnitaryAutomorphism ψ) (i : GenericParty m) :
    (A * B).1 i = A.1 i * B.1 i :=
  rfl

omit [Field 𝔽] in
@[simp]
theorem genericProductUnitaryAutomorphism_one_apply
    (ψ : GenericState m 𝔽) (i : GenericParty m) :
    (1 : GenericProductUnitaryAutomorphism ψ).1 i = 1 :=
  by
    change (genericIdentityAutomorphism ψ).1 i = 1
    simp [genericIdentityAutomorphism, genericScalarPhaseAutomorphism]

omit [Field 𝔽] in
@[simp]
theorem genericProductUnitaryAutomorphism_inv_apply
    {ψ : GenericState m 𝔽}
    (A : GenericProductUnitaryAutomorphism ψ) (i : GenericParty m) :
    (A⁻¹).1 i = (A.1 i).conjTranspose :=
  rfl

noncomputable instance (ψ : GenericState m 𝔽) :
    Group (GenericProductUnitaryAutomorphism ψ) where
  mul_assoc A B D := by
    apply Subtype.ext
    funext i
    simp [Matrix.mul_assoc]
  one_mul A := by
    apply Subtype.ext
    funext i
    simp
  mul_one A := by
    apply Subtype.ext
    funext i
    simp
  inv_mul_cancel A := by
    apply Subtype.ext
    funext i
    simp only [genericProductUnitaryAutomorphism_mul_apply,
      genericProductUnitaryAutomorphism_inv_apply,
      genericProductUnitaryAutomorphism_one_apply]
    exact conjTranspose_mul_self_eq_one_of_isUnitaryMatrix (A.2.1 i)

/-- Forgetful map from fixed-party automorphisms to their matrix families. -/
noncomputable def genericProductUnitaryAutomorphismMatrices
    (ψ : GenericState m 𝔽) :
    GenericProductUnitaryAutomorphism ψ →* GenericParty m → LocalMatrix 𝔽 where
  toFun A := A.1
  map_one' := by
    funext i
    exact genericProductUnitaryAutomorphism_one_apply ψ i
  map_mul' A B := by
    funext i
    exact genericProductUnitaryAutomorphism_mul_apply A B i

/-- Independent scalar phases as a subgroup of the fixed-party
product-unitary automorphism group. -/
noncomputable def genericScalarPhaseSubgroup
    (ψ : GenericState m 𝔽) :
    Subgroup (GenericProductUnitaryAutomorphism ψ) where
  carrier := {A | IsGenericScalarPhaseFamily A.1}
  one_mem' := ⟨1, by simp, by
    funext i
    rw [genericProductUnitaryAutomorphism_one_apply]
    simp⟩
  mul_mem' := by
    rintro A B ⟨a, ha, hA⟩ ⟨b, hb, hB⟩
    refine ⟨a * b, fun i => by simpa [map_mul] using congrArg₂ (· * ·) (ha i) (hb i), ?_⟩
    funext i
    change A.1 i * B.1 i = (a i * b i) • (1 : LocalMatrix 𝔽)
    rw [congrFun hA i, congrFun hB i]
    simp [smul_smul]
    exact mul_comm _ _
  inv_mem' := by
    rintro A ⟨a, ha, hA⟩
    refine ⟨fun i => star (a i), fun i => by simpa [map_star] using congrArg star (ha i), ?_⟩
    funext i
    change (A.1 i).conjTranspose =
      star (a i) • (1 : LocalMatrix 𝔽)
    rw [congrFun hA i]
    simp [Matrix.conjTranspose_smul]

/-- Scalar phases are central, hence normal. -/
theorem genericScalarPhaseSubgroup_le_center
    (ψ : GenericState m 𝔽) :
    genericScalarPhaseSubgroup ψ ≤ Subgroup.center
      (GenericProductUnitaryAutomorphism ψ) := by
  intro A hA
  rw [Subgroup.mem_center_iff]
  intro B
  apply Subtype.ext
  obtain ⟨a, ha, hAa⟩ := hA
  funext i
  have hi := congrFun hAa i
  change B.1 i * A.1 i = A.1 i * B.1 i
  rw [hi]
  simp

noncomputable instance (ψ : GenericState m 𝔽) :
    (genericScalarPhaseSubgroup ψ).Normal :=
  ⟨by
    intro A hA B
    have hcentral :=
      genericScalarPhaseSubgroup_le_center ψ hA
    rw [Subgroup.mem_center_iff] at hcentral
    rw [hcentral B, mul_inv_cancel_right]
    exact hA⟩

/-- The projective fixed-party automorphism group. -/
abbrev ProjectiveGenericProductUnitaryAutomorphismGroup
    (ψ : GenericState m 𝔽) :=
  GenericProductUnitaryAutomorphism ψ ⧸ genericScalarPhaseSubgroup ψ

/-- Projectivization as a surjective group homomorphism. -/
noncomputable def genericProductUnitaryProjectivization
    (ψ : GenericState m 𝔽) :
    GenericProductUnitaryAutomorphism ψ →*
      ProjectiveGenericProductUnitaryAutomorphismGroup ψ :=
  QuotientGroup.mk' (genericScalarPhaseSubgroup ψ)

/-! ## Party-permuted automorphisms -/

/-- The action represented by a party permutation followed by local
matrices. -/
noncomputable def genericPermutedLocalAction
    (A : Equiv.Perm (GenericParty m) ×
      (GenericParty m → LocalMatrix 𝔽))
    (ψ : GenericState m 𝔽) :
    GenericState m 𝔽 :=
  genericLocalAction A.2 (genericPermuteState A.1 ψ)

/-- Semidirect-product multiplication of displayed party permutations and
local matrix families. -/
noncomputable def genericPermutedMatrixFamilyMul
    (A B : Equiv.Perm (GenericParty m) ×
      (GenericParty m → LocalMatrix 𝔽)) :
    Equiv.Perm (GenericParty m) ×
      (GenericParty m → LocalMatrix 𝔽) :=
  ⟨A.1 * B.1, fun i => A.2 i * B.2 (A.1.symm i)⟩

/-- Inverse for the semidirect-product multiplication. -/
noncomputable def genericPermutedMatrixFamilyInv
    (A : Equiv.Perm (GenericParty m) ×
      (GenericParty m → LocalMatrix 𝔽)) :
    Equiv.Perm (GenericParty m) ×
      (GenericParty m → LocalMatrix 𝔽) :=
  ⟨A.1.symm, fun i => (A.2 (A.1 i)).conjTranspose⟩

omit [Field 𝔽] [DecidableEq 𝔽] in
/-- The semidirect-product law agrees with composition of the represented
actions. -/
theorem genericPermutedLocalAction_mul
    (A B : Equiv.Perm (GenericParty m) ×
      (GenericParty m → LocalMatrix 𝔽))
    (ψ : GenericState m 𝔽) :
    genericPermutedLocalAction (genericPermutedMatrixFamilyMul A B) ψ =
      genericPermutedLocalAction A (genericPermutedLocalAction B ψ) := by
  rw [genericPermutedLocalAction, genericPermutedMatrixFamilyMul,
    genericPermutedLocalAction, genericPermutedLocalAction,
    genericPermuteState_genericLocalAction,
    ← genericLocalAction_mul, genericPermuteState_mul]

/-- Product in the party-permuted automorphism space. -/
noncomputable def genericPermutedProductUnitaryAutomorphismMul
    {ψ : GenericState m 𝔽}
    (A B : GenericPermutedProductUnitaryAutomorphism ψ) :
    GenericPermutedProductUnitaryAutomorphism ψ := by
  refine ⟨genericPermutedMatrixFamilyMul A.1 B.1, ?_, ?_⟩
  · intro i
    exact (A.2.1 i).mul (B.2.1 (A.1.1.symm i))
  · obtain ⟨a, ha, hA⟩ := A.2.2
    obtain ⟨b, hb, hB⟩ := B.2.2
    refine ⟨a * b, by simpa [map_mul] using congrArg₂ (· * ·) ha hb, ?_⟩
    change
      genericPermutedLocalAction
          (genericPermutedMatrixFamilyMul A.1 B.1) ψ =
        (a * b) • ψ
    rw [genericPermutedLocalAction_mul]
    change genericPermutedLocalAction A.1
      (genericLocalAction B.1.2
        (genericPermuteState B.1.1 ψ)) = _
    rw [hB, genericPermutedLocalAction, genericPermuteState_smul,
      genericLocalAction_smul, hA, smul_smul, mul_comm]

/-- Inverse in the party-permuted automorphism space. -/
noncomputable def genericPermutedProductUnitaryAutomorphismInv
    {ψ : GenericState m 𝔽}
    (A : GenericPermutedProductUnitaryAutomorphism ψ) :
    GenericPermutedProductUnitaryAutomorphism ψ := by
  refine ⟨genericPermutedMatrixFamilyInv A.1, ?_, ?_⟩
  · intro i
    exact (A.2.1 (A.1.1 i)).conjTranspose
  · obtain ⟨a, ha, hA⟩ := A.2.2
    refine ⟨star a, by simpa [map_star] using congrArg star ha, ?_⟩
    let I : Equiv.Perm (GenericParty m) ×
        (GenericParty m → LocalMatrix 𝔽) :=
      ⟨1, 1⟩
    have hprod :
        genericPermutedMatrixFamilyMul
            (genericPermutedMatrixFamilyInv A.1) A.1 = I := by
      apply Prod.ext
      · change A.1.1.symm * A.1.1 = 1
        exact inv_mul_cancel A.1.1
      · funext i
        simp only [genericPermutedMatrixFamilyMul,
          genericPermutedMatrixFamilyInv, Equiv.symm_symm]
        exact conjTranspose_mul_self_eq_one_of_isUnitaryMatrix
          (A.2.1 (A.1.1 i))
    have hcomp :=
      congrArg
        (genericPermutedLocalAction
          (genericPermutedMatrixFamilyInv A.1)) hA
    change
      genericPermutedLocalAction
          (genericPermutedMatrixFamilyInv A.1)
          (genericPermutedLocalAction A.1 ψ) =
        genericPermutedLocalAction
          (genericPermutedMatrixFamilyInv A.1) (a • ψ)
      at hcomp
    rw [← genericPermutedLocalAction_mul, hprod] at hcomp
    have hI : genericPermutedLocalAction I ψ = ψ := by
      change genericLocalAction 1 (genericPermuteState 1 ψ) = ψ
      rw [show genericPermuteState
        (1 : Equiv.Perm (GenericParty m)) ψ = ψ by rfl]
      exact genericLocalAction_one ψ
    rw [hI, genericPermutedLocalAction, genericPermuteState_smul,
      genericLocalAction_smul] at hcomp
    let φ :=
      genericPermutedLocalAction
        (genericPermutedMatrixFamilyInv A.1) ψ
    change φ = star a • ψ
    change ψ = a • φ at hcomp
    calc
      φ = (star a * a) • φ := by
        rw [show star a * a = 1 by
          simpa [← Complex.normSq_eq_conj_mul_self] using ha]
        simp
      _ = star a • (a • φ) := by rw [smul_smul]
      _ = star a • ψ := congrArg (fun ξ => star a • ξ) hcomp.symm

noncomputable instance (ψ : GenericState m 𝔽) :
    Mul (GenericPermutedProductUnitaryAutomorphism ψ) :=
  ⟨genericPermutedProductUnitaryAutomorphismMul⟩

noncomputable instance (ψ : GenericState m 𝔽) :
    One (GenericPermutedProductUnitaryAutomorphism ψ) :=
  ⟨genericPermutedIdentityAutomorphism ψ⟩

noncomputable instance (ψ : GenericState m 𝔽) :
    Inv (GenericPermutedProductUnitaryAutomorphism ψ) :=
  ⟨genericPermutedProductUnitaryAutomorphismInv⟩

omit [Field 𝔽] in
@[simp]
theorem genericPermutedProductUnitaryAutomorphism_mul_permutation
    {ψ : GenericState m 𝔽}
    (A B : GenericPermutedProductUnitaryAutomorphism ψ) :
    (A * B).1.1 = A.1.1 * B.1.1 :=
  rfl

omit [Field 𝔽] in
@[simp]
theorem genericPermutedProductUnitaryAutomorphism_mul_apply
    {ψ : GenericState m 𝔽}
    (A B : GenericPermutedProductUnitaryAutomorphism ψ)
    (i : GenericParty m) :
    (A * B).1.2 i = A.1.2 i * B.1.2 (A.1.1.symm i) :=
  rfl

omit [Field 𝔽] in
@[simp]
theorem genericPermutedProductUnitaryAutomorphism_one_permutation
    (ψ : GenericState m 𝔽) :
    (1 : GenericPermutedProductUnitaryAutomorphism ψ).1.1 = 1 :=
  rfl

omit [Field 𝔽] in
@[simp]
theorem genericPermutedProductUnitaryAutomorphism_one_apply
    (ψ : GenericState m 𝔽) (i : GenericParty m) :
    (1 : GenericPermutedProductUnitaryAutomorphism ψ).1.2 i = 1 := by
  change (genericPermutedIdentityAutomorphism ψ).1.2 i = 1
  simp [genericPermutedIdentityAutomorphism,
    genericPermutedScalarPhaseAutomorphism]

omit [Field 𝔽] in
@[simp]
theorem genericPermutedProductUnitaryAutomorphism_inv_permutation
    {ψ : GenericState m 𝔽}
    (A : GenericPermutedProductUnitaryAutomorphism ψ) :
    A⁻¹ |>.1.1 = A.1.1.symm :=
  rfl

omit [Field 𝔽] in
@[simp]
theorem genericPermutedProductUnitaryAutomorphism_inv_apply
    {ψ : GenericState m 𝔽}
    (A : GenericPermutedProductUnitaryAutomorphism ψ)
    (i : GenericParty m) :
    A⁻¹ |>.1.2 i = (A.1.2 (A.1.1 i)).conjTranspose :=
  rfl

noncomputable instance (ψ : GenericState m 𝔽) :
    Group (GenericPermutedProductUnitaryAutomorphism ψ) where
  mul_assoc A B D := by
    apply Subtype.ext
    apply Prod.ext
    · simp [mul_assoc]
    · funext i
      simp only [genericPermutedProductUnitaryAutomorphism_mul_apply,
        genericPermutedProductUnitaryAutomorphism_mul_permutation]
      rw [Matrix.mul_assoc]
      congr 3
  one_mul A := by
    apply Subtype.ext
    apply Prod.ext
    · simp
    · funext i
      simp only [genericPermutedProductUnitaryAutomorphism_mul_apply,
        genericPermutedProductUnitaryAutomorphism_one_apply,
        genericPermutedProductUnitaryAutomorphism_one_permutation]
      change (1 : LocalMatrix 𝔽) * A.1.2 ((1 :
        Equiv.Perm (GenericParty m)).symm i) = A.1.2 i
      change (1 : LocalMatrix 𝔽) * A.1.2 i = A.1.2 i
      simp
  mul_one A := by
    apply Subtype.ext
    apply Prod.ext
    · simp
    · funext i
      simp
  inv_mul_cancel A := by
    apply Subtype.ext
    apply Prod.ext
    · exact inv_mul_cancel A.1.1
    · funext i
      simp only [genericPermutedProductUnitaryAutomorphism_mul_apply,
        genericPermutedProductUnitaryAutomorphism_inv_apply,
        genericPermutedProductUnitaryAutomorphism_inv_permutation,
        Equiv.symm_symm,
        genericPermutedProductUnitaryAutomorphism_one_apply]
      exact conjTranspose_mul_self_eq_one_of_isUnitaryMatrix
        (A.2.1 (A.1.1 i))

/-- The independent scalar-phase torus in the party-permuted group. -/
noncomputable def genericPermutedScalarPhaseSubgroup
    (ψ : GenericState m 𝔽) :
    Subgroup (GenericPermutedProductUnitaryAutomorphism ψ) where
  carrier := {A | IsGenericPermutedScalarPhaseFamily A.1}
  one_mem' := by
    refine ⟨genericPermutedProductUnitaryAutomorphism_one_permutation ψ,
      1, by simp, ?_⟩
    funext i
    rw [genericPermutedProductUnitaryAutomorphism_one_apply]
    simp
  mul_mem' := by
    rintro A B ⟨hAπ, a, ha, hA⟩ ⟨hBπ, b, hb, hB⟩
    refine ⟨by simp [hAπ, hBπ], a * b, ?_, ?_⟩
    · intro i
      simpa [map_mul] using congrArg₂ (· * ·) (ha i) (hb i)
    · funext i
      rw [genericPermutedProductUnitaryAutomorphism_mul_apply, hAπ]
      rw [show (1 : Equiv.Perm (GenericParty m)).symm = 1 by rfl]
      change A.1.2 i * B.1.2 i =
        (a * b) i • (1 : LocalMatrix 𝔽)
      rw [congrFun hA i, congrFun hB i]
      simp [smul_smul, mul_comm]
  inv_mem' := by
    rintro A ⟨hAπ, a, ha, hA⟩
    refine ⟨?_, fun i => star (a i), ?_, ?_⟩
    · rw [genericPermutedProductUnitaryAutomorphism_inv_permutation, hAπ]
      change (1 : Equiv.Perm (GenericParty m))⁻¹ = 1
      simp
    · intro i
      simpa [map_star] using congrArg star (ha i)
    · funext i
      rw [genericPermutedProductUnitaryAutomorphism_inv_apply, hAπ]
      change (A.1.2 i).conjTranspose =
        star (a i) • (1 : LocalMatrix 𝔽)
      rw [congrFun hA i]
      simp [Matrix.conjTranspose_smul]

noncomputable instance (ψ : GenericState m 𝔽) :
    (genericPermutedScalarPhaseSubgroup ψ).Normal :=
  ⟨by
    rintro A ⟨hAπ, a, ha, hA⟩ B
    refine ⟨?_, ?_⟩
    · rw [genericPermutedProductUnitaryAutomorphism_mul_permutation,
        genericPermutedProductUnitaryAutomorphism_mul_permutation,
        genericPermutedProductUnitaryAutomorphism_inv_permutation, hAπ]
      change (B.1.1 * 1) * B.1.1⁻¹ = 1
      simp
    · refine ⟨fun i => a (B.1.1.symm i), fun i => ha _, ?_⟩
      funext i
      simp only [genericPermutedProductUnitaryAutomorphism_mul_apply,
        genericPermutedProductUnitaryAutomorphism_inv_apply,
        genericPermutedProductUnitaryAutomorphism_mul_permutation]
      simp [hAπ]
      rw [congrFun hA (B.1.1.symm i)]
      simp [self_mul_conjTranspose_eq_one_of_isUnitaryMatrix
        (B.2.1 i)]⟩

/-- The projective party-permuted automorphism group. -/
abbrev ProjectiveGenericPermutedProductUnitaryAutomorphismGroup
    (ψ : GenericState m 𝔽) :=
  GenericPermutedProductUnitaryAutomorphism ψ ⧸
    genericPermutedScalarPhaseSubgroup ψ

/-- Party-permuted projectivization as a surjective group homomorphism. -/
noncomputable def genericPermutedProductUnitaryProjectivization
    (ψ : GenericState m 𝔽) :
    GenericPermutedProductUnitaryAutomorphism ψ →*
      ProjectiveGenericPermutedProductUnitaryAutomorphismGroup ψ :=
  QuotientGroup.mk' (genericPermutedScalarPhaseSubgroup ψ)

/-! ## Topological-group and continuous-homomorphism packaging -/

noncomputable instance (ψ : GenericState m 𝔽) :
    ContinuousMul (GenericProductUnitaryAutomorphism ψ) :=
  ⟨by
    apply continuous_induced_rng.2
    change Continuous fun
      A : GenericProductUnitaryAutomorphism ψ ×
        GenericProductUnitaryAutomorphism ψ =>
      fun i => A.1.1 i * A.2.1 i
    apply continuous_pi
    intro i
    apply continuous_pi
    intro r
    apply continuous_pi
    intro c
    simp only [Matrix.mul_apply]
    apply continuous_finsetSum
    intro x _
    apply Continuous.mul
    · exact (continuous_apply x).comp ((continuous_apply r).comp
        ((continuous_apply i).comp
          (continuous_subtype_val.comp continuous_fst)))
    · exact (continuous_apply c).comp ((continuous_apply x).comp
        ((continuous_apply i).comp
          (continuous_subtype_val.comp continuous_snd)))⟩

noncomputable instance (ψ : GenericState m 𝔽) :
    ContinuousInv (GenericProductUnitaryAutomorphism ψ) :=
  ⟨by
    apply continuous_induced_rng.2
    change Continuous fun A : GenericProductUnitaryAutomorphism ψ =>
      fun i => (A.1 i).conjTranspose
    apply continuous_pi
    intro i
    apply continuous_pi
    intro r
    apply continuous_pi
    intro c
    simp only [Matrix.conjTranspose_apply]
    exact continuous_star.comp
      ((continuous_apply r).comp ((continuous_apply c).comp
        ((continuous_apply i).comp continuous_subtype_val)))⟩

noncomputable instance (ψ : GenericState m 𝔽) :
    IsTopologicalGroup (GenericProductUnitaryAutomorphism ψ) where

noncomputable instance (ψ : GenericState m 𝔽) :
    ContinuousMul (GenericPermutedProductUnitaryAutomorphism ψ) :=
  ⟨by
    apply continuous_induced_rng.2
    change Continuous fun
      A : GenericPermutedProductUnitaryAutomorphism ψ ×
        GenericPermutedProductUnitaryAutomorphism ψ =>
      genericPermutedMatrixFamilyMul A.1.1 A.2.1
    apply Continuous.prodMk
    · exact continuous_mul.comp
        (Continuous.prodMk
          (continuous_fst.comp (continuous_subtype_val.comp continuous_fst))
          (continuous_fst.comp (continuous_subtype_val.comp continuous_snd)))
    · apply continuous_pi
      intro i
      apply continuous_pi
      intro r
      apply continuous_pi
      intro c
      rw [continuous_iff_continuousAt]
      intro A
      have hlocal :
          ∀ᶠ B in nhds A, B.1.1.1 = A.1.1.1 := by
        exact
          (isOpen_discrete {A.1.1.1}).preimage
              (continuous_fst.comp
                (continuous_subtype_val.comp continuous_fst)) |>.mem_nhds rfl
      have hfixed : Continuous fun
          B : GenericPermutedProductUnitaryAutomorphism ψ ×
            GenericPermutedProductUnitaryAutomorphism ψ =>
          (B.1.1.2 i * B.2.1.2 (A.1.1.1.symm i)) r c := by
        simp only [Matrix.mul_apply]
        apply continuous_finsetSum
        intro x _
        apply Continuous.mul
        · exact (continuous_apply x).comp ((continuous_apply r).comp
            ((continuous_apply i).comp
              (continuous_snd.comp
                (continuous_subtype_val.comp continuous_fst))))
        · exact (continuous_apply c).comp ((continuous_apply x).comp
            ((continuous_apply (A.1.1.1.symm i)).comp
              (continuous_snd.comp
                (continuous_subtype_val.comp continuous_snd))))
      apply hfixed.continuousAt.congr_of_eventuallyEq
      filter_upwards [hlocal] with B hB
      simp [hB]⟩

noncomputable instance (ψ : GenericState m 𝔽) :
    ContinuousInv (GenericPermutedProductUnitaryAutomorphism ψ) :=
  ⟨by
    apply continuous_induced_rng.2
    change Continuous fun
      A : GenericPermutedProductUnitaryAutomorphism ψ =>
      genericPermutedMatrixFamilyInv A.1
    apply Continuous.prodMk
    · exact continuous_inv.comp
        (continuous_fst.comp continuous_subtype_val)
    · apply continuous_pi
      intro i
      apply continuous_pi
      intro r
      apply continuous_pi
      intro c
      rw [continuous_iff_continuousAt]
      intro A
      have hlocal :
          ∀ᶠ B in nhds A, B.1.1 = A.1.1 := by
        exact
          (isOpen_discrete {A.1.1}).preimage
              (continuous_fst.comp continuous_subtype_val) |>.mem_nhds rfl
      have hfixed : Continuous fun
          B : GenericPermutedProductUnitaryAutomorphism ψ =>
          star (B.1.2 (A.1.1 i) c r) := by
        fun_prop
      apply hfixed.continuousAt.congr_of_eventuallyEq
      filter_upwards [hlocal] with B hB
      simp [hB]⟩

noncomputable instance (ψ : GenericState m 𝔽) :
    IsTopologicalGroup
      (GenericPermutedProductUnitaryAutomorphism ψ) where

/-- Fixed-party projectivization as a continuous group homomorphism. -/
noncomputable def genericProductUnitaryContinuousProjectivization
    (ψ : GenericState m 𝔽) :
    GenericProductUnitaryAutomorphism ψ →ₜ*
      ProjectiveGenericProductUnitaryAutomorphismGroup ψ where
  toMonoidHom := genericProductUnitaryProjectivization ψ
  continuous_toFun := QuotientGroup.continuous_mk

/-- Party-permuted projectivization as a continuous group homomorphism. -/
noncomputable def genericPermutedProductUnitaryContinuousProjectivization
    (ψ : GenericState m 𝔽) :
    GenericPermutedProductUnitaryAutomorphism ψ →ₜ*
      ProjectiveGenericPermutedProductUnitaryAutomorphismGroup ψ where
  toMonoidHom := genericPermutedProductUnitaryProjectivization ψ
  continuous_toFun := QuotientGroup.continuous_mk

/-- The finite exact-signature detector as a continuous map. -/
noncomputable def genericAutomorphismCliffordSignatureContinuousMap
    (hm : 2 ≤ m) (w : WeylConvention 𝔽)
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C) :
    C(GenericProductUnitaryAutomorphism (genericEqualPhaseState C),
      GenericParty m → ProjectiveCliffordSignature w) :=
  ⟨genericAutomorphismCliffordSignature hm w hC,
    continuous_genericAutomorphismCliffordSignature hm w hC⟩

/-- The party permutation and finite exact signatures as a continuous
map. -/
noncomputable def
    genericPermutedAutomorphismCliffordSignatureContinuousMap
    (hm : 2 ≤ m) (w : WeylConvention 𝔽)
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C) :
    C(GenericPermutedProductUnitaryAutomorphism
        (genericEqualPhaseState C),
      Equiv.Perm (GenericParty m) ×
        (GenericParty m → ProjectiveCliffordSignature w)) :=
  ⟨genericPermutedAutomorphismCliffordSignature hm w hC,
    continuous_genericPermutedAutomorphismCliffordSignature hm w hC⟩

/-! ## Transfer of the established projective finiteness terminals -/

/-- The earlier coordinatewise scalar quotient maps onto the quotient
group by the phase torus. -/
noncomputable def projectiveGenericAutomorphismToQuotientGroup
    (ψ : GenericState m 𝔽) :
    ProjectiveGenericProductUnitaryAutomorphism ψ →
      ProjectiveGenericProductUnitaryAutomorphismGroup ψ :=
  Quotient.lift
    (genericProductUnitaryProjectivization ψ)
    (by
      intro A B hAB
      apply QuotientGroup.eq_iff_div_mem.mpr
      let z : GenericParty m → ℂ :=
        fun i => Classical.choose (hAB i)
      have hz (i : GenericParty m) :
          z i ≠ 0 ∧ A.1 i = z i • B.1 i :=
        Classical.choose_spec (hAB i)
      refine ⟨z, ?_, ?_⟩
      · intro i
        have hmatrix :
            (A * B⁻¹).1 i = z i • (1 : LocalMatrix 𝔽) := by
          rw [genericProductUnitaryAutomorphism_mul_apply,
            genericProductUnitaryAutomorphism_inv_apply, (hz i).2]
          simp [
            self_mul_conjTranspose_eq_one_of_isUnitaryMatrix (B.2.1 i)]
        exact normSq_eq_one_of_isUnitaryMatrix_smul_one
          (hmatrix ▸ (A / B).2.1 i)
      · funext i
        change (A * B⁻¹).1 i = z i • (1 : LocalMatrix 𝔽)
        rw [genericProductUnitaryAutomorphism_mul_apply,
          genericProductUnitaryAutomorphism_inv_apply, (hz i).2]
        simp [
          self_mul_conjTranspose_eq_one_of_isUnitaryMatrix (B.2.1 i)])

/-- The map from the coordinatewise quotient onto the quotient group is
surjective. -/
theorem projectiveGenericAutomorphismToQuotientGroup_surjective
    (ψ : GenericState m 𝔽) :
    Function.Surjective
      (projectiveGenericAutomorphismToQuotientGroup ψ) := by
  intro q
  refine Quotient.inductionOn q ?_
  intro A
  exact ⟨Quotient.mk _ A, rfl⟩

/-- The fixed-party projective automorphism quotient group is finite. -/
theorem projectiveGenericProductUnitaryAutomorphismGroup_finite
    (hm : 2 ≤ m) (w : WeylConvention 𝔽)
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C) :
    Finite
      (ProjectiveGenericProductUnitaryAutomorphismGroup
        (genericEqualPhaseState C)) := by
  letI :=
    projectiveGenericProductUnitaryAutomorphism_finite hm w hC
  exact Finite.of_surjective
    (projectiveGenericAutomorphismToQuotientGroup
      (genericEqualPhaseState C))
    (projectiveGenericAutomorphismToQuotientGroup_surjective _)

/-- The earlier party-permuted scalar quotient maps onto the corresponding
quotient group. -/
noncomputable def projectiveGenericPermutedAutomorphismToQuotientGroup
    (ψ : GenericState m 𝔽) :
    ProjectiveGenericPermutedProductUnitaryAutomorphism ψ →
      ProjectiveGenericPermutedProductUnitaryAutomorphismGroup ψ :=
  Quotient.lift
    (genericPermutedProductUnitaryProjectivization ψ)
    (by
      intro A B hAB
      apply QuotientGroup.eq_iff_div_mem.mpr
      refine ⟨?_, ?_⟩
      · change (A * B⁻¹).1.1 = 1
        rw [genericPermutedProductUnitaryAutomorphism_mul_permutation,
          genericPermutedProductUnitaryAutomorphism_inv_permutation,
          hAB.1]
        change B.1.1 * B.1.1⁻¹ = 1
        exact mul_inv_cancel B.1.1
      · let z : GenericParty m → ℂ :=
          fun i => Classical.choose (hAB.2 i)
        have hz (i : GenericParty m) :
            z i ≠ 0 ∧ A.1.2 i = z i • B.1.2 i :=
          Classical.choose_spec (hAB.2 i)
        refine ⟨z, ?_, ?_⟩
        · intro i
          have hmatrix :
              (A * B⁻¹).1.2 i =
                z i • (1 : LocalMatrix 𝔽) := by
            rw [genericPermutedProductUnitaryAutomorphism_mul_apply,
              genericPermutedProductUnitaryAutomorphism_inv_apply,
              hAB.1]
            simp only [Equiv.apply_symm_apply]
            rw [(hz i).2]
            simp [
              self_mul_conjTranspose_eq_one_of_isUnitaryMatrix
                (B.2.1 i)]
          exact normSq_eq_one_of_isUnitaryMatrix_smul_one
            (hmatrix ▸ (A / B).2.1 i)
        · funext i
          change (A * B⁻¹).1.2 i =
            z i • (1 : LocalMatrix 𝔽)
          rw [genericPermutedProductUnitaryAutomorphism_mul_apply,
            genericPermutedProductUnitaryAutomorphism_inv_apply,
            hAB.1]
          simp only [Equiv.apply_symm_apply]
          rw [(hz i).2]
          simp [
            self_mul_conjTranspose_eq_one_of_isUnitaryMatrix
              (B.2.1 i)])

/-- The map from the party-permuted coordinate quotient onto its quotient
group is surjective. -/
theorem
    projectiveGenericPermutedAutomorphismToQuotientGroup_surjective
    (ψ : GenericState m 𝔽) :
    Function.Surjective
      (projectiveGenericPermutedAutomorphismToQuotientGroup ψ) := by
  intro q
  refine Quotient.inductionOn q ?_
  intro A
  exact ⟨Quotient.mk _ A, rfl⟩

/-- The party-permuted projective automorphism quotient group is finite. -/
theorem projectiveGenericPermutedProductUnitaryAutomorphismGroup_finite
    (hm : 2 ≤ m) (w : WeylConvention 𝔽)
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C) :
    Finite
      (ProjectiveGenericPermutedProductUnitaryAutomorphismGroup
        (genericEqualPhaseState C)) := by
  letI :=
    projectiveGenericPermutedProductUnitaryAutomorphism_finite hm w hC
  exact Finite.of_surjective
    (projectiveGenericPermutedAutomorphismToQuotientGroup
      (genericEqualPhaseState C))
    (projectiveGenericPermutedAutomorphismToQuotientGroup_surjective _)

end

end RelativeConicArcs.AMELU
