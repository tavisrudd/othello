import RelativeConicArcs.NinePointHeisenbergConicTypeTable

/-!
# Secant interpretation of conic point types: middle conic block

The complete table check and its exhaustive coverage theorem imply this middle-block statement
symbolically.
-/

namespace RelativeConicArcs
namespace NinePointHeisenbergConicTypeMiddle

open NinePointHeisenbergConicCensus

/-- The discriminant and secant definitions agree on conics 28 through 54. -/
theorem discriminant_type_agrees_with_secants :
    ((distinctConics.drop 27).take 27).all conicTypeAgreement = true := by
  have full := NinePointHeisenbergConicTypeTable.distinctConics_type_agreement
  simp only [List.all_eq_true] at full ⊢
  intro coefficients coefficients_mem
  have in_drop : coefficients ∈ distinctConics.drop 27 :=
    List.Sublist.mem coefficients_mem (List.take_sublist 27 (distinctConics.drop 27))
  exact full
    coefficients (List.Sublist.mem in_drop (List.drop_sublist 27 distinctConics))

end NinePointHeisenbergConicTypeMiddle
end RelativeConicArcs
