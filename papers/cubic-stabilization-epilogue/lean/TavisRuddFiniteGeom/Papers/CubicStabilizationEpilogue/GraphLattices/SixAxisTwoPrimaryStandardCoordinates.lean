import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.SixAxisTwoPrimaryPairing

/-!
# The normalized two-primary form in the standard symplectic coordinates

The normalized two-primary form on the kernel of the two-torsion reduction of
the six-axis source polarization is the dot product on axis coordinates
tensored with the reduced elliptic homology pairing.  The rank-eight tensor
form of the coefficient heart lives instead on the standard coordinates
`Fin 4 → Fin 2 → F₂`, obtained from a kernel vector by discarding its fifth
axis coordinate, which the kernel condition determines.  This module proves
that the coordinate equivalence between the two is an isometry.

The computation is the augmentation normalization.  A kernel vector has
vanishing axis coordinate sum along each elliptic homology coordinate, so in
characteristic two its fifth axis coordinate is the sum of the other four; that
is exactly the fifth entry of the normalized heart representative, whose sixth
entry is zero.  Hence the five-term dot product of two kernel slices is the
six-term dot product of the corresponding heart representatives, which is the
coefficient form of the heart, and summing against the reduced elliptic pairing
turns the normalized two-primary form into the rank-eight tensor form.

Trust boundary.  Every statement is about explicit `F₂`-valued coordinates and
matrices.  No elliptic two-torsion group scheme, Weil pairing, geometric
discriminant, or group action is constructed.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace GraphLattices

open scoped BigOperators
open scoped Matrix

/-- The five-term dot product of two vectors with vanishing coordinate sum is
the coefficient form of the heart vectors formed by their first four
coordinates: in characteristic two the fifth coordinate is the sum of the other
four, which is the fifth entry of the normalized heart representative. -/
theorem sixAxisAugmentation_dotProduct_eq_heartForm (left right : Fin 5 → F2)
    (leftSum : ∑ axis : Fin 5, left axis = 0) (rightSum : ∑ axis : Fin 5, right axis = 0) :
    ∑ axis : Fin 5, left axis * right axis =
      sixPointHeartCoefficientForm (fun index : Fin 4 ↦ left ⟨index, by omega⟩)
        (fun index : Fin 4 ↦ right ⟨index, by omega⟩) := by
  revert leftSum rightSum
  revert left right
  decide


/-- The normalized two-primary form resolved into the two elliptic homology
coordinates: the reduced elliptic pairing exchanges them, so only the two
cross terms survive. -/
theorem sixAxisReducedTensorForm_eq_crossTerms (left right : Fin 5 × Fin 2 → F2) :
    sixAxisReducedTensorForm left right =
      (∑ axis : Fin 5, left (axis, 0) * right (axis, 1)) +
        ∑ axis : Fin 5, left (axis, 1) * right (axis, 0) := by
  rw [sixAxisReducedTensorForm]
  have negativeOne : (-1 : F2) = 1 := by decide
  simp [Fin.sum_univ_two, ellipticWeilPairing, negativeOne]

/-- The normalized two-primary form is symmetric. -/
theorem sixAxisReducedTensorForm_comm (left right : Fin 5 × Fin 2 → F2) :
    sixAxisReducedTensorForm left right = sixAxisReducedTensorForm right left := by
  rw [sixAxisReducedTensorForm_eq_crossTerms, sixAxisReducedTensorForm_eq_crossTerms, add_comm]
  congr 1 <;> exact Finset.sum_congr rfl (fun _ _ ↦ mul_comm _ _)

/-- The bundled rank-eight bilinear form computes as the tensor form. -/
theorem sixAxisStandardDiscriminantBilinForm_apply
    (left right : SixAxisStandardDiscriminantCoordinates) :
    sixAxisStandardDiscriminantBilinForm left right =
      sixAxisStandardDiscriminantForm left right :=
  rfl

/-- The coordinates of a kernel vector are its first four axis coordinates. -/
theorem sixAxisSourceTwoPrimaryDiscriminantCoordinates_apply
    (vector : sixAxisSourceTwoPrimaryDiscriminant) (index : Fin 4) (spin : Fin 2) :
    sixAxisSourceTwoPrimaryDiscriminantCoordinates vector index spin =
      vector.1 (⟨index, by omega⟩, spin) :=
  rfl

/-- The coordinate equivalence on the kernel of the reduced polarization is an
isometry from the normalized two-primary form onto the rank-eight tensor form
of the coefficient heart. -/
theorem sixAxisReducedTensorForm_eq_standardForm
    (left right : sixAxisSourceTwoPrimaryDiscriminant) :
    sixAxisReducedTensorForm left.1 right.1 =
      sixAxisStandardDiscriminantForm
        (sixAxisSourceTwoPrimaryDiscriminantCoordinates left)
        (sixAxisSourceTwoPrimaryDiscriminantCoordinates right) := by
  have leftSums : ∀ spin : Fin 2, ∑ axis : Fin 5, left.1 (axis, spin) = 0 :=
    (sixAxisSourcePolarization_two_mulVec_eq_zero_iff left.1).mp (LinearMap.mem_ker.mp left.2)
  have rightSums : ∀ spin : Fin 2, ∑ axis : Fin 5, right.1 (axis, spin) = 0 :=
    (sixAxisSourcePolarization_two_mulVec_eq_zero_iff right.1).mp (LinearMap.mem_ker.mp right.2)
  have slice : ∀ (leftSpin rightSpin : Fin 2),
      ∑ axis : Fin 5, left.1 (axis, leftSpin) * right.1 (axis, rightSpin) =
        sixPointHeartCoefficientForm
          (fun index : Fin 4 ↦ sixAxisSourceTwoPrimaryDiscriminantCoordinates left index leftSpin)
          (fun index : Fin 4 ↦
            sixAxisSourceTwoPrimaryDiscriminantCoordinates right index rightSpin) := by
    intro leftSpin rightSpin
    simpa only [sixAxisSourceTwoPrimaryDiscriminantCoordinates_apply] using
      sixAxisAugmentation_dotProduct_eq_heartForm (fun axis ↦ left.1 (axis, leftSpin))
        (fun axis ↦ right.1 (axis, rightSpin)) (leftSums leftSpin) (rightSums rightSpin)
  rw [sixAxisReducedTensorForm_eq_crossTerms, slice, slice]
  rfl


section Comparison

variable {comparison target : Matrix (Fin 5 × Fin 2) (Fin 5 × Fin 2) ℤ}

/-- The two-primary part of the lattice model of the isogeny kernel, carried
into the standard symplectic coordinates by the comparison and the coordinate
equivalence.  Its elements are the coordinate vectors of the comparison images
of the two-primary kernel classes. -/
def sixAxisSourceTwoPrimaryKernelCoordinates
    (pullback : comparisonᵀ * target * comparison = sixAxisSourcePolarization ℤ) :
    Submodule F2 SixAxisStandardDiscriminantCoordinates where
  carrier := {coordinates |
    ∃ element ∈ sixAxisSourcePrimaryKernelSubgroup pullback 2,
      sixAxisSourceTwoPrimaryDiscriminantCoordinates
          ⟨sixAxisSourceTwoPrimaryComparison element,
            sixAxisSourceTwoPrimaryComparison_mem_kernel element⟩ = coordinates}
  zero_mem' := by
    refine ⟨0, Submodule.zero_mem _, ?_⟩
    have subtypeZero :
        (⟨sixAxisSourceTwoPrimaryComparison 0,
          sixAxisSourceTwoPrimaryComparison_mem_kernel 0⟩ :
            sixAxisSourceTwoPrimaryDiscriminant) = 0 :=
      Subtype.ext (map_zero sixAxisSourceTwoPrimaryComparison)
    rw [subtypeZero, map_zero]
  add_mem' := by
    rintro first second ⟨firstElement, firstMember, rfl⟩ ⟨secondElement, secondMember, rfl⟩
    refine ⟨firstElement + secondElement, Submodule.add_mem _ firstMember secondMember, ?_⟩
    have subtypeAdd :
        (⟨sixAxisSourceTwoPrimaryComparison (firstElement + secondElement),
          sixAxisSourceTwoPrimaryComparison_mem_kernel _⟩ :
            sixAxisSourceTwoPrimaryDiscriminant) =
          ⟨sixAxisSourceTwoPrimaryComparison firstElement,
            sixAxisSourceTwoPrimaryComparison_mem_kernel _⟩ +
            ⟨sixAxisSourceTwoPrimaryComparison secondElement,
              sixAxisSourceTwoPrimaryComparison_mem_kernel _⟩ :=
      Subtype.ext (map_add sixAxisSourceTwoPrimaryComparison firstElement secondElement)
    rw [subtypeAdd, map_add]
  smul_mem' := by
    rintro scalar coordinates ⟨element, member, rfl⟩
    have scalarValue : ∀ value : F2, value = 0 ∨ value = 1 := by decide
    rcases scalarValue scalar with rfl | rfl
    · refine ⟨0, Submodule.zero_mem _, ?_⟩
      have subtypeZero :
          (⟨sixAxisSourceTwoPrimaryComparison 0,
            sixAxisSourceTwoPrimaryComparison_mem_kernel 0⟩ :
              sixAxisSourceTwoPrimaryDiscriminant) = 0 :=
        Subtype.ext (map_zero sixAxisSourceTwoPrimaryComparison)
      rw [subtypeZero, map_zero, zero_smul]
    · exact ⟨element, member, by rw [one_smul]⟩

/-- Membership in the transported kernel is being the coordinate vector of a
comparison image of a two-primary kernel class. -/
theorem mem_sixAxisSourceTwoPrimaryKernelCoordinates_iff
    {pullback : comparisonᵀ * target * comparison = sixAxisSourcePolarization ℤ}
    {coordinates : SixAxisStandardDiscriminantCoordinates} :
    coordinates ∈ sixAxisSourceTwoPrimaryKernelCoordinates pullback ↔
      ∃ element ∈ sixAxisSourcePrimaryKernelSubgroup pullback 2,
        sixAxisSourceTwoPrimaryDiscriminantCoordinates
            ⟨sixAxisSourceTwoPrimaryComparison element,
              sixAxisSourceTwoPrimaryComparison_mem_kernel element⟩ = coordinates :=
  Iff.rfl

/-- The transported two-primary kernel is exactly its own orthogonal complement
for the rank-eight tensor form. -/
theorem sixAxisSourceTwoPrimaryKernelCoordinates_eq_orthogonal (principal : target.det = 1)
    (pullback : comparisonᵀ * target * comparison = sixAxisSourcePolarization ℤ) :
    sixAxisSourceTwoPrimaryKernelCoordinates pullback =
      sixAxisStandardDiscriminantBilinForm.orthogonal
        (sixAxisSourceTwoPrimaryKernelCoordinates pullback) := by
  have transport : ∀ {vector : Fin 5 × Fin 2 → F2},
      vector ∈ sixAxisSourceTwoPrimaryDiscriminant →
      ((∀ other ∈ sixAxisSourceTwoPrimaryKernelImage pullback,
          sixAxisReducedTensorForm vector other = 0) ↔
        vector ∈ sixAxisSourceTwoPrimaryKernelImage pullback) :=
    fun member ↦ sixAxisSourceTwoPrimaryKernelImage_eq_perp principal pullback member
  refine le_antisymm (fun coordinates membership ↦ ?_) (fun coordinates membership ↦ ?_)
  · refine LinearMap.BilinForm.mem_orthogonal_iff.mpr (fun other otherMembership ↦ ?_)
    obtain ⟨element, member, rfl⟩ := mem_sixAxisSourceTwoPrimaryKernelCoordinates_iff.mp membership
    obtain ⟨otherElement, otherMember, rfl⟩ :=
      mem_sixAxisSourceTwoPrimaryKernelCoordinates_iff.mp otherMembership
    have vanishing := (transport (sixAxisSourceTwoPrimaryComparison_mem_kernel otherElement)).mpr
      ⟨otherElement, otherMember, rfl⟩
    have crossVanishing := vanishing (sixAxisSourceTwoPrimaryComparison element)
      ⟨element, member, rfl⟩
    rw [sixAxisStandardDiscriminantBilinForm_apply, ← sixAxisReducedTensorForm_eq_standardForm]
    exact crossVanishing
  · obtain ⟨preimage, preimageMember, preimageValue⟩ :=
      sixAxisSourceTwoPrimaryComparison_surjOn
        (sixAxisSourceTwoPrimaryDiscriminantCoordinates.symm coordinates).2
    have coordinatesValue :
        sixAxisSourceTwoPrimaryDiscriminantCoordinates
            ⟨sixAxisSourceTwoPrimaryComparison preimage,
              sixAxisSourceTwoPrimaryComparison_mem_kernel preimage⟩ = coordinates := by
      have subtypeValue :
          (⟨sixAxisSourceTwoPrimaryComparison preimage,
            sixAxisSourceTwoPrimaryComparison_mem_kernel preimage⟩ :
              sixAxisSourceTwoPrimaryDiscriminant) =
            sixAxisSourceTwoPrimaryDiscriminantCoordinates.symm coordinates :=
        Subtype.ext preimageValue
      rw [subtypeValue, LinearEquiv.apply_symm_apply]
    refine mem_sixAxisSourceTwoPrimaryKernelCoordinates_iff.mpr ⟨preimage, ?_, coordinatesValue⟩
    have kernelMembership := (transport
      (sixAxisSourceTwoPrimaryComparison_mem_kernel preimage)).mp (fun other otherMembership ↦ ?_)
    · obtain ⟨kernelElement, kernelMember, kernelValue⟩ := kernelMembership
      have equalClasses : preimage = kernelElement :=
        (sixAxisSourceTwoPrimaryComparison_injOn preimageMember
          (Submodule.mem_inf.mp kernelMember).2 kernelValue.symm)
      exact equalClasses ▸ kernelMember
    · obtain ⟨otherElement, otherMember, rfl⟩ := otherMembership
      have otherCoordinates :=
        mem_sixAxisSourceTwoPrimaryKernelCoordinates_iff.mpr ⟨otherElement, otherMember, rfl⟩
      have orthogonality := LinearMap.BilinForm.mem_orthogonal_iff.mp membership _ otherCoordinates
      rw [sixAxisStandardDiscriminantBilinForm_apply] at orthogonality
      rw [sixAxisReducedTensorForm_comm,
        sixAxisReducedTensorForm_eq_standardForm
          ⟨sixAxisSourceTwoPrimaryComparison otherElement,
            sixAxisSourceTwoPrimaryComparison_mem_kernel otherElement⟩
          ⟨sixAxisSourceTwoPrimaryComparison preimage,
            sixAxisSourceTwoPrimaryComparison_mem_kernel preimage⟩,
        coordinatesValue]
      exact orthogonality

/-- The transported two-primary kernel is maximal isotropic for the rank-eight
tensor form of the coefficient heart. -/
theorem sixAxisSourceTwoPrimaryKernelCoordinates_isMaximalIsotropic (principal : target.det = 1)
    (pullback : comparisonᵀ * target * comparison = sixAxisSourcePolarization ℤ) :
    IsMaximalIsotropic sixAxisStandardDiscriminantBilinForm
      (sixAxisSourceTwoPrimaryKernelCoordinates pullback) := by
  have selfOrthogonal := sixAxisSourceTwoPrimaryKernelCoordinates_eq_orthogonal principal pullback
  refine ⟨selfOrthogonal.le, fun larger contains isotropic ↦ le_antisymm ?_ contains⟩
  have antitone : sixAxisStandardDiscriminantBilinForm.orthogonal larger ≤
      sixAxisStandardDiscriminantBilinForm.orthogonal
        (sixAxisSourceTwoPrimaryKernelCoordinates pullback) :=
    fun element membership other otherMembership ↦
      LinearMap.BilinForm.mem_orthogonal_iff.mp membership other (contains otherMembership)
  exact le_of_le_of_eq (isotropic.trans antitone) selfOrthogonal.symm

/-- A diagonally stable transported two-primary kernel is one of the five
members of the projective-line packet.  Stability is the only remaining input:
maximal isotropy comes from the lattice-level self-duality of the two-primary
kernel through the isometry above. -/
theorem sixAxisSourceTwoPrimaryKernelCoordinates_stablePacket (principal : target.det = 1)
    (pullback : comparisonᵀ * target * comparison = sixAxisSourcePolarization ℤ)
    (stable : SixAxisStandardDiscriminantGeneratorStable
      (sixAxisSourceTwoPrimaryKernelCoordinates pullback)) :
    (sixAxisSourceTwoPrimaryKernelCoordinates pullback).map
        sixAxisStandardDiscriminantPairLinearEquiv.toLinearMap ∈
      SixPointHeartStableHalfPacket :=
  (sixAxisStandardDiscriminant_stablePacket_iff _).mpr
    ⟨stable, sixAxisSourceTwoPrimaryKernelCoordinates_isMaximalIsotropic principal pullback⟩

end Comparison

end GraphLattices

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
