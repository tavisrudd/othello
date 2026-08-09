import PassantCodeQ13.MinimumWords.OrbitCertificate

/-!
# Minimum-word orbit images for normalized matrices 0 through 155

This module checks one consecutive 156-matrix block of each displayed minimum-word orbit against
the generated matrix-to-orbit-position tables.  Each declaration is independently kernel reduced;
the tables carry no trust.
-/

namespace PassantCodeQ13.MinimumWords

/-- The symmetric-stabilizer support images for normalized matrices 0 through 155. -/
theorem orbitSymmetric_matrixBlock0000To0155 :
    orbitImageBlockCheck representativeS4 orbitSymmetricSupports
      orbitSymmetricSupportsMatrixOrbitIndices 0 156 = true := by
  decide +kernel

/-- The first dihedral support images for normalized matrices 0 through 155. -/
theorem orbitDihedralA_matrixBlock0000To0155 :
    orbitImageBlockCheck representativeDihedralA orbitDihedralASupports
      orbitDihedralASupportsMatrixOrbitIndices 0 156 = true := by
  decide +kernel

/-- The second dihedral support images for normalized matrices 0 through 155. -/
theorem orbitDihedralB_matrixBlock0000To0155 :
    orbitImageBlockCheck representativeDihedralB orbitDihedralBSupports
      orbitDihedralBSupportsMatrixOrbitIndices 0 156 = true := by
  decide +kernel

/-- The third dihedral support images for normalized matrices 0 through 155. -/
theorem orbitDihedralC_matrixBlock0000To0155 :
    orbitImageBlockCheck representativeDihedralC orbitDihedralCSupports
      orbitDihedralCSupportsMatrixOrbitIndices 0 156 = true := by
  decide +kernel

end PassantCodeQ13.MinimumWords
