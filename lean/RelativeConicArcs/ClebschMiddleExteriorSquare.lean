import RelativeConicArcs.ClebschMiddleExteriorSquareRows012To023
import RelativeConicArcs.ClebschMiddleExteriorSquareRows024To045
import RelativeConicArcs.ClebschMiddleExteriorSquareRows123To135
import RelativeConicArcs.ClebschMiddleExteriorSquareRows145To345

/-!
# Square of the middle-exterior return

This leaf checks the two square identities for signed Hodge complementation
and the determinant-defined middle-exterior return.  Native decision evaluates
the definitions imported from `ClebschMiddleExterior`; no return matrix or
generated certificate is stored here.
-/

namespace RelativeConicArcs
namespace ClebschMiddleExterior

open Matrix
open scoped Matrix

set_option maxRecDepth 10000

/-- Middle-degree Hodge complementation squares to minus the identity. -/
theorem hodgeMatrix_sq :
    hodgeMatrix * hodgeMatrix = -(1 : Matrix (Fin 20) (Fin 20) ℤ) := by
  native_decide

/-- The middle-exterior return satisfies `K² = 125I`. -/
theorem middleExterior_sq :
    middleExterior * middleExterior =
      125 • (1 : Matrix (Fin 20) (Fin 20) ℤ) := by
  ext S T
  fin_cases S
  · exact middleExterior_sq_row_012 T
  · exact middleExterior_sq_row_013 T
  · exact middleExterior_sq_row_014 T
  · exact middleExterior_sq_row_015 T
  · exact middleExterior_sq_row_023 T
  · exact middleExterior_sq_row_024 T
  · exact middleExterior_sq_row_025 T
  · exact middleExterior_sq_row_034 T
  · exact middleExterior_sq_row_035 T
  · exact middleExterior_sq_row_045 T
  · exact middleExterior_sq_row_123 T
  · exact middleExterior_sq_row_124 T
  · exact middleExterior_sq_row_125 T
  · exact middleExterior_sq_row_134 T
  · exact middleExterior_sq_row_135 T
  · exact middleExterior_sq_row_145 T
  · exact middleExterior_sq_row_234 T
  · exact middleExterior_sq_row_235 T
  · exact middleExterior_sq_row_245 T
  · exact middleExterior_sq_row_345 T

end ClebschMiddleExterior
end RelativeConicArcs
