import RelativeConicArcs.ClebschWittHadamard

/-!
# Punctured ternary code enumeration

This leaf exhaustively checks the complete length-eleven weight distribution and radius-two
sphere-packing equality in one native-evaluation pass.  Its terminals depend on
`Lean.ofReduceBool`.
-/

namespace RelativeConicArcs
namespace ClebschWittHadamard

private theorem checkedPuncturedCode :
    (let p := puncturedCodewords
     (∀ w : Fin 12, (p.filter fun v => puncturedWeight v = w).card =
       ![1, 0, 0, 0, 0, 132, 132, 0, 330, 110, 0, 24] w) ∧
       p.card = 729 ∧ 729 * (1 + 11 * 2 + 55 * 4) = 3 ^ 11) := by
  native_decide

/-- Complete weight distribution of the punctured perfect parameter code. -/
theorem punctured_weight_distribution :
    ∀ w : Fin 12,
      (puncturedCodewords.filter fun v => puncturedWeight v = w).card =
        ![1, 0, 0, 0, 0, 132, 132, 0, 330, 110, 0, 24] w :=
  checkedPuncturedCode.1

/-- The punctured `[11,6,5]` code attains the radius-two sphere-packing equality. -/
theorem punctured_perfect_parameter_identity :
    puncturedCodewords.card = 729 ∧
    729 * (1 + 11 * 2 + 55 * 4) = 3 ^ 11 :=
  checkedPuncturedCode.2

end ClebschWittHadamard
end RelativeConicArcs
