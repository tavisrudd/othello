import Mathlib.LinearAlgebra.Matrix.ToLinearEquiv

/-!
# Restriction of a pairing to an orthogonal set of coordinates

Let `pairing` be a square matrix over a field indexed by a finite type of
coordinates, and let a predicate `part` single out a set of those coordinates.
Call that set orthogonal to its complement when every entry whose row lies
outside the set and whose column lies inside it vanishes.  This module proves
that a pairing with nonzero determinant restricts to a matrix with nonzero
determinant on such a set: a nonzero kernel vector of the restriction, extended
by zero to all coordinates, is a kernel vector of the whole pairing, so a
degenerate restriction would force the whole pairing to be degenerate.

Two instances of that hypothesis occur for the horizontal Poincare pairing of a
locally split `F`-bundle whose factors have pairwise distinct leading Euler
eigenvalues.  The pairing is block diagonal for the splitting, so each fiber of
the factor label is orthogonal to its complement; and the Poincare form pairs
only classes of equal cohomological parity, so inside a factor the even
coordinates are orthogonal to the odd ones.  Restricting first to one factor
and then to the even coordinates of that factor therefore preserves
nondegeneracy.  Transport along a bijective frame `Fin rank ≃ (the chosen
coordinates)` turns the restriction into a matrix indexed by `Fin rank`; for an
even factor of rank two this is the invertibility hypothesis consumed by the
rank-two residue rigidity argument.

Block diagonality and the parity behaviour of the form are hypotheses.  Lean
constructs no `F`-bundle, spectral splitting, connection, cohomological
grading, or Poincare pairing: the factor label is an arbitrary function to a
type with decidable equality, the parity an arbitrary function to `ZMod 2` with
`0` naming the even coordinates, and nondegeneracy is the nonvanishing of a
determinant.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Quantum

open Matrix

variable {K : Type*} [Field K] {coordinate : Type*} [Fintype coordinate] [DecidableEq coordinate]

/-- The restriction of a pairing to the coordinates satisfying `part`, as a
square matrix indexed by the corresponding subtype. -/
def restrictToCoordinates (pairing : Matrix coordinate coordinate K)
    (part : coordinate → Prop) [DecidablePred part] :
    Matrix {index // part index} {index // part index} K :=
  pairing.submatrix Subtype.val Subtype.val

/-- The extension by zero, to all coordinates, of a vector defined on the
coordinates satisfying `part`. -/
def extendByZero {part : coordinate → Prop} [DecidablePred part]
    (vector : {index // part index} → K) : coordinate → K :=
  fun index => if member : part index then vector ⟨index, member⟩ else 0

omit [Fintype coordinate] [DecidableEq coordinate] in
/-- On the coordinates satisfying `part` the extension by zero agrees with the
vector it extends. -/
theorem extendByZero_val {part : coordinate → Prop} [DecidablePred part]
    (vector : {index // part index} → K) (index : {index // part index}) :
    extendByZero vector index.val = vector index := by
  simp [extendByZero, index.2]

omit [Fintype coordinate] [DecidableEq coordinate] in
/-- The extension by zero of a nonzero vector is nonzero. -/
theorem extendByZero_ne_zero {part : coordinate → Prop} [DecidablePred part]
    {vector : {index // part index} → K} (nonzero : vector ≠ 0) :
    extendByZero vector ≠ 0 := by
  obtain ⟨index, value⟩ := Function.ne_iff.mp nonzero
  refine Function.ne_iff.mpr ⟨index.val, ?_⟩
  simpa [extendByZero_val] using value

omit [DecidableEq coordinate] in
/-- A sum over all coordinates whose terms vanish outside the coordinates
satisfying `part` is the sum of the remaining terms over the subtype. -/
theorem sum_eq_sum_subtype_of_vanishing {part : coordinate → Prop} [DecidablePred part]
    (term : coordinate → K) (vanishing : ∀ index, ¬ part index → term index = 0) :
    ∑ index, term index = ∑ index : {index // part index}, term index.val := by
  rw [← Finset.sum_subtype (Finset.univ.filter part) (by simp) term]
  refine (Finset.sum_subset (Finset.filter_subset _ _) ?_).symm
  intro index _ notMember
  exact vanishing index (by simpa using notMember)

/-- A pairing with nonzero determinant restricts to a matrix with nonzero
determinant on any set of coordinates orthogonal to its complement, that is, on
any set such that every entry with row outside the set and column inside it
vanishes.  A nonzero kernel vector of the restriction extends by zero to a
nonzero kernel vector of the whole pairing: rows inside the set reproduce the
kernel equation of the restriction, and rows outside it are annihilated
entrywise by orthogonality. -/
theorem det_restrictToCoordinates_ne_zero {part : coordinate → Prop} [DecidablePred part]
    {pairing : Matrix coordinate coordinate K}
    (orthogonal : ∀ row column, ¬ part row → part column → pairing row column = 0)
    (nondegenerate : pairing.det ≠ 0) :
    (restrictToCoordinates pairing part).det ≠ 0 := by
  intro vanishing
  obtain ⟨vector, nonzero, annihilated⟩ := Matrix.exists_mulVec_eq_zero_iff.mpr vanishing
  refine nondegenerate (Matrix.exists_mulVec_eq_zero_iff.mp
    ⟨extendByZero vector, extendByZero_ne_zero nonzero, ?_⟩)
  funext row
  have expansion : (pairing *ᵥ extendByZero vector) row
      = ∑ column : {index // part index}, pairing row column.val * vector column := by
    rw [Matrix.mulVec_apply_eq_sum,
      sum_eq_sum_subtype_of_vanishing (part := part)
        (fun column => pairing row column * extendByZero vector column)
        fun column notMember => by
          rw [show extendByZero vector column = 0 from dif_neg notMember, mul_zero]]
    exact Finset.sum_congr rfl fun column _ => by rw [extendByZero_val]
  simp only [Pi.zero_apply, expansion]
  by_cases member : part row
  · have kernel := congrFun annihilated ⟨row, member⟩
    rw [Matrix.mulVec_apply_eq_sum] at kernel
    simpa [restrictToCoordinates] using kernel
  · refine Finset.sum_eq_zero fun column _ => ?_
    rw [orthogonal row column.val member column.2, zero_mul]

/-- The restriction to a set of coordinates orthogonal to its complement is
nondegenerate as a matrix: no nonzero vector pairs trivially with every vector
of the restricted index set. -/
theorem nondegenerate_restrictToCoordinates {part : coordinate → Prop} [DecidablePred part]
    {pairing : Matrix coordinate coordinate K}
    (orthogonal : ∀ row column, ¬ part row → part column → pairing row column = 0)
    (nondegenerate : pairing.det ≠ 0) :
    (restrictToCoordinates pairing part).Nondegenerate :=
  Matrix.nondegenerate_iff_det_ne_zero.mpr
    (det_restrictToCoordinates_ne_zero orthogonal nondegenerate)

variable {factorIndex : Type*} [DecidableEq factorIndex]

/-- A pairing that is block diagonal for a labelling of the coordinates, in the
sense that entries with differently labelled row and column vanish, and that has
nonzero determinant, restricts to a matrix with nonzero determinant on every
fiber of the label.  This is nondegeneracy of the restriction of a horizontal
pairing to one spectral factor of a local splitting. -/
theorem det_restrictToLabelFiber_ne_zero {label : coordinate → factorIndex}
    {pairing : Matrix coordinate coordinate K}
    (blockDiagonal : ∀ row column, label row ≠ label column → pairing row column = 0)
    (nondegenerate : pairing.det ≠ 0) (value : factorIndex) :
    (restrictToCoordinates pairing fun index => label index = value).det ≠ 0 :=
  det_restrictToCoordinates_ne_zero
    (fun row column notMember member =>
      blockDiagonal row column fun equal => notMember (equal.trans member))
    nondegenerate

/-- The even coordinates of one factor of a block-diagonal pairing that also
pairs only coordinates of equal parity: if the pairing has nonzero determinant,
so does its restriction to the coordinates labelled by a fixed factor and of
even parity.  A row outside that set either carries a different label, where
block diagonality applies, or the odd parity, where the parity hypothesis
applies. -/
theorem det_restrictToEvenPartOfFactor_ne_zero {label : coordinate → factorIndex}
    {parity : coordinate → ZMod 2} {pairing : Matrix coordinate coordinate K}
    (blockDiagonal : ∀ row column, label row ≠ label column → pairing row column = 0)
    (parityOrthogonal : ∀ row column, parity row ≠ parity column → pairing row column = 0)
    (nondegenerate : pairing.det ≠ 0) (value : factorIndex) :
    (restrictToCoordinates pairing
      fun index => label index = value ∧ parity index = 0).det ≠ 0 := by
  refine det_restrictToCoordinates_ne_zero (fun row column notMember member => ?_) nondegenerate
  by_cases labelRow : label row = value
  · exact parityOrthogonal row column fun equal => notMember ⟨labelRow, equal.trans member.2⟩
  · exact blockDiagonal row column fun equal => labelRow (equal.trans member.1)

/-- Transport of a nondegenerate restriction along a frame, that is, a bijection
between `Fin rank` and the chosen coordinates: the matrix of the pairing in that
frame again has nonzero determinant, because reindexing a square matrix by a
bijection preserves its determinant. -/
theorem det_frameSubmatrix_ne_zero {part : coordinate → Prop} [DecidablePred part]
    {pairing : Matrix coordinate coordinate K} {rank : ℕ}
    (frame : Fin rank ≃ {index // part index})
    (restrictionNondegenerate : (restrictToCoordinates pairing part).det ≠ 0) :
    (pairing.submatrix (fun position => (frame position).val)
      (fun position => (frame position).val)).det ≠ 0 := by
  have reindexed : pairing.submatrix (fun position => (frame position).val)
      (fun position => (frame position).val)
      = (restrictToCoordinates pairing part).submatrix frame frame := rfl
  rw [reindexed, Matrix.det_submatrix_equiv_self]
  exact restrictionNondegenerate

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
