import RelativeConicArcs.ClebschBalancedSheets
import RelativeConicArcs.ClebschFactorizationH3

/-!
# Balanced sheets for the twenty-two-point `H3` factorization configuration

The twenty-two quotient vectors over `𝔽₁₁` are ordered into the two eleven-point orbits of the
index-two projective special linear subgroup.  Ten checked affine coefficients on each sheet map
to a standard basis of its zero-sum hyperplane.  The displayed second-moment radical takes the
distinct constant values `0` and `1`, and a named quadratic pairing is nonzero.  The abstract
Hadamard-square theorem therefore proves the trade-line classification without enumerating any
eleven-subsets.
-/

namespace RelativeConicArcs
namespace ClebschBalancedSheets

open scoped BigOperators
open ClebschFactorization
open Matrix

/-- Indices of the positive `H3` sheet in the frozen twenty-two-vector ordering. -/
def h3LeftIndex : Fin 11 → Fin 22 := ![0, 3, 4, 6, 9, 11, 13, 15, 17, 18, 20]

/-- Indices of the negative `H3` sheet in the frozen twenty-two-vector ordering. -/
def h3RightIndex : Fin 11 → Fin 22 := ![1, 2, 5, 7, 8, 10, 12, 14, 16, 19, 21]

/-- Quotient-coordinate vectors on the positive `H3` sheet. -/
def h3LeftPoints : Fin 11 → Fin 10 → ZMod 11 := fun i ↦ h3Vectors (h3LeftIndex i)

/-- Quotient-coordinate vectors on the negative `H3` sheet. -/
def h3RightPoints : Fin 11 → Fin 10 → ZMod 11 := fun i ↦ h3Vectors (h3RightIndex i)

private def h3LeftRawDecoder (u : Fin 11 → ZMod 11) : ZMod 11 × (Fin 10 → ZMod 11) :=
  let w : Fin 10 → ZMod 11 := ![
    u 0,
    4 * u 0 + 2 * u 1 + 4 * u 2 + 2 * u 4 + 2 * u 5 + 2 * u 6 + 2 * u 8 + 4 * u 9,
    2 * u 2 + 9 * u 3 + 2 * u 4 + 9 * u 5 + 9 * u 8 + 2 * u 9,
    10 * u 0 + u 1,
    10 * u 0 + u 2,
    2 * u 0 + 4 * u 2 + 4 * u 4 + 2 * u 5 + 4 * u 6 + 2 * u 7 + 2 * u 8 + 2 * u 9,
    10 * u 0 + u 3,
    4 * u 0 + 2 * u 1 + 4 * u 2 + 2 * u 3 + 2 * u 4 + 4 * u 6 + 2 * u 7 + 2 * u 9,
    4 * u 0 + 2 * u 2 + 2 * u 3 + 4 * u 4 + 2 * u 5 + 2 * u 6 + 2 * u 7 + 4 * u 9,
    10 * u 0 + u 4]
  ⟨w 0, ![w 1, w 2, w 3, w 4, w 5, w 6, w 7, w 8, w 9, 0]⟩

private def h3RightRawDecoder (u : Fin 11 → ZMod 11) : ZMod 11 × (Fin 10 → ZMod 11) :=
  let w : Fin 10 → ZMod 11 := ![
    u 5,
    u 0 + 10 * u 5,
    u 1 + 10 * u 5,
    2 * u 0 + 4 * u 1 + 2 * u 2 + 2 * u 3 + 4 * u 5 + 2 * u 6 + 4 * u 8 + 2 * u 9,
    2 * u 1 + 2 * u 2 + 9 * u 4 + 9 * u 6 + 9 * u 7 + 2 * u 9,
    u 2 + 10 * u 5,
    9 * u 0 + 2 * u 5 + 9 * u 6 + 9 * u 7 + 2 * u 8 + 2 * u 9,
    u 3 + 10 * u 5,
    u 4 + 10 * u 5,
    9 * u 0 + 2 * u 1 + 2 * u 2 + 9 * u 3 + 9 * u 7 + 2 * u 8]
  ⟨w 0, ![w 1, w 2, w 3, w 4, w 5, w 6, w 7, w 8, w 9, 0]⟩

private def h3ZeroSumBasis (j : Fin 10) (i : Fin 11) : ZMod 11 :=
  if i = j.castSucc then 1 else if i = Fin.last 10 then -1 else 0

private def h3LeftBasisCoefficient (j : Fin 10) : ZMod 11 × (Fin 10 → ZMod 11) :=
  h3LeftRawDecoder (h3ZeroSumBasis j)

private def h3RightBasisCoefficient (j : Fin 10) : ZMod 11 × (Fin 10 → ZMod 11) :=
  h3RightRawDecoder (h3ZeroSumBasis j)

private theorem h3LeftBasisCoefficient_eval (j : Fin 10) (i : Fin 11) :
    affineValue (h3LeftBasisCoefficient j) (h3LeftPoints i) = h3ZeroSumBasis j i := by
  fin_cases j <;> fin_cases i <;> decide

private theorem h3RightBasisCoefficient_eval (j : Fin 10) (i : Fin 11) :
    affineValue (h3RightBasisCoefficient j) (h3RightPoints i) = h3ZeroSumBasis j i := by
  fin_cases j <;> fin_cases i <;> decide

private def h3LeftDecoder (u : Fin 11 → ZMod 11) : ZMod 11 × (Fin 10 → ZMod 11) :=
  ∑ j, u j.castSucc • h3LeftBasisCoefficient j

private def h3RightDecoder (u : Fin 11 → ZMod 11) : ZMod 11 × (Fin 10 → ZMod 11) :=
  ∑ j, u j.castSucc • h3RightBasisCoefficient j

/-- Both `H3` affine restriction maps surject onto the ten-dimensional zero-sum hyperplanes. -/
theorem h3_restrictsOntoZeroSum :
    RestrictsOntoZeroSum (affineEvaluationSpace h3LeftPoints h3RightPoints) := by
  apply restrictsOntoZeroSum_of_decoders h3LeftPoints h3RightPoints h3LeftDecoder h3RightDecoder
  · intro u hu i
    rw [h3LeftDecoder, affineValue_sum_smul]
    simp_rw [h3LeftBasisCoefficient_eval]
    fin_cases i <;> simp [h3ZeroSumBasis, Fin.sum_univ_succ] at hu ⊢
    linear_combination -hu
  · intro u hu i
    rw [h3RightDecoder, affineValue_sum_smul]
    simp_rw [h3RightBasisCoefficient_eval]
    fin_cases i <;> simp [h3ZeroSumBasis, Fin.sum_univ_succ] at hu ⊢
    linear_combination -hu

/-- The `H3` second-moment radical covector in the transported quotient coordinates. -/
def h3RadicalCovector : Fin 10 → ZMod 11 := ![1, 1, 0, 0, 1, 0, 1, 1, 0, 1]

private def h3MomentComplement : Matrix (Fin 10) (Fin 9) (ZMod 11) := ![
  ![0, 0, 0, 0, 0, 0, 0, 0, 0],
  ![1, 0, 0, 0, 0, 0, 0, 0, 0],
  ![0, 1, 0, 0, 0, 0, 0, 0, 0],
  ![0, 0, 1, 0, 0, 0, 0, 0, 0],
  ![0, 0, 0, 1, 0, 0, 0, 0, 0],
  ![0, 0, 0, 0, 1, 0, 0, 0, 0],
  ![0, 0, 0, 0, 0, 1, 0, 0, 0],
  ![0, 0, 0, 0, 0, 0, 1, 0, 0],
  ![0, 0, 0, 0, 0, 0, 0, 1, 0],
  ![0, 0, 0, 0, 0, 0, 0, 0, 1]]

private def h3MomentRecover : Matrix (Fin 9) (Fin 10) (ZMod 11) := ![
  ![5, 6, 1, 1, 0, 1, 0, 0, 2, 0],
  ![10, 0, 1, 6, 10, 6, 10, 9, 6, 0],
  ![0, 1, 6, 1, 1, 6, 0, 10, 6, 0],
  ![5, 0, 0, 1, 6, 1, 0, 0, 2, 0],
  ![9, 10, 6, 6, 10, 1, 10, 10, 6, 0],
  ![5, 0, 0, 0, 0, 1, 6, 0, 0, 0],
  ![5, 0, 10, 10, 0, 1, 0, 6, 1, 0],
  ![10, 1, 6, 6, 1, 6, 10, 0, 1, 0],
  ![10, 5, 1, 0, 5, 2, 5, 5, 1, 0]]

private def h3MomentProject (v : Fin 10 → ZMod 11) : Fin 9 → ZMod 11 :=
  ![v 1 - v 0, v 2, v 3, v 4 - v 0, v 5, v 6 - v 0, v 7 - v 0, v 8, v 9 - v 0]

private def h3MomentCoefficient (v : Fin 10 → ZMod 11) : ZMod 11 := v 0

private theorem h3_moment_recovery_certificate :
    h3MomentRecover * secondMomentMatrix h3Vectors * h3MomentComplement = 1 := by
  decide

private theorem h3_radical_annihilates_secondMoment :
    secondMomentMatrix h3Vectors *ᵥ h3RadicalCovector = 0 := by
  decide

private theorem h3_moment_decomposition (v : Fin 10 → ZMod 11) :
    v = h3MomentComplement *ᵥ h3MomentProject v +
      h3MomentCoefficient v • h3RadicalCovector := by
  funext i
  fin_cases i <;>
    simp [h3MomentComplement, h3MomentProject, h3MomentCoefficient, h3RadicalCovector,
      Matrix.mulVec]

/-- The kernel of the `H3` second-moment matrix is exactly the line spanned by the displayed
radical covector; in particular its rank and radical dimensions are `9/1`. -/
theorem h3_secondMoment_kernel_eq_radicalLine (v : Fin 10 → ZMod 11) :
    secondMomentMatrix h3Vectors *ᵥ v = 0 ↔
      ∃ c : ZMod 11, v = c • h3RadicalCovector :=
  matrix_kernel_eq_line_of_recovery (secondMomentMatrix h3Vectors) h3RadicalCovector
    h3MomentComplement h3MomentRecover h3MomentProject h3MomentCoefficient
    h3_moment_recovery_certificate h3_radical_annihilates_secondMoment h3_moment_decomposition v

/-- Three generators of the special-subgroup action followed by one outer generator, recorded as
permutations of the twenty-two quotient vectors. -/
def h3ActionPermutation : Fin 4 → Fin 22 → Fin 22 := ![
  ![0, 1, 5, 4, 17, 16, 20, 21, 12, 13, 2, 3, 7, 6, 8, 9, 19, 18, 11, 10, 15, 14],
  ![3, 2, 5, 4, 15, 14, 6, 7, 16, 17, 19, 18, 1, 0, 12, 13, 21, 20, 9, 8, 11, 10],
  ![0, 1, 16, 18, 17, 5, 20, 14, 12, 9, 19, 11, 8, 15, 7, 13, 2, 4, 3, 10, 6, 21],
  ![1, 0, 6, 7, 21, 20, 5, 4, 11, 10, 13, 12, 3, 2, 18, 19, 15, 14, 8, 9, 16, 17]]

/-- Linear parts of the four displayed affine actions on the `H3` quotient coordinates. -/
def h3ActionLinear : Fin 4 → Matrix (Fin 10) (Fin 10) (ZMod 11) := ![
  ![![1, 0, 0, 5, 1, 6, 1, 4, 6, 0], ![0, 0, 0, 7, 1, 10, 0, 3, 10, 1],
    ![0, 0, 0, 5, 0, 6, 5, 3, 7, 0], ![0, 0, 1, 9, 5, 1, 0, 6, 0, 0],
    ![0, 1, 0, 8, 1, 9, 10, 9, 4, 0], ![0, 0, 0, 8, 6, 5, 0, 2, 6, 0],
    ![0, 0, 0, 9, 0, 7, 1, 0, 7, 0], ![0, 0, 0, 5, 10, 0, 10, 1, 0, 0],
    ![0, 0, 0, 5, 0, 5, 6, 3, 4, 0], ![0, 0, 0, 10, 10, 1, 1, 6, 6, 0]],
  ![![0, 0, 0, 10, 0, 0, 0, 1, 5, 4], ![1, 0, 0, 7, 2, 0, 0, 1, 7, 4],
    ![10, 10, 10, 5, 10, 10, 10, 10, 4, 2], ![0, 0, 1, 10, 5, 0, 0, 5, 9, 6],
    ![0, 1, 0, 8, 2, 0, 0, 1, 8, 10], ![0, 0, 0, 7, 6, 1, 0, 6, 8, 8],
    ![0, 0, 0, 9, 10, 0, 1, 0, 9, 10], ![0, 0, 0, 0, 10, 0, 0, 10, 5, 1],
    ![0, 0, 0, 4, 5, 0, 0, 0, 5, 8], ![0, 0, 0, 10, 10, 0, 0, 10, 10, 5]],
  ![![1, 1, 0, 5, 0, 6, 0, 4, 0, 4], ![0, 1, 6, 7, 0, 10, 2, 3, 0, 4],
    ![0, 0, 1, 5, 0, 6, 0, 3, 0, 3], ![0, 5, 10, 9, 0, 1, 5, 6, 0, 6],
    ![0, 1, 6, 8, 1, 9, 2, 9, 0, 10], ![0, 6, 2, 8, 0, 5, 6, 2, 0, 8],
    ![0, 0, 5, 9, 0, 7, 10, 0, 0, 10], ![0, 10, 0, 5, 0, 0, 10, 1, 0, 1],
    ![0, 0, 9, 5, 0, 5, 5, 3, 1, 8], ![0, 10, 5, 10, 0, 1, 10, 6, 0, 5]],
  ![![10, 10, 10, 0, 5, 10, 10, 5, 10, 5], ![0, 0, 0, 0, 10, 0, 0, 4, 0, 10],
    ![0, 0, 0, 5, 6, 0, 0, 7, 0, 7], ![0, 0, 0, 0, 1, 0, 1, 2, 0, 0],
    ![0, 0, 0, 10, 9, 1, 0, 9, 0, 4], ![0, 1, 0, 0, 5, 0, 0, 4, 0, 6],
    ![0, 0, 1, 1, 7, 0, 0, 7, 0, 7], ![0, 0, 0, 10, 0, 0, 0, 6, 0, 0],
    ![0, 0, 0, 6, 5, 0, 0, 5, 0, 4], ![0, 0, 0, 1, 1, 0, 0, 1, 1, 6]]]

/-- Translation parts of the four displayed affine actions on the `H3` quotient coordinates. -/
def h3ActionTranslation : Fin 4 → Fin 10 → ZMod 11 := ![
  ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0], ![0, 0, 1, 0, 0, 0, 0, 0, 0, 0],
  ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0], ![1, 0, 0, 0, 0, 0, 0, 0, 0, 0]]

/-- All four displayed `H3` generators act affinely on every quotient vector. -/
theorem h3_actionGenerators_areAffine :
    IsAffinePermutationAction h3Vectors h3ActionPermutation h3ActionLinear h3ActionTranslation := by
  intro g i
  funext j
  fin_cases g <;> fin_cases i <;> fin_cases j <;> decide

/-- Every displayed `H3` action generator is a permutation. -/
theorem h3_actionPermutation_bijective (g : Fin 4) :
    Function.Bijective (h3ActionPermutation g) := by
  fin_cases g <;> decide

/-- The three displayed special-subgroup generators preserve the `H3` sheet sign. -/
theorem h3_specialGenerators_preserve_sheetSign (g : Fin 3) (i : Fin 22) :
    h3SheetSigns (h3ActionPermutation g.castSucc i) = h3SheetSigns i := by
  fin_cases g <;> fin_cases i <;> decide

/-- The displayed outer generator negates the `H3` sheet sign. -/
theorem h3_outerGenerator_negates_sheetSign (i : Fin 22) :
    h3SheetSigns (h3ActionPermutation (Fin.last 3) i) = -h3SheetSigns i := by
  fin_cases i <;> decide

/-- The concrete signed cubic tensor of the twenty-two `H3` quotient vectors. -/
def h3SignedCubicTensor : CubicTensor 10 (ZMod 11) :=
  signedCubicTensor h3Vectors h3SheetSigns

/-- The concrete `H3` signed cubic is nonzero, witnessed by its imported `x₀³` coordinate. -/
theorem h3_signedCubicTensor_ne_zero : h3SignedCubicTensor ≠ 0 := by
  intro hzero
  have hcoord := congrFun (congrFun (congrFun hzero 0) 0) 0
  apply h3_signedCubicCoordinate_ne_zero
  simpa [h3SignedCubicTensor, signedCubicCoordinate] using hcoord

/-- The four frozen permutation tables as actual equivalences. -/
noncomputable def h3ActionEquiv (g : Fin 4) : Equiv.Perm (Fin 22) :=
  Equiv.ofBijective (h3ActionPermutation g) (h3_actionPermutation_bijective g)

/-- Character values of the three special generators and the outer generator. -/
def h3ActionCharacter : Fin 4 → (ZMod 11)ˣ := ![1, 1, 1, -1]

/-- Each displayed generator, paired with its checked sheet multiplier, is an element of the
explicit signed-symmetry group. -/
noncomputable def h3SignedGenerator (g : Fin 4) : signedSymmetryGroup h3SheetSigns :=
  ⟨⟨h3ActionEquiv g, h3ActionCharacter g⟩, by
    intro i
    fin_cases g <;> fin_cases i <;> decide⟩

/-- The concrete action group generated by the four frozen `H3` tables. -/
noncomputable def h3GeneratedSignedAction : Subgroup (signedSymmetryGroup h3SheetSigns) :=
  Subgroup.closure (Set.range h3SignedGenerator)

/-- Each frozen signed generator belongs to the subgroup generated by the four displayed actions. -/
theorem h3_signedGenerator_mem_generated (g : Fin 4) :
    h3SignedGenerator g ∈ h3GeneratedSignedAction := by
  apply Subgroup.subset_closure
  exact ⟨g, rfl⟩

/-- The cubic coordinate function that witnesses the first nonzero graded part of the signed
evaluation functional. -/
def h3CubicEvaluation (i : Fin 22) : ZMod 11 := h3Vectors i 0 ^ 3

/-- The displayed cubic evaluation has nonzero signed value `3` over `ZMod 11`. -/
theorem h3_signedEvaluation_cubicWitness :
    signedEvaluationFunctional h3SheetSigns h3CubicEvaluation = 3 := by
  simpa [signedEvaluationFunctional, h3CubicEvaluation, signedCubicCoordinate, pow_three,
    mul_assoc] using h3_signedCubicCoordinate_zero_zero_zero

/-- The signed cubic functional transforms by the character in the explicit group generated by
the four displayed `H3` actions. -/
theorem h3_signedCubic_isRelativeInvariant (g : h3GeneratedSignedAction) :
    signedSubgroupAction g =
      (signedSubgroupCharacter h3GeneratedSignedAction g : ZMod 11) •
        signedEvaluationFunctional h3SheetSigns :=
  signedSubgroupAction_eq_character_smul g

/-- The stabilizer of the nonzero signed cubic functional in the explicitly generated `H3` action
is exactly the kernel of the sheet character. -/
theorem h3_signedCubic_stabilizer_eq_characterKernel :
    {g : h3GeneratedSignedAction |
      signedSubgroupAction g = signedEvaluationFunctional h3SheetSigns} =
      {g : h3GeneratedSignedAction |
        signedSubgroupCharacter h3GeneratedSignedAction g = 1} := by
  apply signedSubgroup_stabilizer_eq_characterKernel h3GeneratedSignedAction h3CubicEvaluation
  · rw [h3_signedEvaluation_cubicWitness]
    decide
  · decide
  · intro g
    exact signedSymmetryCharacter_eq_one_or_neg_one 0 (by decide)
      (by intro i; fin_cases i <;> decide) g.1

/-- The radical covector evaluates to `0` and `1` on the two `H3` sheets. -/
theorem h3_radical_separates_sheets :
    (∀ i, affineValue ⟨0, h3RadicalCovector⟩ (h3LeftPoints i) = 0) ∧
      (∀ i, affineValue ⟨0, h3RadicalCovector⟩ (h3RightPoints i) = 1) := by
  constructor <;> intro i <;> fin_cases i <;> decide

/-- The two `H3` sheet indicators belong to the affine evaluation space. -/
theorem h3_sheetIndicators_mem :
    leftIndicator ∈ affineEvaluationSpace h3LeftPoints h3RightPoints ∧
      rightIndicator ∈ affineEvaluationSpace h3LeftPoints h3RightPoints := by
  exact affine_indicators_mem_of_separating_coefficient h3LeftPoints h3RightPoints
    ⟨0, h3RadicalCovector⟩ 0 1 zero_ne_one h3_radical_separates_sheets.1
      h3_radical_separates_sheets.2

/-- The frozen `H3` signs and quotient vectors have vanishing signed moments through degree two. -/
theorem h3_signedMomentsThroughTwo : SignedMomentsThroughTwo h3Vectors h3SheetSigns := by
  refine ⟨by decide, ?_, ?_⟩
  · intro j
    have h := congrFun h3_signedFirstMoment_eq_zero j
    simpa [signedFirstMoment] using h
  · intro j k
    have h := congrFun (congrFun h3_signedSecondMoment_eq_zero j) k
    simpa [signedSecondMoment] using h

private theorem h3_grouped_signed_sum (f : Fin 22 → ZMod 11) :
    (∑ i, h3SheetSigns i * f i) =
      (∑ i, f (h3LeftIndex i)) - ∑ i, f (h3RightIndex i) := by
  have h10 : (10 : ZMod 11) = -1 := by decide
  simp [h3SheetSigns, h3LeftIndex, h3RightIndex, Fin.sum_univ_succ, h10]
  ring

/-- Every product of two `H3` affine evaluation functions has equal sums on the two sheets. -/
theorem h3_productsHaveEqualSheetSums :
    ProductsHaveEqualSheetSums (affineEvaluationSpace h3LeftPoints h3RightPoints) := by
  rintro x ⟨left, rfl⟩ y ⟨right, rfl⟩
  have hz := signed_affine_product_eq_zero h3Vectors h3SheetSigns
    h3_signedMomentsThroughTwo left right
  have hz' : ∑ i, h3SheetSigns i *
      (affineValue left (h3Vectors i) * affineValue right (h3Vectors i)) = 0 := by
    simpa [mul_assoc] using hz
  have hg := h3_grouped_signed_sum (fun i ↦
    affineValue left (h3Vectors i) * affineValue right (h3Vectors i))
  rw [hz'] at hg
  apply sub_eq_zero.mp
  simpa [leftSum, rightSum, hadamard, affineEvaluationMap, h3LeftPoints, h3RightPoints] using hg.symm

private def h3QuadraticWitness : ZMod 11 × (Fin 10 → ZMod 11) :=
  ⟨0, ![1, 0, 0, 0, 0, 0, 0, 0, 0, 0]⟩

private theorem h3QuadraticWitness_leftSum :
    leftSum (hadamard
      (affineEvaluationMap h3LeftPoints h3RightPoints h3QuadraticWitness)
      (affineEvaluationMap h3LeftPoints h3RightPoints h3QuadraticWitness)) = 2 := by
    decide

/-- Image, in the affine evaluation space, of the constant direction together with the checked
linear second-moment radical.  This is the coefficient-matrix model of the affine-pairing radical. -/
def h3AffinePairingRadicalImage : Set (SheetPair 11 (ZMod 11)) :=
  {x | ∃ coefficient : ZMod 11 × (Fin 10 → ZMod 11),
    secondMomentMatrix h3Vectors *ᵥ coefficient.2 = 0 ∧
      affineEvaluationMap h3LeftPoints h3RightPoints coefficient = x}

private theorem h3_affineValue_radical (constant c : ZMod 11) (point : Fin 10 → ZMod 11) :
    affineValue ⟨constant, c • h3RadicalCovector⟩ point =
      constant + c * affineValue ⟨0, h3RadicalCovector⟩ point := by
  simp only [affineValue, Pi.smul_apply, zero_add]
  congr 1
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro i _
  ring

/-- The two-dimensional `H3` affine-pairing radical is exactly the plane spanned by the two
sheet-constant indicator lines. -/
theorem h3_affinePairingRadical_eq_sheetConstantPlane (x : SheetPair 11 (ZMod 11)) :
    x ∈ h3AffinePairingRadicalImage ↔
      ∃ left right : ZMod 11, x = left • leftIndicator + right • rightIndicator := by
  constructor
  · rintro ⟨coefficient, hkernel, rfl⟩
    obtain ⟨c, hc⟩ := (h3_secondMoment_kernel_eq_radicalLine coefficient.2).mp hkernel
    refine ⟨coefficient.1, coefficient.1 + c, ?_⟩
    have hcoefficient : coefficient = ⟨coefficient.1, c • h3RadicalCovector⟩ := by
      exact Prod.ext rfl hc
    ext i
    · rw [hcoefficient]
      simp [affineEvaluationMap, leftIndicator, rightIndicator, h3_affineValue_radical,
        h3_radical_separates_sheets.1 i]
    · rw [hcoefficient]
      simp [affineEvaluationMap, leftIndicator, rightIndicator, h3_affineValue_radical,
        h3_radical_separates_sheets.2 i]
  · rintro ⟨left, right, rfl⟩
    refine ⟨⟨left, (right - left) • h3RadicalCovector⟩, ?_, ?_⟩
    · rw [Matrix.mulVec_smul, h3_radical_annihilates_secondMoment, smul_zero]
    · ext i
      · simp [affineEvaluationMap, leftIndicator, rightIndicator, h3_affineValue_radical,
          h3_radical_separates_sheets.1 i]
      · simp [affineEvaluationMap, leftIndicator, rightIndicator, h3_affineValue_radical,
          h3_radical_separates_sheets.2 i]

/-- The outer-odd line in the two sheet-constant directions is exactly the
radical--Hadamard sheet-sign trade. -/
theorem h3_outerOddSheetConstantLine_eq_sheetSign (c : ZMod 11) :
    c • leftIndicator + (-c) • rightIndicator = c • (sheetSign : SheetPair 11 (ZMod 11)) := by
  ext i <;> simp [leftIndicator, rightIndicator, sheetSign]

/-- The coordinate-square pairing `x₀²` has nonzero sum on the positive `H3` sheet. -/
theorem h3_hasNonzeroSheetProduct :
    HasNonzeroSheetProduct (affineEvaluationSpace h3LeftPoints h3RightPoints) := by
  refine ⟨affineEvaluationMap h3LeftPoints h3RightPoints h3QuadraticWitness,
    ⟨h3QuadraticWitness, rfl⟩,
    affineEvaluationMap h3LeftPoints h3RightPoints h3QuadraticWitness,
    ⟨h3QuadraticWitness, rfl⟩, ?_⟩
  rw [h3QuadraticWitness_leftSum]
  decide

/-- The coordinatewise-product square of the `H3` affine evaluation space is the full
equal-sheet-sum hyperplane. -/
theorem h3_hadamardSquare_eq_equalSheetSum :
    hadamardSquare (affineEvaluationSpace h3LeftPoints h3RightPoints) = equalSheetSum :=
  hadamardSquare_eq_equalSheetSum _ h3_sheetIndicators_mem.1 h3_sheetIndicators_mem.2
    h3_restrictsOntoZeroSum h3_productsHaveEqualSheetSums h3_hasNonzeroSheetProduct

/-- Every `H3` strength-two trade is a scalar sheet sign. -/
theorem h3_trade_eq_sheetSignLine (t : SheetPair 11 (ZMod 11)) :
    (∀ x ∈ hadamardSquare (affineEvaluationSpace h3LeftPoints h3RightPoints),
      sheetPairing t x = 0) ↔
      ∃ c : ZMod 11, t = (⟨fun _ ↦ c, fun _ ↦ -c⟩ : SheetPair 11 (ZMod 11)) := by
  rw [h3_hadamardSquare_eq_equalSheetSum]
  exact annihilates_equalSheetSum_iff_eq_sheetSignLine 0 t

/-- The displayed `H3` sheets are the unique complementary `±1` halves with equal moments,
up to exchanging the two halves. -/
theorem h3_balancedHalf_unique (t : SheetPair 11 (ZMod 11))
    (hann : ∀ x ∈ hadamardSquare (affineEvaluationSpace h3LeftPoints h3RightPoints),
      sheetPairing t x = 0)
    (hpmLeft : ∀ i, t.1 i = 1 ∨ t.1 i = -1)
    (hpmRight : ∀ i, t.2 i = 1 ∨ t.2 i = -1) :
    t = sheetSign ∨ t = -sheetSign := by
  rw [h3_hadamardSquare_eq_equalSheetSum] at hann
  exact balancedHalf_unique_of_annihilates 0 t hann hpmLeft hpmRight

end ClebschBalancedSheets
end RelativeConicArcs
