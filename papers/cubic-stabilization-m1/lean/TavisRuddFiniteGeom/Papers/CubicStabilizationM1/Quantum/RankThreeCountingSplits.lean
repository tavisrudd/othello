import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.SeventeenCountingMatrices
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.NormalizedSylvesterGauge

/-!
# The four rank-three zero-primary counting blocks

The genus-two through genus-five rational matrices have characteristic
polynomial `T³(T-t)` with nonzero `t`. Explicit bases identify each actual
matrix with a rank-three nilpotent Jordan block plus the scalar `t`.
The basis determinants and intertwining identities are checked exhaustively.
The separated leading blocks have a normalized formal gauge for arbitrary
higher coefficients. Geometric family and Hodge-number identifications remain
outside these matrix statements.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum

/-- The four labels with a rank-three zero-primary block. -/
inductive RankThreeCountingLabel
  | genus2 | genus3 | genus4 | genus5
  deriving DecidableEq, Fintype

/-- Inclusion of the four rank-three cases into the seventeen-entry domain. -/
def RankThreeCountingLabel.toCountingLabel : RankThreeCountingLabel → CountingMatrixLabel
  | .genus2 => .genus2
  | .genus3 => .genus3
  | .genus4 => .genus4
  | .genus5 => .genus5

/-- The complementary nonzero eigenvalue of each rank-three case. -/
def RankThreeCountingLabel.complement : RankThreeCountingLabel → ℚ
  | .genus2 => 1728
  | .genus3 => 256
  | .genus4 => 108
  | .genus5 => 64

/-- A cyclic-coordinate basis that separates `T³(T-t)` into its two primary
blocks, ordered with the rank-three zero block first. -/
def rankThreeCyclicSplitBasis {K : Type*} [CommRing K] (t : K) :
    Matrix (Fin 4) (Fin 4) K :=
  !![0,0,-t,0; 0,-t,1,0; -t,1,0,0; 1,0,0,1]

/-- The split leading operator: a size-three nilpotent Jordan block and `t`. -/
def rankThreeCountingBlocks {K : Type*} [CommRing K] (t : K) :
    Matrix (Fin 4) (Fin 4) K :=
  !![0,1,0,0; 0,0,1,0; 0,0,0,0; 0,0,0,t]

/-- The explicit split basis in the original rational counting coordinates. -/
def rankThreeCountingBasis (label : RankThreeCountingLabel) :
    Matrix (Fin 4) (Fin 4) ℚ :=
  let p := countingMatrixParameters label.toCountingLabel
  countingMatrixCyclicBasis (p 0) (p 1) (p 2) (p 3) (p 4) *
    rankThreeCyclicSplitBasis label.complement

/-- The cyclic-coordinate split basis has determinant `t³`. -/
theorem rankThreeCyclicSplitBasis_det {K : Type*} [CommRing K] (t : K) :
    (rankThreeCyclicSplitBasis t).det = t^3 := by
  simp [rankThreeCyclicSplitBasis, Matrix.det_succ_row_zero, Fin.sum_univ_succ,
    Fin.succAbove, Matrix.submatrix_apply]
  ring

/-- Every displayed split basis is invertible, with determinant the cube of
the nonzero complementary eigenvalue. -/
theorem rankThreeCountingBasis_det (label : RankThreeCountingLabel) :
    (rankThreeCountingBasis label).det = label.complement^3 ∧ label.complement ≠ 0 := by
  constructor
  · simp [rankThreeCountingBasis, Matrix.det_mul, countingMatrixCyclicBasis_det,
      rankThreeCyclicSplitBasis_det]
  · cases label <;> norm_num [RankThreeCountingLabel.complement]

set_option maxHeartbeats 1000000 in
/-- The four rational leading matrices are genuinely intertwined with the
rank-three-plus-one block form by the displayed invertible bases. -/
theorem rankThreeCountingBasis_intertwines (label : RankThreeCountingLabel) :
    labeledCountingMatrix label.toCountingLabel * rankThreeCountingBasis label =
      rankThreeCountingBasis label * rankThreeCountingBlocks label.complement := by
  cases label <;> ext row column <;> fin_cases row <;> fin_cases column <;>
    norm_num [labeledCountingMatrix, rankThreeCountingBasis, countingMatrixParameters,
      sixCountingParameters, countingMatrixCyclicBasis, fourDimensionalCountingMatrix,
      rankThreeCyclicSplitBasis, rankThreeCountingBlocks, RankThreeCountingLabel.toCountingLabel,
      RankThreeCountingLabel.complement]

/-- The first three coordinates form one block and the last forms the other. -/
def rankThreeCountingBlockLabel : Fin 4 → Fin 2 := ![0,0,0,1]

/-- Every formal system with one of these split leading operators admits an
all-orders normalized gauge separating the rank-three and rank-one blocks. -/
theorem rankThreeCounting_exists_normalizedGauge
    (label : RankThreeCountingLabel) (system : ℕ → Matrix (Fin 4) (Fin 4) ℚ)
    (leading : system 0 = rankThreeCountingBlocks label.complement) :
    ∃ gauge reduced, IsNormalizedGauge rankThreeCountingBlockLabel system gauge reduced := by
  apply exists_normalizedGauge (scalar := ![0,label.complement])
  · intro first second h
    have nonzero := (rankThreeCountingBasis_det label).2
    fin_cases first <;> fin_cases second <;> simp_all [isUnit_iff_ne_zero]
  · rw [leading]
    intro row column h
    fin_cases row <;> fin_cases column <;>
      simp_all [rankThreeCountingBlockLabel, rankThreeCountingBlocks]
  · rw [leading]
    have difference : rankThreeCountingBlocks label.complement -
        Matrix.diagonal (fun i => ![0,label.complement] (rankThreeCountingBlockLabel i)) =
        rankThreeCountingBlocks (0 : ℚ) := by
      ext row column
      fin_cases row <;> fin_cases column <;>
        simp [rankThreeCountingBlockLabel, rankThreeCountingBlocks, Matrix.diagonal]
    rw [difference]
    refine ⟨3, ?_⟩
    ext row column
    fin_cases row <;> fin_cases column <;>
      simp [rankThreeCountingBlocks, pow_succ]

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum
