import Mathlib.Algebra.Ring.Defs
import Mathlib.Tactic

/-!
# A division-free rank-one identity

This module isolates the algebraic identity used to generate an off-diagonal
symmetric coefficient from rank-one symmetric tensors.  It is valid over an
arbitrary commutative ring and therefore introduces no division by two.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

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
@[ext]
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

/-- Addition of symmetric coefficient triples. -/
def add (left right : SymmetricPair R) : SymmetricPair R where
  diagonalFirst := left.diagonalFirst + right.diagonalFirst
  mixed := left.mixed + right.mixed
  diagonalSecond := left.diagonalSecond + right.diagonalSecond

/-- Membership in the two-coordinate matrix-of-ideals lattice with diagonal
depths `diagonalFirst`, `diagonalSecond` and cross depth `cross`. -/
def MemWeightedPair
    (π : R) (diagonalFirst diagonalSecond cross : ℕ)
    (form : SymmetricPair R) : Prop :=
  π ^ diagonalFirst ∣ form.diagonalFirst ∧
  π ^ cross ∣ form.mixed ∧
  π ^ diagonalSecond ∣ form.diagonalSecond

/-- A prescribed power divides a scalar multiple of a deeper power. -/
theorem pow_dvd_scalar_mul_pow
    (π z : R) {lower upper : ℕ} (bound : lower ≤ upper) :
    π ^ lower ∣ z * π ^ upper := by
  exact (pow_dvd_pow π bound).trans ⟨z, by ring⟩

/-- A diagonal square at depth `upper` belongs to every weighted pair lattice
whose corresponding diagonal depth is at most `upper`. -/
theorem scale_firstSquare_mem
    (π z : R) (diagonalFirst diagonalSecond cross upper : ℕ)
    (bound : diagonalFirst ≤ upper) :
    MemWeightedPair π diagonalFirst diagonalSecond cross
      (scale (z * π ^ upper) firstSquare) := by
  constructor
  · simpa [scale, firstSquare, rankOne] using
      pow_dvd_scalar_mul_pow π z bound
  constructor <;> simp [scale, firstSquare, rankOne]

/-- The analogous membership statement for the second diagonal square. -/
theorem scale_secondSquare_mem
    (π z : R) (diagonalFirst diagonalSecond cross upper : ℕ)
    (bound : diagonalSecond ≤ upper) :
    MemWeightedPair π diagonalFirst diagonalSecond cross
      (scale (z * π ^ upper) secondSquare) := by
  constructor
  · simp [scale, secondSquare, rankOne]
  constructor
  · simp [scale, secondSquare, rankOne]
  · simpa [scale, secondSquare, rankOne] using
      pow_dvd_scalar_mul_pow π z bound

/-- A rank-one pair with powered coordinates belongs to the weighted lattice
when its two diagonal depths and cross depth satisfy the displayed bounds. -/
theorem scaled_power_rankOne_mem
    (π z : R) (diagonalFirst diagonalSecond cross t r s : ℕ)
    (firstBound : diagonalFirst ≤ t + 2 * r)
    (secondBound : diagonalSecond ≤ t + 2 * s)
    (crossBound : cross ≤ t + r + s) :
    MemWeightedPair π diagonalFirst diagonalSecond cross
      (scale (z * π ^ t) (rankOne (π ^ r) (π ^ s))) := by
  constructor
  · have divides := pow_dvd_scalar_mul_pow π z firstBound
    simpa [scale, rankOne, pow_add, pow_mul, pow_two,
      mul_assoc, mul_left_comm, mul_comm] using divides
  constructor
  · have divides := pow_dvd_scalar_mul_pow π z crossBound
    simpa [scale, rankOne, pow_add, mul_assoc, mul_left_comm, mul_comm] using divides
  · have divides := pow_dvd_scalar_mul_pow π z secondBound
    simpa [scale, rankOne, pow_add, pow_mul, pow_two,
      mul_assoc, mul_left_comm, mul_comm] using divides

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

/-- The constructive half of rank-one generation for one two-coordinate
matrix-of-ideals block.  Every member is the sum of its two diagonal rank-one
forms and a difference of three rank-one forms for the cross coefficient; all
five displayed forms remain in the same weighted lattice. -/
theorem weightedPair_decomposition_of_midpoint
    (π : R) (diagonalFirst diagonalSecond cross : ℕ)
    (midpoint : diagonalFirst + diagonalSecond ≤ 2 * cross)
    (form : SymmetricPair R)
    (member : MemWeightedPair π diagonalFirst diagonalSecond cross form) :
    ∃ firstCoefficient mixedCoefficient secondCoefficient : R,
      ∃ t r s : ℕ,
        diagonalFirst ≤ t + 2 * r ∧
        diagonalSecond ≤ t + 2 * s ∧
        MemWeightedPair π diagonalFirst diagonalSecond cross
          (scale (π ^ diagonalFirst * firstCoefficient) firstSquare) ∧
        MemWeightedPair π diagonalFirst diagonalSecond cross
          (scale (π ^ diagonalSecond * secondCoefficient) secondSquare) ∧
        MemWeightedPair π diagonalFirst diagonalSecond cross
          (scale (mixedCoefficient * π ^ t) (rankOne (π ^ r) (π ^ s))) ∧
        MemWeightedPair π diagonalFirst diagonalSecond cross
          (scale ((mixedCoefficient * π ^ t) * π ^ r * π ^ r) firstSquare) ∧
        MemWeightedPair π diagonalFirst diagonalSecond cross
          (scale ((mixedCoefficient * π ^ t) * π ^ s * π ^ s) secondSquare) ∧
        form =
          add (scale (π ^ diagonalFirst * firstCoefficient) firstSquare)
            (add (scale (π ^ diagonalSecond * secondCoefficient) secondSquare)
              (sub
                (sub
                  (scale (mixedCoefficient * π ^ t)
                    (rankOne (π ^ r) (π ^ s)))
                  (scale ((mixedCoefficient * π ^ t) * π ^ r * π ^ r)
                    firstSquare))
                (scale ((mixedCoefficient * π ^ t) * π ^ s * π ^ s)
                  secondSquare))) := by
  rcases member with ⟨⟨firstCoefficient, firstEquality⟩,
    ⟨mixedCoefficient, mixedEquality⟩, ⟨secondCoefficient, secondEquality⟩⟩
  obtain ⟨t, r, s, firstBound, secondBound, crossEquality⟩ :=
    exists_midpoint_exponents diagonalFirst diagonalSecond cross midpoint
  refine ⟨firstCoefficient, mixedCoefficient, secondCoefficient,
    t, r, s, firstBound, secondBound, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · simpa [mul_comm] using scale_firstSquare_mem π firstCoefficient
      diagonalFirst diagonalSecond cross diagonalFirst (le_refl _)
  · simpa [mul_comm] using scale_secondSquare_mem π secondCoefficient
      diagonalFirst diagonalSecond cross diagonalSecond (le_refl _)
  · exact scaled_power_rankOne_mem π mixedCoefficient _ _ _ _ _ _
      firstBound secondBound (le_of_eq crossEquality)
  · simpa [pow_add, pow_mul, pow_two, mul_assoc, mul_left_comm, mul_comm] using
      scale_firstSquare_mem π mixedCoefficient
        diagonalFirst diagonalSecond cross (t + 2 * r) firstBound
  · simpa [pow_add, pow_mul, pow_two, mul_assoc, mul_left_comm, mul_comm] using
      scale_secondSquare_mem π mixedCoefficient
        diagonalFirst diagonalSecond cross (t + 2 * s) secondBound
  · apply SymmetricPair.ext
    · dsimp [add, sub, scale, rankOne, firstSquare, secondSquare]
      rw [firstEquality]
      ring
    · dsimp [add, sub, scale, rankOne, firstSquare, secondSquare]
      rw [mixedEquality, crossEquality, pow_add, pow_add]
      ring
    · dsimp [add, sub, scale, rankOne, firstSquare, secondSquare]
      rw [secondEquality]
      ring

end SymmetricPair

end GraphLattices

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
