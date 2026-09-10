import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.SeventeenCountingMatrices
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.InvertibleComplementGauge

/-!
# Rational bases for the nine rank-two zero blocks

For a cyclic characteristic polynomial `T²(T²-hT-t)` with `t≠0`, a rational
basis separates the nilpotent rank-two block from its invertible companion.
The basis and its inverse are explicit. Specialization to nine rational
counting matrices checks actual intertwining identities, without adjoining
complementary eigenvalues or assuming an invariant value for any family.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum

/-- The nine table entries with a rank-two zero-primary block. -/
inductive RankTwoCountingLabel
  | genus6 | genus7 | genus8 | genus9 | genus10 | degree1 | degree2 | degree3 | degree4
  deriving DecidableEq, Fintype

/-- Inclusion of the rank-two cases into the full table. -/
def RankTwoCountingLabel.toCountingLabel : RankTwoCountingLabel → CountingMatrixLabel
  | .genus6 => .genus6
  | .genus7 => .genus7
  | .genus8 => .genus8
  | .genus9 => .genus9
  | .genus10 => .genus10
  | .degree1 => .degree1
  | .degree2 => .degree2
  | .degree3 => .degree3
  | .degree4 => .degree4

/-- The trace of the invertible complementary block. -/
def RankTwoCountingLabel.complementTrace : RankTwoCountingLabel → ℚ
  | .genus6 => 44
  | .genus7 => 34
  | .genus8 => 26
  | .genus9 => 24
  | .genus10 => 18
  | _ => 0

/-- The negative determinant of the invertible complementary block. -/
def RankTwoCountingLabel.complementParameter : RankTwoCountingLabel → ℚ
  | .genus6 => 16
  | .genus7 => -1
  | .genus8 => 27
  | .genus9 => -16
  | .genus10 => 27
  | .degree1 => 1728
  | .degree2 => 256
  | .degree3 => 108
  | .degree4 => 64

/-- The inverse of the determinant-one cyclic basis of a counting matrix. -/
def countingMatrixCyclicBasisInverse {K : Type*} [CommRing K] (a b c d e : K) :
    Matrix (Fin 4) (Fin 4) K :=
  !![1,-a,a*b-c,-a*b^2+b*c+a*d-e;
     0,1,-a-b,2*a*b+b^2-c-d;
     0,0,1,-a-2*b;
     0,0,0,1]

/-- Both inverse identities for the explicit cyclic basis hold over any
commutative ring, including at every degenerate spectrum. -/
theorem countingMatrixCyclicBasis_inverse {K : Type*} [CommRing K] (a b c d e : K) :
    countingMatrixCyclicBasis a b c d e * countingMatrixCyclicBasisInverse a b c d e = 1 ∧
      countingMatrixCyclicBasisInverse a b c d e * countingMatrixCyclicBasis a b c d e = 1 := by
  constructor <;> ext row column <;> fin_cases row <;> fin_cases column <;>
    simp [countingMatrixCyclicBasis, countingMatrixCyclicBasisInverse] <;> ring

/-- The split basis in cyclic coordinates, ordered with the invertible block
first and the nilpotent block last. -/
def rankTwoCyclicSplitBasis {K : Type*} [Field K] (h t : K) :
    Matrix (Fin 4) (Fin 4) K :=
  !![0,0,0,-t; 0,0,-t,-h; 1,0,-h,1; 0,1,1,0]

/-- The rational inverse of the cyclic-coordinate split basis. -/
def rankTwoCyclicSplitBasisInverse {K : Type*} [Field K] (h t : K) :
    Matrix (Fin 4) (Fin 4) K :=
  !![h^2/t^2+1/t,-h/t,1,0; -h/t^2,1/t,0,1;
     h/t^2,-1/t,0,0; -1/t,0,0,0]

/-- The cyclic-coordinate split basis and its displayed inverse are mutually
inverse exactly under the required nonvanishing assumption on `t`. -/
theorem rankTwoCyclicSplitBasis_inverse {K : Type*} [Field K]
    (h : K) {t : K} (ht : t ≠ 0) :
    rankTwoCyclicSplitBasis h t * rankTwoCyclicSplitBasisInverse h t = 1 ∧
      rankTwoCyclicSplitBasisInverse h t * rankTwoCyclicSplitBasis h t = 1 := by
  constructor <;> ext row column <;> fin_cases row <;> fin_cases column <;>
    simp [rankTwoCyclicSplitBasis, rankTwoCyclicSplitBasisInverse] <;>
    (try field_simp [ht]) <;> ring

/-- The split basis of each rank-two table matrix in its original coordinates. -/
def rankTwoCountingBasis (label : RankTwoCountingLabel) : Matrix (Fin 4) (Fin 4) ℚ :=
  let p := countingMatrixParameters label.toCountingLabel
  countingMatrixCyclicBasis (p 0) (p 1) (p 2) (p 3) (p 4) *
    rankTwoCyclicSplitBasis label.complementTrace label.complementParameter

/-- The explicit inverse split basis of each rank-two table matrix. -/
def rankTwoCountingBasisInverse (label : RankTwoCountingLabel) : Matrix (Fin 4) (Fin 4) ℚ :=
  let p := countingMatrixParameters label.toCountingLabel
  rankTwoCyclicSplitBasisInverse label.complementTrace label.complementParameter *
    countingMatrixCyclicBasisInverse (p 0) (p 1) (p 2) (p 3) (p 4)

/-- All nine complementary blocks are invertible. -/
theorem rankTwoCounting_complement_nonzero (label : RankTwoCountingLabel) :
    label.complementParameter ≠ 0 := by
  cases label <;> norm_num [RankTwoCountingLabel.complementParameter]

/-- Both inverse identities for every rational table basis. -/
theorem rankTwoCountingBasis_inverse (label : RankTwoCountingLabel) :
    rankTwoCountingBasis label * rankTwoCountingBasisInverse label = 1 ∧
      rankTwoCountingBasisInverse label * rankTwoCountingBasis label = 1 := by
  have cyclic := countingMatrixCyclicBasis_inverse
    (countingMatrixParameters label.toCountingLabel 0)
    (countingMatrixParameters label.toCountingLabel 1)
    (countingMatrixParameters label.toCountingLabel 2)
    (countingMatrixParameters label.toCountingLabel 3)
    (countingMatrixParameters label.toCountingLabel 4)
  have split := rankTwoCyclicSplitBasis_inverse label.complementTrace
    (rankTwoCounting_complement_nonzero label)
  constructor
  · simp only [rankTwoCountingBasis, rankTwoCountingBasisInverse]
    rw [Matrix.mul_assoc, ← Matrix.mul_assoc (rankTwoCyclicSplitBasis _ _), split.1,
      one_mul, cyclic.1]
  · simp only [rankTwoCountingBasis, rankTwoCountingBasisInverse]
    rw [Matrix.mul_assoc, ← Matrix.mul_assoc (countingMatrixCyclicBasisInverse _ _ _ _ _),
      cyclic.2, one_mul, split.2]

set_option maxHeartbeats 2000000 in
/-- Exhaustive actual intertwining identities for all nine rank-two matrices. -/
theorem rankTwoCountingBasis_intertwines (label : RankTwoCountingLabel) :
    labeledCountingMatrix label.toCountingLabel * rankTwoCountingBasis label =
      rankTwoCountingBasis label *
        invertibleComplementBlocks label.complementTrace label.complementParameter := by
  cases label <;> ext row column <;> fin_cases row <;> fin_cases column <;>
    norm_num [labeledCountingMatrix, rankTwoCountingBasis, countingMatrixParameters,
      sixCountingParameters, countingMatrixCyclicBasis, fourDimensionalCountingMatrix,
      rankTwoCyclicSplitBasis, invertibleComplementBlocks, RankTwoCountingLabel.toCountingLabel,
      RankTwoCountingLabel.complementTrace, RankTwoCountingLabel.complementParameter]

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum
