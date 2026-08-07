import PassantCodeQ13.MinimumWords.RowUniqueness.IndexCertificate

/-!
# The local-extension certificate at the first indices congruent to three modulo seven

The passant-row search of `PassantCodeQ13.MinimumWords.RowUniqueness.IndexCertificate` is discharged
here, by kernel reduction, at each internal-point index whose residue modulo seven is three.  Each
index is checked in its own declaration, so the reduction of one index is complete before the next
begins.
-/

namespace PassantCodeQ13.MinimumWords.RowUniqueness

private theorem row_extension_at_3 : rowExtensionCheckAt 3 = true := by decide +kernel
private theorem row_extension_at_10 : rowExtensionCheckAt 10 = true := by decide +kernel
private theorem row_extension_at_17 : rowExtensionCheckAt 17 = true := by decide +kernel
private theorem row_extension_at_24 : rowExtensionCheckAt 24 = true := by decide +kernel
private theorem row_extension_at_31 : rowExtensionCheckAt 31 = true := by decide +kernel
private theorem row_extension_at_38 : rowExtensionCheckAt 38 = true := by decide +kernel
private theorem row_extension_at_45 : rowExtensionCheckAt 45 = true := by decide +kernel
private theorem row_extension_at_52 : rowExtensionCheckAt 52 = true := by decide +kernel
private theorem row_extension_at_59 : rowExtensionCheckAt 59 = true := by decide +kernel
private theorem row_extension_at_66 : rowExtensionCheckAt 66 = true := by decide +kernel
private theorem row_extension_at_73 : rowExtensionCheckAt 73 = true := by decide +kernel

/-- Local-extension transport at every first index congruent to three modulo seven. -/
theorem row_extension_residue_three (first : Nat) (mem : first ∈ residueIndices 3) :
    rowExtensionCheckAt first = true := by
  have listing : residueIndices 3 = [3, 10, 17, 24, 31, 38, 45, 52, 59, 66, 73] := by decide
  rw [listing] at mem
  simp only [List.mem_cons, List.not_mem_nil, or_false] at mem
  rcases mem with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact row_extension_at_3
  · exact row_extension_at_10
  · exact row_extension_at_17
  · exact row_extension_at_24
  · exact row_extension_at_31
  · exact row_extension_at_38
  · exact row_extension_at_45
  · exact row_extension_at_52
  · exact row_extension_at_59
  · exact row_extension_at_66
  · exact row_extension_at_73

end PassantCodeQ13.MinimumWords.RowUniqueness
