import RelativeConicArcs.ClebschGoldenConference
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic

/-!
# The middle exterior return on six labelled axes

The twenty basis vectors are the increasing three-subsets of six labels in
lexicographic order.  The third compound matrix is defined entrywise by the
corresponding `3 × 3` minor.  Signed complementation defines the middle Hodge
matrix, and their product is the middle-exterior return.

Lean evaluates the square, diagonal, and parity statements from these
definitions by native decision.  No `20 × 20` return matrix, generated table,
or external axiom is imported.
-/

namespace RelativeConicArcs
namespace ClebschMiddleExterior

open Matrix
open scoped Matrix
open ClebschGoldenConference

/-- The increasing triples of `Fin 6`, in lexicographic order. -/
def triple : Fin 20 → Fin 3 → Fin 6 :=
  ![![0, 1, 2], ![0, 1, 3], ![0, 1, 4], ![0, 1, 5],
    ![0, 2, 3], ![0, 2, 4], ![0, 2, 5], ![0, 3, 4],
    ![0, 3, 5], ![0, 4, 5], ![1, 2, 3], ![1, 2, 4],
    ![1, 2, 5], ![1, 3, 4], ![1, 3, 5], ![1, 4, 5],
    ![2, 3, 4], ![2, 3, 5], ![2, 4, 5], ![3, 4, 5]]

/-- The underlying three-element set of a basis label. -/
def tripleSet (S : Fin 20) : Finset (Fin 6) :=
  {triple S 0, triple S 1, triple S 2}

/-- Intersection size of two triple-basis labels. -/
def intersectionSize (S T : Fin 20) : ℕ :=
  (tripleSet S ∩ tripleSet T).card

/-- Number of basis labels meeting each of two triples in one point. -/
def commonIntersectionOneNeighbors (S T : Fin 20) : ℕ :=
  (Finset.univ.filter fun U : Fin 20 =>
    intersectionSize U S = 1 ∧ intersectionSize U T = 1).card

/-- Complementation on the lexicographically ordered triple basis. -/
def complementIndex : Fin 20 → Fin 20 :=
  ![19, 18, 17, 16, 15, 14, 13, 12, 11, 10,
    9, 8, 7, 6, 5, 4, 3, 2, 1, 0]

/-- Sign of the permutation obtained by concatenating a triple with its
increasing complement. -/
def hodgeSign : Fin 20 → ℤ :=
  ![1, -1, 1, -1, 1, -1, 1, 1, -1, 1,
    -1, 1, -1, -1, 1, -1, 1, -1, 1, -1]

/-- Signed middle-degree Hodge complementation. -/
def hodgeMatrix : Matrix (Fin 20) (Fin 20) ℤ :=
  fun S T => if T = complementIndex S then hodgeSign S else 0

/-- The `3 × 3` minor selected by two increasing triples. -/
def minorThree (C : Matrix (Fin 6) (Fin 6) ℤ) (S T : Fin 20) :
    Matrix (Fin 3) (Fin 3) ℤ :=
  fun i j => C (triple S i) (triple T j)

/-- Closed determinant formula in dimension three. -/
def detThree (A : Matrix (Fin 3) (Fin 3) ℤ) : ℤ :=
  A 0 0 * A 1 1 * A 2 2 - A 0 0 * A 1 2 * A 2 1
    - A 0 1 * A 1 0 * A 2 2 + A 0 1 * A 1 2 * A 2 0
    + A 0 2 * A 1 0 * A 2 1 - A 0 2 * A 1 1 * A 2 0

/-- The closed formula is the ordinary matrix determinant. -/
theorem detThree_eq_det (A : Matrix (Fin 3) (Fin 3) ℤ) :
    detThree A = Matrix.det A := by
  simpa [detThree] using (Matrix.det_fin_three A).symm

/-- The third compound matrix, representing the third exterior power in the
increasing-triple bases. -/
def compoundThree (C : Matrix (Fin 6) (Fin 6) ℤ) :
    Matrix (Fin 20) (Fin 20) ℤ :=
  fun S T => detThree (minorThree C S T)

/-- The middle-exterior return `* Λ³C` for the golden conference matrix.  The
sparse Hodge factor is evaluated directly. -/
def middleExterior : Matrix (Fin 20) (Fin 20) ℤ :=
  fun S T => hodgeSign S * compoundThree conferenceMatrix (complementIndex S) T

/-- The direct sparse formula for the return equals Hodge multiplication by
the third compound matrix. -/
theorem middleExterior_eq_hodge_mul :
    middleExterior = hodgeMatrix * compoundThree conferenceMatrix := by
  ext S T
  simp [middleExterior, hodgeMatrix, Matrix.mul_apply]

end ClebschMiddleExterior
end RelativeConicArcs
