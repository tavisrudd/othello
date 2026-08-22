import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.SixAxisSourcePermutationAction
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.SixAxisTwoPrimaryStandardCoordinates
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.SixAxisThreePrimaryHeartCoordinates

/-!
# Diagonal stability of both primary kernels

The two-primary and three-primary parts of the lattice model of the isogeny
kernel of the six-axis source were carried, in the modules on the primary
lattice comparisons, into two copies of the corresponding coefficient heart,
where each is proved to be a maximal isotropic subspace.  The classification of
those subspaces into the projective-line packet has one further input: the
subspace must be stable under the diagonal action of the two displayed
generators of the six-label permutation action on the heart.  This module
proves that stability from equivariance of the comparison matrix.

The mechanism is one diagram.  The comparison of the two models of a primary
part reduces the integral cofactor image modulo the prime; the cofactor
intertwines the contragredient source action with the source action, so the
comparison carries the descended action on the discriminant group to the
reduced source action on the kernel of the reduced polarization.  The reduced
source action moves each elliptic homology coordinate separately by the chart
matrix of the permutation, and on chart vectors of vanishing coordinate sum
that chart matrix is, in the four heart coordinates, exactly the heart matrix
of the same permutation: such a vector is the difference presentation of the
normalized heart representative of its own first four coordinates.  Hence the
transported kernel is stable under the diagonal heart action of every
permutation for which the comparison matrix is equivariant.

Results.  For a comparison matrix pulling a unimodular alternating form back to
the source polarization and equivariant for the two displayed generators, the
transported two-primary kernel is diagonally generator stable and is therefore
one of the five members of the projective-line packet over the field with four
elements, and the transported three-primary kernel is diagonally generator
stable and is therefore the vertical copy or one of the three scalar graphs.
Neither conclusion assumes stability any longer, and neither assumes any order
or dimension of the kernel.

Trust boundary.  Every statement is about explicit integral and finite-field
matrices and finitely generated abelian groups.  No abelian scheme, elliptic
scheme, relative isogeny, Weil pairing, or geometric group action is
constructed; equivariance of the comparison matrix is a hypothesis, and its
geometric source — an action of the manuscript's alternating group compatible
with the isogeny — is supplied elsewhere.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace GraphLattices

open scoped BigOperators
open scoped Matrix

section Reduction

/-- Reduction modulo two commutes with multiplication by any integral matrix. -/
theorem integralTwoReduction_mulVec_map
    (matrix : Matrix (Fin 5 × Fin 2) (Fin 5 × Fin 2) ℤ) (vector : Fin 5 × Fin 2 → ℤ) :
    integralTwoReduction (matrix *ᵥ vector) =
      matrix.map (Int.castRingHom F2) *ᵥ integralTwoReduction vector := by
  funext index
  exact RingHom.map_mulVec (Int.castRingHom F2) matrix vector index

/-- Reduction modulo three commutes with multiplication by any integral
matrix. -/
theorem integralThreeReduction_mulVec_map
    (matrix : Matrix (Fin 5 × Fin 2) (Fin 5 × Fin 2) ℤ) (vector : Fin 5 × Fin 2 → ℤ) :
    integralThreeReduction (matrix *ᵥ vector) =
      matrix.map (Int.castRingHom F3) *ᵥ integralThreeReduction vector := by
  funext index
  exact RingHom.map_mulVec (Int.castRingHom F3) matrix vector index

/-- The comparison of the two models of the two-primary part intertwines the
descended action on the discriminant group with the reduced source action. -/
theorem sixAxisSourceTwoPrimaryComparison_permutation (permutation : Equiv.Perm (Fin 6))
    (element : sixAxisSourceDiscriminantGroup) :
    sixAxisSourceTwoPrimaryComparison
        (sixAxisSourceDiscriminantPermutation permutation element) =
      sixAxisSourcePermutationMatrix F2 permutation *ᵥ
        sixAxisSourceTwoPrimaryComparison element := by
  obtain ⟨vector, rfl⟩ := Submodule.Quotient.mk_surjective _ element
  rw [sixAxisSourceDiscriminantPermutation_mk, sixAxisSourceTwoPrimaryComparison_mk,
    sixAxisSourceTwoPrimaryComparison_mk, Matrix.mulVec_mulVec,
    sixAxisSourcePolarizationCofactor_mul_dual, ← Matrix.mulVec_mulVec,
    integralTwoReduction_mulVec_map, sixAxisSourcePermutationMatrix_map]

/-- The comparison of the two models of the three-primary part intertwines the
descended action on the discriminant group with the reduced source action. -/
theorem sixAxisSourceThreePrimaryComparison_permutation (permutation : Equiv.Perm (Fin 6))
    (element : sixAxisSourceDiscriminantGroup) :
    sixAxisSourceThreePrimaryComparison
        (sixAxisSourceDiscriminantPermutation permutation element) =
      sixAxisSourcePermutationMatrix F3 permutation *ᵥ
        sixAxisSourceThreePrimaryComparison element := by
  obtain ⟨vector, rfl⟩ := Submodule.Quotient.mk_surjective _ element
  rw [sixAxisSourceDiscriminantPermutation_mk, sixAxisSourceThreePrimaryComparison_mk,
    sixAxisSourceThreePrimaryComparison_mk, Matrix.mulVec_mulVec,
    sixAxisSourcePolarizationCofactor_mul_dual, ← Matrix.mulVec_mulVec,
    integralThreeReduction_mulVec_map, sixAxisSourcePermutationMatrix_map]

end Reduction

section HeartTransport

set_option maxRecDepth 10000
set_option maxHeartbeats 2000000

/-- In characteristic two a chart vector of vanishing coordinate sum is the
difference presentation of the normalized heart representative of its first
four coordinates. -/
theorem sixPointHeartRepresentative_difference (vector : Fin 5 → F2)
    (augmentation : ∑ axis : Fin 5, vector axis = 0) :
    (fun index : Fin 5 ↦
        sixPointHeartRepresentative (fun other : Fin 4 ↦ vector other.castSucc)
            index.castSucc -
          sixPointHeartRepresentative (fun other : Fin 4 ↦ vector other.castSucc) 5) =
      vector := by
  revert augmentation
  revert vector
  decide

/-- In characteristic three a chart vector of vanishing coordinate sum is the
difference presentation of the normalized heart representative of its first
four coordinates. -/
theorem sixPointThreeHeartRepresentative_difference (vector : Fin 5 → F3)
    (augmentation : ∑ axis : Fin 5, vector axis = 0) :
    (fun index : Fin 5 ↦
        sixPointThreeHeartRepresentative (fun other : Fin 4 ↦ vector other.castSucc)
            index.castSucc -
          sixPointThreeHeartRepresentative (fun other : Fin 4 ↦ vector other.castSucc) 5) =
      vector := by
  revert augmentation
  revert vector
  decide

/-- On chart vectors of vanishing coordinate sum, the characteristic-two chart
action is the heart action of the same permutation on the four heart
coordinates. -/
theorem sixPointChartMatrix_two_heartCoordinates (permutation : Equiv.Perm (Fin 6))
    (vector : Fin 5 → F2) (augmentation : ∑ axis : Fin 5, vector axis = 0) :
    (fun index : Fin 4 ↦
        (sixPointChartMatrix F2 permutation *ᵥ vector) index.castSucc) =
      sixPointHeartCoordinates
        (sixPointHeartRepresentative (fun other : Fin 4 ↦ vector other.castSucc) ∘
          ⇑permutation⁻¹) := by
  have permuted := sixPointChartMatrix_mulVec_difference (R := F2) permutation
    (sixPointHeartRepresentative fun other : Fin 4 ↦ vector other.castSucc)
  rw [sixPointHeartRepresentative_difference vector augmentation] at permuted
  rw [permuted]
  funext index
  fin_cases index <;> rfl

/-- On chart vectors of vanishing coordinate sum, the characteristic-three
chart action is the heart action of the same permutation on the four heart
coordinates. -/
theorem sixPointChartMatrix_three_heartCoordinates (permutation : Equiv.Perm (Fin 6))
    (vector : Fin 5 → F3) (augmentation : ∑ axis : Fin 5, vector axis = 0) :
    (fun index : Fin 4 ↦
        (sixPointChartMatrix F3 permutation *ᵥ vector) index.castSucc) =
      sixPointThreeHeartCoordinates
        (sixPointThreeHeartRepresentative (fun other : Fin 4 ↦ vector other.castSucc) ∘
          ⇑permutation⁻¹) := by
  have permuted := sixPointChartMatrix_mulVec_difference (R := F3) permutation
    (sixPointThreeHeartRepresentative fun other : Fin 4 ↦ vector other.castSucc)
  rw [sixPointThreeHeartRepresentative_difference vector augmentation] at permuted
  rw [permuted]
  funext index
  fin_cases index <;> rfl

/-- The characteristic-two chart action of the translation generator is the
displayed heart translation. -/
theorem sixPointChartMatrix_two_translation (vector : Fin 5 → F2)
    (augmentation : ∑ axis : Fin 5, vector axis = 0) :
    (fun index : Fin 4 ↦
        (sixPointChartMatrix F2 sixPointTranslationPermutation *ᵥ vector) index.castSucc) =
      sixPointHeartTranslation *ᵥ fun index : Fin 4 ↦ vector index.castSucc := by
  rw [sixPointChartMatrix_two_heartCoordinates sixPointTranslationPermutation vector augmentation]
  have inverse : ⇑sixPointTranslationPermutation⁻¹ = sixPointTranslationPreimage := rfl
  rw [inverse]
  exact sixPointHeartCoordinates_translation _

/-- The characteristic-two chart action of the inversion generator is the
displayed heart inversion. -/
theorem sixPointChartMatrix_two_inversion (vector : Fin 5 → F2)
    (augmentation : ∑ axis : Fin 5, vector axis = 0) :
    (fun index : Fin 4 ↦
        (sixPointChartMatrix F2 sixPointInversionPermutation *ᵥ vector) index.castSucc) =
      sixPointHeartInversion *ᵥ fun index : Fin 4 ↦ vector index.castSucc := by
  rw [sixPointChartMatrix_two_heartCoordinates sixPointInversionPermutation vector augmentation]
  have inverse : ⇑sixPointInversionPermutation⁻¹ = sixPointInversionPreimage := rfl
  rw [inverse]
  exact sixPointHeartCoordinates_inversion _

/-- The characteristic-three chart action of the translation generator is the
displayed three-primary heart translation. -/
theorem sixPointChartMatrix_three_translation (vector : Fin 5 → F3)
    (augmentation : ∑ axis : Fin 5, vector axis = 0) :
    (fun index : Fin 4 ↦
        (sixPointChartMatrix F3 sixPointTranslationPermutation *ᵥ vector) index.castSucc) =
      sixPointThreeHeartTranslation *ᵥ fun index : Fin 4 ↦ vector index.castSucc := by
  rw [sixPointChartMatrix_three_heartCoordinates sixPointTranslationPermutation vector
    augmentation]
  have inverse : ⇑sixPointTranslationPermutation⁻¹ = sixPointTranslationPreimage := rfl
  rw [inverse]
  exact sixPointThreeHeartCoordinates_translation _

/-- The characteristic-three chart action of the inversion generator is the
displayed three-primary heart inversion. -/
theorem sixPointChartMatrix_three_inversion (vector : Fin 5 → F3)
    (augmentation : ∑ axis : Fin 5, vector axis = 0) :
    (fun index : Fin 4 ↦
        (sixPointChartMatrix F3 sixPointInversionPermutation *ᵥ vector) index.castSucc) =
      sixPointThreeHeartInversion *ᵥ fun index : Fin 4 ↦ vector index.castSucc := by
  rw [sixPointChartMatrix_three_heartCoordinates sixPointInversionPermutation vector augmentation]
  have inverse : ⇑sixPointInversionPermutation⁻¹ = sixPointInversionPreimage := rfl
  rw [inverse]
  exact sixPointThreeHeartCoordinates_inversion _

end HeartTransport

section DiagonalAction

/-- The diagonal action of a heart matrix on the standard discriminant
coordinates: each elliptic homology layer is moved separately. -/
def sixAxisStandardDiscriminantHeartAction (matrix : Matrix (Fin 4) (Fin 4) F2)
    (coordinates : SixAxisStandardDiscriminantCoordinates) :
    SixAxisStandardDiscriminantCoordinates :=
  fun index spin ↦ (matrix *ᵥ fun other ↦ coordinates other spin) index

/-- The coordinates of a permuted kernel vector are the diagonal heart action
on its coordinates, for any permutation whose chart action is the given heart
matrix on augmented chart vectors. -/
theorem sixAxisSourceTwoPrimaryDiscriminantCoordinates_permutation
    {permutation : Equiv.Perm (Fin 6)} {heartMatrix : Matrix (Fin 4) (Fin 4) F2}
    (compatibility : ∀ slice : Fin 5 → F2, ∑ axis : Fin 5, slice axis = 0 →
      (fun index : Fin 4 ↦ (sixPointChartMatrix F2 permutation *ᵥ slice) index.castSucc) =
        heartMatrix *ᵥ fun index : Fin 4 ↦ slice index.castSucc)
    (vector : sixAxisSourceTwoPrimaryDiscriminant)
    (membership : sixAxisSourcePermutationMatrix F2 permutation *ᵥ vector.1 ∈
      sixAxisSourceTwoPrimaryDiscriminant) :
    sixAxisSourceTwoPrimaryDiscriminantCoordinates
        ⟨sixAxisSourcePermutationMatrix F2 permutation *ᵥ vector.1, membership⟩ =
      sixAxisStandardDiscriminantHeartAction heartMatrix
        (sixAxisSourceTwoPrimaryDiscriminantCoordinates vector) := by
  have sums : ∀ spin : Fin 2, ∑ axis : Fin 5, vector.1 (axis, spin) = 0 :=
    (sixAxisSourcePolarization_two_mulVec_eq_zero_iff vector.1).mp (LinearMap.mem_ker.mp vector.2)
  funext index spin
  show (sixAxisSourcePermutationMatrix F2 permutation *ᵥ vector.1) (index.castSucc, spin) =
    (heartMatrix *ᵥ fun other : Fin 4 ↦ vector.1 (other.castSucc, spin)) index
  rw [sixAxisSourcePermutationMatrix_mulVec_apply]
  exact congrFun (compatibility (fun axis ↦ vector.1 (axis, spin)) (sums spin)) index

/-- The diagonal action of a heart matrix on two copies of the three-primary
heart. -/
def sixPointThreeHeartPairAction (matrix : Matrix (Fin 4) (Fin 4) F3)
    (pair : SixPointThreeHeart × SixPointThreeHeart) :
    SixPointThreeHeart × SixPointThreeHeart :=
  (matrix *ᵥ pair.1, matrix *ᵥ pair.2)

/-- The heart coordinates of a permuted kernel vector are the diagonal heart
action on its heart coordinates. -/
theorem sixAxisSourceThreePrimaryHeartCoordinates_permutation
    {permutation : Equiv.Perm (Fin 6)} {heartMatrix : Matrix (Fin 4) (Fin 4) F3}
    (compatibility : ∀ slice : Fin 5 → F3, ∑ axis : Fin 5, slice axis = 0 →
      (fun index : Fin 4 ↦ (sixPointChartMatrix F3 permutation *ᵥ slice) index.castSucc) =
        heartMatrix *ᵥ fun index : Fin 4 ↦ slice index.castSucc)
    (vector : sixAxisSourceThreePrimaryDiscriminant)
    (membership : sixAxisSourcePermutationMatrix F3 permutation *ᵥ vector.1 ∈
      sixAxisSourceThreePrimaryDiscriminant) :
    sixAxisSourceThreePrimaryHeartCoordinates
        ⟨sixAxisSourcePermutationMatrix F3 permutation *ᵥ vector.1, membership⟩ =
      sixPointThreeHeartPairAction heartMatrix
        (sixAxisSourceThreePrimaryHeartCoordinates vector) := by
  have sums : ∀ spin : Fin 2, ∑ axis : Fin 5, vector.1 (axis, spin) = 0 :=
    (sixAxisSourcePolarization_three_mulVec_eq_zero_iff vector.1).mp
      (LinearMap.mem_ker.mp vector.2)
  have layer : ∀ spin : Fin 2, ∀ index : Fin 4,
      (sixAxisSourcePermutationMatrix F3 permutation *ᵥ vector.1) (index.castSucc, spin) =
        (heartMatrix *ᵥ fun other : Fin 4 ↦ vector.1 (other.castSucc, spin)) index := by
    intro spin index
    rw [sixAxisSourcePermutationMatrix_mulVec_apply]
    exact congrFun (compatibility (fun axis ↦ vector.1 (axis, spin)) (sums spin)) index
  refine Prod.ext ?_ ?_ <;> funext index
  · exact layer 0 index
  · exact layer 1 index

end DiagonalAction

section Stability

variable {comparison target : Matrix (Fin 5 × Fin 2) (Fin 5 × Fin 2) ℤ}

/-- The transported two-primary kernel is stable under the diagonal heart
action of every permutation for which the comparison matrix is equivariant. -/
theorem sixAxisSourceTwoPrimaryKernelCoordinates_heartAction_mem
    {permutation : Equiv.Perm (Fin 6)} {heartMatrix : Matrix (Fin 4) (Fin 4) F2}
    (principal : target.det = 1)
    (pullback : comparisonᵀ * target * comparison = sixAxisSourcePolarization ℤ)
    (compatibility : ∀ slice : Fin 5 → F2, ∑ axis : Fin 5, slice axis = 0 →
      (fun index : Fin 4 ↦ (sixPointChartMatrix F2 permutation *ᵥ slice) index.castSucc) =
        heartMatrix *ᵥ fun index : Fin 4 ↦ slice index.castSucc)
    (equivariant : SixAxisComparisonEquivariant comparison permutation)
    {coordinates : SixAxisStandardDiscriminantCoordinates}
    (member : coordinates ∈ sixAxisSourceTwoPrimaryKernelCoordinates pullback) :
    sixAxisStandardDiscriminantHeartAction heartMatrix coordinates ∈
      sixAxisSourceTwoPrimaryKernelCoordinates pullback := by
  obtain ⟨element, elementMember, rfl⟩ :=
    mem_sixAxisSourceTwoPrimaryKernelCoordinates_iff.mp member
  refine mem_sixAxisSourceTwoPrimaryKernelCoordinates_iff.mpr
    ⟨sixAxisSourceDiscriminantPermutation permutation element,
      sixAxisSourcePrimaryKernelSubgroup_permutation_mem principal pullback equivariant 2
        elementMember, ?_⟩
  have imageValue := sixAxisSourceTwoPrimaryComparison_permutation permutation element
  have membership : sixAxisSourcePermutationMatrix F2 permutation *ᵥ
      sixAxisSourceTwoPrimaryComparison element ∈ sixAxisSourceTwoPrimaryDiscriminant := by
    rw [← imageValue]
    exact sixAxisSourceTwoPrimaryComparison_mem_kernel _
  have subtypeValue :
      (⟨sixAxisSourceTwoPrimaryComparison
          (sixAxisSourceDiscriminantPermutation permutation element),
        sixAxisSourceTwoPrimaryComparison_mem_kernel _⟩ :
          sixAxisSourceTwoPrimaryDiscriminant) =
        ⟨sixAxisSourcePermutationMatrix F2 permutation *ᵥ
          sixAxisSourceTwoPrimaryComparison element, membership⟩ :=
    Subtype.ext imageValue
  rw [subtypeValue]
  exact sixAxisSourceTwoPrimaryDiscriminantCoordinates_permutation compatibility
    ⟨sixAxisSourceTwoPrimaryComparison element,
      sixAxisSourceTwoPrimaryComparison_mem_kernel element⟩ membership

/-- The transported three-primary kernel is stable under the diagonal heart
action of every permutation for which the comparison matrix is equivariant. -/
theorem sixAxisSourceThreePrimaryKernelHeartCoordinates_heartAction_mem
    {permutation : Equiv.Perm (Fin 6)} {heartMatrix : Matrix (Fin 4) (Fin 4) F3}
    (principal : target.det = 1)
    (pullback : comparisonᵀ * target * comparison = sixAxisSourcePolarization ℤ)
    (compatibility : ∀ slice : Fin 5 → F3, ∑ axis : Fin 5, slice axis = 0 →
      (fun index : Fin 4 ↦ (sixPointChartMatrix F3 permutation *ᵥ slice) index.castSucc) =
        heartMatrix *ᵥ fun index : Fin 4 ↦ slice index.castSucc)
    (equivariant : SixAxisComparisonEquivariant comparison permutation)
    {coordinates : SixPointThreeHeart × SixPointThreeHeart}
    (member : coordinates ∈ sixAxisSourceThreePrimaryKernelHeartCoordinates pullback) :
    sixPointThreeHeartPairAction heartMatrix coordinates ∈
      sixAxisSourceThreePrimaryKernelHeartCoordinates pullback := by
  obtain ⟨element, elementMember, rfl⟩ :=
    mem_sixAxisSourceThreePrimaryKernelHeartCoordinates_iff.mp member
  refine mem_sixAxisSourceThreePrimaryKernelHeartCoordinates_iff.mpr
    ⟨sixAxisSourceDiscriminantPermutation permutation element,
      sixAxisSourcePrimaryKernelSubgroup_permutation_mem principal pullback equivariant 3
        elementMember, ?_⟩
  have imageValue := sixAxisSourceThreePrimaryComparison_permutation permutation element
  have membership : sixAxisSourcePermutationMatrix F3 permutation *ᵥ
      sixAxisSourceThreePrimaryComparison element ∈
        sixAxisSourceThreePrimaryDiscriminant := by
    rw [← imageValue]
    exact sixAxisSourceThreePrimaryComparison_mem_kernel _
  have subtypeValue :
      (⟨sixAxisSourceThreePrimaryComparison
          (sixAxisSourceDiscriminantPermutation permutation element),
        sixAxisSourceThreePrimaryComparison_mem_kernel _⟩ :
          sixAxisSourceThreePrimaryDiscriminant) =
        ⟨sixAxisSourcePermutationMatrix F3 permutation *ᵥ
          sixAxisSourceThreePrimaryComparison element, membership⟩ :=
    Subtype.ext imageValue
  rw [subtypeValue]
  exact sixAxisSourceThreePrimaryHeartCoordinates_permutation compatibility
    ⟨sixAxisSourceThreePrimaryComparison element,
      sixAxisSourceThreePrimaryComparison_mem_kernel element⟩ membership

/-- Equivariance of a comparison matrix for the two displayed generators of the
six-label action.  Words in those two permutations realize, faithfully and
onto, the alternating group on the five matchings of the displayed
one-factorization, by `sixPointGeneratedAction_realizes_alternatingGroup`. -/
def SixAxisComparisonAlternatingEquivariant
    (comparison : Matrix (Fin 5 × Fin 2) (Fin 5 × Fin 2) ℤ) : Prop :=
  SixAxisComparisonEquivariant comparison sixPointTranslationPermutation ∧
    SixAxisComparisonEquivariant comparison sixPointInversionPermutation

/-- The transported two-primary kernel of an equivariant comparison is
diagonally generator stable. -/
theorem sixAxisSourceTwoPrimaryKernelCoordinates_generatorStable
    (principal : target.det = 1)
    (pullback : comparisonᵀ * target * comparison = sixAxisSourcePolarization ℤ)
    (equivariant : SixAxisComparisonAlternatingEquivariant comparison) :
    SixAxisStandardDiscriminantGeneratorStable
      (sixAxisSourceTwoPrimaryKernelCoordinates pullback) := by
  constructor
  · rintro pair ⟨coordinates, member, rfl⟩
    exact ⟨sixAxisStandardDiscriminantHeartAction sixPointHeartTranslation coordinates,
      sixAxisSourceTwoPrimaryKernelCoordinates_heartAction_mem principal pullback
        sixPointChartMatrix_two_translation equivariant.1 member, rfl⟩
  · rintro pair ⟨coordinates, member, rfl⟩
    exact ⟨sixAxisStandardDiscriminantHeartAction sixPointHeartInversion coordinates,
      sixAxisSourceTwoPrimaryKernelCoordinates_heartAction_mem principal pullback
        sixPointChartMatrix_two_inversion equivariant.2 member, rfl⟩

/-- The transported three-primary kernel of an equivariant comparison is
diagonally generator stable. -/
theorem sixAxisSourceThreePrimaryKernelHeartCoordinates_generatorStable
    (principal : target.det = 1)
    (pullback : comparisonᵀ * target * comparison = sixAxisSourcePolarization ℤ)
    (equivariant : SixAxisComparisonAlternatingEquivariant comparison) :
    SixPointThreeHeartPairGeneratorStable
      (sixAxisSourceThreePrimaryKernelHeartCoordinates pullback) := by
  constructor
  · intro pair member
    exact sixAxisSourceThreePrimaryKernelHeartCoordinates_heartAction_mem principal pullback
      sixPointChartMatrix_three_translation equivariant.1 member
  · intro pair member
    exact sixAxisSourceThreePrimaryKernelHeartCoordinates_heartAction_mem principal pullback
      sixPointChartMatrix_three_inversion equivariant.2 member

/-- The transported two-primary kernel of an equivariant comparison is one of
the five members of the projective-line packet over the field with four
elements.  Stability is no longer an input: it comes from equivariance, and
maximal isotropy from the lattice-level self-duality of the two-primary
kernel. -/
theorem sixAxisSourceTwoPrimaryKernelCoordinates_equivariantPacket
    (principal : target.det = 1)
    (pullback : comparisonᵀ * target * comparison = sixAxisSourcePolarization ℤ)
    (equivariant : SixAxisComparisonAlternatingEquivariant comparison) :
    (sixAxisSourceTwoPrimaryKernelCoordinates pullback).map
        sixAxisStandardDiscriminantPairLinearEquiv.toLinearMap ∈
      SixPointHeartStableHalfPacket :=
  sixAxisSourceTwoPrimaryKernelCoordinates_stablePacket principal pullback
    (sixAxisSourceTwoPrimaryKernelCoordinates_generatorStable principal pullback equivariant)

/-- The transported three-primary kernel of an equivariant comparison is the
vertical copy or one of the three scalar graphs.  Stability is no longer an
input: it comes from equivariance, and four-dimensionality from the
lattice-level self-duality of the three-primary kernel. -/
theorem sixAxisSourceThreePrimaryKernelHeartCoordinates_equivariantPacket
    (principal : target.det = 1)
    (pullback : comparisonᵀ * target * comparison = sixAxisSourcePolarization ℤ)
    (equivariant : SixAxisComparisonAlternatingEquivariant comparison) :
    sixAxisSourceThreePrimaryKernelHeartCoordinates pullback ∈
      SixPointThreeHeartStableHalfPacket :=
  sixAxisSourceThreePrimaryKernelHeartCoordinates_stablePacket principal pullback
    (sixAxisSourceThreePrimaryKernelHeartCoordinates_generatorStable principal pullback
      equivariant)

end Stability

end GraphLattices

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
