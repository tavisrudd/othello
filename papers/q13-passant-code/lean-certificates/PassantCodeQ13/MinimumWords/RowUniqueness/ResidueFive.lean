import PassantCodeQ13.MinimumWords.RowUniqueness.IndexCertificate

/-!
# The local-extension certificate at the first indices congruent to five modulo seven

The passant-row search of `PassantCodeQ13.MinimumWords.RowUniqueness.IndexCertificate` is discharged
here, by kernel reduction, at each internal-point index whose residue modulo seven is five.  Each
index is checked in its own declaration, so the reduction of one index is complete before the next
begins.
-/

namespace PassantCodeQ13.MinimumWords.RowUniqueness

private theorem row_extension_at_5 : rowExtensionCheckAt 5 = true := by decide +kernel
private theorem row_extension_at_12 : rowExtensionCheckAt 12 = true := by decide +kernel
private theorem row_extension_at_19 : rowExtensionCheckAt 19 = true := by decide +kernel
private theorem row_extension_at_26 : rowExtensionCheckAt 26 = true := by decide +kernel
private theorem row_extension_at_33 : rowExtensionCheckAt 33 = true := by decide +kernel
private theorem row_extension_at_40 : rowExtensionCheckAt 40 = true := by decide +kernel
private theorem row_extension_at_47 : rowExtensionCheckAt 47 = true := by decide +kernel
private theorem row_extension_at_54 : rowExtensionCheckAt 54 = true := by decide +kernel
private theorem row_extension_at_61 : rowExtensionCheckAt 61 = true := by decide +kernel
private theorem row_extension_at_68 : rowExtensionCheckAt 68 = true := by decide +kernel
private theorem row_extension_at_75 : rowExtensionCheckAt 75 = true := by decide +kernel

/-- Local-extension transport at every first index congruent to five modulo seven. -/
theorem row_extension_residue_five (first : Nat) (mem : first ∈ residueIndices 5) :
    rowExtensionCheckAt first = true := by
  have listing : residueIndices 5 = [5, 12, 19, 26, 33, 40, 47, 54, 61, 68, 75] := by decide
  rw [listing] at mem
  simp only [List.mem_cons, List.not_mem_nil, or_false] at mem
  rcases mem with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact row_extension_at_5
  · exact row_extension_at_12
  · exact row_extension_at_19
  · exact row_extension_at_26
  · exact row_extension_at_33
  · exact row_extension_at_40
  · exact row_extension_at_47
  · exact row_extension_at_54
  · exact row_extension_at_61
  · exact row_extension_at_68
  · exact row_extension_at_75

end PassantCodeQ13.MinimumWords.RowUniqueness
