import RelativeConicArcs.AMELU.ProjectiveClifford
import RelativeConicArcs.AMELU.GenericLURigidity

/-!
# Projective product-unitary symmetries

For an equal-phase state of a linear `[2m,m,m+1]` MDS code, a
product-unitary automorphism is a family of one-site unitaries carrying the
state to its complex phase axis.  Local-unitary rigidity makes every factor
Clifford.  Projectivizing the factors therefore embeds the automorphism
quotient into a finite product of projective one-site Clifford types.

All arguments are symbolic and kernel checked.  The module contains no
generated data, native evaluation, axioms, or admitted declarations.
-/

namespace RelativeConicArcs.AMELU

noncomputable section

variable {m : ℕ} {𝔽 : Type*}
  [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽]

/-- Party permutations carry the discrete topology. -/
instance genericPartyPermutationTopologicalSpace :
    TopologicalSpace (Equiv.Perm (GenericParty m)) :=
  ⊥

/-- The chosen topology on the finite party-permutation type is discrete. -/
instance genericPartyPermutationDiscreteTopology :
    DiscreteTopology (Equiv.Perm (GenericParty m)) :=
  ⟨rfl⟩

/-- Product-unitary automorphisms of a generic state, with the resulting
global phase existentially quantified. -/
noncomputable def GenericProductUnitaryAutomorphism (ψ : GenericState m 𝔽) :=
  {U : GenericParty m → LocalMatrix 𝔽 //
    (∀ i, IsUnitaryMatrix (U i)) ∧
      ∃ phase : ℂ, Complex.normSq phase = 1 ∧
        genericLocalAction U ψ = phase • ψ}
deriving TopologicalSpace

omit [Field 𝔽] in
/-- A unit-modulus scalar multiple of the identity matrix is unitary. -/
theorem isUnitaryMatrix_smul_one {z : ℂ}
    (hz : Complex.normSq z = 1) :
    IsUnitaryMatrix (z • (1 : LocalMatrix 𝔽)) := by
  have hzc : (starRingEnd ℂ) z * z = 1 := by
    rw [← Complex.normSq_eq_conj_mul_self]
    exact_mod_cast hz
  intro x y
  rw [Finset.sum_eq_single x]
  · simp [Matrix.one_apply, hzc]
  · intro t _ htx
    simp [Matrix.one_apply, htx]
  · simp

omit [Field 𝔽] in
/-- A family of scalar matrices acts on a tensor by the product of its
scalars. -/
theorem genericLocalAction_smul_one
    (z : GenericParty m → ℂ) (ψ : GenericState m 𝔽) :
    genericLocalAction
        (fun i => z i • (1 : LocalMatrix 𝔽)) ψ =
      (∏ i, z i) • ψ := by
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
    have hprod :
        (∏ j,
          (fun k => z k • (1 : LocalMatrix 𝔽)) j (y j) (x j)) = 0 := by
      apply Finset.prod_eq_zero (Finset.mem_univ i)
      simp [hi]
    rw [hprod, zero_mul]
  · simp

/-- A family consists of independent one-site scalar phases. -/
def IsGenericScalarPhaseFamily
    (U : GenericParty m → LocalMatrix 𝔽) : Prop :=
  ∃ z : GenericParty m → ℂ,
    (∀ i, Complex.normSq (z i) = 1) ∧
      U = fun i => z i • (1 : LocalMatrix 𝔽)

/-- Every family of independent one-site scalar phases is a
product-unitary automorphism of every state. -/
noncomputable def genericScalarPhaseAutomorphism
    (ψ : GenericState m 𝔽) (z : GenericParty m → ℂ)
    (hz : ∀ i, Complex.normSq (z i) = 1) :
    GenericProductUnitaryAutomorphism ψ :=
  ⟨fun i => z i • (1 : LocalMatrix 𝔽),
    fun i => isUnitaryMatrix_smul_one (hz i),
    ∏ i, z i,
    by simp [map_prod, hz],
    genericLocalAction_smul_one z ψ⟩

/-- The identity family as a product-unitary automorphism. -/
noncomputable def genericIdentityAutomorphism
    (ψ : GenericState m 𝔽) :
    GenericProductUnitaryAutomorphism ψ :=
  genericScalarPhaseAutomorphism ψ 1 (by simp)

/-- Every factor of a product-unitary automorphism of an equal-phase exact
MDS code state is Clifford. -/
theorem genericProductUnitaryAutomorphism_factor_isClifford
    (hm : 2 ≤ m) (w : WeylConvention 𝔽)
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C)
    (A : GenericProductUnitaryAutomorphism (genericEqualPhaseState C))
    (i : GenericParty m) :
    IsCliffordMatrix w (A.1 i) := by
  obtain ⟨hU, phase, hphase, hstate⟩ := A.2
  exact generic_all_isClifford_of_localAction_equalPhaseState
    hm w hC hC A.1 hU phase hphase hstate i

/-- Coordinatewise scalar-axis equivalence of product-unitary
automorphisms. -/
def genericAutomorphismScalarSetoid
    (ψ : GenericState m 𝔽) :
    Setoid (GenericProductUnitaryAutomorphism ψ) where
  r A B := ∀ i, SameMatrixAxis (A.1 i) (B.1 i)
  iseqv := by
    constructor
    · intro A i
      exact ⟨1, one_ne_zero, by simp⟩
    · intro A B hAB i
      obtain ⟨z, hz, hi⟩ := hAB i
      refine ⟨z⁻¹, inv_ne_zero hz, ?_⟩
      rw [hi, smul_smul]
      simp [hz]
    · intro A B D hAB hBD i
      obtain ⟨z, hz, hi⟩ := hAB i
      obtain ⟨t, ht, hj⟩ := hBD i
      refine ⟨z * t, mul_ne_zero hz ht, ?_⟩
      rw [hi, hj, smul_smul]

/-- Product-unitary automorphisms modulo independent one-site scalar
phases. -/
def ProjectiveGenericProductUnitaryAutomorphism
    (ψ : GenericState m 𝔽) :=
  Quotient (genericAutomorphismScalarSetoid ψ)

/-- The coordinatewise projective Clifford class of a product-unitary
automorphism of an exact MDS equal-phase state. -/
noncomputable def genericAutomorphismProjectiveCliffordCoordinates
    (hm : 2 ≤ m) (w : WeylConvention 𝔽)
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C)
    (A : GenericProductUnitaryAutomorphism (genericEqualPhaseState C)) :
    GenericParty m → ProjectiveClifford w :=
  fun i =>
    Quotient.mk (cliffordScalarSetoid w)
      ⟨A.1 i,
        genericProductUnitaryAutomorphism_factor_isClifford hm w hC A i⟩

/-- Projectivization descends from automorphism witnesses to their quotient
by independent scalar phases. -/
noncomputable def projectiveGenericAutomorphismEmbedding
    (hm : 2 ≤ m) (w : WeylConvention 𝔽)
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C) :
    ProjectiveGenericProductUnitaryAutomorphism
        (genericEqualPhaseState C) →
      GenericParty m → ProjectiveClifford w :=
  Quotient.lift
    (genericAutomorphismProjectiveCliffordCoordinates hm w hC)
    (by
      intro A B hAB
      funext i
      exact Quotient.sound (hAB i))

/-- Coordinatewise projectivization is injective on the quotient by
independent scalar phases. -/
theorem projectiveGenericAutomorphismEmbedding_injective
    (hm : 2 ≤ m) (w : WeylConvention 𝔽)
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C) :
    Function.Injective
      (projectiveGenericAutomorphismEmbedding hm w hC) := by
  intro q r
  refine Quotient.inductionOn₂ q r ?_
  intro A B hclasses
  apply Quotient.sound
  intro i
  have hi := congrFun hclasses i
  exact Quotient.exact hi

/-- The product-unitary automorphism group of an exact MDS equal-phase
state, modulo independent one-site scalar phases, is finite. -/
theorem projectiveGenericProductUnitaryAutomorphism_finite
    (hm : 2 ≤ m) (w : WeylConvention 𝔽)
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C) :
    Finite
      (ProjectiveGenericProductUnitaryAutomorphism
        (genericEqualPhaseState C)) := by
  classical
  exact Finite.of_injective
    (projectiveGenericAutomorphismEmbedding hm w hC)
    (projectiveGenericAutomorphismEmbedding_injective hm w hC)

/-- Product-unitary automorphisms allowing a displayed permutation of the
parties before the local factors act. -/
def GenericPermutedProductUnitaryAutomorphism
    (ψ : GenericState m 𝔽) :=
  {A : Equiv.Perm (GenericParty m) ×
      (GenericParty m → LocalMatrix 𝔽) //
    (∀ i, IsUnitaryMatrix (A.2 i)) ∧
      ∃ phase : ℂ, Complex.normSq phase = 1 ∧
        genericLocalAction A.2 (genericPermuteState A.1 ψ) =
          phase • ψ}
deriving TopologicalSpace

/-- Every local factor of a party-permuted product-unitary automorphism of
an equal-phase exact MDS code state is Clifford. -/
theorem genericPermutedProductUnitaryAutomorphism_factor_isClifford
    (hm : 2 ≤ m) (w : WeylConvention 𝔽)
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C)
    (A :
      GenericPermutedProductUnitaryAutomorphism
        (genericEqualPhaseState C))
    (i : GenericParty m) :
    IsCliffordMatrix w (A.1.2 i) := by
  obtain ⟨hU, phase, hphase, hstate⟩ := A.2
  exact
    generic_all_isClifford_of_permutedLocalAction_equalPhaseState
      hm w hC hC A.1.1 A.1.2 hU phase hphase hstate i

/-- Scalar-axis equivalence for party-permuted automorphisms retains the
same party permutation and projectivizes every local factor. -/
def genericPermutedAutomorphismScalarSetoid
    (ψ : GenericState m 𝔽) :
    Setoid (GenericPermutedProductUnitaryAutomorphism ψ) where
  r A B :=
    A.1.1 = B.1.1 ∧
      ∀ i, SameMatrixAxis (A.1.2 i) (B.1.2 i)
  iseqv := by
    constructor
    · intro A
      exact ⟨rfl, fun i => ⟨1, one_ne_zero, by simp⟩⟩
    · intro A B hAB
      refine ⟨hAB.1.symm, ?_⟩
      intro i
      obtain ⟨z, hz, hi⟩ := hAB.2 i
      refine ⟨z⁻¹, inv_ne_zero hz, ?_⟩
      rw [hi, smul_smul]
      simp [hz]
    · intro A B D hAB hBD
      refine ⟨hAB.1.trans hBD.1, ?_⟩
      intro i
      obtain ⟨z, hz, hi⟩ := hAB.2 i
      obtain ⟨t, ht, hj⟩ := hBD.2 i
      refine ⟨z * t, mul_ne_zero hz ht, ?_⟩
      rw [hi, hj, smul_smul]

/-- Party-permuted product-unitary automorphisms modulo independent
one-site scalar phases. -/
def ProjectiveGenericPermutedProductUnitaryAutomorphism
    (ψ : GenericState m 𝔽) :=
  Quotient (genericPermutedAutomorphismScalarSetoid ψ)

/-- The party permutation and coordinatewise projective Clifford classes
of a party-permuted automorphism. -/
noncomputable def
    genericPermutedAutomorphismProjectiveCliffordCoordinates
    (hm : 2 ≤ m) (w : WeylConvention 𝔽)
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C)
    (A :
      GenericPermutedProductUnitaryAutomorphism
        (genericEqualPhaseState C)) :
    Equiv.Perm (GenericParty m) ×
      (GenericParty m → ProjectiveClifford w) :=
  ⟨A.1.1, fun i =>
    Quotient.mk (cliffordScalarSetoid w)
      ⟨A.1.2 i,
        genericPermutedProductUnitaryAutomorphism_factor_isClifford
          hm w hC A i⟩⟩

/-- Party-permuted projectivization descends to the scalar quotient. -/
noncomputable def projectiveGenericPermutedAutomorphismEmbedding
    (hm : 2 ≤ m) (w : WeylConvention 𝔽)
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C) :
    ProjectiveGenericPermutedProductUnitaryAutomorphism
        (genericEqualPhaseState C) →
      Equiv.Perm (GenericParty m) ×
        (GenericParty m → ProjectiveClifford w) :=
  Quotient.lift
    (genericPermutedAutomorphismProjectiveCliffordCoordinates hm w hC)
    (by
      intro A B hAB
      apply Prod.ext
      · exact hAB.1
      · funext i
        exact Quotient.sound (hAB.2 i))

/-- The party-permuted projective-coordinate map is injective. -/
theorem projectiveGenericPermutedAutomorphismEmbedding_injective
    (hm : 2 ≤ m) (w : WeylConvention 𝔽)
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C) :
    Function.Injective
      (projectiveGenericPermutedAutomorphismEmbedding hm w hC) := by
  intro q r
  refine Quotient.inductionOn₂ q r ?_
  intro A B hclasses
  change
    genericPermutedAutomorphismProjectiveCliffordCoordinates hm w hC A =
      genericPermutedAutomorphismProjectiveCliffordCoordinates hm w hC B
    at hclasses
  apply Quotient.sound
  refine ⟨?_, ?_⟩
  · exact congrArg
      (fun x :
        Equiv.Perm (GenericParty m) ×
          (GenericParty m → ProjectiveClifford w) => x.1)
      hclasses
  intro i
  have hi := congrFun
    (congrArg
      (fun x :
        Equiv.Perm (GenericParty m) ×
          (GenericParty m → ProjectiveClifford w) => x.2)
      hclasses) i
  exact Quotient.exact hi

/-- The product-unitary automorphism quotient remains finite after party
permutations are adjoined. -/
theorem projectiveGenericPermutedProductUnitaryAutomorphism_finite
    (hm : 2 ≤ m) (w : WeylConvention 𝔽)
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C) :
    Finite
      (ProjectiveGenericPermutedProductUnitaryAutomorphism
        (genericEqualPhaseState C)) := by
  classical
  exact Finite.of_injective
    (projectiveGenericPermutedAutomorphismEmbedding hm w hC)
    (projectiveGenericPermutedAutomorphismEmbedding_injective hm w hC)

/-- The scalar-phase torus inside the party-permuted automorphism space has
the identity party permutation. -/
def IsGenericPermutedScalarPhaseFamily
    (A : Equiv.Perm (GenericParty m) ×
      (GenericParty m → LocalMatrix 𝔽)) : Prop :=
  A.1 = 1 ∧ IsGenericScalarPhaseFamily A.2

/-- A scalar-phase family with the identity party permutation is a
party-permuted product-unitary automorphism. -/
noncomputable def genericPermutedScalarPhaseAutomorphism
    (ψ : GenericState m 𝔽) (z : GenericParty m → ℂ)
    (hz : ∀ i, Complex.normSq (z i) = 1) :
    GenericPermutedProductUnitaryAutomorphism ψ :=
  ⟨⟨1, fun i => z i • (1 : LocalMatrix 𝔽)⟩,
    fun i => isUnitaryMatrix_smul_one (hz i),
    ∏ i, z i,
    by simp [map_prod, hz],
    by
      have hperm :
          genericPermuteState
              (1 : Equiv.Perm (GenericParty m)) ψ = ψ := by
        rfl
      rw [hperm]
      exact genericLocalAction_smul_one z ψ⟩

/-- The identity witness in the party-permuted automorphism space. -/
noncomputable def genericPermutedIdentityAutomorphism
    (ψ : GenericState m 𝔽) :
    GenericPermutedProductUnitaryAutomorphism ψ :=
  genericPermutedScalarPhaseAutomorphism ψ 1 (by simp)

end

end RelativeConicArcs.AMELU
