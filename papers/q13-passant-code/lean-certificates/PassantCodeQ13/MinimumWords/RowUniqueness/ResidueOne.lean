import PassantCodeQ13.MinimumWords.RowUniqueness.IndexCertificate

/-!
# The local-extension certificate at the first indices congruent to one modulo seven

The passant-row search of `PassantCodeQ13.MinimumWords.RowUniqueness.IndexCertificate` is discharged
here, by kernel reduction, at each internal-point index whose residue modulo seven is one.  Each
index is checked in its own declaration, so the reduction of one index is complete before the next
begins.
-/

namespace PassantCodeQ13.MinimumWords.RowUniqueness

private theorem row_extension_at_1 : rowExtensionCheckAt 1 = true := by decide +kernel
private theorem row_extension_at_8 : rowExtensionCheckAt 8 = true := by decide +kernel
private theorem row_extension_at_15 : rowExtensionCheckAt 15 = true := by decide +kernel
private theorem row_extension_at_22 : rowExtensionCheckAt 22 = true := by decide +kernel
private theorem row_extension_at_29 : rowExtensionCheckAt 29 = true := by decide +kernel
private theorem row_extension_at_36 : rowExtensionCheckAt 36 = true := by decide +kernel
private theorem row_extension_at_43 : rowExtensionCheckAt 43 = true := by decide +kernel
private theorem row_extension_at_50 : rowExtensionCheckAt 50 = true := by decide +kernel
private theorem row_extension_at_57 : rowExtensionCheckAt 57 = true := by decide +kernel
private theorem row_extension_at_64 : rowExtensionCheckAt 64 = true := by decide +kernel
private theorem row_extension_at_71 : rowExtensionCheckAt 71 = true := by decide +kernel

/-- Local-extension transport at every first index congruent to one modulo seven. -/
theorem row_extension_residue_one (first : Nat) (mem : first ∈ residueIndices 1) :
    rowExtensionCheckAt first = true := by
  have listing : residueIndices 1 = [1, 8, 15, 22, 29, 36, 43, 50, 57, 64, 71] := by decide
  rw [listing] at mem
  simp only [List.mem_cons, List.not_mem_nil, or_false] at mem
  rcases mem with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact row_extension_at_1
  · exact row_extension_at_8
  · exact row_extension_at_15
  · exact row_extension_at_22
  · exact row_extension_at_29
  · exact row_extension_at_36
  · exact row_extension_at_43
  · exact row_extension_at_50
  · exact row_extension_at_57
  · exact row_extension_at_64
  · exact row_extension_at_71

end PassantCodeQ13.MinimumWords.RowUniqueness
