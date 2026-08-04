import PassantCodeQ13.MinimumWords.NormalizedIndexTable
import PassantCodeQ13.MinimumWords.OrbitData

/-! # The minimum-word orbit with symmetric-group stabilizer

The displayed twelve-set is expanded under all normalized elements of `PGL(2,13)`, and the
expansion is identified with the displayed orbit by kernel reduction through the packed
internal-index table of `PassantCodeQ13.MinimumWords.NormalizedIndexTable`.  The checks are
exhaustive over the full projective group: the orbit has 91 distinct supports, each of weight
twelve and zero syndrome, and its binary span has rank 36.
-/

namespace PassantCodeQ13.MinimumWords

/-- Expanding the symmetric-stabilizer representative gives the displayed orbit. -/
theorem supportOrbit_representativeS4_eq :
    supportOrbit representativeS4 = orbitSymmetricSupports := by
  rw [← tabulatedSupportOrbit_eq_supportOrbit]
  decide +kernel

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
