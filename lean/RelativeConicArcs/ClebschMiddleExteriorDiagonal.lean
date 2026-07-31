import RelativeConicArcs.ClebschMiddleExterior

/-!
# Diagonal of the middle-exterior return

This leaf checks that the diagonal of the determinant-defined return recovers
the oriented triangle tensor with scalar four.  Native decision evaluates the
twenty diagonal entries from the definitions; no generated table is imported.
-/

namespace RelativeConicArcs
namespace ClebschMiddleExterior

open ClebschGoldenConference

set_option maxRecDepth 10000

/-- Complementation reverses the concatenation sign in middle degree. -/
theorem hodgeSign_complement (S : Fin 20) :
    hodgeSign (complementIndex S) = -hodgeSign S := by
  fin_cases S <;> rfl

/-- The Hodge matrix realizes the paper's column-action convention
`*e_S = ε(S,Sᶜ)e_{Sᶜ}`. -/
theorem hodgeMatrix_complement_entry (S : Fin 20) :
    hodgeMatrix (complementIndex S) S = hodgeSign S := by
  fin_cases S <;> rfl

/-- The diagonal of the middle-exterior return is four times the oriented
triangle sign. -/
theorem middleExterior_diagonal (S : Fin 20) :
    middleExterior S S =
      4 * triangleSign conferenceMatrix (triple S 0) (triple S 1) (triple S 2) := by
  native_decide +revert

end ClebschMiddleExterior
end RelativeConicArcs
