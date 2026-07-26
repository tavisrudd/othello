import RelativeConicArcs.AMELU.GenericTensorRigidity
import RelativeConicArcs.AMELU.GenericPartyPermutation
import RelativeConicArcs.AMELU.LUPencilClassification

/-!
# Length-generic local-unitary rigidity

For every retained `(m+1)`-set of an exact `[2m,m,m+1]` code, shortening
coordinates turn the complete marginal Weyl array into a full diagonal
tensor.  Reduced-matrix covariance intertwines the source and target arrays
by the local unitary conjugation maps.  Arbitrary-arity diagonal-tensor
rigidity then makes each retained local conjugation monomial in the Weyl
basis, hence Clifford.  Retained sets cover all `2m` parties.

The terminal theorem is unconditional for every finite field and every
`m ≥ 2`.  Its `m=3` specialization agrees with the established six-party
state and equivalence relations; the admitted-pencil scalar classification
continues to use its separate prime-field geometric hypotheses.

All arguments are symbolic and kernel checked.  The module contains no
generated data, native evaluation, axioms, or admitted declarations.
-/

namespace RelativeConicArcs.AMELU

open Finset

variable {m : ℕ} {𝔽 : Type*}
  [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽]

private theorem genericFamilyExpansion
    {ι κ : Type*} [Fintype ι] [DecidableEq ι]
    [Fintype κ] [DecidableEq κ]
    (T : FamilyArray ι κ) :
    T = ∑ v, T v • coordinateVector v 1 := by
  classical
  funext x
  simp [coordinateVector]

/-- Product-unitary conjugation in product-Weyl coordinates is the
independent action of the local one-qudit coordinate equivalences. -/
theorem finiteProductUnitaryConjugationWeylEquiv_eq_mapFamilyArray
    {ι : Type*} [Fintype ι] [DecidableEq ι]
    (w : WeylConvention 𝔽)
    (U : ι → LocalMatrix 𝔽) (hU : ∀ i, IsUnitaryMatrix (U i))
    (T : FamilyArray ι (𝔽 × 𝔽)) :
    finiteProductUnitaryConjugationWeylEquiv w U hU T =
      mapFamilyArray
        (fun i => unitaryConjugationWeylEquiv w (U i) (hU i)) T := by
  classical
  funext x
  conv_lhs =>
    rw [genericFamilyExpansion T]
  simp only [map_sum, map_smul, Finset.sum_apply, Pi.smul_apply,
    smul_eq_mul,
    finiteProductUnitaryConjugationWeylEquiv_coordinateVector]
  rfl

private theorem mapFamilyArray_relabel
    {ι κ : Type*} [Fintype ι] [DecidableEq ι]
    [Fintype κ] [DecidableEq κ]
    (e : ι → Equiv.Perm κ) (T : FamilyArray ι κ) :
    mapFamilyArray (fun i => relabelCoordinateEquiv (e i)) T =
      fun x => T (fun i => (e i).symm (x i)) := by
  classical
  funext x
  unfold mapFamilyArray
  let y₀ : ι → κ := fun i => (e i).symm (x i)
  rw [Fintype.sum_eq_single y₀]
  · have hlocal (i : ι) :
        relabelCoordinateEquiv (e i)
            (coordinateVector (y₀ i) 1) (x i) = 1 := by
      rw [relabelCoordinateEquiv_coordinateVector]
      simp [coordinateVector, y₀]
    simp_rw [hlocal, Finset.prod_const_one, mul_one]
    rfl
  · intro y hy
    obtain ⟨i, hi⟩ : ∃ i, y i ≠ y₀ i := by
      by_contra hpoint
      push Not at hpoint
      exact hy (funext hpoint)
    have hlabel : e i (y i) ≠ x i := by
      intro h
      apply hi
      rw [← (e i).symm_apply_apply (y i), h]
    rw [Finset.prod_eq_zero (Finset.mem_univ i)]
    · simp
    · rw [relabelCoordinateEquiv_coordinateVector]
      simp [coordinateVector, Ne.symm hlabel]

/-- The marginal coefficient array after every retained local label is
pulled back to the common shortening parameter. -/
noncomputable def genericReindexedMarginalArray
    (hm : 0 < m) (w : WeylConvention 𝔽)
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C) {S : Finset (GenericParty m)}
    (hS : S.card = m + 1) :
    FamilyArray S (𝔽 × 𝔽) :=
  fun x =>
    genericMarginalWeylCoefficient w (genericEqualPhaseState C) S
      (genericReindexedMarginalLabels hm hC hS x)

/-- The complete reindexed shortened marginal is a full diagonal family
array with one common nonzero coefficient. -/
theorem genericReindexedMarginalArray_eq_diagonal
    (hm : 0 < m) (w : WeylConvention 𝔽)
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C) {S : Finset (GenericParty m)}
    (hS : S.card = m + 1) :
    genericReindexedMarginalArray hm w hC hS =
      diagonalFamilyArray
        (fun _ : 𝔽 × 𝔽 =>
          ((Fintype.card 𝔽 : ℂ) ^ (m + 1))⁻¹) := by
  classical
  funext x
  change
    genericMarginalWeylCoefficient w (genericEqualPhaseState C) S
        (genericReindexedMarginalLabels hm hC hS x) =
      diagonalFamilyArray
        (fun _ : 𝔽 × 𝔽 =>
          ((Fintype.card 𝔽 : ℂ) ^ (m + 1))⁻¹) x
  rw [genericReindexedMarginalCoefficient_eq_iff]
  by_cases hdiag : ∃ v : 𝔽 × 𝔽, ∀ i, x i = v
  · rw [if_pos hdiag]
    obtain ⟨v, hv⟩ := hdiag
    have hx : x = fun _ => v := funext hv
    subst x
    unfold diagonalFamilyArray
    rw [Fintype.sum_eq_single v]
    · simp [coordinateVector]
    · intro u huv
      have hfun : (fun _ : S => v) ≠ fun _ => u := by
        intro h
        have hi := congrFun h ⟨S.min' (by
          rw [← Finset.card_pos, hS]
          omega), S.min'_mem (by
            rw [← Finset.card_pos, hS]
            omega)⟩
        exact huv hi.symm
      simp [coordinateVector, hfun]
  · rw [if_neg hdiag]
    unfold diagonalFamilyArray
    symm
    apply Finset.sum_eq_zero
    intro v _
    have hfun : (fun _ : S => v) ≠ x := by
      intro h
      exact hdiag ⟨v, fun i => congrFun h.symm i⟩
    simp [coordinateVector, Ne.symm hfun]

/-- Local unitary conjugation transported between the source and target
shortening coordinates at one retained party. -/
noncomputable def genericTransportedLocalConjugation
    (hm : 0 < m) (w : WeylConvention 𝔽)
    {C D : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C) (hD : IsMDSCode2m D)
    {S : Finset (GenericParty m)} (hS : S.card = m + 1)
    (i : S) (U : LocalMatrix 𝔽) (hU : IsUnitaryMatrix U) :
    (𝔽 × 𝔽 → ℂ) ≃ₗ[ℂ] (𝔽 × 𝔽 → ℂ) :=
  relabelCoordinateEquiv
      (genericShorteningLocalLabelEquiv hm hC hS i.2) ≪≫ₗ
    unitaryConjugationWeylEquiv w U hU ≪≫ₗ
      (relabelCoordinateEquiv
        (genericShorteningLocalLabelEquiv hm hD hS i.2)).symm

private theorem genericReindexedMarginalArray_eq_relabelled
    (hm : 0 < m) (w : WeylConvention 𝔽)
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C) {S : Finset (GenericParty m)}
    (hS : S.card = m + 1) :
    genericReindexedMarginalArray hm w hC hS =
      mapFamilyArray
        (fun i : S =>
          relabelCoordinateEquiv
            (genericShorteningLocalLabelEquiv hm hC hS i.2).symm)
        (fun v =>
          genericMarginalWeylCoefficient w
            (genericEqualPhaseState C) S v) := by
  rw [mapFamilyArray_relabel]
  rfl

/-- A phase-normalized product action between two generic equal-phase MDS
states intertwines the full shortened marginal arrays in shortening
coordinates. -/
theorem genericReindexedMarginalArray_intertwining
    (hm : 0 < m) (w : WeylConvention 𝔽)
    {C D : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C) (hD : IsMDSCode2m D)
    (U : GenericParty m → LocalMatrix 𝔽)
    (hU : ∀ i, IsUnitaryMatrix (U i))
    (phase : ℂ) (hphase : Complex.normSq phase = 1)
    (hstate :
      genericLocalAction U (genericEqualPhaseState C) =
        phase • genericEqualPhaseState D)
    {S : Finset (GenericParty m)} (hS : S.card = m + 1) :
    mapFamilyArray
        (fun i : S =>
          genericTransportedLocalConjugation
            hm w hC hD hS i (U i.1) (hU i.1))
        (genericReindexedMarginalArray hm w hC hS) =
      genericReindexedMarginalArray hm w hD hS := by
  classical
  let LC : S → Equiv.Perm (𝔽 × 𝔽) :=
    fun i => genericShorteningLocalLabelEquiv hm hC hS i.2
  let LD : S → Equiv.Perm (𝔽 × 𝔽) :=
    fun i => genericShorteningLocalLabelEquiv hm hD hS i.2
  let W : S → ((𝔽 × 𝔽 → ℂ) ≃ₗ[ℂ] (𝔽 × 𝔽 → ℂ)) :=
    fun i => unitaryConjugationWeylEquiv w (U i.1) (hU i.1)
  let FC : FamilyArray S (𝔽 × 𝔽) :=
    fun v => genericMarginalWeylCoefficient w
      (genericEqualPhaseState C) S v
  let FD : FamilyArray S (𝔽 × 𝔽) :=
    fun v => genericMarginalWeylCoefficient w
      (genericEqualPhaseState D) S v
  have hordinary :
      mapFamilyArray W FC = FD := by
    rw [← finiteProductUnitaryConjugationWeylEquiv_eq_mapFamilyArray]
    exact genericMarginalWeylCoordinates_eq_of_localAction_eq
      w U hU phase hphase
        (genericEqualPhaseState C) (genericEqualPhaseState D)
        hstate S
  rw [genericReindexedMarginalArray_eq_relabelled,
    genericReindexedMarginalArray_eq_relabelled]
  rw [mapFamilyArray_comp]
  have hfactor :
      (fun i : S =>
        relabelCoordinateEquiv (LC i).symm ≪≫ₗ
          genericTransportedLocalConjugation
            hm w hC hD hS i (U i.1) (hU i.1)) =
      fun i : S => W i ≪≫ₗ
        relabelCoordinateEquiv (LD i).symm := by
    funext i
    apply LinearEquiv.ext
    intro f
    change
      relabelCoordinateEquiv (LD i).symm
          (W i
            (relabelCoordinateEquiv (LC i)
              (relabelCoordinateEquiv (LC i).symm f))) =
        relabelCoordinateEquiv (LD i).symm (W i f)
    congr 1
    apply congrArg (W i)
    funext j
    simp [relabelCoordinateEquiv]
  rw [hfactor, ← mapFamilyArray_comp, hordinary]

private theorem generic_relabelCoordinateEquiv_preserves_axis
    {κ κ₂ : Type*} [DecidableEq κ] [DecidableEq κ₂]
    (e : κ ≃ κ₂) {f : κ → ℂ}
    (hf : IsNonzeroCoordinateAxis f) :
    IsNonzeroCoordinateAxis (relabelCoordinateEquiv e f) := by
  obtain ⟨i, z, hz, rfl⟩ := hf
  exact
    ⟨e i, z, hz,
      relabelCoordinateEquiv_coordinateVector e i z⟩

/-- A product of one-qudit conjugations carrying one full diagonal Weyl
coordinate tensor to another is Clifford in every factor.  The factors are
indexed by the complete local Weyl-label plane, all diagonal coefficients are
nonzero, and at least three tensor factors are present. -/
theorem all_isClifford_of_fullWeylDiagonal_intertwining
    {ι : Type*} [Fintype ι] [DecidableEq ι]
    (hι : 3 ≤ Fintype.card ι)
    (w : WeylConvention 𝔽)
    (U : ι → LocalMatrix 𝔽)
    (hU : ∀ i, IsUnitaryMatrix (U i))
    {coeff target : (𝔽 × 𝔽) → ℂ}
    (hcoeff : ∀ v, coeff v ≠ 0)
    (htarget : ∀ v, target v ≠ 0)
    (hmap :
      mapFamilyArray
          (fun i => unitaryConjugationWeylEquiv w (U i) (hU i))
          (diagonalFamilyArray (ι := ι) coeff) =
        diagonalFamilyArray (ι := ι) target) :
    ∀ i, IsCliffordMatrix w (U i) := by
  intro i
  have haxes :=
    familyFactor_coordinateAxes_of_diagonal_equivalent
      hι
      (fun j => unitaryConjugationWeylEquiv w (U j) (hU j))
      hcoeff htarget hmap i
  exact isCliffordMatrix_of_weylCoordinate_axes w (U i) (hU i) haxes

private theorem genericMarginal_party_isClifford
    (hm2 : 2 ≤ m) (w : WeylConvention 𝔽)
    {C D : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C) (hD : IsMDSCode2m D)
    (U : GenericParty m → LocalMatrix 𝔽)
    (hU : ∀ i, IsUnitaryMatrix (U i))
    (phase : ℂ) (hphase : Complex.normSq phase = 1)
    (hstate :
      genericLocalAction U (genericEqualPhaseState C) =
        phase • genericEqualPhaseState D)
    {S : Finset (GenericParty m)} (hS : S.card = m + 1)
    (i : S) :
    IsCliffordMatrix w (U i.1) := by
  classical
  have hintertwine :=
    genericReindexedMarginalArray_intertwining
      (by omega : 0 < m) w hC hD U hU phase hphase hstate hS
  rw [genericReindexedMarginalArray_eq_diagonal,
    genericReindexedMarginalArray_eq_diagonal] at hintertwine
  have hcardS : 3 ≤ Fintype.card S := by
    rw [Fintype.card_coe, hS]
    omega
  have hq : (Fintype.card 𝔽 : ℂ) ≠ 0 := by
    exact_mod_cast Fintype.card_ne_zero
  have haxes :=
    familyFactor_coordinateAxes_of_diagonal_equivalent
      hcardS
      (fun j : S =>
        genericTransportedLocalConjugation
          (by omega : 0 < m) w hC hD hS j
            (U j.1) (hU j.1))
      (fun _ => inv_ne_zero (pow_ne_zero _ hq))
      (fun _ => inv_ne_zero (pow_ne_zero _ hq))
      hintertwine i
  apply isCliffordMatrix_of_weylCoordinate_axes w (U i.1) (hU i.1)
  intro v
  let LC :=
    genericShorteningLocalLabelEquiv
      (by omega : 0 < m) hC hS i.2
  let LD :=
    genericShorteningLocalLabelEquiv
      (by omega : 0 < m) hD hS i.2
  let t := LC.symm v
  have ht :
      relabelCoordinateEquiv LC (coordinateVector t 1) =
        coordinateVector v 1 := by
    simpa [t, LC] using
      relabelCoordinateEquiv_coordinateVector LC t 1
  have htransport := haxes t
  have htarget :
      relabelCoordinateEquiv LD
        (genericTransportedLocalConjugation
          (by omega : 0 < m) w hC hD hS i
            (U i.1) (hU i.1) (coordinateVector t 1)) =
      unitaryConjugationWeylEquiv w (U i.1) (hU i.1)
        (coordinateVector v 1) := by
    change
      relabelCoordinateEquiv LD
        ((relabelCoordinateEquiv LD).symm
          (unitaryConjugationWeylEquiv w (U i.1) (hU i.1)
            (relabelCoordinateEquiv LC
              (coordinateVector t 1)))) =
        unitaryConjugationWeylEquiv w (U i.1) (hU i.1)
          (coordinateVector v 1)
    rw [(relabelCoordinateEquiv LD).apply_symm_apply, ht]
  rw [← htarget]
  exact generic_relabelCoordinateEquiv_preserves_axis LD htransport

/-- Every party belongs to an `(m+1)`-set when `m ≥ 1`. -/
theorem exists_genericRetainedSet
    (hm : 1 ≤ m) (i : GenericParty m) :
    ∃ S : Finset (GenericParty m), S.card = m + 1 ∧ i ∈ S := by
  classical
  have hrest : m ≤ (Finset.univ.erase i).card := by
    simp [Fintype.card_fin]
    omega
  obtain ⟨T, hTsub, hTcard⟩ :=
    Finset.exists_subset_card_eq
      (s := Finset.univ.erase i) (n := m) hrest
  have hiT : i ∉ T := by
    intro hi
    have := hTsub hi
    simp at this
  refine ⟨insert i T, ?_, by simp⟩
  simp [hiT, hTcard]

/-- In a phase-normalized product action between generic equal-phase exact
MDS code states, every local unitary is Clifford. -/
theorem generic_all_isClifford_of_localAction_equalPhaseState
    (hm : 2 ≤ m) (w : WeylConvention 𝔽)
    {C D : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C) (hD : IsMDSCode2m D)
    (U : GenericParty m → LocalMatrix 𝔽)
    (hU : ∀ i, IsUnitaryMatrix (U i))
    (phase : ℂ) (hphase : Complex.normSq phase = 1)
    (hstate :
      genericLocalAction U (genericEqualPhaseState C) =
        phase • genericEqualPhaseState D) :
    ∀ i, IsCliffordMatrix w (U i) := by
  intro i
  obtain ⟨S, hS, hiS⟩ := exists_genericRetainedSet (by omega) i
  exact genericMarginal_party_isClifford
    hm w hC hD U hU phase hphase hstate hS ⟨i, hiS⟩

/-- In a phase-normalized product action from a party permutation of one
generic equal-phase exact MDS code state to another, every displayed local
unitary is Clifford. -/
theorem generic_all_isClifford_of_permutedLocalAction_equalPhaseState
    (hm : 2 ≤ m) (w : WeylConvention 𝔽)
    {C D : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C) (hD : IsMDSCode2m D)
    (π : Equiv.Perm (GenericParty m))
    (U : GenericParty m → LocalMatrix 𝔽)
    (hU : ∀ i, IsUnitaryMatrix (U i))
    (phase : ℂ) (hphase : Complex.normSq phase = 1)
    (hstate :
      genericLocalAction U
          (genericPermuteState π (genericEqualPhaseState C)) =
        phase • genericEqualPhaseState D) :
    ∀ i, IsCliffordMatrix w (U i) := by
  let Cπ := genericPermutedCode π C
  have hCπ : IsMDSCode2m Cπ :=
    isMDSCode2m_genericPermutedCode π hC
  have hstate' :
      genericLocalAction U (genericEqualPhaseState Cπ) =
        phase • genericEqualPhaseState D := by
    rw [← genericPermuteState_equalPhaseState π C]
    exact hstate
  exact generic_all_isClifford_of_localAction_equalPhaseState
    hm w hCπ hD U hU phase hphase hstate'

/-- Length-generic rigidity: for every finite field and every `m ≥ 2`,
local-unitary equivalence between equal-phase exact `[2m,m,m+1]` MDS code
states is local-Clifford equivalence, with the same permutation, local
matrices, and global phase. -/
theorem genericLocallyUnitaryEquivalent_equalPhaseState_implies_genericLocallyCliffordEquivalent
    (hm : 2 ≤ m) (w : WeylConvention 𝔽)
    {C D : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C) (hD : IsMDSCode2m D)
    (hLU :
      GenericLocallyUnitaryEquivalent
        (genericEqualPhaseState C) (genericEqualPhaseState D)) :
    GenericLocallyCliffordEquivalent w
      (genericEqualPhaseState C) (genericEqualPhaseState D) := by
  obtain ⟨π, U, phase, hU, hphase, hstate⟩ := hLU
  let Cπ := genericPermutedCode π C
  have hCπ : IsMDSCode2m Cπ :=
    isMDSCode2m_genericPermutedCode π hC
  have hstate' :
      genericLocalAction U (genericEqualPhaseState Cπ) =
        phase • genericEqualPhaseState D := by
    rw [← genericPermuteState_equalPhaseState π C]
    exact hstate
  have hcliff :=
    generic_all_isClifford_of_localAction_equalPhaseState
      hm w hCπ hD U hU phase hphase hstate'
  exact ⟨π, U, phase, hcliff, hphase, hstate⟩

/-- At `m=3`, the length-generic rigidity theorem gives the established
six-party `[6,3,4]` LU-to-LC statement. -/
theorem locallyUnitaryEquivalent_equalPhaseState_implies_locallyCliffordEquivalent_from_generic
    (w : WeylConvention 𝔽)
    {C D : Submodule 𝔽 (BasisLabel 𝔽)}
    (hC : IsMDSCode634 C) (hD : IsMDSCode634 D)
    (hLU :
      LocallyUnitaryEquivalent
        (equalPhaseState C) (equalPhaseState D)) :
    LocallyCliffordEquivalent w
      (equalPhaseState C) (equalPhaseState D) := by
  rw [← genericLocallyCliffordEquivalent_three,
    ← genericEqualPhaseState_three,
    ← genericEqualPhaseState_three]
  apply
    genericLocallyUnitaryEquivalent_equalPhaseState_implies_genericLocallyCliffordEquivalent
      (m := 3) (by omega) w
      ((isMDSCode2m_three_iff C).2 hC)
      ((isMDSCode2m_three_iff D).2 hD)
  rw [genericEqualPhaseState_three, genericEqualPhaseState_three,
    genericLocallyUnitaryEquivalent_three]
  exact hLU

/-- The admitted non-GRS pencil classification is compatible with the
length-generic rigidity terminal: under the existing prime-field geometric
inputs, LU equivalence is classified by `pencilZ`. -/
theorem locallyUnitaryEquivalent_admitted_nonGRS_pencil_iff_pencilZ_eq_from_generic
    (w : WeylConvention 𝔽) (inputs : PencilClassificationInputs 𝔽 w)
    {t u : 𝔽} (ht : IsAdmittedNonGRSParameter t)
    (hu : IsAdmittedNonGRSParameter u) :
    LocallyUnitaryEquivalent
        (equalPhaseState (arcKernel (nonGRSPencil t)))
        (equalPhaseState (arcKernel (nonGRSPencil u))) ↔
      pencilZ t = pencilZ u := by
  have hCt : IsMDSCode634 (arcKernel (nonGRSPencil t)) :=
    isMDSCode634_arcKernel (inputs.admitted_isSixArc t ht)
  have hCu : IsMDSCode634 (arcKernel (nonGRSPencil u)) :=
    isMDSCode634_arcKernel (inputs.admitted_isSixArc u hu)
  have hlc_iff :
      LocallyCliffordEquivalent w
          (equalPhaseState (arcKernel (nonGRSPencil t)))
          (equalPhaseState (arcKernel (nonGRSPencil u))) ↔
        pencilZ t = pencilZ u :=
    (admitted_nonGRS_pencil_classified_by_z w inputs ht hu).2.2
  constructor
  · intro hLU
    exact hlc_iff.mp
      (locallyUnitaryEquivalent_equalPhaseState_implies_locallyCliffordEquivalent_from_generic
        w hCt hCu hLU)
  · intro hz
    exact locallyCliffordEquivalent_implies_locallyUnitaryEquivalent w
      (hlc_iff.mpr hz)

end RelativeConicArcs.AMELU
