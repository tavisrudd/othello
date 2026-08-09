import PassantCodeQ13.MinimumWords.OrbitCertificates

/-! # First minimum-word orbit with dihedral stabilizer

The displayed twelve-set is expanded under all normalized elements of `PGL(2,13)`.  Fourteen bounded
matrix-block certificates identify that expansion with the displayed orbit through the generated
matrix-to-orbit index table.  The orbit has 91 distinct supports, each of weight twelve and zero
syndrome, and its binary span has rank 36.
-/

namespace PassantCodeQ13.MinimumWords

/-- Expanding the first dihedral representative gives the displayed orbit. -/
theorem supportOrbit_representativeDihedralA_eq :
    supportOrbit representativeDihedralA = orbitDihedralASupports := by
  rw [← tabulatedSupportOrbit_eq_supportOrbit]
  exact tabulatedSupportOrbit_eq_of_blockFamily orbitDihedralA_matrixIndices_length
    orbitDihedralA_allMatrixBlocks orbitDihedralA_indexExpansion_eraseDups

/-- The first dihedral representative has a 91-element kernel orbit of binary span rank 36. -/
theorem orbitDihedralA_certificate :
    (supportOrbit representativeDihedralA).length = 91 ∧
      orbitKernelCheck (supportOrbit representativeDihedralA) = true ∧
      binaryRank (supportOrbit representativeDihedralA) = 36 := by
  rw [supportOrbit_representativeDihedralA_eq]
  decide +kernel

end PassantCodeQ13.MinimumWords
