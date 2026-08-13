import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.MarkedSplitPresentation
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.SplitCoordinateTransport

/-!
# Marked graph descent after a splitting-ring basis change

This module joins two exact algebraic layers of the marked graph argument.  A
base coefficient form is extended to the splitting ring and transported by a
supplied invertible basis.  The resulting matrix is restricted to its
dependent slope blocks.  Weighted-lattice membership is then identified with
symmetry and the actual graph-coordinate descent conditions, including the
transpose on the right slope in `A Tᵗ - T A`.

The splitting extension, spectral basis, and geometric assertion that divisor
descent is expressed by these block conditions remain supplied data.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace GraphLattices

/-- Restrict a matrix on the disjoint union of dependent block bases to its
rectangular `(first, second)` block. -/
def blockCoefficientOfMatrix
    {R Index : Type*} [CommRing R] (Block : Index → Type*)
    (form : Matrix (SplitGraphAxis Block) (SplitGraphAxis Block) R)
    (first second : Index) : Matrix (Block first) (Block second) R :=
  fun row column ↦ form ⟨first, row⟩ ⟨second, column⟩

/-- Restricting to every dependent block and flattening again recovers the
original matrix definitionally at each entry. -/
theorem flattenBlockCoefficient_blockCoefficientOfMatrix
    {R Index : Type*} [CommRing R] (Block : Index → Type*)
    (form : Matrix (SplitGraphAxis Block) (SplitGraphAxis Block) R) :
    flattenBlockCoefficient Block (blockCoefficientOfMatrix Block form) = form := by
  rfl

/-- A split-coordinate coefficient form satisfies the weighted matrix depth
conditions exactly when its dependent blocks are symmetric and satisfy the
three actual graph-coordinate descent conditions. -/
theorem memWeightedMatrix_iff_blockGraphDescent
    {R Index : Type*} [CommRing R]
    (Block : Index → Type*) [∀ index, Fintype (Block index)]
    [∀ index, DecidableEq (Block index)]
    {uniformizer : R} (data : NormalizedDVRValuation uniformizer)
    (depth : Index → ℕ) (scalar : Index → R)
    (slopeError : ∀ index, Matrix (Block index) (Block index) R)
    (form : Matrix (SplitGraphAxis Block) (SplitGraphAxis Block) R) :
    MemWeightedMatrix uniformizer (fun axis ↦ depth axis.1)
        (splitGraphCrossDepth Block data.valuation depth scalar) form ↔
      GraphBlockSymmetric Block (blockCoefficientOfMatrix Block form) ∧
        GraphBlockDescentCondition Block uniformizer depth scalar slopeError
          (blockCoefficientOfMatrix Block form) := by
  rw [← flattenBlockCoefficient_blockCoefficientOfMatrix Block form]
  exact memWeightedMatrix_flattenBlockCoefficient_iff_graphDescent
    Block data depth scalar slopeError (blockCoefficientOfMatrix Block form)

/-- Exact graph-descent criterion after scalar extension and a supplied
splitting-ring basis change.  The base and split coordinate types may differ. -/
theorem splitCoordinateCoefficientExtension_memWeightedMatrix_iff_graphDescent
    {R S BaseAxis Index : Type*} [CommRing R] [CommRing S]
    [Algebra R S] [Fintype BaseAxis] [DecidableEq BaseAxis]
    (Block : Index → Type*) [∀ index, Fintype (Block index)]
    [∀ index, DecidableEq (Block index)]
    [Fintype (SplitGraphAxis Block)] [DecidableEq (SplitGraphAxis Block)]
    (basis : SplitCoordinateBasisEquivalence S BaseAxis
      (SplitGraphAxis Block))
    {uniformizer : S} (data : NormalizedDVRValuation uniformizer)
    (depth : Index → ℕ) (scalar : Index → S)
    (slopeError : ∀ index, Matrix (Block index) (Block index) S)
    (form : Matrix BaseAxis BaseAxis R) :
    MemWeightedMatrix uniformizer (fun axis ↦ depth axis.1)
        (splitGraphCrossDepth Block data.valuation depth scalar)
        (splitCoordinateCoefficientExtension basis.toSplit form) ↔
      GraphBlockSymmetric Block
          (blockCoefficientOfMatrix Block
            (splitCoordinateCoefficientExtension basis.toSplit form)) ∧
        GraphBlockDescentCondition Block uniformizer depth scalar slopeError
          (blockCoefficientOfMatrix Block
            (splitCoordinateCoefficientExtension basis.toSplit form)) :=
  memWeightedMatrix_iff_blockGraphDescent Block data depth scalar slopeError
    (splitCoordinateCoefficientExtension basis.toSplit form)

/-- Symmetry of the base coefficient form supplies blockwise transpose
symmetry after scalar extension and the splitting-ring basis change. -/
theorem splitCoordinateCoefficientExtension_blockSymmetric
    {R S BaseAxis Index : Type*} [CommRing R] [CommRing S]
    [Algebra R S] [Fintype BaseAxis] [DecidableEq BaseAxis]
    (Block : Index → Type*)
    [Fintype (SplitGraphAxis Block)] [DecidableEq (SplitGraphAxis Block)]
    (basis : SplitCoordinateBasisEquivalence S BaseAxis
      (SplitGraphAxis Block))
    (form : Matrix BaseAxis BaseAxis R) (symmetric : form.IsSymm) :
    GraphBlockSymmetric Block
      (blockCoefficientOfMatrix Block
        (splitCoordinateCoefficientExtension basis.toSplit form)) := by
  apply (flattenBlockCoefficient_isSymm_iff Block
    (blockCoefficientOfMatrix Block
      (splitCoordinateCoefficientExtension basis.toSplit form))).mp
  rw [flattenBlockCoefficient_blockCoefficientOfMatrix]
  exact splitCoordinateCoefficientExtension_isSymm
    basis.toSplit form symmetric

end GraphLattices

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
