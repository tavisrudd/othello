import RelativeConicArcs.NinePointHeisenbergConicType45To47
import RelativeConicArcs.NinePointHeisenbergConicType48To50
import RelativeConicArcs.NinePointHeisenbergConicType51To53

/-! # Conic point types for normalized conics 46 through 54

This module combines three kernel-checked three-conic blocks by symbolic list decomposition.
-/
namespace RelativeConicArcs.NinePointHeisenbergConicType45To53
open NinePointHeisenbergConicCensus NinePointHeisenbergConicTable
/-- The discriminant and secant definitions agree on conics 46 through 54. -/
theorem discriminant_type_agrees_with_secants :
    ((conicTable.drop 45).take 9).all conicTypeAgreement = true := by
  simpa using all_take_nine_of_three (conicTable.drop 45) conicTypeAgreement
    NinePointHeisenbergConicType45To47.agreement
    NinePointHeisenbergConicType48To50.agreement
    NinePointHeisenbergConicType51To53.agreement
end RelativeConicArcs.NinePointHeisenbergConicType45To53
