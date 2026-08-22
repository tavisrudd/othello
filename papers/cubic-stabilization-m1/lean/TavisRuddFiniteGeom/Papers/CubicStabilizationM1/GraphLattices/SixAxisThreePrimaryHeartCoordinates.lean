import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.SixAxisThreePrimaryPairing

/-!
# The normalized three-primary form in the two-heart coordinates, and the packet

The normalized three-primary form on the kernel of the three-torsion reduction
of the six-axis source polarization is minus the dot product on axis
coordinates tensored with the reduced elliptic homology pairing.  The
three-primary coefficient heart lives instead on two copies of `F₃⁴`, the
coordinates of a kernel vector along the two elliptic homology coordinates,
each obtained by discarding the fifth axis coordinate, which the kernel
condition determines.  This module proves that the coordinate equivalence
between the two models is an isometry onto the two-copy tensor-product
polarization form of the heart.

The computation is the augmentation normalization.  A kernel vector has
vanishing axis coordinate sum along each elliptic homology coordinate, so its
fifth axis coordinate is minus the sum of the other four; that is exactly the
fifth entry of the normalized heart representative, whose sixth entry is zero.
Hence minus the five-term dot product of two kernel slices is minus the
six-term dot product of the corresponding heart representatives, which is the
coefficient form of the three-primary heart, and summing against the reduced
elliptic pairing turns the normalized three-primary form into the two-copy
polarization form.

Carrying the three-primary part of the lattice model of the isogeny kernel
across that isometry gives a subspace of two heart copies which is exactly its
own orthogonal complement, hence maximal isotropic, hence four-dimensional; by
the classification of the diagonally stable four-dimensional subspaces it is
therefore the vertical copy or one of the three scalar graphs as soon as it is
stable under the two diagonal generators.

Trust boundary.  Every statement is about explicit `F₃`-valued coordinates and
matrices.  No elliptic three-torsion group scheme, Weil pairing, geometric
discriminant, or group action is constructed.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace GraphLattices

open scoped BigOperators
open scoped Matrix

set_option maxRecDepth 10000
set_option maxHeartbeats 2000000

/-- In a finite-dimensional nondegenerate alternating bilinear space, a maximal
isotropic subspace has exactly half the ambient dimension. -/
theorem twice_finrank_of_isMaximalIsotropic
    {K V : Type*} [Field K] [AddCommGroup V] [Module K V] [FiniteDimensional K V]
    (form : LinearMap.BilinForm K V) (nondegenerate : form.Nondegenerate)
    (alternating : form.IsAlt) {subspace : Submodule K V}
    (maximal : IsMaximalIsotropic form subspace) :
    2 * Module.finrank K subspace = Module.finrank K V := by
  have orthogonalLe : form.orthogonal subspace ≤ subspace := by
    by_contra notLe
    have unequal : subspace ≠ form.orthogonal subspace := by
      intro equality
      apply notLe
      rw [← equality]
    have strict : subspace < form.orthogonal subspace := lt_of_le_of_ne maximal.1 unequal
    obtain ⟨vector, vectorOrthogonal, vectorOutside⟩ := SetLike.exists_of_lt strict
    let larger : Submodule K V := subspace ⊔ K ∙ vector
    have contains : subspace ≤ larger := le_sup_left
    have largerIsotropic : larger ≤ form.orthogonal larger := by
      intro left leftMember right rightMember
      obtain ⟨leftBase, leftBaseMember, leftSpan, leftSpanMember, rfl⟩ :=
        Submodule.mem_sup.mp leftMember
      obtain ⟨rightBase, rightBaseMember, rightSpan, rightSpanMember, rfl⟩ :=
        Submodule.mem_sup.mp rightMember
      obtain ⟨leftScalar, rfl⟩ := Submodule.mem_span_singleton.mp leftSpanMember
      obtain ⟨rightScalar, rfl⟩ := Submodule.mem_span_singleton.mp rightSpanMember
      have baseBase : form rightBase leftBase = 0 :=
        maximal.1 leftBaseMember rightBase rightBaseMember
      have baseVector : form rightBase vector = 0 := vectorOrthogonal rightBase rightBaseMember
      have vectorBase : form vector leftBase = 0 :=
        neg_eq_zero.mp
          ((LinearMap.BilinForm.IsAlt.neg_eq alternating vector leftBase).trans
            (vectorOrthogonal leftBase leftBaseMember))
      have vectorVector : form vector vector = 0 := alternating vector
      simp only [map_add, map_smul, LinearMap.add_apply, LinearMap.smul_apply, baseBase,
        baseVector, vectorBase, vectorVector, smul_zero, add_zero]
    have largerEquality := maximal.2 larger contains largerIsotropic
    have vectorLarger : vector ∈ larger :=
      Submodule.mem_sup_right (Submodule.mem_span_singleton_self vector)
    exact vectorOutside (by simpa [largerEquality] using vectorLarger)
  have orthogonalEquality : form.orthogonal subspace = subspace :=
    le_antisymm orthogonalLe maximal.1
  have rankEquality := form.finrank_orthogonal nondegenerate subspace
  rw [orthogonalEquality] at rankEquality
  have rankLe : Module.finrank K subspace ≤ Module.finrank K V := Submodule.finrank_le subspace
  omega

/-- The three-primary heart coefficient form of two four-coordinate vectors is
minus their dot product minus the product of their coordinate sums: the fifth
entry of a normalized representative is minus the coordinate sum, and the sixth
entry vanishes. -/
theorem sixPointThreeHeartCoefficientForm_eq_dotProduct_and_sums
    (left right : SixPointThreeHeart) :
    sixPointThreeHeartCoefficientForm left right =
      -((∑ index : Fin 4, left index * right index) +
        (∑ index : Fin 4, left index) * (∑ index : Fin 4, right index)) := by
  revert left right
  decide

/-- Minus the five-term dot product of two vectors with vanishing coordinate
sum is the three-primary coefficient form of the heart vectors formed by their
first four coordinates: the fifth coordinate is minus the sum of the other
four, which is the fifth entry of the normalized heart representative. -/
theorem sixAxisThreeAugmentation_dotProduct_eq_heartForm (left right : Fin 5 → F3)
    (leftSum : ∑ axis : Fin 5, left axis = 0) (rightSum : ∑ axis : Fin 5, right axis = 0) :
    -(∑ axis : Fin 5, left axis * right axis) =
      sixPointThreeHeartCoefficientForm (fun index : Fin 4 ↦ left index.castSucc)
        (fun index : Fin 4 ↦ right index.castSucc) := by
  have leftExpanded : left 0 + left 1 + left 2 + left 3 + left 4 = 0 := by
    simpa [Fin.sum_univ_five] using leftSum
  have rightExpanded : right 0 + right 1 + right 2 + right 3 + right 4 = 0 := by
    simpa [Fin.sum_univ_five] using rightSum
  have leftFifth : left 4 = -(left 0 + left 1 + left 2 + left 3) := by
    linear_combination leftExpanded
  have rightFifth : right 4 = -(right 0 + right 1 + right 2 + right 3) := by
    linear_combination rightExpanded
  rw [sixPointThreeHeartCoefficientForm_eq_dotProduct_and_sums]
  simp only [Fin.sum_univ_five, Fin.sum_univ_four, Fin.castSucc_zero, Fin.castSucc_one]
  show -(left 0 * right 0 + left 1 * right 1 + left 2 * right 2 + left 3 * right 3 +
      left 4 * right 4) =
    -((left 0 * right 0 + left 1 * right 1 + left 2 * right 2 + left 3 * right 3) +
      (left 0 + left 1 + left 2 + left 3) * (right 0 + right 1 + right 2 + right 3))
  rw [leftFifth, rightFifth]
  ring

/-- The normalized three-primary form resolved into the two elliptic homology
coordinates: the reduced elliptic pairing exchanges them, so only the two cross
terms survive. -/
theorem sixAxisThreeReducedTensorForm_eq_crossTerms (left right : Fin 5 × Fin 2 → F3) :
    sixAxisThreeReducedTensorForm left right =
      -(∑ axis : Fin 5, left (axis, 0) * right (axis, 1)) +
        ∑ axis : Fin 5, left (axis, 1) * right (axis, 0) := by
  rw [sixAxisThreeReducedTensorForm]
  simp [Fin.sum_univ_two, ellipticWeilPairing]

/-- The normalized three-primary form is alternating: exchanging its arguments
reverses the sign. -/
theorem sixAxisThreeReducedTensorForm_swap (left right : Fin 5 × Fin 2 → F3) :
    sixAxisThreeReducedTensorForm right left = -sixAxisThreeReducedTensorForm left right := by
  rw [sixAxisThreeReducedTensorForm_eq_crossTerms, sixAxisThreeReducedTensorForm_eq_crossTerms,
    neg_add, neg_neg]
  rw [add_comm]
  congr 1 <;>
    [skip; rw [neg_inj]] <;>
    exact Finset.sum_congr rfl (fun _ _ ↦ mul_comm _ _)

/-- Choosing the two elliptic homology coordinates presents the four normalized
coefficient coordinates of the three-torsion model as two copies of the
three-primary heart. -/
def sixAxisThreeHeartPairLinearEquiv :
    (Fin 4 → Fin 2 → F3) ≃ₗ[F3] SixPointThreeHeart × SixPointThreeHeart where
  toFun vector := (fun index ↦ vector index 0, fun index ↦ vector index 1)
  invFun pair := fun index ↦ ![pair.1 index, pair.2 index]
  left_inv vector := by
    funext index spin
    fin_cases spin <;> rfl
  right_inv pair := by
    ext index <;> rfl
  map_add' _ _ := rfl
  map_smul' _ _ := rfl

/-- The three-primary discriminant of the source polarization in two heart
copies: the coordinates of a kernel vector along the two elliptic homology
coordinates. -/
noncomputable def sixAxisSourceThreePrimaryHeartCoordinates :
    sixAxisSourceThreePrimaryDiscriminant ≃ₗ[F3] SixPointThreeHeart × SixPointThreeHeart :=
  sixAxisSourceThreePrimaryDiscriminantCoordinates.trans sixAxisThreeHeartPairLinearEquiv

/-- The first heart coordinate of a kernel vector is its slice along the first
elliptic homology coordinate, with the fifth axis coordinate discarded. -/
theorem sixAxisSourceThreePrimaryHeartCoordinates_fst
    (vector : sixAxisSourceThreePrimaryDiscriminant) (index : Fin 4) :
    (sixAxisSourceThreePrimaryHeartCoordinates vector).1 index =
      vector.1 (index.castSucc, 0) :=
  rfl

/-- The second heart coordinate of a kernel vector is its slice along the
second elliptic homology coordinate, with the fifth axis coordinate
discarded. -/
theorem sixAxisSourceThreePrimaryHeartCoordinates_snd
    (vector : sixAxisSourceThreePrimaryDiscriminant) (index : Fin 4) :
    (sixAxisSourceThreePrimaryHeartCoordinates vector).2 index =
      vector.1 (index.castSucc, 1) :=
  rfl

/-- The coordinate equivalence on the kernel of the reduced polarization is an
isometry from the normalized three-primary form onto the two-copy
tensor-product polarization form of the three-primary heart. -/
theorem sixAxisThreeReducedTensorForm_eq_pairPolarizationForm
    (left right : sixAxisSourceThreePrimaryDiscriminant) :
    sixAxisThreeReducedTensorForm left.1 right.1 =
      sixPointThreeHeartPairPolarizationForm
        (sixAxisSourceThreePrimaryHeartCoordinates left)
        (sixAxisSourceThreePrimaryHeartCoordinates right) := by
  have leftSums : ∀ spin : Fin 2, ∑ axis : Fin 5, left.1 (axis, spin) = 0 :=
    (sixAxisSourcePolarization_three_mulVec_eq_zero_iff left.1).mp (LinearMap.mem_ker.mp left.2)
  have rightSums : ∀ spin : Fin 2, ∑ axis : Fin 5, right.1 (axis, spin) = 0 :=
    (sixAxisSourcePolarization_three_mulVec_eq_zero_iff right.1).mp (LinearMap.mem_ker.mp right.2)
  have slice : ∀ leftSpin rightSpin : Fin 2,
      -(∑ axis : Fin 5, left.1 (axis, leftSpin) * right.1 (axis, rightSpin)) =
        sixPointThreeHeartCoefficientForm
          (fun index : Fin 4 ↦ left.1 (index.castSucc, leftSpin))
          (fun index : Fin 4 ↦ right.1 (index.castSucc, rightSpin)) := by
    intro leftSpin rightSpin
    exact sixAxisThreeAugmentation_dotProduct_eq_heartForm
      (fun axis ↦ left.1 (axis, leftSpin)) (fun axis ↦ right.1 (axis, rightSpin))
      (leftSums leftSpin) (rightSums rightSpin)
  rw [sixAxisThreeReducedTensorForm_eq_crossTerms, sixPointThreeHeartPairPolarizationForm]
  rw [show (sixAxisSourceThreePrimaryHeartCoordinates left).1 =
      fun index : Fin 4 ↦ left.1 (index.castSucc, 0) from rfl,
    show (sixAxisSourceThreePrimaryHeartCoordinates left).2 =
      fun index : Fin 4 ↦ left.1 (index.castSucc, 1) from rfl,
    show (sixAxisSourceThreePrimaryHeartCoordinates right).1 =
      fun index : Fin 4 ↦ right.1 (index.castSucc, 0) from rfl,
    show (sixAxisSourceThreePrimaryHeartCoordinates right).2 =
      fun index : Fin 4 ↦ right.1 (index.castSucc, 1) from rfl,
    ← slice 0 1, ← slice 1 0]
  ring

section Comparison

variable {comparison target : Matrix (Fin 5 × Fin 2) (Fin 5 × Fin 2) ℤ}

/-- The three-primary part of the lattice model of the isogeny kernel, carried
into two copies of the three-primary heart by the comparison and the coordinate
equivalence. -/
def sixAxisSourceThreePrimaryKernelHeartCoordinates
    (pullback : comparisonᵀ * target * comparison = sixAxisSourcePolarization ℤ) :
    Submodule F3 (SixPointThreeHeart × SixPointThreeHeart) where
  carrier := {coordinates |
    ∃ element ∈ sixAxisSourcePrimaryKernelSubgroup pullback 3,
      sixAxisSourceThreePrimaryHeartCoordinates
          ⟨sixAxisSourceThreePrimaryComparison element,
            sixAxisSourceThreePrimaryComparison_mem_kernel element⟩ = coordinates}
  zero_mem' := by
    refine ⟨0, Submodule.zero_mem _, ?_⟩
    have subtypeZero :
        (⟨sixAxisSourceThreePrimaryComparison 0,
          sixAxisSourceThreePrimaryComparison_mem_kernel 0⟩ :
            sixAxisSourceThreePrimaryDiscriminant) = 0 :=
      Subtype.ext (map_zero sixAxisSourceThreePrimaryComparison)
    rw [subtypeZero, map_zero]
  add_mem' := by
    rintro first second ⟨firstElement, firstMember, rfl⟩ ⟨secondElement, secondMember, rfl⟩
    refine ⟨firstElement + secondElement, Submodule.add_mem _ firstMember secondMember, ?_⟩
    have subtypeAdd :
        (⟨sixAxisSourceThreePrimaryComparison (firstElement + secondElement),
          sixAxisSourceThreePrimaryComparison_mem_kernel _⟩ :
            sixAxisSourceThreePrimaryDiscriminant) =
          ⟨sixAxisSourceThreePrimaryComparison firstElement,
            sixAxisSourceThreePrimaryComparison_mem_kernel _⟩ +
            ⟨sixAxisSourceThreePrimaryComparison secondElement,
              sixAxisSourceThreePrimaryComparison_mem_kernel _⟩ :=
      Subtype.ext (map_add sixAxisSourceThreePrimaryComparison firstElement secondElement)
    rw [subtypeAdd, map_add]
  smul_mem' := by
    rintro scalar coordinates ⟨element, member, rfl⟩
    have scalarValue : ∀ value : F3, value = 0 ∨ value = 1 ∨ value = 2 := by decide
    have subtypeZero :
        (⟨sixAxisSourceThreePrimaryComparison 0,
          sixAxisSourceThreePrimaryComparison_mem_kernel 0⟩ :
            sixAxisSourceThreePrimaryDiscriminant) = 0 :=
      Subtype.ext (map_zero sixAxisSourceThreePrimaryComparison)
    rcases scalarValue scalar with rfl | rfl | rfl
    · refine ⟨0, Submodule.zero_mem _, ?_⟩
      rw [subtypeZero, map_zero, zero_smul]
    · exact ⟨element, member, by rw [one_smul]⟩
    · refine ⟨element + element, Submodule.add_mem _ member member, ?_⟩
      have subtypeAdd :
          (⟨sixAxisSourceThreePrimaryComparison (element + element),
            sixAxisSourceThreePrimaryComparison_mem_kernel _⟩ :
              sixAxisSourceThreePrimaryDiscriminant) =
            ⟨sixAxisSourceThreePrimaryComparison element,
              sixAxisSourceThreePrimaryComparison_mem_kernel _⟩ +
              ⟨sixAxisSourceThreePrimaryComparison element,
                sixAxisSourceThreePrimaryComparison_mem_kernel _⟩ :=
        Subtype.ext (map_add sixAxisSourceThreePrimaryComparison element element)
      rw [subtypeAdd, map_add, two_smul]

/-- Membership in the transported kernel is being the coordinate pair of a
comparison image of a three-primary kernel class. -/
theorem mem_sixAxisSourceThreePrimaryKernelHeartCoordinates_iff
    {pullback : comparisonᵀ * target * comparison = sixAxisSourcePolarization ℤ}
    {coordinates : SixPointThreeHeart × SixPointThreeHeart} :
    coordinates ∈ sixAxisSourceThreePrimaryKernelHeartCoordinates pullback ↔
      ∃ element ∈ sixAxisSourcePrimaryKernelSubgroup pullback 3,
        sixAxisSourceThreePrimaryHeartCoordinates
            ⟨sixAxisSourceThreePrimaryComparison element,
              sixAxisSourceThreePrimaryComparison_mem_kernel element⟩ = coordinates :=
  Iff.rfl

/-- The transported three-primary kernel is exactly its own orthogonal
complement for the two-copy polarization form. -/
theorem sixAxisSourceThreePrimaryKernelHeartCoordinates_eq_orthogonal
    (principal : target.det = 1)
    (pullback : comparisonᵀ * target * comparison = sixAxisSourcePolarization ℤ) :
    sixAxisSourceThreePrimaryKernelHeartCoordinates pullback =
      sixPointThreeHeartPairPolarizationBilinForm.orthogonal
        (sixAxisSourceThreePrimaryKernelHeartCoordinates pullback) := by
  have transport : ∀ {vector : Fin 5 × Fin 2 → F3},
      vector ∈ sixAxisSourceThreePrimaryDiscriminant →
      ((∀ other ∈ sixAxisSourceThreePrimaryKernelImage pullback,
          sixAxisThreeReducedTensorForm vector other = 0) ↔
        vector ∈ sixAxisSourceThreePrimaryKernelImage pullback) :=
    fun member ↦ sixAxisSourceThreePrimaryKernelImage_eq_perp principal pullback member
  refine le_antisymm (fun coordinates membership ↦ ?_) (fun coordinates membership ↦ ?_)
  · refine LinearMap.BilinForm.mem_orthogonal_iff.mpr (fun other otherMembership ↦ ?_)
    obtain ⟨element, member, rfl⟩ :=
      mem_sixAxisSourceThreePrimaryKernelHeartCoordinates_iff.mp membership
    obtain ⟨otherElement, otherMember, rfl⟩ :=
      mem_sixAxisSourceThreePrimaryKernelHeartCoordinates_iff.mp otherMembership
    have vanishing := (transport (sixAxisSourceThreePrimaryComparison_mem_kernel otherElement)).mpr
      ⟨otherElement, otherMember, rfl⟩
    have crossVanishing := vanishing (sixAxisSourceThreePrimaryComparison element)
      ⟨element, member, rfl⟩
    rw [sixPointThreeHeartPairPolarizationBilinForm_apply,
      ← sixAxisThreeReducedTensorForm_eq_pairPolarizationForm
        ⟨sixAxisSourceThreePrimaryComparison otherElement,
          sixAxisSourceThreePrimaryComparison_mem_kernel otherElement⟩
        ⟨sixAxisSourceThreePrimaryComparison element,
          sixAxisSourceThreePrimaryComparison_mem_kernel element⟩]
    exact crossVanishing
  · obtain ⟨preimage, preimageMember, preimageValue⟩ :=
      sixAxisSourceThreePrimaryComparison_surjOn
        (sixAxisSourceThreePrimaryHeartCoordinates.symm coordinates).2
    have coordinatesValue :
        sixAxisSourceThreePrimaryHeartCoordinates
            ⟨sixAxisSourceThreePrimaryComparison preimage,
              sixAxisSourceThreePrimaryComparison_mem_kernel preimage⟩ = coordinates := by
      have subtypeValue :
          (⟨sixAxisSourceThreePrimaryComparison preimage,
            sixAxisSourceThreePrimaryComparison_mem_kernel preimage⟩ :
              sixAxisSourceThreePrimaryDiscriminant) =
            sixAxisSourceThreePrimaryHeartCoordinates.symm coordinates :=
        Subtype.ext preimageValue
      rw [subtypeValue, LinearEquiv.apply_symm_apply]
    refine mem_sixAxisSourceThreePrimaryKernelHeartCoordinates_iff.mpr
      ⟨preimage, ?_, coordinatesValue⟩
    have kernelMembership := (transport
      (sixAxisSourceThreePrimaryComparison_mem_kernel preimage)).mp (fun other otherMembership ↦ ?_)
    · obtain ⟨kernelElement, kernelMember, kernelValue⟩ := kernelMembership
      have equalClasses : preimage = kernelElement :=
        sixAxisSourceThreePrimaryComparison_injOn preimageMember
          (Submodule.mem_inf.mp kernelMember).2 kernelValue.symm
      exact equalClasses ▸ kernelMember
    · obtain ⟨otherElement, otherMember, rfl⟩ := otherMembership
      have otherCoordinates :=
        mem_sixAxisSourceThreePrimaryKernelHeartCoordinates_iff.mpr ⟨otherElement, otherMember, rfl⟩
      have orthogonality := LinearMap.BilinForm.mem_orthogonal_iff.mp membership _ otherCoordinates
      rw [sixPointThreeHeartPairPolarizationBilinForm_apply] at orthogonality
      have swapped :
          sixAxisThreeReducedTensorForm (sixAxisSourceThreePrimaryComparison preimage)
              (sixAxisSourceThreePrimaryComparison otherElement) =
            -sixAxisThreeReducedTensorForm (sixAxisSourceThreePrimaryComparison otherElement)
              (sixAxisSourceThreePrimaryComparison preimage) :=
        sixAxisThreeReducedTensorForm_swap _ _
      rw [swapped, sixAxisThreeReducedTensorForm_eq_pairPolarizationForm
          ⟨sixAxisSourceThreePrimaryComparison otherElement,
            sixAxisSourceThreePrimaryComparison_mem_kernel otherElement⟩
          ⟨sixAxisSourceThreePrimaryComparison preimage,
            sixAxisSourceThreePrimaryComparison_mem_kernel preimage⟩,
        coordinatesValue, orthogonality, neg_zero]

/-- The transported three-primary kernel is maximal isotropic for the two-copy
polarization form of the three-primary heart. -/
theorem sixAxisSourceThreePrimaryKernelHeartCoordinates_isMaximalIsotropic
    (principal : target.det = 1)
    (pullback : comparisonᵀ * target * comparison = sixAxisSourcePolarization ℤ) :
    IsMaximalIsotropic sixPointThreeHeartPairPolarizationBilinForm
      (sixAxisSourceThreePrimaryKernelHeartCoordinates pullback) := by
  have selfOrthogonal :=
    sixAxisSourceThreePrimaryKernelHeartCoordinates_eq_orthogonal principal pullback
  refine ⟨selfOrthogonal.le, fun larger contains isotropic ↦ le_antisymm ?_ contains⟩
  have antitone : sixPointThreeHeartPairPolarizationBilinForm.orthogonal larger ≤
      sixPointThreeHeartPairPolarizationBilinForm.orthogonal
        (sixAxisSourceThreePrimaryKernelHeartCoordinates pullback) :=
    fun element membership other otherMembership ↦
      LinearMap.BilinForm.mem_orthogonal_iff.mp membership other (contains otherMembership)
  exact le_of_le_of_eq (isotropic.trans antitone) selfOrthogonal.symm

/-- The transported three-primary kernel is four-dimensional, by maximal
isotropy in an eight-dimensional nondegenerate alternating space; no
cardinality of the kernel is used. -/
theorem sixAxisSourceThreePrimaryKernelHeartCoordinates_finrank
    (principal : target.det = 1)
    (pullback : comparisonᵀ * target * comparison = sixAxisSourcePolarization ℤ) :
    Module.finrank F3 (sixAxisSourceThreePrimaryKernelHeartCoordinates pullback) = 4 := by
  have ambient : Module.finrank F3 (SixPointThreeHeart × SixPointThreeHeart) = 8 := by
    simp [SixPointThreeHeart, Module.finrank_prod]
  have halved := twice_finrank_of_isMaximalIsotropic sixPointThreeHeartPairPolarizationBilinForm
    sixPointThreeHeartPairPolarizationBilinForm_nondegenerate
    sixPointThreeHeartPairPolarizationBilinForm_isAlt
    (sixAxisSourceThreePrimaryKernelHeartCoordinates_isMaximalIsotropic principal pullback)
  rw [ambient] at halved
  omega

/-- A diagonally stable transported three-primary kernel is the vertical copy
or one of the three scalar graphs.  Stability is the only remaining input:
four-dimensionality comes from the lattice-level self-duality of the
three-primary kernel through the isometry above. -/
theorem sixAxisSourceThreePrimaryKernelHeartCoordinates_stablePacket
    (principal : target.det = 1)
    (pullback : comparisonᵀ * target * comparison = sixAxisSourcePolarization ℤ)
    (stable : SixPointThreeHeartPairGeneratorStable
      (sixAxisSourceThreePrimaryKernelHeartCoordinates pullback)) :
    sixAxisSourceThreePrimaryKernelHeartCoordinates pullback ∈
      SixPointThreeHeartStableHalfPacket :=
  (sixPointThreeHeartStableHalfPacket_iff _).mpr
    ⟨stable, sixAxisSourceThreePrimaryKernelHeartCoordinates_finrank principal pullback⟩

end Comparison

end GraphLattices

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
