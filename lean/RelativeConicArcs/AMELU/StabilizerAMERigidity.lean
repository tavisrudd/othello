import RelativeConicArcs.AMELU.StabilizerAMESupport
import RelativeConicArcs.AMELU.GenericLURigidity

/-!
# Local-unitary rigidity from additive stabilizer AME data

This module connects the abstract support theorem for additive stabilizer
labels to the full-Weyl diagonal-tensor argument.  Labels are linear over a
field `𝕜`, while the physical one-party basis is indexed by a finite field
`𝔽`; taking `𝕜` to be the prime field of `𝔽` covers arbitrary additive
prime-power stabilizers.

`AdditiveStabilizerProjector` records the two algebraic facts about a pure
stabilizer AME state used here: its label space has half the ambient label
dimension, and it has no nonzero label on at most half the parties.  Its lift
coefficient permits arbitrary nonzero stabilizer phases.

`AdditiveStabilizerState` adds the physical state and one explicit realization
hypothesis.  That hypothesis says that partial trace of the stabilizer
projector has the stated product-Weyl coefficients.  This is the only
physics-facing assumption in the module.  The support squeeze, unique local
label projections, full-Weyl diagonality, marginal covariance, and
local-unitary-to-local-Clifford conclusion are kernel checked from it.
The supported kernels also define linear minimum-support operator-pushing
transitions.  Their local-frame equivalence relation is proved reflexive,
symmetric, and transitive here; the group-valued holonomy reduction is in
`HolonomyCentralizer`.

The module contains no generated data, native evaluation, axioms, or admitted
declarations.
-/

namespace RelativeConicArcs.AMELU

open Finset

variable {m : ℕ} {𝕜 𝔽 : Type*}
  [Field 𝕜] [Field 𝔽] [Algebra 𝕜 𝔽]
  [FiniteDimensional 𝕜 𝔽]
  [Fintype 𝔽] [DecidableEq 𝔽]

/-- Zero extension of local Pauli labels from a retained set of generic
parties. -/
def genericExtendAdditivePauliLabel
    (S : Finset (GenericParty m)) (v : S → 𝔽 × 𝔽) :
    GenericParty m → 𝔽 × 𝔽 :=
  fun i => if hi : i ∈ S then v ⟨i, hi⟩ else 0

/-- Algebraic projector data used by the rigidity proof for an additive
stabilizer AME state on `2m` parties.

The dimension field is the pure-state stabilizer assumption.  Isotropy and
the multiplication law of chosen Pauli lifts are not fields because the
rigidity argument uses them only through the projector expansion supplied by
`AdditiveStabilizerState`. -/
structure AdditiveStabilizerProjector (m : ℕ) (𝕜 𝔽 : Type*)
    [Field 𝕜] [Field 𝔽] [Algebra 𝕜 𝔽]
    [FiniteDimensional 𝕜 𝔽] [DecidableEq 𝔽] where
  /-- Additive projective Pauli-label space. -/
  labelSpace : Submodule 𝕜 (GenericParty m → 𝔽 × 𝔽)
  /-- Coefficient of the chosen stabilizer lift of each projective label. -/
  liftCoefficient : labelSpace → ℂ
  /-- Every stabilizer lift has a nonzero coefficient. -/
  liftCoefficient_ne_zero : ∀ x, liftCoefficient x ≠ 0
  /-- A pure stabilizer on `2m` parties has `m` local label spaces of
  dimension. -/
  labelSpace_finrank :
    Module.finrank 𝕜 labelSpace =
      m * Module.finrank 𝕜 (𝔽 × 𝔽)
  /-- Purity and AME determine the dimension of the label subgroup supported
  on every party set. -/
  supportedKernel_finrank :
    ∀ S : Finset (GenericParty m),
      Module.finrank 𝕜
          (LinearMap.ker
            (stabilizerCoordinateRestriction labelSpace
              (Finset.univ \ S))) =
        Module.finrank 𝕜 (𝔽 × 𝔽) * (S.card - m)
  /-- AME excludes every nonidentity stabilizer supported on at most `m`
  parties. -/
  noSmallSupport : NoNonzeroLabelOfSupportAtMost labelSpace m

namespace AdditiveStabilizerProjector

variable (P : AdditiveStabilizerProjector m 𝕜 𝔽)

/-- Labels supported on `S`, represented as the kernel of restriction to its
complement. -/
abbrev supportedKernel (S : Finset (GenericParty m)) :=
  LinearMap.ker
    (stabilizerCoordinateRestriction P.labelSpace (Finset.univ \ S))

/-- The actual supported-label kernels form the abstract AME support profile
used by minimum-support generation. -/
def supportedSubspaceProfile :
    AMESupportedSubspaceProfile
      (𝕜 := 𝕜) (ι := GenericParty m) (E := P.labelSpace)
      m (Module.finrank 𝕜 (𝔽 × 𝔽)) where
  space := P.supportedKernel
  monotone := by
    intro S T hST x hx
    apply (stabilizerCoordinateRestriction_eq_zero_iff
      P.labelSpace (Finset.univ \ T) x).2
    intro j hj
    have hjT : j ∉ T := (Finset.mem_sdiff.mp hj).2
    have hjS : j ∉ S := fun h => hjT (hST h)
    exact
      (stabilizerCoordinateRestriction_eq_zero_iff
        P.labelSpace (Finset.univ \ S) x).1 hx j (by simp [hjS])
  inf_eq := by
    intro S T
    ext x
    constructor
    · intro hx
      apply (stabilizerCoordinateRestriction_eq_zero_iff
        P.labelSpace (Finset.univ \ (S ∩ T)) x).2
      intro j hj
      have hjNotInter : j ∉ S ∩ T := (Finset.mem_sdiff.mp hj).2
      by_cases hjS : j ∈ S
      · have hjT : j ∉ T := by
          intro hjT
          exact hjNotInter (Finset.mem_inter.mpr ⟨hjS, hjT⟩)
        exact
          (stabilizerCoordinateRestriction_eq_zero_iff
            P.labelSpace (Finset.univ \ T) x).1 hx.2 j (by simp [hjT])
      · exact
          (stabilizerCoordinateRestriction_eq_zero_iff
            P.labelSpace (Finset.univ \ S) x).1 hx.1 j (by simp [hjS])
    · intro hx
      constructor
      · apply (stabilizerCoordinateRestriction_eq_zero_iff
          P.labelSpace (Finset.univ \ S) x).2
        intro j hj
        have hjS : j ∉ S := (Finset.mem_sdiff.mp hj).2
        exact
          (stabilizerCoordinateRestriction_eq_zero_iff
            P.labelSpace (Finset.univ \ (S ∩ T)) x).1 hx j
              (by simp [hjS])
      · apply (stabilizerCoordinateRestriction_eq_zero_iff
          P.labelSpace (Finset.univ \ T) x).2
        intro j hj
        have hjT : j ∉ T := (Finset.mem_sdiff.mp hj).2
        exact
          (stabilizerCoordinateRestriction_eq_zero_iff
            P.labelSpace (Finset.univ \ (S ∩ T)) x).1 hx j
              (by simp [hjT])
  finrank_eq := P.supportedKernel_finrank

omit [Fintype 𝔽] in
/-- Minimum-support supported stabilizer subspaces generate the whole
projective label space. -/
theorem minimumSupportSpan_univ_eq_top :
    P.supportedSubspaceProfile.minimumSupportSpan Finset.univ = ⊤ := by
  apply
    P.supportedSubspaceProfile.minimumSupportSpan_univ_eq_top
  apply le_antisymm le_top
  intro x _
  apply (stabilizerCoordinateRestriction_eq_zero_iff
    P.labelSpace (Finset.univ \ Finset.univ) x).2
  simp

/-- Projection of an `S`-supported label to one retained party. -/
def supportedLocalProjection
    (S : Finset (GenericParty m)) (i : S) :
    P.supportedKernel S →ₗ[𝕜] 𝔽 × 𝔽 :=
  stabilizerKernelLocalProjection P.labelSpace (Finset.univ \ S) i.1

omit [Fintype 𝔽] in
/-- On an `(m+1)`-party support, every retained local projection is
bijective onto the complete local Pauli-label space. -/
theorem supportedLocalProjection_bijective
    (S : Finset (GenericParty m)) (hS : S.card = m + 1) (i : S) :
    Function.Bijective (P.supportedLocalProjection S i) := by
  classical
  apply stabilizerAME_halfParty_kernelToLocal_bijective_of_finrank
    m P.labelSpace (Finset.univ \ S) i.1
  · simp [GenericParty]
  · rw [Finset.card_sdiff
      , Finset.inter_eq_left.mpr (Finset.subset_univ S),
      Finset.card_univ, hS]
    simp [GenericParty]
    omega
  · simp [i.2]
  · exact P.labelSpace_finrank
  · exact P.noSmallSupport

/-- The supported-label kernel is linearly equivalent to the complete local
Pauli-label space at every retained party. -/
noncomputable def supportedLocalLinearEquiv
    (S : Finset (GenericParty m)) (hS : S.card = m + 1) (i : S) :
    P.supportedKernel S ≃ₗ[𝕜] 𝔽 × 𝔽 :=
  LinearEquiv.ofBijective (P.supportedLocalProjection S i)
    (P.supportedLocalProjection_bijective S hS i)

/-- Linear operator-pushing transport between two local label frames on one
minimum support. -/
noncomputable def minimumSupportTransition
    (S : Finset (GenericParty m)) (hS : S.card = m + 1)
    (i j : S) : (𝔽 × 𝔽) ≃ₗ[𝕜] (𝔽 × 𝔽) :=
  (P.supportedLocalLinearEquiv S hS i).symm.trans
    (P.supportedLocalLinearEquiv S hS j)

/-- A minimum-support transition sends the label at one retained party to
the label at another party of the same supported stabilizer. -/
theorem minimumSupportTransition_apply_supportedLabel
    (S : Finset (GenericParty m)) (hS : S.card = m + 1)
    (i j : S) (x : P.supportedKernel S) :
    P.minimumSupportTransition S hS i j
        (P.supportedLocalProjection S i x) =
      P.supportedLocalProjection S j x := by
  simp [minimumSupportTransition, supportedLocalLinearEquiv]

/-- Local linear frame changes intertwine the complete minimum-support
operator-pushing atlases of two additive stabilizer AME projectors. -/
def MinimumSupportAtlasEquivalent
    (P Q : AdditiveStabilizerProjector m 𝕜 𝔽)
    (F : ∀ _ : GenericParty m, (𝔽 × 𝔽) ≃ₗ[𝕜] (𝔽 × 𝔽)) : Prop :=
  ∀ (S : Finset (GenericParty m)) (hS : S.card = m + 1)
    (i j : S) (v : 𝔽 × 𝔽),
    F j.1 (P.minimumSupportTransition S hS i j v) =
      Q.minimumSupportTransition S hS i j (F i.1 v)

/-- The identity local frames identify a minimum-support atlas with itself. -/
theorem minimumSupportAtlasEquivalent_refl :
    MinimumSupportAtlasEquivalent P P
      (fun _ => LinearEquiv.refl 𝕜 (𝔽 × 𝔽)) := by
  intro S hS i j v
  rfl

/-- Minimum-support atlas equivalences compose party by party. -/
theorem MinimumSupportAtlasEquivalent.trans
    {P Q R : AdditiveStabilizerProjector m 𝕜 𝔽}
    {F G : ∀ _ : GenericParty m, (𝔽 × 𝔽) ≃ₗ[𝕜] (𝔽 × 𝔽)}
    (hF : MinimumSupportAtlasEquivalent P Q F)
    (hG : MinimumSupportAtlasEquivalent Q R G) :
    MinimumSupportAtlasEquivalent P R
      (fun i => (F i).trans (G i)) := by
  intro S hS i j v
  change
    G j.1 (F j.1 (P.minimumSupportTransition S hS i j v)) =
      R.minimumSupportTransition S hS i j (G i.1 (F i.1 v))
  rw [hF S hS i j v, hG S hS i j (F i.1 v)]

/-- A minimum-support atlas equivalence is symmetric by inverting every
local frame change. -/
theorem MinimumSupportAtlasEquivalent.symm
    {P Q : AdditiveStabilizerProjector m 𝕜 𝔽}
    {F : ∀ _ : GenericParty m, (𝔽 × 𝔽) ≃ₗ[𝕜] (𝔽 × 𝔽)}
    (hF : MinimumSupportAtlasEquivalent P Q F) :
    MinimumSupportAtlasEquivalent Q P (fun i => (F i).symm) := by
  intro S hS i j v
  apply (F j.1).injective
  simp only [LinearEquiv.apply_symm_apply]
  rw [hF S hS i j ((F i.1).symm v)]
  simp

/-- The supported label is uniquely determined by its label at one retained
party. -/
noncomputable def supportedLocalEquiv
    (S : Finset (GenericParty m)) (hS : S.card = m + 1) (i : S) :
    P.supportedKernel S ≃ 𝔽 × 𝔽 :=
  Equiv.ofBijective (P.supportedLocalProjection S i)
    (P.supportedLocalProjection_bijective S hS i)

/-- The local-label transport from a chosen base party to another retained
party is a permutation of the complete local Pauli-label set. -/
noncomputable def transportedLocalLabelEquiv
    (S : Finset (GenericParty m)) (hS : S.card = m + 1)
    (base i : S) : Equiv.Perm (𝔽 × 𝔽) :=
  (P.supportedLocalEquiv S hS base).symm.trans
    (P.supportedLocalEquiv S hS i)

/-- Reindex the local label at party `i` by the label at a chosen base party
of the same support. -/
noncomputable def transportedLocalLabel
    (S : Finset (GenericParty m)) (hS : S.card = m + 1)
    (base i : S) (v : 𝔽 × 𝔽) : 𝔽 × 𝔽 :=
  P.transportedLocalLabelEquiv S hS base i v

/-- The label tuple obtained by transporting a common base label to all
retained parties. -/
noncomputable def reindexedMarginalLabels
    (S : Finset (GenericParty m)) (hS : S.card = m + 1)
    (base : S) (x : S → 𝔽 × 𝔽) : S → 𝔽 × 𝔽 :=
  fun i => P.transportedLocalLabel S hS base i (x i)

/-- Unnormalized product-Weyl coefficient of the stabilizer projector
expansion.  It vanishes off the projective label space and otherwise records
the arbitrary nonzero coefficient of the chosen stabilizer lift. -/
noncomputable def projectorLiftWeylCoefficient
    (v : GenericParty m → 𝔽 × 𝔽) : ℂ :=
  by
    classical
    exact if h : v ∈ P.labelSpace then P.liftCoefficient ⟨v, h⟩ else 0

/-- Product-Weyl coefficient obtained by tracing out the complement of `S`.
Weyl orthogonality retains only zero labels on traced parties, while the
normalization becomes `q⁻|S|`. -/
noncomputable def marginalWeylCoefficient
    (S : Finset (GenericParty m)) (v : S → 𝔽 × 𝔽) : ℂ :=
  ((Fintype.card 𝔽 : ℂ) ^ S.card)⁻¹ *
    projectorLiftWeylCoefficient (P := P)
      (genericExtendAdditivePauliLabel S v)

/-- A supported label survives projector partial trace with its arbitrary
nonzero lift coefficient. -/
theorem marginalWeylCoefficient_eq_of_mem
    (S : Finset (GenericParty m)) (v : S → 𝔽 × 𝔽)
    (h : genericExtendAdditivePauliLabel S v ∈ P.labelSpace) :
    marginalWeylCoefficient (P := P) S v =
      ((Fintype.card 𝔽 : ℂ) ^ S.card)⁻¹ *
        P.liftCoefficient
          ⟨genericExtendAdditivePauliLabel S v, h⟩ := by
  classical
  simp [marginalWeylCoefficient, projectorLiftWeylCoefficient, h]

/-- A local Weyl label whose zero extension is not a stabilizer label has
zero coefficient after projector partial trace. -/
theorem marginalWeylCoefficient_eq_zero_of_not_mem
    (S : Finset (GenericParty m)) (v : S → 𝔽 × 𝔽)
    (h : genericExtendAdditivePauliLabel S v ∉ P.labelSpace) :
    marginalWeylCoefficient (P := P) S v = 0 := by
  classical
  simp [marginalWeylCoefficient, projectorLiftWeylCoefficient, h]

omit [Fintype 𝔽] in
/-- Reindexed retained labels are the restriction of one supported
stabilizer label exactly when all common-frame labels agree. -/
theorem reindexedMarginalLabels_mem_iff
    (S : Finset (GenericParty m)) (hS : S.card = m + 1)
    (base : S) (x : S → 𝔽 × 𝔽) :
    genericExtendAdditivePauliLabel S
        (P.reindexedMarginalLabels S hS base x) ∈ P.labelSpace ↔
      ∃ v : 𝔽 × 𝔽, ∀ i, x i = v := by
  classical
  constructor
  · intro hmem
    let y : P.supportedKernel S :=
      ⟨⟨genericExtendAdditivePauliLabel S
          (P.reindexedMarginalLabels S hS base x), hmem⟩, by
        apply (stabilizerCoordinateRestriction_eq_zero_iff
          P.labelSpace (Finset.univ \ S) _).2
        intro j hj
        have hjS : j ∉ S := (Finset.mem_sdiff.mp hj).2
        simp [genericExtendAdditivePauliLabel, hjS]⟩
    refine ⟨P.supportedLocalEquiv S hS base y, ?_⟩
    intro i
    have hproj :
        P.supportedLocalEquiv S hS i
            ((P.supportedLocalEquiv S hS base).symm (x i)) =
          P.supportedLocalEquiv S hS i y := by
      change
        P.reindexedMarginalLabels S hS base x i =
          y.1.1 i.1
      simp [y, genericExtendAdditivePauliLabel, i.2]
    have hy :
        (P.supportedLocalEquiv S hS base).symm (x i) = y :=
      (P.supportedLocalEquiv S hS i).injective hproj
    apply (P.supportedLocalEquiv S hS base).symm.injective
    simpa using hy
  · rintro ⟨v, hv⟩
    let y : P.supportedKernel S :=
      (P.supportedLocalEquiv S hS base).symm v
    have heq :
        genericExtendAdditivePauliLabel S
            (P.reindexedMarginalLabels S hS base x) =
          y.1.1 := by
      funext j
      by_cases hj : j ∈ S
      · let i : S := ⟨j, hj⟩
        simp only [genericExtendAdditivePauliLabel, dif_pos hj,
          reindexedMarginalLabels, transportedLocalLabel]
        change
          P.transportedLocalLabelEquiv S hS base i (x i) =
            y.1.1 j
        rw [hv i]
        change
          P.supportedLocalEquiv S hS i
              ((P.supportedLocalEquiv S hS base).symm v) =
            y.1.1 j
        rfl
      · have hjOutside : j ∈ Finset.univ \ S := by simp [hj]
        have hyzero :=
          (stabilizerCoordinateRestriction_eq_zero_iff
            P.labelSpace (Finset.univ \ S) y.1).1 y.2 j hjOutside
        simp [genericExtendAdditivePauliLabel, hj, hyzero]
    rw [heq]
    exact y.1.2

/-- Common-frame diagonal coefficient contributed by the unique supported
stabilizer lift with prescribed base-party label. -/
noncomputable def reindexedDiagonalCoefficient
    (S : Finset (GenericParty m)) (hS : S.card = m + 1)
    (base : S) (v : 𝔽 × 𝔽) : ℂ :=
  ((Fintype.card 𝔽 : ℂ) ^ S.card)⁻¹ *
    P.liftCoefficient
      ((P.supportedLocalEquiv S hS base).symm v).1

/-- Every common-frame diagonal coefficient is nonzero. -/
theorem reindexedDiagonalCoefficient_ne_zero
    (S : Finset (GenericParty m)) (hS : S.card = m + 1)
    (base : S) (v : 𝔽 × 𝔽) :
    P.reindexedDiagonalCoefficient S hS base v ≠ 0 := by
  apply mul_ne_zero
  · apply inv_ne_zero
    apply pow_ne_zero
    exact_mod_cast Fintype.card_ne_zero
  · exact P.liftCoefficient_ne_zero _

/-- The stabilizer-projector marginal after transport to one common local
Pauli frame. -/
noncomputable def reindexedMarginalArray
    (S : Finset (GenericParty m)) (hS : S.card = m + 1)
    (base : S) : FamilyArray S (𝔽 × 𝔽) :=
  fun x =>
    P.marginalWeylCoefficient S
      (P.reindexedMarginalLabels S hS base x)

/-- The complete reindexed stabilizer marginal is diagonal on all local
Weyl labels, with arbitrary nonzero lift coefficients. -/
theorem reindexedMarginalArray_eq_diagonal
    (S : Finset (GenericParty m)) (hS : S.card = m + 1)
    (base : S) :
    P.reindexedMarginalArray S hS base =
      diagonalFamilyArray
        (P.reindexedDiagonalCoefficient S hS base) := by
  classical
  funext x
  unfold reindexedMarginalArray marginalWeylCoefficient
  unfold projectorLiftWeylCoefficient
  by_cases hdiag : ∃ v : 𝔽 × 𝔽, ∀ i, x i = v
  · obtain ⟨v, hv⟩ := hdiag
    have hx : x = fun _ => v := funext hv
    subst x
    have hmem :=
      (P.reindexedMarginalLabels_mem_iff S hS base
        (fun _ => v)).2 ⟨v, fun _ => rfl⟩
    rw [dif_pos hmem]
    have hlabel :
        (⟨genericExtendAdditivePauliLabel S
            (P.reindexedMarginalLabels S hS base (fun _ => v)),
          hmem⟩ : P.labelSpace) =
          ((P.supportedLocalEquiv S hS base).symm v).1 := by
      apply Subtype.ext
      funext j
      by_cases hj : j ∈ S
      · let i : S := ⟨j, hj⟩
        simp only [genericExtendAdditivePauliLabel, dif_pos hj,
          reindexedMarginalLabels, transportedLocalLabel]
        change
          P.transportedLocalLabelEquiv S hS base i v =
            ((P.supportedLocalEquiv S hS base).symm v).1.1 j
        rfl
      · have hjOutside : j ∈ Finset.univ \ S := by simp [hj]
        have hyzero :=
          (stabilizerCoordinateRestriction_eq_zero_iff
            P.labelSpace (Finset.univ \ S)
              ((P.supportedLocalEquiv S hS base).symm v).1).1
            ((P.supportedLocalEquiv S hS base).symm v).2
            j hjOutside
        simp [genericExtendAdditivePauliLabel, hj, hyzero]
    rw [hlabel]
    unfold diagonalFamilyArray reindexedDiagonalCoefficient
    rw [Fintype.sum_eq_single v]
    · simp [coordinateVector]
    · intro u huv
      have hfun : (fun _ : S => v) ≠ fun _ => u := by
        intro h
        have hi := congrFun h base
        exact huv hi.symm
      simp [coordinateVector, hfun]
  · have hmem :
      ¬ genericExtendAdditivePauliLabel S
          (P.reindexedMarginalLabels S hS base x) ∈ P.labelSpace :=
        fun h => hdiag
          ((P.reindexedMarginalLabels_mem_iff S hS base x).1 h)
    rw [dif_neg hmem]
    simp only [mul_zero]
    unfold diagonalFamilyArray
    symm
    apply Finset.sum_eq_zero
    intro v _
    have hfun : (fun _ : S => v) ≠ x := by
      intro h
      exact hdiag ⟨v, fun i => congrFun h.symm i⟩
    simp [coordinateVector, Ne.symm hfun]

end AdditiveStabilizerProjector

/-- A physical state realizing additive stabilizer projector data.

`marginalWeylExpansion` is the explicit trust boundary: it identifies the
Weyl coordinates computed from the physical reduced density matrix with the
partial trace of the stabilizer projector. -/
structure AdditiveStabilizerState (m : ℕ) (𝕜 𝔽 : Type*)
    [Field 𝕜] [Field 𝔽] [Algebra 𝕜 𝔽]
    [FiniteDimensional 𝕜 𝔽] [Fintype 𝔽] [DecidableEq 𝔽]
    (w : WeylConvention 𝔽) where
  /-- Algebraic stabilizer projector data. -/
  projector : AdditiveStabilizerProjector m 𝕜 𝔽
  /-- Physical pure state in the computational basis. -/
  state : GenericState m 𝔽
  /-- Stabilizer-projector expansion and partial trace in the chosen Weyl
  convention. -/
  marginalWeylExpansion :
    ∀ (S : Finset (GenericParty m)) (v : S → 𝔽 × 𝔽),
      genericMarginalWeylCoefficient w state S v =
        projector.marginalWeylCoefficient S v

namespace AdditiveStabilizerState

variable {w : WeylConvention 𝔽}
  (ψ : AdditiveStabilizerState m 𝕜 𝔽 w)

/-- Physical marginal coordinates transported to the common Weyl frame
selected by one retained base party. -/
noncomputable def reindexedMarginalArray
    (S : Finset (GenericParty m)) (hS : S.card = m + 1)
    (base : S) : FamilyArray S (𝔽 × 𝔽) :=
  fun x =>
    genericMarginalWeylCoefficient w ψ.state S
      (ψ.projector.reindexedMarginalLabels S hS base x)

/-- The physical reindexed marginal equals the projector-defined reindexed
marginal. -/
theorem reindexedMarginalArray_eq_projector
    (S : Finset (GenericParty m)) (hS : S.card = m + 1)
    (base : S) :
    ψ.reindexedMarginalArray S hS base =
      ψ.projector.reindexedMarginalArray S hS base := by
  funext x
  exact ψ.marginalWeylExpansion S
    (ψ.projector.reindexedMarginalLabels S hS base x)

/-- Every physical half-plus-one marginal is full-Weyl diagonal after
transport to a common local label frame. -/
theorem reindexedMarginalArray_eq_diagonal
    (S : Finset (GenericParty m)) (hS : S.card = m + 1)
    (base : S) :
    ψ.reindexedMarginalArray S hS base =
      diagonalFamilyArray
        (ψ.projector.reindexedDiagonalCoefficient S hS base) := by
  rw [ψ.reindexedMarginalArray_eq_projector S hS base,
    ψ.projector.reindexedMarginalArray_eq_diagonal S hS base]

end AdditiveStabilizerState

private theorem mapFamilyArray_relabel_equiv
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

private theorem relabelCoordinateEquiv_preserves_coordinateAxis
    {κ κ₂ : Type*} [DecidableEq κ] [DecidableEq κ₂]
    (e : κ ≃ κ₂) {f : κ → ℂ}
    (hf : IsNonzeroCoordinateAxis f) :
    IsNonzeroCoordinateAxis (relabelCoordinateEquiv e f) := by
  obtain ⟨i, z, hz, rfl⟩ := hf
  exact
    ⟨e i, z, hz,
      relabelCoordinateEquiv_coordinateVector e i z⟩

/-- Local unitary conjugation transported between the source and target
stabilizer pushing frames on one retained party. -/
noncomputable def additiveStabilizerTransportedLocalConjugation
    {w : WeylConvention 𝔽}
    (ψ φ : AdditiveStabilizerState m 𝕜 𝔽 w)
    {S : Finset (GenericParty m)} (hS : S.card = m + 1)
    (base i : S) (U : LocalMatrix 𝔽) (hU : IsUnitaryMatrix U) :
    (𝔽 × 𝔽 → ℂ) ≃ₗ[ℂ] (𝔽 × 𝔽 → ℂ) :=
  relabelCoordinateEquiv
      (ψ.projector.transportedLocalLabelEquiv S hS base i) ≪≫ₗ
    unitaryConjugationWeylEquiv w U hU ≪≫ₗ
      (relabelCoordinateEquiv
        (φ.projector.transportedLocalLabelEquiv S hS base i)).symm

/-- A phase-normalized product action intertwines the source and target
full-Weyl marginals in their common stabilizer pushing frames. -/
theorem additiveStabilizer_reindexedMarginalArray_intertwining
    {w : WeylConvention 𝔽}
    (ψ φ : AdditiveStabilizerState m 𝕜 𝔽 w)
    (U : GenericParty m → LocalMatrix 𝔽)
    (hU : ∀ i, IsUnitaryMatrix (U i))
    (phase : ℂ) (hphase : Complex.normSq phase = 1)
    (hstate :
      genericLocalAction U ψ.state = phase • φ.state)
    {S : Finset (GenericParty m)} (hS : S.card = m + 1)
    (base : S) :
    mapFamilyArray
        (fun i : S =>
          additiveStabilizerTransportedLocalConjugation
            ψ φ hS base i (U i.1) (hU i.1))
        (ψ.reindexedMarginalArray S hS base) =
      φ.reindexedMarginalArray S hS base := by
  classical
  let Eψ : S → Equiv.Perm (𝔽 × 𝔽) :=
    fun i => ψ.projector.transportedLocalLabelEquiv S hS base i
  let Eφ : S → Equiv.Perm (𝔽 × 𝔽) :=
    fun i => φ.projector.transportedLocalLabelEquiv S hS base i
  let W : S → ((𝔽 × 𝔽 → ℂ) ≃ₗ[ℂ] (𝔽 × 𝔽 → ℂ)) :=
    fun i => unitaryConjugationWeylEquiv w (U i.1) (hU i.1)
  let Fψ : FamilyArray S (𝔽 × 𝔽) :=
    fun v => genericMarginalWeylCoefficient w ψ.state S v
  let Fφ : FamilyArray S (𝔽 × 𝔽) :=
    fun v => genericMarginalWeylCoefficient w φ.state S v
  have hordinary : mapFamilyArray W Fψ = Fφ := by
    rw [← finiteProductUnitaryConjugationWeylEquiv_eq_mapFamilyArray]
    exact genericMarginalWeylCoordinates_eq_of_localAction_eq
      w U hU phase hphase ψ.state φ.state hstate S
  have hψ :
      ψ.reindexedMarginalArray S hS base =
        mapFamilyArray
          (fun i : S => relabelCoordinateEquiv (Eψ i).symm) Fψ := by
    rw [mapFamilyArray_relabel_equiv]
    rfl
  have hφ :
      φ.reindexedMarginalArray S hS base =
        mapFamilyArray
          (fun i : S => relabelCoordinateEquiv (Eφ i).symm) Fφ := by
    rw [mapFamilyArray_relabel_equiv]
    rfl
  rw [hψ, hφ, mapFamilyArray_comp]
  have hfactor :
      (fun i : S =>
        relabelCoordinateEquiv (Eψ i).symm ≪≫ₗ
          additiveStabilizerTransportedLocalConjugation
            ψ φ hS base i (U i.1) (hU i.1)) =
      fun i : S => W i ≪≫ₗ
        relabelCoordinateEquiv (Eφ i).symm := by
    funext i
    apply LinearEquiv.ext
    intro f
    change
      relabelCoordinateEquiv (Eφ i).symm
          (W i
            (relabelCoordinateEquiv (Eψ i)
              (relabelCoordinateEquiv (Eψ i).symm f))) =
        relabelCoordinateEquiv (Eφ i).symm (W i f)
    congr 1
    apply congrArg (W i)
    funext j
    simp [relabelCoordinateEquiv]
  rw [hfactor, ← mapFamilyArray_comp, hordinary]

/-- One party of a product-unitary equivalence between additive stabilizer
AME states is Clifford, using any half-plus-one support containing it. -/
theorem additiveStabilizer_marginal_party_isClifford
    (hm : 2 ≤ m) (w : WeylConvention 𝔽)
    (ψ φ : AdditiveStabilizerState m 𝕜 𝔽 w)
    (U : GenericParty m → LocalMatrix 𝔽)
    (hU : ∀ i, IsUnitaryMatrix (U i))
    (phase : ℂ) (hphase : Complex.normSq phase = 1)
    (hstate :
      genericLocalAction U ψ.state = phase • φ.state)
    {S : Finset (GenericParty m)} (hS : S.card = m + 1)
    (base i : S) :
    IsCliffordMatrix w (U i.1) := by
  classical
  have hintertwine :=
    additiveStabilizer_reindexedMarginalArray_intertwining
      ψ φ U hU phase hphase hstate hS base
  rw [ψ.reindexedMarginalArray_eq_diagonal S hS base,
    φ.reindexedMarginalArray_eq_diagonal S hS base] at hintertwine
  have hcardS : 3 ≤ Fintype.card S := by
    rw [Fintype.card_coe, hS]
    omega
  have haxes :=
    familyFactor_coordinateAxes_of_diagonal_equivalent
      hcardS
      (fun j : S =>
        additiveStabilizerTransportedLocalConjugation
          ψ φ hS base j (U j.1) (hU j.1))
      (ψ.projector.reindexedDiagonalCoefficient_ne_zero S hS base)
      (φ.projector.reindexedDiagonalCoefficient_ne_zero S hS base)
      hintertwine i
  apply isCliffordMatrix_of_weylCoordinate_axes w (U i.1) (hU i.1)
  intro v
  let Eψ :=
    ψ.projector.transportedLocalLabelEquiv S hS base i
  let Eφ :=
    φ.projector.transportedLocalLabelEquiv S hS base i
  let t := Eψ.symm v
  have ht :
      relabelCoordinateEquiv Eψ (coordinateVector t 1) =
        coordinateVector v 1 := by
    simpa [t, Eψ] using
      relabelCoordinateEquiv_coordinateVector Eψ t 1
  have htransport := haxes t
  have htarget :
      relabelCoordinateEquiv Eφ
        (additiveStabilizerTransportedLocalConjugation
          ψ φ hS base i (U i.1) (hU i.1)
            (coordinateVector t 1)) =
      unitaryConjugationWeylEquiv w (U i.1) (hU i.1)
        (coordinateVector v 1) := by
    change
      relabelCoordinateEquiv Eφ
        ((relabelCoordinateEquiv Eφ).symm
          (unitaryConjugationWeylEquiv w (U i.1) (hU i.1)
            (relabelCoordinateEquiv Eψ
              (coordinateVector t 1)))) =
        unitaryConjugationWeylEquiv w (U i.1) (hU i.1)
          (coordinateVector v 1)
    rw [(relabelCoordinateEquiv Eφ).apply_symm_apply, ht]
  rw [← htarget]
  exact relabelCoordinateEquiv_preserves_coordinateAxis Eφ htransport

/-- Every factor of a product-unitary equivalence between arbitrary additive
stabilizer `AME(2m,q)` states is Clifford when `m ≥ 2`. -/
theorem additiveStabilizer_all_isClifford_of_localAction
    (hm : 2 ≤ m) (w : WeylConvention 𝔽)
    (ψ φ : AdditiveStabilizerState m 𝕜 𝔽 w)
    (U : GenericParty m → LocalMatrix 𝔽)
    (hU : ∀ i, IsUnitaryMatrix (U i))
    (phase : ℂ) (hphase : Complex.normSq phase = 1)
    (hstate :
      genericLocalAction U ψ.state = phase • φ.state) :
    ∀ i, IsCliffordMatrix w (U i) := by
  intro i
  obtain ⟨S, hS, hiS⟩ := exists_genericRetainedSet (by omega) i
  let base : S := ⟨i, hiS⟩
  exact additiveStabilizer_marginal_party_isClifford
    hm w ψ φ U hU phase hphase hstate hS base base

/-- Party-relabeled form of additive stabilizer AME rigidity.  The source
interface `ψπ` explicitly realizes the permuted source state; constructing
that interface from a concrete stabilizer representation is separate from
the axis-recovery argument. -/
theorem additiveStabilizer_all_isClifford_of_permutedLocalAction
    (hm : 2 ≤ m) (w : WeylConvention 𝔽)
    (ψ φ ψπ : AdditiveStabilizerState m 𝕜 𝔽 w)
    (π : Equiv.Perm (GenericParty m))
    (hψπ : ψπ.state = genericPermuteState π ψ.state)
    (U : GenericParty m → LocalMatrix 𝔽)
    (hU : ∀ i, IsUnitaryMatrix (U i))
    (phase : ℂ) (hphase : Complex.normSq phase = 1)
    (hstate :
      genericLocalAction U (genericPermuteState π ψ.state) =
        phase • φ.state) :
    ∀ i, IsCliffordMatrix w (U i) := by
  apply additiveStabilizer_all_isClifford_of_localAction
    hm w ψπ φ U hU phase hphase
  rw [hψπ]
  exact hstate

/-- Fixed-party product-unitary equivalence of two realized additive
stabilizer AME states. -/
def AdditiveStabilizerLocallyUnitaryEquivalent
    (w : WeylConvention 𝔽)
    (ψ φ : AdditiveStabilizerState m 𝕜 𝔽 w) : Prop :=
  ∃ (U : GenericParty m → LocalMatrix 𝔽) (phase : ℂ),
    (∀ i, IsUnitaryMatrix (U i)) ∧
    Complex.normSq phase = 1 ∧
    genericLocalAction U ψ.state = phase • φ.state

/-- Fixed-party local-Clifford equivalence of two realized additive
stabilizer AME states. -/
def AdditiveStabilizerLocallyCliffordEquivalent
    (w : WeylConvention 𝔽)
    (ψ φ : AdditiveStabilizerState m 𝕜 𝔽 w) : Prop :=
  ∃ (U : GenericParty m → LocalMatrix 𝔽) (phase : ℂ),
    (∀ i, IsCliffordMatrix w (U i)) ∧
    Complex.normSq phase = 1 ∧
    genericLocalAction U ψ.state = phase • φ.state

/-- For `m ≥ 2`, fixed-party local-unitary equivalence between arbitrary
additive stabilizer AME states implies local-Clifford equivalence with the
same local matrices and global phase. -/
theorem additiveStabilizer_locallyUnitaryEquivalent_implies_locallyCliffordEquivalent
    (hm : 2 ≤ m) (w : WeylConvention 𝔽)
    (ψ φ : AdditiveStabilizerState m 𝕜 𝔽 w)
    (hLU : AdditiveStabilizerLocallyUnitaryEquivalent w ψ φ) :
    AdditiveStabilizerLocallyCliffordEquivalent w ψ φ := by
  obtain ⟨U, phase, hU, hphase, hstate⟩ := hLU
  exact
    ⟨U, phase,
      additiveStabilizer_all_isClifford_of_localAction
        hm w ψ φ U hU phase hphase hstate,
      hphase, hstate⟩

end RelativeConicArcs.AMELU
