import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.FourDimensionalCountingMatrix

/-!
# Seventeen rational counting matrices

This module defines a finite domain of seventeen labels and an explicit
six-parameter rational matrix for each label. The labels use the conventional
genus and degree notation, together with the quadric and projective-space
labels. The characteristic polynomial and determinant-one cyclic basis are
checked for every constructor by kernel-checked algebra. No classification of
varieties, geometric quantum-product identification, or rationality assertion
is supplied by the labels or these numerical checks.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum

/-- The seventeen labels indexing the rational counting-matrix table. -/
inductive CountingMatrixLabel
  | genus2 | genus3 | genus4 | genus5 | genus6 | genus7 | genus8 | genus9 | genus10 | genus12
  | degree1 | degree2 | degree3 | degree4 | degree5 | quadric | projectiveSpace
  deriving DecidableEq, Fintype

/-- A reducible evaluator of the six matrix parameters by their coordinate
index, with the finite domain fixed to six coordinates. -/
def sixCountingParameters (a b c d e f : ℚ) (i : Fin 6) : ℚ :=
  match i.val with
  | 0 => a
  | 1 => b
  | 2 => c
  | 3 => d
  | 4 => e
  | _ => f

/-- The six entries specifying each upper-Hessenberg matrix; the subdiagonal
entries are one and the reflection symmetry fixes the other entries. -/
def countingMatrixParameters : CountingMatrixLabel → Fin 6 → ℚ
  | .genus2 => sixCountingParameters (120) (744) (137520) (650016) (119681280) (21690374400)
  | .genus3 => sixCountingParameters (24) (104) (3888) (13600) (504576) (18323712)
  | .genus4 => sixCountingParameters (12) (42) (792) (2340) (43632) (793152)
  | .genus5 => sixCountingParameters (8) (24) (304) (800) (9984) (121088)
  | .genus6 => sixCountingParameters (6) (16) (156) (380) (3600) (33120)
  | .genus7 => sixCountingParameters (5) (12) (96) (216) (1692) (12816)
  | .genus8 => sixCountingParameters (4) (9) (64) (140) (924) (5936)
  | .genus9 => sixCountingParameters (4) (8) (48) (96) (576) (3328)
  | .genus10 => sixCountingParameters (3) (6) (36) (72) (378) (1944)
  | .genus12 => sixCountingParameters (12/5) (22/5) (24) (44) (198) (880)
  | .degree1 => sixCountingParameters (0) (0) (240) (1248) (0) (57600)
  | .degree2 => sixCountingParameters (0) (0) (48) (160) (0) (2304)
  | .degree3 => sixCountingParameters (0) (0) (24) (60) (0) (576)
  | .degree4 => sixCountingParameters (0) (0) (16) (32) (0) (256)
  | .degree5 => sixCountingParameters (0) (0) (12) (20) (0) (160)
  | .quadric => sixCountingParameters (0) (0) (0) (0) (54) (0)
  | .projectiveSpace => sixCountingParameters (0) (0) (0) (0) (0) (256)

/-- The actual rational matrix attached to a table label. -/
def labeledCountingMatrix (label : CountingMatrixLabel) : Matrix (Fin 4) (Fin 4) ℚ :=
  let p := countingMatrixParameters label
  fourDimensionalCountingMatrix (p 0) (p 1) (p 2) (p 3) (p 4) (p 5)

/-- The characteristic polynomial in a form displaying its repeated zero roots
and complementary factors. These values are verified against the matrices. -/
noncomputable def labeledCountingPolynomial : CountingMatrixLabel → Polynomial ℚ
  | .genus2 => Polynomial.X^3*(Polynomial.X-1728)
  | .genus3 => Polynomial.X^3*(Polynomial.X-256)
  | .genus4 => Polynomial.X^3*(Polynomial.X-108)
  | .genus5 => Polynomial.X^3*(Polynomial.X-64)
  | .genus6 => Polynomial.X^2*(Polynomial.X^2-44*Polynomial.X-16)
  | .genus7 => Polynomial.X^2*(Polynomial.X^2-34*Polynomial.X+1)
  | .genus8 => Polynomial.X^2*(Polynomial.X-27)*(Polynomial.X+1)
  | .genus9 => Polynomial.X^2*(Polynomial.X^2-24*Polynomial.X+16)
  | .genus10 => Polynomial.X^2*(Polynomial.X^2-18*Polynomial.X-27)
  | .genus12 => Polynomial.C (1/625)*(5*Polynomial.X+8)*
      (125*Polynomial.X^3-1900*Polynomial.X^2-40*Polynomial.X-188)
  | .degree1 => Polynomial.X^2*(Polynomial.X^2-1728)
  | .degree2 => Polynomial.X^2*(Polynomial.X-16)*(Polynomial.X+16)
  | .degree3 => Polynomial.X^2*(Polynomial.X^2-108)
  | .degree4 => Polynomial.X^2*(Polynomial.X-8)*(Polynomial.X+8)
  | .degree5 => Polynomial.X^4-44*Polynomial.X^2-16
  | .quadric => Polynomial.X*(Polynomial.X^3-108)
  | .projectiveSpace => (Polynomial.X-4)*(Polynomial.X+4)*(Polynomial.X^2+16)

set_option maxHeartbeats 1000000 in
/-- All seventeen characteristic polynomials agree with the actual rational
matrices, by exhaustive constructor cases and symbolic polynomial identities. -/
theorem labeledCountingMatrix_charpoly (label : CountingMatrixLabel) :
    (labeledCountingMatrix label).charpoly = labeledCountingPolynomial label := by
  unfold labeledCountingMatrix
  rw [fourDimensionalCountingMatrix_charpoly]
  apply Polynomial.funext
  intro t
  cases label <;> norm_num [countingMatrixParameters, sixCountingParameters, labeledCountingPolynomial] <;> ring

/-- Each table entry has an actual determinant-one cyclic basis, including
all repeated-root entries. -/
theorem labeledCountingMatrix_cyclicBasis (label : CountingMatrixLabel) :
    let p := countingMatrixParameters label
    let basis := countingMatrixCyclicBasis (p 0) (p 1) (p 2) (p 3) (p 4)
    basis.det = 1 ∧ ∀ column : Fin 4,
      (fun row => basis row column) =
        ((labeledCountingMatrix label)^column.val).mulVec ![1,0,0,0] := by
  exact ⟨countingMatrixCyclicBasis_det _ _ _ _ _,
    countingMatrixCyclicBasis_column _ _ _ _ _ _⟩

/-- The table's constructor domain has exactly seventeen elements. -/
theorem countingMatrixLabel_card : Fintype.card CountingMatrixLabel = 17 := by decide

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum
