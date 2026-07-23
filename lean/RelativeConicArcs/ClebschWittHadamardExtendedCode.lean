import RelativeConicArcs.ClebschWittHadamard

/-!
# Extended ternary code enumeration

This leaf exhaustively checks the 729-word cardinality and complete length-twelve weight
distribution in one native-evaluation pass.  In the pinned toolchain its terminals expose
declaration-local `_native.native_decide.ax_1_1` dependencies.
-/

namespace RelativeConicArcs
namespace ClebschWittHadamard

private theorem checkedExtendedCode :
    (let c := codewords
     c.card = 729 ∧
       ∀ w : Fin 13, (c.filter fun v => weight v = w).card =
         ![1, 0, 0, 0, 0, 0, 264, 0, 0, 440, 0, 0, 24] w) := by
  native_decide

/-- The code has exactly 729 words. -/
theorem code_card : codewords.card = 729 := checkedExtendedCode.1

/-- Complete weight distribution of the extended ternary code. -/
theorem code_weight_distribution :
    ∀ w : Fin 13,
      (codewords.filter fun v => weight v = w).card =
        ![1, 0, 0, 0, 0, 0, 264, 0, 0, 440, 0, 0, 24] w :=
  checkedExtendedCode.2

end ClebschWittHadamard
end RelativeConicArcs
