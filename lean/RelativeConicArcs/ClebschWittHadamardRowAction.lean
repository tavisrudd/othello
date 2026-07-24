import RelativeConicArcs.ClebschWittHadamardFrozenAction

/-!
# Signed row/column generator action

This leaf checks the displayed coordinate, row, carrier, and square-conjugator permutations and
the signed action of both design generators on all twelve Hadamard rows.  In the pinned toolchain
its native-evaluation terminals expose declaration-local `_native.native_decide.ax_1_1`
dependencies.
-/

namespace RelativeConicArcs
namespace ClebschWittHadamard

/-- Every displayed non-frozen action map is a literal permutation. -/
theorem displayed_nonfrozen_maps_are_permutations :
    (∀ g : Fin 2, isPermutation (transitiveParentGenerators g) = true) ∧
    (∀ g : Fin 2, isPermutation (fixedPointParentGenerators g) = true) ∧
    (∀ g : Fin 2, isPermutation (designGenerators g) = true) ∧
    (∀ g : Fin 2, isPermutation (rowGenerators g) = true) ∧
    isPermutation rowCarrierRelabelling = true ∧
    isPermutation rowCarrierRelabellingInverse = true ∧
    isPermutation dualitySquareConjugator = true := by
  native_decide

/-- Every displayed generator and carrier map is a literal permutation. -/
theorem displayed_maps_are_permutations :
    (∀ g : Fin 2, isPermutation (frozenGenerators g) = true) ∧
    (∀ g : Fin 2, isPermutation (frozenRowGenerators g) = true) ∧
    (∀ g : Fin 2, isPermutation (transitiveParentGenerators g) = true) ∧
    (∀ g : Fin 2, isPermutation (fixedPointParentGenerators g) = true) ∧
    (∀ g : Fin 2, isPermutation (designGenerators g) = true) ∧
    (∀ g : Fin 2, isPermutation (rowGenerators g) = true) ∧
    isPermutation rowCarrierRelabelling = true ∧
    isPermutation rowCarrierRelabellingInverse = true ∧
    isPermutation dualitySquareConjugator = true :=
  ⟨frozen_maps_are_permutations.1, frozen_maps_are_permutations.2,
    displayed_nonfrozen_maps_are_permutations⟩

/-- The two displayed carrier relabellings are two-sided inverses on all twelve points. -/
theorem rowCarrierRelabelling_twoSidedInverse :
    (∀ i : Fin 12,
      rowCarrierRelabellingInverse (rowCarrierRelabelling i) = i) ∧
    (∀ i : Fin 12,
      rowCarrierRelabelling (rowCarrierRelabellingInverse i) = i) := by
  native_decide

/-- Each design generator carries sign rows to sign rows, up to a row-dependent scalar sign. -/
theorem row_column_hinge :
    ∀ g : Fin 2, ∀ i : Fin 12,
      projectivePair (signedPermuteWord (designGenerators g) (designGeneratorSigns g)
        (hadamardWord i)) =
      projectivePair (hadamardWord (rowGenerators g i)) := by
  native_decide

end ClebschWittHadamard
end RelativeConicArcs
