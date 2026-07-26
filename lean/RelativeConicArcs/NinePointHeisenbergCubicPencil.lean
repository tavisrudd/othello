import RelativeConicArcs.NinePointHeisenbergPair

/-!
# Cubic pencil carried by a nine-point Heisenberg pair

This module treats ternary cubics over `ZMod 19` in the ordered monomial basis

`X³, Y³, Z³, X²Y, X²Z, Y²X, Y²Z, Z²X, Z²Y, XYZ`.

For each of the two explicit nine-point orbits, a nonzero `9 × 9` evaluation minor proves
symbolically that the space of cubics through the orbit is one-dimensional.  The separate
`NinePointHeisenbergCubicPencilCounts` module checks every one of the 381 projective points on all
twenty rational members of the resulting pencil.  The explicit inverse matrices in this module
are checked as left inverses by kernel reduction; no rank verdict is imported.
-/

namespace RelativeConicArcs
namespace NinePointHeisenbergCubicPencil

open NinePointHeisenbergPair

set_option maxHeartbeats 400000000
set_option maxRecDepth 100000

abbrev CubicCoefficients := Fin 10 → K

/-- Evaluation of the ordered cubic monomial basis at a coordinate vector. -/
def cubicMonomial (p : V) : Fin 10 → K :=
  ![p 0 ^ 3, p 1 ^ 3, p 2 ^ 3,
    p 0 ^ 2 * p 1, p 0 ^ 2 * p 2,
    p 1 ^ 2 * p 0, p 1 ^ 2 * p 2,
    p 2 ^ 2 * p 0, p 2 ^ 2 * p 1,
    p 0 * p 1 * p 2]

/-- Evaluation of a cubic coefficient vector. -/
def cubicValue (coefficients : CubicCoefficients) (p : V) : K :=
  dotProduct (cubicMonomial p) coefficients

/-- Coefficients of the cubic through the selected orbit. -/
def selectedCoefficients : CubicCoefficients :=
  ![0, 0, 0, 1, 2, 1, 13, 7, 7, 7]

/-- Coefficients of the cubic through the uncovered orbit. -/
def uncoveredCoefficients : CubicCoefficients :=
  ![1, 16, 15, 3, 6, 3, 1, 2, 2, 1]

/-- A homogeneous coefficient pair in the cubic pencil. -/
def pencilCombination (left right : K) : CubicCoefficients :=
  left • selectedCoefficients + right • uncoveredCoefficients

/-- The coefficient-vector evaluator agrees with the selected-orbit cubic used for the
semi-invariance identities. -/
theorem selected_coefficients_evaluate_as_selectedCubic (p : V) :
    cubicValue selectedCoefficients p = selectedCubic p := by
  simp [cubicValue, cubicMonomial, selectedCoefficients, selectedCubic, dotProduct,
    Fin.sum_univ_succ]
  ring

/-- The coefficient-vector evaluator agrees with the uncovered-orbit cubic used for the
semi-invariance identities. -/
theorem uncovered_coefficients_evaluate_as_uncoveredCubic (p : V) :
    cubicValue uncoveredCoefficients p = uncoveredCubic p := by
  simp [cubicValue, cubicMonomial, uncoveredCoefficients, uncoveredCubic, dotProduct,
    Fin.sum_univ_succ]
  ring

private theorem cubicValue_pencilCombination (left right : K) (p : V) :
    cubicValue (pencilCombination left right) p =
      left * cubicValue selectedCoefficients p +
        right * cubicValue uncoveredCoefficients p := by
  unfold pencilCombination cubicValue dotProduct
  simp only [Pi.add_apply, Pi.smul_apply, smul_eq_mul]
  simp_rw [mul_add]
  rw [Finset.sum_add_distrib, Finset.mul_sum, Finset.mul_sum]
  congr 1 <;> apply Finset.sum_congr rfl <;> intro i hi <;> ring

/-- Every member of the cubic pencil has multiplier `14` under the first generator. -/
theorem pencilCombination_g (left right : K) (p : V) :
    cubicValue (pencilCombination left right) (Matrix.mulVec g p) =
      14 * cubicValue (pencilCombination left right) p := by
  rw [cubicValue_pencilCombination, cubicValue_pencilCombination,
    selected_coefficients_evaluate_as_selectedCubic,
    uncovered_coefficients_evaluate_as_uncoveredCubic,
    selected_coefficients_evaluate_as_selectedCubic,
    uncovered_coefficients_evaluate_as_uncoveredCubic,
    selectedCubic_g, uncoveredCubic_g]
  ring

/-- Every member of the cubic pencil has multiplier `15` under the second generator. -/
theorem pencilCombination_h (left right : K) (p : V) :
    cubicValue (pencilCombination left right) (Matrix.mulVec h p) =
      15 * cubicValue (pencilCombination left right) p := by
  rw [cubicValue_pencilCombination, cubicValue_pencilCombination,
    selected_coefficients_evaluate_as_selectedCubic,
    uncovered_coefficients_evaluate_as_uncoveredCubic,
    selected_coefficients_evaluate_as_selectedCubic,
    uncovered_coefficients_evaluate_as_uncoveredCubic,
    selectedCubic_h, uncoveredCubic_h]
  ring

private def selectedPoint (i : Fin 9) : V :=
  NinePointHeisenbergPair.selected.get i

private def uncoveredPoint (i : Fin 9) : V :=
  NinePointHeisenbergPair.uncovered.get i

private def evaluationMinor (point : Fin 9 → V) : Matrix (Fin 9) (Fin 9) K :=
  fun i j => cubicMonomial (point i) j.castSucc

private def selectedMinor := evaluationMinor selectedPoint
private def uncoveredMinor := evaluationMinor uncoveredPoint

/-- An explicit inverse of the selected-orbit evaluation minor. -/
def selectedMinorInverse : Matrix (Fin 9) (Fin 9) K :=
  ![![0, 0, 1, 0, 0, 0, 0, 0, 0],
    ![0, 1, 0, 0, 0, 0, 0, 0, 0],
    ![1, 0, 0, 0, 0, 0, 0, 0, 0],
    ![3, 9, 8, 10, 8, 18, 15, 16, 1],
    ![2, 11, 9, 13, 3, 15, 10, 12, 14],
    ![16, 8, 15, 9, 8, 12, 6, 12, 14],
    ![7, 16, 15, 16, 14, 12, 3, 12, 4],
    ![5, 9, 1, 16, 18, 5, 15, 3, 18],
    ![4, 3, 8, 13, 6, 14, 8, 2, 6]]

/-- An explicit inverse of the uncovered-orbit evaluation minor. -/
def uncoveredMinorInverse : Matrix (Fin 9) (Fin 9) K :=
  ![![4, 6, 15, 4, 7, 4, 14, 6, 17],
    ![9, 6, 17, 7, 3, 6, 9, 4, 15],
    ![10, 13, 6, 5, 10, 5, 13, 13, 1],
    ![9, 18, 13, 11, 14, 15, 0, 17, 17],
    ![12, 15, 3, 1, 0, 13, 18, 13, 1],
    ![11, 16, 14, 0, 5, 15, 7, 11, 16],
    ![13, 8, 0, 9, 6, 18, 1, 5, 16],
    ![14, 6, 1, 15, 16, 0, 11, 7, 6],
    ![9, 9, 15, 1, 18, 11, 2, 11, 0]]

/-- The displayed matrix is a left inverse of the selected evaluation minor. -/
theorem selected_evaluation_minor_left_inverse :
    selectedMinorInverse * selectedMinor = 1 := by decide

/-- The displayed matrix is a left inverse of the uncovered evaluation minor. -/
theorem uncovered_evaluation_minor_left_inverse :
    uncoveredMinorInverse * uncoveredMinor = 1 := by decide

/-- The first nine cubic columns are independent on the selected orbit. -/
theorem selected_evaluation_minor_nonsingular : Matrix.det selectedMinor ≠ 0 := by
  intro h
  have hdet := congrArg Matrix.det selected_evaluation_minor_left_inverse
  simp [Matrix.det_mul, h] at hdet

/-- The first nine cubic columns are independent on the uncovered orbit. -/
theorem uncovered_evaluation_minor_nonsingular : Matrix.det uncoveredMinor ≠ 0 := by
  intro h
  have hdet := congrArg Matrix.det uncovered_evaluation_minor_left_inverse
  simp [Matrix.det_mul, h] at hdet

private theorem minor_mulVec_eq_zero
    (point : Fin 9 → V) (coefficients : CubicCoefficients)
    (lastCoefficientZero : coefficients 9 = 0)
    (vanishes : ∀ i, cubicValue coefficients (point i) = 0) :
    Matrix.mulVec (evaluationMinor point) (fun j => coefficients j.castSucc) = 0 := by
  funext i
  have hi := vanishes i
  rw [cubicValue, dotProduct, Fin.sum_univ_castSucc] at hi
  simpa [evaluationMinor, Matrix.mulVec, dotProduct, lastCoefficientZero] using hi

private theorem coefficients_eq_zero_of_last_eq_zero
    (point : Fin 9 → V) (coefficients : CubicCoefficients)
    (minorInverse : Matrix (Fin 9) (Fin 9) K)
    (leftInverse : minorInverse * evaluationMinor point = 1)
    (lastCoefficientZero : coefficients 9 = 0)
    (vanishes : ∀ i, cubicValue coefficients (point i) = 0) :
    coefficients = 0 := by
  have hmul := minor_mulVec_eq_zero point coefficients lastCoefficientZero vanishes
  have hinjective : Function.Injective (Matrix.mulVec (evaluationMinor point)) := by
    intro left right h
    have transformed := congrArg (Matrix.mulVec minorInverse) h
    rw [Matrix.mulVec_mulVec, Matrix.mulVec_mulVec, leftInverse,
      Matrix.one_mulVec, Matrix.one_mulVec] at transformed
    exact transformed
  have hfirst : (fun j : Fin 9 => coefficients j.castSucc) = 0 := by
    apply hinjective
    simpa using hmul
  funext j
  refine Fin.lastCases ?_ (fun i => ?_) j
  · exact lastCoefficientZero
  · exact congrFun hfirst i

private theorem cubicValue_sub_smul
    (left right : CubicCoefficients) (scalar : K) (p : V) :
    cubicValue (left - scalar • right) p =
      cubicValue left p - scalar * cubicValue right p := by
  unfold cubicValue dotProduct
  simp only [Pi.sub_apply, Pi.smul_apply, smul_eq_mul]
  simp_rw [mul_sub]
  rw [Finset.sum_sub_distrib, Finset.mul_sum]
  congr 1
  apply Finset.sum_congr rfl
  intro i hi
  ring

/-- Every cubic vanishing on the selected orbit is a scalar multiple of the displayed cubic. -/
theorem selected_cubic_unique_up_to_scalar
    (coefficients : CubicCoefficients)
    (vanishes : ∀ i, cubicValue coefficients (selectedPoint i) = 0) :
    coefficients = (coefficients 9 / 7) • selectedCoefficients := by
  let scalar : K := coefficients 9 / 7
  let difference := coefficients - scalar • selectedCoefficients
  have hlast : difference 9 = 0 := by
    dsimp [difference, scalar]
    change coefficients 9 - (coefficients 9 / 7) * 7 = 0
    have hseven : (7 : K) ≠ 0 := by decide
    rw [div_mul_cancel₀ _ hseven]
    simp
  have hdisplayed : ∀ i, cubicValue selectedCoefficients (selectedPoint i) = 0 := by decide
  have hdifference : ∀ i, cubicValue difference (selectedPoint i) = 0 := by
    intro i
    simp [difference, cubicValue_sub_smul, vanishes i, hdisplayed i]
  have hz := coefficients_eq_zero_of_last_eq_zero selectedPoint difference
    selectedMinorInverse selected_evaluation_minor_left_inverse hlast hdifference
  simpa [difference, scalar] using (sub_eq_zero.mp hz)

/-- Every cubic vanishing on the uncovered orbit is a scalar multiple of the displayed cubic. -/
theorem uncovered_cubic_unique_up_to_scalar
    (coefficients : CubicCoefficients)
    (vanishes : ∀ i, cubicValue coefficients (uncoveredPoint i) = 0) :
    coefficients = coefficients 9 • uncoveredCoefficients := by
  let scalar : K := coefficients 9
  let difference := coefficients - scalar • uncoveredCoefficients
  have hlast : difference 9 = 0 := by
    dsimp [difference, scalar]
    change coefficients 9 - coefficients 9 * 1 = 0
    ring
  have hdisplayed : ∀ i, cubicValue uncoveredCoefficients (uncoveredPoint i) = 0 := by decide
  have hdifference : ∀ i, cubicValue difference (uncoveredPoint i) = 0 := by
    intro i
    simp [difference, cubicValue_sub_smul, vanishes i, hdisplayed i]
  have hz := coefficients_eq_zero_of_last_eq_zero uncoveredPoint difference
    uncoveredMinorInverse uncovered_evaluation_minor_left_inverse hlast hdifference
  simpa [difference, scalar] using (sub_eq_zero.mp hz)

attribute [reducible] cubicMonomial cubicValue selectedCoefficients uncoveredCoefficients
  pencilCombination selectedPoint uncoveredPoint evaluationMinor selectedMinor uncoveredMinor
  selectedMinorInverse uncoveredMinorInverse

end NinePointHeisenbergCubicPencil
end RelativeConicArcs
