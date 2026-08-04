import PassantCodeQ13.MinimumWords.NormalizedIndexTable
import PassantCodeQ13.MinimumWords.OrbitData

/-! # Second minimum-word orbit with dihedral stabilizer

The displayed twelve-set is expanded under all normalized elements of `PGL(2,13)` and identified
with the displayed orbit by kernel reduction through the packed internal-index table of
`PassantCodeQ13.MinimumWords.NormalizedIndexTable`.  The orbit has 91 distinct supports, each of
weight twelve and zero syndrome, and its binary span has rank 36.
-/

namespace PassantCodeQ13.MinimumWords

/-- Expanding the second dihedral representative gives the displayed orbit. -/
theorem supportOrbit_representativeDihedralB_eq :
    supportOrbit representativeDihedralB = orbitDihedralBSupports := by
  rw [← tabulatedSupportOrbit_eq_supportOrbit]
  decide +kernel

/-- The second dihedral representative has a 91-element kernel orbit of binary span rank 36. -/
theorem orbitDihedralB_certificate :
    (supportOrbit representativeDihedralB).length = 91 ∧
      orbitKernelCheck (supportOrbit representativeDihedralB) = true ∧
      binaryRank (supportOrbit representativeDihedralB) = 36 := by
  rw [supportOrbit_representativeDihedralB_eq]
  decide +kernel

end PassantCodeQ13.MinimumWords
