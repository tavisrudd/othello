import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.RankTwoCountingBases
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.InvertibleComplementResidue

/-!
# Nine exact rank-two modified residues

The regular coefficient is computed by conjugating the actual rational grading
matrix with each explicitly verified counting-matrix basis. The all-orders
normalized gauge theorem then extracts a regular modified zero block. Its exact
residue discriminant is checked in all nine cases, including discriminant one
and the four zero-discriminant controls. No exponent is reduced modulo integers.
Geometric quantum-product identifications remain outside these finite systems.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum

/-- The actual grading coefficient in the rational split basis. -/
def rankTwoCountingRegular (label : RankTwoCountingLabel) : Matrix (Fin 4) (Fin 4) ℚ :=
  rankTwoCountingBasisInverse label * parameterizedGradingMatrix * rankTwoCountingBasis label

/-- The first Sylvester correction computes the modified residue for each
split rational connection; its input is the conjugated grading matrix. -/
def rankTwoCountingResidue (label : RankTwoCountingLabel) : Matrix (Fin 2) (Fin 2) ℚ :=
  invertibleComplementResidue label.complementTrace label.complementParameter
    (rankTwoCountingRegular label)

/-- Expected exact discriminants for the nine rational systems, verified by
matrix calculation below. A value one is retained as a nonzero discriminant. -/
def rankTwoCountingDiscriminant : RankTwoCountingLabel → ℚ
  | .genus6 => 1
  | .genus7 => 0
  | .genus8 => 4/9
  | .genus9 => 0
  | .genus10 => 0
  | .degree1 => 16/9
  | .degree2 => 1
  | .degree3 => 4/9
  | .degree4 => 0

/-- The grading coefficient is intertwined by the same basis as the Euler
coefficient, so the two coefficients define one changed formal system. -/
theorem rankTwoCountingRegular_intertwines (label : RankTwoCountingLabel) :
    parameterizedGradingMatrix * rankTwoCountingBasis label =
      rankTwoCountingBasis label * rankTwoCountingRegular label := by
  simp only [rankTwoCountingRegular]
  rw [← Matrix.mul_assoc, ← Matrix.mul_assoc, (rankTwoCountingBasis_inverse label).1,
    one_mul]

set_option maxHeartbeats 2000000 in
/-- In all nine systems the first zero-block coefficient preserves the leading
nilpotent line, ensuring regularity after elementary modification. -/
theorem rankTwoCountingRegular_preserves_line (label : RankTwoCountingLabel) :
    rankTwoCountingRegular label 3 2=0 := by
  cases label <;>
    norm_num [rankTwoCountingRegular, rankTwoCountingBasisInverse, rankTwoCountingBasis,
      rankTwoCyclicSplitBasisInverse, rankTwoCyclicSplitBasis, countingMatrixCyclicBasisInverse,
      countingMatrixCyclicBasis, countingMatrixParameters, sixCountingParameters,
      RankTwoCountingLabel.toCountingLabel, RankTwoCountingLabel.complementTrace,
      RankTwoCountingLabel.complementParameter, parameterizedGradingMatrix,
      Matrix.cons_val_two, Matrix.cons_val_three, Matrix.vecHead, Matrix.vecTail]

set_option maxHeartbeats 4000000 in
/-- Exhaustive kernel-checked evaluation of the discriminant from the actual
conjugated grading and the rational Sylvester correction in all nine cases. -/
theorem rankTwoCountingResidue_discriminant (label : RankTwoCountingLabel) :
    residueDiscriminant (rankTwoCountingResidue label) = rankTwoCountingDiscriminant label := by
  cases label <;>
    norm_num [rankTwoCountingResidue, invertibleComplementResidue, invertibleComplementGaugeStep,
      rankTwoCountingRegular, rankTwoCountingBasisInverse, rankTwoCountingBasis,
      rankTwoCyclicSplitBasisInverse, rankTwoCyclicSplitBasis, countingMatrixCyclicBasisInverse,
      countingMatrixCyclicBasis, countingMatrixParameters, sixCountingParameters,
      RankTwoCountingLabel.toCountingLabel, RankTwoCountingLabel.complementTrace,
      RankTwoCountingLabel.complementParameter, parameterizedGradingMatrix,
      residueDiscriminant, Matrix.trace_fin_two, Matrix.det_fin_two, rankTwoCountingDiscriminant,
      Matrix.cons_val_two, Matrix.cons_val_three, Matrix.vecHead, Matrix.vecTail]

/-- Every one of the nine connections has a complete normalized gauge whose
actual power-series zero block is adapted, regularly modifiable, and has the
computed exact discriminant. The discriminant is a conclusion of the matrix
calculation, not a supplied invariant of the connection. -/
theorem rankTwoCounting_exists_gauge_with_exact_discriminant (label : RankTwoCountingLabel) :
    ∃ gauge reduced, IsNormalizedGauge twoByTwoBlockLabel
      (invertibleComplementSystem label.complementTrace label.complementParameter
        (rankTwoCountingRegular label)) gauge reduced ∧
      PowerSeries.coeff 0 (lastRankTwoBlockSeries reduced) = adaptedLeadingOperator 1 ∧
      (PowerSeries.coeff 1 (lastRankTwoBlockSeries reduced)) 1 0=0 ∧
      residueDiscriminant (modifiedResidue (lastRankTwoBlockSeries reduced)) =
        rankTwoCountingDiscriminant label := by
  obtain ⟨gauge,reduced,normalized,adapted,line,residue⟩ :=
    invertibleComplement_exists_gauge_with_residue label.complementTrace
      (rankTwoCounting_complement_nonzero label) (rankTwoCountingRegular label)
      (rankTwoCountingRegular_preserves_line label)
  refine ⟨gauge,reduced,normalized,adapted,line,?_⟩
  rw [residue]
  exact rankTwoCountingResidue_discriminant label

/-- There are exactly nine rank-two constructors in the exhaustive domain. -/
theorem rankTwoCountingLabel_card : Fintype.card RankTwoCountingLabel = 9 := by decide

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum
