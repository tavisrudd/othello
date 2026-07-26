import RelativeConicArcs.NinePointHeisenbergConicType72To74
import RelativeConicArcs.NinePointHeisenbergConicType75To77
import RelativeConicArcs.NinePointHeisenbergConicType78To80

/-! # Conic point types for normalized conics 73 through 81

This module combines three kernel-checked three-conic blocks by symbolic list decomposition.
-/
namespace RelativeConicArcs.NinePointHeisenbergConicType72To80
open NinePointHeisenbergConicCensus NinePointHeisenbergConicTable
/-- The discriminant and secant definitions agree on conics 73 through 81. -/
theorem discriminant_type_agrees_with_secants :
    (conicTable.drop 72).all conicTypeAgreement = true := by
  have tail := all_of_take_and_drop (conicTable.drop 75) conicTypeAgreement 3
    NinePointHeisenbergConicType75To77.agreement
    NinePointHeisenbergConicType78To80.agreement
  exact all_of_take_and_drop (conicTable.drop 72) conicTypeAgreement 3
    NinePointHeisenbergConicType72To74.agreement tail
end RelativeConicArcs.NinePointHeisenbergConicType72To80
