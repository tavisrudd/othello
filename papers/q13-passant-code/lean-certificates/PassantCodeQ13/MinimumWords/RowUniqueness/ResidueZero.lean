import PassantCodeQ13.MinimumWords.RowUniqueness.IndexCertificate

/-!
# The local-extension certificate at the first indices congruent to zero modulo seven

The passant-row search of `PassantCodeQ13.MinimumWords.RowUniqueness.IndexCertificate` is discharged
here, by kernel reduction, at each internal-point index whose residue modulo seven is zero.  Each
index is checked in its own declaration, so the reduction of one index is complete before the next
begins.
-/

namespace PassantCodeQ13.MinimumWords.RowUniqueness

private theorem row_extension_at_0 : rowExtensionCheckAt 0 = true := by decide +kernel
private theorem row_extension_at_7 : rowExtensionCheckAt 7 = true := by decide +kernel
private theorem row_extension_at_14 : rowExtensionCheckAt 14 = true := by decide +kernel
private theorem row_extension_at_21 : rowExtensionCheckAt 21 = true := by decide +kernel
private theorem row_extension_at_28 : rowExtensionCheckAt 28 = true := by decide +kernel
private theorem row_extension_at_35 : rowExtensionCheckAt 35 = true := by decide +kernel
private theorem row_extension_at_42 : rowExtensionCheckAt 42 = true := by decide +kernel
private theorem row_extension_at_49 : rowExtensionCheckAt 49 = true := by decide +kernel
private theorem row_extension_at_56 : rowExtensionCheckAt 56 = true := by decide +kernel
private theorem row_extension_at_63 : rowExtensionCheckAt 63 = true := by decide +kernel
private theorem row_extension_at_70 : rowExtensionCheckAt 70 = true := by decide +kernel
private theorem row_extension_at_77 : rowExtensionCheckAt 77 = true := by decide +kernel

/-- Local-extension transport at every first index congruent to zero modulo seven. -/
theorem row_extension_residue_zero (first : Nat) (mem : first ∈ residueIndices 0) :
    rowExtensionCheckAt first = true := by
  have listing : residueIndices 0 = [0, 7, 14, 21, 28, 35, 42, 49, 56, 63, 70, 77] := by decide
  rw [listing] at mem
  simp only [List.mem_cons, List.not_mem_nil, or_false] at mem
  rcases mem with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact row_extension_at_0
  · exact row_extension_at_7
  · exact row_extension_at_14
  · exact row_extension_at_21
  · exact row_extension_at_28
  · exact row_extension_at_35
  · exact row_extension_at_42
  · exact row_extension_at_49
  · exact row_extension_at_56
  · exact row_extension_at_63
  · exact row_extension_at_70
  · exact row_extension_at_77

end PassantCodeQ13.MinimumWords.RowUniqueness
