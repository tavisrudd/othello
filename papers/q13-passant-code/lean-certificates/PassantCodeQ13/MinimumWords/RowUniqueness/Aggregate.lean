import PassantCodeQ13.MinimumWords.RowUniqueness.ResidueZero
import PassantCodeQ13.MinimumWords.RowUniqueness.ResidueOne
import PassantCodeQ13.MinimumWords.RowUniqueness.ResidueTwo
import PassantCodeQ13.MinimumWords.RowUniqueness.ResidueThree
import PassantCodeQ13.MinimumWords.RowUniqueness.ResidueFour
import PassantCodeQ13.MinimumWords.RowUniqueness.ResidueFive
import PassantCodeQ13.MinimumWords.RowUniqueness.ResidueSix

/-!
# The local-extension certificate at every first index

The seven residue classes modulo seven partition the internal-point indices, so the seven kernel
certificates cover every displayed first index.  This module combines them and performs no
computation of its own.
-/

namespace PassantCodeQ13.MinimumWords.RowUniqueness

/-- Every displayed first index passes the exhaustive local-extension check. -/
theorem row_extension_check_all_indices (first : Nat) (bounded : first < 78) :
    rowExtensionCheckAt first = true := by
  have mem := mem_residueIndices bounded
  have residue : first % 7 = 0 ∨ first % 7 = 1 ∨ first % 7 = 2 ∨ first % 7 = 3 ∨
      first % 7 = 4 ∨ first % 7 = 5 ∨ first % 7 = 6 := by omega
  rcases residue with value | value | value | value | value | value | value
  · exact row_extension_residue_zero first (value ▸ mem)
  · exact row_extension_residue_one first (value ▸ mem)
  · exact row_extension_residue_two first (value ▸ mem)
  · exact row_extension_residue_three first (value ▸ mem)
  · exact row_extension_residue_four first (value ▸ mem)
  · exact row_extension_residue_five first (value ▸ mem)
  · exact row_extension_residue_six first (value ▸ mem)

end PassantCodeQ13.MinimumWords.RowUniqueness
