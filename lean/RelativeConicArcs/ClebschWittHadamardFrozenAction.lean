import RelativeConicArcs.ClebschWittHadamard

/-!
# Frozen coordinate and full-support actions

This leaf checks the displayed permutation data, the frozen coordinate action through an explicit
coefficient-vector evaluator, and the induced `1+11` action on full-support projective words.  The
finite evaluator depends on `Lean.ofReduceBool`; code preservation is transported symbolically
from coefficient vectors to the image-defined code.
-/

namespace RelativeConicArcs
namespace ClebschWittHadamard

/-- Coefficients of a frozen-generator image, read from the systematic first six coordinates. -/
def frozenCoefficientAction (g : Fin 2) (a : Fin 6 → F3) : Fin 6 → F3 :=
  fun i => permuteWord (frozenGenerators g) (codeword a) ⟨i.val, by omega⟩

private theorem checkedFrozenPermutations :
    ((∀ g : Fin 2, isPermutation (frozenGenerators g) = true) ∧
      ∀ g : Fin 2, isPermutation (frozenRowGenerators g) = true) := by
  native_decide

private theorem checkedFrozenCoefficientAction :
    ∀ g : Fin 2, ∀ a : Fin 6 → F3,
      permuteWord (frozenGenerators g) (codeword a) =
        codeword (frozenCoefficientAction g a) := by
  native_decide

private theorem checkedFrozenCoordinateOrbits :
    (∀ g : Fin 2, frozenGenerators g 11 = 11) ∧
      pointOrbit frozenGenerators 11 = {11} ∧
      pointOrbit frozenGenerators 0 = Finset.univ.erase 11 := by
  native_decide

private theorem checkedFrozenFullSupport :
    (∀ g : Fin 2, ∀ i : Fin 12,
      projectivePair (permuteWord (frozenGenerators g) (hadamardWord i)) =
        projectivePair (hadamardWord (frozenRowGenerators g i))) ∧
      pointOrbit frozenRowGenerators 0 = {0} ∧
      pointOrbit frozenRowGenerators 1 = Finset.univ.erase 0 := by
  native_decide

/-- The frozen coordinate and row maps are literal permutations. -/
theorem frozen_maps_are_permutations :
    (∀ g : Fin 2, isPermutation (frozenGenerators g) = true) ∧
    ∀ g : Fin 2, isPermutation (frozenRowGenerators g) = true :=
  checkedFrozenPermutations

/-- The frozen generators preserve the code and act on coordinates with orbit sizes `1+11`. -/
theorem frozen_action_literal_checks :
    (∀ g : Fin 2, ∀ v ∈ codewords, permuteWord (frozenGenerators g) v ∈ codewords) ∧
    (∀ g : Fin 2, frozenGenerators g 11 = 11) ∧
    pointOrbit frozenGenerators 11 = {11} ∧
    pointOrbit frozenGenerators 0 = Finset.univ.erase 11 := by
  refine ⟨?_, checkedFrozenCoordinateOrbits⟩
  intro g v hv
  rcases Finset.mem_image.mp hv with ⟨a, _, rfl⟩
  rw [checkedFrozenCoefficientAction g a]
  exact Finset.mem_image.mpr ⟨frozenCoefficientAction g a, Finset.mem_univ _, rfl⟩

/-- The frozen action on projective full-support words has orbit decomposition `1+11`. -/
theorem frozen_fullSupport_action :
    (∀ g : Fin 2, ∀ i : Fin 12,
      projectivePair (permuteWord (frozenGenerators g) (hadamardWord i)) =
        projectivePair (hadamardWord (frozenRowGenerators g i))) ∧
    pointOrbit frozenRowGenerators 0 = {0} ∧
    pointOrbit frozenRowGenerators 1 = Finset.univ.erase 0 :=
  checkedFrozenFullSupport

end ClebschWittHadamard
end RelativeConicArcs
