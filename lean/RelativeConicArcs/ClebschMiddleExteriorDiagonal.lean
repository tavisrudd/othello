import RelativeConicArcs.ClebschMiddleExterior

/-!
# Diagonal of the middle-exterior return

This leaf checks that the diagonal of the determinant-defined return recovers
the oriented triangle tensor with scalar four, by a kernel decision on the
twenty diagonal entries; no generated table is imported and no compiled
evaluation is used.  It also records the two sign conventions for
complementation, both consequences of the parity identity
`hodgeSign_mul_complement`.
-/

namespace RelativeConicArcs
namespace ClebschMiddleExterior

open ClebschGoldenConference

set_option maxRecDepth 10000

/-- Complementation reverses the concatenation sign in middle degree.  Since
the two complementary signs multiply to minus one and each squares to one,
dividing the first identity by `hodgeSign S` gives the statement. -/
theorem hodgeSign_complement (S : Fin 20) :
    hodgeSign (complementIndex S) = -hodgeSign S := by
  calc hodgeSign (complementIndex S)
      = hodgeSign S * hodgeSign S * hodgeSign (complementIndex S) := by
        rw [hodgeSign_mul_self, one_mul]
    _ = hodgeSign S * (hodgeSign S * hodgeSign (complementIndex S)) := by
        rw [mul_assoc]
    _ = -hodgeSign S := by rw [hodgeSign_mul_complement]; ring

/-- The Hodge matrix realizes the paper's column-action convention
`*e_S = ε(S,Sᶜ)e_{Sᶜ}`. -/
theorem hodgeMatrix_complement_entry (S : Fin 20) :
    hodgeMatrix (complementIndex S) S = hodgeSign S := by
  have h : complementIndex (complementIndex S) = S := complementIndex_involutive S
  simp [hodgeMatrix, h, hodgeSign_complement]

/-- The diagonal of the middle-exterior return is four times the oriented
triangle sign. -/
theorem middleExterior_diagonal (S : Fin 20) :
    middleExterior S S =
      4 * triangleSign conferenceMatrix (triple S 0) (triple S 1) (triple S 2) := by
  decide +revert

end ClebschMiddleExterior
end RelativeConicArcs
