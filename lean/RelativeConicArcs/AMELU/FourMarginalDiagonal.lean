import RelativeConicArcs.AMELU.MarginalWeylExpansion

/-!
# Diagonal form of four-party MDS marginals

The shortening parameters `(a,b)` are transported to the local Weyl
labels at each retained party.  Since every local transport is
bijective, reindexing the four local Weyl bases by these maps turns the
complete marginal coefficient array, including its identity entry, into
the full diagonal four-array on `𝔽 × 𝔽`.

All arguments are symbolic and kernel checked.  The module contains no
generated data, native evaluation, axioms, or admitted declarations.
-/

namespace RelativeConicArcs.AMELU

open Finset

variable {𝔽 : Type*} [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽]

/-- The shortening parameters mapped to the local Weyl label at one
retained party. -/
noncomputable def shorteningLocalLabelEquiv
    {C : Submodule 𝔽 (BasisLabel 𝔽)} (hC : IsMDSCode634 C)
    {S : Finset Party} (hS : S.card = 4) {i : Party} (hi : i ∈ S) :
    (𝔽 × 𝔽) ≃ (𝔽 × 𝔽) :=
  Equiv.ofBijective
    (fun v : 𝔽 × 𝔽 =>
      (v.1 * (fourShorteningGenerator C hC S hS).word i,
        v.2 * (fourShorteningGenerator (FiniteGeom.dualCode C)
          (isMDSCode634_dualCode hC) S hS).word i))
    (shorteningLocalLabel_bijective hC hS hi)

@[simp]
theorem shorteningLocalLabelEquiv_apply
    {C : Submodule 𝔽 (BasisLabel 𝔽)} (hC : IsMDSCode634 C)
    {S : Finset Party} (hS : S.card = 4) {i : Party} (hi : i ∈ S)
    (v : 𝔽 × 𝔽) :
    shorteningLocalLabelEquiv hC hS hi v =
      (v.1 * (fourShorteningGenerator C hC S hS).word i,
        v.2 * (fourShorteningGenerator (FiniteGeom.dualCode C)
          (isMDSCode634_dualCode hC) S hS).word i) :=
  rfl

/-- Local labels on an ordered four-set, reindexed by the shortening
parameter at each party. -/
noncomputable def reindexedFourLabels
    {C : Submodule 𝔽 (BasisLabel 𝔽)} (hC : IsMDSCode634 C)
    {S : Finset Party} (hS : S.card = 4) (e : Fin 4 ≃ S)
    (x : Fin 4 → 𝔽 × 𝔽) : S → 𝔽 × 𝔽 :=
  fun i => shorteningLocalLabelEquiv hC hS i.2 (x (e.symm i))

/-- The zero extension of reindexed local labels is a CSS label exactly
when all four shortening parameters agree. -/
theorem reindexedFourLabels_mem_cssLabelSpace_iff
    {C : Submodule 𝔽 (BasisLabel 𝔽)} (hC : IsMDSCode634 C)
    {S : Finset Party} (hS : S.card = 4) (e : Fin 4 ≃ S)
    (x : Fin 4 → 𝔽 × 𝔽) :
    extendSubsystemPauliLabel S (reindexedFourLabels hC hS e x) ∈
        cssLabelSpace C ↔
      ∃ v : 𝔽 × 𝔽, ∀ j, x j = v := by
  classical
  let p :=
    extendSubsystemPauliLabel S (reindexedFourLabels hC hS e x)
  have hpSupport : pauliSupport p ⊆ S := by
    rw [pauliSupport_subset_iff]
    exact extendSubsystemPauliLabel_supportedOn S
      (reindexedFourLabels hC hS e x)
  change p ∈ cssLabelSpace C ↔ _
  have hpMem :
      p ∈ cssSupportedLabelSpace C S ↔ p ∈ cssLabelSpace C := by
    rw [mem_cssSupportedLabelSpace_iff_support_subset]
    simp [hpSupport]
  rw [← hpMem, cssSupportedLabelSpace_eq_shortening_plane hC hS]
  constructor
  · rintro ⟨a, b, hp⟩
    refine ⟨(a, b), ?_⟩
    intro j
    let i : S := e j
    apply (shorteningLocalLabelEquiv hC hS i.2).injective
    have hpi := congrArg
      (fun z : PauliLabel 𝔽 => (z.1 i.1, z.2 i.1)) hp
    simpa only [p, extendSubsystemPauliLabel, dif_pos i.2,
      reindexedFourLabels, i, e.symm_apply_apply,
      shorteningLocalLabelEquiv_apply, Pi.smul_apply, smul_eq_mul] using hpi
  · rintro ⟨v, hv⟩
    refine ⟨v.1, v.2, ?_⟩
    apply Prod.ext <;> funext i
    · by_cases hi : i ∈ S
      · let j : Fin 4 := e.symm ⟨i, hi⟩
        have hxj := hv j
        have hlocal := congrArg
          (shorteningLocalLabelEquiv hC hS hi) hxj
        simp only [p, extendSubsystemPauliLabel, dif_pos hi,
          reindexedFourLabels, Pi.smul_apply, smul_eq_mul]
        change
          (shorteningLocalLabelEquiv hC hS hi
            (x (e.symm ⟨i, hi⟩))).1 =
          (shorteningLocalLabelEquiv hC hS hi v).1
        exact congrArg Prod.fst hlocal
      · simp [p, extendSubsystemPauliLabel, hi,
          (fourShorteningGenerator C hC S hS).eq_zero_off i hi]
    · by_cases hi : i ∈ S
      · let j : Fin 4 := e.symm ⟨i, hi⟩
        have hxj := hv j
        have hlocal := congrArg
          (shorteningLocalLabelEquiv hC hS hi) hxj
        simp only [p, extendSubsystemPauliLabel, dif_pos hi,
          reindexedFourLabels, Pi.smul_apply, smul_eq_mul]
        change
          (shorteningLocalLabelEquiv hC hS hi
            (x (e.symm ⟨i, hi⟩))).2 =
          (shorteningLocalLabelEquiv hC hS hi v).2
        exact congrArg Prod.snd hlocal
      · simp [p, extendSubsystemPauliLabel, hi,
          (fourShorteningGenerator (FiniteGeom.dualCode C)
            (isMDSCode634_dualCode hC) S hS).eq_zero_off i hi]

/-- The four-party marginal Weyl coefficients, with each local Weyl
label pulled back to the common shortening parameter space. -/
noncomputable def reindexedFourMarginalArray
    (w : WeylConvention 𝔽)
    {C : Submodule 𝔽 (BasisLabel 𝔽)} (hC : IsMDSCode634 C)
    {S : Finset Party} (hS : S.card = 4) (e : Fin 4 ≃ S) :
    FourArray (𝔽 × 𝔽) :=
  fun a b c d =>
    marginalWeylCoefficient w (equalPhaseState C) S
      (reindexedFourLabels hC hS e ![a, b, c, d])

/-- After the local shortening reindexings, the complete marginal
coefficient tensor is the full diagonal tensor on all `q²` Weyl labels.
The identity label is included and has the same nonzero coefficient as
every other diagonal label. -/
theorem reindexedFourMarginalArray_eq_diagonal
    (w : WeylConvention 𝔽)
    {C : Submodule 𝔽 (BasisLabel 𝔽)} (hC : IsMDSCode634 C)
    {S : Finset Party} (hS : S.card = 4) (e : Fin 4 ≃ S) :
    reindexedFourMarginalArray w hC hS e =
      diagonalFourArray
        (fun _ : 𝔽 × 𝔽 => ((Fintype.card 𝔽 : ℂ) ^ 4)⁻¹) := by
  classical
  funext a b c d
  let x : Fin 4 → 𝔽 × 𝔽 := ![a, b, c, d]
  let p :=
    extendSubsystemPauliLabel S (reindexedFourLabels hC hS e x)
  have hcases :=
    marginalWeylCoefficient_equalPhaseState_cases w hC S
      (reindexedFourLabels hC hS e x)
  dsimp only at hcases
  by_cases hdiag : a = b ∧ b = c ∧ c = d
  · have hx : ∃ v : 𝔽 × 𝔽, ∀ j, x j = v := by
      refine ⟨a, ?_⟩
      intro j
      fin_cases j <;> simp [x, hdiag.1, hdiag.2.1, hdiag.2.2]
    have hp : p ∈ cssLabelSpace C :=
      (reindexedFourLabels_mem_cssLabelSpace_iff hC hS e x).2 hx
    have hvalue := hcases.1 hp
    simpa [reindexedFourMarginalArray, diagonalFourArray, x, p, hdiag,
      hS] using hvalue
  · have hp : p ∉ cssLabelSpace C := by
      intro hp
      obtain ⟨v, hv⟩ :=
        (reindexedFourLabels_mem_cssLabelSpace_iff hC hS e x).1 hp
      apply hdiag
      have h0 := hv 0
      have h1 := hv 1
      have h2 := hv 2
      have h3 := hv 3
      simpa [x] using And.intro (h0.trans h1.symm)
        (And.intro (h1.trans h2.symm) (h2.trans h3.symm))
    have hvalue := hcases.2 hp
    simpa [reindexedFourMarginalArray, diagonalFourArray, x, p, hdiag]
      using hvalue

end RelativeConicArcs.AMELU
