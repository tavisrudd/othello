import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.NormalizedSylvesterGauge
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.ParameterizedRankTwoResidue

/-!
# Formal gauge splitting into two rank-two blocks

For a leading operator with blocks `[[0,t],[1,0]]` and `[[0,1],[0,0]]`,
where `t` is nonzero in a field, an explicit rational inverse of the
block off-diagonal Sylvester operator constructs a normalized gauge to all
orders. No square root of `t` or splitting field is used. Formal systems and
gauges are represented by their complete sequences of matrix coefficients.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum

/-- A normalized gauge is obtained from a solver for every coefficient residual.
The hypotheses concern finite matrix equations; the conclusion constructs all
coefficients and proves the full convolution identity, including the derivative. -/
theorem exists_normalizedGauge_of_step_solver
    {R coordinate factorIndex : Type*} [CommRing R] [Fintype coordinate]
    [DecidableEq coordinate] [DecidableEq factorIndex]
    (label : coordinate → factorIndex) (system : ℕ → Matrix coordinate coordinate R)
    (blockDiagonal : IsBlockDiagonal label (system 0))
    (solve : Matrix coordinate coordinate R →
      Matrix coordinate coordinate R × Matrix coordinate coordinate R)
    (solveOffDiagonal : ∀ r, IsBlockOffDiagonal label (solve r).1)
    (solveDiagonal : ∀ r, IsBlockDiagonal label (solve r).2)
    (solveEquation : ∀ r, (solve r).2 +
      ((solve r).1 * system 0 - system 0 * (solve r).1) = r) :
    ∃ gauge reduced, IsNormalizedGauge label system gauge reduced := by
  refine ⟨fun order => (gaugeSequence solve system order).1,
    fun order => (gaugeSequence solve system order).2, ?_, ?_, ?_, ?_⟩
  · rfl
  · intro order bound
    match order with
    | 0 => exact absurd bound (by omega)
    | step + 1 =>
        rw [gaugeSequence_succ]
        exact solveOffDiagonal _
  · intro order
    match order with
    | 0 => exact blockDiagonal
    | step + 1 =>
        rw [gaugeSequence_succ]
        exact solveDiagonal _
  · intro order
    match order with
    | 0 =>
        have zeroValue : gaugeSequence solve system 0 = (1, system 0) := rfl
        simp [zeroValue]
    | step + 1 =>
        have leadingValue : (gaugeSequence solve system 0).1 = 1 := rfl
        have reducedValue : (gaugeSequence solve system 0).2 = system 0 := rfl
        refine (gaugeTransform_succ_iff (system := system)
          (gauge := fun order => (gaugeSequence solve system order).1)
          (reduced := fun order => (gaugeSequence solve system order).2)
          leadingValue reducedValue step).mpr ?_
        have equation := solveEquation (gaugeResidual system
          (fun order => (gaugeSequence solve system order).1)
          (fun order => (gaugeSequence solve system order).2) (step + 1))
        rw [← gaugeSequence_succ solve system step] at equation
        exact equation

/-- The first two and last two coordinates are the two blocks. -/
def twoByTwoBlockLabel : Fin 4 → Fin 2 := ![0,0,1,1]

/-- The off-diagonal gauge coefficient solving a residual equation for the
leading blocks `[[0,t],[1,0]]` and `[[0,1],[0,0]]`. -/
def twoByTwoGaugeStep {K : Type*} [Field K] (t : K)
    (r : Matrix (Fin 4) (Fin 4) K) : Matrix (Fin 4) (Fin 4) K :=
  !![0,0,-r 1 2,-r 1 3-r 0 2/t;
     0,0,-r 0 2/t,-(r 0 3+r 1 2)/t;
     (r 3 0+r 2 1)/t,r 3 1/t+r 2 0,0,0;
     r 3 1/t,r 3 0,0,0]

/-- The rational Sylvester solution is block off-diagonal. -/
theorem twoByTwoGaugeStep_offDiagonal {K : Type*} [Field K]
    (t : K) (r : Matrix (Fin 4) (Fin 4) K) :
    IsBlockOffDiagonal twoByTwoBlockLabel (twoByTwoGaugeStep t r) := by
  intro row column h
  fin_cases row <;> fin_cases column <;>
    simp_all [twoByTwoBlockLabel, twoByTwoGaugeStep]

/-- The explicit step solver satisfies the full residual equation whenever
`t` is nonzero; no individual eigenvalues of the nonzero block are required. -/
theorem twoByTwoGaugeStep_equation {K : Type*} [Field K]
    {a b q : K} (ht : (2*a+b)*q ≠ 0) (r : Matrix (Fin 4) (Fin 4) K) :
    blockDiagonalProjection twoByTwoBlockLabel r +
      (twoByTwoGaugeStep ((2*a+b)*q) r * parameterizedEulerBlocks a b q -
        parameterizedEulerBlocks a b q * twoByTwoGaugeStep ((2*a+b)*q) r) = r := by
  ext row column
  fin_cases row <;> fin_cases column <;>
    simp [twoByTwoGaugeStep, twoByTwoBlockLabel, parameterizedEulerBlocks] <;> field_simp [mul_ne_zero_iff.mp ht |>.1, mul_ne_zero_iff.mp ht |>.2] <;> ring

/-- Every formal system with the specified separated rank-two leading blocks
admits a normalized two-block gauge over the original coefficient field. -/
theorem twoByTwo_exists_normalizedGauge {K : Type*} [Field K]
    {a b q : K} (ht : (2*a+b)*q ≠ 0)
    (system : ℕ → Matrix (Fin 4) (Fin 4) K)
    (leading : system 0 = parameterizedEulerBlocks a b q) :
    ∃ gauge reduced, IsNormalizedGauge twoByTwoBlockLabel system gauge reduced := by
  apply exists_normalizedGauge_of_step_solver twoByTwoBlockLabel system
    (solve := fun r => (twoByTwoGaugeStep ((2*a+b)*q) r,
      blockDiagonalProjection twoByTwoBlockLabel r))
  · rw [leading]
    intro row column h
    fin_cases row <;> fin_cases column <;>
      simp_all [twoByTwoBlockLabel, parameterizedEulerBlocks]
  · exact twoByTwoGaugeStep_offDiagonal _
  · exact isBlockDiagonal_blockDiagonalProjection _
  · intro r
    simpa only [leading] using twoByTwoGaugeStep_equation ht r


set_option maxHeartbeats 1000000 in
/-- The rational step solver recovers every off-diagonal unknown from its
residual, even when an arbitrary block-diagonal term is added. Consequently
the normalized off-diagonal coefficient at each order is unique. -/
theorem twoByTwoGaugeStep_recovers {K : Type*} [Field K]
    {a b q : K} (ht : (2*a+b)*q ≠ 0)
    (x d : Matrix (Fin 4) (Fin 4) K)
    (off : IsBlockOffDiagonal twoByTwoBlockLabel x)
    (diag : IsBlockDiagonal twoByTwoBlockLabel d) :
    twoByTwoGaugeStep ((2*a+b)*q)
      (d+(x*parameterizedEulerBlocks a b q-parameterizedEulerBlocks a b q*x)) = x := by
  have h00 : x 0 0 = 0 := off 0 0 (by decide)
  have h01 : x 0 1 = 0 := off 0 1 (by decide)
  have h02 : d 0 2 = 0 := diag 0 2 (by decide)
  have h03 : d 0 3 = 0 := diag 0 3 (by decide)
  have h10 : x 1 0 = 0 := off 1 0 (by decide)
  have h11 : x 1 1 = 0 := off 1 1 (by decide)
  have h12 : d 1 2 = 0 := diag 1 2 (by decide)
  have h13 : d 1 3 = 0 := diag 1 3 (by decide)
  have h20 : d 2 0 = 0 := diag 2 0 (by decide)
  have h21 : d 2 1 = 0 := diag 2 1 (by decide)
  have h22 : x 2 2 = 0 := off 2 2 (by decide)
  have h23 : x 2 3 = 0 := off 2 3 (by decide)
  have h30 : d 3 0 = 0 := diag 3 0 (by decide)
  have h31 : d 3 1 = 0 := diag 3 1 (by decide)
  have h32 : x 3 2 = 0 := off 3 2 (by decide)
  have h33 : x 3 3 = 0 := off 3 3 (by decide)
  ext row column
  fin_cases row <;> fin_cases column <;>
    simp [twoByTwoGaugeStep, parameterizedEulerBlocks, Matrix.mul_apply, Matrix.vecMul, dotProduct,
      Fin.sum_univ_succ, h00, h01, h02, h03, h10, h11, h12, h13, h20, h21, h22, h23, h30, h31, h32, h33] <;>
    (try field_simp [mul_ne_zero_iff.mp ht |>.1, mul_ne_zero_iff.mp ht |>.2]) <;> ring


/-- Two normalized solutions of one residual equation agree in both their
off-diagonal gauge coefficient and their block-diagonal reduced coefficient. -/
theorem twoByTwoGaugeStep_unique {K : Type*} [Field K]
    {a b q : K} (ht : (2*a+b)*q ≠ 0)
    {x y d e r : Matrix (Fin 4) (Fin 4) K}
    (offX : IsBlockOffDiagonal twoByTwoBlockLabel x)
    (offY : IsBlockOffDiagonal twoByTwoBlockLabel y)
    (diagD : IsBlockDiagonal twoByTwoBlockLabel d)
    (diagE : IsBlockDiagonal twoByTwoBlockLabel e)
    (hx : d+(x*parameterizedEulerBlocks a b q-parameterizedEulerBlocks a b q*x) = r)
    (hy : e+(y*parameterizedEulerBlocks a b q-parameterizedEulerBlocks a b q*y) = r) :
    x=y ∧ d=e := by
  have h1 := twoByTwoGaugeStep_recovers ht x d offX diagD
  have h2 := twoByTwoGaugeStep_recovers ht y e offY diagE
  rw [hx] at h1
  rw [hy] at h2
  have hxy := h1.symm.trans h2
  refine ⟨hxy, ?_⟩
  rw [hxy] at hx
  linear_combination (norm := abel) hx-hy

/-- The formal two-block system obtained by the rational leading basis change
has only an Euler coefficient and a grading coefficient. -/
def parameterizedSeparatedSystem {K : Type*} [Field K] (a b q : K) :
    ℕ → Matrix (Fin 4) (Fin 4) K
  | 0 => parameterizedEulerBlocks a b q
  | 1 => parameterizedGradingBlocks a b
  | _ + 2 => 0

/-- The first gauge and reduced coefficients, and the second lower-left entry
of the zero block, are forced by the complete normalized gauge equation. -/
theorem parameterizedNormalizedGauge_coefficients {K : Type*} [Field K] [CharZero K]
    {a b q : K} (sumNonzero : 2*a+b ≠ 0) (qNonzero : q ≠ 0)
    {gauge reduced : ℕ → Matrix (Fin 4) (Fin 4) K}
    (normalized : IsNormalizedGauge twoByTwoBlockLabel
      (parameterizedSeparatedSystem a b q) gauge reduced) :
    gauge 1 = parameterizedGaugeFirst a b q ∧
      reduced 1 = parameterizedReducedFirst a b ∧
      reduced 2 3 2 = -4*a^2/(2*a+b)^2 := by
  have reducedZero := reduced_zero_eq normalized.leading normalized.transform
  have firstOrder := (gaugeTransform_succ_iff normalized.leading reducedZero 0).mp
    (normalized.transform 1)
  have firstResidual : gaugeResidual (parameterizedSeparatedSystem a b q) gauge reduced 1
      = parameterizedGradingBlocks a b := by
    rw [gaugeResidual, sourceConvolution, interiorConvolution]
    simp [normalized.leading, parameterizedSeparatedSystem]
  rw [firstResidual] at firstOrder
  have firstExhibited : parameterizedReducedFirst a b +
      (parameterizedGaugeFirst a b q * parameterizedEulerBlocks a b q -
       parameterizedEulerBlocks a b q * parameterizedGaugeFirst a b q) =
      parameterizedGradingBlocks a b := by
    have identity := parameterizedReduction_first_order sumNonzero qNonzero
    linear_combination (norm := abel) -identity
  have off : IsBlockOffDiagonal twoByTwoBlockLabel (parameterizedGaugeFirst a b q) := by
    intro row column h
    fin_cases row <;> fin_cases column <;>
      simp_all [twoByTwoBlockLabel, parameterizedGaugeFirst]
  have diag : IsBlockDiagonal twoByTwoBlockLabel (parameterizedReducedFirst a b) := by
    intro row column h
    fin_cases row <;> fin_cases column <;>
      simp_all [twoByTwoBlockLabel, parameterizedReducedFirst]
  obtain ⟨gaugeFirst, reducedFirst⟩ := twoByTwoGaugeStep_unique (mul_ne_zero sumNonzero qNonzero)
    (normalized.gaugeOffDiagonal 1 (by omega)) off (normalized.reducedDiagonal 1) diag
    firstOrder firstExhibited
  refine ⟨gaugeFirst, reducedFirst, ?_⟩
  have secondOrder := (gaugeTransform_succ_iff normalized.leading reducedZero 1).mp
    (normalized.transform 2)
  have secondResidual : gaugeResidual (parameterizedSeparatedSystem a b q) gauge reduced 2
      = parameterizedSecondCorrection a b q := by
    rw [gaugeResidual, sourceConvolution, interiorConvolution]
    simp [normalized.leading, gaugeFirst, reducedFirst, Finset.sum_Ico_succ_top,
      parameterizedSeparatedSystem, parameterizedSecondCorrection]
  rw [secondResidual] at secondOrder
  have equation : reduced 2 = 0 + parameterizedSecondCorrection a b q +
      (parameterizedEulerBlocks a b q * gauge 2 - gauge 2 * parameterizedEulerBlocks a b q) := by
    change reduced 2 + (gauge 2 * parameterizedEulerBlocks a b q -
      parameterizedEulerBlocks a b q * gauge 2) = _ at secondOrder
    linear_combination (norm := abel) secondOrder
  simpa [neg_div] using parameterizedReduction_second_order_lowerLeft a b q 0 (gauge 2) (reduced 2) equation


/-- Two normalized gauges for the same two-block formal system agree at every
order, together with their reduced systems. -/
theorem twoByTwo_normalizedGauge_unique {K : Type*} [Field K]
    {a b q : K} (ht : (2*a+b)*q ≠ 0)
    {system gauge reduced gaugeOther reducedOther : ℕ → Matrix (Fin 4) (Fin 4) K}
    (leading : system 0 = parameterizedEulerBlocks a b q)
    (first : IsNormalizedGauge twoByTwoBlockLabel system gauge reduced)
    (second : IsNormalizedGauge twoByTwoBlockLabel system gaugeOther reducedOther) :
    ∀ order, gauge order = gaugeOther order ∧ reduced order = reducedOther order := by
  intro order
  induction order using Nat.strong_induction_on with
  | _ order inductionHypothesis =>
    match order with
    | 0 =>
        exact ⟨first.leading.trans second.leading.symm,
          (reduced_zero_eq first.leading first.transform).trans
            (reduced_zero_eq second.leading second.transform).symm⟩
    | step + 1 =>
        have gaugeAgreement : ∀ index, index ≤ step → gauge index = gaugeOther index :=
          fun index bound => (inductionHypothesis index (by omega)).1
        have reducedAgreement : ∀ index, index ≤ step → reduced index = reducedOther index :=
          fun index bound => (inductionHypothesis index (by omega)).2
        have residualAgreement := gaugeResidual_congr (system := system)
          gaugeAgreement reducedAgreement
        have firstIdentity := (gaugeTransform_succ_iff first.leading
          (reduced_zero_eq first.leading first.transform) step).mp (first.transform (step + 1))
        have secondIdentity := (gaugeTransform_succ_iff second.leading
          (reduced_zero_eq second.leading second.transform) step).mp (second.transform (step + 1))
        rw [residualAgreement] at firstIdentity
        rw [leading] at firstIdentity secondIdentity
        exact twoByTwoGaugeStep_unique ht
          (first.gaugeOffDiagonal (step + 1) (by omega))
          (second.gaugeOffDiagonal (step + 1) (by omega))
          (first.reducedDiagonal (step + 1)) (second.reducedDiagonal (step + 1))
          firstIdentity secondIdentity

/-- The formal rank-two series extracted from the last two coordinates of a
four-dimensional coefficient sequence. -/
noncomputable def lastRankTwoBlockSeries {K : Type*} [Field K]
    (reduced : ℕ → Matrix (Fin 4) (Fin 4) K) : PowerSeries (Matrix (Fin 2) (Fin 2) K) :=
  PowerSeries.mk fun n => !![reduced n 2 2, reduced n 2 3; reduced n 3 2, reduced n 3 3]

/-- Every complete normalized gauge of the parameterized system gives exactly
the displayed modified residue on its rank-two zero block. The residue is
computed from an actual power series via the elementary modification. -/
theorem parameterizedNormalizedGauge_modifiedResidue {K : Type*} [Field K] [CharZero K]
    {a b q : K} (sumNonzero : 2*a+b ≠ 0) (qNonzero : q ≠ 0)
    {gauge reduced : ℕ → Matrix (Fin 4) (Fin 4) K}
    (normalized : IsNormalizedGauge twoByTwoBlockLabel
      (parameterizedSeparatedSystem a b q) gauge reduced) :
    modifiedResidue (lastRankTwoBlockSeries reduced) = parameterizedModifiedResidue a b := by
  obtain ⟨_, first, second⟩ := parameterizedNormalizedGauge_coefficients sumNonzero qNonzero normalized
  have zeroth := reduced_zero_eq normalized.leading normalized.transform
  rw [modifiedResidue_eq]
  simp only [lastRankTwoBlockSeries, PowerSeries.coeff_mk]
  rw [first, zeroth, second]
  have identity := parameterizedModifiedResidue_from_coefficients (q := q) sumNonzero
  rw [parameterizedSecondCorrection_lowerLeft] at identity
  exact identity

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum
