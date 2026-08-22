import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.CubicSmallEvenBlockReduction
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.NormalizedSylvesterGauge

/-!
# The normalized gauge of the separated small even cubic system

The small even quantum connection of a smooth cubic threefold, written in the
ordered classical basis and transported by the constant separating change of
basis, is the system

  `z ^ 2 * ∂_z S = (E + z * G) * S`

whose leading coefficient `E` is the separated Euler matrix: the two simple
eigenvalues `6 r` and `-6 r` on the first two coordinates, and a single rank-two
Jordan block at the eigenvalue zero on the last two.  Partitioning the four
coordinates as `{0}, {1}, {2, 3}` makes `E` block diagonal, with the three
scalars `6 r`, `-6 r` and `0`; for `r ≠ 0` their pairwise differences are units,
and `E` differs from the diagonal matrix of those scalars by a square-zero
matrix.

The separated blocks therefore satisfy the hypotheses of the general
normalized-gauge theorem: there is exactly one gauge starting at the identity
whose positive coefficients are block off-diagonal for this partition and which
carries the system to one whose every coefficient is block diagonal.  This
module records that instance and identifies the first two coefficients of that
unique gauge, and of the reduced system, with the matrices exhibited by the
block reduction.

Lean constructs neither the cubic threefold nor its quantum connection: the two
matrices of the system are the ones exhibited in the source, and their
identification with the small even connection of a cubic threefold is an
imported datum.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace Quantum

open Matrix

variable {K : Type*} [Field K]

/-- The partition of the four coordinates of the small even system into the two
simple Euler eigenvalues and the rank-two zero block. -/
def cubicBlockLabel : Fin 4 → Fin 3 := ![0, 1, 2, 2]

/-- The Euler eigenvalue attached to each block of the small even system. -/
def cubicBlockScalar (r : K) : Fin 3 → K := ![6 * r, -6 * r, 0]

/-- The separated small even system: the separated Euler matrix at order zero,
the separated grading matrix at order one, and nothing beyond. -/
def cubicSeparatedSystem (r : K) : ℕ → Matrix (Fin 4) (Fin 4) K
  | 0 => cubicEulerBlockForm r
  | 1 => cubicGradingBlockForm r
  | _ + 2 => 0

/-- The leading coefficient of the separated system is the separated Euler
matrix. -/
@[simp]
theorem cubicSeparatedSystem_zero (r : K) :
    cubicSeparatedSystem r 0 = cubicEulerBlockForm r := rfl

/-- The first coefficient of the separated system is the separated grading
matrix. -/
@[simp]
theorem cubicSeparatedSystem_one (r : K) :
    cubicSeparatedSystem r 1 = cubicGradingBlockForm r := rfl

/-- The separated system has no coefficient beyond the first. -/
@[simp]
theorem cubicSeparatedSystem_add_two (r : K) (order : ℕ) :
    cubicSeparatedSystem r (order + 2) = 0 := rfl

/-- The separated Euler matrix is block diagonal for the partition. -/
theorem cubicEulerBlockForm_isBlockDiagonal (r : K) :
    IsBlockDiagonal cubicBlockLabel (cubicEulerBlockForm r) := by
  intro row column differentLabel
  fin_cases row <;> fin_cases column <;>
    simp_all [cubicBlockLabel, cubicEulerBlockForm]

/-- The pairwise differences of the three Euler eigenvalues are units when the
square root of three times the line-class variable is nonzero. -/
theorem cubicBlockScalar_separated [CharZero K] {r : K} (nonzero : r ≠ 0) :
    ∀ first second, first ≠ second →
      IsUnit (cubicBlockScalar r first - cubicBlockScalar r second) := by
  intro first second different
  refine isUnit_iff_ne_zero.mpr ?_
  fin_cases first <;> fin_cases second <;> simp_all [cubicBlockScalar]
  all_goals ring_nf
  all_goals
    first
      | exact mul_ne_zero nonzero (by norm_num)
      | exact mul_ne_zero (by norm_num) nonzero
      | exact neg_ne_zero.mpr (mul_ne_zero nonzero (by norm_num))

/-- The separated Euler matrix differs from the diagonal matrix of the three
eigenvalues by the square-zero Jordan entry of the rank-two block. -/
theorem cubicEulerBlockForm_sub_diagonal_isNilpotent (r : K) :
    IsNilpotent (cubicEulerBlockForm r
      - Matrix.diagonal fun index => cubicBlockScalar r (cubicBlockLabel index)) := by
  refine ⟨2, ?_⟩
  have square : (cubicEulerBlockForm r
      - Matrix.diagonal fun index => cubicBlockScalar r (cubicBlockLabel index))
      = !![0, 0, 0, 0; 0, 0, 0, 0; 0, 0, 0, 2; 0, 0, 0, 0] := by
    ext row column
    fin_cases row <;> fin_cases column <;>
      simp [cubicEulerBlockForm, cubicBlockLabel, cubicBlockScalar, Matrix.diagonal]
  rw [pow_two, square]
  ext row column
  fin_cases row <;> fin_cases column <;>
    simp [Matrix.mul_apply, Fin.sum_univ_four]

/-- The separated small even system has exactly one normalized gauge reducing it
to block-diagonal form. -/
theorem exists_normalizedGauge_cubicSeparatedSystem [CharZero K] {r : K} (nonzero : r ≠ 0) :
    ∃ gauge reduced : ℕ → Matrix (Fin 4) (Fin 4) K,
      IsNormalizedGauge cubicBlockLabel (cubicSeparatedSystem r) gauge reduced :=
  exists_normalizedGauge (scalar := cubicBlockScalar r)
    (cubicBlockScalar_separated nonzero) (cubicEulerBlockForm_isBlockDiagonal r)
    (cubicEulerBlockForm_sub_diagonal_isNilpotent r)

/-- Uniqueness of the normalized gauge of the separated small even system. -/
theorem normalizedGauge_cubicSeparatedSystem_unique [CharZero K] {r : K} (nonzero : r ≠ 0)
    {gauge reduced gaugeOther reducedOther : ℕ → Matrix (Fin 4) (Fin 4) K}
    (first : IsNormalizedGauge cubicBlockLabel (cubicSeparatedSystem r) gauge reduced)
    (second : IsNormalizedGauge cubicBlockLabel (cubicSeparatedSystem r) gaugeOther
      reducedOther) :
    ∀ order, gauge order = gaugeOther order ∧ reduced order = reducedOther order :=
  normalizedGauge_unique (scalar := cubicBlockScalar r)
    (cubicBlockScalar_separated nonzero) (cubicEulerBlockForm_isBlockDiagonal r)
    (cubicEulerBlockForm_sub_diagonal_isNilpotent r) first second

/-- The first gauge coefficient exhibited by the block reduction is block
off-diagonal for the partition. -/
theorem cubicGaugeFirst_isBlockOffDiagonal (r : K) :
    IsBlockOffDiagonal cubicBlockLabel (cubicGaugeFirst r) := by
  intro row column sameLabel
  fin_cases row <;> fin_cases column <;>
    simp_all [cubicBlockLabel, cubicGaugeFirst]

/-- The second gauge coefficient exhibited by the block reduction is block
off-diagonal for the partition. -/
theorem cubicGaugeSecond_isBlockOffDiagonal (r : K) :
    IsBlockOffDiagonal cubicBlockLabel (cubicGaugeSecond r) := by
  intro row column sameLabel
  fin_cases row <;> fin_cases column <;>
    simp_all [cubicBlockLabel, cubicGaugeSecond]

/-- The first coefficient of the reduced system exhibited by the block reduction
is block diagonal for the partition. -/
theorem cubicReducedFirst_isBlockDiagonal :
    IsBlockDiagonal cubicBlockLabel (cubicReducedFirst (K := K)) := by
  intro row column differentLabel
  fin_cases row <;> fin_cases column <;>
    simp_all [cubicBlockLabel, cubicReducedFirst]

/-- The second coefficient of the reduced system exhibited by the block
reduction is block diagonal for the partition. -/
theorem cubicReducedSecond_isBlockDiagonal (r : K) :
    IsBlockDiagonal cubicBlockLabel (cubicReducedSecond r) := by
  intro row column differentLabel
  fin_cases row <;> fin_cases column <;>
    simp_all [cubicBlockLabel, cubicReducedSecond]

/-- The coefficients exhibited by the block reduction are the first two
coefficients of the unique normalized gauge, and of the reduced system.  At
order one the residual is the separated grading matrix, and at order two it is
built from the first coefficients; in both cases the exhibited matrices satisfy
the order's identity, so uniqueness of one order identifies them. -/
theorem normalizedGauge_cubicSeparatedSystem_coefficients [CharZero K] {r : K} (nonzero : r ≠ 0)
    {gauge reduced : ℕ → Matrix (Fin 4) (Fin 4) K}
    (normalized : IsNormalizedGauge cubicBlockLabel (cubicSeparatedSystem r) gauge reduced) :
    gauge 1 = cubicGaugeFirst r ∧ reduced 1 = cubicReducedFirst
      ∧ gauge 2 = cubicGaugeSecond r ∧ reduced 2 = cubicReducedSecond r := by
  have reducedZero : reduced 0 = cubicSeparatedSystem r 0 :=
    reduced_zero_eq normalized.leading normalized.transform
  have firstOrder := (gaugeTransform_succ_iff normalized.leading reducedZero 0).mp
    (normalized.transform 1)
  have firstResidual : gaugeResidual (cubicSeparatedSystem r) gauge reduced 1
      = cubicGradingBlockForm r := by
    rw [gaugeResidual, sourceConvolution, interiorConvolution]
    simp [normalized.leading]
  rw [firstResidual] at firstOrder
  have firstExhibited : cubicReducedFirst
      + (cubicGaugeFirst r * cubicSeparatedSystem r 0
        - cubicSeparatedSystem r 0 * cubicGaugeFirst r) = cubicGradingBlockForm r := by
    have identity := cubicReduction_first_order r nonzero
    rw [cubicSeparatedSystem_zero]
    linear_combination (norm := abel) -identity
  obtain ⟨gaugeFirst, reducedFirstEquality⟩ :=
    normalizedGauge_step_unique (scalar := cubicBlockScalar r)
      (cubicBlockScalar_separated nonzero) (cubicEulerBlockForm_isBlockDiagonal r)
      (cubicEulerBlockForm_sub_diagonal_isNilpotent r) (normalized.reducedDiagonal 1)
      cubicReducedFirst_isBlockDiagonal (normalized.gaugeOffDiagonal 1 (by omega))
      (cubicGaugeFirst_isBlockOffDiagonal r) firstOrder firstExhibited
  have secondOrder := (gaugeTransform_succ_iff normalized.leading reducedZero 1).mp
    (normalized.transform 2)
  have secondResidual : gaugeResidual (cubicSeparatedSystem r) gauge reduced 2
      = cubicGradingBlockForm r * cubicGaugeFirst r
        - cubicGaugeFirst r * cubicReducedFirst - cubicGaugeFirst r := by
    rw [gaugeResidual, sourceConvolution, interiorConvolution]
    simp [normalized.leading, gaugeFirst, reducedFirstEquality, Finset.sum_Ico_succ_top]
  rw [secondResidual] at secondOrder
  have secondExhibited : cubicReducedSecond r
      + (cubicGaugeSecond r * cubicSeparatedSystem r 0
        - cubicSeparatedSystem r 0 * cubicGaugeSecond r)
      = cubicGradingBlockForm r * cubicGaugeFirst r
        - cubicGaugeFirst r * cubicReducedFirst - cubicGaugeFirst r := by
    have identity := cubicReduction_second_order r nonzero
    rw [cubicSeparatedSystem_zero]
    linear_combination (norm := abel) -identity
  obtain ⟨gaugeSecond, reducedSecondEquality⟩ :=
    normalizedGauge_step_unique (scalar := cubicBlockScalar r)
      (cubicBlockScalar_separated nonzero) (cubicEulerBlockForm_isBlockDiagonal r)
      (cubicEulerBlockForm_sub_diagonal_isNilpotent r) (normalized.reducedDiagonal 2)
      (cubicReducedSecond_isBlockDiagonal r) (normalized.gaugeOffDiagonal 2 (by omega))
      (cubicGaugeSecond_isBlockOffDiagonal r) secondOrder secondExhibited
  exact ⟨gaugeFirst, reducedFirstEquality, gaugeSecond, reducedSecondEquality⟩

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
