import RelativeConicArcs.NinePointHeisenbergConicType27To29
import RelativeConicArcs.NinePointHeisenbergConicType30To32
import RelativeConicArcs.NinePointHeisenbergConicType33To35

/-! # Conic point types for normalized conics 28 through 36

This module combines three kernel-checked three-conic blocks by symbolic list decomposition.
-/
namespace RelativeConicArcs.NinePointHeisenbergConicType27To35
open NinePointHeisenbergConicCensus NinePointHeisenbergConicTable
/-- The discriminant and secant definitions agree on conics 28 through 36. -/
theorem discriminant_type_agrees_with_secants :
    ((conicTable.drop 27).take 9).all conicTypeAgreement = true := by
  simpa using all_take_nine_of_three (conicTable.drop 27) conicTypeAgreement
    NinePointHeisenbergConicType27To29.agreement
    NinePointHeisenbergConicType30To32.agreement
    NinePointHeisenbergConicType33To35.agreement
end RelativeConicArcs.NinePointHeisenbergConicType27To35
