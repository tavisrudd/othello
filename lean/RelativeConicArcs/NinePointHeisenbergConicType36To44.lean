import RelativeConicArcs.NinePointHeisenbergConicType36To38
import RelativeConicArcs.NinePointHeisenbergConicType39To41
import RelativeConicArcs.NinePointHeisenbergConicType42To44

/-! # Conic point types for normalized conics 37 through 45

This module combines three kernel-checked three-conic blocks by symbolic list decomposition.
-/
namespace RelativeConicArcs.NinePointHeisenbergConicType36To44
open NinePointHeisenbergConicCensus NinePointHeisenbergConicTable
/-- The discriminant and secant definitions agree on conics 37 through 45. -/
theorem discriminant_type_agrees_with_secants :
    ((conicTable.drop 36).take 9).all conicTypeAgreement = true := by
  simpa using all_take_nine_of_three (conicTable.drop 36) conicTypeAgreement
    NinePointHeisenbergConicType36To38.agreement
    NinePointHeisenbergConicType39To41.agreement
    NinePointHeisenbergConicType42To44.agreement
end RelativeConicArcs.NinePointHeisenbergConicType36To44
