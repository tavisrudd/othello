import RelativeConicArcs.GoldenMatchingCubics
import Mathlib.Tactic.Ring

/-!
# The order-six commutator Pfaffian as a matching evaluation

Given six affine coordinates `x` and a coefficient matrix `C`, the bracket
matrix has entry `(xᵢ-xⱼ)Cᵢⱼ`.  When `C` is symmetric this matrix is
skew-symmetric.  Expanding its Pfaffian produces the signed sum over all
fifteen perfect matchings of six labels, with each term equal to the product
of three brackets and the corresponding three entries of `C`.

This module fixes the Pfaffian sign convention by an explicit first-row
expansion and proves the matching identity symbolically over every commutative
ring.  It does not assume a conference equation or a special order-six sign
matrix.
-/

namespace RelativeConicArcs.GoldenCommutatorPfaffian

open RelativeConicArcs.GoldenMatchingCubics

/-- The entrywise bracket matrix associated with affine coordinates and a
coefficient matrix. -/
def bracketMatrix {R : Type*} [CommRing R] (C : Matrix (Fin 6) (Fin 6) R)
    (x : Fin 6 → R) : Matrix (Fin 6) (Fin 6) R :=
  fun i j => bracket x i j * C i j

/-- A symmetric coefficient matrix produces a skew-symmetric bracket matrix. -/
theorem bracketMatrix_transpose {R : Type*} [CommRing R]
    (C : Matrix (Fin 6) (Fin 6) R) (x : Fin 6 → R)
    (hC : C.transpose = C) :
    (bracketMatrix C x).transpose = -bracketMatrix C x := by
  ext i j
  have hij : C j i = C i j := by
    have := congrFun (congrFun hC i) j
    simpa using this
  simp [bracketMatrix, bracket, hij]
  ring

/-- The Pfaffian of a six-by-six matrix, with signs fixed by expansion along
the first row.  On skew-symmetric matrices this is the standard Pfaffian. -/
def pfaffianSix {R : Type*} [CommRing R]
    (A : Matrix (Fin 6) (Fin 6) R) : R :=
  A 0 1 * (A 2 3 * A 4 5 - A 2 4 * A 3 5 + A 2 5 * A 3 4) -
  A 0 2 * (A 1 3 * A 4 5 - A 1 4 * A 3 5 + A 1 5 * A 3 4) +
  A 0 3 * (A 1 2 * A 4 5 - A 1 4 * A 2 5 + A 1 5 * A 2 4) -
  A 0 4 * (A 1 2 * A 3 5 - A 1 3 * A 2 5 + A 1 5 * A 2 3) +
  A 0 5 * (A 1 2 * A 3 4 - A 1 3 * A 2 4 + A 1 4 * A 2 3)

/-- The signed perfect-matching evaluation obtained by weighting each of the
fifteen bracket products by the corresponding three entries of `C`. -/
def matchingEvaluation {R : Type*} [CommRing R]
    (C : Matrix (Fin 6) (Fin 6) R) (x : Fin 6 → R) : R :=
  C 0 1 * C 2 3 * C 4 5 *
      (bracket x 0 1 * bracket x 2 3 * bracket x 4 5) -
  C 0 1 * C 2 4 * C 3 5 *
      (bracket x 0 1 * bracket x 2 4 * bracket x 3 5) +
  C 0 1 * C 2 5 * C 3 4 *
      (bracket x 0 1 * bracket x 2 5 * bracket x 3 4) -
  C 0 2 * C 1 3 * C 4 5 *
      (bracket x 0 2 * bracket x 1 3 * bracket x 4 5) +
  C 0 2 * C 1 4 * C 3 5 *
      (bracket x 0 2 * bracket x 1 4 * bracket x 3 5) -
  C 0 2 * C 1 5 * C 3 4 *
      (bracket x 0 2 * bracket x 1 5 * bracket x 3 4) +
  C 0 3 * C 1 2 * C 4 5 *
      (bracket x 0 3 * bracket x 1 2 * bracket x 4 5) -
  C 0 3 * C 1 4 * C 2 5 *
      (bracket x 0 3 * bracket x 1 4 * bracket x 2 5) +
  C 0 3 * C 1 5 * C 2 4 *
      (bracket x 0 3 * bracket x 1 5 * bracket x 2 4) -
  C 0 4 * C 1 2 * C 3 5 *
      (bracket x 0 4 * bracket x 1 2 * bracket x 3 5) +
  C 0 4 * C 1 3 * C 2 5 *
      (bracket x 0 4 * bracket x 1 3 * bracket x 2 5) -
  C 0 4 * C 1 5 * C 2 3 *
      (bracket x 0 4 * bracket x 1 5 * bracket x 2 3) +
  C 0 5 * C 1 2 * C 3 4 *
      (bracket x 0 5 * bracket x 1 2 * bracket x 3 4) -
  C 0 5 * C 1 3 * C 2 4 *
      (bracket x 0 5 * bracket x 1 3 * bracket x 2 4) +
  C 0 5 * C 1 4 * C 2 3 *
      (bracket x 0 5 * bracket x 1 4 * bracket x 2 3)

/-- The Pfaffian of the bracket matrix is exactly its signed perfect-matching
evaluation. -/
theorem pfaffianSix_bracketMatrix_eq_matchingEvaluation
    {R : Type*} [CommRing R] (C : Matrix (Fin 6) (Fin 6) R)
    (x : Fin 6 → R) :
    pfaffianSix (bracketMatrix C x) = matchingEvaluation C x := by
  simp [pfaffianSix, bracketMatrix, matchingEvaluation]
  ring

/-- Common affine translation of the six coordinates leaves the matching
evaluation unchanged. -/
theorem matchingEvaluation_translate {R : Type*} [CommRing R]
    (C : Matrix (Fin 6) (Fin 6) R) (x : Fin 6 → R) (t : R) :
    matchingEvaluation C (fun i => x i + t) = matchingEvaluation C x := by
  simp [matchingEvaluation, bracket]
  ring

/-- Common scaling gives the matching evaluation affine weight three. -/
theorem matchingEvaluation_scale {R : Type*} [CommRing R]
    (C : Matrix (Fin 6) (Fin 6) R) (x : Fin 6 → R) (s : R) :
    matchingEvaluation C (fun i => s * x i) =
      s ^ 3 * matchingEvaluation C x := by
  simp [matchingEvaluation, bracket]
  ring

end RelativeConicArcs.GoldenCommutatorPfaffian
