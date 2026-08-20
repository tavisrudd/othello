import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.SixAxisTwoPrimaryLatticeComparison

/-!
# The discriminant pairing on the two-primary part of the six-axis source

The two-primary part of the discriminant group of the six-axis source
polarization is the kernel of the polarization reduced modulo two, through the
reduction of the cofactor image.  This module computes the `ℚ/ℤ`-valued
discriminant pairing across that identification.

Conventions.  `F` is the integral source polarization, the Kronecker product of
the five-axis coefficient matrix `6I₅-J₅` with the rank-two elliptic homology
pairing `W`; `C` is its integral cofactor, with `F C = C F = 6`.  The reduced
tensor form on `F₂^ι` is

    b(x,y) = Σ_{s,t} W̄(s,t) · Σ_i x(i,s) · y(i,t),

the tensor product of the dot product on axis coordinates with the reduced
elliptic pairing.  This is the manuscript's normalized two-primary pairing.

Results.  The adjugate of the source polarization is `6⁷ C`, so the
discriminant pairing of two classes vanishes exactly when six divides
`v ⬝ C w`; that prime-free step is proved with the cofactor identities and is
used here as stated.  For two-torsion classes, written as halves `2 v = F y` and
`2 w = F z` of polarization images, that condition becomes divisibility of
`y ⬝ F z` by four, and the halved value `(y ⬝ F z)/2` reduces modulo two to
`b(ȳ, z̄)`.  Since the comparison sends the class of `v` to `ȳ`, the
discriminant pairing of two two-torsion classes vanishes exactly when the
reduced tensor form of their comparison images does.

Trust boundary.  Every statement is about explicit integral and `F₂` matrices
and finite abelian groups.  No abelian scheme, elliptic scheme, isogeny, Weil
pairing of an actual elliptic curve, torsion local system, or geometric
commutator pairing is constructed.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace GraphLattices

open scoped BigOperators
open scoped Kronecker
open scoped Matrix

/-- Reduction of an integral vector, coordinatewise. -/
theorem integralTwoReduction_apply (vector : Fin 5 × Fin 2 → ℤ) (index : Fin 5 × Fin 2) :
    integralTwoReduction vector index = ((vector index : ℤ) : F2) :=
  rfl

/-- The reduced elliptic homology pairing is the reduction of the integral
one. -/
theorem ellipticWeilPairing_intCast (leftSpin rightSpin : Fin 2) :
    ((ellipticWeilPairing ℤ leftSpin rightSpin : ℤ) : F2) =
      ellipticWeilPairing F2 leftSpin rightSpin := by
  fin_cases leftSpin <;> fin_cases rightSpin <;> simp [ellipticWeilPairing]

/-- The normalized two-primary form on two-torsion source vectors: the dot
product on axis coordinates tensored with the reduced elliptic homology
pairing. -/
def sixAxisReducedTensorForm (left right : Fin 5 × Fin 2 → F2) : F2 :=
  ∑ leftSpin : Fin 2, ∑ rightSpin : Fin 2,
    ellipticWeilPairing F2 leftSpin rightSpin *
      ∑ axis : Fin 5, left (axis, leftSpin) * right (axis, rightSpin)

/-- Halving the polarization form of two integral vectors whose axis coordinate
sums are even, and reducing modulo two, gives the normalized two-primary form
of their reductions.  The six in the coefficient form becomes three after
halving and one modulo two, while the product of the halved coordinate sums
carries a factor two and vanishes. -/
theorem sixAxisSourcePolarization_halved_dotProduct_reduction
    (left right : Fin 5 × Fin 2 → ℤ) (leftHalfSums rightHalfSums : Fin 2 → ℤ)
    (leftSums : ∀ spin : Fin 2, ∑ axis : Fin 5, left (axis, spin) = 2 * leftHalfSums spin)
    (rightSums : ∀ spin : Fin 2, ∑ axis : Fin 5, right (axis, spin) = 2 * rightHalfSums spin)
    (value : ℤ)
    (halved : left ⬝ᵥ (sixAxisSourcePolarization ℤ *ᵥ right) = 2 * value) :
    (value : F2) =
      sixAxisReducedTensorForm (integralTwoReduction left) (integralTwoReduction right) := by
  have doubled : left ⬝ᵥ (sixAxisSourcePolarization ℤ *ᵥ right) =
      2 * ∑ leftSpin : Fin 2, ∑ rightSpin : Fin 2,
        ellipticWeilPairing ℤ leftSpin rightSpin *
          (3 * (∑ axis : Fin 5, left (axis, leftSpin) * right (axis, rightSpin)) -
            2 * (leftHalfSums leftSpin * rightHalfSums rightSpin)) := by
    rw [sixAxisSourcePolarization_dotProduct_mulVec, Finset.mul_sum]
    refine Finset.sum_congr rfl ?_
    intro leftSpin _
    rw [Finset.mul_sum]
    refine Finset.sum_congr rfl ?_
    intro rightSpin _
    rw [leftSums, rightSums]
    ring
  have equalValues : value = ∑ leftSpin : Fin 2, ∑ rightSpin : Fin 2,
      ellipticWeilPairing ℤ leftSpin rightSpin *
        (3 * (∑ axis : Fin 5, left (axis, leftSpin) * right (axis, rightSpin)) -
          2 * (leftHalfSums leftSpin * rightHalfSums rightSpin)) :=
    mul_left_cancel₀ (by norm_num : (2 : ℤ) ≠ 0) (halved.symm.trans doubled)
  rw [equalValues, sixAxisReducedTensorForm]
  push_cast
  refine Finset.sum_congr rfl ?_
  intro leftSpin _
  refine Finset.sum_congr rfl ?_
  intro rightSpin _
  rw [ellipticWeilPairing_intCast]
  have three : (3 : F2) = 1 := by decide
  have two : (2 : F2) = 0 := by decide
  rw [three, two]
  simp only [integralTwoReduction_apply]
  ring

/-- The comparison image of a two-torsion class presented as a half of a
polarization image is the reduction of the halved vector. -/
theorem sixAxisSourceTwoPrimaryComparison_mk_of_half
    (half source : Fin 5 × Fin 2 → ℤ)
    (halving : (2 : ℤ) • half = sixAxisSourcePolarization ℤ *ᵥ source) :
    sixAxisSourceTwoPrimaryComparison (Submodule.Quotient.mk half) =
      integralTwoReduction source := by
  have cofactorDoubled : (2 : ℤ) • (sixAxisSourcePolarizationCofactor *ᵥ half) =
      (2 : ℤ) • ((3 : ℤ) • source) := by
    calc (2 : ℤ) • (sixAxisSourcePolarizationCofactor *ᵥ half)
        = sixAxisSourcePolarizationCofactor *ᵥ ((2 : ℤ) • half) := by rw [Matrix.mulVec_smul]
      _ = sixAxisSourcePolarizationCofactor *ᵥ (sixAxisSourcePolarization ℤ *ᵥ source) := by
          rw [halving]
      _ = (6 : ℤ) • source := by
          rw [Matrix.mulVec_mulVec, sixAxisSourcePolarizationCofactor_mul, Matrix.smul_mulVec,
            Matrix.one_mulVec]
      _ = (2 : ℤ) • ((3 : ℤ) • source) := by rw [smul_smul]; norm_num
  have cofactorValue : sixAxisSourcePolarizationCofactor *ᵥ half = (3 : ℤ) • source :=
    smul_right_injective (Fin 5 × Fin 2 → ℤ) (by norm_num : (2 : ℤ) ≠ 0) cofactorDoubled
  rw [sixAxisSourceTwoPrimaryComparison_mk, cofactorValue, map_smul]
  funext index
  show (3 : ℤ) • integralTwoReduction source index = integralTwoReduction source index
  have three : ((3 : ℤ) : F2) = 1 := by decide
  rw [zsmul_eq_mul, three, one_mul]

/-- A vector whose polarization image is twice an integral vector has even axis
coordinate sums along every elliptic homology coordinate. -/
theorem sixAxisSourcePolarization_halved_sums_even
    (half source : Fin 5 × Fin 2 → ℤ)
    (halving : (2 : ℤ) • half = sixAxisSourcePolarization ℤ *ᵥ source) :
    ∃ halfSums : Fin 2 → ℤ,
      ∀ spin : Fin 2, ∑ axis : Fin 5, source (axis, spin) = 2 * halfSums spin := by
  have reduced : sixAxisSourcePolarization F2 *ᵥ integralTwoReduction source = 0 := by
    rw [← integralTwoReduction_mulVec, ← halving]
    funext index
    refine (integralTwoReduction_apply_eq_zero_iff _ index).mpr ?_
    exact ⟨half index, by simp [Pi.smul_apply]⟩
  have sums := (sixAxisSourcePolarization_two_mulVec_eq_zero_iff
    (integralTwoReduction source)).mp reduced
  have divisibility : ∀ spin : Fin 2, (2 : ℤ) ∣ ∑ axis : Fin 5, source (axis, spin) := by
    intro spin
    have cast : ((∑ axis : Fin 5, source (axis, spin) : ℤ) : F2) = 0 := by
      push_cast
      simpa [integralTwoReduction_apply] using sums spin
    rw [ZMod.intCast_zmod_eq_zero_iff_dvd] at cast
    exact_mod_cast cast
  exact ⟨fun spin ↦ (divisibility spin).choose, fun spin ↦ (divisibility spin).choose_spec⟩

/-- The discriminant pairing of two two-torsion classes, presented as halves of
polarization images, vanishes exactly when the normalized two-primary form of
the halved vectors does. -/
theorem sixAxisSourceTwoPrimaryPairing_mk_eq_zero_iff
    (leftHalf rightHalf left right : Fin 5 × Fin 2 → ℤ)
    (leftHalving : (2 : ℤ) • leftHalf = sixAxisSourcePolarization ℤ *ᵥ left)
    (rightHalving : (2 : ℤ) • rightHalf = sixAxisSourcePolarization ℤ *ᵥ right) :
    sixAxisSourceDiscriminantPairing (Submodule.Quotient.mk leftHalf)
          (Submodule.Quotient.mk rightHalf) = 0 ↔
      sixAxisReducedTensorForm (integralTwoReduction left) (integralTwoReduction right) = 0 := by
  obtain ⟨leftHalfSums, leftSums⟩ :=
    sixAxisSourcePolarization_halved_sums_even leftHalf left leftHalving
  obtain ⟨rightHalfSums, rightSums⟩ :=
    sixAxisSourcePolarization_halved_sums_even rightHalf right rightHalving
  have cofactorValue : sixAxisSourcePolarizationCofactor *ᵥ rightHalf = (3 : ℤ) • right := by
    have doubled : (2 : ℤ) • (sixAxisSourcePolarizationCofactor *ᵥ rightHalf) =
        (2 : ℤ) • ((3 : ℤ) • right) := by
      calc (2 : ℤ) • (sixAxisSourcePolarizationCofactor *ᵥ rightHalf)
          = sixAxisSourcePolarizationCofactor *ᵥ ((2 : ℤ) • rightHalf) := by
            rw [Matrix.mulVec_smul]
        _ = sixAxisSourcePolarizationCofactor *ᵥ (sixAxisSourcePolarization ℤ *ᵥ right) := by
            rw [rightHalving]
        _ = (6 : ℤ) • right := by
            rw [Matrix.mulVec_mulVec, sixAxisSourcePolarizationCofactor_mul, Matrix.smul_mulVec,
              Matrix.one_mulVec]
        _ = (2 : ℤ) • ((3 : ℤ) • right) := by rw [smul_smul]; norm_num
    exact smul_right_injective (Fin 5 × Fin 2 → ℤ) (by norm_num : (2 : ℤ) ≠ 0) doubled
  have transposed : left ⬝ᵥ (sixAxisSourcePolarization ℤ *ᵥ right) =
      2 * (-(leftHalf ⬝ᵥ right)) := by
    have moved : ((2 : ℤ) • leftHalf) ⬝ᵥ right =
        left ⬝ᵥ ((sixAxisSourcePolarization ℤ)ᵀ *ᵥ right) := by
      rw [leftHalving, mulVec_dotProduct_eq_dotProduct_transpose]
    rw [sixAxisSourcePolarization_transpose] at moved
    have expanded : (2 : ℤ) * (leftHalf ⬝ᵥ right) =
        - (left ⬝ᵥ (sixAxisSourcePolarization ℤ *ᵥ right)) := by
      rw [← smul_eq_mul, ← smul_dotProduct, moved, Matrix.neg_mulVec, dotProduct_neg]
    linarith [expanded]
  rw [sixAxisSourceDiscriminantPairing_mk_eq_zero_iff, cofactorValue, dotProduct_smul,
    smul_eq_mul,
    show (6 : ℤ) = 3 * 2 by norm_num,
    mul_dvd_mul_iff_left (by norm_num : (3 : ℤ) ≠ 0),
    ← sixAxisSourcePolarization_halved_dotProduct_reduction left right leftHalfSums rightHalfSums
      leftSums rightSums (-(leftHalf ⬝ᵥ right)) transposed]
  constructor
  · intro divisibility
    have cast : ((-(leftHalf ⬝ᵥ right) : ℤ) : F2) = 0 := by
      rw [ZMod.intCast_zmod_eq_zero_iff_dvd]
      exact_mod_cast dvd_neg.mpr divisibility
    exact cast
  · intro vanishing
    have divides : ((2 : ℕ) : ℤ) ∣ -(leftHalf ⬝ᵥ right) :=
      (ZMod.intCast_zmod_eq_zero_iff_dvd _ 2).mp vanishing
    have negated : (2 : ℤ) ∣ -(leftHalf ⬝ᵥ right) := by exact_mod_cast divides
    exact dvd_neg.mp negated


/-- Every two-torsion class of the discriminant group is the class of a half of
a polarization image. -/
theorem exists_halving_of_mem_twoPrimaryPart
    {element : sixAxisSourceDiscriminantGroup}
    (membership : element ∈ sixAxisSourceDiscriminantPrimaryPart 2) :
    ∃ half source : Fin 5 × Fin 2 → ℤ,
      element = Submodule.Quotient.mk half ∧
        (2 : ℤ) • half = sixAxisSourcePolarization ℤ *ᵥ source := by
  obtain ⟨half, rfl⟩ := Submodule.Quotient.mk_surjective _ element
  have torsion : (2 : ℤ) • (Submodule.Quotient.mk half : sixAxisSourceDiscriminantGroup) = 0 :=
    mem_torsionBy_iff_smul_eq_zero.mp membership
  rw [← sixAxisSourceDiscriminant_mk_smul] at torsion
  obtain ⟨source, equation⟩ :=
    mem_latticeImage_iff.mp ((Submodule.Quotient.mk_eq_zero _).mp torsion)
  exact ⟨half, source, rfl, equation.symm⟩

/-- Across the identification of the two two-primary models, the discriminant
pairing of two-torsion classes vanishes exactly when the normalized two-primary
form of their comparison images does. -/
theorem sixAxisSourceTwoPrimaryPairing_eq_zero_iff_reducedForm
    {leftClass rightClass : sixAxisSourceDiscriminantGroup}
    (leftMember : leftClass ∈ sixAxisSourceDiscriminantPrimaryPart 2)
    (rightMember : rightClass ∈ sixAxisSourceDiscriminantPrimaryPart 2) :
    sixAxisSourceDiscriminantPairing leftClass rightClass = 0 ↔
      sixAxisReducedTensorForm (sixAxisSourceTwoPrimaryComparison leftClass)
        (sixAxisSourceTwoPrimaryComparison rightClass) = 0 := by
  obtain ⟨leftHalf, left, leftClassValue, leftHalving⟩ :=
    exists_halving_of_mem_twoPrimaryPart leftMember
  obtain ⟨rightHalf, right, rightClassValue, rightHalving⟩ :=
    exists_halving_of_mem_twoPrimaryPart rightMember
  subst leftClassValue
  subst rightClassValue
  rw [sixAxisSourceTwoPrimaryComparison_mk_of_half leftHalf left leftHalving,
    sixAxisSourceTwoPrimaryComparison_mk_of_half rightHalf right rightHalving]
  exact sixAxisSourceTwoPrimaryPairing_mk_eq_zero_iff leftHalf rightHalf left right
    leftHalving rightHalving

section Comparison

variable {comparison target : Matrix (Fin 5 × Fin 2) (Fin 5 × Fin 2) ℤ}

/-- The image, in the kernel of the reduced polarization, of the two-primary
part of the lattice model of the kernel of a relative isogeny. -/
def sixAxisSourceTwoPrimaryKernelImage
    (pullback : comparisonᵀ * target * comparison = sixAxisSourcePolarization ℤ) :
    Set (Fin 5 × Fin 2 → F2) :=
  sixAxisSourceTwoPrimaryComparison ''
    (sixAxisSourcePrimaryKernelSubgroup pullback 2 : Set sixAxisSourceDiscriminantGroup)

/-- That image is exactly its own orthogonal complement inside the kernel of
the reduced polarization, for the normalized two-primary form: a vector of that
kernel is orthogonal to the whole image exactly when it belongs to it.  This
transports the relative maximal isotropy of the two-primary kernel to the
model in which the coefficient heart and the rank-eight tensor form are
formalized. -/
theorem sixAxisSourceTwoPrimaryKernelImage_eq_perp (principal : target.det = 1)
    (pullback : comparisonᵀ * target * comparison = sixAxisSourcePolarization ℤ)
    {vector : Fin 5 × Fin 2 → F2} (member : vector ∈ sixAxisSourceTwoPrimaryDiscriminant) :
    (∀ other ∈ sixAxisSourceTwoPrimaryKernelImage pullback,
        sixAxisReducedTensorForm vector other = 0) ↔
      vector ∈ sixAxisSourceTwoPrimaryKernelImage pullback := by
  have selfPerp := (sixAxisSourcePrimaryKernelSubgroup_eq_perpWithin principal pullback).1
  constructor
  · intro orthogonal
    obtain ⟨preimage, preimageMember, preimageValue⟩ :=
      sixAxisSourceTwoPrimaryComparison_surjOn member
    refine ⟨preimage, ?_, preimageValue⟩
    have perpMember : preimage ∈
        discriminantPerp (sixAxisSourcePolarization_transpose ℤ)
          sixAxisSourcePolarization_det_ne_zero
          (sixAxisSourcePrimaryKernelSubgroup pullback 2) := by
      intro other otherMember
      have kernelTwoTorsion : other ∈ sixAxisSourceDiscriminantPrimaryPart 2 :=
        (Submodule.mem_inf.mp otherMember).2
      refine (sixAxisSourceTwoPrimaryPairing_eq_zero_iff_reducedForm preimageMember
        kernelTwoTorsion).mpr ?_
      rw [preimageValue]
      exact orthogonal _ ⟨other, otherMember, rfl⟩
    rw [selfPerp]
    exact Submodule.mem_inf.mpr ⟨preimageMember, perpMember⟩
  · rintro ⟨preimage, preimageMember, rfl⟩ other ⟨otherPreimage, otherMember, rfl⟩
    have isotropy := selfPerp.le.trans discriminantPerpWithin_le_discriminantPerp
    exact (sixAxisSourceTwoPrimaryPairing_eq_zero_iff_reducedForm
        (Submodule.mem_inf.mp preimageMember).2
        (Submodule.mem_inf.mp otherMember).2).mp
      (isotropy preimageMember otherPreimage otherMember)

end Comparison

end GraphLattices

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
