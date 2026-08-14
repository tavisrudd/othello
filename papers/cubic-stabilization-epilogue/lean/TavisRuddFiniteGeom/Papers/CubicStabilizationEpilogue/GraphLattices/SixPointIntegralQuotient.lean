import Mathlib.LinearAlgebra.Quotient.Bilinear
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.SixAxisGram
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.SixPointAxisDescent

/-!
# The integral six-coordinate quotient lattice

This module constructs the integral quotient of six labelled coordinates by
the constant line.  Subtracting the sixth coordinate gives a linear
equivalence with five integral coordinates.  The symmetric form

`6 * Σ i, left i * right i - (Σ i, left i) * (Σ i, right i)`

annihilates the constant line in both variables and therefore descends to the
quotient.  In the five-coordinate chart its Gram matrix is exactly `6I₅-J₅`.

These are integral coefficient-lattice statements.  No elliptic scheme,
Rosati pairing, polarization, relative isogeny, or identification with the
geometric six-axis source is constructed here.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace GraphLattices

/-- The constant integral line in the six-coordinate permutation module. -/
def sixPointIntegralConstantLine : Submodule ℤ (Fin 6 → ℤ) :=
  ℤ ∙ (fun _ ↦ (1 : ℤ))

/-- The integral six-coordinate module modulo its constant line. -/
abbrev SixPointIntegralCoefficientQuotient :=
  (Fin 6 → ℤ) ⧸ sixPointIntegralConstantLine

/-- Subtract the sixth coordinate and retain the first five coordinates. -/
def sixPointIntegralDifferenceCoordinates :
    (Fin 6 → ℤ) →ₗ[ℤ] (Fin 5 → ℤ) where
  toFun vector := fun index ↦ vector index.castSucc - vector 5
  map_add' left right := by
    funext index
    simp
    ring
  map_smul' scalar vector := by
    funext index
    simp
    ring

/-- The kernel of difference coordinates is exactly the constant line. -/
theorem sixPointIntegralDifferenceCoordinates_ker :
    LinearMap.ker sixPointIntegralDifferenceCoordinates =
      sixPointIntegralConstantLine := by
  apply le_antisymm
  · intro vector kernel
    rw [sixPointIntegralConstantLine, Submodule.mem_span_singleton]
    refine ⟨vector 5, ?_⟩
    funext coordinate
    have firstCoordinate (index : Fin 5) :
        vector index.castSucc = vector 5 := by
      have equality := congrFun
        (show sixPointIntegralDifferenceCoordinates vector = 0 from kernel)
        index
      simpa [sixPointIntegralDifferenceCoordinates, sub_eq_zero] using equality
    have coordinateEquality : vector 5 = vector coordinate := by
      fin_cases coordinate
      · exact (firstCoordinate 0).symm
      · exact (firstCoordinate 1).symm
      · exact (firstCoordinate 2).symm
      · exact (firstCoordinate 3).symm
      · exact (firstCoordinate 4).symm
      · rfl
    simpa only [Pi.smul_apply, smul_eq_mul, mul_one] using coordinateEquality
  · intro vector member
    rw [sixPointIntegralConstantLine, Submodule.mem_span_singleton] at member
    obtain ⟨scalar, rfl⟩ := member
    rw [LinearMap.mem_ker]
    ext index
    simp [sixPointIntegralDifferenceCoordinates]

/-- Difference coordinates are onto the five-coordinate integral module. -/
theorem sixPointIntegralDifferenceCoordinates_surjective :
    Function.Surjective sixPointIntegralDifferenceCoordinates := by
  intro vector
  refine ⟨![vector 0, vector 1, vector 2, vector 3, vector 4, 0], ?_⟩
  ext index
  fin_cases index <;>
    simp [sixPointIntegralDifferenceCoordinates]

/-- Difference coordinates descended to the quotient by the constant line. -/
def sixPointIntegralDifferenceDescent :
    SixPointIntegralCoefficientQuotient →ₗ[ℤ] (Fin 5 → ℤ) :=
  sixPointIntegralConstantLine.liftQ
    sixPointIntegralDifferenceCoordinates (by
      rw [← sixPointIntegralDifferenceCoordinates_ker])

/-- The descended difference-coordinate map is bijective. -/
theorem sixPointIntegralDifferenceDescent_bijective :
    Function.Bijective sixPointIntegralDifferenceDescent := by
  constructor
  · apply LinearMap.ker_eq_bot.mp
    exact Submodule.ker_liftQ_eq_bot'
      sixPointIntegralConstantLine sixPointIntegralDifferenceCoordinates
      sixPointIntegralDifferenceCoordinates_ker.symm
  · intro vector
    obtain ⟨representative, equality⟩ :=
      sixPointIntegralDifferenceCoordinates_surjective vector
    refine ⟨Submodule.Quotient.mk representative, ?_⟩
    change sixPointIntegralDifferenceCoordinates representative = vector
    exact equality

/-- The integral quotient by the constant line is linearly equivalent to five
integral coordinates. -/
noncomputable def sixPointIntegralCoefficientQuotientEquivFive :
    SixPointIntegralCoefficientQuotient ≃ₗ[ℤ] (Fin 5 → ℤ) :=
  LinearEquiv.ofBijective sixPointIntegralDifferenceDescent
    sixPointIntegralDifferenceDescent_bijective

/-- The quotient equivalence is induced by subtracting the sixth coordinate. -/
@[simp]
theorem sixPointIntegralCoefficientQuotientEquivFive_mk
    (vector : Fin 6 → ℤ) :
    sixPointIntegralCoefficientQuotientEquivFive
        (Submodule.Quotient.mk vector) =
      sixPointIntegralDifferenceCoordinates vector :=
  rfl

/-- The symmetric six-coordinate form whose radical contains the constant
line. -/
def sixPointIntegralQuotientPairing
    (left right : Fin 6 → ℤ) : ℤ :=
  6 * ∑ index, left index * right index -
    (∑ index, left index) * (∑ index, right index)

/-- The six-coordinate form is additive in its first variable. -/
theorem sixPointIntegralQuotientPairing_add_left
    (left right test : Fin 6 → ℤ) :
    sixPointIntegralQuotientPairing (left + right) test =
      sixPointIntegralQuotientPairing left test +
        sixPointIntegralQuotientPairing right test := by
  simp only [sixPointIntegralQuotientPairing, Pi.add_apply, add_mul]
  rw [Finset.sum_add_distrib, Finset.sum_add_distrib]
  ring

/-- The six-coordinate form is integral-linear in its first variable. -/
theorem sixPointIntegralQuotientPairing_smul_left
    (scalar : ℤ) (left right : Fin 6 → ℤ) :
    sixPointIntegralQuotientPairing (scalar • left) right =
      scalar • sixPointIntegralQuotientPairing left right := by
  simp only [sixPointIntegralQuotientPairing, Pi.smul_apply, smul_eq_mul]
  simp_rw [mul_assoc]
  rw [← Finset.mul_sum, ← Finset.mul_sum]
  ring

/-- The six-coordinate form is symmetric. -/
theorem sixPointIntegralQuotientPairing_comm
    (left right : Fin 6 → ℤ) :
    sixPointIntegralQuotientPairing left right =
      sixPointIntegralQuotientPairing right left := by
  unfold sixPointIntegralQuotientPairing
  have productSum : (∑ index, left index * right index) =
      ∑ index, right index * left index := by
    apply Finset.sum_congr rfl
    intro index _
    rw [mul_comm]
  rw [productSum, mul_comm (∑ index, left index) (∑ index, right index)]

/-- The six-coordinate form is additive in its second variable. -/
theorem sixPointIntegralQuotientPairing_add_right
    (left right test : Fin 6 → ℤ) :
    sixPointIntegralQuotientPairing left (right + test) =
      sixPointIntegralQuotientPairing left right +
        sixPointIntegralQuotientPairing left test := by
  rw [sixPointIntegralQuotientPairing_comm left,
    sixPointIntegralQuotientPairing_add_left,
    sixPointIntegralQuotientPairing_comm right left,
    sixPointIntegralQuotientPairing_comm test left]

/-- The six-coordinate form is integral-linear in its second variable. -/
theorem sixPointIntegralQuotientPairing_smul_right
    (scalar : ℤ) (left right : Fin 6 → ℤ) :
    sixPointIntegralQuotientPairing left (scalar • right) =
      scalar • sixPointIntegralQuotientPairing left right := by
  rw [sixPointIntegralQuotientPairing_comm left,
    sixPointIntegralQuotientPairing_smul_left,
    sixPointIntegralQuotientPairing_comm right left]

/-- The six-coordinate form bundled as an integral bilinear form. -/
def sixPointIntegralQuotientBilinForm :
    LinearMap.BilinForm ℤ (Fin 6 → ℤ) :=
  LinearMap.mk₂ ℤ sixPointIntegralQuotientPairing
    sixPointIntegralQuotientPairing_add_left
    sixPointIntegralQuotientPairing_smul_left
    sixPointIntegralQuotientPairing_add_right
    sixPointIntegralQuotientPairing_smul_right

/-- Evaluation of the bundled form is the displayed integral formula. -/
@[simp]
theorem sixPointIntegralQuotientBilinForm_apply
    (left right : Fin 6 → ℤ) :
    sixPointIntegralQuotientBilinForm left right =
      sixPointIntegralQuotientPairing left right :=
  rfl

/-- The constant line lies in the left radical of the integral form. -/
theorem sixPointIntegralConstantLine_le_pairing_ker :
    sixPointIntegralConstantLine ≤ sixPointIntegralQuotientBilinForm.ker := by
  rw [sixPointIntegralConstantLine, Submodule.span_singleton_le_iff_mem,
    LinearMap.mem_ker]
  apply LinearMap.ext
  intro right
  simp [sixPointIntegralQuotientPairing, Finset.mul_sum]

/-- The constant line lies in the right radical of the integral form. -/
theorem sixPointIntegralConstantLine_le_pairing_flip_ker :
    sixPointIntegralConstantLine ≤
      sixPointIntegralQuotientBilinForm.flip.ker := by
  rw [sixPointIntegralConstantLine, Submodule.span_singleton_le_iff_mem,
    LinearMap.mem_ker]
  apply LinearMap.ext
  intro left
  simp [sixPointIntegralQuotientPairing, Finset.mul_sum,
    mul_comm]

/-- The integral form descended in both variables to the quotient by the
constant line. -/
def sixPointIntegralDescendedPairing :
    LinearMap.BilinForm ℤ SixPointIntegralCoefficientQuotient :=
  sixPointIntegralQuotientBilinForm.liftQ₂
    sixPointIntegralConstantLine sixPointIntegralConstantLine
    sixPointIntegralConstantLine_le_pairing_ker
    sixPointIntegralConstantLine_le_pairing_flip_ker

/-- The descended form evaluates on representatives by the original
six-coordinate formula. -/
@[simp]
theorem sixPointIntegralDescendedPairing_mk
    (left right : Fin 6 → ℤ) :
    sixPointIntegralDescendedPairing
        (Submodule.Quotient.mk left) (Submodule.Quotient.mk right) =
      sixPointIntegralQuotientPairing left right :=
  rfl

/-- A permutation of the six labels acts linearly on integral coordinate
families by inverse precomposition. -/
def sixPointIntegralPermutationLinear
    (permutation : Equiv.Perm (Fin 6)) :
    (Fin 6 → ℤ) →ₗ[ℤ] (Fin 6 → ℤ) where
  toFun vector := fun index ↦ vector (permutation⁻¹ index)
  map_add' left right := by rfl
  map_smul' scalar vector := by rfl

/-- Every coordinate permutation preserves the constant line. -/
theorem sixPointIntegralPermutationLinear_constantLine
    (permutation : Equiv.Perm (Fin 6)) :
    ∀ vector ∈ sixPointIntegralConstantLine,
      sixPointIntegralPermutationLinear permutation vector ∈
        sixPointIntegralConstantLine := by
  intro vector member
  rw [sixPointIntegralConstantLine, Submodule.mem_span_singleton] at member ⊢
  obtain ⟨scalar, rfl⟩ := member
  refine ⟨scalar, ?_⟩
  funext index
  simp [sixPointIntegralPermutationLinear]

/-- Permute an integral representative and then take its quotient class. -/
def sixPointIntegralPermutationToQuotient
    (permutation : Equiv.Perm (Fin 6)) :
    (Fin 6 → ℤ) →ₗ[ℤ] SixPointIntegralCoefficientQuotient where
  toFun vector := Submodule.Quotient.mk
    (sixPointIntegralPermutationLinear permutation vector)
  map_add' left right := by rfl
  map_smul' scalar vector := by rfl

/-- The linear map induced by a permutation on the integral quotient. -/
def sixPointIntegralQuotientPermutation
    (permutation : Equiv.Perm (Fin 6)) :
    SixPointIntegralCoefficientQuotient →ₗ[ℤ]
      SixPointIntegralCoefficientQuotient :=
  sixPointIntegralConstantLine.liftQ
    (sixPointIntegralPermutationToQuotient permutation) (by
        intro vector member
        rw [LinearMap.mem_ker]
        change Submodule.Quotient.mk
          (sixPointIntegralPermutationLinear permutation vector) = 0
        rw [Submodule.Quotient.mk_eq_zero]
        exact sixPointIntegralPermutationLinear_constantLine
          permutation vector member)

/-- The quotient permutation map acts on a representative by permuting that
representative. -/
@[simp]
theorem sixPointIntegralQuotientPermutation_mk
    (permutation : Equiv.Perm (Fin 6)) (vector : Fin 6 → ℤ) :
    sixPointIntegralQuotientPermutation permutation
        (Submodule.Quotient.mk vector) =
      Submodule.Quotient.mk
        (sixPointIntegralPermutationLinear permutation vector) :=
  rfl

/-- The identity permutation induces the identity map on the quotient. -/
theorem sixPointIntegralQuotientPermutation_one
    (vector : SixPointIntegralCoefficientQuotient) :
    sixPointIntegralQuotientPermutation 1 vector = vector := by
  refine Submodule.Quotient.induction_on sixPointIntegralConstantLine vector ?_
  intro representative
  rfl

/-- Products of permutations act by composition on the quotient. -/
theorem sixPointIntegralQuotientPermutation_mul
    (left right : Equiv.Perm (Fin 6))
    (vector : SixPointIntegralCoefficientQuotient) :
    sixPointIntegralQuotientPermutation (left * right) vector =
      sixPointIntegralQuotientPermutation left
        (sixPointIntegralQuotientPermutation right vector) := by
  refine Submodule.Quotient.induction_on sixPointIntegralConstantLine vector ?_
  intro representative
  change Submodule.Quotient.mk
      (sixPointIntegralPermutationLinear (left * right) representative) =
    Submodule.Quotient.mk
      (sixPointIntegralPermutationLinear left
        (sixPointIntegralPermutationLinear right representative))
  congr 1

/-- The six-coordinate form is invariant under every permutation of the six
labels. -/
theorem sixPointIntegralQuotientPairing_permutation
    (permutation : Equiv.Perm (Fin 6)) (left right : Fin 6 → ℤ) :
    sixPointIntegralQuotientPairing
        (sixPointIntegralPermutationLinear permutation left)
        (sixPointIntegralPermutationLinear permutation right) =
      sixPointIntegralQuotientPairing left right := by
  change sixPointIntegralQuotientPairing
      (fun index ↦ left (permutation⁻¹ index))
      (fun index ↦ right (permutation⁻¹ index)) =
    sixPointIntegralQuotientPairing left right
  unfold sixPointIntegralQuotientPairing
  rw [Fintype.sum_equiv permutation⁻¹
      (fun index ↦ left (permutation⁻¹ index) *
        right (permutation⁻¹ index))
      (fun index ↦ left index * right index) (fun _ ↦ rfl),
    Fintype.sum_equiv permutation⁻¹
      (fun index ↦ left (permutation⁻¹ index)) left (fun _ ↦ rfl),
    Fintype.sum_equiv permutation⁻¹
      (fun index ↦ right (permutation⁻¹ index)) right (fun _ ↦ rfl)]

/-- The descended integral form is invariant under every induced quotient
permutation. -/
theorem sixPointIntegralDescendedPairing_permutation
    (permutation : Equiv.Perm (Fin 6))
    (left right : SixPointIntegralCoefficientQuotient) :
    sixPointIntegralDescendedPairing
        (sixPointIntegralQuotientPermutation permutation left)
        (sixPointIntegralQuotientPermutation permutation right) =
      sixPointIntegralDescendedPairing left right := by
  refine Submodule.Quotient.induction_on sixPointIntegralConstantLine left ?_
  intro leftRepresentative
  refine Submodule.Quotient.induction_on sixPointIntegralConstantLine right ?_
  intro rightRepresentative
  exact sixPointIntegralQuotientPairing_permutation permutation
    leftRepresentative rightRepresentative

/-- The representative with prescribed first five coordinates and sixth
coordinate zero. -/
def sixPointIntegralRepresentativeFromFive :
    (Fin 5 → ℤ) →ₗ[ℤ] (Fin 6 → ℤ) where
  toFun vector := ![vector 0, vector 1, vector 2, vector 3, vector 4, 0]
  map_add' left right := by
    ext index
    fin_cases index <;> simp
  map_smul' scalar vector := by
    ext index
    fin_cases index <;> simp

/-- The five-coordinate chart regarded as quotient classes. -/
def sixPointIntegralClassFromFive :
    (Fin 5 → ℤ) →ₗ[ℤ] SixPointIntegralCoefficientQuotient :=
  sixPointIntegralConstantLine.mkQ.comp sixPointIntegralRepresentativeFromFive

/-- The quotient chart and the five-coordinate equivalence are inverse on
five-coordinate vectors. -/
@[simp]
theorem sixPointIntegralCoefficientQuotientEquivFive_classFromFive
    (vector : Fin 5 → ℤ) :
    sixPointIntegralCoefficientQuotientEquivFive
        (sixPointIntegralClassFromFive vector) = vector := by
  rw [show sixPointIntegralClassFromFive vector =
      Submodule.Quotient.mk
        (sixPointIntegralRepresentativeFromFive vector) by rfl,
    sixPointIntegralCoefficientQuotientEquivFive_mk]
  ext index
  fin_cases index <;>
    simp [sixPointIntegralRepresentativeFromFive,
      sixPointIntegralDifferenceCoordinates]

/-- In the five-coordinate quotient chart, the descended form is represented
by the matrix `6I₅-J₅`. -/
theorem sixPointIntegralDescendedPairing_classFromFive
    (left right : Fin 5 → ℤ) :
    sixPointIntegralDescendedPairing
        (sixPointIntegralClassFromFive left)
        (sixPointIntegralClassFromFive right) =
      dotProduct left (Matrix.mulVec (sixAxisGram ℤ) right) := by
  rw [show sixPointIntegralClassFromFive left =
      Submodule.Quotient.mk (sixPointIntegralRepresentativeFromFive left) by rfl,
    show sixPointIntegralClassFromFive right =
      Submodule.Quotient.mk (sixPointIntegralRepresentativeFromFive right) by rfl,
    sixPointIntegralDescendedPairing_mk]
  simp only [sixPointIntegralQuotientPairing, dotProduct,
    sixPointIntegralRepresentativeFromFive]
  simp_rw [sixAxisGram_mulVec]
  simp [Fin.sum_univ_succ]
  ring

end GraphLattices

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
