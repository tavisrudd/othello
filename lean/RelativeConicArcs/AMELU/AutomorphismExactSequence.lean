import RelativeConicArcs.AMELU.ProductUnitaryAutomorphismGroup
import RelativeConicArcs.AMELU.EncoderTransversal
import Mathlib.Algebra.Exact.Basic

/-!
# Exact projective symmetry sequences

For an equal-phase MDS--CSS state, independent one-site phases form the
closed identity component of the product-unitary automorphism group.  The
quotient projection therefore belongs to a short exact sequence with closed
connected kernel and finite discrete quotient.  The same statement holds
when party permutations are displayed.

The finite local detector is packaged intrinsically as the projective
Clifford group: one-site Clifford matrices modulo their scalar center.  The
coordinatewise adjoint class is a continuous group homomorphism whose kernel
is exactly the scalar-phase torus.  With party permutations, the target has
the corresponding semidirect-product law.  Its range is the realized finite
adjoint-signature group; no unproved surjectivity onto an ambient Clifford
product is asserted.

All arguments are symbolic and kernel checked.  The module contains no
generated data, native evaluation, axioms, or admitted declarations.
-/

namespace RelativeConicArcs.AMELU

open Matrix Set

noncomputable section

variable {m : ℕ} {𝔽 : Type*}
  [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽]

/-! ## The intrinsic one-site adjoint-signature group -/

/-- The identity matrix is a Clifford matrix for every Weyl convention. -/
theorem isCliffordMatrix_one (w : WeylConvention 𝔽) :
    IsCliffordMatrix w (1 : LocalMatrix 𝔽) := by
  refine ⟨isUnitaryMatrix_one, ?_⟩
  intro a b
  refine ⟨a, b, 1, one_ne_zero, ?_⟩
  simp [matrixProduct]

/-- Clifford matrices are closed under multiplication. -/
theorem IsCliffordMatrix.mul
    (w : WeylConvention 𝔽) {U V : LocalMatrix 𝔽}
    (hU : IsCliffordMatrix w U) (hV : IsCliffordMatrix w V) :
    IsCliffordMatrix w (U * V) := by
  refine ⟨hU.1.mul hV.1, ?_⟩
  intro a b
  obtain ⟨c, d, z, hz, hVaxis⟩ := hV.2 a b
  obtain ⟨e, f, t, ht, hUaxis⟩ := hU.2 c d
  refine ⟨e, f, z * t, mul_ne_zero hz ht, ?_⟩
  rw [Matrix.conjTranspose_mul]
  change
    (U * V) * weylMatrix w a b * (V.conjTranspose * U.conjTranspose) =
      (z * t) • weylMatrix w e f
  calc
    _ = U *
        (matrixProduct (matrixProduct V (weylMatrix w a b))
          V.conjTranspose) * U.conjTranspose := by
          simp [matrixProduct, Matrix.mul_assoc]
    _ = U * (z • weylMatrix w c d) * U.conjTranspose := by
          rw [hVaxis]
    _ = z •
        (matrixProduct (matrixProduct U (weylMatrix w c d))
          U.conjTranspose) := by
          simp [matrixProduct, Matrix.mul_assoc]
    _ = z • (t • weylMatrix w e f) := by rw [hUaxis]
    _ = (z * t) • weylMatrix w e f := by rw [smul_smul]

/-- One-site Clifford matrices with their actual unitary representatives. -/
abbrev CliffordMatrixGroup (w : WeylConvention 𝔽) :=
  CliffordMatrix w

noncomputable instance (w : WeylConvention 𝔽) :
    Mul (CliffordMatrixGroup w) where
  mul U V := ⟨U.1 * V.1, IsCliffordMatrix.mul w U.2 V.2⟩

noncomputable instance (w : WeylConvention 𝔽) :
    One (CliffordMatrixGroup w) where
  one := ⟨1, isCliffordMatrix_one w⟩

noncomputable instance (w : WeylConvention 𝔽) :
    Inv (CliffordMatrixGroup w) where
  inv U := ⟨U.1.conjTranspose, U.2.conjTranspose w⟩

/-- Multiplication of Clifford representatives is matrix multiplication. -/
@[simp]
theorem cliffordMatrixGroup_mul_val
    (w : WeylConvention 𝔽) (U V : CliffordMatrixGroup w) :
    (U * V).1 = U.1 * V.1 :=
  rfl

/-- The identity Clifford representative is the identity matrix. -/
@[simp]
theorem cliffordMatrixGroup_one_val
    (w : WeylConvention 𝔽) :
    (1 : CliffordMatrixGroup w).1 = (1 : LocalMatrix 𝔽) :=
  rfl

/-- Inversion of a Clifford representative is conjugate transposition. -/
@[simp]
theorem cliffordMatrixGroup_inv_val
    (w : WeylConvention 𝔽) (U : CliffordMatrixGroup w) :
    (U⁻¹).1 = U.1.conjTranspose :=
  rfl

noncomputable instance (w : WeylConvention 𝔽) :
    Group (CliffordMatrixGroup w) where
  mul_assoc U V W := by
    apply Subtype.ext
    exact Matrix.mul_assoc _ _ _
  one_mul U := by
    apply Subtype.ext
    change (1 : LocalMatrix 𝔽) * U.1 = U.1
    simp
  mul_one U := by
    apply Subtype.ext
    change U.1 * (1 : LocalMatrix 𝔽) = U.1
    simp
  inv_mul_cancel U := by
    apply Subtype.ext
    exact conjTranspose_mul_self_eq_one_of_isUnitaryMatrix U.2.1

noncomputable instance (w : WeylConvention 𝔽) :
    TopologicalSpace (CliffordMatrixGroup w) :=
  TopologicalSpace.induced Subtype.val inferInstance

noncomputable instance (w : WeylConvention 𝔽) :
    ContinuousMul (CliffordMatrixGroup w) :=
  ⟨by
    apply continuous_induced_rng.2
    change Continuous fun U : CliffordMatrixGroup w ×
      CliffordMatrixGroup w => U.1.1 * U.2.1
    fun_prop⟩

noncomputable instance (w : WeylConvention 𝔽) :
    ContinuousInv (CliffordMatrixGroup w) :=
  ⟨by
    apply continuous_induced_rng.2
    change Continuous fun U : CliffordMatrixGroup w =>
      U.1.conjTranspose
    fun_prop⟩

noncomputable instance (w : WeylConvention 𝔽) :
    IsTopologicalGroup (CliffordMatrixGroup w) where

/-- Scalar Clifford matrices form the kernel of the intrinsic adjoint
action. -/
noncomputable def cliffordScalarSubgroup
    (w : WeylConvention 𝔽) :
    Subgroup (CliffordMatrixGroup w) where
  carrier := {U | SameMatrixAxis U.1 (1 : LocalMatrix 𝔽)}
  one_mem' := by
    change SameMatrixAxis (1 : LocalMatrix 𝔽) 1
    exact ⟨1, one_ne_zero, by simp⟩
  mul_mem' := by
    rintro U V ⟨z, hz, hU⟩ ⟨t, ht, hV⟩
    refine ⟨z * t, mul_ne_zero hz ht, ?_⟩
    change U.1 * V.1 = (z * t) • (1 : LocalMatrix 𝔽)
    rw [hU, hV]
    simp [smul_smul, mul_comm]
  inv_mem' := by
    rintro U ⟨z, hz, hU⟩
    refine ⟨star z, ?_, ?_⟩
    · intro hstar
      apply hz
      have := congrArg star hstar
      simpa using this
    change U.1.conjTranspose = star z • (1 : LocalMatrix 𝔽)
    rw [hU]
    simp [Matrix.conjTranspose_smul]

/-- Scalar Clifford matrices are central. -/
theorem cliffordScalarSubgroup_le_center
    (w : WeylConvention 𝔽) :
    cliffordScalarSubgroup w ≤ Subgroup.center
      (CliffordMatrixGroup w) := by
  intro U hU
  change SameMatrixAxis U.1 (1 : LocalMatrix 𝔽) at hU
  rw [Subgroup.mem_center_iff]
  intro V
  apply Subtype.ext
  obtain ⟨z, _, hU⟩ := hU
  change V.1 * U.1 = U.1 * V.1
  rw [hU]
  simp

noncomputable instance (w : WeylConvention 𝔽) :
    (cliffordScalarSubgroup w).Normal :=
  ⟨by
    intro U hU V
    have hcentral := cliffordScalarSubgroup_le_center w hU
    rw [Subgroup.mem_center_iff] at hcentral
    rw [hcentral V, mul_inv_cancel_right]
    exact hU⟩

/-- The intrinsic one-site Clifford adjoint-signature group.  Its elements
are Clifford matrices modulo the scalar matrices acting trivially by
conjugation. -/
abbrev IntrinsicCliffordAdjointSignature
    (w : WeylConvention 𝔽) :=
  CliffordMatrixGroup w ⧸ cliffordScalarSubgroup w

/-- Project a Clifford matrix to its intrinsic adjoint class. -/
noncomputable def intrinsicCliffordAdjointProjectivization
    (w : WeylConvention 𝔽) :
    CliffordMatrixGroup w →*
      IntrinsicCliffordAdjointSignature w :=
  QuotientGroup.mk' (cliffordScalarSubgroup w)

/-- Exact adjoint signatures map onto the intrinsic quotient. -/
noncomputable def exactSignatureToIntrinsicCliffordAdjoint
    (w : WeylConvention 𝔽) :
    ProjectiveCliffordSignature w →
      IntrinsicCliffordAdjointSignature w :=
  fun s =>
    intrinsicCliffordAdjointProjectivization w
      ⟨projectiveCliffordSignatureRepresentative w s,
        projectiveCliffordSignatureRepresentative_isClifford w s⟩

/-- Every intrinsic Clifford adjoint class has an exact Weyl-basis
signature. -/
theorem exactSignatureToIntrinsicCliffordAdjoint_surjective
    (w : WeylConvention 𝔽) :
    Function.Surjective
      (exactSignatureToIntrinsicCliffordAdjoint w) := by
  intro q
  refine Quotient.inductionOn q ?_
  intro U
  let s : ProjectiveCliffordSignature w :=
    ⟨cliffordConjugationSignature w U.1, U.1, U.2, rfl⟩
  refine ⟨s, ?_⟩
  apply QuotientGroup.eq_iff_div_mem.mpr
  have haxis :
      SameMatrixAxis
        (projectiveCliffordSignatureRepresentative w s) U.1 :=
    sameMatrixAxis_of_cliffordConjugationSignature_eq w
      (projectiveCliffordSignatureRepresentative w s) U.1
      (projectiveCliffordSignatureRepresentative_isClifford w s).1
      U.2.1
      (projectiveCliffordSignatureRepresentative_signature w s).symm
  obtain ⟨z, hz, hrep⟩ := haxis
  change SameMatrixAxis
    (projectiveCliffordSignatureRepresentative w s *
      U.1.conjTranspose)
    (1 : LocalMatrix 𝔽)
  refine ⟨z, hz, ?_⟩
  change
    (projectiveCliffordSignatureRepresentative w s *
      U.1.conjTranspose) = z • (1 : LocalMatrix 𝔽)
  rw [hrep]
  simp [self_mul_conjTranspose_eq_one_of_isUnitaryMatrix U.2.1]

noncomputable instance (w : WeylConvention 𝔽) :
    Finite (IntrinsicCliffordAdjointSignature w) :=
  Finite.of_surjective
    (exactSignatureToIntrinsicCliffordAdjoint w)
    (exactSignatureToIntrinsicCliffordAdjoint_surjective w)

/-! ## Closed scalar kernels and discrete projective quotients -/

/-- The fixed-party scalar-phase subgroup is closed. -/
theorem genericScalarPhaseSubgroup_isClosed
    (hm : 2 ≤ m) (w : WeylConvention 𝔽)
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C) :
    IsClosed
      (genericScalarPhaseSubgroup
        (genericEqualPhaseState C) :
        Set (GenericProductUnitaryAutomorphism
          (genericEqualPhaseState C))) := by
  rw [show
      (genericScalarPhaseSubgroup
        (genericEqualPhaseState C) :
        Set (GenericProductUnitaryAutomorphism
          (genericEqualPhaseState C))) =
        connectedComponent
          (genericIdentityAutomorphism
            (genericEqualPhaseState C)) by
      symm
      exact
        connectedComponent_genericIdentityAutomorphism_eq_scalarPhases
          hm w hC]
  exact isClosed_connectedComponent

/-- The party-permuted scalar-phase subgroup is closed. -/
theorem genericPermutedScalarPhaseSubgroup_isClosed
    (hm : 2 ≤ m) (w : WeylConvention 𝔽)
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C) :
    IsClosed
      (genericPermutedScalarPhaseSubgroup
        (genericEqualPhaseState C) :
        Set (GenericPermutedProductUnitaryAutomorphism
          (genericEqualPhaseState C))) := by
  rw [show
      (genericPermutedScalarPhaseSubgroup
        (genericEqualPhaseState C) :
        Set (GenericPermutedProductUnitaryAutomorphism
          (genericEqualPhaseState C))) =
        connectedComponent
          (genericPermutedIdentityAutomorphism
            (genericEqualPhaseState C)) by
      symm
      exact
        connectedComponent_genericPermutedIdentityAutomorphism_eq_scalarPhases
          hm w hC]
  exact isClosed_connectedComponent

/-- Inclusion of the fixed-party scalar torus. -/
noncomputable def genericScalarPhaseInclusion
    (ψ : GenericState m 𝔽) :
    genericScalarPhaseSubgroup ψ →*
      GenericProductUnitaryAutomorphism ψ :=
  (genericScalarPhaseSubgroup ψ).subtype

/-- The scalar inclusion and fixed-party projectivization form an exact
pair. -/
theorem genericScalarPhase_projectivization_mulExact
    (ψ : GenericState m 𝔽) :
    Function.MulExact
      (genericScalarPhaseInclusion ψ)
      (genericProductUnitaryProjectivization ψ) := by
  intro A
  constructor
  · intro hA
    refine ⟨⟨A, ?_⟩, rfl⟩
    exact
      (QuotientGroup.eq_one_iff A).mp hA
  · rintro ⟨A, rfl⟩
    exact
      (QuotientGroup.eq_one_iff A.1).mpr A.2

/-- Inclusion of the fixed-party scalar torus is injective. -/
theorem genericScalarPhaseInclusion_injective
    (ψ : GenericState m 𝔽) :
    Function.Injective (genericScalarPhaseInclusion ψ) :=
  Subtype.val_injective

/-- Inclusion of the party-permuted scalar torus. -/
noncomputable def genericPermutedScalarPhaseInclusion
    (ψ : GenericState m 𝔽) :
    genericPermutedScalarPhaseSubgroup ψ →*
      GenericPermutedProductUnitaryAutomorphism ψ :=
  (genericPermutedScalarPhaseSubgroup ψ).subtype

omit [Field 𝔽] in
/-- The scalar inclusion and party-permuted projectivization form an exact
pair. -/
theorem genericPermutedScalarPhase_projectivization_mulExact
    (ψ : GenericState m 𝔽) :
    Function.MulExact
      (genericPermutedScalarPhaseInclusion ψ)
      (genericPermutedProductUnitaryProjectivization ψ) := by
  intro A
  constructor
  · intro hA
    refine ⟨⟨A, ?_⟩, rfl⟩
    exact
      (QuotientGroup.eq_one_iff A).mp hA
  · rintro ⟨A, rfl⟩
    exact
      (QuotientGroup.eq_one_iff A.1).mpr A.2

omit [Field 𝔽] in
/-- Inclusion of the party-permuted scalar torus is injective. -/
theorem genericPermutedScalarPhaseInclusion_injective
    (ψ : GenericState m 𝔽) :
    Function.Injective (genericPermutedScalarPhaseInclusion ψ) :=
  Subtype.val_injective

/-- Fixed-party projectivization is surjective. -/
theorem genericProductUnitaryProjectivization_surjective
    (ψ : GenericState m 𝔽) :
    Function.Surjective
      (genericProductUnitaryProjectivization ψ) :=
  QuotientGroup.mk'_surjective _

omit [Field 𝔽] in
/-- Party-permuted projectivization is surjective. -/
theorem genericPermutedProductUnitaryProjectivization_surjective
    (ψ : GenericState m 𝔽) :
    Function.Surjective
      (genericPermutedProductUnitaryProjectivization ψ) :=
  QuotientGroup.mk'_surjective _

/-- The fixed-party projective quotient has the discrete topology. -/
theorem projectiveGenericProductUnitaryAutomorphismGroup_discrete
    (hm : 2 ≤ m) (w : WeylConvention 𝔽)
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C) :
    DiscreteTopology
      (ProjectiveGenericProductUnitaryAutomorphismGroup
        (genericEqualPhaseState C)) := by
  letI : IsClosed
      (genericScalarPhaseSubgroup
        (genericEqualPhaseState C) :
        Set (GenericProductUnitaryAutomorphism
          (genericEqualPhaseState C))) :=
    genericScalarPhaseSubgroup_isClosed hm w hC
  letI :=
    projectiveGenericProductUnitaryAutomorphismGroup_finite hm w hC
  exact Finite.instDiscreteTopology

/-- The party-permuted projective quotient has the discrete topology. -/
theorem
    projectiveGenericPermutedProductUnitaryAutomorphismGroup_discrete
    (hm : 2 ≤ m) (w : WeylConvention 𝔽)
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C) :
    DiscreteTopology
      (ProjectiveGenericPermutedProductUnitaryAutomorphismGroup
        (genericEqualPhaseState C)) := by
  letI : IsClosed
      (genericPermutedScalarPhaseSubgroup
        (genericEqualPhaseState C) :
        Set (GenericPermutedProductUnitaryAutomorphism
          (genericEqualPhaseState C))) :=
    genericPermutedScalarPhaseSubgroup_isClosed hm w hC
  letI :=
    projectiveGenericPermutedProductUnitaryAutomorphismGroup_finite hm w hC
  exact Finite.instDiscreteTopology

/-! ## Intrinsic continuous signature homomorphisms -/

/-- A local factor of an MDS product-unitary automorphism, regarded as an
actual Clifford matrix. -/
noncomputable def genericAutomorphismCliffordFactor
    (hm : 2 ≤ m) (w : WeylConvention 𝔽)
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C)
    (A : GenericProductUnitaryAutomorphism
      (genericEqualPhaseState C))
    (i : GenericParty m) :
    CliffordMatrixGroup w :=
  ⟨A.1 i,
    genericProductUnitaryAutomorphism_factor_isClifford
      hm w hC A i⟩

/-- Every coordinate of the identity automorphism gives the identity
Clifford representative. -/
@[simp]
theorem genericAutomorphismCliffordFactor_one
    (hm : 2 ≤ m) (w : WeylConvention 𝔽)
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C) (i : GenericParty m) :
    genericAutomorphismCliffordFactor hm w hC
      (1 : GenericProductUnitaryAutomorphism
        (genericEqualPhaseState C)) i = 1 := by
  apply Subtype.ext
  change
    (1 : GenericProductUnitaryAutomorphism
      (genericEqualPhaseState C)).1 i =
      (1 : LocalMatrix 𝔽)
  exact genericProductUnitaryAutomorphism_one_apply
    (genericEqualPhaseState C) i

/-- Clifford representatives of a product automorphism multiply
coordinatewise. -/
@[simp]
theorem genericAutomorphismCliffordFactor_mul
    (hm : 2 ≤ m) (w : WeylConvention 𝔽)
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C)
    (A B : GenericProductUnitaryAutomorphism
      (genericEqualPhaseState C))
    (i : GenericParty m) :
    genericAutomorphismCliffordFactor hm w hC (A * B) i =
      genericAutomorphismCliffordFactor hm w hC A i *
        genericAutomorphismCliffordFactor hm w hC B i := by
  apply Subtype.ext
  exact genericProductUnitaryAutomorphism_mul_apply A B i

/-- Coordinatewise intrinsic Clifford adjoint classes of fixed-party
automorphisms. -/
noncomputable def genericAutomorphismIntrinsicSignatureHom
    (hm : 2 ≤ m) (w : WeylConvention 𝔽)
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C) :
    GenericProductUnitaryAutomorphism
        (genericEqualPhaseState C) →*
      GenericParty m → IntrinsicCliffordAdjointSignature w where
  toFun A i :=
    intrinsicCliffordAdjointProjectivization w
      (genericAutomorphismCliffordFactor hm w hC A i)
  map_one' := by
    funext i
    simp
  map_mul' A B := by
    funext i
    simp

/-- The intrinsic fixed-party signature is a continuous group
homomorphism. -/
noncomputable def genericAutomorphismIntrinsicSignatureContinuousHom
    (hm : 2 ≤ m) (w : WeylConvention 𝔽)
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C) :
    GenericProductUnitaryAutomorphism
        (genericEqualPhaseState C) →ₜ*
      GenericParty m → IntrinsicCliffordAdjointSignature w where
  toMonoidHom := genericAutomorphismIntrinsicSignatureHom hm w hC
  continuous_toFun := by
    apply continuous_pi
    intro i
    exact QuotientGroup.continuous_mk.comp
      (((continuous_apply i).comp continuous_subtype_val).subtype_mk
        (fun A =>
          genericProductUnitaryAutomorphism_factor_isClifford
            hm w hC A i))

/-- The kernel of the intrinsic fixed-party signature is exactly the
scalar-phase torus. -/
theorem genericAutomorphismIntrinsicSignatureHom_ker
    (hm : 2 ≤ m) (w : WeylConvention 𝔽)
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C) :
    MonoidHom.ker
        (genericAutomorphismIntrinsicSignatureHom hm w hC) =
      genericScalarPhaseSubgroup (genericEqualPhaseState C) := by
  ext A
  constructor
  · intro hA
    change
      genericAutomorphismIntrinsicSignatureHom hm w hC A = 1 at hA
    refine ⟨fun i =>
      Classical.choose
        ((QuotientGroup.eq_one_iff
          (N := cliffordScalarSubgroup w)
          (genericAutomorphismCliffordFactor hm w hC A i)).mp
          (congrFun hA i)), ?_, ?_⟩
    · intro i
      let haxis :=
        (QuotientGroup.eq_one_iff
          (N := cliffordScalarSubgroup w)
          (genericAutomorphismCliffordFactor hm w hC A i)).mp
          (congrFun hA i)
      change SameMatrixAxis (A.1 i) (1 : LocalMatrix 𝔽) at haxis
      have hunit :
          IsUnitaryMatrix
            (Classical.choose haxis • (1 : LocalMatrix 𝔽)) := by
        rw [← (Classical.choose_spec haxis).2]
        exact A.2.1 i
      exact normSq_eq_one_of_isUnitaryMatrix_smul_one hunit
    · funext i
      let haxis :=
        (QuotientGroup.eq_one_iff
          (N := cliffordScalarSubgroup w)
          (genericAutomorphismCliffordFactor hm w hC A i)).mp
          (congrFun hA i)
      change SameMatrixAxis (A.1 i) (1 : LocalMatrix 𝔽) at haxis
      exact (Classical.choose_spec haxis).2
  · rintro ⟨z, hz, hA⟩
    change
      genericAutomorphismIntrinsicSignatureHom hm w hC A = 1
    funext i
    apply (QuotientGroup.eq_one_iff
      (N := cliffordScalarSubgroup w) _).mpr
    change SameMatrixAxis (A.1 i) (1 : LocalMatrix 𝔽)
    exact ⟨z i, by
      intro hzi
      have := hz i
      rw [hzi, Complex.normSq_zero] at this
      exact zero_ne_one this, congrFun hA i⟩

/-- The realized fixed-party adjoint-signature group. -/
noncomputable def RealizedGenericAdjointSignatureGroup
    (hm : 2 ≤ m) (w : WeylConvention 𝔽)
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C) :
    Subgroup (GenericParty m →
      IntrinsicCliffordAdjointSignature w) :=
  MonoidHom.range
    (genericAutomorphismIntrinsicSignatureHom hm w hC)

/-- The projective automorphism quotient is canonically isomorphic to its
realized intrinsic adjoint-signature group. -/
noncomputable def
    projectiveGenericAutomorphismEquivRealizedAdjointSignature
    (hm : 2 ≤ m) (w : WeylConvention 𝔽)
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C) :
  ProjectiveGenericProductUnitaryAutomorphismGroup
        (genericEqualPhaseState C) ≃*
      RealizedGenericAdjointSignatureGroup hm w hC :=
  (QuotientGroup.quotientMulEquivOfEq
      (genericAutomorphismIntrinsicSignatureHom_ker hm w hC).symm).trans
    (QuotientGroup.quotientKerEquivRange
      (genericAutomorphismIntrinsicSignatureHom hm w hC))

/-! ## Party-permuted intrinsic signatures -/

/-- A party permutation together with intrinsic local Clifford adjoint
classes.  Multiplication is the semidirect-product law dictated by
reindexing tensor factors. -/
structure IntrinsicPermutedCliffordSignature
    (m : ℕ) (w : WeylConvention 𝔽) where
  /-- Displayed permutation of the tensor factors. -/
  permutation : Equiv.Perm (GenericParty m)
  /-- Intrinsic local adjoint class at each output factor. -/
  factors : GenericParty m → IntrinsicCliffordAdjointSignature w

/-- Two permuted intrinsic signatures are equal when their permutations and
all local adjoint classes agree. -/
@[ext]
theorem IntrinsicPermutedCliffordSignature.ext
    {m : ℕ} {w : WeylConvention 𝔽}
    {A B : IntrinsicPermutedCliffordSignature m w}
    (hπ : A.permutation = B.permutation)
    (hf : ∀ i : GenericParty m, A.factors i = B.factors i) :
    A = B := by
  cases A with
  | mk Aπ Af =>
    cases B with
    | mk Bπ Bf =>
      simp only at hπ hf
      subst Bπ
      congr
      funext i
      exact hf i

noncomputable instance (w : WeylConvention 𝔽) :
    TopologicalSpace (IntrinsicPermutedCliffordSignature m w) :=
  TopologicalSpace.induced
    (fun A => (A.permutation, A.factors)) inferInstance

noncomputable instance (w : WeylConvention 𝔽) :
    Mul (IntrinsicPermutedCliffordSignature m w) where
  mul A B :=
    ⟨A.permutation * B.permutation,
      fun i => A.factors i * B.factors (A.permutation.symm i)⟩

noncomputable instance (w : WeylConvention 𝔽) :
    One (IntrinsicPermutedCliffordSignature m w) where
  one := ⟨1, 1⟩

noncomputable instance (w : WeylConvention 𝔽) :
    Inv (IntrinsicPermutedCliffordSignature m w) where
  inv A :=
    ⟨A.permutation.symm,
      fun i => (A.factors (A.permutation i))⁻¹⟩

/-- The permutation of a product is the product of the displayed
permutations. -/
@[simp]
theorem intrinsicPermutedSignature_mul_permutation
    (w : WeylConvention 𝔽)
    (A B : IntrinsicPermutedCliffordSignature m w) :
    (A * B).permutation = A.permutation * B.permutation :=
  rfl

/-- Local adjoint classes multiply after reindexing the right factor by the
inverse left permutation. -/
@[simp]
theorem intrinsicPermutedSignature_mul_local
    (w : WeylConvention 𝔽)
    (A B : IntrinsicPermutedCliffordSignature m w)
    (i : GenericParty m) :
    (A * B).factors i =
      A.factors i * B.factors (A.permutation.symm i) :=
  rfl

/-- The identity intrinsic signature has identity party permutation. -/
@[simp]
theorem intrinsicPermutedSignature_one_permutation
    (w : WeylConvention 𝔽) :
    (1 : IntrinsicPermutedCliffordSignature m w).permutation = 1 :=
  rfl

/-- Every local component of the identity intrinsic signature is trivial. -/
@[simp]
theorem intrinsicPermutedSignature_one_local
    (w : WeylConvention 𝔽) (i : GenericParty m) :
    (1 : IntrinsicPermutedCliffordSignature m w).factors i = 1 :=
  rfl

/-- Inversion reverses the displayed party permutation. -/
@[simp]
theorem intrinsicPermutedSignature_inv_permutation
    (w : WeylConvention 𝔽)
    (A : IntrinsicPermutedCliffordSignature m w) :
    (A⁻¹).permutation = A.permutation.symm :=
  rfl

/-- The local class of an inverse is the inverse class at the
permutation-reindexed coordinate. -/
@[simp]
theorem intrinsicPermutedSignature_inv_local
    (w : WeylConvention 𝔽)
    (A : IntrinsicPermutedCliffordSignature m w)
    (i : GenericParty m) :
    (A⁻¹).factors i = (A.factors (A.permutation i))⁻¹ :=
  rfl

noncomputable instance (w : WeylConvention 𝔽) :
    Group (IntrinsicPermutedCliffordSignature m w) where
  mul_assoc A B D := by
    cases A with
    | mk Aπ Aₗ =>
      cases B with
      | mk Bπ Bₗ =>
        cases D with
        | mk Dπ Dₗ =>
          apply IntrinsicPermutedCliffordSignature.ext
          · simp [mul_assoc]
          · intro i
            change
              (Aₗ i * Bₗ (Aπ.symm i)) *
                  Dₗ (Bπ.symm (Aπ.symm i)) =
                Aₗ i *
                  (Bₗ (Aπ.symm i) *
                    Dₗ (Bπ.symm (Aπ.symm i)))
            exact mul_assoc _ _ _
  one_mul A := by
    apply IntrinsicPermutedCliffordSignature.ext
    · simp
    · intro i
      change
        (1 : IntrinsicCliffordAdjointSignature w) *
            A.factors ((1 :
              Equiv.Perm (GenericParty m)).symm i) =
          A.factors i
      change 1 * A.factors i = A.factors i
      exact one_mul _
  mul_one A := by
    apply IntrinsicPermutedCliffordSignature.ext
    · simp
    · intro i
      simp
  inv_mul_cancel A := by
    apply IntrinsicPermutedCliffordSignature.ext
    · exact inv_mul_cancel A.permutation
    · intro i
      simp

/-- A local factor of a party-permuted MDS automorphism, regarded as an
actual Clifford matrix. -/
noncomputable def genericPermutedAutomorphismCliffordFactor
    (hm : 2 ≤ m) (w : WeylConvention 𝔽)
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C)
    (A : GenericPermutedProductUnitaryAutomorphism
      (genericEqualPhaseState C))
    (i : GenericParty m) :
    CliffordMatrixGroup w :=
  ⟨A.1.2 i,
    genericPermutedProductUnitaryAutomorphism_factor_isClifford
      hm w hC A i⟩

/-- Every local factor of the identity party-permuted automorphism gives
the identity Clifford representative. -/
@[simp]
theorem genericPermutedAutomorphismCliffordFactor_one
    (hm : 2 ≤ m) (w : WeylConvention 𝔽)
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C) (i : GenericParty m) :
    genericPermutedAutomorphismCliffordFactor hm w hC
      (1 : GenericPermutedProductUnitaryAutomorphism
        (genericEqualPhaseState C)) i = 1 := by
  apply Subtype.ext
  exact genericPermutedProductUnitaryAutomorphism_one_apply
    (genericEqualPhaseState C) i

/-- Local Clifford representatives of party-permuted automorphisms obey
the semidirect-product multiplication law. -/
@[simp]
theorem genericPermutedAutomorphismCliffordFactor_mul
    (hm : 2 ≤ m) (w : WeylConvention 𝔽)
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C)
    (A B : GenericPermutedProductUnitaryAutomorphism
      (genericEqualPhaseState C))
    (i : GenericParty m) :
    genericPermutedAutomorphismCliffordFactor hm w hC (A * B) i =
      genericPermutedAutomorphismCliffordFactor hm w hC A i *
        genericPermutedAutomorphismCliffordFactor hm w hC B
          (A.1.1.symm i) := by
  apply Subtype.ext
  exact genericPermutedProductUnitaryAutomorphism_mul_apply A B i

/-- The displayed permutation and intrinsic local adjoint classes form a
genuine group homomorphism. -/
noncomputable def genericPermutedAutomorphismIntrinsicSignatureHom
    (hm : 2 ≤ m) (w : WeylConvention 𝔽)
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C) :
    GenericPermutedProductUnitaryAutomorphism
        (genericEqualPhaseState C) →*
      IntrinsicPermutedCliffordSignature m w where
  toFun A :=
    ⟨A.1.1, fun i =>
      intrinsicCliffordAdjointProjectivization w
        (genericPermutedAutomorphismCliffordFactor hm w hC A i)⟩
  map_one' := by
    apply IntrinsicPermutedCliffordSignature.ext
    · exact
        genericPermutedProductUnitaryAutomorphism_one_permutation
          (genericEqualPhaseState C)
    · intro i
      simp
  map_mul' A B := by
    apply IntrinsicPermutedCliffordSignature.ext
    · exact
        genericPermutedProductUnitaryAutomorphism_mul_permutation A B
    · intro i
      simp

/-- The party-permuted intrinsic signature is a continuous group
homomorphism. -/
noncomputable def
    genericPermutedAutomorphismIntrinsicSignatureContinuousHom
    (hm : 2 ≤ m) (w : WeylConvention 𝔽)
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C) :
    GenericPermutedProductUnitaryAutomorphism
        (genericEqualPhaseState C) →ₜ*
      IntrinsicPermutedCliffordSignature m w where
  toMonoidHom :=
    genericPermutedAutomorphismIntrinsicSignatureHom hm w hC
  continuous_toFun := by
    apply continuous_induced_rng.2
    apply Continuous.prodMk
    · exact continuous_fst.comp continuous_subtype_val
    · apply continuous_pi
      intro i
      exact QuotientGroup.continuous_mk.comp
        (((continuous_apply i).comp
          (continuous_snd.comp continuous_subtype_val)).subtype_mk
            (fun A =>
              genericPermutedProductUnitaryAutomorphism_factor_isClifford
                hm w hC A i))

/-- The kernel of the party-permuted intrinsic signature is exactly the
scalar-phase torus with identity party permutation. -/
theorem genericPermutedAutomorphismIntrinsicSignatureHom_ker
    (hm : 2 ≤ m) (w : WeylConvention 𝔽)
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C) :
    MonoidHom.ker
        (genericPermutedAutomorphismIntrinsicSignatureHom hm w hC) =
      genericPermutedScalarPhaseSubgroup
        (genericEqualPhaseState C) := by
  ext A
  constructor
  · intro hA
    change
      genericPermutedAutomorphismIntrinsicSignatureHom hm w hC A = 1
      at hA
    have hπ : A.1.1 = 1 :=
      congrArg IntrinsicPermutedCliffordSignature.permutation hA
    refine ⟨hπ, fun i =>
      Classical.choose
        ((QuotientGroup.eq_one_iff
          (N := cliffordScalarSubgroup w)
          (genericPermutedAutomorphismCliffordFactor
            hm w hC A i)).mp
          (congrFun
            (congrArg IntrinsicPermutedCliffordSignature.factors hA) i)),
      ?_, ?_⟩
    · intro i
      let haxis :=
        (QuotientGroup.eq_one_iff
          (N := cliffordScalarSubgroup w)
          (genericPermutedAutomorphismCliffordFactor
            hm w hC A i)).mp
          (congrFun
            (congrArg IntrinsicPermutedCliffordSignature.factors hA) i)
      change SameMatrixAxis (A.1.2 i) (1 : LocalMatrix 𝔽) at haxis
      have hunit :
          IsUnitaryMatrix
            (Classical.choose haxis • (1 : LocalMatrix 𝔽)) := by
        rw [← (Classical.choose_spec haxis).2]
        exact A.2.1 i
      exact normSq_eq_one_of_isUnitaryMatrix_smul_one hunit
    · funext i
      let haxis :=
        (QuotientGroup.eq_one_iff
          (N := cliffordScalarSubgroup w)
          (genericPermutedAutomorphismCliffordFactor
            hm w hC A i)).mp
          (congrFun
            (congrArg IntrinsicPermutedCliffordSignature.factors hA) i)
      change SameMatrixAxis (A.1.2 i) (1 : LocalMatrix 𝔽) at haxis
      exact (Classical.choose_spec haxis).2
  · rintro ⟨hπ, z, hz, hA⟩
    change
      genericPermutedAutomorphismIntrinsicSignatureHom hm w hC A = 1
    apply IntrinsicPermutedCliffordSignature.ext
    · exact hπ
    · intro i
      apply (QuotientGroup.eq_one_iff
        (N := cliffordScalarSubgroup w) _).mpr
      change SameMatrixAxis (A.1.2 i) (1 : LocalMatrix 𝔽)
      exact ⟨z i, by
        intro hzi
        have := hz i
        rw [hzi, Complex.normSq_zero] at this
        exact zero_ne_one this, congrFun hA i⟩

/-- The realized party-permuted intrinsic adjoint-signature group. -/
noncomputable def RealizedGenericPermutedAdjointSignatureGroup
    (hm : 2 ≤ m) (w : WeylConvention 𝔽)
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C) :
    Subgroup (IntrinsicPermutedCliffordSignature m w) :=
  MonoidHom.range
    (genericPermutedAutomorphismIntrinsicSignatureHom hm w hC)

/-- The party-permuted projective automorphism quotient is canonically
isomorphic to the realized intrinsic semidirect-product subgroup. -/
noncomputable def
    projectiveGenericPermutedAutomorphismEquivRealizedAdjointSignature
    (hm : 2 ≤ m) (w : WeylConvention 𝔽)
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C) :
    ProjectiveGenericPermutedProductUnitaryAutomorphismGroup
        (genericEqualPhaseState C) ≃*
      RealizedGenericPermutedAdjointSignatureGroup hm w hC :=
  (QuotientGroup.quotientMulEquivOfEq
      (genericPermutedAutomorphismIntrinsicSignatureHom_ker
        hm w hC).symm).trans
    (QuotientGroup.quotientKerEquivRange
      (genericPermutedAutomorphismIntrinsicSignatureHom hm w hC))

/-! ## The realized party-permutation quotient and splitting boundary -/

/-- Forget local factors and retain the displayed party permutation. -/
noncomputable def genericPermutedPartyPermutationHom
    (ψ : GenericState m 𝔽) :
    GenericPermutedProductUnitaryAutomorphism ψ →*
      Equiv.Perm (GenericParty m) where
  toFun A := A.1.1
  map_one' :=
    genericPermutedProductUnitaryAutomorphism_one_permutation ψ
  map_mul' :=
    genericPermutedProductUnitaryAutomorphism_mul_permutation

/-- Projective party-permutation homomorphism.  Scalar phases lie in its
kernel, so the displayed permutation descends to the scalar quotient. -/
noncomputable def projectiveGenericPartyPermutationHom
    (ψ : GenericState m 𝔽) :
    ProjectiveGenericPermutedProductUnitaryAutomorphismGroup ψ →*
      Equiv.Perm (GenericParty m) :=
  QuotientGroup.lift
    (genericPermutedScalarPhaseSubgroup ψ)
    (genericPermutedPartyPermutationHom ψ)
    (by
      intro A hA
      exact MonoidHom.mem_ker.mpr hA.1)

/-- Party permutations actually realized by product-unitary
automorphisms. -/
noncomputable def RealizedGenericPartyPermutationGroup
    (ψ : GenericState m 𝔽) :
    Subgroup (Equiv.Perm (GenericParty m)) :=
  MonoidHom.range (projectiveGenericPartyPermutationHom ψ)

/-- Project from the party-permuted projective automorphism group onto the
subgroup of party permutations that it realizes. -/
noncomputable def projectiveGenericRealizedPartyPermutationHom
    (ψ : GenericState m 𝔽) :
    ProjectiveGenericPermutedProductUnitaryAutomorphismGroup ψ →*
      RealizedGenericPartyPermutationGroup ψ :=
  MonoidHom.rangeRestrict
    (projectiveGenericPartyPermutationHom ψ)

omit [Field 𝔽] in
/-- The realized party-permutation projection is surjective by
construction. -/
theorem projectiveGenericRealizedPartyPermutationHom_surjective
    (ψ : GenericState m 𝔽) :
    Function.Surjective
      (projectiveGenericRealizedPartyPermutationHom ψ) :=
  MonoidHom.rangeRestrict_surjective
    (projectiveGenericPartyPermutationHom ψ)

/-- Regard a fixed-party automorphism as a party-permuted automorphism with
identity permutation. -/
noncomputable def genericFixedPartyToPermutedAutomorphismHom
    (ψ : GenericState m 𝔽) :
    GenericProductUnitaryAutomorphism ψ →*
      GenericPermutedProductUnitaryAutomorphism ψ where
  toFun A := by
    refine ⟨⟨1, A.1⟩, A.2.1, ?_⟩
    obtain ⟨phase, hphase, hA⟩ := A.2.2
    refine ⟨phase, hphase, ?_⟩
    change genericLocalAction A.1 ψ = phase • ψ
    exact hA
  map_one' := by
    apply Subtype.ext
    apply Prod.ext
    · rfl
    · funext i
      change
        (1 : GenericProductUnitaryAutomorphism ψ).1 i =
          (1 : GenericPermutedProductUnitaryAutomorphism ψ).1.2 i
      rw [genericProductUnitaryAutomorphism_one_apply,
        genericPermutedProductUnitaryAutomorphism_one_apply]
  map_mul' A B := by
    apply Subtype.ext
    apply Prod.ext
    · rfl
    · funext i
      exact genericProductUnitaryAutomorphism_mul_apply A B i

/-- The fixed-party inclusion descends through both scalar-phase
quotients. -/
noncomputable def projectiveFixedPartyToPermutedAutomorphismHom
    (ψ : GenericState m 𝔽) :
    ProjectiveGenericProductUnitaryAutomorphismGroup ψ →*
      ProjectiveGenericPermutedProductUnitaryAutomorphismGroup ψ :=
  QuotientGroup.lift
    (genericScalarPhaseSubgroup ψ)
    ((genericPermutedProductUnitaryProjectivization ψ).comp
      (genericFixedPartyToPermutedAutomorphismHom ψ))
    (by
      intro A hA
      apply (QuotientGroup.eq_one_iff _).mpr
      exact ⟨rfl, hA⟩)

/-- The fixed-party projective group embeds in the party-permuted
projective group. -/
theorem projectiveFixedPartyToPermutedAutomorphismHom_injective
    (ψ : GenericState m 𝔽) :
    Function.Injective
      (projectiveFixedPartyToPermutedAutomorphismHom ψ) := by
  intro p q hpq
  refine Quotient.inductionOn₂ p q ?_ hpq
  intro A B hAB
  apply QuotientGroup.eq_iff_div_mem.mpr
  have hphase :
      genericFixedPartyToPermutedAutomorphismHom ψ (A / B) ∈
        genericPermutedScalarPhaseSubgroup ψ := by
    change
      QuotientGroup.mk
          (genericFixedPartyToPermutedAutomorphismHom ψ A) =
        QuotientGroup.mk
          (genericFixedPartyToPermutedAutomorphismHom ψ B) at hAB
    have hdiv := QuotientGroup.eq_iff_div_mem.mp hAB
    simpa using hdiv
  rcases hphase with ⟨_, z, hz, hmat⟩
  exact ⟨z, hz, hmat⟩

/-- The fixed-party projective subgroup is exactly the kernel of the
realized party-permutation projection. -/
theorem projectiveFixedParty_permutationProjection_mulExact
    (ψ : GenericState m 𝔽) :
    Function.MulExact
      (projectiveFixedPartyToPermutedAutomorphismHom ψ)
      (projectiveGenericRealizedPartyPermutationHom ψ) := by
  intro q
  refine Quotient.inductionOn q ?_
  intro A
  constructor
  · intro hA
    have hπ : A.1.1 = 1 := by
      have hval :=
        congrArg Subtype.val hA
      change
        projectiveGenericPartyPermutationHom ψ
            (QuotientGroup.mk A) = 1 at hval
      change A.1.1 = 1 at hval
      exact hval
    let B : GenericProductUnitaryAutomorphism ψ := by
      refine ⟨A.1.2, A.2.1, ?_⟩
      obtain ⟨phase, hphase, hstate⟩ := A.2.2
      refine ⟨phase, hphase, ?_⟩
      rw [hπ] at hstate
      change genericLocalAction A.1.2 ψ = phase • ψ at hstate
      exact hstate
    refine ⟨QuotientGroup.mk B, ?_⟩
    change
      QuotientGroup.mk
          (genericFixedPartyToPermutedAutomorphismHom ψ B) =
        QuotientGroup.mk A
    congr 1
    apply Subtype.ext
    apply Prod.ext
    · exact hπ.symm
    · rfl
  · rintro ⟨p, hp⟩
    rw [← hp]
    refine Quotient.inductionOn p ?_
    intro B
    apply Subtype.ext
    change
      projectiveGenericPartyPermutationHom ψ
          (QuotientGroup.mk
            (genericFixedPartyToPermutedAutomorphismHom ψ B)) = 1
    simp [projectiveGenericPartyPermutationHom,
      genericPermutedPartyPermutationHom,
      genericFixedPartyToPermutedAutomorphismHom]

/-- A splitting of the realized party-permutation extension is precisely a
homomorphic choice of projective product-unitary lift for every realized
party permutation.  Existence of representatives alone does not supply
this coherence. -/
structure GenericPartyPermutationExtensionSplitting
    (ψ : GenericState m 𝔽) where
  /-- Homomorphic lift of realized party permutations. -/
  lift :
    RealizedGenericPartyPermutationGroup ψ →*
      ProjectiveGenericPermutedProductUnitaryAutomorphismGroup ψ
  /-- The lift is a right inverse to the quotient projection. -/
  rightInverse :
    (projectiveGenericRealizedPartyPermutationHom ψ).comp lift =
      MonoidHom.id _

omit [Field 𝔽] in
/-- The exact obstruction to splitting is the absence of a homomorphic
right inverse to the realized party-permutation projection. -/
theorem genericPartyPermutationExtension_splits_iff
    (ψ : GenericState m 𝔽) :
    Nonempty (GenericPartyPermutationExtensionSplitting ψ) ↔
      ∃ s :
          RealizedGenericPartyPermutationGroup ψ →*
            ProjectiveGenericPermutedProductUnitaryAutomorphismGroup ψ,
        (projectiveGenericRealizedPartyPermutationHom ψ).comp s =
          MonoidHom.id _ := by
  constructor
  · rintro ⟨s⟩
    exact ⟨s.lift, s.rightInverse⟩
  · rintro ⟨s, hs⟩
    exact ⟨⟨s, hs⟩⟩

end

end RelativeConicArcs.AMELU
