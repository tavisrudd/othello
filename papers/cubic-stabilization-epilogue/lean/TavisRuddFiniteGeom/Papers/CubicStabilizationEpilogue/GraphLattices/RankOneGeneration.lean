import Mathlib.Algebra.Ring.Defs
import Mathlib.Tactic

/-!
# A division-free rank-one identity

This module isolates the algebraic identity used to generate an off-diagonal
symmetric coefficient from rank-one symmetric tensors.  It is valid over an
arbitrary commutative ring and therefore introduces no division by two.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace GraphLattices

/-- The midpoint inequality supplies exponents for the division-free
rank-one decomposition.  The common residual exponent `t` records the parity
shared by the two diagonal exponents. -/
theorem exists_midpoint_exponents
    (diagonalFirst diagonalSecond cross : ℕ)
    (midpoint : diagonalFirst + diagonalSecond ≤ 2 * cross) :
    ∃ t r s : ℕ,
      diagonalFirst ≤ t + 2 * r ∧
      diagonalSecond ≤ t + 2 * s ∧
      cross = t + r + s := by
  let remaining := 2 * cross - diagonalFirst
  have sumRemaining : diagonalFirst + remaining = 2 * cross := by
    dsimp [remaining]
    omega
  refine ⟨diagonalFirst % 2, diagonalFirst / 2, remaining / 2, ?_, ?_, ?_⟩
  · omega
  · omega
  · omega

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
  simp only [sub, scale, rankOne, firstSquare, secondSquare,
    SymmetricPair.mk.injEq]
  constructor
  · ring
  constructor <;> ring

/-- Given the midpoint inequality, a cross coefficient of depth `cross` is
the difference of three explicit rank-one forms whose two diagonal depths are
at least the prescribed bounds.  The coefficient `z` is arbitrary, so the
identity covers every multiple of the cross-ideal generator. -/
theorem cross_coefficient_rankOne_decomposition
    (π z : R) (diagonalFirst diagonalSecond cross : ℕ)
    (midpoint : diagonalFirst + diagonalSecond ≤ 2 * cross) :
    ∃ t r s : ℕ,
      diagonalFirst ≤ t + 2 * r ∧
      diagonalSecond ≤ t + 2 * s ∧
      sub
          (sub
            (scale (z * π ^ t) (rankOne (π ^ r) (π ^ s)))
            (scale ((z * π ^ t) * π ^ r * π ^ r) firstSquare))
          (scale ((z * π ^ t) * π ^ s * π ^ s) secondSquare) =
        { diagonalFirst := 0, mixed := z * π ^ cross, diagonalSecond := 0 } := by
  obtain ⟨t, r, s, firstBound, secondBound, crossExponent⟩ :=
    exists_midpoint_exponents diagonalFirst diagonalSecond cross midpoint
  refine ⟨t, r, s, firstBound, secondBound, ?_⟩
  rw [scaled_rankOne_sub_diagonals]
  congr 1
  rw [crossExponent, pow_add, pow_add]
  ring

end SymmetricPair

end GraphLattices

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
