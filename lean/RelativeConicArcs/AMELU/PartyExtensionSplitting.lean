import RelativeConicArcs.AMELU.NonabelianExtensionInvariant

/-!
# Splitting consequences for party-permutation extensions

A homomorphic section of a group extension does more than decide that the
extension splits.  Relative to any normalized set-theoretic section, it gives
an explicit normalized kernel cochain that trivializes the associated
nonabelian factor set.  It also identifies the middle group with the
semidirect product determined by conjugation, giving unique kernel--quotient
coordinates and the corresponding cardinality formula.

The first part of this module proves these statements for an arbitrary group
extension.  The second part specializes them to the realized projective
party-permutation extension of an equal-phase MDS--CSS state.

All declarations are symbolic and kernel checked.  There is no generated
finite data, native evaluation, axiom, or admitted declaration in this
module.
-/

namespace GroupExtension

noncomputable section

variable {N E G : Type*} [Group N] [Group E] [Group G]
  {S : GroupExtension N E G}

namespace Splitting

/-- The normalized kernel cochain that changes a chosen normalized section
to the homomorphic normalized section underlying a splitting. -/
noncomputable def trivializingCochain
    (s : S.Splitting) (σ : S.NormalizedSection) (g : G) : N :=
  S.sectionChange σ s.normalizedSection g

@[simp]
theorem trivializingCochain_one
    (s : S.Splitting) (σ : S.NormalizedSection) :
    s.trivializingCochain σ 1 = 1 :=
  S.sectionChange_one σ s.normalizedSection

/-- Multiplication by the explicit kernel cochain changes the chosen
normalized lift into the homomorphic lift supplied by the splitting. -/
theorem inl_trivializingCochain_mul
    (s : S.Splitting) (σ : S.NormalizedSection) (g : G) :
    S.inl (s.trivializingCochain σ g) * σ g = s g := by
  exact (S.sectionChange_spec σ s.normalizedSection g).symm

/-- The explicit cochain satisfies the ordered nonabelian coboundary
equation that changes the chosen factor set to the identity factor set. -/
theorem trivializingCochain_coboundary
    (s : S.Splitting) (σ : S.NormalizedSection) (g h : G) :
    s.trivializingCochain σ g *
        S.sectionAction σ g (s.trivializingCochain σ h) *
        S.factorSet σ g h *
        (s.trivializingCochain σ (g * h))⁻¹ = 1 := by
  have hchange :=
    S.factorSet_change σ s.normalizedSection g h
  simpa [trivializingCochain, s.factorSet_eq_one] using hchange.symm

/-- A splitting identifies the middle group with the semidirect product of
the kernel by the quotient, using the conjugation action induced by the
homomorphic section. -/
noncomputable def semidirectProductEquiv
    (s : S.Splitting) :
    SemidirectProduct N G s.conjAct ≃* E :=
  s.semidirectProductToGroupExtensionEquiv.toMulEquiv

@[simp]
theorem semidirectProductEquiv_apply
    (s : S.Splitting) (n : N) (g : G) :
    s.semidirectProductEquiv ⟨n, g⟩ = S.inl n * s g :=
  rfl

/-- Every element of the middle group has unique kernel and quotient
coordinates determined by a splitting. -/
theorem existsUnique_inl_mul_splitting
    (s : S.Splitting) (e : E) :
    ∃! ng : N × G, e = S.inl ng.1 * s ng.2 := by
  let x := (s.semidirectProductEquiv).symm e
  have hx : e = S.inl x.left * s x.right := by
    rw [← semidirectProductEquiv_apply]
    exact (s.semidirectProductEquiv).apply_symm_apply e |>.symm
  refine ⟨(x.left, x.right), hx, ?_⟩
  · rintro ⟨n, g⟩ h
    have heq :
        s.semidirectProductEquiv
            (⟨n, g⟩ : SemidirectProduct N G s.conjAct) =
          s.semidirectProductEquiv x := by
      rw [semidirectProductEquiv_apply, semidirectProductEquiv_apply]
      exact h.symm.trans hx
    have hpair :
        (⟨n, g⟩ : SemidirectProduct N G s.conjAct) = x :=
      (s.semidirectProductEquiv).injective heq
    exact congrArg (fun y => (y.left, y.right)) hpair

/-- The cardinality of a split extension is the product of the cardinalities
of its kernel and quotient.  `Nat.card` makes the statement valid without
separate finiteness typeclass assumptions. -/
theorem natCard_middle
    (s : S.Splitting) :
    Nat.card E = Nat.card N * Nat.card G := by
  calc
    Nat.card E =
        Nat.card (SemidirectProduct N G s.conjAct) :=
      (Nat.card_congr s.semidirectProductEquiv.toEquiv).symm
    _ = Nat.card N * Nat.card G := SemidirectProduct.card

end Splitting

end

section Inversion

noncomputable section

variable {N E G : Type*} [CommGroup N] [Group E] [Group G]
  {S : GroupExtension N E G}

namespace Splitting

/-- A quotient element acts by inversion on the kernel under the
conjugation action induced by a splitting.  For a projective split-torus
kernel this is the algebraic condition detected by the nontrivial normalizer
class. -/
def InvertsKernel (s : S.Splitting) (g : G) : Prop :=
  s.conjAct g = MulEquiv.inv N

/-- An inverting quotient element conjugates every embedded kernel element
to its inverse. -/
theorem inl_conj_eq_inv
    (s : S.Splitting) {g : G} (hg : s.InvertsKernel g) (n : N) :
    s g * S.inl n * (s g)⁻¹ = S.inl n⁻¹ := by
  calc
    s g * S.inl n * (s g)⁻¹ =
        S.inl (S.conjAct (s g) n) :=
      (S.inl_conjAct_comm (e := s g) (n := n)).symm
    _ = S.inl (s.conjAct g n) := rfl
    _ = S.inl n⁻¹ := by rw [hg]; rfl

/-- A homomorphic lift of an involution is itself an involution.  Together
with `inl_conj_eq_inv`, this is the abstract witness for a split
party-extension element whose projective action inverts a torus.  It does not
assert that a chosen determinant-one matrix representative of that projective
action has order two. -/
theorem invertingInvolutionWitness
    (s : S.Splitting) {g : G}
    (hg_order : g * g = 1) (hg_action : s.InvertsKernel g) :
    s g * s g = 1 ∧
      ∀ n : N, s g * S.inl n * (s g)⁻¹ = S.inl n⁻¹ := by
  constructor
  · rw [← map_mul, hg_order, map_one]
  · exact s.inl_conj_eq_inv hg_action

end Splitting

end

end Inversion

end GroupExtension

namespace RelativeConicArcs.AMELU

noncomputable section

variable {m : ℕ} {𝔽 : Type*}
  [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽]

/-- Convert a homomorphic projective product-unitary lift of every realized
party permutation into the splitting structure of the abstract realized
party-permutation group extension. -/
noncomputable def genericPartyPermutationGroupExtensionSplitting
    (ψ : GenericState m 𝔽)
    (s : GenericPartyPermutationExtensionSplitting ψ) :
    (genericPartyPermutationGroupExtension ψ).Splitting where
  toMonoidHom := s.lift
  rightInverse_rightHom := fun π => by
    have h := DFunLike.congr_fun s.rightInverse π
    exact h

/-- The explicit fixed-party projective automorphism that changes the
chosen normalized lift of a realized party permutation into a given
homomorphic lift. -/
noncomputable def genericPartyPermutationTrivializingCochain
    (ψ : GenericState m 𝔽)
    (s : GenericPartyPermutationExtensionSplitting ψ)
    (π : RealizedGenericPartyPermutationGroup ψ) :
    ProjectiveGenericProductUnitaryAutomorphismGroup ψ :=
  (genericPartyPermutationGroupExtensionSplitting ψ s).trivializingCochain
    (genericPartyPermutationNormalizedSection ψ) π

@[simp]
theorem genericPartyPermutationTrivializingCochain_one
    (ψ : GenericState m 𝔽)
    (s : GenericPartyPermutationExtensionSplitting ψ) :
    genericPartyPermutationTrivializingCochain ψ s 1 = 1 :=
  (genericPartyPermutationGroupExtensionSplitting ψ s).trivializingCochain_one
    (genericPartyPermutationNormalizedSection ψ)

/-- The explicit correction cochain changes the canonical normalized
set-theoretic lift into the supplied homomorphic lift. -/
theorem genericPartyPermutation_correctedSection_eq_lift
    (ψ : GenericState m 𝔽)
    (s : GenericPartyPermutationExtensionSplitting ψ)
    (π : RealizedGenericPartyPermutationGroup ψ) :
    projectiveFixedPartyToPermutedAutomorphismHom ψ
          (genericPartyPermutationTrivializingCochain ψ s π) *
        genericPartyPermutationNormalizedSection ψ π =
      s.lift π :=
  GroupExtension.Splitting.inl_trivializingCochain_mul
    (genericPartyPermutationGroupExtensionSplitting ψ s)
    (genericPartyPermutationNormalizedSection ψ) π

/-- The correction cochain obeys the ordered nonabelian coboundary equation
that trivializes the canonical factor set. -/
theorem genericPartyPermutationTrivializingCochain_coboundary
    (ψ : GenericState m 𝔽)
    (s : GenericPartyPermutationExtensionSplitting ψ)
    (π ρ : RealizedGenericPartyPermutationGroup ψ) :
    genericPartyPermutationTrivializingCochain ψ s π *
        (genericPartyPermutationGroupExtension ψ).sectionAction
          (genericPartyPermutationNormalizedSection ψ) π
          (genericPartyPermutationTrivializingCochain ψ s ρ) *
        genericPartyPermutationFactorSet ψ π ρ *
        (genericPartyPermutationTrivializingCochain ψ s (π * ρ))⁻¹ = 1 :=
  GroupExtension.Splitting.trivializingCochain_coboundary
    (genericPartyPermutationGroupExtensionSplitting ψ s)
    (genericPartyPermutationNormalizedSection ψ) π ρ

/-- A coherent choice of party-permutation lifts identifies the projective
party-moving automorphism group with the semidirect product of its
fixed-party subgroup by the realized party-permutation group. -/
noncomputable def genericPartyPermutationSemidirectProductEquiv
    (ψ : GenericState m 𝔽)
    (s : GenericPartyPermutationExtensionSplitting ψ) :
    SemidirectProduct
        (ProjectiveGenericProductUnitaryAutomorphismGroup ψ)
        (RealizedGenericPartyPermutationGroup ψ)
        (genericPartyPermutationGroupExtensionSplitting ψ s).conjAct ≃*
      ProjectiveGenericPermutedProductUnitaryAutomorphismGroup ψ :=
  (genericPartyPermutationGroupExtensionSplitting ψ s).semidirectProductEquiv

/-- In a split realized party-permutation extension, the order of the
projective party-moving group is the product of the fixed-party and realized
party-permutation group orders. -/
theorem genericPartyPermutation_natCard
    (ψ : GenericState m 𝔽)
    (s : GenericPartyPermutationExtensionSplitting ψ) :
    Nat.card (ProjectiveGenericPermutedProductUnitaryAutomorphismGroup ψ) =
      Nat.card (ProjectiveGenericProductUnitaryAutomorphismGroup ψ) *
        Nat.card (RealizedGenericPartyPermutationGroup ψ) :=
  (genericPartyPermutationGroupExtensionSplitting ψ s).natCard_middle

end

end RelativeConicArcs.AMELU
