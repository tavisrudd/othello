import PassantCodeQ13.MinimumWords.NormalizedIndexTable
import PassantCodeQ13.MinimumWords.OrbitData

/-! # Third minimum-word orbit with dihedral stabilizer

The displayed twelve-set is expanded under all normalized elements of `PGL(2,13)` and identified
with the displayed orbit by kernel reduction through the packed internal-index table of
`PassantCodeQ13.MinimumWords.NormalizedIndexTable`.  The orbit has 91 distinct supports, each of
weight twelve and zero syndrome, and its binary span has rank 36.
-/

namespace PassantCodeQ13.MinimumWords

/-- Expanding the third dihedral representative gives the displayed orbit. -/
theorem supportOrbit_representativeDihedralC_eq :
    supportOrbit representativeDihedralC = orbitDihedralCSupports := by
  rw [← tabulatedSupportOrbit_eq_supportOrbit]
  decide +kernel

/-- The third dihedral representative has a 91-element kernel orbit of binary span rank 36. -/
theorem orbitDihedralC_certificate :
    (supportOrbit representativeDihedralC).length = 91 ∧
      orbitKernelCheck (supportOrbit representativeDihedralC) = true ∧
      binaryRank (supportOrbit representativeDihedralC) = 36 := by
  rw [supportOrbit_representativeDihedralC_eq]
  decide +kernel

end PassantCodeQ13.MinimumWords
