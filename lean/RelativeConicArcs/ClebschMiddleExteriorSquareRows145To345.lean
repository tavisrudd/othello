import RelativeConicArcs.ClebschMiddleExterior

/-!
# Middle-exterior square on rows 145 through 345

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

/-- Row 145 of the middle-exterior square identity. -/
theorem middleExterior_sq_row_145 (T : Fin 20) :
    (middleExterior * middleExterior) 15 T =
      (125 • (1 : Matrix (Fin 20) (Fin 20) ℤ)) 15 T := by
  decide +revert

/-- Row 234 of the middle-exterior square identity. -/
theorem middleExterior_sq_row_234 (T : Fin 20) :
    (middleExterior * middleExterior) 16 T =
      (125 • (1 : Matrix (Fin 20) (Fin 20) ℤ)) 16 T := by
  decide +revert

/-- Row 235 of the middle-exterior square identity. -/
theorem middleExterior_sq_row_235 (T : Fin 20) :
    (middleExterior * middleExterior) 17 T =
      (125 • (1 : Matrix (Fin 20) (Fin 20) ℤ)) 17 T := by
  decide +revert

/-- Row 245 of the middle-exterior square identity. -/
theorem middleExterior_sq_row_245 (T : Fin 20) :
    (middleExterior * middleExterior) 18 T =
      (125 • (1 : Matrix (Fin 20) (Fin 20) ℤ)) 18 T := by
  decide +revert

/-- Row 345 of the middle-exterior square identity. -/
theorem middleExterior_sq_row_345 (T : Fin 20) :
    (middleExterior * middleExterior) 19 T =
      (125 • (1 : Matrix (Fin 20) (Fin 20) ℤ)) 19 T := by
  decide +revert

end ClebschMiddleExterior
end RelativeConicArcs
