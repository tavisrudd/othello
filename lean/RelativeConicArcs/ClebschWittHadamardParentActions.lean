import RelativeConicArcs.ClebschWittHadamard

/-!
# Parent actions on the Steiner support design

This leaf checks that both displayed parent generator pairs preserve all 132 minimum supports and
checks their transitive/fixed-point discriminator.  The support check uses native evaluation and
depends on `Lean.ofReduceBool`; the two twelve-point orbit equalities use kernel reduction.
-/

namespace RelativeConicArcs
namespace ClebschWittHadamard

/-- Both parent generator pairs preserve the minimum-support design. -/
theorem parent_generators_preserve_hexads :
    (∀ g : Fin 2, ∀ h ∈ hexads,
      permuteSupport (transitiveParentGenerators g) h ∈ hexads) ∧
    (∀ g : Fin 2, ∀ h ∈ hexads,
      permuteSupport (fixedPointParentGenerators g) h ∈ hexads) := by
  native_decide

/-- The first parent is transitive, while the second fixes coordinate eleven. -/
theorem parent_action_discriminator :
    pointOrbit transitiveParentGenerators 0 = Finset.univ ∧
    pointOrbit fixedPointParentGenerators 11 = {11} := by
  constructor
  · ext i
    fin_cases i <;> decide
  · ext i
    fin_cases i <;> decide

end ClebschWittHadamard
end RelativeConicArcs
