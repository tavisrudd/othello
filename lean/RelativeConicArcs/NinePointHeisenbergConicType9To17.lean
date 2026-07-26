import RelativeConicArcs.NinePointHeisenbergConicType9To11
import RelativeConicArcs.NinePointHeisenbergConicType12To14
import RelativeConicArcs.NinePointHeisenbergConicType15To17

/-! # Conic point types for normalized conics 10 through 18

This module combines three kernel-checked three-conic blocks by symbolic list decomposition.
-/
namespace RelativeConicArcs.NinePointHeisenbergConicType9To17
open NinePointHeisenbergConicCensus NinePointHeisenbergConicTable
/-- The discriminant and secant definitions agree on conics 10 through 18. -/
theorem discriminant_type_agrees_with_secants :
    ((conicTable.drop 9).take 9).all conicTypeAgreement = true := by
  simpa using all_take_nine_of_three (conicTable.drop 9) conicTypeAgreement
    NinePointHeisenbergConicType9To11.agreement
    NinePointHeisenbergConicType12To14.agreement
    NinePointHeisenbergConicType15To17.agreement
end RelativeConicArcs.NinePointHeisenbergConicType9To17
