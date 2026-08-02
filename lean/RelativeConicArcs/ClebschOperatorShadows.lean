import RelativeConicArcs.ClebschGoldenConference
import RelativeConicArcs.GoldenCommutatorPfaffian
import Mathlib.Tactic.Ring

/-!
# Conference triangle cubics as commutator Pfaffians

For the fixed order-six integral conference matrix, this module connects two
symbolic presentations of its oriented cubic over an arbitrary commutative
ring.  Expanding the bracket-weighted perfect matchings gives four times the
triangle-holonomy cubic.  Composing with the general order-six Pfaffian
expansion identifies the Pfaffian of the diagonal commutator with the same
cubic.

The proofs are polynomial identities after the matrix signs are expanded.
They do not formalize the representation-theoretic identification with
Joubert coordinates, the Segre cubic, or the Igusa quartic.
-/

namespace RelativeConicArcs.ClebschOperatorShadows

open ClebschGoldenConference
open GoldenCommutatorPfaffian

/-- The signed perfect-matching evaluation of the fixed conference matrix is
four times its triangle-holonomy cubic. -/
theorem matchingEvaluation_conferenceMatrix_eq_triangleCubic
    {R : Type*} [CommRing R] (x : Fin 6 → R) :
    matchingEvaluation (conferenceMatrixOver R) x =
      4 * triangleCubic (conferenceMatrixOver R) x := by
  simp [matchingEvaluation, GoldenMatchingCubics.bracket, triangleCubic,
    cubicTerm, triangleSign, conferenceMatrixOver, conferenceMatrix]
  ring

/-- The Pfaffian of the fixed conference bracket matrix is four times the
triangle-holonomy cubic. -/
theorem pfaffianSix_conferenceBracket_eq_four_triangleCubic
    {R : Type*} [CommRing R] (x : Fin 6 → R) :
    pfaffianSix (bracketMatrix (conferenceMatrixOver R) x) =
      4 * triangleCubic (conferenceMatrixOver R) x := by
  rw [pfaffianSix_bracketMatrix_eq_matchingEvaluation]
  exact matchingEvaluation_conferenceMatrix_eq_triangleCubic x

end RelativeConicArcs.ClebschOperatorShadows
