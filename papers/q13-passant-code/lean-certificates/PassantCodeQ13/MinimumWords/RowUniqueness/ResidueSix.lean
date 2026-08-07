import PassantCodeQ13.MinimumWords.RowUniqueness.IndexCertificate

/-!
# The local-extension certificate at the first indices congruent to six modulo seven

The passant-row search of `PassantCodeQ13.MinimumWords.RowUniqueness.IndexCertificate` is discharged
here, by kernel reduction, at each internal-point index whose residue modulo seven is six.  Each
index is checked in its own declaration, so the reduction of one index is complete before the next
begins.
-/

namespace PassantCodeQ13.MinimumWords.RowUniqueness

private theorem row_extension_at_6 : rowExtensionCheckAt 6 = true := by decide +kernel
private theorem row_extension_at_13 : rowExtensionCheckAt 13 = true := by decide +kernel
private theorem row_extension_at_20 : rowExtensionCheckAt 20 = true := by decide +kernel
private theorem row_extension_at_27 : rowExtensionCheckAt 27 = true := by decide +kernel
private theorem row_extension_at_34 : rowExtensionCheckAt 34 = true := by decide +kernel
private theorem row_extension_at_41 : rowExtensionCheckAt 41 = true := by decide +kernel
private theorem row_extension_at_48 : rowExtensionCheckAt 48 = true := by decide +kernel
private theorem row_extension_at_55 : rowExtensionCheckAt 55 = true := by decide +kernel
private theorem row_extension_at_62 : rowExtensionCheckAt 62 = true := by decide +kernel
private theorem row_extension_at_69 : rowExtensionCheckAt 69 = true := by decide +kernel
private theorem row_extension_at_76 : rowExtensionCheckAt 76 = true := by decide +kernel

/-- Local-extension transport at every first index congruent to six modulo seven. -/
theorem row_extension_residue_six (first : Nat) (mem : first ∈ residueIndices 6) :
    rowExtensionCheckAt first = true := by
  have listing : residueIndices 6 = [6, 13, 20, 27, 34, 41, 48, 55, 62, 69, 76] := by decide
  rw [listing] at mem
  simp only [List.mem_cons, List.not_mem_nil, or_false] at mem
  rcases mem with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact row_extension_at_6
  · exact row_extension_at_13
  · exact row_extension_at_20
  · exact row_extension_at_27
  · exact row_extension_at_34
  · exact row_extension_at_41
  · exact row_extension_at_48
  · exact row_extension_at_55
  · exact row_extension_at_62
  · exact row_extension_at_69
  · exact row_extension_at_76

end PassantCodeQ13.MinimumWords.RowUniqueness
