import PassantCodeQ13.MinimumWords.OrbitCertificates

/-! # The minimum-word orbit with symmetric-group stabilizer

The displayed twelve-set is expanded under all normalized elements of `PGL(2,13)`.  Fourteen bounded
matrix-block certificates identify that expansion with the displayed orbit through the generated
matrix-to-orbit index table.  The checks are exhaustive over the full projective group: the orbit
has 91 distinct supports, each of weight twelve and zero syndrome, and its binary span has rank 36.
-/

namespace PassantCodeQ13.MinimumWords

/-- Expanding the symmetric-stabilizer representative gives the displayed orbit. -/
theorem supportOrbit_representativeS4_eq :
    supportOrbit representativeS4 = orbitSymmetricSupports := by
  rw [← tabulatedSupportOrbit_eq_supportOrbit]
  exact tabulatedSupportOrbit_eq_of_blockFamily orbitSymmetric_matrixIndices_length
    orbitSymmetric_allMatrixBlocks orbitSymmetric_indexExpansion_eraseDups

/-- The symmetric-stabilizer representative has a 91-element orbit of weight-twelve codewords. -/
theorem orbitS4_size_and_kernel :
    (supportOrbit representativeS4).length = 91 ∧
      orbitKernelCheck (supportOrbit representativeS4) = true := by
  rw [supportOrbit_representativeS4_eq]
  decide +kernel

/-- The symmetric-stabilizer orbit spans a 36-dimensional binary space. -/
theorem orbitS4_rank : binaryRank (supportOrbit representativeS4) = 36 := by
  rw [supportOrbit_representativeS4_eq]
  decide +kernel

end PassantCodeQ13.MinimumWords
