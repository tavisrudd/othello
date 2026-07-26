import RelativeConicArcs.NinePointHeisenbergConicType54To56
import RelativeConicArcs.NinePointHeisenbergConicType57To59
import RelativeConicArcs.NinePointHeisenbergConicType60To62

/-! # Conic point types for normalized conics 55 through 63

This module combines three kernel-checked three-conic blocks by symbolic list decomposition.
-/
namespace RelativeConicArcs.NinePointHeisenbergConicType54To62
open NinePointHeisenbergConicCensus NinePointHeisenbergConicTable
/-- The discriminant and secant definitions agree on conics 55 through 63. -/
theorem discriminant_type_agrees_with_secants :
    ((conicTable.drop 54).take 9).all conicTypeAgreement = true := by
  simpa using all_take_nine_of_three (conicTable.drop 54) conicTypeAgreement
    NinePointHeisenbergConicType54To56.agreement
    NinePointHeisenbergConicType57To59.agreement
    NinePointHeisenbergConicType60To62.agreement
end RelativeConicArcs.NinePointHeisenbergConicType54To62
