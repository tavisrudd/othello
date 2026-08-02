import RelativeConicArcs.PassantCodeQ13.AssociationAlgebra
import Mathlib.LinearAlgebra.FiniteDimensional.Basic

/-!
# Structural lemmas in the q=13 passant-code proof

This module contains logical reductions of the human proof, separated from native finite leaves.
Parity in a seven-line pencil forces the two weight-ten profiles, seven distinct pencil companions
force weight at least eight, the association identities make the relation operator invertible on
the code kernel, and the four-anchor argument reduces automorphism classification to three
geometric rigidity inputs.  None of these theorems uses native evaluation.
-/

namespace RelativeConicArcs.PassantCodeQ13.LogicalSpine

open Finset

/-- Seven distinct companions of a support point force support size at least eight. -/
theorem seven_companions_force_card_eight
    {Point : Type*} [DecidableEq Point]
    (support : Finset Point) (point : Point) (point_mem : point ∈ support)
    (companions : Fin 7 ↪ {other // other ∈ support.erase point}) :
    8 ≤ support.card := by
  have seven_le_erase : 7 ≤ (support.erase point).card := by
    simpa only [Fintype.card_fin, Fintype.card_coe] using
      Fintype.card_le_of_injective companions companions.injective
  rw [Finset.card_erase_of_mem point_mem] at seven_le_erase
  omega

/-- Seven nonempty odd passant fibres leave zero or two secant neighbors in a weight-ten support. -/
theorem weightTen_secant_count_is_zero_or_two
    (secantNeighbors : ℕ) (secantNeighbors_even : Even secantNeighbors)
    (seven_nonempty_fibres : 7 ≤ 9 - secantNeighbors) :
    secantNeighbors = 0 ∨ secantNeighbors = 2 := by
  obtain ⟨half, rfl⟩ := secantNeighbors_even
  omega

section Association

variable {K V : Type*} [Field K] [AddCommGroup V] [Module K V]

/-- The association squaring identities imply that a vector killed by both the incidence
operator `A` and the relation operator `B` is zero. -/
theorem association_kernel_rigidity
    (A B B2 B4 : V →ₗ[K] V)
    (B_squared : B.comp B = B2)
    (B2_squared : B2.comp B2 = B4)
    (A_squared : A.comp A = LinearMap.id + B + B2 + B4)
    {vector : V} (incidence_zero : A vector = 0) (relation_zero : B vector = 0) :
    vector = 0 := by
  have B2_zero : B2 vector = 0 := by
    have evaluated := LinearMap.congr_fun B_squared vector
    simpa [relation_zero] using evaluated.symm
  have B4_zero : B4 vector = 0 := by
    have evaluated := LinearMap.congr_fun B2_squared vector
    simpa [B2_zero] using evaluated.symm
  have evaluated := LinearMap.congr_fun A_squared vector
  simpa [incidence_zero, relation_zero, B2_zero, B4_zero] using evaluated.symm

/-- If `AB=0`, the relation operator restricts to an endomorphism of `ker A`. -/
def relationOnKernel (A B : V →ₗ[K] V) (AB_zero : A.comp B = 0) :
    LinearMap.ker A →ₗ[K] LinearMap.ker A :=
  (B.domRestrict (LinearMap.ker A)).codRestrict (LinearMap.ker A) fun vector => by
    have evaluated := LinearMap.congr_fun AB_zero vector
    simpa using evaluated

/-- The association identities make the relation operator injective on the incidence kernel. -/
theorem relationOnKernel_injective
    (A B B2 B4 : V →ₗ[K] V)
    (AB_zero : A.comp B = 0)
    (B_squared : B.comp B = B2)
    (B2_squared : B2.comp B2 = B4)
    (A_squared : A.comp A = LinearMap.id + B + B2 + B4) :
    Function.Injective (relationOnKernel A B AB_zero) := by
  intro first second equal_images
  apply Subtype.ext
  apply sub_eq_zero.mp
  apply association_kernel_rigidity A B B2 B4 B_squared B2_squared A_squared
  · simp
  · rw [map_sub]
    apply sub_eq_zero.mpr
    exact congrArg Subtype.val equal_images

/-- In finite dimension, injectivity makes the relation endomorphism of the kernel surjective. -/
theorem relationOnKernel_surjective
    [FiniteDimensional K V]
    (A B B2 B4 : V →ₗ[K] V)
    (AB_zero : A.comp B = 0)
    (B_squared : B.comp B = B2)
    (B2_squared : B2.comp B2 = B4)
    (A_squared : A.comp A = LinearMap.id + B + B2 + B4) :
    Function.Surjective (relationOnKernel A B AB_zero) :=
  LinearMap.injective_iff_surjective.mp
    (relationOnKernel_injective A B B2 B4 AB_zero B_squared B2_squared A_squared)

/-- The relation operator has image exactly the incidence kernel.  This packages the manuscript's
`im B = K` conclusion, leaving only the concrete association identities as finite inputs. -/
theorem relation_range_eq_kernel
    [FiniteDimensional K V]
    (A B B2 B4 : V →ₗ[K] V)
    (AB_zero : A.comp B = 0)
    (B_squared : B.comp B = B2)
    (B2_squared : B2.comp B2 = B4)
    (A_squared : A.comp A = LinearMap.id + B + B2 + B4) :
    LinearMap.range B = LinearMap.ker A := by
  apply le_antisymm
  · rintro vector ⟨source, rfl⟩
    have evaluated := LinearMap.congr_fun AB_zero source
    simpa [LinearMap.mem_ker] using evaluated
  · intro vector vector_mem
    obtain ⟨source, source_maps⟩ :=
      relationOnKernel_surjective A B B2 B4 AB_zero B_squared B2_squared A_squared
        ⟨vector, vector_mem⟩
    refine ⟨source, ?_⟩
    exact congrArg Subtype.val source_maps

/-- If a relation operator factors through an orbit support map, its full-kernel image forces the
orbit rows to span the code.  In the manuscript the factorization is `B = NᵀN`. -/
theorem factorization_forces_orbit_span
    {OrbitSpace : Type*} [AddCommGroup OrbitSpace] [Module K OrbitSpace]
    (A B : V →ₗ[K] V) (orbitRows : OrbitSpace →ₗ[K] V) (transposeRows : V →ₗ[K] OrbitSpace)
    (factorization : orbitRows.comp transposeRows = B)
    (relation_image : LinearMap.range B = LinearMap.ker A)
    (rows_are_codewords : LinearMap.range orbitRows ≤ LinearMap.ker A) :
    LinearMap.range orbitRows = LinearMap.ker A := by
  apply le_antisymm rows_are_codewords
  rw [← relation_image, ← factorization]
  exact LinearMap.range_comp_le_range transposeRows orbitRows

end Association

section Anchors

variable {Point GroupModel : Type*} [Group GroupModel]

/-- The logical four-anchor closure: triple normalization, a forced fourth anchor, and separating
four-anchor signatures imply that every preserving permutation comes from the group action. -/
theorem four_anchor_rigidity
    (action : GroupModel →* Equiv.Perm Point)
    (Preserves : Equiv.Perm Point → Prop)
    (first second third fourth : Point)
    (normalize : ∀ permutation, Preserves permutation →
      ∃ groupElement, let normalized := (action groupElement)⁻¹ * permutation
        Preserves normalized ∧ normalized first = first ∧ normalized second = second ∧
          normalized third = third)
    (fourth_forced : ∀ permutation, Preserves permutation →
      permutation first = first → permutation second = second → permutation third = third →
        permutation fourth = fourth)
    (signatures_separate : ∀ permutation, Preserves permutation →
      permutation first = first → permutation second = second → permutation third = third →
        permutation fourth = fourth → permutation = 1) :
    ∀ permutation, Preserves permutation → permutation ∈ Set.range action := by
  intro permutation preserves
  obtain ⟨groupElement, normalized_preserves, fixes_first, fixes_second, fixes_third⟩ :=
    normalize permutation preserves
  have fixes_fourth := fourth_forced _ normalized_preserves fixes_first fixes_second fixes_third
  have normalized_identity := signatures_separate _ normalized_preserves fixes_first fixes_second
    fixes_third fixes_fourth
  refine ⟨groupElement, ?_⟩
  simpa using inv_mul_eq_one.mp normalized_identity

end Anchors

end RelativeConicArcs.PassantCodeQ13.LogicalSpine
