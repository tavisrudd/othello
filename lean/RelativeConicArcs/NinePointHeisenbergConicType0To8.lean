import RelativeConicArcs.NinePointHeisenbergConicType0To2
import RelativeConicArcs.NinePointHeisenbergConicType3To5
import RelativeConicArcs.NinePointHeisenbergConicType6To8

/-! # Conic point types for normalized conics 1 through 9

This module combines three kernel-checked three-conic blocks by symbolic list decomposition.
-/
namespace RelativeConicArcs.NinePointHeisenbergConicType0To8
open NinePointHeisenbergConicCensus NinePointHeisenbergConicTable
/-- The discriminant and secant definitions agree on conics 1 through 9. -/
theorem discriminant_type_agrees_with_secants :
    (conicTable.take 9).all conicTypeAgreement = true := by
  exact all_take_nine_of_three conicTable conicTypeAgreement
    NinePointHeisenbergConicType0To2.agreement
    NinePointHeisenbergConicType3To5.agreement
    NinePointHeisenbergConicType6To8.agreement
end RelativeConicArcs.NinePointHeisenbergConicType0To8
