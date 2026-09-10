import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.InvertibleComplementGauge

/-!
# Modified residues beside an invertible rank-two companion

For the formal system `J+zB`, the normalized first gauge is the explicit
Sylvester solution and the first reduced coefficient is the block-diagonal
part of `B`. The second lower-left entry of the nilpotent block is `(BX)₃₂`.
This computes the elementary-modification residue of the actual extracted
power series. Vanishing of `B₃₂` is stated separately when regularity of that
modification is asserted.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum

/-- The two-term system with a nilpotent and an invertible rank-two leading block. -/
def invertibleComplementSystem {K : Type*} [Field K] (h t : K)
    (regular : Matrix (Fin 4) (Fin 4) K) : ℕ → Matrix (Fin 4) (Fin 4) K
  | 0 => invertibleComplementBlocks h t
  | 1 => regular
  | _ + 2 => 0

/-- The residue matrix computed from the regular coefficient and its uniquely
determined first off-diagonal Sylvester correction. -/
def invertibleComplementResidue {K : Type*} [Field K] (h t : K)
    (regular : Matrix (Fin 4) (Fin 4) K) : Matrix (Fin 2) (Fin 2) K :=
  !![regular 2 2,1;
     (regular * invertibleComplementGaugeStep h t regular) 3 2,regular 3 3-1]

/-- The full normalized gauge equation determines the first gauge, the first
reduced coefficient, and the second lower-left entry of the nilpotent block. -/
theorem invertibleComplementNormalizedGauge_coefficients {K : Type*} [Field K]
    (h : K) {t : K} (ht : t ≠ 0) (regular : Matrix (Fin 4) (Fin 4) K)
    {gauge reduced : ℕ → Matrix (Fin 4) (Fin 4) K}
    (normalized : IsNormalizedGauge twoByTwoBlockLabel
      (invertibleComplementSystem h t regular) gauge reduced) :
    gauge 1 = invertibleComplementGaugeStep h t regular ∧
      reduced 1 = blockDiagonalProjection twoByTwoBlockLabel regular ∧
      reduced 2 3 2 = (regular * invertibleComplementGaugeStep h t regular) 3 2 := by
  have reducedZero := reduced_zero_eq normalized.leading normalized.transform
  have firstOrder := (gaugeTransform_succ_iff normalized.leading reducedZero 0).mp
    (normalized.transform 1)
  have firstResidual : gaugeResidual (invertibleComplementSystem h t regular) gauge reduced 1
      = regular := by
    rw [gaugeResidual, sourceConvolution, interiorConvolution]
    simp [normalized.leading, invertibleComplementSystem]
  rw [firstResidual] at firstOrder
  obtain ⟨gaugeFirst,reducedFirst⟩ := invertibleComplementGaugeStep_unique h ht
    (normalized.gaugeOffDiagonal 1 (by omega)) (invertibleComplementGaugeStep_offDiagonal h t regular)
    (normalized.reducedDiagonal 1) (isBlockDiagonal_blockDiagonalProjection _ _)
    firstOrder (invertibleComplementGaugeStep_equation h ht regular)
  refine ⟨gaugeFirst,reducedFirst,?_⟩
  have secondOrder := (gaugeTransform_succ_iff normalized.leading reducedZero 1).mp
    (normalized.transform 2)
  have secondResidual : gaugeResidual (invertibleComplementSystem h t regular) gauge reduced 2 =
      regular * invertibleComplementGaugeStep h t regular -
      invertibleComplementGaugeStep h t regular * blockDiagonalProjection twoByTwoBlockLabel regular -
      invertibleComplementGaugeStep h t regular := by
    rw [gaugeResidual, sourceConvolution, interiorConvolution]
    simp [normalized.leading, gaugeFirst, reducedFirst, Finset.sum_Ico_succ_top,
      invertibleComplementSystem]
  rw [secondResidual] at secondOrder
  have entry := congrArg (fun m : Matrix (Fin 4) (Fin 4) K => m 3 2) secondOrder
  have commutator : (gauge 2 * invertibleComplementBlocks h t -
      invertibleComplementBlocks h t * gauge 2) 3 2=0 := by
    simp [invertibleComplementBlocks, Matrix.mul_apply, Fin.sum_univ_four,
      Matrix.vecMul, dotProduct]
  have diagonalProduct : (invertibleComplementGaugeStep h t regular *
      blockDiagonalProjection twoByTwoBlockLabel regular) 3 2=0 := by
    simp [invertibleComplementGaugeStep, Matrix.mul_apply, Fin.sum_univ_four,
      twoByTwoBlockLabel]
  change reduced 2 3 2 + (gauge 2 * invertibleComplementBlocks h t -
      invertibleComplementBlocks h t * gauge 2) 3 2 = _ at entry
  simpa only [commutator, add_zero, Matrix.sub_apply, diagonalProduct,
    show invertibleComplementGaugeStep h t regular 3 2=0 from rfl, sub_zero] using entry

/-- The actual formal zero block of every normalized gauge has the computed
modified residue. No precomputed discriminant enters this statement. -/
theorem invertibleComplementNormalizedGauge_modifiedResidue {K : Type*} [Field K]
    (h : K) {t : K} (ht : t ≠ 0) (regular : Matrix (Fin 4) (Fin 4) K)
    {gauge reduced : ℕ → Matrix (Fin 4) (Fin 4) K}
    (normalized : IsNormalizedGauge twoByTwoBlockLabel
      (invertibleComplementSystem h t regular) gauge reduced) :
    modifiedResidue (lastRankTwoBlockSeries reduced) = invertibleComplementResidue h t regular := by
  obtain ⟨_,first,second⟩ := invertibleComplementNormalizedGauge_coefficients h ht regular normalized
  have zeroth := reduced_zero_eq normalized.leading normalized.transform
  rw [modifiedResidue_eq]
  simp only [lastRankTwoBlockSeries, PowerSeries.coeff_mk]
  rw [first,zeroth,second]
  simp [invertibleComplementSystem, invertibleComplementBlocks, invertibleComplementResidue,
    twoByTwoBlockLabel]

/-- A complete normalized gauge with adapted regular zero block exists when
`t` is nonzero and the first zero-block coefficient preserves the nilpotent line. -/
theorem invertibleComplement_exists_gauge_with_residue {K : Type*} [Field K]
    (h : K) {t : K} (ht : t ≠ 0) (regular : Matrix (Fin 4) (Fin 4) K)
    (line : regular 3 2=0) :
    ∃ gauge reduced, IsNormalizedGauge twoByTwoBlockLabel
      (invertibleComplementSystem h t regular) gauge reduced ∧
      PowerSeries.coeff 0 (lastRankTwoBlockSeries reduced) = adaptedLeadingOperator 1 ∧
      (PowerSeries.coeff 1 (lastRankTwoBlockSeries reduced)) 1 0=0 ∧
      modifiedResidue (lastRankTwoBlockSeries reduced) = invertibleComplementResidue h t regular := by
  obtain ⟨gauge,reduced,normalized⟩ := invertibleComplement_exists_normalizedGauge h ht
    (invertibleComplementSystem h t regular) rfl
  have zeroth := reduced_zero_eq normalized.leading normalized.transform
  have first := (invertibleComplementNormalizedGauge_coefficients h ht regular normalized).2.1
  refine ⟨gauge,reduced,normalized,?_,?_,
    invertibleComplementNormalizedGauge_modifiedResidue h ht regular normalized⟩
  · simp [lastRankTwoBlockSeries, zeroth, invertibleComplementSystem,
      invertibleComplementBlocks, adaptedLeadingOperator]
  · simp [lastRankTwoBlockSeries, first, twoByTwoBlockLabel, line]

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum
