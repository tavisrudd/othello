import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.EffectiveReesCalibrationCertificate
import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.Generated.EffectiveDistinctOrderData

/-!
# Effective calibration certificate for the distinct-root order

This module checks the second explicit rank-six Rees chart.  The native order
is

`Q[r][a,b]/(a*b-r^2, a^3+b^3-2*r^3)`

in the self-dual graded basis `(1,a,b,b^2,-a^2,b^3)`.  The same complete
five-parameter family of effective pairing-preserving calibrations is used as
in `EffectiveReesCalibrationCertificate`, with multiplication transported in
both its output and input indices.

The exact Rust solver finds that the logarithmic divisor equation holds on
the whole chart.  It then solves the normalized off-block Sylvester system.
Lean reconstructs that system and proves that the lower-left entry of the
selected grading is always `1/6`.  Consequently the leading nilpotent line is
never preserved, so the elementary modification defining the cubic marker is
not a regular lattice operation anywhere in this chart.

The result is exhaustive only for this native order, the displayed effective
support, one primitive Kummer ray, and the normalized pairing.  It does not
bound all coweights or construct a geometric occurrence-to-Rees adapter.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.EffectiveDistinctOrderCertificate

open ThreefoldKummerCompatibility
open EffectiveReesCalibrationCertificate
open Generated.EffectiveDistinctOrderData

abbrev Index := Fin 6
abbrev BlockIndex := Fin 2

set_option maxHeartbeats 10000000
set_option maxRecDepth 10000

/-- Multiplication by `a` at the normalized fibre `r=1`, in the basis
`(1,a,b,b^2,-a^2,b^3)`. -/
def distinctAMultiplication : Matrix Index Index ℚ :=
  !![0, 0, 1, 0, -2, 0;
     1, 0, 0, 0, 0, 0;
     0, 0, 0, 1, 0, 0;
     0, 0, 0, 0, 0, 1;
     0, -1, 0, 0, 0, 0;
     0, 0, 0, 0, 1, 0]

/-- Multiplication by `b` at the normalized fibre. -/
def distinctBMultiplication : Matrix Index Index ℚ :=
  !![0, 1, 0, 0, 0, 0;
     0, 0, 0, 0, -1, 0;
     1, 0, 0, 0, 0, 2;
     0, 0, 1, 0, 0, 0;
     0, 0, 0, 0, 0, 1;
     0, 0, 0, 1, 0, 0]

/-- Multiplication by a general vector in the normalized distinct-root
algebra. -/
def distinctMultiplicationOf (v : Index → ℚ) : Matrix Index Index ℚ :=
  v 0 • (1 : Matrix Index Index ℚ) +
    v 1 • distinctAMultiplication +
    v 2 • distinctBMultiplication +
    v 3 • (distinctBMultiplication * distinctBMultiplication) -
    v 4 • (distinctAMultiplication * distinctAMultiplication) +
    v 5 • (distinctBMultiplication * distinctBMultiplication *
      distinctBMultiplication)

/-- Correct two-index transport of the distinct-root multiplication tensor. -/
def transportedDistinctMultiplication
    (calibration inverse : Matrix Index Index ℚ) (v : Index → ℚ) :
    Matrix Index Index ℚ :=
  calibration * distinctMultiplicationOf (inverse.mulVec v) * inverse

def distinctEulerVector : Index → ℚ := ![0, 3, 0, 0, 0, 0]

def distinctDivisorVector : Index → ℚ := ![0, 1, 0, 0, 0, 0]

def oldDistinctEulerVector (a : ℚ) : Index → ℚ := ![-3 * a, 3, 0, 0, 0, 0]

def oldDistinctDivisorVector (a : ℚ) : Index → ℚ := ![-a, 1, 0, 0, 0, 0]

theorem inverse_mulVec_distinctEulerVector (a b c d f : ℚ) :
    (generalCalibrationInverse a b c d f).mulVec distinctEulerVector =
      oldDistinctEulerVector a := by
  ext i
  fin_cases i <;>
    norm_num [generalCalibrationInverse, distinctEulerVector,
      oldDistinctEulerVector, Matrix.mulVec, dotProduct,
      Fin.sum_univ_succ]
  ring

theorem inverse_mulVec_distinctDivisorVector (a b c d f : ℚ) :
    (generalCalibrationInverse a b c d f).mulVec distinctDivisorVector =
      oldDistinctDivisorVector a := by
  ext i
  fin_cases i <;>
    norm_num [generalCalibrationInverse, distinctDivisorVector,
      oldDistinctDivisorVector, Matrix.mulVec, dotProduct,
      Fin.sum_univ_succ]

/-- Correctly transported Euler multiplication on the distinct-root chart. -/
def transportedDistinctEuler (a b c d f : ℚ) : Matrix Index Index ℚ :=
  transportedDistinctMultiplication (generalCalibration a b c d f)
    (generalCalibrationInverse a b c d f) distinctEulerVector

/-- Correctly transported divisor multiplication on the distinct-root chart. -/
def transportedDistinctDivisor (a b c d f : ℚ) : Matrix Index Index ℚ :=
  transportedDistinctMultiplication (generalCalibration a b c d f)
    (generalCalibrationInverse a b c d f) distinctDivisorVector

/-- Logarithmic divisor-equation defect for the native distinct-root order. -/
def distinctConformalDefect (a b c d f : ℚ) : Matrix Index Index ℚ :=
  (1 / 3 : ℚ) • logarithmicDerivative
      (transportedDistinctEuler a b c d f) -
    (transportedDistinctDivisor a b c d f +
      transportedDistinctDivisor a b c d f * productGrading -
      productGrading * transportedDistinctDivisor a b c d f)

private theorem oldDistinctEulerMultiplication_formula (a : ℚ) :
    distinctMultiplicationOf (oldDistinctEulerVector a) =
      distinctOldEulerMultiplicationFormula a := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [distinctMultiplicationOf,
      distinctAMultiplication, distinctBMultiplication,
      distinctOldEulerMultiplicationFormula, Matrix.mul_apply,
      Matrix.one_apply, Fin.sum_univ_succ]
  all_goals simp [oldDistinctEulerVector]
  all_goals ring

private theorem leftDistinctEulerTransport_formula (a b c d f : ℚ) :
    generalCalibration a b c d f * distinctOldEulerMultiplicationFormula a =
      distinctLeftEulerTransportFormula a b c d f := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [generalCalibration, distinctOldEulerMultiplicationFormula,
      distinctLeftEulerTransportFormula, Matrix.mul_apply,
      Fin.sum_univ_succ] <;>
    ring

private theorem rightDistinctEulerTransport_formula (a b c d f : ℚ) :
    distinctLeftEulerTransportFormula a b c d f *
        generalCalibrationInverse a b c d f =
      distinctTransportedEulerFormula a b c d f := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [distinctLeftEulerTransportFormula, generalCalibrationInverse,
      distinctTransportedEulerFormula, Matrix.mul_apply,
      Fin.sum_univ_succ] <;>
    ring

theorem transportedDistinctEuler_formula (a b c d f : ℚ) :
    transportedDistinctEuler a b c d f =
      distinctTransportedEulerFormula a b c d f := by
  unfold transportedDistinctEuler transportedDistinctMultiplication
  rw [inverse_mulVec_distinctEulerVector]
  rw [oldDistinctEulerMultiplication_formula,
    leftDistinctEulerTransport_formula, rightDistinctEulerTransport_formula]

private theorem oldDistinctDivisorMultiplication_formula (a : ℚ) :
    distinctMultiplicationOf (oldDistinctDivisorVector a) =
      distinctOldDivisorMultiplicationFormula a := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [distinctMultiplicationOf,
      distinctAMultiplication, distinctBMultiplication,
      distinctOldDivisorMultiplicationFormula, Matrix.mul_apply,
      Matrix.one_apply, Fin.sum_univ_succ]
  all_goals simp [oldDistinctDivisorVector]

private theorem leftDistinctDivisorTransport_formula (a b c d f : ℚ) :
    generalCalibration a b c d f *
        distinctOldDivisorMultiplicationFormula a =
      distinctLeftDivisorTransportFormula a b c d f := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [generalCalibration, distinctOldDivisorMultiplicationFormula,
      distinctLeftDivisorTransportFormula, Matrix.mul_apply,
      Fin.sum_univ_succ] <;>
    ring

private theorem rightDistinctDivisorTransport_formula (a b c d f : ℚ) :
    distinctLeftDivisorTransportFormula a b c d f *
        generalCalibrationInverse a b c d f =
      distinctTransportedDivisorFormula a b c d f := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [distinctLeftDivisorTransportFormula, generalCalibrationInverse,
      distinctTransportedDivisorFormula, Matrix.mul_apply,
      Fin.sum_univ_succ] <;>
    ring

theorem transportedDistinctDivisor_formula (a b c d f : ℚ) :
    transportedDistinctDivisor a b c d f =
      distinctTransportedDivisorFormula a b c d f := by
  unfold transportedDistinctDivisor transportedDistinctMultiplication
  rw [inverse_mulVec_distinctDivisorVector]
  rw [oldDistinctDivisorMultiplication_formula,
    leftDistinctDivisorTransport_formula,
    rightDistinctDivisorTransport_formula]

/-- Correct input-index transport makes the distinct-root family conformal
for every effective self-dual calibration parameter. -/
theorem distinctConformalDefect_zero (a b c d f : ℚ) :
    distinctConformalDefect a b c d f = 0 := by
  unfold distinctConformalDefect
  rw [transportedDistinctEuler_formula, transportedDistinctDivisor_formula]
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [distinctTransportedEulerFormula,
      distinctTransportedDivisorFormula, logarithmicDerivative,
      cohomologicalWeight, productGrading, Matrix.mul_apply,
      Fin.sum_univ_succ] <;>
    ring

/-- Rank-two projector for the branch with reduced eigenvalue one. -/
def distinctProjector : Matrix Index Index ℚ :=
  !![1 / 3, 4 / 9, 2 / 9, 1 / 9, -5 / 9, 0;
     2 / 9, 1 / 3, 1 / 9, 0, -4 / 9, -1 / 9;
     2 / 9, 1 / 9, 1 / 3, 4 / 9, 0, 5 / 9;
     1 / 9, 0, 2 / 9, 1 / 3, 1 / 9, 4 / 9;
     -1 / 9, -2 / 9, 0, 1 / 9, 1 / 3, 2 / 9;
     0, -1 / 9, 1 / 9, 2 / 9, 2 / 9, 1 / 3]

/-- Selected Jordan-chain basis. -/
def distinctSelectedBasis : Matrix Index BlockIndex ℚ :=
  !![-1, -6;
     -1, -4;
     1, -4;
     1, -2;
     1, 2;
     1, 0]

/-- Left inverse of the selected basis. -/
def distinctLeftInverse : Matrix BlockIndex Index ℚ :=
  !![0, -1 / 9, 1 / 9, 2 / 9, 2 / 9, 1 / 3;
     -1 / 18, -1 / 18, -1 / 18, -1 / 18, 1 / 18, -1 / 18]

def distinctEulerCore : Matrix Index Index ℚ :=
  (3 : ℚ) • distinctAMultiplication

def selectedEulerJordan : Matrix BlockIndex BlockIndex ℚ :=
  !![3, 6; 0, 3]

/-- Connection grading in the native algebra frame. -/
def distinctNativeConnectionGrading (a b c d f : ℚ) :
    Matrix Index Index ℚ :=
  -(generalCalibrationInverse a b c d f * productGrading *
      generalCalibration a b c d f)

theorem distinctNativeGrading_formula (a b c d f : ℚ) :
    generalCalibrationInverse a b c d f * productGrading *
        generalCalibration a b c d f =
      distinctNativeGradingFormula a b c d f := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [generalCalibration, generalCalibrationInverse, productGrading,
      distinctNativeGradingFormula, Matrix.mul_apply,
      Fin.sum_univ_succ] <;>
    ring

theorem distinctNativeConnectionGrading_formula (a b c d f : ℚ) :
    distinctNativeConnectionGrading a b c d f =
      -distinctNativeGradingFormula a b c d f := by
  unfold distinctNativeConnectionGrading
  rw [distinctNativeGrading_formula]

/-- The exact first gauge emitted by the Rust Sylvester solver. -/
def distinctFirstGauge (a b c d f : ℚ) : Matrix Index Index ℚ :=
  distinctFirstGaugeFormula a b c d f

def distinctBlockGrading (a b c d f : ℚ) : Matrix Index Index ℚ :=
  distinctNativeConnectionGrading a b c d f +
    distinctEulerCore * distinctFirstGauge a b c d f -
      distinctFirstGauge a b c d f * distinctEulerCore

def distinctSelectedBlockGrading (a b c d f : ℚ) :
    Matrix BlockIndex BlockIndex ℚ :=
  distinctLeftInverse * distinctBlockGrading a b c d f *
    distinctSelectedBasis

theorem distinct_projector_factorization :
    distinctProjector = distinctSelectedBasis * distinctLeftInverse := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [distinctProjector, distinctSelectedBasis, distinctLeftInverse,
      Matrix.mul_apply, Fin.sum_univ_succ]

theorem distinct_selected_intertwining :
    distinctEulerCore * distinctSelectedBasis =
      distinctSelectedBasis * selectedEulerJordan := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [distinctEulerCore, distinctAMultiplication,
      distinctSelectedBasis, selectedEulerJordan, Matrix.mul_apply,
      Fin.sum_univ_succ]

theorem distinct_projector_commutes :
    distinctProjector * distinctEulerCore =
      distinctEulerCore * distinctProjector := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [distinctProjector, distinctEulerCore,
      distinctAMultiplication, Matrix.mul_apply, Fin.sum_univ_succ]

/-- The generated first gauge has zero selected and complementary diagonal
blocks. -/
theorem distinctFirstGauge_diagonalBlocks_zero (a b c d f : ℚ) :
    distinctProjector * distinctFirstGauge a b c d f * distinctProjector = 0 ∧
      (1 - distinctProjector) * distinctFirstGauge a b c d f *
        (1 - distinctProjector) = 0 := by
  constructor
  · ext i j
    fin_cases i <;> fin_cases j <;>
      norm_num [distinctProjector, distinctFirstGauge,
        distinctFirstGaugeFormula, Matrix.mul_apply, Matrix.one_apply,
        Fin.sum_univ_succ] <;>
      ring
  · ext i j
    fin_cases i <;> fin_cases j <;>
      simp [distinctProjector, distinctFirstGauge,
        distinctFirstGaugeFormula, Matrix.mul_apply,
        Matrix.one_apply,
        Fin.sum_univ_succ] <;>
      ring

/-- The generated gauge solves the exact off-block Sylvester equation. -/
theorem distinctFirstGauge_sylvester (a b c d f : ℚ) :
    distinctEulerCore * distinctFirstGauge a b c d f -
        distinctFirstGauge a b c d f * distinctEulerCore =
      distinctProjector *
          (generalCalibrationInverse a b c d f * productGrading *
            generalCalibration a b c d f) * (1 - distinctProjector) +
        (1 - distinctProjector) *
          (generalCalibrationInverse a b c d f * productGrading *
            generalCalibration a b c d f) * distinctProjector := by
  rw [distinctNativeGrading_formula]
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [distinctEulerCore, distinctAMultiplication,
      distinctFirstGauge, distinctFirstGaugeFormula, distinctProjector,
      distinctNativeGradingFormula,
      Matrix.mul_apply, Matrix.vecMul_apply_eq_sum, Matrix.one_apply,
      Fin.sum_univ_succ] <;>
    ring

/-- Lean recomputes the selected grading matrix emitted by Rust. -/
theorem distinctSelectedBlockGrading_formula (a b c d f : ℚ) :
    distinctSelectedBlockGrading a b c d f =
      distinctSelectedBlockGradingFormula a b c d f := by
  unfold distinctSelectedBlockGrading distinctBlockGrading
  rw [distinctNativeConnectionGrading_formula]
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [distinctEulerCore,
      distinctAMultiplication, distinctFirstGauge,
      distinctFirstGaugeFormula, distinctSelectedBasis, distinctLeftInverse,
      distinctNativeGradingFormula,
      distinctSelectedBlockGradingFormula, Matrix.mul_apply,
      Fin.sum_univ_succ] <;>
    ring

/-- The leading nilpotent line always leaks into its quotient by the exact
constant amount `1/6`. -/
theorem distinctSelectedBlockGrading_lowerLeft (a b c d f : ℚ) :
    distinctSelectedBlockGrading a b c d f 1 0 = 1 / 6 := by
  rw [distinctSelectedBlockGrading_formula]
  norm_num [distinctSelectedBlockGradingFormula]

/-- No effective self-dual calibration in the distinct-root chart preserves
the line needed for the marked elementary modification. -/
theorem no_effectiveDistinctOrder_preservesLeadingLine (a b c d f : ℚ) :
    distinctSelectedBlockGrading a b c d f 1 0 ≠ 0 := by
  rw [distinctSelectedBlockGrading_lowerLeft]
  norm_num

/-- Public terminal: the entire displayed distinct-root Rees chart is
conformal, but every point fails the marked-line condition. -/
theorem conformalDistinctOrder_forces_lineFailure (a b c d f : ℚ) :
    distinctConformalDefect a b c d f = 0 ∧
      distinctSelectedBlockGrading a b c d f 1 0 ≠ 0 :=
  ⟨distinctConformalDefect_zero a b c d f,
    no_effectiveDistinctOrder_preservesLeadingLine a b c d f⟩

end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.EffectiveDistinctOrderCertificate
