import PassantCodeQ13.MinimumWords.RowUniqueness.IndexCertificate

/-!
# The local-extension certificate at the first indices congruent to four modulo seven

The passant-row search of `PassantCodeQ13.MinimumWords.RowUniqueness.IndexCertificate` is discharged
here, by kernel reduction, at each internal-point index whose residue modulo seven is four.  Each
index is checked in its own declaration, so the reduction of one index is complete before the next
begins.
-/

namespace PassantCodeQ13.MinimumWords.RowUniqueness

private theorem row_extension_at_4 : rowExtensionCheckAt 4 = true := by decide +kernel
private theorem row_extension_at_11 : rowExtensionCheckAt 11 = true := by decide +kernel
private theorem row_extension_at_18 : rowExtensionCheckAt 18 = true := by decide +kernel
private theorem row_extension_at_25 : rowExtensionCheckAt 25 = true := by decide +kernel
private theorem row_extension_at_32 : rowExtensionCheckAt 32 = true := by decide +kernel
private theorem row_extension_at_39 : rowExtensionCheckAt 39 = true := by decide +kernel
private theorem row_extension_at_46 : rowExtensionCheckAt 46 = true := by decide +kernel
private theorem row_extension_at_53 : rowExtensionCheckAt 53 = true := by decide +kernel
private theorem row_extension_at_60 : rowExtensionCheckAt 60 = true := by decide +kernel
private theorem row_extension_at_67 : rowExtensionCheckAt 67 = true := by decide +kernel
private theorem row_extension_at_74 : rowExtensionCheckAt 74 = true := by decide +kernel

/-- Local-extension transport at every first index congruent to four modulo seven. -/
theorem row_extension_residue_four (first : Nat) (mem : first ∈ residueIndices 4) :
    rowExtensionCheckAt first = true := by
  have listing : residueIndices 4 = [4, 11, 18, 25, 32, 39, 46, 53, 60, 67, 74] := by decide
  rw [listing] at mem
  simp only [List.mem_cons, List.not_mem_nil, or_false] at mem
  rcases mem with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact row_extension_at_4
  · exact row_extension_at_11
  · exact row_extension_at_18
  · exact row_extension_at_25
  · exact row_extension_at_32
  · exact row_extension_at_39
  · exact row_extension_at_46
  · exact row_extension_at_53
  · exact row_extension_at_60
  · exact row_extension_at_67
  · exact row_extension_at_74

end PassantCodeQ13.MinimumWords.RowUniqueness
