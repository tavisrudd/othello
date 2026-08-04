import RelativeConicArcs.ClebschMiddleExterior

/-!
# Middle-exterior square on rows 012 through 023

This leaf checks five rows of the determinant-defined square identity by
native decision.  The row partition bounds elaboration memory; no return
entries or generated certificate are stored.
-/

namespace RelativeConicArcs
namespace ClebschMiddleExterior

open Matrix
open scoped Matrix

set_option maxRecDepth 10000

/-- Row 012 of the middle-exterior square identity. -/
theorem middleExterior_sq_row_012 (T : Fin 20) :
    (middleExterior * middleExterior) 0 T =
      (125 • (1 : Matrix (Fin 20) (Fin 20) ℤ)) 0 T := by
  decide +revert

/-- Row 013 of the middle-exterior square identity. -/
theorem middleExterior_sq_row_013 (T : Fin 20) :
    (middleExterior * middleExterior) 1 T =
      (125 • (1 : Matrix (Fin 20) (Fin 20) ℤ)) 1 T := by
  decide +revert

/-- Row 014 of the middle-exterior square identity. -/
theorem middleExterior_sq_row_014 (T : Fin 20) :
    (middleExterior * middleExterior) 2 T =
      (125 • (1 : Matrix (Fin 20) (Fin 20) ℤ)) 2 T := by
  decide +revert

/-- Row 015 of the middle-exterior square identity. -/
theorem middleExterior_sq_row_015 (T : Fin 20) :
    (middleExterior * middleExterior) 3 T =
      (125 • (1 : Matrix (Fin 20) (Fin 20) ℤ)) 3 T := by
  decide +revert

/-- Row 023 of the middle-exterior square identity. -/
theorem middleExterior_sq_row_023 (T : Fin 20) :
    (middleExterior * middleExterior) 4 T =
      (125 • (1 : Matrix (Fin 20) (Fin 20) ℤ)) 4 T := by
  decide +revert

end ClebschMiddleExterior
end RelativeConicArcs
