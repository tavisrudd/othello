import Mathlib.Data.Matrix.Block
import Mathlib.RingTheory.Ideal.Quotient.Operations
import Mathlib.Tactic

/-!
# Lifting a residue endomorphism to a self-adjoint integral endomorphism

Let `U` be a free module of finite rank over a commutative ring, with a symmetric
Gram matrix `gram` admitting a two-sided inverse `inverseGram` over the same
ring, and let `p` be a coefficient.  A matrix `T` is self-adjoint for the dual
coefficient form when `Tᵀ * inverseGram = inverseGram * T`.  This module proves
that every endomorphism of `U/pU` self-adjoint for the reduced dual form is the
reduction of an endomorphism of `U` self-adjoint for the dual form itself.  The
construction divides by nothing.

Choose any matrix `chosenLift` reducing to the given endomorphism.  Its
adjointness defect `chosenLiftᵀ * inverseGram - inverseGram * chosenLift` is skew
for the transpose, because `inverseGram` is symmetric, and vanishes modulo `p`,
so it is `p` times a matrix `D` that is skew with zero diagonal.  Fix a linear
order on the coordinates and let `C` be the strictly lower triangular part of
`D`; then `Cᵀ - C = -D`, and `chosenLift + p • (gram * C)` reduces to the same
endomorphism of `U/pU` and has vanishing defect.  The coefficient ring enters in
exactly two places: cancelling `p` to see that `D` is skew, and cancelling `2` to
see that a skew matrix has zero diagonal.  Both are supplied by the hypotheses
that `p` and `2` are nonzero in a domain.

Two further statements record how the construction meets an orthogonal
decomposition of `U`.  A block-diagonal matrix is self-adjoint for a
block-diagonal inverse Gram matrix as soon as each block is self-adjoint for its
own block, so lifts constructed separately on orthogonal summands assemble; and a
scalar matrix is self-adjoint for every inverse Gram matrix, so a lift on one
summand extends by a scalar on its orthogonal complement.

Everything here is a statement about matrices over a commutative ring.  No
lattice, polarization, isogeny kernel, or geometric slope is constructed.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace GraphLattices

open Matrix

variable {R Index : Type*} [CommRing R]

section Defect

variable [Fintype Index]

/-- The failure of a matrix to be self-adjoint for the dual coefficient form
represented by `inverseGram`. -/
def adjointDefect (inverseGram matrix : Matrix Index Index R) :
    Matrix Index Index R :=
  matrixᵀ * inverseGram - inverseGram * matrix

/-- Self-adjointness for the dual coefficient form is the vanishing of the
adjointness defect. -/
theorem adjointDefect_eq_zero_iff (inverseGram matrix : Matrix Index Index R) :
    adjointDefect inverseGram matrix = 0 ↔
      matrixᵀ * inverseGram = inverseGram * matrix := by
  rw [adjointDefect, sub_eq_zero]

section Inverse

variable [DecidableEq Index]

/-- A two-sided inverse of a symmetric matrix is symmetric. -/
theorem transpose_inverse_of_transpose_eq
    {gram inverseGram : Matrix Index Index R}
    (symmetric : gramᵀ = gram) (rightInverse : gram * inverseGram = 1) :
    inverseGramᵀ = inverseGram := by
  have step : inverseGramᵀ * gram = 1 := by
    rw [← symmetric, ← Matrix.transpose_mul, rightInverse, Matrix.transpose_one]
  calc inverseGramᵀ = inverseGramᵀ * (gram * inverseGram) := by
        rw [rightInverse, mul_one]
    _ = inverseGramᵀ * gram * inverseGram := by rw [Matrix.mul_assoc]
    _ = inverseGram := by rw [step, one_mul]

/-- For a symmetric Gram matrix the adjointness defect is skew for the
transpose. -/
theorem adjointDefect_transpose
    {gram inverseGram matrix : Matrix Index Index R}
    (symmetric : gramᵀ = gram) (rightInverse : gram * inverseGram = 1) :
    (adjointDefect inverseGram matrix)ᵀ = -adjointDefect inverseGram matrix := by
  have symmetricInverse := transpose_inverse_of_transpose_eq symmetric rightInverse
  simp [adjointDefect, Matrix.transpose_sub, Matrix.transpose_mul, symmetricInverse,
    neg_sub]

/-- In a domain, cancelling a nonzero coefficient `p` from a skew defect leaves a
skew matrix: if the defect is `p` times `coefficient`, then `coefficient` is
skew. -/
theorem transpose_eq_neg_of_adjointDefect_eq_smul [IsDomain R]
    {p : R} {gram inverseGram matrix coefficient : Matrix Index Index R}
    (nonzero : p ≠ 0)
    (symmetric : gramᵀ = gram) (rightInverse : gram * inverseGram = 1)
    (defect : adjointDefect inverseGram matrix = p • coefficient) :
    coefficientᵀ = -coefficient := by
  have skew := adjointDefect_transpose (matrix := matrix) symmetric rightInverse
  rw [defect] at skew
  ext row column
  have entry : p * coefficient column row = p * -coefficient row column := by
    have raw := congrFun (congrFun skew row) column
    simpa [Matrix.transpose_apply, mul_neg] using raw
  simpa using mul_left_cancel₀ nonzero entry

end Inverse

end Defect

/-- In a domain in which `2` is nonzero, a skew matrix has zero diagonal. -/
theorem diagonal_eq_zero_of_transpose_eq_neg [IsDomain R]
    {coefficient : Matrix Index Index R}
    (twoNonzero : (2 : R) ≠ 0) (skew : coefficientᵀ = -coefficient)
    (index : Index) :
    coefficient index index = 0 := by
  have entry : coefficient index index = -coefficient index index := by
    simpa [Matrix.transpose_apply] using congrFun (congrFun skew index) index
  have doubled : (2 : R) * coefficient index index = 0 := by
    linear_combination entry
  rcases mul_eq_zero.mp doubled with two | value
  · exact absurd two twoNonzero
  · exact value

section Triangular

variable [LinearOrder Index]

/-- The strictly lower triangular part of a matrix, for a chosen linear order on
the coordinates. -/
def strictLowerPart (coefficient : Matrix Index Index R) : Matrix Index Index R :=
  fun row column ↦ if column < row then coefficient row column else 0

/-- Splitting a skew matrix with zero diagonal into its strictly triangular
parts: the strictly lower part `C` of `D` satisfies `Cᵀ - C = -D`.  This is the
step of the lifting construction that uses no division. -/
theorem strictLowerPart_transpose_sub_self
    {coefficient : Matrix Index Index R}
    (skew : coefficientᵀ = -coefficient)
    (diagonal : ∀ index, coefficient index index = 0) :
    (strictLowerPart coefficient)ᵀ - strictLowerPart coefficient = -coefficient := by
  ext row column
  have entry : coefficient column row = -coefficient row column := by
    simpa [Matrix.transpose_apply] using congrFun (congrFun skew row) column
  rcases lt_trichotomy row column with less | equal | greater
  · have notGreater : ¬ column < row := asymm less
    simp [strictLowerPart, Matrix.transpose_apply, less, notGreater, entry]
  · subst equal
    simp [strictLowerPart, Matrix.transpose_apply, diagonal row]
  · have notLess : ¬ row < column := asymm greater
    simp [strictLowerPart, Matrix.transpose_apply, greater, notLess]

section Correction

variable [Fintype Index] [DecidableEq Index]

/-- The corrected lift: a chosen lift adjusted by `p` times `gram` times the
strictly lower triangular part of the divided defect. -/
def selfAdjointLiftCorrection (p : R)
    (gram coefficient chosenLift : Matrix Index Index R) : Matrix Index Index R :=
  chosenLift + p • (gram * strictLowerPart coefficient)

/-- The corrected lift is self-adjoint for the dual coefficient form. -/
theorem adjointDefect_selfAdjointLiftCorrection
    {p : R} {gram inverseGram coefficient chosenLift : Matrix Index Index R}
    (symmetric : gramᵀ = gram)
    (rightInverse : gram * inverseGram = 1)
    (leftInverse : inverseGram * gram = 1)
    (skew : coefficientᵀ = -coefficient)
    (diagonal : ∀ index, coefficient index index = 0)
    (defect : adjointDefect inverseGram chosenLift = p • coefficient) :
    adjointDefect inverseGram
        (selfAdjointLiftCorrection p gram coefficient chosenLift) = 0 := by
  have transposeStep :
      (p • (gram * strictLowerPart coefficient))ᵀ * inverseGram =
        p • (strictLowerPart coefficient)ᵀ := by
    rw [Matrix.transpose_smul, Matrix.transpose_mul, symmetric, Matrix.smul_mul,
      Matrix.mul_assoc, rightInverse, Matrix.mul_one]
  have multiplyStep :
      inverseGram * (p • (gram * strictLowerPart coefficient)) =
        p • strictLowerPart coefficient := by
    rw [Matrix.mul_smul, ← Matrix.mul_assoc, leftInverse, Matrix.one_mul]
  have expand :
      adjointDefect inverseGram
          (selfAdjointLiftCorrection p gram coefficient chosenLift) =
        adjointDefect inverseGram chosenLift +
          (p • (strictLowerPart coefficient)ᵀ - p • strictLowerPart coefficient) := by
    simp only [adjointDefect, selfAdjointLiftCorrection, Matrix.transpose_add,
      Matrix.add_mul, Matrix.mul_add, transposeStep, multiplyStep]
    abel
  have triangular :
      p • (strictLowerPart coefficient)ᵀ - p • strictLowerPart coefficient =
        p • (-coefficient) := by
    rw [← smul_sub, strictLowerPart_transpose_sub_self skew diagonal]
  rw [expand, defect, triangular, smul_neg, add_neg_cancel]

/-- Divisibility form of the lifting theorem: if the adjointness defect of a
chosen matrix is `p` times an integral matrix, the chosen matrix can be corrected
by a multiple of `p` into a matrix self-adjoint for the dual coefficient form. -/
theorem exists_selfAdjoint_correction_of_adjointDefect_eq_smul [IsDomain R]
    {p : R} {gram inverseGram coefficient chosenLift : Matrix Index Index R}
    (nonzero : p ≠ 0) (twoNonzero : (2 : R) ≠ 0)
    (symmetric : gramᵀ = gram)
    (rightInverse : gram * inverseGram = 1)
    (leftInverse : inverseGram * gram = 1)
    (defect : adjointDefect inverseGram chosenLift = p • coefficient) :
    ∃ correction : Matrix Index Index R,
      (chosenLift + p • correction)ᵀ * inverseGram =
        inverseGram * (chosenLift + p • correction) := by
  have skew := transpose_eq_neg_of_adjointDefect_eq_smul nonzero symmetric rightInverse defect
  have diagonal := fun index ↦
    diagonal_eq_zero_of_transpose_eq_neg twoNonzero skew index
  refine ⟨gram * strictLowerPart coefficient, ?_⟩
  have vanishing :=
    adjointDefect_selfAdjointLiftCorrection symmetric rightInverse leftInverse skew
      diagonal defect
  exact (adjointDefect_eq_zero_iff _ _).mp vanishing

/-- Every endomorphism of `U/pU` self-adjoint for the reduced dual coefficient
form is the reduction of an endomorphism of `U` self-adjoint for the dual
coefficient form.  The Gram matrix is symmetric with a two-sided inverse over the
coefficient ring, which is a domain in which `p` and `2` are nonzero. -/
theorem exists_selfAdjoint_lift_of_residue_selfAdjoint [IsDomain R]
    {p : R} (nonzero : p ≠ 0) (twoNonzero : (2 : R) ≠ 0)
    {gram inverseGram : Matrix Index Index R}
    (symmetric : gramᵀ = gram)
    (rightInverse : gram * inverseGram = 1)
    (leftInverse : inverseGram * gram = 1)
    (residue : Matrix Index Index (R ⧸ Ideal.span ({p} : Set R)))
    (residueSelfAdjoint :
      residueᵀ * inverseGram.map (Ideal.Quotient.mk (Ideal.span ({p} : Set R))) =
        inverseGram.map (Ideal.Quotient.mk (Ideal.span ({p} : Set R))) * residue) :
    ∃ lift : Matrix Index Index R,
      lift.map (Ideal.Quotient.mk (Ideal.span ({p} : Set R))) = residue ∧
        liftᵀ * inverseGram = inverseGram * lift := by
  classical
  set reduction := Ideal.Quotient.mk (Ideal.span ({p} : Set R)) with reductionDefinition
  have primeVanishes : reduction p = 0 :=
    Ideal.Quotient.eq_zero_iff_mem.mpr (Ideal.mem_span_singleton_self p)
  set chosenLift : Matrix Index Index R := fun row column ↦
    Function.surjInv Ideal.Quotient.mk_surjective (residue row column) with chosenDefinition
  have chosenReduction : chosenLift.map reduction = residue := by
    ext row column
    exact Function.surjInv_eq Ideal.Quotient.mk_surjective (residue row column)
  have defectReduction :
      (adjointDefect inverseGram chosenLift).map reduction = 0 := by
    have expand :
        (adjointDefect inverseGram chosenLift).map reduction =
          (chosenLift.map reduction)ᵀ * inverseGram.map reduction -
            inverseGram.map reduction * chosenLift.map reduction := by
      have transposeMap :
          chosenLiftᵀ.map reduction = (chosenLift.map reduction)ᵀ := rfl
      simp only [adjointDefect]
      rw [← RingHom.mapMatrix_apply, map_sub, map_mul, map_mul]
      simp [RingHom.mapMatrix_apply, transposeMap]
    rw [expand, chosenReduction, residueSelfAdjoint, sub_self]
  have divides : ∀ row column,
      ∃ value : R, adjointDefect inverseGram chosenLift row column = p * value := by
    intro row column
    have vanishing : reduction (adjointDefect inverseGram chosenLift row column) = 0 := by
      simpa [Matrix.map_apply] using congrFun (congrFun defectReduction row) column
    exact Ideal.mem_span_singleton.mp (Ideal.Quotient.eq_zero_iff_mem.mp vanishing)
  choose coefficient coefficientEquation using divides
  have defect :
      adjointDefect inverseGram chosenLift =
        p • (coefficient : Matrix Index Index R) := by
    ext row column
    simpa [Matrix.smul_apply, smul_eq_mul] using coefficientEquation row column
  have skew :=
    transpose_eq_neg_of_adjointDefect_eq_smul nonzero symmetric rightInverse defect
  have diagonal := fun index ↦
    diagonal_eq_zero_of_transpose_eq_neg twoNonzero skew index
  refine ⟨selfAdjointLiftCorrection p gram coefficient chosenLift, ?_, ?_⟩
  · ext row column
    simp [selfAdjointLiftCorrection, Matrix.map_apply, Matrix.add_apply,
      Matrix.smul_apply, smul_eq_mul, primeVanishes,
      ← congrFun (congrFun chosenReduction row) column, Matrix.map_apply]
  · exact (adjointDefect_eq_zero_iff _ _).mp
      (adjointDefect_selfAdjointLiftCorrection symmetric rightInverse leftInverse
        skew diagonal defect)

end Correction

end Triangular

section Blocks

variable [Fintype Index] [DecidableEq Index]

/-- A scalar matrix is self-adjoint for every dual coefficient form, so a lift
constructed on one orthogonal summand extends by a scalar on its complement. -/
theorem smul_one_selfAdjoint (scalar : R) (inverseGram : Matrix Index Index R) :
    (scalar • (1 : Matrix Index Index R))ᵀ * inverseGram =
      inverseGram * (scalar • (1 : Matrix Index Index R)) := by
  simp [Matrix.transpose_smul]

/-- Self-adjointness is blockwise for an orthogonal decomposition: a
block-diagonal matrix is self-adjoint for a block-diagonal inverse Gram matrix as
soon as each block is self-adjoint for its own block.  Applied to a depth
decomposition, this is what makes the lifting construction depth-preserving. -/
theorem fromBlocks_selfAdjoint
    {First Second : Type*} [Fintype First] [DecidableEq First]
    [Fintype Second] [DecidableEq Second]
    (firstInverseGram firstMatrix : Matrix First First R)
    (secondInverseGram secondMatrix : Matrix Second Second R)
    (firstSelfAdjoint :
      firstMatrixᵀ * firstInverseGram = firstInverseGram * firstMatrix)
    (secondSelfAdjoint :
      secondMatrixᵀ * secondInverseGram = secondInverseGram * secondMatrix) :
    (Matrix.fromBlocks firstMatrix 0 0 secondMatrix)ᵀ *
        Matrix.fromBlocks firstInverseGram 0 0 secondInverseGram =
      Matrix.fromBlocks firstInverseGram 0 0 secondInverseGram *
        Matrix.fromBlocks firstMatrix 0 0 secondMatrix := by
  simp [Matrix.fromBlocks_transpose, Matrix.fromBlocks_multiply, firstSelfAdjoint,
    secondSelfAdjoint]

end Blocks

end GraphLattices

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
