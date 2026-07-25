import RelativeConicArcs.AMELU.ProductUnitarySymmetry
import Mathlib.Analysis.Complex.Circle
import Mathlib.Analysis.Normed.Module.Connected
import Mathlib.LinearAlgebra.Complex.FiniteDimensional
import Mathlib.Topology.Instances.Matrix
import Mathlib.Topology.Separation.Connected

/-!
# Identity components of product-unitary symmetry spaces

The product-unitary automorphisms of an equal-phase exact MDS code state
inherit their topology from the finite product of complex matrix spaces.
Their exact Clifford adjoint signatures form a finite Hausdorff space, so
the signature is constant on the identity component.  Faithfulness of the
projective Clifford signature identifies that fiber with the independent
one-site scalar phases.  Conversely, those phases form a connected torus.

All arguments are symbolic and kernel checked.  The module contains no
generated data, native evaluation, axioms, or admitted declarations.
-/

namespace RelativeConicArcs.AMELU

open Set

variable {m : ℕ} {𝔽 : Type*}
  [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽]

/-- A scalar identity matrix is unitary only when its scalar has unit
norm-square. -/
theorem normSq_eq_one_of_isUnitaryMatrix_smul_one
    {z : ℂ} (hU : IsUnitaryMatrix (z • (1 : LocalMatrix 𝔽))) :
    Complex.normSq z = 1 := by
  have h := hU 0 0
  rw [Finset.sum_eq_single 0] at h
  · have hc : (starRingEnd ℂ) z * z = 1 := by
      simpa [Matrix.one_apply] using h
    rw [← Complex.normSq_eq_conj_mul_self] at hc
    exact_mod_cast hc
  · intro t _ ht
    simp [ht]
  · simp

/-- Conjugation signatures vary continuously with the matrix entries. -/
theorem continuous_cliffordConjugationSignature
    (w : WeylConvention 𝔽) :
    Continuous (cliffordConjugationSignature w) := by
  apply continuous_pi
  intro v
  apply continuous_pi
  intro r
  apply continuous_pi
  intro c
  simp only [cliffordConjugationSignature, Matrix.mul_apply,
    Matrix.conjTranspose_apply]
  fun_prop

/-- The finite tuple of exact one-site Clifford signatures attached to an
MDS product-unitary automorphism. -/
noncomputable def genericAutomorphismCliffordSignature
    (hm : 2 ≤ m) (w : WeylConvention 𝔽)
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C)
    (A : GenericProductUnitaryAutomorphism (genericEqualPhaseState C)) :
    GenericParty m → ProjectiveCliffordSignature w :=
  fun i =>
    ⟨cliffordConjugationSignature w (A.1 i),
      A.1 i,
      genericProductUnitaryAutomorphism_factor_isClifford hm w hC A i,
      rfl⟩

/-- The exact Clifford-signature map on product-unitary automorphisms is
continuous. -/
theorem continuous_genericAutomorphismCliffordSignature
    (hm : 2 ≤ m) (w : WeylConvention 𝔽)
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C) :
    Continuous (genericAutomorphismCliffordSignature hm w hC) := by
  apply continuous_pi
  intro i
  apply continuous_induced_rng.2
  change
    Continuous fun
      A : GenericProductUnitaryAutomorphism (genericEqualPhaseState C) =>
        cliffordConjugationSignature w (A.1 i)
  exact (continuous_cliffordConjugationSignature w).comp
    ((continuous_apply i).comp continuous_subtype_val)

/-- The torus of one-site phases mapped into the product-unitary
automorphism space. -/
noncomputable def genericPhaseTorusMap
    (ψ : GenericState m 𝔽) :
    (GenericParty m → Circle) →
      GenericProductUnitaryAutomorphism ψ :=
  fun z =>
    genericScalarPhaseAutomorphism ψ (fun i => (z i : ℂ))
      (by intro i; exact Circle.normSq_coe (z i))

omit [Field 𝔽] in
/-- The phase-torus parametrization is continuous. -/
theorem continuous_genericPhaseTorusMap
    (ψ : GenericState m 𝔽) :
    Continuous (genericPhaseTorusMap ψ) := by
  apply continuous_induced_rng.2
  change
    Continuous fun z : GenericParty m → Circle =>
      fun i => (z i : ℂ) • (1 : LocalMatrix 𝔽)
  fun_prop

/-- The complex unit circle is connected. -/
theorem isConnected_univ_circle :
    IsConnected (Set.univ : Set Circle) := by
  have hrank : 1 < Module.rank ℝ ℂ := by
    rw [Complex.rank_real_complex]
    norm_num
  have hsphere :
      IsConnected (Metric.sphere (0 : ℂ) 1) :=
    isConnected_sphere hrank 0 (by norm_num)
  letI : ConnectedSpace (Metric.sphere (0 : ℂ) 1) :=
    isConnected_iff_connectedSpace.mp hsphere
  change IsConnected (Set.univ : Set (Metric.sphere (0 : ℂ) 1))
  exact isConnected_univ

/-- A finite product of complex unit circles is connected. -/
theorem isConnected_univ_genericPhaseTorus :
    IsConnected (Set.univ : Set (GenericParty m → Circle)) := by
  simpa using
    (isConnected_univ_pi (X := fun _ : GenericParty m => Circle)).2
      (fun _ => isConnected_univ_circle)

omit [Field 𝔽] in
/-- The image of the phase torus is exactly the scalar-phase family inside
the automorphism space. -/
theorem mem_range_genericPhaseTorusMap_iff
    (ψ : GenericState m 𝔽)
    (A : GenericProductUnitaryAutomorphism ψ) :
    A ∈ Set.range (genericPhaseTorusMap ψ) ↔
      IsGenericScalarPhaseFamily A.1 := by
  constructor
  · rintro ⟨z, rfl⟩
    exact ⟨fun i => (z i : ℂ), fun i => Circle.normSq_coe (z i), rfl⟩
  · rintro ⟨z, hz, hA⟩
    have hnorm (i : GenericParty m) : ‖z i‖ = 1 := by
      have hsquare : ‖z i‖ ^ 2 = 1 := by
        simpa [Complex.normSq_eq_norm_sq] using hz i
      nlinarith [norm_nonneg (z i)]
    let zCircle : GenericParty m → Circle :=
      fun i =>
        ⟨z i, by
          simpa [Circle, Submonoid.unitSphere,
            mem_sphere_zero_iff_norm] using hnorm i⟩
    refine ⟨zCircle, ?_⟩
    apply Subtype.ext
    simpa [genericPhaseTorusMap, genericScalarPhaseAutomorphism,
      zCircle] using hA.symm

/-- The identity component of the product-unitary automorphism space of an
equal-phase exact MDS code state is exactly its torus of independent
one-site scalar phases. -/
theorem connectedComponent_genericIdentityAutomorphism_eq_scalarPhases
    (hm : 2 ≤ m) (w : WeylConvention 𝔽)
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C) :
    connectedComponent
        (genericIdentityAutomorphism (genericEqualPhaseState C)) =
      {A : GenericProductUnitaryAutomorphism (genericEqualPhaseState C) |
        IsGenericScalarPhaseFamily (m := m) (𝔽 := 𝔽) A.1} := by
  classical
  apply Set.Subset.antisymm
  · intro A hA
    let f :=
      genericAutomorphismCliffordSignature hm w hC
    let e :=
      genericIdentityAutomorphism (genericEqualPhaseState C)
    have himage :
        f A ∈ connectedComponent (f e) := by
      apply
        (Continuous.image_connectedComponent_subset
          (continuous_genericAutomorphismCliffordSignature hm w hC) e)
      exact ⟨A, hA, rfl⟩
    have hsignature :
        f A = f e := by
      simpa [connectedComponent_eq_singleton] using himage
    have hsignature_i (i : GenericParty m) :
        cliffordConjugationSignature w (A.1 i) =
          cliffordConjugationSignature w (1 : LocalMatrix 𝔽) := by
      have hi := congrArg Subtype.val (congrFun hsignature i)
      simpa [f, e, genericAutomorphismCliffordSignature,
        genericIdentityAutomorphism, genericScalarPhaseAutomorphism] using hi
    have hOne : IsUnitaryMatrix (1 : LocalMatrix 𝔽) := by
      simpa using
        (isUnitaryMatrix_smul_one (𝔽 := 𝔽)
          (z := (1 : ℂ)) Complex.normSq_one)
    have haxis (i : GenericParty m) :
        SameMatrixAxis (A.1 i) (1 : LocalMatrix 𝔽) :=
      sameMatrixAxis_of_cliffordConjugationSignature_eq w
        (A.1 i) (1 : LocalMatrix 𝔽) (A.2.1 i)
        hOne (hsignature_i i)
    let z : GenericParty m → ℂ := fun i => (haxis i).choose
    refine ⟨z, ?_, ?_⟩
    · intro i
      have hzmatrix :
          IsUnitaryMatrix (z i • (1 : LocalMatrix 𝔽)) := by
        rw [← (haxis i).choose_spec.2]
        exact A.2.1 i
      exact normSq_eq_one_of_isUnitaryMatrix_smul_one
        hzmatrix
    · funext i
      exact (haxis i).choose_spec.2
  · intro A hA
    have hArange :=
      (mem_range_genericPhaseTorusMap_iff
        (genericEqualPhaseState C) A).2 hA
    have hconnected :
        IsConnected
          (Set.range
            (genericPhaseTorusMap (genericEqualPhaseState C))) := by
      simpa only [Set.image_univ] using
        isConnected_univ_genericPhaseTorus.image
          (genericPhaseTorusMap (genericEqualPhaseState C))
          (continuous_genericPhaseTorusMap _).continuousOn
    apply hconnected.subset_connectedComponent
    · exact ⟨1, by apply Subtype.ext; rfl⟩
    · exact hArange

/-- The party permutation together with the finite tuple of exact local
Clifford signatures of a party-permuted automorphism. -/
noncomputable def genericPermutedAutomorphismCliffordSignature
    (hm : 2 ≤ m) (w : WeylConvention 𝔽)
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C)
    (A :
      GenericPermutedProductUnitaryAutomorphism
        (genericEqualPhaseState C)) :
    Equiv.Perm (GenericParty m) ×
      (GenericParty m → ProjectiveCliffordSignature w) :=
  ⟨A.1.1, fun i =>
    ⟨cliffordConjugationSignature w (A.1.2 i),
      A.1.2 i,
      genericPermutedProductUnitaryAutomorphism_factor_isClifford
        hm w hC A i,
      rfl⟩⟩

/-- The party-permuted exact Clifford-signature map is continuous. -/
theorem continuous_genericPermutedAutomorphismCliffordSignature
    (hm : 2 ≤ m) (w : WeylConvention 𝔽)
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C) :
    Continuous
      (genericPermutedAutomorphismCliffordSignature hm w hC) := by
  apply Continuous.prodMk
  · exact continuous_fst.comp continuous_subtype_val
  · apply continuous_pi
    intro i
    apply continuous_induced_rng.2
    change
      Continuous fun
        A : GenericPermutedProductUnitaryAutomorphism
          (genericEqualPhaseState C) =>
          cliffordConjugationSignature w (A.1.2 i)
    exact (continuous_cliffordConjugationSignature w).comp
      ((continuous_apply i).comp
        (continuous_snd.comp continuous_subtype_val))

/-- The phase torus mapped into the party-permuted automorphism space with
the identity party permutation. -/
noncomputable def genericPermutedPhaseTorusMap
    (ψ : GenericState m 𝔽) :
    (GenericParty m → Circle) →
      GenericPermutedProductUnitaryAutomorphism ψ :=
  fun z =>
    genericPermutedScalarPhaseAutomorphism ψ (fun i => (z i : ℂ))
      (by intro i; exact Circle.normSq_coe (z i))

omit [Field 𝔽] in
/-- The party-permuted phase-torus parametrization is continuous. -/
theorem continuous_genericPermutedPhaseTorusMap
    (ψ : GenericState m 𝔽) :
    Continuous (genericPermutedPhaseTorusMap ψ) := by
  apply continuous_induced_rng.2
  change
    Continuous fun z : GenericParty m → Circle =>
      ((1 : Equiv.Perm (GenericParty m)),
        fun i => (z i : ℂ) • (1 : LocalMatrix 𝔽))
  fun_prop

omit [Field 𝔽] in
/-- The image of the party-permuted phase-torus map is exactly the
scalar-phase family with identity party permutation. -/
theorem mem_range_genericPermutedPhaseTorusMap_iff
    (ψ : GenericState m 𝔽)
    (A : GenericPermutedProductUnitaryAutomorphism ψ) :
    A ∈ Set.range (genericPermutedPhaseTorusMap ψ) ↔
      IsGenericPermutedScalarPhaseFamily A.1 := by
  constructor
  · rintro ⟨z, rfl⟩
    exact
      ⟨rfl, fun i => (z i : ℂ),
        fun i => Circle.normSq_coe (z i), rfl⟩
  · rintro ⟨hperm, z, hz, hA⟩
    have hnorm (i : GenericParty m) : ‖z i‖ = 1 := by
      have hsquare : ‖z i‖ ^ 2 = 1 := by
        simpa [Complex.normSq_eq_norm_sq] using hz i
      nlinarith [norm_nonneg (z i)]
    let zCircle : GenericParty m → Circle :=
      fun i =>
        ⟨z i, by
          simpa [Circle, Submonoid.unitSphere,
            mem_sphere_zero_iff_norm] using hnorm i⟩
    refine ⟨zCircle, ?_⟩
    apply Subtype.ext
    apply Prod.ext
    · simpa [genericPermutedPhaseTorusMap,
        genericPermutedScalarPhaseAutomorphism] using hperm.symm
    · simpa [genericPermutedPhaseTorusMap,
        genericPermutedScalarPhaseAutomorphism, zCircle] using hA.symm

/-- Adjoining party permutations does not enlarge the identity component:
it remains exactly the torus of independent one-site scalar phases with
identity permutation. -/
theorem
    connectedComponent_genericPermutedIdentityAutomorphism_eq_scalarPhases
    (hm : 2 ≤ m) (w : WeylConvention 𝔽)
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C) :
    connectedComponent
        (genericPermutedIdentityAutomorphism (genericEqualPhaseState C)) =
      {A :
          GenericPermutedProductUnitaryAutomorphism
            (genericEqualPhaseState C) |
        IsGenericPermutedScalarPhaseFamily (m := m) (𝔽 := 𝔽) A.1} := by
  classical
  apply Set.Subset.antisymm
  · intro A hA
    let f :=
      genericPermutedAutomorphismCliffordSignature hm w hC
    let e :=
      genericPermutedIdentityAutomorphism (genericEqualPhaseState C)
    have himage :
        f A ∈ connectedComponent (f e) := by
      apply
        (Continuous.image_connectedComponent_subset
          (continuous_genericPermutedAutomorphismCliffordSignature
            hm w hC) e)
      exact ⟨A, hA, rfl⟩
    have hsignature : f A = f e := by
      simpa [connectedComponent_eq_singleton] using himage
    have hperm : A.1.1 = 1 := by
      exact congrArg Prod.fst hsignature
    have hsignature_i (i : GenericParty m) :
        cliffordConjugationSignature w (A.1.2 i) =
          cliffordConjugationSignature w (1 : LocalMatrix 𝔽) := by
      have hi :=
        congrArg Subtype.val
          (congrFun (congrArg Prod.snd hsignature) i)
      simpa [f, e, genericPermutedAutomorphismCliffordSignature,
        genericPermutedIdentityAutomorphism,
        genericPermutedScalarPhaseAutomorphism] using hi
    have hOne : IsUnitaryMatrix (1 : LocalMatrix 𝔽) := by
      simpa using
        (isUnitaryMatrix_smul_one (𝔽 := 𝔽)
          (z := (1 : ℂ)) Complex.normSq_one)
    have haxis (i : GenericParty m) :
        SameMatrixAxis (A.1.2 i) (1 : LocalMatrix 𝔽) :=
      sameMatrixAxis_of_cliffordConjugationSignature_eq w
        (A.1.2 i) (1 : LocalMatrix 𝔽) (A.2.1 i)
        hOne (hsignature_i i)
    refine ⟨hperm, fun i => (haxis i).choose, ?_, ?_⟩
    · intro i
      have hzmatrix :
          IsUnitaryMatrix
            ((haxis i).choose • (1 : LocalMatrix 𝔽)) := by
        rw [← (haxis i).choose_spec.2]
        exact A.2.1 i
      exact normSq_eq_one_of_isUnitaryMatrix_smul_one hzmatrix
    · funext i
      exact (haxis i).choose_spec.2
  · intro A hA
    have hArange :=
      (mem_range_genericPermutedPhaseTorusMap_iff
        (genericEqualPhaseState C) A).2 hA
    have hconnected :
        IsConnected
          (Set.range
            (genericPermutedPhaseTorusMap
              (genericEqualPhaseState C))) := by
      simpa only [Set.image_univ] using
        isConnected_univ_genericPhaseTorus.image
          (genericPermutedPhaseTorusMap (genericEqualPhaseState C))
          (continuous_genericPermutedPhaseTorusMap _).continuousOn
    apply hconnected.subset_connectedComponent
    · exact ⟨1, by apply Subtype.ext; rfl⟩
    · exact hArange

end RelativeConicArcs.AMELU
