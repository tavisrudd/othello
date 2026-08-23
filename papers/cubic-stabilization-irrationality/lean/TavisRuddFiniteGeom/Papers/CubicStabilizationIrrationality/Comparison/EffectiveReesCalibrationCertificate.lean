import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.Generated.EffectiveReesCalibrationData
import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.ThreefoldKummerCompatibility

/-!
# Effective self-dual Rees-calibration certificate

This module checks one finite chart of marked Rees data.  The chart consists
of rank-six, weight-filtered, unipotent
calibrations for the cubic dual-number algebra over one primitive Kummer ray.

There are two logically separate results.

* Every pairing-preserving matrix in the stated effective unipotent support
  has the displayed five-parameter normal form.
* After the multiplication tensor is transported in both its output and input
  indices, the logarithmic divisor equation cuts this family down to one
  parameter.  Every member of that surviving family has modified-residue
  discriminant zero.

The Rust generator computes the exact defect and recurrence matrices.  Lean
reconstructs their meaning and proves all polynomial identities.  This is an
exhaustive theorem only for the stated coweight-zero dual-number chart.  It
does not classify nonzero coweights, other classical orders, arbitrary bulk
deformations, or construct a geometric occurrence-to-lattice adapter.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.EffectiveReesCalibrationCertificate

open ThreefoldKummerCompatibility
open Generated.EffectiveReesCalibrationData

abbrev Index := Fin 6
abbrev BlockIndex := Fin 2

set_option maxHeartbeats 1600000

/-- Coefficients of the most general unipotent matrix with positive support
for weights `(0,1,1,2,2,3)`. -/
structure RawEffectiveCoefficients where
  x01 : ℚ
  x02 : ℚ
  x03 : ℚ
  x04 : ℚ
  x05 : ℚ
  x13 : ℚ
  x14 : ℚ
  x15 : ℚ
  x23 : ℚ
  x24 : ℚ
  x25 : ℚ
  x35 : ℚ
  x45 : ℚ

/-- The raw effective unipotent matrix at the normalized Kummer fibre.  Its
power of the Kummer parameter is determined by the row/column weights and is
therefore not another coefficient. -/
def RawEffectiveCoefficients.matrix (x : RawEffectiveCoefficients) :
    Matrix Index Index ℚ :=
  !![1, x.x01, x.x02, x.x03, x.x04, x.x05;
     0, 1, 0, x.x13, x.x14, x.x15;
     0, 0, 1, x.x23, x.x24, x.x25;
     0, 0, 0, 1, 0, x.x35;
     0, 0, 0, 0, 1, x.x45;
     0, 0, 0, 0, 0, 1]

/-- The five-parameter pairing-preserving normal form. -/
def generalCalibration (a b c d f : ℚ) : Matrix Index Index ℚ :=
  !![1, a, b, c, d, -(a * d + b * c);
     0, 1, 0, f, 0, -(d + f * b);
     0, 0, 1, 0, -f, -c + f * a;
     0, 0, 0, 1, 0, -b;
     0, 0, 0, 0, 1, -a;
     0, 0, 0, 0, 0, 1]

/-- The pairing inverse of the five-parameter normal form. -/
def generalCalibrationInverse (a b c d f : ℚ) : Matrix Index Index ℚ :=
  !![1, -a, -b, -c + f * a, -(d + f * b), -(a * d + b * c);
     0, 1, 0, -f, 0, d;
     0, 0, 1, 0, f, c;
     0, 0, 0, 1, 0, b;
     0, 0, 0, 0, 1, a;
     0, 0, 0, 0, 0, 1]

/-- Every displayed five-parameter calibration preserves the Poincare
pairing. -/
theorem generalCalibration_pairing (a b c d f : ℚ) :
    (generalCalibration a b c d f).transpose * threefoldPairing *
        generalCalibration a b c d f = threefoldPairing := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [generalCalibration, threefoldPairing, Matrix.mul_apply,
      Fin.sum_univ_succ] <;>
    ring

/-- The displayed pairing inverse is a two-sided inverse. -/
theorem generalCalibration_inverse (a b c d f : ℚ) :
    generalCalibration a b c d f * generalCalibrationInverse a b c d f = 1 ∧
      generalCalibrationInverse a b c d f * generalCalibration a b c d f = 1 := by
  constructor <;>
    ext i j <;>
    fin_cases i <;> fin_cases j <;>
      norm_num [generalCalibrationInverse, generalCalibration,
        threefoldPairing, Matrix.mul_apply, Matrix.one_apply,
        Fin.sum_univ_succ] <;>
      ring

/-- Pairing preservation leaves exactly the five displayed parameters in the
effective unipotent support. -/
theorem raw_pairing_normalForm
    (x : RawEffectiveCoefficients)
    (pairing : x.matrix.transpose * threefoldPairing * x.matrix =
      threefoldPairing) :
    x.matrix = generalCalibration x.x01 x.x02 x.x03 x.x04 x.x13 := by
  have h33 := congrArg (fun matrix => matrix (3 : Index) (3 : Index)) pairing
  have h44 := congrArg (fun matrix => matrix (4 : Index) (4 : Index)) pairing
  have h34 := congrArg (fun matrix => matrix (3 : Index) (4 : Index)) pairing
  have h15 := congrArg (fun matrix => matrix (1 : Index) (5 : Index)) pairing
  have h25 := congrArg (fun matrix => matrix (2 : Index) (5 : Index)) pairing
  have h35 := congrArg (fun matrix => matrix (3 : Index) (5 : Index)) pairing
  have h45 := congrArg (fun matrix => matrix (4 : Index) (5 : Index)) pairing
  have h55 := congrArg (fun matrix => matrix (5 : Index) (5 : Index)) pairing
  simp [RawEffectiveCoefficients.matrix, threefoldPairing,
    Matrix.mul_apply, Fin.sum_univ_succ] at h33 h44 h34 h15 h25 h35 h45 h55
  ring_nf at h33 h44 h34 h15 h25 h35 h45 h55
  have hx23 : x.x23 = 0 := by linarith
  have hx14 : x.x14 = 0 := by linarith
  have hx24 : x.x24 = -x.x13 := by linarith
  have hx45 : x.x45 = -x.x01 := by linarith
  have hx35 : x.x35 = -x.x02 := by linarith
  have hx25 : x.x25 = -x.x03 + x.x13 * x.x01 := by
    rw [hx45, hx23] at h35
    ring_nf at h35
    nlinarith
  have hx15 : x.x15 = -(x.x04 + x.x13 * x.x02) := by
    rw [hx24, hx35, hx14] at h45
    ring_nf at h45
    nlinarith
  have hx05 : x.x05 = -(x.x01 * x.x04 + x.x02 * x.x03) := by
    rw [hx45, hx35, hx25, hx15] at h55
    nlinarith
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [RawEffectiveCoefficients.matrix, generalCalibration, hx23, hx14,
      hx24, hx45, hx35, hx25, hx15, hx05]

/-- Multiplication by a general vector in
`Q[x,e]/(x^3-1,e^2)`, with basis `1,e,x,xe,x^2,x^2e`. -/
def multiplicationOf (v : Index → ℚ) : Matrix Index Index ℚ :=
  !![v 0, 0, v 4, 0, v 2, 0;
     v 1, v 0, v 5, v 4, v 3, v 2;
     v 2, 0, v 0, 0, v 4, 0;
     v 3, v 2, v 1, v 0, v 5, v 4;
     v 4, 0, v 2, 0, v 0, 0;
     v 5, v 4, v 3, v 2, v 1, v 0]

/-- Correct tensor transport: the calibration acts on the output matrices and
its inverse also acts on the multiplication input. -/
def transportedMultiplication
    (calibration inverse : Matrix Index Index ℚ) (v : Index → ℚ) :
    Matrix Index Index ℚ :=
  calibration * multiplicationOf (inverse.mulVec v) * inverse

def eulerVector : Index → ℚ := ![0, 2, 3, 0, 0, 0]

def divisorVector : Index → ℚ := ![0, 0, 1, 0, 0, 0]

/-- Input coordinates of the Euler vector before output conjugation. -/
def oldEulerVector (a b : ℚ) : Index → ℚ :=
  ![-2 * a - 3 * b, 2, 3, 0, 0, 0]

/-- Input coordinates of the Kummer divisor before output conjugation. -/
def oldDivisorVector (b : ℚ) : Index → ℚ :=
  ![-b, 0, 1, 0, 0, 0]

theorem inverse_mulVec_eulerVector (a b c d f : ℚ) :
    (generalCalibrationInverse a b c d f).mulVec eulerVector =
      oldEulerVector a b := by
  ext i
  fin_cases i <;>
    norm_num [generalCalibrationInverse, eulerVector, oldEulerVector,
      Matrix.mulVec, dotProduct, Fin.sum_univ_succ]
  all_goals ring

theorem inverse_mulVec_divisorVector (a b c d f : ℚ) :
    (generalCalibrationInverse a b c d f).mulVec divisorVector =
      oldDivisorVector b := by
  ext i
  fin_cases i <;>
    norm_num [generalCalibrationInverse, divisorVector, oldDivisorVector,
      Matrix.mulVec, dotProduct, Fin.sum_univ_succ]

/-- Integral cohomological weights in the normalized basis. -/
def cohomologicalWeight : Index → ℤ := ![0, 1, 1, 2, 2, 3]

/-- Logarithmic derivative of a homogeneous degree-one multiplication matrix
at the normalized Kummer fibre. -/
def logarithmicDerivative (matrix : Matrix Index Index ℚ) :
    Matrix Index Index ℚ :=
  fun i j => ((1 + cohomologicalWeight j - cohomologicalWeight i : ℤ) : ℚ) *
    matrix i j

/-- The correctly input-transported Euler multiplication. -/
def transportedEuler (a b c d f : ℚ) : Matrix Index Index ℚ :=
  transportedMultiplication (generalCalibration a b c d f)
    (generalCalibrationInverse a b c d f) eulerVector

/-- The correctly input-transported Kummer divisor multiplication. -/
def transportedDivisor (a b c d f : ℚ) : Matrix Index Index ℚ :=
  transportedMultiplication (generalCalibration a b c d f)
    (generalCalibrationInverse a b c d f) divisorVector

/-- The correctly input-transported Euler multiplication has the exact
polynomial matrix emitted by Rust. -/
private theorem oldEulerMultiplication_formula (a b : ℚ) :
    multiplicationOf (oldEulerVector a b) =
      oldEulerMultiplicationFormula a b := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [multiplicationOf, oldEulerVector,
      oldEulerMultiplicationFormula] <;>
    ring

private theorem leftEulerTransport_formula (a b c d f : ℚ) :
    generalCalibration a b c d f * oldEulerMultiplicationFormula a b =
      leftEulerTransportFormula a b c d f := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [generalCalibration, oldEulerMultiplicationFormula,
      leftEulerTransportFormula, Matrix.mul_apply, Fin.sum_univ_succ] <;>
    ring

private theorem rightEulerTransport_formula (a b c d f : ℚ) :
    leftEulerTransportFormula a b c d f *
        generalCalibrationInverse a b c d f =
      transportedEulerFormula a b c d f := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [leftEulerTransportFormula, generalCalibrationInverse,
      transportedEulerFormula, Matrix.mul_apply, Fin.sum_univ_succ] <;>
    ring

theorem transportedEuler_formula (a b c d f : ℚ) :
    transportedEuler a b c d f = transportedEulerFormula a b c d f := by
  unfold transportedEuler transportedMultiplication
  rw [inverse_mulVec_eulerVector]
  rw [oldEulerMultiplication_formula, leftEulerTransport_formula,
    rightEulerTransport_formula]

/-- The correctly input-transported divisor multiplication has the exact
polynomial matrix emitted by Rust. -/
private theorem oldDivisorMultiplication_formula (b : ℚ) :
    multiplicationOf (oldDivisorVector b) =
      oldDivisorMultiplicationFormula b := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [multiplicationOf, oldDivisorVector,
      oldDivisorMultiplicationFormula]

private theorem leftDivisorTransport_formula (a b c d f : ℚ) :
    generalCalibration a b c d f * oldDivisorMultiplicationFormula b =
      leftDivisorTransportFormula a b c d f := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [generalCalibration, oldDivisorMultiplicationFormula,
      leftDivisorTransportFormula, Matrix.mul_apply, Fin.sum_univ_succ] <;>
    ring

private theorem rightDivisorTransport_formula (a b c d f : ℚ) :
    leftDivisorTransportFormula a b c d f *
        generalCalibrationInverse a b c d f =
      transportedDivisorFormula a b c d f := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [leftDivisorTransportFormula, generalCalibrationInverse,
      transportedDivisorFormula, Matrix.mul_apply, Fin.sum_univ_succ] <;>
    ring

theorem transportedDivisor_formula (a b c d f : ℚ) :
    transportedDivisor a b c d f = transportedDivisorFormula a b c d f := by
  unfold transportedDivisor transportedMultiplication
  rw [inverse_mulVec_divisorVector]
  rw [oldDivisorMultiplication_formula, leftDivisorTransport_formula,
    rightDivisorTransport_formula]

/-- Defect of the logarithmic divisor equation in this finite chart. -/
def conformalDefect (a b c d f : ℚ) : Matrix Index Index ℚ :=
  (1 / 3 : ℚ) • logarithmicDerivative (transportedEuler a b c d f) -
    (transportedDivisor a b c d f +
      transportedDivisor a b c d f * productGrading -
      productGrading * transportedDivisor a b c d f)

/-- Lean reconstructs the exact polynomial defect emitted by Rust. -/
theorem conformalDefect_formula (a b c d f : ℚ) :
    conformalDefect a b c d f = conformalDefectFormula a b c d f := by
  unfold conformalDefect
  rw [transportedEuler_formula, transportedDivisor_formula]
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [logarithmicDerivative,
      cohomologicalWeight, productGrading, threefoldPairing,
      transportedEulerFormula, transportedDivisorFormula,
      conformalDefectFormula, Matrix.mul_apply, Fin.sum_univ_succ] <;>
    ring

/-- The logarithmic divisor equation is equivalent to the one-parameter
normal-form equations found by the exact solver. -/
theorem conformalDefect_eq_zero_iff (a b c d f : ℚ) :
    conformalDefect a b c d f = 0 ↔
      a = 0 ∧ c = 0 ∧ f = b ∧ 2 * d + b ^ 2 = 0 := by
  rw [conformalDefect_formula]
  constructor
  · intro h
    have h11 := congrArg (fun matrix => matrix (1 : Index) (1 : Index)) h
    have h12 := congrArg (fun matrix => matrix (1 : Index) (2 : Index)) h
    have h13 := congrArg (fun matrix => matrix (1 : Index) (3 : Index)) h
    have h14 := congrArg (fun matrix => matrix (1 : Index) (4 : Index)) h
    simp [conformalDefectFormula] at h11 h12 h13 h14
    ring_nf at h11 h12 h13 h14
    have ha : a = 0 := by linarith
    have hc : c = 0 := by
      rw [ha] at h13
      linarith
    have hf : f = b := by linarith
    have hd : 2 * d + b ^ 2 = 0 := by
      rw [hf] at h14
      nlinarith
    exact ⟨ha, hc, hf, hd⟩
  · rintro ⟨rfl, rfl, rfl, relation⟩
    have hd : d = -(f ^ 2) / 2 := by linarith
    rw [hd]
    ext i j
    fin_cases i <;> fin_cases j <;>
      norm_num [conformalDefectFormula]
    all_goals ring

/-! ## The surviving conformal family -/

/-- The five-parameter calibration specialized to the one-parameter family
selected by the logarithmic divisor equation. -/
theorem generalCalibration_normalFamily (p : ℚ) :
    generalCalibration 0 (-p) 0 (-(p ^ 2) / 2) (-p) =
      normalCalibration p := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [generalCalibration, normalCalibration] <;>
    ring

/-- The generated inverse is the corresponding specialization of the
five-parameter pairing inverse. -/
theorem generalCalibrationInverse_normalFamily (p : ℚ) :
    generalCalibrationInverse 0 (-p) 0 (-(p ^ 2) / 2) (-p) =
      normalCalibrationInverse p := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [generalCalibrationInverse, normalCalibrationInverse] <;>
    ring

/-- The inverse calibration changes the Euler input by the scalar unit term
`3p`.  This records the input-index transport that is lost by output-only
conjugation. -/
theorem normalCalibrationInverse_mulVec_eulerVector (p : ℚ) :
    (normalCalibrationInverse p).mulVec eulerVector =
      ![3 * p, 2, 3, 0, 0, 0] := by
  ext i
  fin_cases i <;>
    norm_num [normalCalibrationInverse, eulerVector, Matrix.mulVec,
      dotProduct, Fin.sum_univ_succ]
  all_goals ring

/-- Away from the strict member, transporting only multiplication outputs
cannot equal the correctly transported Euler input. -/
theorem normalCalibrationInverse_mulVec_eulerVector_ne
    (p : ℚ) (hp : p ≠ 0) :
    (normalCalibrationInverse p).mulVec eulerVector ≠ eulerVector := by
  intro equality
  have coordinate := congrFun equality (0 : Index)
  rw [normalCalibrationInverse_mulVec_eulerVector] at coordinate
  simp [eulerVector] at coordinate
  exact hp (by linarith)

/-- Euler multiplication on the conformal normal family. -/
def normalEuler (p : ℚ) : Matrix Index Index ℚ :=
  transportedEuler 0 (-p) 0 (-(p ^ 2) / 2) (-p)

/-- The generated normal-family matrix is the correctly transported Euler
multiplication. -/
theorem normalEuler_formula (p : ℚ) :
    normalEuler p = transportedEulerFormula 0 (-p) 0 (-(p ^ 2) / 2) (-p) :=
  transportedEuler_formula 0 (-p) 0 (-(p ^ 2) / 2) (-p)

/-- The displayed normal-family basis and inverse are mutually inverse. -/
theorem normalJordanBasis_inverse (p : ℚ) :
    normalJordanBasis p * normalJordanBasisInverse p = 1 ∧
      normalJordanBasisInverse p * normalJordanBasis p = 1 := by
  constructor <;>
    ext i j <;>
    fin_cases i <;> fin_cases j <;>
      norm_num [normalJordanBasis, normalJordanBasisInverse,
        Matrix.mul_apply, Matrix.one_apply, Fin.sum_univ_succ] <;>
      ring

/-- The normal-family basis intertwines the transported Euler multiplication
with the displayed `2+4` Jordan matrix. -/
theorem normalEuler_intertwining (p : ℚ) :
    normalEuler p * normalJordanBasis p =
      normalJordanBasis p * normalJordanForm p := by
  rw [normalEuler_formula]
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [transportedEulerFormula, normalJordanBasis, normalJordanForm,
      Matrix.mul_apply, Fin.sum_univ_succ] <;>
    ring

/-- The same basis intertwines the connection grading with the generated
grading matrix. -/
theorem normalConnectionGrading_intertwining (p : ℚ) :
    (-productGrading) * normalJordanBasis p =
      normalJordanBasis p * normalGradingInJordanBasis p := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [productGrading, normalJordanBasis,
      normalGradingInJordanBasis, Matrix.mul_apply, Fin.sum_univ_succ] <;>
    ring

/-- The grading after the first normalized Sylvester step on the conformal
normal family. -/
def normalBlockGrading (p : ℚ) : Matrix Index Index ℚ :=
  normalGradingInJordanBasis p +
    normalJordanForm p * normalFirstGauge p -
      normalFirstGauge p * normalJordanForm p

/-- The second coefficient of the normalized connection-gauge recurrence. -/
def normalSecondCoefficient (p : ℚ) : Matrix Index Index ℚ :=
  let commutator := normalJordanForm p * normalFirstGauge p -
    normalFirstGauge p * normalJordanForm p
  normalGradingInJordanBasis p * normalFirstGauge p -
    normalFirstGauge p * normalGradingInJordanBasis p -
    normalFirstGauge p * commutator - normalFirstGauge p

/-- The generated first gauge has zero diagonal blocks for the partition
`2+4`. -/
theorem normalFirstGauge_diagonalBlocks_zero (p : ℚ) :
    ∀ i j,
      (i.1 < 2 ∧ j.1 < 2) ∨ (2 ≤ i.1 ∧ 2 ≤ j.1) →
        normalFirstGauge p i j = 0 := by
  intro i j hij
  fin_cases i <;> fin_cases j <;>
    norm_num at hij <;>
    norm_num [normalFirstGauge]

/-- The first gauge removes all entries between the selected rank-two block
and its four-dimensional complement. -/
theorem normalFirstGauge_block_separation (p : ℚ) :
    ∀ i j,
      (i.1 < 2 ∧ 2 ≤ j.1) ∨ (2 ≤ i.1 ∧ j.1 < 2) →
        normalBlockGrading p i j = 0 := by
  intro i j hij
  fin_cases i <;> fin_cases j <;>
    norm_num at hij <;>
    norm_num [normalBlockGrading, normalGradingInJordanBasis,
      normalJordanForm, normalFirstGauge, Matrix.mul_apply,
      Fin.sum_univ_succ] <;>
    ring

/-- The selected block has diagonal exponents `-1/2,1/2`, and the return
entry of the full second recurrence vanishes for every normal parameter. -/
theorem normal_selectedBlock_values (p : ℚ) :
    normalBlockGrading p 0 0 = -1 / 2 ∧
      normalBlockGrading p 1 1 = 1 / 2 ∧
      normalSecondCoefficient p 1 0 = 0 := by
  norm_num [normalBlockGrading, normalSecondCoefficient,
    normalGradingInJordanBasis, normalJordanForm, normalFirstGauge,
    Matrix.mul_apply, Fin.sum_univ_succ]

/-- Elementary-modified residue of the selected normal-family block. -/
def normalModifiedResidue (p : ℚ) : Matrix BlockIndex BlockIndex ℚ :=
  !![normalBlockGrading p 0 0, 2;
     normalSecondCoefficient p 1 0, normalBlockGrading p 1 1 - 1]

/-- Every conformal normal-family calibration has zero modified-residue
discriminant. -/
theorem normalModifiedResidue_discriminant (p : ℚ) :
    (normalModifiedResidue p).trace ^ 2 -
        4 * (normalModifiedResidue p).det = 0 := by
  norm_num [normalModifiedResidue, normalBlockGrading,
    normalSecondCoefficient, normalGradingInJordanBasis, normalJordanForm,
    normalFirstGauge, Matrix.trace, Matrix.det_fin_two, Matrix.mul_apply,
    Fin.sum_univ_succ]

/-- No member of the conformal normal family has the marked cubic
discriminant `4/9`. -/
theorem normalModifiedResidue_discriminant_ne_cubic (p : ℚ) :
    (normalModifiedResidue p).trace ^ 2 -
        4 * (normalModifiedResidue p).det ≠ 4 / 9 := by
  rw [normalModifiedResidue_discriminant]
  norm_num

/-- Within the displayed effective coweight-zero dual-number chart, the
logarithmic divisor equation calibrates every point to the normal family and
therefore excludes the marked cubic discriminant. -/
theorem conformalCalibration_normalFamily_and_discriminant
    (a b c d f : ℚ) (equation : conformalDefect a b c d f = 0) :
    ∃ p : ℚ,
      generalCalibration a b c d f = normalCalibration p ∧
      (normalModifiedResidue p).trace ^ 2 -
          4 * (normalModifiedResidue p).det = 0 ∧
      (normalModifiedResidue p).trace ^ 2 -
          4 * (normalModifiedResidue p).det ≠ 4 / 9 := by
  rcases (conformalDefect_eq_zero_iff a b c d f).mp equation with
    ⟨ha, hc, hf, hd⟩
  have hd' : d = -(b ^ 2) / 2 := by linarith
  refine ⟨-b, ?_, normalModifiedResidue_discriminant (-b),
    normalModifiedResidue_discriminant_ne_cubic (-b)⟩
  rw [ha, hc, hf, hd']
  simpa using generalCalibration_normalFamily (-b)

end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.EffectiveReesCalibrationCertificate
