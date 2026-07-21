import RelativeConicArcs.ClebschBalancedSheets
import RelativeConicArcs.ClebschFactorizationB3

/-!
# Balanced sheets for the fourteen-point `B3` factorization configuration

The fourteen quotient vectors over `𝔽₇` are ordered into the two seven-point orbits of the
index-two projective special linear subgroup.  Explicit symbolic decoders prove that both affine
restriction maps cover the zero-sum hyperplane.  The displayed second-moment radical has constant
values `0` and `1` on the two sheets, while a named quadratic pairing is nonzero.  These facts feed
the abstract Hadamard-square theorem; no seven-subset enumeration occurs.
-/

namespace RelativeConicArcs
namespace ClebschBalancedSheets

open scoped BigOperators
open ClebschFactorization
open Matrix

/-- Indices of the positive `B3` sheet in the frozen fourteen-vector ordering. -/
def b3LeftIndex : Fin 7 → Fin 14 := ![0, 2, 4, 6, 9, 10, 13]

/-- Indices of the negative `B3` sheet in the frozen fourteen-vector ordering. -/
def b3RightIndex : Fin 7 → Fin 14 := ![1, 3, 5, 7, 8, 11, 12]

/-- Quotient-coordinate vectors on the positive `B3` sheet. -/
def b3LeftPoints : Fin 7 → Fin 6 → ZMod 7 := fun i ↦ b3Vectors (b3LeftIndex i)

/-- Quotient-coordinate vectors on the negative `B3` sheet. -/
def b3RightPoints : Fin 7 → Fin 6 → ZMod 7 := fun i ↦ b3Vectors (b3RightIndex i)

private def b3LeftDecoder (u : Fin 7 → ZMod 7) : ZMod 7 × (Fin 6 → ZMod 7) :=
  let w : Fin 6 → ZMod 7 := ![
    u 1,
    u 0 + 6 * u 1,
    5 * u 0 + 5 * u 1 + 3 * u 2 + 5 * u 3 + 3 * u 4,
    3 * u 0 + 5 * u 1 + 3 * u 2 + 5 * u 4 + 5 * u 5,
    6 * u 1 + u 2,
    6 * u 1 + u 3]
  ⟨w 0, ![w 1, w 2, w 3, w 4, 0, w 5]⟩

private def b3RightDecoder (u : Fin 7 → ZMod 7) : ZMod 7 × (Fin 6 → ZMod 7) :=
  let w : Fin 6 → ZMod 7 := ![
    u 2,
    5 * u 1 + 2 * u 3 + 2 * u 4 + 5 * u 5,
    u 0 + 6 * u 2,
    u 1 + 6 * u 2,
    3 * u 0 + 3 * u 1 + 5 * u 2 + 5 * u 4 + 5 * u 5,
    5 * u 0 + 5 * u 2 + 2 * u 3 + 2 * u 4]
  ⟨w 0, ![w 1, w 2, w 3, w 4, 0, w 5]⟩

private def b3ZeroSumBasis (j : Fin 6) (i : Fin 7) : ZMod 7 :=
  if i = j.castSucc then 1 else if i = Fin.last 6 then -1 else 0

private def b3LeftBasisCoefficient (j : Fin 6) : ZMod 7 × (Fin 6 → ZMod 7) :=
  b3LeftDecoder (b3ZeroSumBasis j)

private def b3RightBasisCoefficient (j : Fin 6) : ZMod 7 × (Fin 6 → ZMod 7) :=
  b3RightDecoder (b3ZeroSumBasis j)

private theorem b3LeftBasisCoefficient_eval (j : Fin 6) (i : Fin 7) :
    affineValue (b3LeftBasisCoefficient j) (b3LeftPoints i) = b3ZeroSumBasis j i := by
  fin_cases j <;> fin_cases i <;> decide

private theorem b3RightBasisCoefficient_eval (j : Fin 6) (i : Fin 7) :
    affineValue (b3RightBasisCoefficient j) (b3RightPoints i) = b3ZeroSumBasis j i := by
  fin_cases j <;> fin_cases i <;> decide

private def b3LeftLinearDecoder (u : Fin 7 → ZMod 7) : ZMod 7 × (Fin 6 → ZMod 7) :=
  ∑ j, u j.castSucc • b3LeftBasisCoefficient j

private def b3RightLinearDecoder (u : Fin 7 → ZMod 7) : ZMod 7 × (Fin 6 → ZMod 7) :=
  ∑ j, u j.castSucc • b3RightBasisCoefficient j

/-- Both `B3` affine restriction maps surject onto the six-dimensional zero-sum hyperplanes. -/
theorem b3_restrictsOntoZeroSum :
    RestrictsOntoZeroSum (affineEvaluationSpace b3LeftPoints b3RightPoints) := by
  apply restrictsOntoZeroSum_of_decoders b3LeftPoints b3RightPoints
    b3LeftLinearDecoder b3RightLinearDecoder
  · intro u hu i
    rw [b3LeftLinearDecoder, affineValue_sum_smul]
    simp_rw [b3LeftBasisCoefficient_eval]
    fin_cases i <;> simp [b3ZeroSumBasis, Fin.sum_univ_succ] at hu ⊢
    linear_combination -hu
  · intro u hu i
    rw [b3RightLinearDecoder, affineValue_sum_smul]
    simp_rw [b3RightBasisCoefficient_eval]
    fin_cases i <;> simp [b3ZeroSumBasis, Fin.sum_univ_succ] at hu ⊢
    linear_combination -hu

/-- The `B3` second-moment radical covector in the transported quotient coordinates. -/
def b3RadicalCovector : Fin 6 → ZMod 7 := ![0, 1, 1, 0, 1, 0]

private def b3MomentComplement : Matrix (Fin 6) (Fin 5) (ZMod 7) := ![
  ![1, 0, 0, 0, 0],
  ![0, 0, 0, 0, 0],
  ![0, 1, 0, 0, 0],
  ![0, 0, 1, 0, 0],
  ![0, 0, 0, 1, 0],
  ![0, 0, 0, 0, 1]]

private def b3MomentRecover : Matrix (Fin 5) (Fin 6) (ZMod 7) := ![
  ![1, 0, 6, 4, 0, 4],
  ![6, 3, 4, 0, 0, 1],
  ![4, 6, 6, 1, 0, 4],
  ![0, 6, 3, 1, 0, 0],
  ![4, 0, 1, 4, 0, 1]]

private def b3MomentProject (v : Fin 6 → ZMod 7) : Fin 5 → ZMod 7 :=
  ![v 0, v 2 - v 1, v 3, v 4 - v 1, v 5]

private def b3MomentCoefficient (v : Fin 6 → ZMod 7) : ZMod 7 := v 1

private theorem b3_moment_recovery_certificate :
    b3MomentRecover * secondMomentMatrix b3Vectors * b3MomentComplement = 1 := by
  decide

private theorem b3_radical_annihilates_secondMoment :
    secondMomentMatrix b3Vectors *ᵥ b3RadicalCovector = 0 := by
  decide

private theorem b3_moment_decomposition (v : Fin 6 → ZMod 7) :
    v = b3MomentComplement *ᵥ b3MomentProject v +
      b3MomentCoefficient v • b3RadicalCovector := by
  funext i
  fin_cases i <;>
    simp [b3MomentComplement, b3MomentProject, b3MomentCoefficient, b3RadicalCovector,
      Matrix.mulVec]

/-- The kernel of the `B3` second-moment matrix is exactly the line spanned by the displayed
radical covector; in particular its rank and radical dimensions are `5/1`. -/
theorem b3_secondMoment_kernel_eq_radicalLine (v : Fin 6 → ZMod 7) :
    secondMomentMatrix b3Vectors *ᵥ v = 0 ↔
      ∃ c : ZMod 7, v = c • b3RadicalCovector :=
  matrix_kernel_eq_line_of_recovery (secondMomentMatrix b3Vectors) b3RadicalCovector
    b3MomentComplement b3MomentRecover b3MomentProject b3MomentCoefficient
    b3_moment_recovery_certificate b3_radical_annihilates_secondMoment b3_moment_decomposition v

/-- Three generators of the special-subgroup action followed by one outer generator, recorded as
permutations of the fourteen quotient vectors. -/
def b3ActionPermutation : Fin 4 → Fin 14 → Fin 14 := ![
  ![0, 1, 10, 11, 9, 8, 4, 5, 7, 6, 13, 12, 3, 2],
  ![2, 3, 6, 7, 10, 11, 0, 1, 5, 4, 9, 8, 12, 13],
  ![0, 1, 10, 12, 6, 8, 4, 7, 5, 9, 2, 11, 3, 13],
  ![1, 0, 5, 4, 3, 2, 12, 13, 10, 11, 8, 9, 6, 7]]

/-- Linear parts of the four displayed affine actions on the `B3` quotient coordinates. -/
def b3ActionLinear : Fin 4 → Matrix (Fin 6) (Fin 6) (ZMod 7) := ![
  ![![6, 5, 1, 1, 2, 5], ![5, 6, 6, 3, 2, 5], ![4, 4, 3, 4, 3, 4],
    ![1, 1, 1, 0, 4, 2], ![5, 5, 6, 0, 3, 5], ![3, 3, 0, 6, 6, 3]],
  ![![0, 0, 3, 2, 3, 1], ![0, 0, 4, 2, 1, 0], ![0, 1, 1, 3, 6, 0],
    ![0, 0, 4, 6, 0, 0], ![0, 0, 3, 2, 1, 0], ![6, 6, 0, 3, 3, 6]],
  ![![6, 5, 2, 5, 2, 5], ![5, 6, 2, 5, 2, 5], ![4, 4, 4, 4, 3, 4],
    ![1, 1, 1, 1, 4, 2], ![5, 5, 2, 5, 3, 5], ![3, 3, 2, 4, 6, 3]],
  ![![0, 1, 0, 0, 0, 4], ![1, 0, 0, 0, 0, 4], ![0, 0, 0, 1, 0, 0],
    ![0, 0, 1, 0, 0, 0], ![6, 6, 6, 6, 6, 3], ![0, 0, 0, 0, 0, 6]]]

/-- Translation parts of the four displayed affine actions on the `B3` quotient coordinates. -/
def b3ActionTranslation : Fin 4 → Fin 6 → ZMod 7 := ![
  ![2, 2, 3, 6, 2, 4], ![0, 0, 0, 0, 0, 1], ![2, 2, 3, 6, 2, 4], ![0, 0, 0, 0, 1, 0]]

/-- All four displayed `B3` generators act affinely on every quotient vector. -/
theorem b3_actionGenerators_areAffine :
    IsAffinePermutationAction b3Vectors b3ActionPermutation b3ActionLinear b3ActionTranslation := by
  intro g i
  funext j
  fin_cases g <;> fin_cases i <;> fin_cases j <;> decide

/-- Every displayed `B3` action generator is a permutation. -/
theorem b3_actionPermutation_bijective (g : Fin 4) :
    Function.Bijective (b3ActionPermutation g) := by
  fin_cases g <;> decide

/-- The three displayed special-subgroup generators preserve the `B3` sheet sign. -/
theorem b3_specialGenerators_preserve_sheetSign (g : Fin 3) (i : Fin 14) :
    b3SheetSigns (b3ActionPermutation g.castSucc i) = b3SheetSigns i := by
  fin_cases g <;> fin_cases i <;> decide

/-- The displayed outer generator negates the `B3` sheet sign. -/
theorem b3_outerGenerator_negates_sheetSign (i : Fin 14) :
    b3SheetSigns (b3ActionPermutation (Fin.last 3) i) = -b3SheetSigns i := by
  fin_cases i <;> decide

/-- The radical covector evaluates to `0` and `1` on the two `B3` sheets. -/
theorem b3_radical_separates_sheets :
    (∀ i, affineValue ⟨0, b3RadicalCovector⟩ (b3LeftPoints i) = 0) ∧
      (∀ i, affineValue ⟨0, b3RadicalCovector⟩ (b3RightPoints i) = 1) := by
  constructor <;> intro i <;> fin_cases i <;>
    decide

/-- The two `B3` sheet indicators belong to the affine evaluation space. -/
theorem b3_sheetIndicators_mem :
    leftIndicator ∈ affineEvaluationSpace b3LeftPoints b3RightPoints ∧
      rightIndicator ∈ affineEvaluationSpace b3LeftPoints b3RightPoints := by
  exact affine_indicators_mem_of_separating_coefficient b3LeftPoints b3RightPoints
    ⟨0, b3RadicalCovector⟩ 0 1 zero_ne_one b3_radical_separates_sheets.1
      b3_radical_separates_sheets.2

/-- The frozen `B3` signs and quotient vectors have vanishing signed moments through degree two. -/
theorem b3_signedMomentsThroughTwo : SignedMomentsThroughTwo b3Vectors b3SheetSigns := by
  refine ⟨by decide, ?_, ?_⟩
  · intro j
    have h := congrFun b3_signedFirstMoment_eq_zero j
    simpa [signedFirstMoment] using h
  · intro j k
    have h := congrFun (congrFun b3_signedSecondMoment_eq_zero j) k
    simpa [signedSecondMoment] using h

private theorem b3_grouped_signed_sum (f : Fin 14 → ZMod 7) :
    (∑ i, b3SheetSigns i * f i) =
      (∑ i, f (b3LeftIndex i)) - ∑ i, f (b3RightIndex i) := by
  have h6 : (6 : ZMod 7) = -1 := by decide
  simp [b3SheetSigns, b3LeftIndex, b3RightIndex, Fin.sum_univ_succ, h6]
  ring

/-- Every product of two `B3` affine evaluation functions has equal sums on the two sheets. -/
theorem b3_productsHaveEqualSheetSums :
    ProductsHaveEqualSheetSums (affineEvaluationSpace b3LeftPoints b3RightPoints) := by
  rintro x ⟨left, rfl⟩ y ⟨right, rfl⟩
  have hz := signed_affine_product_eq_zero b3Vectors b3SheetSigns
    b3_signedMomentsThroughTwo left right
  have hz' : ∑ i, b3SheetSigns i *
      (affineValue left (b3Vectors i) * affineValue right (b3Vectors i)) = 0 := by
    simpa [mul_assoc] using hz
  have hg := b3_grouped_signed_sum (fun i ↦
    affineValue left (b3Vectors i) * affineValue right (b3Vectors i))
  rw [hz'] at hg
  apply sub_eq_zero.mp
  simpa [leftSum, rightSum, hadamard, affineEvaluationMap, b3LeftPoints, b3RightPoints] using hg.symm

private def b3QuadraticWitness : ZMod 7 × (Fin 6 → ZMod 7) := ⟨0, ![1, 0, 0, 0, 0, 0]⟩

private theorem b3QuadraticWitness_leftSum :
    leftSum (hadamard
      (affineEvaluationMap b3LeftPoints b3RightPoints b3QuadraticWitness)
      (affineEvaluationMap b3LeftPoints b3RightPoints b3QuadraticWitness)) = 1 := by
  decide

/-- The coordinate-square pairing `x₀²` has nonzero sum on the positive `B3` sheet. -/
theorem b3_hasNonzeroSheetProduct :
    HasNonzeroSheetProduct (affineEvaluationSpace b3LeftPoints b3RightPoints) := by
  refine ⟨affineEvaluationMap b3LeftPoints b3RightPoints b3QuadraticWitness,
    ⟨b3QuadraticWitness, rfl⟩,
    affineEvaluationMap b3LeftPoints b3RightPoints b3QuadraticWitness,
    ⟨b3QuadraticWitness, rfl⟩, ?_⟩
  rw [b3QuadraticWitness_leftSum]
  decide

/-- The coordinatewise-product square of the `B3` affine evaluation space is the full
equal-sheet-sum hyperplane. -/
theorem b3_hadamardSquare_eq_equalSheetSum :
    hadamardSquare (affineEvaluationSpace b3LeftPoints b3RightPoints) = equalSheetSum :=
  hadamardSquare_eq_equalSheetSum _ b3_sheetIndicators_mem.1 b3_sheetIndicators_mem.2
    b3_restrictsOntoZeroSum b3_productsHaveEqualSheetSums b3_hasNonzeroSheetProduct

/-- Every `B3` strength-two trade is a scalar sheet sign. -/
theorem b3_trade_eq_sheetSignLine (t : SheetPair 7 (ZMod 7)) :
    (∀ x ∈ hadamardSquare (affineEvaluationSpace b3LeftPoints b3RightPoints),
      sheetPairing t x = 0) ↔
      ∃ c : ZMod 7, t = (⟨fun _ ↦ c, fun _ ↦ -c⟩ : SheetPair 7 (ZMod 7)) := by
  rw [b3_hadamardSquare_eq_equalSheetSum]
  exact annihilates_equalSheetSum_iff_eq_sheetSignLine 0 t

end ClebschBalancedSheets
end RelativeConicArcs
