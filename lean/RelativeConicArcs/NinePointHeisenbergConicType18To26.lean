import RelativeConicArcs.NinePointHeisenbergConicType18To20
import RelativeConicArcs.NinePointHeisenbergConicType21To23
import RelativeConicArcs.NinePointHeisenbergConicType24To26

/-! # Conic point types for normalized conics 19 through 27

This module combines three kernel-checked three-conic blocks by symbolic list decomposition.
-/
namespace RelativeConicArcs.NinePointHeisenbergConicType18To26
open NinePointHeisenbergConicCensus NinePointHeisenbergConicTable
/-- The discriminant and secant definitions agree on conics 19 through 27. -/
theorem discriminant_type_agrees_with_secants :
    ((conicTable.drop 18).take 9).all conicTypeAgreement = true := by
  simpa using all_take_nine_of_three (conicTable.drop 18) conicTypeAgreement
    NinePointHeisenbergConicType18To20.agreement
    NinePointHeisenbergConicType21To23.agreement
    NinePointHeisenbergConicType24To26.agreement
end RelativeConicArcs.NinePointHeisenbergConicType18To26
