import Mathlib.Algebra.Ring.Defs
import Mathlib.Tactic.Ring

/-!
# A division-free rank-one identity

This module isolates the algebraic identity used to generate an off-diagonal
symmetric coefficient from rank-one symmetric tensors.  It is valid over an
arbitrary commutative ring and therefore introduces no division by two.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace GraphLattices

/-- The diagonal and mixed coefficients of a symmetric tensor on a labelled
two-dimensional module. -/
structure SymmetricPair (R : Type*) where
  diagonalFirst : R
  mixed : R
  diagonalSecond : R

namespace SymmetricPair

variable {R : Type*} [CommRing R]

/-- Scalar multiplication of all three coefficients. -/
def scale (c : R) (form : SymmetricPair R) : SymmetricPair R where
  diagonalFirst := c * form.diagonalFirst
  mixed := c * form.mixed
  diagonalSecond := c * form.diagonalSecond

/-- The rank-one symmetric tensor determined by coordinates `a` and `b`. -/
def rankOne (a b : R) : SymmetricPair R where
  diagonalFirst := a * a
  mixed := a * b
  diagonalSecond := b * b

/-- The pure first-coordinate square. -/
def firstSquare : SymmetricPair R := rankOne 1 0

/-- The pure second-coordinate square. -/
def secondSquare : SymmetricPair R := rankOne 0 1

/-- Subtraction of symmetric coefficient triples. -/
def sub (left right : SymmetricPair R) : SymmetricPair R where
  diagonalFirst := left.diagonalFirst - right.diagonalFirst
  mixed := left.mixed - right.mixed
  diagonalSecond := left.diagonalSecond - right.diagonalSecond

/-- A scaled mixed coefficient is a difference of three rank-one tensors.
The formula is the division-free algebraic core of the midpoint criterion for
symmetric matrix-of-ideals lattices. -/
theorem scaled_rankOne_sub_diagonals
    (c a b : R) :
    sub (sub (scale c (rankOne a b)) (scale (c * a * a) firstSquare))
        (scale (c * b * b) secondSquare) =
      { diagonalFirst := 0, mixed := c * a * b, diagonalSecond := 0 } := by
  ext <;> simp [sub, scale, rankOne, firstSquare, secondSquare] <;> ring

end SymmetricPair

end GraphLattices

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
