import RelativeConicArcs.ClebschMiddleExterior

/-!
# Middle-exterior square on rows 024 through 045

This leaf checks five rows of the determinant-defined square identity by
kernel decision on the twenty entries of each row.  The row partition bounds
elaboration memory; no return entries or generated certificate are stored, and
no compiled evaluation is used.
-/

namespace RelativeConicArcs
namespace ClebschMiddleExterior

open Matrix
open scoped Matrix

set_option maxRecDepth 10000

/-- Row 024 of the middle-exterior square identity. -/
theorem middleExterior_sq_row_024 (T : Fin 20) :
    (middleExterior * middleExterior) 5 T =
      (125 • (1 : Matrix (Fin 20) (Fin 20) ℤ)) 5 T := by
  decide +revert

/-- Row 025 of the middle-exterior square identity. -/
theorem middleExterior_sq_row_025 (T : Fin 20) :
    (middleExterior * middleExterior) 6 T =
      (125 • (1 : Matrix (Fin 20) (Fin 20) ℤ)) 6 T := by
  decide +revert

/-- Row 034 of the middle-exterior square identity. -/
theorem middleExterior_sq_row_034 (T : Fin 20) :
    (middleExterior * middleExterior) 7 T =
      (125 • (1 : Matrix (Fin 20) (Fin 20) ℤ)) 7 T := by
  decide +revert

/-- Row 035 of the middle-exterior square identity. -/
theorem middleExterior_sq_row_035 (T : Fin 20) :
    (middleExterior * middleExterior) 8 T =
      (125 • (1 : Matrix (Fin 20) (Fin 20) ℤ)) 8 T := by
  decide +revert

/-- Row 045 of the middle-exterior square identity. -/
theorem middleExterior_sq_row_045 (T : Fin 20) :
    (middleExterior * middleExterior) 9 T =
      (125 • (1 : Matrix (Fin 20) (Fin 20) ℤ)) 9 T := by
  decide +revert

end ClebschMiddleExterior
end RelativeConicArcs
