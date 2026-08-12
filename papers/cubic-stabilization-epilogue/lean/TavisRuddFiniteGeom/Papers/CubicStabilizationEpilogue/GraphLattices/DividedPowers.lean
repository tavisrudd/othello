import Mathlib.Tactic

/-!
# Square-zero divided-power expansion

This module isolates the integral algebra behind the passage from rank-one
divisors to divided powers.  It does not model divisor classes, cohomology, or
faithfully flat descent: it proves only the division-free square-zero
expansion used by that argument.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace GraphLattices

variable {R : Type*} [CommRing R]

/-- The degree-`k` squarefree product sum of a list.  Repeated values at
different list positions remain different factors, as required for a labelled
finite family of divisor classes. -/
def squarefreeProductSum : List R → ℕ → R
  | _, 0 => 1
  | [], _ + 1 => 0
  | x :: terms, k + 1 =>
      squarefreeProductSum terms (k + 1) + x * squarefreeProductSum terms k

/-- If `b² = 0`, the binomial expansion of `(a+b)^k` has only its constant
and linear terms in `b`.  The natural-number coefficient is kept as an
integral scalar; no division is used. -/
theorem add_pow_of_square_zero (a b : R) (squareZero : b * b = 0) (k : ℕ) :
    (a + b) ^ k = a ^ k + (k : R) * a ^ (k - 1) * b := by
  induction k with
  | zero => simp
  | succ k inductionHypothesis =>
      rw [pow_succ, inductionHypothesis]
      cases k with
      | zero => simp
      | succ k =>
          simp only [Nat.succ_sub_one, Nat.cast_succ]
          simp only [pow_succ]
          ring_nf
          have squareZeroPower : b ^ 2 = 0 := by simpa [pow_two] using squareZero
          rw [squareZeroPower]
          simp

/-- For a labelled finite family of square-zero elements, the `k`th power of
their sum is `k!` times the degree-`k` squarefree product sum.  This is the
division-free content of the usual divided-power formula. -/
theorem sum_pow_eq_factorial_mul_squarefreeProductSum
    (terms : List R) (squareZero : ∀ term ∈ terms, term * term = 0) (k : ℕ) :
    terms.sum ^ k = (k.factorial : R) * squarefreeProductSum terms k := by
  induction terms generalizing k with
  | nil =>
      cases k <;> simp [squarefreeProductSum]
  | cons head tail inductionHypothesis =>
      cases k with
      | zero => simp [squarefreeProductSum]
      | succ k =>
          have headSquareZero : head * head = 0 := squareZero head (by simp)
          have tailSquareZero : ∀ term ∈ tail, term * term = 0 := by
            intro term membership
            exact squareZero term (by simp [membership])
          rw [List.sum_cons, add_comm head tail.sum,
            add_pow_of_square_zero tail.sum head headSquareZero]
          rw [inductionHypothesis tailSquareZero (k + 1)]
          cases k with
          | zero => simp [squarefreeProductSum]
          | succ k =>
              simp only [Nat.succ_sub_one]
              rw [inductionHypothesis tailSquareZero (k + 1)]
              simp only [squarefreeProductSum, Nat.factorial_succ, Nat.cast_mul,
                Nat.cast_succ]
              ring

end GraphLattices

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
