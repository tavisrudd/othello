import RelativeConicArcs.ClebschMiddleExterior

/-!
# Middle-exterior square on rows 123 through 135

This leaf checks five rows of the determinant-defined square identity by
native decision.  The row partition bounds elaboration memory; no return
entries or generated certificate are stored.
-/

namespace RelativeConicArcs
namespace ClebschMiddleExterior

open Matrix
open scoped Matrix

set_option maxRecDepth 10000

/-- Row 123 of the middle-exterior square identity. -/
theorem middleExterior_sq_row_123 (T : Fin 20) :
    (middleExterior * middleExterior) 10 T =
      (125 • (1 : Matrix (Fin 20) (Fin 20) ℤ)) 10 T := by
  native_decide +revert

/-- Row 124 of the middle-exterior square identity. -/
theorem middleExterior_sq_row_124 (T : Fin 20) :
    (middleExterior * middleExterior) 11 T =
      (125 • (1 : Matrix (Fin 20) (Fin 20) ℤ)) 11 T := by
  native_decide +revert

/-- Row 125 of the middle-exterior square identity. -/
theorem middleExterior_sq_row_125 (T : Fin 20) :
    (middleExterior * middleExterior) 12 T =
      (125 • (1 : Matrix (Fin 20) (Fin 20) ℤ)) 12 T := by
  native_decide +revert

/-- Row 134 of the middle-exterior square identity. -/
theorem middleExterior_sq_row_134 (T : Fin 20) :
    (middleExterior * middleExterior) 13 T =
      (125 • (1 : Matrix (Fin 20) (Fin 20) ℤ)) 13 T := by
  native_decide +revert

/-- Row 135 of the middle-exterior square identity. -/
theorem middleExterior_sq_row_135 (T : Fin 20) :
    (middleExterior * middleExterior) 14 T =
      (125 • (1 : Matrix (Fin 20) (Fin 20) ℤ)) 14 T := by
  native_decide +revert

end ClebschMiddleExterior
end RelativeConicArcs
