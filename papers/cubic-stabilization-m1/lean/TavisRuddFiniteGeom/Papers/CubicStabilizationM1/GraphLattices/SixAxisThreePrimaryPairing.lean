import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.SixAxisThreePrimaryLatticeComparison

/-!
# The discriminant pairing on the three-primary part of the six-axis source

The three-primary part of the discriminant group of the six-axis source
polarization is the kernel of the polarization reduced modulo three, through
the reduction of the cofactor image.  This module computes the `ℚ/ℤ`-valued
discriminant pairing across that identification.

Conventions.  `F` is the integral source polarization, the Kronecker product of
the five-axis coefficient matrix `6I₅-J₅` with the rank-two elliptic homology
pairing `W`; `C` is its integral cofactor, with `F C = C F = 6`.  The reduced
tensor form on `F₃^ι` is

    b(x,y) = Σ_{s,t} W̄(s,t) · (- Σ_i x(i,s) · y(i,t)),

the tensor product of minus the dot product on axis coordinates with the
reduced elliptic pairing.  This is the manuscript's normalized three-primary
pairing, and the minus sign is the reduction of `6I₅-J₅` modulo three, which is
the negative of the all-ones matrix and, on vectors of vanishing coordinate
sum, acts as minus the identity.

Results.  The discriminant pairing of two classes vanishes exactly when six
divides `v ⬝ C w`.  For three-torsion classes, written as thirds `3 v = F y`
and `3 w = F z` of polarization images, that condition becomes divisibility of
`y ⬝ F z` by nine, and the value `(y ⬝ F z)/3` reduces modulo three to
`b(ȳ, z̄)`.  The comparison sends the class of `v` to `-ȳ`, because `C v = 2 y`
and two is minus one modulo three; the form is unchanged by negating both
arguments, so the discriminant pairing of two three-torsion classes vanishes
exactly when the reduced tensor form of their comparison images does.

Trust boundary.  Every statement is about explicit integral and `F₃` matrices
and finite abelian groups.  No abelian scheme, elliptic scheme, isogeny, Weil
pairing of an actual elliptic curve, torsion local system, or geometric
commutator pairing is constructed.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace GraphLattices

open scoped BigOperators
open scoped Kronecker
open scoped Matrix

/-- The reduced elliptic homology pairing modulo three is the reduction of the
integral one. -/
theorem ellipticWeilPairing_intCast_three (leftSpin rightSpin : Fin 2) :
    ((ellipticWeilPairing ℤ leftSpin rightSpin : ℤ) : F3) =
      ellipticWeilPairing F3 leftSpin rightSpin := by
  fin_cases leftSpin <;> fin_cases rightSpin <;> simp [ellipticWeilPairing]

/-- The normalized three-primary form on three-torsion source vectors: minus
the dot product on axis coordinates tensored with the reduced elliptic homology
pairing. -/
def sixAxisThreeReducedTensorForm (left right : Fin 5 × Fin 2 → F3) : F3 :=
  ∑ leftSpin : Fin 2, ∑ rightSpin : Fin 2,
    ellipticWeilPairing F3 leftSpin rightSpin *
      (-∑ axis : Fin 5, left (axis, leftSpin) * right (axis, rightSpin))

/-- Negating both arguments leaves the normalized three-primary form
unchanged. -/
theorem sixAxisThreeReducedTensorForm_neg_neg (left right : Fin 5 × Fin 2 → F3) :
    sixAxisThreeReducedTensorForm (-left) (-right) =
      sixAxisThreeReducedTensorForm left right := by
  rw [sixAxisThreeReducedTensorForm, sixAxisThreeReducedTensorForm]
  refine Finset.sum_congr rfl ?_
  intro leftSpin _
  refine Finset.sum_congr rfl ?_
  intro rightSpin _
  congr 1
  congr 1
  refine Finset.sum_congr rfl ?_
  intro axis _
  show (-left) (axis, leftSpin) * (-right) (axis, rightSpin) =
    left (axis, leftSpin) * right (axis, rightSpin)
  simp

/-- Dividing the polarization form of two integral vectors whose axis
coordinate sums are divisible by three by three, and reducing modulo three,
gives the normalized three-primary form of their reductions.  The six in the
coefficient form becomes two after that division and minus one modulo three,
while the product of the divided coordinate sums carries a factor three and
vanishes. -/
theorem sixAxisSourcePolarization_thirded_dotProduct_reduction
    (left right : Fin 5 × Fin 2 → ℤ) (leftThirdSums rightThirdSums : Fin 2 → ℤ)
    (leftSums : ∀ spin : Fin 2, ∑ axis : Fin 5, left (axis, spin) = 3 * leftThirdSums spin)
    (rightSums : ∀ spin : Fin 2, ∑ axis : Fin 5, right (axis, spin) = 3 * rightThirdSums spin)
    (value : ℤ)
    (thirded : left ⬝ᵥ (sixAxisSourcePolarization ℤ *ᵥ right) = 3 * value) :
    (value : F3) =
      sixAxisThreeReducedTensorForm (integralThreeReduction left)
        (integralThreeReduction right) := by
  have tripled : left ⬝ᵥ (sixAxisSourcePolarization ℤ *ᵥ right) =
      3 * ∑ leftSpin : Fin 2, ∑ rightSpin : Fin 2,
        ellipticWeilPairing ℤ leftSpin rightSpin *
          (2 * (∑ axis : Fin 5, left (axis, leftSpin) * right (axis, rightSpin)) -
            3 * (leftThirdSums leftSpin * rightThirdSums rightSpin)) := by
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
        (2 * (∑ axis : Fin 5, left (axis, leftSpin) * right (axis, rightSpin)) -
          3 * (leftThirdSums leftSpin * rightThirdSums rightSpin)) :=
    mul_left_cancel₀ (by norm_num : (3 : ℤ) ≠ 0) (thirded.symm.trans tripled)
  rw [equalValues, sixAxisThreeReducedTensorForm]
  push_cast
  refine Finset.sum_congr rfl ?_
  intro leftSpin _
  refine Finset.sum_congr rfl ?_
  intro rightSpin _
  rw [ellipticWeilPairing_intCast_three]
  have two : (2 : F3) = -1 := by decide
  have three : (3 : F3) = 0 := by decide
  rw [two, three]
  simp only [integralThreeReduction_apply]
  ring

/-- The comparison image of a three-torsion class presented as a third of a
polarization image is minus the reduction of the divided vector: the cofactor
identity gives `C v = 2 y`, and two is minus one modulo three. -/
theorem sixAxisSourceThreePrimaryComparison_mk_of_third
    (third source : Fin 5 × Fin 2 → ℤ)
    (thirding : (3 : ℤ) • third = sixAxisSourcePolarization ℤ *ᵥ source) :
    sixAxisSourceThreePrimaryComparison (Submodule.Quotient.mk third) =
      -integralThreeReduction source := by
  have cofactorTripled : (3 : ℤ) • (sixAxisSourcePolarizationCofactor *ᵥ third) =
      (3 : ℤ) • ((2 : ℤ) • source) := by
    calc (3 : ℤ) • (sixAxisSourcePolarizationCofactor *ᵥ third)
        = sixAxisSourcePolarizationCofactor *ᵥ ((3 : ℤ) • third) := by rw [Matrix.mulVec_smul]
      _ = sixAxisSourcePolarizationCofactor *ᵥ (sixAxisSourcePolarization ℤ *ᵥ source) := by
          rw [thirding]
      _ = (6 : ℤ) • source := by
          rw [Matrix.mulVec_mulVec, sixAxisSourcePolarizationCofactor_mul, Matrix.smul_mulVec,
            Matrix.one_mulVec]
      _ = (3 : ℤ) • ((2 : ℤ) • source) := by rw [smul_smul]; norm_num
  have cofactorValue : sixAxisSourcePolarizationCofactor *ᵥ third = (2 : ℤ) • source :=
    smul_right_injective (Fin 5 × Fin 2 → ℤ) (by norm_num : (3 : ℤ) ≠ 0) cofactorTripled
  rw [sixAxisSourceThreePrimaryComparison_mk, cofactorValue, map_smul]
  funext index
  show (2 : ℤ) • integralThreeReduction source index = -integralThreeReduction source index
  have two : ((2 : ℤ) : F3) = -1 := by decide
  rw [zsmul_eq_mul, two, neg_one_mul]

/-- A vector whose polarization image is three times an integral vector has
axis coordinate sums divisible by three along every elliptic homology
coordinate. -/
theorem sixAxisSourcePolarization_thirded_sums_divisible
    (third source : Fin 5 × Fin 2 → ℤ)
    (thirding : (3 : ℤ) • third = sixAxisSourcePolarization ℤ *ᵥ source) :
    ∃ thirdSums : Fin 2 → ℤ,
      ∀ spin : Fin 2, ∑ axis : Fin 5, source (axis, spin) = 3 * thirdSums spin := by
  have reduced : sixAxisSourcePolarization F3 *ᵥ integralThreeReduction source = 0 := by
    rw [← integralThreeReduction_mulVec, ← thirding]
    funext index
    refine (integralThreeReduction_apply_eq_zero_iff _ index).mpr ?_
    exact ⟨third index, by simp [Pi.smul_apply]⟩
  have sums := (sixAxisSourcePolarization_three_mulVec_eq_zero_iff
    (integralThreeReduction source)).mp reduced
  have divisibility : ∀ spin : Fin 2, (3 : ℤ) ∣ ∑ axis : Fin 5, source (axis, spin) := by
    intro spin
    have cast : ((∑ axis : Fin 5, source (axis, spin) : ℤ) : F3) = 0 := by
      push_cast
      simpa [integralThreeReduction_apply] using sums spin
    rw [ZMod.intCast_zmod_eq_zero_iff_dvd] at cast
    exact_mod_cast cast
  exact ⟨fun spin ↦ (divisibility spin).choose, fun spin ↦ (divisibility spin).choose_spec⟩

/-- The discriminant pairing of two three-torsion classes, presented as thirds
of polarization images, vanishes exactly when the normalized three-primary form
of the divided vectors does. -/
theorem sixAxisSourceThreePrimaryPairing_mk_eq_zero_iff
    (leftThird rightThird left right : Fin 5 × Fin 2 → ℤ)
    (leftThirding : (3 : ℤ) • leftThird = sixAxisSourcePolarization ℤ *ᵥ left)
    (rightThirding : (3 : ℤ) • rightThird = sixAxisSourcePolarization ℤ *ᵥ right) :
    sixAxisSourceDiscriminantPairing (Submodule.Quotient.mk leftThird)
          (Submodule.Quotient.mk rightThird) = 0 ↔
      sixAxisThreeReducedTensorForm (integralThreeReduction left)
        (integralThreeReduction right) = 0 := by
  obtain ⟨leftThirdSums, leftSums⟩ :=
    sixAxisSourcePolarization_thirded_sums_divisible leftThird left leftThirding
  obtain ⟨rightThirdSums, rightSums⟩ :=
    sixAxisSourcePolarization_thirded_sums_divisible rightThird right rightThirding
  have cofactorValue : sixAxisSourcePolarizationCofactor *ᵥ rightThird = (2 : ℤ) • right := by
    have tripled : (3 : ℤ) • (sixAxisSourcePolarizationCofactor *ᵥ rightThird) =
        (3 : ℤ) • ((2 : ℤ) • right) := by
      calc (3 : ℤ) • (sixAxisSourcePolarizationCofactor *ᵥ rightThird)
          = sixAxisSourcePolarizationCofactor *ᵥ ((3 : ℤ) • rightThird) := by
            rw [Matrix.mulVec_smul]
        _ = sixAxisSourcePolarizationCofactor *ᵥ (sixAxisSourcePolarization ℤ *ᵥ right) := by
            rw [rightThirding]
        _ = (6 : ℤ) • right := by
            rw [Matrix.mulVec_mulVec, sixAxisSourcePolarizationCofactor_mul, Matrix.smul_mulVec,
              Matrix.one_mulVec]
        _ = (3 : ℤ) • ((2 : ℤ) • right) := by rw [smul_smul]; norm_num
    exact smul_right_injective (Fin 5 × Fin 2 → ℤ) (by norm_num : (3 : ℤ) ≠ 0) tripled
  have transposed : left ⬝ᵥ (sixAxisSourcePolarization ℤ *ᵥ right) =
      3 * (-(leftThird ⬝ᵥ right)) := by
    have moved : ((3 : ℤ) • leftThird) ⬝ᵥ right =
        left ⬝ᵥ ((sixAxisSourcePolarization ℤ)ᵀ *ᵥ right) := by
      rw [leftThirding, mulVec_dotProduct_eq_dotProduct_transpose]
    rw [sixAxisSourcePolarization_transpose] at moved
    have expanded : (3 : ℤ) * (leftThird ⬝ᵥ right) =
        - (left ⬝ᵥ (sixAxisSourcePolarization ℤ *ᵥ right)) := by
      rw [← smul_eq_mul, ← smul_dotProduct, moved, Matrix.neg_mulVec, dotProduct_neg]
    linarith [expanded]
  rw [sixAxisSourceDiscriminantPairing_mk_eq_zero_iff, cofactorValue, dotProduct_smul,
    smul_eq_mul,
    show (6 : ℤ) = 2 * 3 by norm_num,
    mul_dvd_mul_iff_left (by norm_num : (2 : ℤ) ≠ 0),
    ← sixAxisSourcePolarization_thirded_dotProduct_reduction left right leftThirdSums
      rightThirdSums leftSums rightSums (-(leftThird ⬝ᵥ right)) transposed]
  constructor
  · intro divisibility
    have cast : ((-(leftThird ⬝ᵥ right) : ℤ) : F3) = 0 := by
      rw [ZMod.intCast_zmod_eq_zero_iff_dvd]
      exact_mod_cast dvd_neg.mpr divisibility
    exact cast
  · intro vanishing
    have divides : ((3 : ℕ) : ℤ) ∣ -(leftThird ⬝ᵥ right) :=
      (ZMod.intCast_zmod_eq_zero_iff_dvd _ 3).mp vanishing
    have negated : (3 : ℤ) ∣ -(leftThird ⬝ᵥ right) := by exact_mod_cast divides
    exact dvd_neg.mp negated

/-- Every three-torsion class of the discriminant group is the class of a third
of a polarization image. -/
theorem exists_thirding_of_mem_threePrimaryPart
    {element : sixAxisSourceDiscriminantGroup}
    (membership : element ∈ sixAxisSourceDiscriminantPrimaryPart 3) :
    ∃ third source : Fin 5 × Fin 2 → ℤ,
      element = Submodule.Quotient.mk third ∧
        (3 : ℤ) • third = sixAxisSourcePolarization ℤ *ᵥ source := by
  obtain ⟨third, rfl⟩ := Submodule.Quotient.mk_surjective _ element
  have torsion : (3 : ℤ) • (Submodule.Quotient.mk third : sixAxisSourceDiscriminantGroup) = 0 :=
    mem_torsionBy_iff_smul_eq_zero.mp membership
  rw [← sixAxisSourceDiscriminant_mk_smul] at torsion
  obtain ⟨source, equation⟩ :=
    mem_latticeImage_iff.mp ((Submodule.Quotient.mk_eq_zero _).mp torsion)
  exact ⟨third, source, rfl, equation.symm⟩

/-- Across the identification of the two three-primary models, the discriminant
pairing of three-torsion classes vanishes exactly when the normalized
three-primary form of their comparison images does. -/
theorem sixAxisSourceThreePrimaryPairing_eq_zero_iff_reducedForm
    {leftClass rightClass : sixAxisSourceDiscriminantGroup}
    (leftMember : leftClass ∈ sixAxisSourceDiscriminantPrimaryPart 3)
    (rightMember : rightClass ∈ sixAxisSourceDiscriminantPrimaryPart 3) :
    sixAxisSourceDiscriminantPairing leftClass rightClass = 0 ↔
      sixAxisThreeReducedTensorForm (sixAxisSourceThreePrimaryComparison leftClass)
        (sixAxisSourceThreePrimaryComparison rightClass) = 0 := by
  obtain ⟨leftThird, left, leftClassValue, leftThirding⟩ :=
    exists_thirding_of_mem_threePrimaryPart leftMember
  obtain ⟨rightThird, right, rightClassValue, rightThirding⟩ :=
    exists_thirding_of_mem_threePrimaryPart rightMember
  subst leftClassValue
  subst rightClassValue
  rw [sixAxisSourceThreePrimaryComparison_mk_of_third leftThird left leftThirding,
    sixAxisSourceThreePrimaryComparison_mk_of_third rightThird right rightThirding,
    sixAxisThreeReducedTensorForm_neg_neg]
  exact sixAxisSourceThreePrimaryPairing_mk_eq_zero_iff leftThird rightThird left right
    leftThirding rightThirding

section Comparison

variable {comparison target : Matrix (Fin 5 × Fin 2) (Fin 5 × Fin 2) ℤ}

/-- The image, in the kernel of the reduced polarization, of the three-primary
part of the lattice model of the kernel of a relative isogeny. -/
def sixAxisSourceThreePrimaryKernelImage
    (pullback : comparisonᵀ * target * comparison = sixAxisSourcePolarization ℤ) :
    Set (Fin 5 × Fin 2 → F3) :=
  sixAxisSourceThreePrimaryComparison ''
    (sixAxisSourcePrimaryKernelSubgroup pullback 3 : Set sixAxisSourceDiscriminantGroup)

/-- That image is exactly its own orthogonal complement inside the kernel of
the reduced polarization, for the normalized three-primary form: a vector of
that kernel is orthogonal to the whole image exactly when it belongs to it.
This transports the relative maximal isotropy of the three-primary kernel to
the model in which the three-primary coefficient heart and its
minus-dot-product pairing are formalized. -/
theorem sixAxisSourceThreePrimaryKernelImage_eq_perp (principal : target.det = 1)
    (pullback : comparisonᵀ * target * comparison = sixAxisSourcePolarization ℤ)
    {vector : Fin 5 × Fin 2 → F3} (member : vector ∈ sixAxisSourceThreePrimaryDiscriminant) :
    (∀ other ∈ sixAxisSourceThreePrimaryKernelImage pullback,
        sixAxisThreeReducedTensorForm vector other = 0) ↔
      vector ∈ sixAxisSourceThreePrimaryKernelImage pullback := by
  have selfPerp := (sixAxisSourcePrimaryKernelSubgroup_eq_perpWithin principal pullback).2
  constructor
  · intro orthogonal
    obtain ⟨preimage, preimageMember, preimageValue⟩ :=
      sixAxisSourceThreePrimaryComparison_surjOn member
    refine ⟨preimage, ?_, preimageValue⟩
    have perpMember : preimage ∈
        discriminantPerp (sixAxisSourcePolarization_transpose ℤ)
          sixAxisSourcePolarization_det_ne_zero
          (sixAxisSourcePrimaryKernelSubgroup pullback 3) := by
      intro other otherMember
      have kernelThreeTorsion : other ∈ sixAxisSourceDiscriminantPrimaryPart 3 :=
        (Submodule.mem_inf.mp otherMember).2
      refine (sixAxisSourceThreePrimaryPairing_eq_zero_iff_reducedForm preimageMember
        kernelThreeTorsion).mpr ?_
      rw [preimageValue]
      exact orthogonal _ ⟨other, otherMember, rfl⟩
    rw [selfPerp]
    exact Submodule.mem_inf.mpr ⟨preimageMember, perpMember⟩
  · rintro ⟨preimage, preimageMember, rfl⟩ other ⟨otherPreimage, otherMember, rfl⟩
    have isotropy := selfPerp.le.trans discriminantPerpWithin_le_discriminantPerp
    exact (sixAxisSourceThreePrimaryPairing_eq_zero_iff_reducedForm
        (Submodule.mem_inf.mp preimageMember).2
        (Submodule.mem_inf.mp otherMember).2).mp
      (isotropy preimageMember otherPreimage otherMember)

end Comparison

end GraphLattices

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
