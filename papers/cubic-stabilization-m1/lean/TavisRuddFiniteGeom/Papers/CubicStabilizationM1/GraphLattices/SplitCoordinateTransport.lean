import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.CoefficientExtension
import Mathlib.Tactic

/-!
# Transport to a splitting-ring basis

The eigenblock basis used after finite-etale scalar extension need not descend
to the base coefficient ring.  This module therefore keeps the base coordinate
type and the split coordinate type distinct.  It extends a base coefficient
matrix entrywise and then applies an explicitly invertible change of basis by
congruence.  All proofs are symbolic kernel-checked matrix algebra.

No splitting extension, eigenbasis, graph presentation, or geometric
realization is constructed here.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace GraphLattices

open scoped BigOperators

/-- Rectangular matrices giving mutually inverse coordinate changes between
two finite free coordinate systems over the same coefficient ring.  The
matrix `toSplit` has base coordinates as rows and split coordinates as
columns, so a split coordinate column is sent to a base coordinate column by
left multiplication with `toSplit`. -/
structure SplitCoordinateBasisEquivalence
    (S BaseAxis SplitAxis : Type*) [CommRing S]
    [Fintype BaseAxis] [Fintype SplitAxis]
    [DecidableEq BaseAxis] [DecidableEq SplitAxis] where
  toSplit : Matrix BaseAxis SplitAxis S
  toBase : Matrix SplitAxis BaseAxis S
  toSplit_mul_toBase : toSplit * toBase = 1
  toBase_mul_toSplit : toBase * toSplit = 1

/-- Congruence transport of a coefficient bilinear form from base coordinates
to split coordinates. -/
def matrixCongruence
    {S BaseAxis SplitAxis : Type*} [CommRing S]
    [Fintype BaseAxis]
    (basis : Matrix BaseAxis SplitAxis S)
    (form : Matrix BaseAxis BaseAxis S) : Matrix SplitAxis SplitAxis S :=
  basis.transpose * form * basis

/-- The split-coordinate vector obtained by applying the transpose of the
coordinate-change matrix to a base-coordinate vector. -/
def splitCoordinateVector
    {S BaseAxis SplitAxis : Type*} [CommRing S]
    [Fintype BaseAxis]
    (basis : Matrix BaseAxis SplitAxis S) (vector : BaseAxis → S) :
    SplitAxis → S :=
  fun coordinate ↦ ∑ index, basis index coordinate * vector index

/-- Congruence transport is additive in the coefficient form. -/
def matrixCongruenceAddHom
    {S BaseAxis SplitAxis : Type*} [CommRing S]
    [Fintype BaseAxis]
    (basis : Matrix BaseAxis SplitAxis S) :
    Matrix BaseAxis BaseAxis S →+ Matrix SplitAxis SplitAxis S where
  toFun := matrixCongruence basis
  map_zero' := by
    simp [matrixCongruence]
  map_add' := by
    intro left right
    simp [matrixCongruence, Matrix.mul_add, Matrix.add_mul]

/-- Congruence transport preserves symmetry of bilinear coefficient forms. -/
theorem matrixCongruence_isSymm
    {S BaseAxis SplitAxis : Type*} [CommRing S]
    [Fintype BaseAxis]
    (basis : Matrix BaseAxis SplitAxis S)
    (form : Matrix BaseAxis BaseAxis S) (symmetric : form.IsSymm) :
    (matrixCongruence basis form).IsSymm := by
  unfold Matrix.IsSymm at symmetric ⊢
  unfold matrixCongruence
  rw [Matrix.transpose_mul, Matrix.transpose_mul, Matrix.transpose_transpose,
    symmetric]
  simp only [Matrix.mul_assoc]

/-- A congruence change of coordinates sends a scalar rank-one coefficient
form to the scalar rank-one form of the transported vector. -/
theorem matrixCongruence_matrixRankOne
    {S BaseAxis SplitAxis : Type*} [CommRing S]
    [Fintype BaseAxis]
    (basis : Matrix BaseAxis SplitAxis S)
    (coefficient : S) (vector : BaseAxis → S) :
    matrixCongruence basis (matrixRankOne coefficient vector) =
      matrixRankOne coefficient (splitCoordinateVector basis vector) := by
  ext row column
  change
    (∑ second, (∑ first,
      basis first row * (coefficient * vector first * vector second)) *
        basis second column) =
      coefficient * (∑ first, basis first row * vector first) *
        (∑ second, basis second column * vector second)
  have innerFactor (second : BaseAxis) :
      (∑ first,
        basis first row * (coefficient * vector first * vector second)) =
        coefficient * (∑ first, basis first row * vector first) *
          vector second := by
    calc
      _ = ∑ first,
          (coefficient * (basis first row * vector first)) * vector second := by
            apply Finset.sum_congr rfl
            intro first _
            ring
      _ = (∑ first, coefficient * (basis first row * vector first)) *
          vector second := (Finset.sum_mul _ _ _).symm
      _ = coefficient * (∑ first, basis first row * vector first) *
          vector second := by rw [Finset.mul_sum]
  calc
    _ = ∑ second,
        (coefficient * (∑ first, basis first row * vector first) *
          vector second) * basis second column := by
      apply Finset.sum_congr rfl
      intro second _
      rw [innerFactor second]
    _ = coefficient * (∑ first, basis first row * vector first) *
        (∑ second, basis second column * vector second) := by
      calc
        _ = ∑ second,
            (coefficient * (∑ first, basis first row * vector first)) *
              (basis second column * vector second) := by
                apply Finset.sum_congr rfl
                intro second _
                ring
        _ = _ := (Finset.mul_sum _ _ _).symm

/-- Entrywise coefficient extension followed by congruence in a supplied
split basis.  The base and split coordinate types are intentionally distinct. -/
def splitCoordinateCoefficientExtension
    {R S BaseAxis SplitAxis : Type*} [CommRing R] [CommRing S]
    [Algebra R S] [Fintype BaseAxis]
    (basis : Matrix BaseAxis SplitAxis S)
    (form : Matrix BaseAxis BaseAxis R) : Matrix SplitAxis SplitAxis S :=
  matrixCongruence basis (matrixCoefficientExtension form)

/-- Scalar extension followed by split-coordinate transport preserves the
rank-one shape, with both the coefficient and vector extended to the splitting
ring before the basis change. -/
theorem splitCoordinateCoefficientExtension_matrixRankOne
    {R S BaseAxis SplitAxis : Type*} [CommRing R] [CommRing S]
    [Algebra R S] [Fintype BaseAxis]
    (basis : Matrix BaseAxis SplitAxis S)
    (coefficient : R) (vector : BaseAxis → R) :
    splitCoordinateCoefficientExtension basis
        (matrixRankOne coefficient vector) =
      matrixRankOne (algebraMap R S coefficient)
        (splitCoordinateVector basis
          (fun index ↦ algebraMap R S (vector index))) := by
  rw [splitCoordinateCoefficientExtension,
    matrixCoefficientExtension_matrixRankOne,
    matrixCongruence_matrixRankOne]

/-- Scalar extension followed by congruence transport preserves symmetry of a
base coefficient form. -/
theorem splitCoordinateCoefficientExtension_isSymm
    {R S BaseAxis SplitAxis : Type*} [CommRing R] [CommRing S]
    [Algebra R S] [Fintype BaseAxis]
    (basis : Matrix BaseAxis SplitAxis S)
    (form : Matrix BaseAxis BaseAxis R) (symmetric : form.IsSymm) :
    (splitCoordinateCoefficientExtension basis form).IsSymm := by
  apply matrixCongruence_isSymm
  ext row column
  change algebraMap R S (form column row) = algebraMap R S (form row column)
  rw [show form column row = form row column by
    simpa [Matrix.IsSymm, Matrix.transpose_apply] using
      congrFun (congrFun symmetric row) column]

/-- The inverse basis change recovers the original bilinear form.  This
certifies that the congruence map attached to a supplied coordinate
equivalence loses no coefficient information. -/
theorem matrixCongruence_toBase_toSplit
    {S BaseAxis SplitAxis : Type*} [CommRing S]
    [Fintype BaseAxis] [Fintype SplitAxis]
    [DecidableEq BaseAxis] [DecidableEq SplitAxis]
    (basis : SplitCoordinateBasisEquivalence S BaseAxis SplitAxis)
    (form : Matrix BaseAxis BaseAxis S) :
    matrixCongruence basis.toBase (matrixCongruence basis.toSplit form) = form := by
  calc
    _ = (basis.toSplit * basis.toBase).transpose * form *
        (basis.toSplit * basis.toBase) := by
          simp only [matrixCongruence, Matrix.transpose_mul, Matrix.mul_assoc]
    _ = form := by rw [basis.toSplit_mul_toBase]; simp

/-- Congruence transport by a supplied coordinate equivalence is injective. -/
theorem matrixCongruence_injective
    {S BaseAxis SplitAxis : Type*} [CommRing S]
    [Fintype BaseAxis] [Fintype SplitAxis]
    [DecidableEq BaseAxis] [DecidableEq SplitAxis]
    (basis : SplitCoordinateBasisEquivalence S BaseAxis SplitAxis) :
    Function.Injective (matrixCongruence basis.toSplit) := by
  intro left right equality
  have recovered := congrArg (matrixCongruence basis.toBase) equality
  simpa only [matrixCongruence_toBase_toSplit] using recovered

end GraphLattices

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
