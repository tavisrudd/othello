import PassantCodeQ13.MinimumWords.RowUniqueness.IndexCertificate

/-!
# The local-extension certificate at the first indices congruent to two modulo seven

The passant-row search of `PassantCodeQ13.MinimumWords.RowUniqueness.IndexCertificate` is discharged
here, by kernel reduction, at each internal-point index whose residue modulo seven is two.  Each
index is checked in its own declaration, so the reduction of one index is complete before the next
begins.
-/

namespace PassantCodeQ13.MinimumWords.RowUniqueness

private theorem row_extension_at_2 : rowExtensionCheckAt 2 = true := by decide +kernel
private theorem row_extension_at_9 : rowExtensionCheckAt 9 = true := by decide +kernel
private theorem row_extension_at_16 : rowExtensionCheckAt 16 = true := by decide +kernel
private theorem row_extension_at_23 : rowExtensionCheckAt 23 = true := by decide +kernel
private theorem row_extension_at_30 : rowExtensionCheckAt 30 = true := by decide +kernel
private theorem row_extension_at_37 : rowExtensionCheckAt 37 = true := by decide +kernel
private theorem row_extension_at_44 : rowExtensionCheckAt 44 = true := by decide +kernel
private theorem row_extension_at_51 : rowExtensionCheckAt 51 = true := by decide +kernel
private theorem row_extension_at_58 : rowExtensionCheckAt 58 = true := by decide +kernel
private theorem row_extension_at_65 : rowExtensionCheckAt 65 = true := by decide +kernel
private theorem row_extension_at_72 : rowExtensionCheckAt 72 = true := by decide +kernel

/-- Local-extension transport at every first index congruent to two modulo seven. -/
theorem row_extension_residue_two (first : Nat) (mem : first ∈ residueIndices 2) :
    rowExtensionCheckAt first = true := by
  have listing : residueIndices 2 = [2, 9, 16, 23, 30, 37, 44, 51, 58, 65, 72] := by decide
  rw [listing] at mem
  simp only [List.mem_cons, List.not_mem_nil, or_false] at mem
  rcases mem with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact row_extension_at_2
  · exact row_extension_at_9
  · exact row_extension_at_16
  · exact row_extension_at_23
  · exact row_extension_at_30
  · exact row_extension_at_37
  · exact row_extension_at_44
  · exact row_extension_at_51
  · exact row_extension_at_58
  · exact row_extension_at_65
  · exact row_extension_at_72

end PassantCodeQ13.MinimumWords.RowUniqueness
