import Mathlib.LinearAlgebra.FiniteDimensional.Lemmas

/-!
# The dimension squeeze behind stabilizer-AME full-Weyl marginals

For a pure stabilizer state on `2m` parties, restriction of its label
Lagrangian to the complement of an `(m+1)`-party set has a kernel of
dimension at least one local Pauli-label space.  The AME condition makes
projection of that kernel to any retained party injective.  Rank-nullity
therefore forces the projection to be bijective.

The theorem below isolates this dimension squeeze.  It applies over the
prime field to arbitrary additive prime-power stabilizers and over the
alphabet field to field-linear stabilizers.  The physical application
takes:

* `E` to be the stabilizer-label space;
* `W` to be the Pauli labels on the omitted `m-1` parties;
* `V` to be the Pauli-label space of one retained party;
* `outside` to be restriction to the omitted parties; and
* `localProjection` to be projection of `ker outside` to the retained party.

The AME condition supplies injectivity of `localProjection`, because its kernel
would be a nonzero stabilizer supported on at most `m` parties.

This module is symbolic and kernel checked.  It contains no generated
data, native evaluation, axioms, or admitted declarations.
-/

namespace RelativeConicArcs.AMELU

variable {𝕜 E W V : Type*}
  [Field 𝕜]
  [AddCommGroup E] [Module 𝕜 E] [FiniteDimensional 𝕜 E]
  [AddCommGroup W] [Module 𝕜 W] [FiniteDimensional 𝕜 W]
  [AddCommGroup V] [Module 𝕜 V] [FiniteDimensional 𝕜 V]

/-- Restriction of a label subspace to a finite set of party coordinates. -/
def stabilizerCoordinateRestriction
    {ι P : Type*} [AddCommGroup P] [Module 𝕜 P]
    (L : Submodule 𝕜 (ι → P)) (S : Finset ι) :
    L →ₗ[𝕜] (S → P) :=
  LinearMap.funLeft 𝕜 P (fun i : S => (i : ι)) ∘ₗ L.subtype

/-- The kernel of coordinate restriction consists exactly of labels
vanishing on every selected outside coordinate. -/
theorem stabilizerCoordinateRestriction_eq_zero_iff
    {ι P : Type*} [AddCommGroup P] [Module 𝕜 P]
    (L : Submodule 𝕜 (ι → P)) (S : Finset ι) (x : L) :
    stabilizerCoordinateRestriction L S x = 0 ↔
      ∀ j, j ∈ S → x.1 j = 0 := by
  constructor
  · intro hx j hj
    have hcoord := congrFun hx ⟨j, hj⟩
    exact hcoord
  · intro hx
    ext j
    exact hx j j.2

/-- Projection of the kernel of an outside-coordinate restriction to one
retained local label space. -/
def stabilizerKernelLocalProjection
    {ι P : Type*} [AddCommGroup P] [Module 𝕜 P]
    (L : Submodule 𝕜 (ι → P)) (outside : Finset ι) (i : ι) :
    LinearMap.ker (stabilizerCoordinateRestriction L outside) →ₗ[𝕜] P where
  toFun x := x.1.1 i
  map_add' _ _ := rfl
  map_smul' _ _ := rfl

/-- No nonzero label in `L` is supported inside `S`.  For stabilizer labels,
maximal mixing on `S` supplies this condition. -/
def NoNonzeroLabelSupportedOn
    {ι P : Type*} [AddCommGroup P] [Module 𝕜 P]
    (L : Submodule 𝕜 (ι → P)) (S : Finset ι) : Prop :=
  ∀ x : L, (∀ j, j ∉ S → x.1 j = 0) → x = 0

/-- A numerical version of the AME support condition: every nonzero label
uses more than `maxSupport` party coordinates. -/
def NoNonzeroLabelOfSupportAtMost
    {ι P : Type*} [Fintype ι] [DecidableEq ι]
    [AddCommGroup P] [Module 𝕜 P] [DecidableEq P]
    (L : Submodule 𝕜 (ι → P)) (maxSupport : ℕ) : Prop :=
  ∀ x : L,
    (Finset.univ.filter fun j => x.1 j ≠ 0).card ≤ maxSupport →
      x = 0

/-- The numerical no-small-support condition excludes a nonzero label on
every party set of bounded cardinality. -/
theorem noNonzeroLabelSupportedOn_of_supportAtMost
    {ι P : Type*} [Fintype ι] [DecidableEq ι]
    [AddCommGroup P] [Module 𝕜 P] [DecidableEq P]
    (L : Submodule 𝕜 (ι → P)) {maxSupport : ℕ}
    (hsmall : NoNonzeroLabelOfSupportAtMost L maxSupport)
    {S : Finset ι} (hS : S.card ≤ maxSupport) :
    NoNonzeroLabelSupportedOn L S := by
  intro x hx
  apply hsmall x
  refine le_trans (Finset.card_le_card ?_) hS
  intro j hj
  have hjne : x.1 j ≠ 0 := (Finset.mem_filter.mp hj).2
  by_contra hjS
  exact hjne (hx j hjS)

/-- If a label vanishing on the outside coordinates and one retained
coordinate would be supported on an AME-forbidden party set, then projection
of the supported-label kernel to that retained coordinate is injective. -/
theorem stabilizerKernelLocalProjection_injective
    {ι P : Type*} [Fintype ι] [DecidableEq ι]
    [AddCommGroup P] [Module 𝕜 P]
    (L : Submodule 𝕜 (ι → P)) (outside : Finset ι) (i : ι)
    (hno :
      NoNonzeroLabelSupportedOn L
        (Finset.univ \ (outside ∪ {i}))) :
    Function.Injective
      (stabilizerKernelLocalProjection L outside i) := by
  intro x y hxy
  apply Subtype.ext
  apply sub_eq_zero.mp
  apply hno (x.1 - y.1)
  intro j hj
  have hjCovered : j ∈ outside ∨ j = i := by
    simp only [Finset.mem_sdiff, Finset.mem_univ, true_and,
      Finset.mem_union, Finset.mem_singleton] at hj
    exact Classical.byContradiction hj
  rcases hjCovered with hjOutside | rfl
  · have hxOutside :
        x.1.1 j = 0 := by
      have hx := congrFun x.2 ⟨j, hjOutside⟩
      exact hx
    have hyOutside :
        y.1.1 j = 0 := by
      have hy := congrFun y.2 ⟨j, hjOutside⟩
      exact hy
    exact sub_eq_zero.mpr (hxOutside.trans hyOutside.symm)
  · exact sub_eq_zero.mpr hxy

/-- The AME no-small-support condition implies injectivity of the supported
kernel at a retained coordinate whenever the possible residual support has
the forbidden size. -/
theorem stabilizerKernelLocalProjection_injective_of_supportAtMost
    {ι P : Type*} [Fintype ι] [DecidableEq ι]
    [AddCommGroup P] [Module 𝕜 P] [DecidableEq P]
    (L : Submodule 𝕜 (ι → P)) (outside : Finset ι) (i : ι)
    {maxSupport : ℕ}
    (hsmall : NoNonzeroLabelOfSupportAtMost L maxSupport)
    (hremaining :
      (Finset.univ \ (outside ∪ {i})).card ≤ maxSupport) :
    Function.Injective
      (stabilizerKernelLocalProjection L outside i) :=
  stabilizerKernelLocalProjection_injective L outside i
    (noNonzeroLabelSupportedOn_of_supportAtMost L hsmall hremaining)

/-- Injectivity says that every nonzero supported stabilizer label has a
nonidentity Weyl label at the retained coordinate. -/
theorem stabilizerKernelLocalProjection_ne_zero_of_ne_zero
    {ι P : Type*} [AddCommGroup P] [Module 𝕜 P]
    (L : Submodule 𝕜 (ι → P)) (outside : Finset ι) (i : ι)
    (hinjective :
      Function.Injective (stabilizerKernelLocalProjection L outside i))
    {x : LinearMap.ker (stabilizerCoordinateRestriction L outside)}
    (hx : x ≠ 0) :
    stabilizerKernelLocalProjection L outside i x ≠ 0 := by
  intro hxLocal
  apply hx
  apply hinjective
  simpa using hxLocal

/-- If the source dimension is the sum of the outside-label and one-site
label dimensions, injectivity of the one-site projection on the outside
kernel forces that projection to be bijective. -/
theorem stabilizerAME_kernelToLocal_bijective
    (outside : E →ₗ[𝕜] W)
    (localProjection : LinearMap.ker outside →ₗ[𝕜] V)
    (hfinrank :
      Module.finrank 𝕜 E =
        Module.finrank 𝕜 W + Module.finrank 𝕜 V)
    (hinjective : Function.Injective localProjection) :
    Function.Bijective localProjection := by
  have hrange_le :
      Module.finrank 𝕜 (LinearMap.range outside) ≤
        Module.finrank 𝕜 W :=
    Submodule.finrank_le _
  have hrank_nullity := LinearMap.finrank_range_add_finrank_ker outside
  have hlower :
      Module.finrank 𝕜 V ≤
        Module.finrank 𝕜 (LinearMap.ker outside) := by
    omega
  have hupper :
      Module.finrank 𝕜 (LinearMap.ker outside) ≤
        Module.finrank 𝕜 V :=
    LinearMap.finrank_le_finrank_of_injective hinjective
  have heq :
      Module.finrank 𝕜 (LinearMap.ker outside) =
        Module.finrank 𝕜 V :=
    Nat.le_antisymm hupper hlower
  refine ⟨hinjective, ?_⟩
  exact
    (LinearMap.injective_iff_surjective_of_finrank_eq_finrank heq).mp
      hinjective

/-- For an explicit finite party-coordinate label space, the AME
no-small-support condition and rank-nullity squeeze make every retained
local projection of the supported kernel bijective. -/
theorem stabilizerAME_kernelToLocal_bijective_of_supportAtMost
    {ι P : Type*} [Fintype ι] [DecidableEq ι]
    [AddCommGroup P] [Module 𝕜 P] [FiniteDimensional 𝕜 P] [DecidableEq P]
    (L : Submodule 𝕜 (ι → P)) (outside : Finset ι) (i : ι)
    {maxSupport : ℕ}
    (hfinrank :
      Module.finrank 𝕜 L =
        Module.finrank 𝕜 (outside → P) + Module.finrank 𝕜 P)
    (hsmall : NoNonzeroLabelOfSupportAtMost L maxSupport)
    (hremaining :
      (Finset.univ \ (outside ∪ {i})).card ≤ maxSupport) :
    Function.Bijective
      (stabilizerKernelLocalProjection L outside i) :=
  stabilizerAME_kernelToLocal_bijective
    (stabilizerCoordinateRestriction L outside)
    (stabilizerKernelLocalProjection L outside i)
    hfinrank
    (stabilizerKernelLocalProjection_injective_of_supportAtMost
      L outside i hsmall hremaining)

/-- In the `2m`-party AME configuration, omitting `m-1` parties and one
retained coordinate leaves exactly `m` possible support coordinates. -/
theorem stabilizerAME_remainingSupport_card
    {ι : Type*} [Fintype ι] [DecidableEq ι]
    (m : ℕ) (outside : Finset ι) (i : ι)
    (htotal : Fintype.card ι = 2 * m)
    (houtside : outside.card = m - 1)
    (hi : i ∉ outside) :
    (Finset.univ \ (outside ∪ {i})).card = m := by
  have hcardPos : 0 < Fintype.card ι :=
    Fintype.card_pos_iff.mpr ⟨i⟩
  have hm : 1 ≤ m := by omega
  have hcardUnion : (outside ∪ {i}).card = m := by
    rw [Finset.card_union_of_disjoint]
    · simp [houtside, hm]
    · simp [Finset.disjoint_singleton_right, hi]
  rw [Finset.card_sdiff,
    Finset.inter_eq_left.mpr (Finset.subset_univ _),
    Finset.card_univ, hcardUnion, htotal]
  omega

/-- Prime-field/additive stabilizer form of the support bridge for
`2m` parties: AME exclusion of labels on at most `m` parties makes the
supported-kernel projection bijective. -/
theorem stabilizerAME_halfParty_kernelToLocal_bijective
    {ι P : Type*} [Fintype ι] [DecidableEq ι]
    [AddCommGroup P] [Module 𝕜 P] [FiniteDimensional 𝕜 P] [DecidableEq P]
    (m : ℕ) (L : Submodule 𝕜 (ι → P))
    (outside : Finset ι) (i : ι)
    (htotal : Fintype.card ι = 2 * m)
    (houtside : outside.card = m - 1)
    (hi : i ∉ outside)
    (hfinrank :
      Module.finrank 𝕜 L =
        Module.finrank 𝕜 (outside → P) + Module.finrank 𝕜 P)
    (hAME : NoNonzeroLabelOfSupportAtMost L m) :
    Function.Bijective
      (stabilizerKernelLocalProjection L outside i) :=
  stabilizerAME_kernelToLocal_bijective_of_supportAtMost
    L outside i hfinrank hAME
      (le_of_eq (stabilizerAME_remainingSupport_card
        m outside i htotal houtside hi))

/-- The intrinsic prime-field dimension form.  A pure stabilizer label
Lagrangian on `2m` parties has `m` local label spaces of dimension; this
identity supplies the rank hypothesis in the preceding support theorem. -/
theorem stabilizerAME_halfParty_kernelToLocal_bijective_of_finrank
    {ι P : Type*} [Fintype ι] [DecidableEq ι]
    [AddCommGroup P] [Module 𝕜 P] [FiniteDimensional 𝕜 P] [DecidableEq P]
    (m : ℕ) (L : Submodule 𝕜 (ι → P))
    (outside : Finset ι) (i : ι)
    (htotal : Fintype.card ι = 2 * m)
    (houtside : outside.card = m - 1)
    (hi : i ∉ outside)
    (hLagrangianDimension :
      Module.finrank 𝕜 L = m * Module.finrank 𝕜 P)
    (hAME : NoNonzeroLabelOfSupportAtMost L m) :
    Function.Bijective
      (stabilizerKernelLocalProjection L outside i) := by
  have hcardPos : 0 < Fintype.card ι :=
    Fintype.card_pos_iff.mpr ⟨i⟩
  have hm : 1 ≤ m := by omega
  have houtsideFinrank :
      Module.finrank 𝕜 (outside → P) =
        outside.card * Module.finrank 𝕜 P := by
    rw [Module.finrank_pi_fintype]
    simp
  have hfinrank :
      Module.finrank 𝕜 L =
        Module.finrank 𝕜 (outside → P) + Module.finrank 𝕜 P := by
    rw [hLagrangianDimension, houtsideFinrank, houtside]
    calc
      m * Module.finrank 𝕜 P =
          ((m - 1) + 1) * Module.finrank 𝕜 P := by
            rw [Nat.sub_add_cancel hm]
      _ = (m - 1) * Module.finrank 𝕜 P +
          Module.finrank 𝕜 P := by
            rw [Nat.add_mul, one_mul]
  exact
    stabilizerAME_halfParty_kernelToLocal_bijective
      m L outside i htotal houtside hi hfinrank hAME

/-- A bijective supported-kernel projection realizes every local Weyl label
exactly once, which is the algebraic full-Weyl-axis premise for the marginal
diagonal-tensor argument. -/
theorem stabilizerKernelLocalProjection_existsUnique
    {ι P : Type*} [AddCommGroup P] [Module 𝕜 P]
    (L : Submodule 𝕜 (ι → P)) (outside : Finset ι) (i : ι)
    (hbijective :
      Function.Bijective (stabilizerKernelLocalProjection L outside i))
    (v : P) :
    ∃! x : LinearMap.ker (stabilizerCoordinateRestriction L outside),
      stabilizerKernelLocalProjection L outside i x = v := by
  obtain ⟨x, hx⟩ := hbijective.2 v
  exact ⟨x, hx, fun y hy => hbijective.1 (hy.trans hx.symm)⟩

/-- An abstract family of label subspaces supported on finite party sets.
The AME profile has dimension `localFinrank * (|S| - m)`, is monotone in
the support, and turns intersections of support sets into intersections of
label subspaces. -/
structure AMESupportedSubspaceProfile
    {ι E : Type*} [DecidableEq ι] [AddCommGroup E] [Module 𝕜 E]
    (m localFinrank : ℕ) where
  space : Finset ι → Submodule 𝕜 E
  monotone :
    ∀ {S T : Finset ι}, S ⊆ T → space S ≤ space T
  inf_eq :
    ∀ S T : Finset ι, space S ⊓ space T = space (S ∩ T)
  finrank_eq :
    ∀ S : Finset ι,
      Module.finrank 𝕜 (space S) =
        localFinrank * (S.card - m)

/-- Two distinct codimension-one supported subspaces generate the supported
subspace on `A` once `A` has at least `m+2` parties. -/
theorem AMESupportedSubspaceProfile.erase_sup_erase_eq
    {ι E : Type*} [DecidableEq ι]
    [AddCommGroup E] [Module 𝕜 E] [FiniteDimensional 𝕜 E]
    {m localFinrank : ℕ}
    (profile : AMESupportedSubspaceProfile
      (𝕜 := 𝕜) (ι := ι) (E := E) m localFinrank)
    (A : Finset ι) {i j : ι}
    (hi : i ∈ A) (hj : j ∈ A) (hij : i ≠ j)
    (hcard : m + 2 ≤ A.card) :
    profile.space (A.erase i) ⊔ profile.space (A.erase j) =
      profile.space A := by
  apply Submodule.eq_of_le_of_finrank_eq
  · exact sup_le
      (profile.monotone (Finset.erase_subset i A))
      (profile.monotone (Finset.erase_subset j A))
  · have hinter :
        (A.erase i) ∩ (A.erase j) = (A.erase i).erase j := by
      ext k
      simp only [Finset.mem_inter, Finset.mem_erase]
      constructor
      · rintro ⟨⟨hki, hkA⟩, hkj, _⟩
        exact ⟨hkj, hki, hkA⟩
      · rintro ⟨hkj, hki, hkA⟩
        exact ⟨⟨hki, hkA⟩, hkj, hkA⟩
    have hjErase : j ∈ A.erase i :=
      Finset.mem_erase.mpr ⟨Ne.symm hij, hj⟩
    have hsum :=
      Submodule.finrank_sup_add_finrank_inf_eq
        (profile.space (A.erase i)) (profile.space (A.erase j))
    rw [profile.inf_eq, hinter, profile.finrank_eq,
      profile.finrank_eq, profile.finrank_eq,
      Finset.card_erase_of_mem hi, Finset.card_erase_of_mem hj,
      Finset.card_erase_of_mem hjErase,
      Finset.card_erase_of_mem hi] at hsum
    rw [profile.finrank_eq]
    have hdim0 :
        A.card - m = (A.card - (m + 2)) + 2 := by
      omega
    have hdim1 :
        A.card - 1 - m = (A.card - (m + 2)) + 1 := by
      omega
    have hdim2 :
        A.card - 1 - 1 - m = A.card - (m + 2) := by
      omega
    rw [hdim1, hdim2] at hsum
    rw [hdim0]
    simp only [Nat.mul_add, Nat.mul_one] at hsum ⊢
    omega

/-- Span of all minimum-size supported label subspaces contained in `A`. -/
def AMESupportedSubspaceProfile.minimumSupportSpan
    {ι E : Type*} [DecidableEq ι]
    [AddCommGroup E] [Module 𝕜 E]
    {m localFinrank : ℕ}
    (profile : AMESupportedSubspaceProfile
      (𝕜 := 𝕜) (ι := ι) (E := E) m localFinrank)
    (A : Finset ι) : Submodule 𝕜 E :=
  ⨆ (B : Finset ι) (_ : B ⊆ A) (_ : B.card = m + 1),
    profile.space B

/-- Minimum-support spans grow when the allowed party set grows. -/
theorem AMESupportedSubspaceProfile.minimumSupportSpan_mono
    {ι E : Type*} [DecidableEq ι]
    [AddCommGroup E] [Module 𝕜 E]
    {m localFinrank : ℕ}
    (profile : AMESupportedSubspaceProfile
      (𝕜 := 𝕜) (ι := ι) (E := E) m localFinrank)
    {A B : Finset ι} (hAB : A ⊆ B) :
    profile.minimumSupportSpan A ≤
      profile.minimumSupportSpan B := by
  refine iSup_le fun S => iSup_le fun hSA => iSup_le fun hcard => ?_
  exact le_iSup_of_le S <|
    le_iSup_of_le (hSA.trans hAB) <|
      le_iSup_of_le hcard le_rfl

/-- Every minimum-support span inside `A` lies in the full supported
subspace on `A`. -/
theorem AMESupportedSubspaceProfile.minimumSupportSpan_le_space
    {ι E : Type*} [DecidableEq ι]
    [AddCommGroup E] [Module 𝕜 E]
    {m localFinrank : ℕ}
    (profile : AMESupportedSubspaceProfile
      (𝕜 := 𝕜) (ι := ι) (E := E) m localFinrank)
    (A : Finset ι) :
    profile.minimumSupportSpan A ≤ profile.space A := by
  refine iSup_le fun S => iSup_le fun hSA => iSup_le fun _ => ?_
  exact profile.monotone hSA

/-- The AME support-dimension profile is generated by its subspaces on
`m+1` parties.  The proof repeatedly splits a larger support into the sum
of two distinct one-coordinate erasures. -/
theorem AMESupportedSubspaceProfile.space_eq_minimumSupportSpan
    {ι E : Type*} [DecidableEq ι]
    [AddCommGroup E] [Module 𝕜 E] [FiniteDimensional 𝕜 E]
    {m localFinrank : ℕ}
    (profile : AMESupportedSubspaceProfile
      (𝕜 := 𝕜) (ι := ι) (E := E) m localFinrank)
    (A : Finset ι) :
    profile.space A = profile.minimumSupportSpan A := by
  apply le_antisymm
  · induction A using Finset.strongInductionOn with
    | _ A ih =>
      by_cases hsmall : A.card ≤ m
      · have hzero :
            Module.finrank 𝕜 (profile.space A) = 0 := by
          rw [profile.finrank_eq]
          simp [Nat.sub_eq_zero_of_le hsmall]
        rw [Submodule.finrank_eq_zero.mp hzero]
        exact bot_le
      by_cases hminimum : A.card = m + 1
      · exact le_iSup_of_le A <|
          le_iSup_of_le (show A ⊆ A from Finset.Subset.rfl) <|
            le_iSup_of_le hminimum le_rfl
      · have hcard : m + 2 ≤ A.card := by omega
        have hpos : 0 < A.card := by omega
        obtain ⟨i, hi⟩ := Finset.card_pos.mp hpos
        have hErasePos : 0 < (A.erase i).card := by
          rw [Finset.card_erase_of_mem hi]
          omega
        obtain ⟨j, hjErase⟩ := Finset.card_pos.mp hErasePos
        have hjData := Finset.mem_erase.mp hjErase
        have hij : i ≠ j := Ne.symm hjData.1
        rw [← profile.erase_sup_erase_eq
          A hi hjData.2 hij hcard]
        exact sup_le
          ((ih (A.erase i) (Finset.erase_ssubset hi)).trans
            (profile.minimumSupportSpan_mono
              (Finset.erase_subset i A)))
          ((ih (A.erase j) (Finset.erase_ssubset hjData.2)).trans
            (profile.minimumSupportSpan_mono
              (Finset.erase_subset j A)))
  · exact profile.minimumSupportSpan_le_space A

/-- If the support on all parties is the full label space, then the
`m+1`-party supported subspaces span the full label space. -/
theorem AMESupportedSubspaceProfile.minimumSupportSpan_univ_eq_top
    {ι E : Type*} [Fintype ι] [DecidableEq ι]
    [AddCommGroup E] [Module 𝕜 E] [FiniteDimensional 𝕜 E]
    {m localFinrank : ℕ}
    (profile : AMESupportedSubspaceProfile
      (𝕜 := 𝕜) (ι := ι) (E := E) m localFinrank)
    (hfull : profile.space Finset.univ = ⊤) :
    profile.minimumSupportSpan Finset.univ = ⊤ := by
  rw [← profile.space_eq_minimumSupportSpan Finset.univ, hfull]

/-- Under the same hypotheses, the supported stabilizer-label kernel has
exactly one local Pauli-label space of dimension. -/
theorem stabilizerAME_finrank_ker_eq_local
    (outside : E →ₗ[𝕜] W)
    (localProjection : LinearMap.ker outside →ₗ[𝕜] V)
    (hfinrank :
      Module.finrank 𝕜 E =
        Module.finrank 𝕜 W + Module.finrank 𝕜 V)
    (hinjective : Function.Injective localProjection) :
    Module.finrank 𝕜 (LinearMap.ker outside) =
      Module.finrank 𝕜 V := by
  have hbij :=
    stabilizerAME_kernelToLocal_bijective
      outside localProjection hfinrank hinjective
  exact
    LinearEquiv.finrank_eq
      (LinearEquiv.ofBijective localProjection hbij)

end RelativeConicArcs.AMELU
