import RelativeConicArcs.NinePointHeisenbergConicTypeTable

/-!
# Secant interpretation of conic point types: last conic block

The complete table check and its exhaustive coverage theorem imply this suffix statement
symbolically.
-/

namespace RelativeConicArcs
namespace NinePointHeisenbergConicTypeHigh

open NinePointHeisenbergConicCensus

/-- The discriminant and secant definitions agree on the last 27 conics. -/
theorem discriminant_type_agrees_with_secants :
    (distinctConics.drop 54).all conicTypeAgreement = true := by
  have full := NinePointHeisenbergConicTypeTable.distinctConics_type_agreement
  simp only [List.all_eq_true] at full ⊢
  intro coefficients coefficients_mem
  exact full
    coefficients (List.Sublist.mem coefficients_mem (List.drop_sublist 54 distinctConics))

end NinePointHeisenbergConicTypeHigh
end RelativeConicArcs
