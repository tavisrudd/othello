import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.NormalizedSylvesterGauge

/-!
# Connection splitting from separated leading spectra

Let a finite free formal system have a block-diagonal leading operator whose
blocks are scalar-plus-nilpotent and whose distinct scalar parts differ by
units.  `NormalizedSylvesterGauge` constructs and uniquely determines the
regular normalized gauge which makes the loop-direction system block
diagonal.

This module supplies the remaining flatness step.  The adjoint action of the
leading operator is invertible on block off-diagonal matrices.  Consequently,
if the commutator of a matrix with the leading operator is block diagonal,
then the matrix itself is block diagonal.  Strong induction applies this fact
coefficient by coefficient to any base-direction Laurent series after a
finite lower bound has been cleared: the flatness equation makes the
commutator at the first possibly off-diagonal coefficient depend only on
earlier coefficients, which are already block diagonal.

The terminal theorem combines the normalized loop gauge with this
coefficientwise flatness recurrence.  It is an algebraic formal-series model;
the identification of a geometric quantum connection with its hypotheses
remains an external input.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace Quantum

open Matrix

variable {R : Type*} [CommRing R]
  {coordinate factorIndex : Type*}
  [Fintype coordinate] [DecidableEq coordinate] [DecidableEq factorIndex]

/-- A matrix is block diagonal when its commutator with a separated
scalar-plus-nilpotent block-diagonal leading operator is block diagonal.  This
is the algebraic lowest-coefficient step in the flatness argument for every
base direction. -/
theorem isBlockDiagonal_of_sylvesterOperator_isBlockDiagonal
    {label : coordinate → factorIndex} {scalar : factorIndex → R}
    {leadingOperator matrix : Matrix coordinate coordinate R}
    (separated : ∀ first second, first ≠ second →
      IsUnit (scalar first - scalar second))
    (leadingBlockDiagonal : IsBlockDiagonal label leadingOperator)
    (nilpotent : IsNilpotent
      (leadingOperator - Matrix.diagonal fun index => scalar (label index)))
    (commutatorBlockDiagonal :
      IsBlockDiagonal label (leadingOperator * matrix - matrix * leadingOperator)) :
    IsBlockDiagonal label matrix := by
  let offDiagonal := blockOffDiagonalProjection label matrix
  have offDiagonalProperty : IsBlockOffDiagonal label offDiagonal :=
    isBlockOffDiagonal_blockOffDiagonalProjection label matrix
  have projectedCommutator :
      leadingOperator * offDiagonal - offDiagonal * leadingOperator = 0 := by
    have commuting := commute_sylvesterOperator_blockOffDiagonalProjection
      (R := R) leadingBlockDiagonal
    have applied := congrArg
      (fun endomorphism : Module.End R (Matrix coordinate coordinate R) =>
        endomorphism matrix) commuting.eq
    rw [Module.End.mul_apply, Module.End.mul_apply, sylvesterOperator_apply,
      sylvesterOperator_apply] at applied
    rw [blockOffDiagonalProjection_eq_zero commutatorBlockDiagonal] at applied
    exact applied
  obtain ⟨solution, -, unique⟩ := existsUnique_blockOffDiagonal_sylvester_solution
    (label := label) (scalar := scalar) (leadingOperator := leadingOperator)
    separated leadingBlockDiagonal nilpotent
    (target := 0) (fun row column _ => rfl)
  have offDiagonalEq := unique offDiagonal
    ⟨offDiagonalProperty, projectedCommutator⟩
  have zeroEq := unique 0 ⟨fun row column _ => rfl, by simp⟩
  have offDiagonalVanishing : offDiagonal = 0 := offDiagonalEq.trans zeroEq.symm
  intro row column differentLabel
  have entry := congrFun (congrFun offDiagonalVanishing row) column
  simpa [offDiagonal, differentLabel] using entry

/-- The coefficientwise flatness recurrence for one base direction.  Once all
earlier coefficients are block diagonal, the flatness equation must make the
commutator of the next coefficient with the leading loop operator block
diagonal.  This formulation covers a Laurent series after shifting its finite
lower bound to index zero. -/
def SatisfiesBlockFlatnessRecurrence (label : coordinate → factorIndex)
    (leadingOperator : Matrix coordinate coordinate R)
    (baseCoefficient : ℕ → Matrix coordinate coordinate R) : Prop :=
  ∀ order,
    (∀ earlier, earlier < order → IsBlockDiagonal label (baseCoefficient earlier)) →
      IsBlockDiagonal label
        (leadingOperator * baseCoefficient order - baseCoefficient order * leadingOperator)

/-- A base-direction series satisfying the coefficientwise flatness recurrence
is block diagonal at every order when the leading loop operator has separated
scalar-plus-nilpotent blocks. -/
theorem baseConnection_blockDiagonal_of_flatnessRecurrence
    {label : coordinate → factorIndex} {scalar : factorIndex → R}
    {leadingOperator : Matrix coordinate coordinate R}
    {baseCoefficient : ℕ → Matrix coordinate coordinate R}
    (separated : ∀ first second, first ≠ second →
      IsUnit (scalar first - scalar second))
    (leadingBlockDiagonal : IsBlockDiagonal label leadingOperator)
    (nilpotent : IsNilpotent
      (leadingOperator - Matrix.diagonal fun index => scalar (label index)))
    (flatness : SatisfiesBlockFlatnessRecurrence label leadingOperator baseCoefficient) :
    ∀ order, IsBlockDiagonal label (baseCoefficient order) := by
  intro order
  induction order using Nat.strong_induction_on with
  | _ order inductionHypothesis =>
      exact isBlockDiagonal_of_sylvesterOperator_isBlockDiagonal separated
        leadingBlockDiagonal nilpotent (flatness order inductionHypothesis)

/-- A separated formal system has a unique normalized regular loop gauge, and
every base-direction coefficient satisfying the induced flatness recurrence is
block diagonal in that same splitting.  Thus the normalized spectral factors
are summands of the full formal connection, not merely primary subspaces of its
leading Euler operator. -/
theorem existsUnique_normalizedGauge_with_flat_base
    {label : coordinate → factorIndex} {scalar : factorIndex → R}
    {system : ℕ → Matrix coordinate coordinate R}
    {baseCoefficient : ℕ → Matrix coordinate coordinate R}
    (separated : ∀ first second, first ≠ second →
      IsUnit (scalar first - scalar second))
    (leadingBlockDiagonal : IsBlockDiagonal label (system 0))
    (nilpotent : IsNilpotent
      (system 0 - Matrix.diagonal fun index => scalar (label index)))
    (flatness : SatisfiesBlockFlatnessRecurrence label (system 0) baseCoefficient) :
    ∃ gauge reduced : ℕ → Matrix coordinate coordinate R,
      IsNormalizedGauge label system gauge reduced ∧
      (∀ otherGauge otherReduced,
        IsNormalizedGauge label system otherGauge otherReduced →
          ∀ order,
            gauge order = otherGauge order ∧ reduced order = otherReduced order) ∧
      ∀ order, IsBlockDiagonal label (baseCoefficient order) := by
  obtain ⟨gauge, reduced, normalized⟩ := exists_normalizedGauge separated
    leadingBlockDiagonal nilpotent
  refine ⟨gauge, reduced, normalized, ?_,
    baseConnection_blockDiagonal_of_flatnessRecurrence separated
      leadingBlockDiagonal nilpotent flatness⟩
  intro otherGauge otherReduced otherNormalized order
  exact normalizedGauge_unique separated leadingBlockDiagonal nilpotent
    normalized otherNormalized order

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
