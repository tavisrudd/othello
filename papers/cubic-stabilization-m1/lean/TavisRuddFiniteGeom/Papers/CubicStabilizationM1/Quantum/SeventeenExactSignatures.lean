import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.NineRankTwoResidues
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.ExactResidueSelectors

/-!
# Exact signatures of the seventeen counting labels

Rank-two signatures are computed from the verified residue matrices, with
zero discriminants omitted and discriminant one retained. The four rank-three
entries use the stated full odd dimensions 104, 60, 40 and 28. The four
simple-spectrum controls have zero signature. Exhaustive constructor proofs
check the nine positive labels and eight controls. This is a finite algebraic
table; its identification with geometric primary factors, the Hodge numbers,
and rationality of the controls remain separate source inputs.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum

/-- The computed exact residue contribution of one of the nine rank-two matrices. -/
noncomputable def rankTwoCountingExactSignature (label : RankTwoCountingLabel) : (ℚ →₀ ℕ) × ℕ :=
  (exactDiscriminantAtom (residueDiscriminant (rankTwoCountingResidue label)),0)

/-- The exact finite endpoint signature: actual rank-two residues, the four
specified full odd dimensions, and zero simple-spectrum controls. -/
noncomputable def countingExactSignature : CountingMatrixLabel → (ℚ →₀ ℕ) × ℕ
  | .genus2 => (0,104)
  | .genus3 => (0,60)
  | .genus4 => (0,40)
  | .genus5 => (0,28)
  | .genus6 => rankTwoCountingExactSignature .genus6
  | .genus7 => rankTwoCountingExactSignature .genus7
  | .genus8 => rankTwoCountingExactSignature .genus8
  | .genus9 => rankTwoCountingExactSignature .genus9
  | .genus10 => rankTwoCountingExactSignature .genus10
  | .degree1 => rankTwoCountingExactSignature .degree1
  | .degree2 => rankTwoCountingExactSignature .degree2
  | .degree3 => rankTwoCountingExactSignature .degree3
  | .degree4 => rankTwoCountingExactSignature .degree4
  | .genus12 | .degree5 | .quadric | .projectiveSpace => 0

/-- The five eligible nonzero rank-two labels and four positive rank-three labels. -/
def CountingMatrixLabel.detected : CountingMatrixLabel → Bool
  | .genus2 | .genus3 | .genus4 | .genus5 | .genus6 | .genus8
  | .degree1 | .degree2 | .degree3 => true
  | _ => false

/-- Evaluation of the exact table uses the proved residue calculation. -/
theorem rankTwoCountingExactSignature_eq (label : RankTwoCountingLabel) :
    rankTwoCountingExactSignature label = (exactDiscriminantAtom (rankTwoCountingDiscriminant label),0) := by
  simp [rankTwoCountingExactSignature, rankTwoCountingResidue_discriminant]

/-- Exactly the nine designated labels have nonzero exact signatures. -/
theorem countingExactSignature_ne_zero_iff (label : CountingMatrixLabel) :
    countingExactSignature label ≠ 0 ↔ label.detected=true := by
  cases label <;>
    norm_num [countingExactSignature, rankTwoCountingExactSignature_eq,
      rankTwoCountingDiscriminant, exactDiscriminantAtom, CountingMatrixLabel.detected]

/-- The detected and zero-control label domains have cardinalities nine and eight. -/
theorem countingExactSignature_label_counts :
    Fintype.card {label : CountingMatrixLabel // label.detected=true}=9 ∧
      Fintype.card {label : CountingMatrixLabel // label.detected=false}=8 := by decide

/-- Doubling the effective exact signature cannot erase a positive entry. -/
theorem countingExactSignature_double_ne_zero_iff (label : CountingMatrixLabel) :
    2 • countingExactSignature label ≠ 0 ↔ label.detected=true := by
  rw [← countingExactSignature_ne_zero_iff]
  simp

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum
