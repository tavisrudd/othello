import RelativeConicArcs.AMELU.AutomorphismExactSequence
import Mathlib.GroupTheory.GroupExtension.Basic

/-!
# Nonabelian invariants of the realized party-permutation extension

A short exact sequence with nonabelian kernel has two complementary
descriptions.  Conjugation in the middle group descends, without choosing
lifts, to an outer action of the quotient on the kernel.  A normalized
set-theoretic section refines this outer action to actual automorphisms and
has a factor set measuring its failure to preserve multiplication.

This module develops that package for an arbitrary group extension and then
applies it to the projective product-unitary automorphism groups of an
equal-phase MDS--CSS state.  The change-of-section formula retains the order
of all factors; no commutativity of the fixed-party projective group is
assumed.  The factor set can be changed to the constant identity factor set
exactly when the extension has a homomorphic section.

All arguments are symbolic and kernel checked.  The module contains no
generated data, native evaluation, axioms, or admitted declarations.
-/

namespace GroupExtension

noncomputable section

variable {N E G : Type*} [Group N] [Group E] [Group G]
  (S : GroupExtension N E G)

/-! ## The section-free outer action -/

/-- Inner automorphisms, realized as a subgroup of the full automorphism
group. -/
def innerMulAutSubgroup : Subgroup (MulAut N) :=
  MonoidHom.range MulAut.conj

instance innerMulAutSubgroup_normal :
    (innerMulAutSubgroup (N := N)).Normal where
  conj_mem _ hα φ := by
    rcases hα with ⟨n, rfl⟩
    refine ⟨φ n, ?_⟩
    ext x
    simp [MulAut.conj_apply]

/-- The outer automorphism group is the automorphism group modulo its
normal subgroup of inner automorphisms. -/
abbrev OuterMulAut (N : Type*) [Group N] :=
  MulAut N ⧸ innerMulAutSubgroup (N := N)

/-- Projection from automorphisms to outer automorphisms. -/
def toOuterMulAut (N : Type*) [Group N] :
    MulAut N →* OuterMulAut N :=
  QuotientGroup.mk' (innerMulAutSubgroup (N := N))

/-- Conjugation by the middle group, modulo inner automorphisms of the
kernel. -/
noncomputable def middleOuterAction : E →* OuterMulAut N :=
  (toOuterMulAut (N := N)).comp S.conjAct

theorem ker_rightHom_le_ker_middleOuterAction :
    S.rightHom.ker ≤ (S.middleOuterAction).ker := by
  intro e he
  have he' : e ∈ S.inl.range := by
    rw [S.range_inl_eq_ker_rightHom]
    exact he
  rcases he' with ⟨n, rfl⟩
  apply MonoidHom.mem_ker.mpr
  apply (QuotientGroup.eq_one_iff _).mpr
  refine ⟨n, ?_⟩
  ext x
  apply S.inl_injective
  simp [MulAut.conj_apply, S.inl_conjAct_comm]

/-- The quotient acts canonically on the kernel through outer
automorphisms.  This definition descends conjugation along the surjective
extension projection and therefore makes no choice of section. -/
noncomputable def outerAction : G →* OuterMulAut N :=
  S.rightHom.liftOfSurjective S.rightHom_surjective
    ⟨S.middleOuterAction, S.ker_rightHom_le_ker_middleOuterAction⟩

theorem outerAction_comp_rightHom :
    S.outerAction.comp S.rightHom = S.middleOuterAction := by
  simp [outerAction]

/-! ## Normalized sections and factor sets -/

/-- A normalized section is a set-theoretic right inverse that sends the
identity to the identity. -/
structure NormalizedSection extends S.Section where
  map_one' : toFun 1 = 1

namespace NormalizedSection

instance : FunLike S.NormalizedSection G E where
  coe σ := σ.toFun
  coe_injective := by
    intro ⟨⟨f, hf⟩, h1⟩ ⟨⟨g, hg⟩, h2⟩ h
    dsimp at h
    cases h
    rfl

@[simp]
theorem rightHom_apply (σ : S.NormalizedSection) (g : G) :
    S.rightHom (σ g) = g :=
  σ.rightInverse_rightHom g

@[simp]
theorem apply_one (σ : S.NormalizedSection) : σ 1 = 1 :=
  σ.map_one'

/-- Every section becomes normalized after multiplying all its values on
the right by the inverse of its value at the identity. -/
def ofSection (σ : S.Section) : S.NormalizedSection where
  toFun g := σ g * (σ 1)⁻¹
  rightInverse_rightHom g := by simp
  map_one' := mul_inv_cancel _

end NormalizedSection

/-- A normalized choice of lifts obtained from a surjective inverse to the
extension projection. -/
noncomputable def normalizedSection : S.NormalizedSection :=
  NormalizedSection.ofSection S S.surjInvRightHom

/-- The automorphism of the kernel induced by a chosen normalized lift. -/
noncomputable def sectionAction (σ : S.NormalizedSection) (g : G) :
    MulAut N :=
  S.conjAct (σ g)

theorem outerAction_eq_sectionClass
    (σ : S.NormalizedSection) (g : G) :
    S.outerAction g = toOuterMulAut N (S.sectionAction σ g) := by
  calc
    S.outerAction g =
        S.outerAction (S.rightHom (σ g)) := by
      rw [NormalizedSection.rightHom_apply (S := S) σ g]
    _ = S.middleOuterAction (σ g) := by
      exact DFunLike.congr_fun S.outerAction_comp_rightHom (σ g)
    _ = toOuterMulAut N (S.sectionAction σ g) := rfl

/-- The element of the middle group whose kernel coordinate is the factor
set value. -/
def factorElement (σ : S.NormalizedSection) (g h : G) : E :=
  σ g * σ h * (σ (g * h))⁻¹

theorem factorElement_mem_range
    (σ : S.NormalizedSection) (g h : G) :
    S.factorElement σ g h ∈ S.inl.range := by
  rw [S.range_inl_eq_ker_rightHom]
  simp [factorElement, MonoidHom.mem_ker]

/-- The normalized nonabelian factor set attached to a normalized section,
with convention
`inl (factorSet g h) = σ g * σ h * (σ (g*h))⁻¹`. -/
noncomputable def factorSet
    (σ : S.NormalizedSection) (g h : G) : N :=
  (MonoidHom.ofInjective S.inl_injective).symm
    ⟨S.factorElement σ g h, S.factorElement_mem_range σ g h⟩

theorem inl_factorSet
    (σ : S.NormalizedSection) (g h : G) :
    S.inl (S.factorSet σ g h) =
      σ g * σ h * (σ (g * h))⁻¹ := by
  exact MonoidHom.apply_ofInjective_symm S.inl_injective
    ⟨S.factorElement σ g h, S.factorElement_mem_range σ g h⟩

@[simp]
theorem factorSet_one_left (σ : S.NormalizedSection) (g : G) :
    S.factorSet σ 1 g = 1 := by
  apply S.inl_injective
  simp [S.inl_factorSet]

@[simp]
theorem factorSet_one_right (σ : S.NormalizedSection) (g : G) :
    S.factorSet σ g 1 = 1 := by
  apply S.inl_injective
  simp [S.inl_factorSet]

/-- The chosen actions multiply up to the inner automorphism represented
by the factor set. -/
theorem sectionAction_mul
    (σ : S.NormalizedSection) (g h : G) :
    S.sectionAction σ g * S.sectionAction σ h =
      MulAut.conj (S.factorSet σ g h) *
        S.sectionAction σ (g * h) := by
  ext n
  apply S.inl_injective
  simp only [map_mul, S.inl_conjAct_comm, sectionAction,
    MulAut.mul_apply, MulAut.conj_apply]
  have hlift :
      S.inl (S.factorSet σ g h) * σ (g * h) = σ g * σ h := by
    rw [S.inl_factorSet]
    group
  calc
    σ g * (σ h * S.inl n * (σ h)⁻¹) * (σ g)⁻¹ =
        (σ g * σ h) * S.inl n * (σ g * σ h)⁻¹ := by group
    _ = (S.inl (S.factorSet σ g h) * σ (g * h)) *
        S.inl n *
          (S.inl (S.factorSet σ g h) * σ (g * h))⁻¹ := by
      rw [hlift]
    _ = S.inl (S.factorSet σ g h) *
        (σ (g * h) * S.inl n * (σ (g * h))⁻¹) *
          S.inl (S.factorSet σ g h)⁻¹ := by
      rw [map_inv]
      group

/-- The nonabelian factor-set identity.  The action term cannot be moved
past either adjacent factor unless the kernel is abelian. -/
theorem factorSet_associativity
    (σ : S.NormalizedSection) (g h k : G) :
    S.factorSet σ g h * S.factorSet σ (g * h) k =
      S.sectionAction σ g (S.factorSet σ h k) *
        S.factorSet σ g (h * k) := by
  apply S.inl_injective
  simp only [map_mul, sectionAction]
  rw [S.inl_factorSet σ g h, S.inl_factorSet σ (g * h) k,
    S.inl_conjAct_comm, S.inl_factorSet σ h k,
    S.inl_factorSet σ g (h * k)]
  group

/-! ## Change of section and splitting -/

/-- The unique kernel-valued cochain comparing two normalized sections on
the left: `τ g = inl (sectionChange σ τ g) * σ g`. -/
noncomputable def sectionChange
    (σ τ : S.NormalizedSection) (g : G) : N :=
  (MonoidHom.ofInjective S.inl_injective).symm
    ⟨τ g * (σ g)⁻¹, by
      rw [S.range_inl_eq_ker_rightHom]
      simp [MonoidHom.mem_ker]⟩

theorem sectionChange_spec
    (σ τ : S.NormalizedSection) (g : G) :
    τ g = S.inl (S.sectionChange σ τ g) * σ g := by
  have h :=
    MonoidHom.apply_ofInjective_symm S.inl_injective
      ⟨τ g * (σ g)⁻¹, by
        rw [S.range_inl_eq_ker_rightHom]
        simp [MonoidHom.mem_ker]⟩
  have h' :
      S.inl (S.sectionChange σ τ g) = τ g * (σ g)⁻¹ := by
    change S.inl (S.sectionChange σ τ g) = τ g * (σ g)⁻¹ at h
    exact h
  calc
    τ g = (τ g * (σ g)⁻¹) * σ g := by group
    _ = S.inl (S.sectionChange σ τ g) * σ g := by rw [h']

@[simp]
theorem sectionChange_one
    (σ τ : S.NormalizedSection) :
    S.sectionChange σ τ 1 = 1 := by
  apply S.inl_injective
  have h := S.sectionChange_spec σ τ 1
  simpa using h.symm

/-- Changing normalized lifts by the kernel cochain `b` changes the chosen
action by the inner automorphism represented by `b`. -/
theorem sectionAction_change
    (σ τ : S.NormalizedSection) (g : G) :
    S.sectionAction τ g =
      MulAut.conj (S.sectionChange σ τ g) *
        S.sectionAction σ g := by
  ext n
  apply S.inl_injective
  simp only [sectionAction, MulAut.mul_apply, MulAut.conj_apply,
    S.inl_conjAct_comm, map_mul, map_inv]
  rw [S.sectionChange_spec σ τ g]
  group

/-- The nonabelian change-of-section law.  For
`τ(g)=inl(b(g))*σ(g)`, the new factor set is
`b(g) α_g(b(h)) f(g,h) b(gh)⁻¹` in this exact order. -/
theorem factorSet_change
    (σ τ : S.NormalizedSection) (g h : G) :
    S.factorSet τ g h =
      S.sectionChange σ τ g *
        S.sectionAction σ g (S.sectionChange σ τ h) *
        S.factorSet σ g h *
        (S.sectionChange σ τ (g * h))⁻¹ := by
  apply S.inl_injective
  simp only [map_mul, map_inv, sectionAction]
  rw [S.inl_factorSet, S.inl_conjAct_comm, S.inl_factorSet]
  rw [S.sectionChange_spec σ τ g, S.sectionChange_spec σ τ h,
    S.sectionChange_spec σ τ (g * h)]
  group

/-- A factor set is trivializable when a normalized change of section
turns it into the constant identity factor set.  The comparison equation
records explicitly that the new section is obtained from the given one by
its normalized kernel-valued cochain. -/
def FactorSetTrivializable (σ : S.NormalizedSection) : Prop :=
  ∃ τ : S.NormalizedSection,
    (∀ g, τ g = S.inl (S.sectionChange σ τ g) * σ g) ∧
      ∀ g h, S.factorSet τ g h = 1

theorem factorSet_eq_one_iff_section_mul
    (σ : S.NormalizedSection) :
    (∀ g h, S.factorSet σ g h = 1) ↔
      ∀ g h, σ (g * h) = σ g * σ h := by
  constructor
  · intro hf g h
    have hfactor := S.inl_factorSet σ g h
    rw [hf g h, map_one] at hfactor
    have hprod : σ g * σ h = σ (g * h) := by
      apply mul_inv_eq_one.mp
      simpa [mul_assoc] using hfactor.symm
    exact hprod.symm
  · intro hmul g h
    apply S.inl_injective
    rw [S.inl_factorSet, hmul g h, mul_inv_cancel, map_one]

/-- A normalized section with identity factor set is a homomorphic
splitting. -/
noncomputable def splittingOfFactorSetOne
    (σ : S.NormalizedSection)
    (hf : ∀ g h, S.factorSet σ g h = 1) :
    S.Splitting where
  toMonoidHom :=
    { toFun := σ
      map_one' := σ.map_one'
      map_mul' := fun g h =>
        (S.factorSet_eq_one_iff_section_mul σ).mp hf g h }
  rightInverse_rightHom := σ.rightInverse_rightHom

/-- The normalized section underlying a splitting has identity factor
set. -/
def Splitting.normalizedSection (s : S.Splitting) :
    S.NormalizedSection where
  toFun := s
  rightInverse_rightHom := s.rightInverse_rightHom
  map_one' := map_one s

@[simp]
theorem Splitting.factorSet_eq_one (s : S.Splitting) (g h : G) :
    S.factorSet (s.normalizedSection) g h = 1 :=
  (S.factorSet_eq_one_iff_section_mul s.normalizedSection).mpr
    (fun g h => map_mul s g h) g h

/-- For every normalized choice of lifts, its nonabelian factor set is
trivializable exactly when the extension splits. -/
theorem factorSet_trivializable_iff_splitting
    (σ : S.NormalizedSection) :
    S.FactorSetTrivializable σ ↔ Nonempty S.Splitting := by
  constructor
  · rintro ⟨τ, _, hτ⟩
    exact ⟨S.splittingOfFactorSetOne τ hτ⟩
  · rintro ⟨s⟩
    refine ⟨s.normalizedSection, ?_, ?_⟩
    · exact fun g => S.sectionChange_spec σ s.normalizedSection g
    · exact s.factorSet_eq_one

/-- Trivializability is independent of the normalized section used to
represent the factor set. -/
theorem factorSet_trivializable_iff
    (σ τ : S.NormalizedSection) :
    S.FactorSetTrivializable σ ↔ S.FactorSetTrivializable τ := by
  rw [S.factorSet_trivializable_iff_splitting,
    S.factorSet_trivializable_iff_splitting]

end

end GroupExtension

namespace RelativeConicArcs.AMELU

noncomputable section

variable {m : ℕ} {𝔽 : Type*}
  [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽]

/-! ## The realized projective party-permutation extension -/

/-- The realized projective party-permutation exact sequence as a
`GroupExtension`. -/
noncomputable def genericPartyPermutationGroupExtension
    (ψ : GenericState m 𝔽) :
    GroupExtension
      (ProjectiveGenericProductUnitaryAutomorphismGroup ψ)
      (ProjectiveGenericPermutedProductUnitaryAutomorphismGroup ψ)
      (RealizedGenericPartyPermutationGroup ψ) where
  inl := projectiveFixedPartyToPermutedAutomorphismHom ψ
  rightHom := projectiveGenericRealizedPartyPermutationHom ψ
  inl_injective :=
    projectiveFixedPartyToPermutedAutomorphismHom_injective ψ
  range_inl_eq_ker_rightHom :=
    (MonoidHom.mulExact_iff.mp
      (projectiveFixedParty_permutationProjection_mulExact ψ)).symm
  rightHom_surjective :=
    projectiveGenericRealizedPartyPermutationHom_surjective ψ

/-- The canonical outer action of realized party permutations on the
fixed-party projective automorphism group.  It is defined by descent and is
independent of any choice of product-unitary lifts. -/
noncomputable def genericPartyPermutationOuterAction
    (ψ : GenericState m 𝔽) :
    RealizedGenericPartyPermutationGroup ψ →*
      GroupExtension.OuterMulAut
        (ProjectiveGenericProductUnitaryAutomorphismGroup ψ) :=
  (genericPartyPermutationGroupExtension ψ).outerAction

/-- A normalized set-theoretic choice of projective product-unitary lifts
of the realized party permutations. -/
noncomputable def genericPartyPermutationNormalizedSection
    (ψ : GenericState m 𝔽) :
    (genericPartyPermutationGroupExtension ψ).NormalizedSection :=
  (genericPartyPermutationGroupExtension ψ).normalizedSection

/-- The nonabelian factor set attached to the normalized choice of
projective product-unitary lifts. -/
noncomputable def genericPartyPermutationFactorSet
    (ψ : GenericState m 𝔽)
    (π ρ : RealizedGenericPartyPermutationGroup ψ) :
    ProjectiveGenericProductUnitaryAutomorphismGroup ψ :=
  (genericPartyPermutationGroupExtension ψ).factorSet
    (genericPartyPermutationNormalizedSection ψ) π ρ

/-- The chosen factor set obeys the nonabelian associativity identity. -/
theorem genericPartyPermutationFactorSet_associativity
    (ψ : GenericState m 𝔽)
    (π ρ υ : RealizedGenericPartyPermutationGroup ψ) :
    genericPartyPermutationFactorSet ψ π ρ *
        genericPartyPermutationFactorSet ψ (π * ρ) υ =
      (genericPartyPermutationGroupExtension ψ).sectionAction
          (genericPartyPermutationNormalizedSection ψ) π
          (genericPartyPermutationFactorSet ψ ρ υ) *
        genericPartyPermutationFactorSet ψ π (ρ * υ) :=
  (genericPartyPermutationGroupExtension ψ).factorSet_associativity
    (genericPartyPermutationNormalizedSection ψ) π ρ υ

/-- Any other normalized choice of lifts changes the factor set by the
ordered nonabelian coboundary formula. -/
theorem genericPartyPermutationFactorSet_change
    (ψ : GenericState m 𝔽)
    (τ : (genericPartyPermutationGroupExtension ψ).NormalizedSection)
    (π ρ : RealizedGenericPartyPermutationGroup ψ) :
    (genericPartyPermutationGroupExtension ψ).factorSet τ π ρ =
      (genericPartyPermutationGroupExtension ψ).sectionChange
          (genericPartyPermutationNormalizedSection ψ) τ π *
        (genericPartyPermutationGroupExtension ψ).sectionAction
          (genericPartyPermutationNormalizedSection ψ) π
          ((genericPartyPermutationGroupExtension ψ).sectionChange
            (genericPartyPermutationNormalizedSection ψ) τ ρ) *
        genericPartyPermutationFactorSet ψ π ρ *
        ((genericPartyPermutationGroupExtension ψ).sectionChange
          (genericPartyPermutationNormalizedSection ψ) τ (π * ρ))⁻¹ :=
  (genericPartyPermutationGroupExtension ψ).factorSet_change
    (genericPartyPermutationNormalizedSection ψ) τ π ρ

/-- The realized party-permutation extension splits exactly when the
factor set of the normalized chosen lifts can be trivialized by a normalized
change of section. -/
theorem genericPartyPermutationFactorSet_trivializable_iff_splits
    (ψ : GenericState m 𝔽) :
    (genericPartyPermutationGroupExtension ψ).FactorSetTrivializable
        (genericPartyPermutationNormalizedSection ψ) ↔
      Nonempty (GenericPartyPermutationExtensionSplitting ψ) := by
  constructor
  · intro h
    obtain ⟨s⟩ :=
      (GroupExtension.factorSet_trivializable_iff_splitting
        (genericPartyPermutationGroupExtension ψ)
        (genericPartyPermutationNormalizedSection ψ)).mp h
    refine ⟨⟨s.toMonoidHom, ?_⟩⟩
    apply MonoidHom.ext
    intro π
    exact s.rightInverse_rightHom π
  · rintro ⟨s⟩
    apply (GroupExtension.factorSet_trivializable_iff_splitting
      (genericPartyPermutationGroupExtension ψ)
      (genericPartyPermutationNormalizedSection ψ)).mpr
    exact ⟨{
      toMonoidHom := s.lift
      rightInverse_rightHom := fun π => by
        have h := DFunLike.congr_fun s.rightInverse π
        exact h }⟩

end

end RelativeConicArcs.AMELU
