import RelativeConicArcs.NinePointHeisenbergConicType63To65
import RelativeConicArcs.NinePointHeisenbergConicType66To68
import RelativeConicArcs.NinePointHeisenbergConicType69To71

/-! # Conic point types for normalized conics 64 through 72

This module combines three kernel-checked three-conic blocks by symbolic list decomposition.
-/
namespace RelativeConicArcs.NinePointHeisenbergConicType63To71
open NinePointHeisenbergConicCensus NinePointHeisenbergConicTable
/-- The discriminant and secant definitions agree on conics 64 through 72. -/
theorem discriminant_type_agrees_with_secants :
    ((conicTable.drop 63).take 9).all conicTypeAgreement = true := by
  simpa using all_take_nine_of_three (conicTable.drop 63) conicTypeAgreement
    NinePointHeisenbergConicType63To65.agreement
    NinePointHeisenbergConicType66To68.agreement
    NinePointHeisenbergConicType69To71.agreement
end RelativeConicArcs.NinePointHeisenbergConicType63To71
