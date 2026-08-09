import PassantCodeQ13.MinimumWords.OrbitCertificates

/-! # Third minimum-word orbit with dihedral stabilizer

The displayed twelve-set is expanded under all normalized elements of `PGL(2,13)`.  Fourteen bounded
matrix-block certificates identify that expansion with the displayed orbit through the generated
matrix-to-orbit index table.  The orbit has 91 distinct supports, each of weight twelve and zero
syndrome, and its binary span has rank 36.
-/

namespace PassantCodeQ13.MinimumWords

/-- Expanding the third dihedral representative gives the displayed orbit. -/
theorem supportOrbit_representativeDihedralC_eq :
    supportOrbit representativeDihedralC = orbitDihedralCSupports := by
  rw [← tabulatedSupportOrbit_eq_supportOrbit]
  exact tabulatedSupportOrbit_eq_of_blockFamily orbitDihedralC_matrixIndices_length
    orbitDihedralC_allMatrixBlocks orbitDihedralC_indexExpansion_eraseDups

/-- The third dihedral representative has a 91-element kernel orbit of binary span rank 36. -/
theorem orbitDihedralC_certificate :
    (supportOrbit representativeDihedralC).length = 91 ∧
      orbitKernelCheck (supportOrbit representativeDihedralC) = true ∧
      binaryRank (supportOrbit representativeDihedralC) = 36 := by
  rw [supportOrbit_representativeDihedralC_eq]
  decide +kernel

end PassantCodeQ13.MinimumWords
