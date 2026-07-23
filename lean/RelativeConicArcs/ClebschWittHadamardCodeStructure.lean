import RelativeConicArcs.ClebschWittHadamard

/-!
# Parity extension and generator Gram checks

This leaf checks the parity-coordinate rule on all 729 coefficient vectors and transports it
symbolically through the image definition of the code.  It also checks the six-by-six generator
Gram matrix.  In the pinned toolchain the finite coefficient and Gram terminal exposes a
declaration-local `_native.native_decide.ax_1_1` dependency.
-/

namespace RelativeConicArcs
namespace ClebschWittHadamard

private theorem checkedCodeStructure :
    (∀ a : Fin 6 → F3, codeword a 11 = -∑ i : Fin 11, codeword a i.castSucc) ∧
    ∀ i j : Fin 6, (∑ k, generatorMatrix i k * generatorMatrix j k) = 0 := by
  native_decide

/-- The twelfth coordinate is the parity extension of the first eleven. -/
theorem parity_extension_rule :
    ∀ v ∈ codewords, v 11 = -∑ i : Fin 11, v i.castSucc := by
  intro v hv
  rcases Finset.mem_image.mp hv with ⟨a, _, rfl⟩
  exact checkedCodeStructure.1 a

/-- The six displayed generator rows are pairwise orthogonal. -/
theorem generator_gram_zero :
    ∀ i j : Fin 6, (∑ k, generatorMatrix i k * generatorMatrix j k) = 0 :=
  checkedCodeStructure.2

end ClebschWittHadamard
end RelativeConicArcs
