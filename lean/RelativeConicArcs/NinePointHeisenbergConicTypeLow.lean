import RelativeConicArcs.NinePointHeisenbergConicTypeTable

/-!
# Secant interpretation of conic point types: first conic block

The complete table check and its exhaustive coverage theorem imply this prefix statement
symbolically.
-/

namespace RelativeConicArcs
namespace NinePointHeisenbergConicTypeLow

open NinePointHeisenbergConicCensus

/-- The discriminant and secant definitions agree on the first 27 conics. -/
theorem discriminant_type_agrees_with_secants :
    (distinctConics.take 27).all conicTypeAgreement = true := by
  have full := NinePointHeisenbergConicTypeTable.distinctConics_type_agreement
  simp only [List.all_eq_true] at full ⊢
  intro coefficients coefficients_mem
  exact full
    coefficients (List.Sublist.mem coefficients_mem (List.take_sublist 27 distinctConics))

end NinePointHeisenbergConicTypeLow
end RelativeConicArcs
