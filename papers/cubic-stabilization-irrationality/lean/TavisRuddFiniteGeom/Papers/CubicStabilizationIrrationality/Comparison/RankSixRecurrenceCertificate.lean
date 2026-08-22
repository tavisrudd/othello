import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.Generated.RankSixRecurrenceData

/-!
# Certificate checker for the rank-six cubic recurrence

The generated data contain the two endpoint orientations of a nonzero
hyperbolic-self-adjoint square-zero return map.  For each orientation this
module checks the spectral projector, selected Jordan basis, unique normalized
off-block Sylvester solution, first two reduced connection coefficients, and
modified-residue discriminant.

The Rust generator performs exact rational Gaussian elimination and emits both
the data module and a JSON audit record.  Lean does not trust that execution:
all matrix identities below are proved by kernel-checked rational reduction.
The terminal two-case theorem excludes discriminant `4/9` only for a carrier
already identified with one of these canonical strict rank-six recurrences.
It does not construct that identification from a quantum-D-module occurrence.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.RankSixRecurrenceCertificate

open Generated.RankSixRecurrenceData

set_option maxHeartbeats 800000

/-- The selected Jordan block with eigenvalue one and nilpotent scale two. -/
def selectedJordan : Matrix BlockIndex BlockIndex ℚ :=
  !![1, 2; 0, 1]

/-- Matrix data consumed by the recurrence checker. -/
structure Data where
  multiplication : Matrix Index Index ℚ
  projector : Matrix Index Index ℚ
  selectedBasis : Matrix Index BlockIndex ℚ
  leftInverse : Matrix BlockIndex Index ℚ
  firstGauge : Matrix Index Index ℚ

/-- The lower-oriented generated data. -/
def lowerData : Data :=
  ⟨lowerMultiplication, lowerProjector, lowerSelectedBasis,
    lowerLeftInverse, lowerFirstGauge⟩

/-- The upper-oriented generated data. -/
def upperData : Data :=
  ⟨upperMultiplication, upperProjector, upperSelectedBasis,
    upperLeftInverse, upperFirstGauge⟩

/-- The commutator introduced by the first normalized gauge coefficient. -/
def firstCommutator (data : Data) : Matrix Index Index ℚ :=
  data.multiplication * data.firstGauge -
    data.firstGauge * data.multiplication

/-- The first reduced grading coefficient. -/
def blockGrading (data : Data) : Matrix Index Index ℚ :=
  -grading + firstCommutator data

/-- The full second recurrence coefficient, including the gauge-derivative
term. -/
def secondCoefficient (data : Data) : Matrix Index Index ℚ :=
  (-grading) * data.firstGauge - data.firstGauge * (-grading) -
    data.firstGauge * firstCommutator data - data.firstGauge

/-- Compression of the first reduced grading to the selected factor. -/
def selectedBlockGrading (data : Data) : Matrix BlockIndex BlockIndex ℚ :=
  data.leftInverse * blockGrading data * data.selectedBasis

/-- Compression of the second recurrence coefficient.  The projector factors
are essential because the full second coefficient need not preserve the
selected factor. -/
def selectedSecondCoefficient (data : Data) : Matrix BlockIndex BlockIndex ℚ :=
  data.leftInverse * data.projector * secondCoefficient data *
    data.projector * data.selectedBasis

/-- The elementary-modified residue of a checked canonical recurrence. -/
def modifiedResidue (data : Data) : Matrix BlockIndex BlockIndex ℚ :=
  !![selectedBlockGrading data 0 0, selectedJordan 0 1;
     selectedSecondCoefficient data 1 0,
       selectedBlockGrading data 1 1 - 1]

/-- Trace-square-minus-four-determinant for the modified residue. -/
def residueDiscriminant (data : Data) : ℚ :=
  (modifiedResidue data).trace ^ 2 - 4 * (modifiedResidue data).det

/-- Exact conditions checked for a normalized recurrence certificate. -/
structure IsRecurrenceCertificate (data : Data) : Prop where
  leftInverse_selected : data.leftInverse * data.selectedBasis = 1
  projector_selected : data.projector * data.selectedBasis = data.selectedBasis
  multiplication_selected :
    data.multiplication * data.selectedBasis =
      data.selectedBasis * selectedJordan
  projector_idempotent : data.projector * data.projector = data.projector
  projector_commutes :
    data.projector * data.multiplication =
      data.multiplication * data.projector
  sylvester :
    firstCommutator data =
      data.projector * grading * (1 - data.projector) +
        (1 - data.projector) * grading * data.projector
  gauge_selected_zero :
    data.projector * data.firstGauge * data.projector = 0
  gauge_complement_zero :
    (1 - data.projector) * data.firstGauge * (1 - data.projector) = 0
  reduced_grading_commutes :
    data.projector * blockGrading data = blockGrading data * data.projector

private theorem lower_leftInverse_selected :
    lowerLeftInverse * lowerSelectedBasis = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [lowerLeftInverse, lowerSelectedBasis, Matrix.mul_apply,
      Fin.sum_univ_succ]

private theorem lower_projector_selected :
    lowerProjector * lowerSelectedBasis = lowerSelectedBasis := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [lowerProjector, lowerSelectedBasis, Matrix.mul_apply,
      Fin.sum_univ_succ]

private theorem lower_multiplication_selected :
    lowerMultiplication * lowerSelectedBasis =
      lowerSelectedBasis * selectedJordan := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [lowerMultiplication, lowerSelectedBasis, selectedJordan,
      Matrix.mul_apply, Fin.sum_univ_succ]

private theorem lower_projector_idempotent :
    lowerProjector * lowerProjector = lowerProjector := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [lowerProjector, Matrix.mul_apply, Fin.sum_univ_succ]

private theorem lower_projector_commutes :
    lowerProjector * lowerMultiplication =
      lowerMultiplication * lowerProjector := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [lowerProjector, lowerMultiplication, Matrix.mul_apply,
      Fin.sum_univ_succ]

private theorem lower_sylvester :
    firstCommutator lowerData =
      lowerProjector * grading * (1 - lowerProjector) +
        (1 - lowerProjector) * grading * lowerProjector := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [firstCommutator, lowerData, lowerMultiplication, lowerProjector,
      lowerFirstGauge, grading, Matrix.one_apply, Matrix.mul_apply,
      Matrix.vecMul_apply_eq_sum, Fin.sum_univ_succ] <;>
    norm_num

private theorem lower_gauge_selected_zero :
    lowerProjector * lowerFirstGauge * lowerProjector = 0 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [lowerProjector, lowerFirstGauge, Matrix.mul_apply,
      Fin.sum_univ_succ]

private theorem lower_gauge_complement_zero :
    (1 - lowerProjector) * lowerFirstGauge * (1 - lowerProjector) = 0 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [lowerProjector, lowerFirstGauge, Matrix.one_apply, Matrix.mul_apply,
      Fin.sum_univ_succ] <;>
    norm_num

private theorem lower_reduced_grading_commutes :
    lowerProjector * blockGrading lowerData =
      blockGrading lowerData * lowerProjector := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [blockGrading, firstCommutator, lowerData, lowerProjector,
      lowerMultiplication, lowerFirstGauge, grading, Matrix.mul_apply,
      Fin.sum_univ_succ]

/-- The generated lower data satisfy every recurrence-certificate identity. -/
theorem lower_isRecurrenceCertificate : IsRecurrenceCertificate lowerData := by
  exact ⟨lower_leftInverse_selected, lower_projector_selected,
    lower_multiplication_selected, lower_projector_idempotent,
    lower_projector_commutes, lower_sylvester, lower_gauge_selected_zero,
    lower_gauge_complement_zero, lower_reduced_grading_commutes⟩

private theorem upper_leftInverse_selected :
    upperLeftInverse * upperSelectedBasis = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [upperLeftInverse, upperSelectedBasis, Matrix.mul_apply,
      Fin.sum_univ_succ]

private theorem upper_projector_selected :
    upperProjector * upperSelectedBasis = upperSelectedBasis := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [upperProjector, upperSelectedBasis, Matrix.mul_apply,
      Fin.sum_univ_succ]

private theorem upper_multiplication_selected :
    upperMultiplication * upperSelectedBasis =
      upperSelectedBasis * selectedJordan := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [upperMultiplication, upperSelectedBasis, selectedJordan,
      Matrix.mul_apply, Fin.sum_univ_succ]

private theorem upper_projector_idempotent :
    upperProjector * upperProjector = upperProjector := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [upperProjector, Matrix.mul_apply, Fin.sum_univ_succ]

private theorem upper_projector_commutes :
    upperProjector * upperMultiplication =
      upperMultiplication * upperProjector := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [upperProjector, upperMultiplication, Matrix.mul_apply,
      Fin.sum_univ_succ]

private theorem upper_sylvester :
    firstCommutator upperData =
      upperProjector * grading * (1 - upperProjector) +
        (1 - upperProjector) * grading * upperProjector := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [firstCommutator, upperData, upperMultiplication, upperProjector,
      upperFirstGauge, grading, Matrix.one_apply, Matrix.mul_apply,
      Matrix.vecMul_apply_eq_sum, Fin.sum_univ_succ] <;>
    norm_num

private theorem upper_gauge_selected_zero :
    upperProjector * upperFirstGauge * upperProjector = 0 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [upperProjector, upperFirstGauge, Matrix.mul_apply,
      Fin.sum_univ_succ]

private theorem upper_gauge_complement_zero :
    (1 - upperProjector) * upperFirstGauge * (1 - upperProjector) = 0 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [upperProjector, upperFirstGauge, Matrix.one_apply, Matrix.mul_apply,
      Fin.sum_univ_succ] <;>
    norm_num

private theorem upper_reduced_grading_commutes :
    upperProjector * blockGrading upperData =
      blockGrading upperData * upperProjector := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [blockGrading, firstCommutator, upperData, upperProjector,
      upperMultiplication, upperFirstGauge, grading, Matrix.mul_apply,
      Fin.sum_univ_succ]

/-- The generated upper data satisfy every recurrence-certificate identity. -/
theorem upper_isRecurrenceCertificate : IsRecurrenceCertificate upperData := by
  exact ⟨upper_leftInverse_selected, upper_projector_selected,
    upper_multiplication_selected, upper_projector_idempotent,
    upper_projector_commutes, upper_sylvester, upper_gauge_selected_zero,
    upper_gauge_complement_zero, upper_reduced_grading_commutes⟩

/-- The selected lower grading is `diag(-1/2,1/2)`. -/
theorem lower_selectedBlockGrading_value :
    selectedBlockGrading lowerData = !![-1 / 2, 0; 0, 1 / 2] := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [selectedBlockGrading, blockGrading, firstCommutator, lowerData,
      lowerMultiplication, lowerProjector, lowerSelectedBasis,
      lowerLeftInverse, lowerFirstGauge, grading, Matrix.mul_apply,
      Fin.sum_univ_succ]

/-- The selected upper grading is `diag(1/2,-1/2)`. -/
theorem upper_selectedBlockGrading_value :
    selectedBlockGrading upperData = !![1 / 2, 0; 0, -1 / 2] := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [selectedBlockGrading, blockGrading, firstCommutator, upperData,
      upperMultiplication, upperProjector, upperSelectedBasis,
      upperLeftInverse, upperFirstGauge, grading, Matrix.mul_apply,
      Fin.sum_univ_succ]

/-- In both orientations the selected second coefficient is the scalar
matrix `1/3`. -/
theorem selectedSecondCoefficient_values :
    selectedSecondCoefficient lowerData = !![1 / 3, 0; 0, 1 / 3] ∧
      selectedSecondCoefficient upperData = !![1 / 3, 0; 0, 1 / 3] := by
  constructor <;>
    ext i j <;>
    fin_cases i <;> fin_cases j <;>
    norm_num [selectedSecondCoefficient, secondCoefficient, blockGrading,
      firstCommutator, lowerData, upperData, lowerMultiplication,
      upperMultiplication, lowerProjector, upperProjector, lowerSelectedBasis,
      upperSelectedBasis, lowerLeftInverse, upperLeftInverse, lowerFirstGauge,
      upperFirstGauge, grading, Matrix.mul_apply, Fin.sum_univ_succ]

/-- The lower-oriented modified residue has discriminant zero. -/
theorem lower_residueDiscriminant_zero :
    residueDiscriminant lowerData = 0 := by
  unfold residueDiscriminant modifiedResidue
  rw [lower_selectedBlockGrading_value, selectedSecondCoefficient_values.1]
  norm_num [selectedJordan, Matrix.trace, Matrix.det_fin_two]

/-- The upper-oriented modified residue has discriminant four. -/
theorem upper_residueDiscriminant_four :
    residueDiscriminant upperData = 4 := by
  unfold residueDiscriminant modifiedResidue
  rw [upper_selectedBlockGrading_value, selectedSecondCoefficient_values.2]
  norm_num [selectedJordan, Matrix.trace, Matrix.det_fin_two]

/-- The two canonical endpoint orientations. -/
inductive Orientation
  | lower
  | upper
  deriving DecidableEq

/-- Recurrence data selected by an endpoint orientation. -/
def Orientation.data : Orientation → Data
  | .lower => lowerData
  | .upper => upperData

/-- Neither canonical strict rank-six recurrence has cubic discriminant
`4/9`. -/
theorem no_orientation_has_cubic_discriminant (orientation : Orientation) :
    residueDiscriminant orientation.data ≠ 4 / 9 := by
  cases orientation with
  | lower =>
      change residueDiscriminant lowerData ≠ 4 / 9
      rw [lower_residueDiscriminant_zero]
      norm_num
  | upper =>
      change residueDiscriminant upperData ≠ 4 / 9
      rw [upper_residueDiscriminant_four]
      norm_num

/-- A constant grading-compatible calibration from arbitrary recurrence data
to one generated canonical orientation.  The equations state that the same
linear map intertwines multiplication, projector, normalized first gauge,
selected basis, and its left inverse.  Invertibility is not required by the
consumer theorem. -/
structure Calibration (source target : Data) where
  intertwiner : Matrix Index Index ℚ
  multiplication_intertwines :
    source.multiplication * intertwiner =
      intertwiner * target.multiplication
  projector_intertwines :
    source.projector * intertwiner = intertwiner * target.projector
  firstGauge_intertwines :
    source.firstGauge * intertwiner = intertwiner * target.firstGauge
  grading_intertwines : grading * intertwiner = intertwiner * grading
  selectedBasis_intertwines :
    source.selectedBasis = intertwiner * target.selectedBasis
  leftInverse_intertwines :
    source.leftInverse * intertwiner = target.leftInverse

private theorem neg_intertwines
    {left right change : Matrix Index Index ℚ}
    (h : left * change = change * right) :
    (-left) * change = change * (-right) := by
  rw [neg_mul, h, mul_neg]

private theorem add_intertwines
    {left₁ left₂ right₁ right₂ change : Matrix Index Index ℚ}
    (h₁ : left₁ * change = change * right₁)
    (h₂ : left₂ * change = change * right₂) :
    (left₁ + left₂) * change = change * (right₁ + right₂) := by
  rw [add_mul, h₁, h₂, mul_add]

private theorem sub_intertwines
    {left₁ left₂ right₁ right₂ change : Matrix Index Index ℚ}
    (h₁ : left₁ * change = change * right₁)
    (h₂ : left₂ * change = change * right₂) :
    (left₁ - left₂) * change = change * (right₁ - right₂) := by
  rw [sub_mul, h₁, h₂, mul_sub]

private theorem mul_intertwines
    {left₁ left₂ right₁ right₂ change : Matrix Index Index ℚ}
    (h₁ : left₁ * change = change * right₁)
    (h₂ : left₂ * change = change * right₂) :
    (left₁ * left₂) * change = change * (right₁ * right₂) := by
  rw [Matrix.mul_assoc, h₂, ← Matrix.mul_assoc, h₁, Matrix.mul_assoc]

private theorem firstCommutator_intertwines
    {source target : Data} (calibration : Calibration source target) :
    firstCommutator source * calibration.intertwiner =
      calibration.intertwiner * firstCommutator target := by
  exact sub_intertwines
    (mul_intertwines calibration.multiplication_intertwines
      calibration.firstGauge_intertwines)
    (mul_intertwines calibration.firstGauge_intertwines
      calibration.multiplication_intertwines)

private theorem blockGrading_intertwines
    {source target : Data} (calibration : Calibration source target) :
    blockGrading source * calibration.intertwiner =
      calibration.intertwiner * blockGrading target := by
  exact add_intertwines (neg_intertwines calibration.grading_intertwines)
    (firstCommutator_intertwines calibration)

private theorem secondCoefficient_intertwines
    {source target : Data} (calibration : Calibration source target) :
    secondCoefficient source * calibration.intertwiner =
      calibration.intertwiner * secondCoefficient target := by
  exact sub_intertwines
    (sub_intertwines
      (sub_intertwines
        (mul_intertwines (neg_intertwines calibration.grading_intertwines)
          calibration.firstGauge_intertwines)
        (mul_intertwines calibration.firstGauge_intertwines
          (neg_intertwines calibration.grading_intertwines)))
      (mul_intertwines calibration.firstGauge_intertwines
        (firstCommutator_intertwines calibration)))
    calibration.firstGauge_intertwines

/-- A calibration preserves the selected first reduced grading. -/
theorem selectedBlockGrading_eq_of_calibration
    {source target : Data} (calibration : Calibration source target) :
    selectedBlockGrading source = selectedBlockGrading target := by
  calc
    selectedBlockGrading source =
        source.leftInverse * blockGrading source *
          (calibration.intertwiner * target.selectedBasis) := by
      rw [selectedBlockGrading, calibration.selectedBasis_intertwines]
    _ = source.leftInverse *
          (blockGrading source * calibration.intertwiner) *
          target.selectedBasis := by simp only [Matrix.mul_assoc]
    _ = source.leftInverse *
          (calibration.intertwiner * blockGrading target) *
          target.selectedBasis := by rw [blockGrading_intertwines calibration]
    _ = (source.leftInverse * calibration.intertwiner) *
          blockGrading target * target.selectedBasis := by
      simp only [Matrix.mul_assoc]
    _ = selectedBlockGrading target := by
      rw [calibration.leftInverse_intertwines]
      rfl

/-- A calibration preserves the projected second recurrence coefficient. -/
theorem selectedSecondCoefficient_eq_of_calibration
    {source target : Data} (calibration : Calibration source target) :
    selectedSecondCoefficient source = selectedSecondCoefficient target := by
  have operator_intertwines :
      (source.projector * secondCoefficient source * source.projector) *
          calibration.intertwiner =
        calibration.intertwiner *
          (target.projector * secondCoefficient target * target.projector) :=
    mul_intertwines
      (mul_intertwines calibration.projector_intertwines
        (secondCoefficient_intertwines calibration))
      calibration.projector_intertwines
  calc
    selectedSecondCoefficient source =
        source.leftInverse *
          (source.projector * secondCoefficient source * source.projector) *
          (calibration.intertwiner * target.selectedBasis) := by
      rw [selectedSecondCoefficient, calibration.selectedBasis_intertwines]
      simp only [Matrix.mul_assoc]
    _ = source.leftInverse *
          ((source.projector * secondCoefficient source * source.projector) *
            calibration.intertwiner) * target.selectedBasis := by
      simp only [Matrix.mul_assoc]
    _ = source.leftInverse *
          (calibration.intertwiner *
            (target.projector * secondCoefficient target * target.projector)) *
          target.selectedBasis := by rw [operator_intertwines]
    _ = (source.leftInverse * calibration.intertwiner) *
          (target.projector * secondCoefficient target * target.projector) *
          target.selectedBasis := by simp only [Matrix.mul_assoc]
    _ = selectedSecondCoefficient target := by
      rw [calibration.leftInverse_intertwines]
      unfold selectedSecondCoefficient
      simp only [Matrix.mul_assoc]

/-- A calibration preserves the modified residue and its discriminant. -/
theorem residueDiscriminant_eq_of_calibration
    {source target : Data} (calibration : Calibration source target) :
    residueDiscriminant source = residueDiscriminant target := by
  have first := selectedBlockGrading_eq_of_calibration calibration
  have second := selectedSecondCoefficient_eq_of_calibration calibration
  simp [residueDiscriminant, modifiedResidue, first, second]

/-- Any recurrence data calibrated to one generated orientation excludes the
cubic discriminant. -/
theorem no_cubic_discriminant_of_calibration
    (orientation : Orientation) (source : Data)
    (calibration : Calibration source orientation.data) :
    residueDiscriminant source ≠ 4 / 9 := by
  rw [residueDiscriminant_eq_of_calibration calibration]
  exact no_orientation_has_cubic_discriminant orientation

/-- The hyperbolic pairing on a rank-two endpoint sector. -/
def hyperbolicPairing : Matrix BlockIndex BlockIndex ℚ :=
  !![0, 1; 1, 0]

/-- A nonzero hyperbolic-self-adjoint square-zero `2 x 2` matrix has exactly
one nonzero off-diagonal orientation. -/
theorem selfAdjoint_squareZero_orientation
    (nilpotent : Matrix BlockIndex BlockIndex ℚ)
    (selfAdjoint :
      nilpotent.transpose * hyperbolicPairing =
        hyperbolicPairing * nilpotent)
    (squareZero : nilpotent * nilpotent = 0)
    (nonzero : nilpotent ≠ 0) :
    (nilpotent 0 0 = 0 ∧ nilpotent 1 1 = 0 ∧
      nilpotent 0 1 = 0 ∧ nilpotent 1 0 ≠ 0) ∨
    (nilpotent 0 0 = 0 ∧ nilpotent 1 1 = 0 ∧
      nilpotent 1 0 = 0 ∧ nilpotent 0 1 ≠ 0) := by
  have diagonal : nilpotent 0 0 = nilpotent 1 1 := by
    have entry := congrArg (fun matrix => matrix 0 1) selfAdjoint
    norm_num [hyperbolicPairing, Matrix.mul_apply, Fin.sum_univ_succ] at entry
    exact entry
  have square00 :
      nilpotent 0 0 * nilpotent 0 0 +
        nilpotent 0 1 * nilpotent 1 0 = 0 := by
    have entry := congrArg (fun matrix => matrix 0 0) squareZero
    norm_num [Matrix.mul_apply, Fin.sum_univ_succ] at entry
    exact entry
  have square01 :
      nilpotent 0 0 * nilpotent 0 1 +
        nilpotent 0 1 * nilpotent 1 1 = 0 := by
    have entry := congrArg (fun matrix => matrix 0 1) squareZero
    norm_num [Matrix.mul_apply, Fin.sum_univ_succ] at entry
    exact entry
  by_cases upperEntry : nilpotent 0 1 = 0
  · have diagonalZero : nilpotent 0 0 = 0 := by
      rw [upperEntry, zero_mul, add_zero] at square00
      exact mul_self_eq_zero.mp square00
    have lowerEntry : nilpotent 1 0 ≠ 0 := by
      intro lowerZero
      apply nonzero
      ext i j
      fin_cases i <;> fin_cases j <;>
        simp_all
    exact Or.inl ⟨diagonalZero, diagonal.symm.trans diagonalZero,
      upperEntry, lowerEntry⟩
  · have diagonalZero : nilpotent 0 0 = 0 := by
      have sumZero : nilpotent 0 0 + nilpotent 1 1 = 0 := by
        apply (mul_eq_zero.mp ?_).resolve_left upperEntry
        simpa [mul_add, mul_comm] using square01
      linarith
    have lowerEntry : nilpotent 1 0 = 0 := by
      rw [diagonalZero, zero_mul, zero_add] at square00
      exact (mul_eq_zero.mp square00).resolve_left upperEntry
    exact Or.inr ⟨diagonalZero, diagonal.symm.trans diagonalZero,
      lowerEntry, upperEntry⟩

end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.RankSixRecurrenceCertificate
