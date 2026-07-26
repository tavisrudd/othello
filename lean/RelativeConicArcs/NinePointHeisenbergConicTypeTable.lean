import RelativeConicArcs.NinePointHeisenbergConicType0To8
import RelativeConicArcs.NinePointHeisenbergConicType9To17
import RelativeConicArcs.NinePointHeisenbergConicType18To26
import RelativeConicArcs.NinePointHeisenbergConicType27To35
import RelativeConicArcs.NinePointHeisenbergConicType36To44
import RelativeConicArcs.NinePointHeisenbergConicType45To53
import RelativeConicArcs.NinePointHeisenbergConicType54To62
import RelativeConicArcs.NinePointHeisenbergConicType63To71
import RelativeConicArcs.NinePointHeisenbergConicType72To80

/-!
# Secant interpretation on the complete conic census

The bounded table slices are combined symbolically, then the kernel-checked coverage theorem
transports the result to every distinct conic constructed from a five-subset.
-/

namespace RelativeConicArcs
namespace NinePointHeisenbergConicTypeTable

open NinePointHeisenbergConicCensus NinePointHeisenbergConicTable

/-- The discriminant and rational-secant point types agree on all 81 table entries. -/
theorem conicTable_type_agreement :
    conicTable.all conicTypeAgreement = true := by
  have h72 := NinePointHeisenbergConicType72To80.discriminant_type_agrees_with_secants
  have h63 := all_of_take_and_drop (conicTable.drop 63) conicTypeAgreement 9
    NinePointHeisenbergConicType63To71.discriminant_type_agrees_with_secants h72
  have h54 := all_of_take_and_drop (conicTable.drop 54) conicTypeAgreement 9
    NinePointHeisenbergConicType54To62.discriminant_type_agrees_with_secants h63
  have h45 := all_of_take_and_drop (conicTable.drop 45) conicTypeAgreement 9
    NinePointHeisenbergConicType45To53.discriminant_type_agrees_with_secants h54
  have h36 := all_of_take_and_drop (conicTable.drop 36) conicTypeAgreement 9
    NinePointHeisenbergConicType36To44.discriminant_type_agrees_with_secants h45
  have h27 := all_of_take_and_drop (conicTable.drop 27) conicTypeAgreement 9
    NinePointHeisenbergConicType27To35.discriminant_type_agrees_with_secants h36
  have h18 := all_of_take_and_drop (conicTable.drop 18) conicTypeAgreement 9
    NinePointHeisenbergConicType18To26.discriminant_type_agrees_with_secants h27
  have h9 := all_of_take_and_drop (conicTable.drop 9) conicTypeAgreement 9
    NinePointHeisenbergConicType9To17.discriminant_type_agrees_with_secants h18
  exact all_of_take_and_drop conicTable conicTypeAgreement 9
    NinePointHeisenbergConicType0To8.discriminant_type_agrees_with_secants h9

/-- The discriminant and rational-secant point types agree on every constructed distinct conic. -/
theorem distinctConics_type_agreement :
    distinctConics.all conicTypeAgreement = true :=
  all_distinctConics_of_all_conicTable conicTypeAgreement conicTable_type_agreement

end NinePointHeisenbergConicTypeTable
end RelativeConicArcs
