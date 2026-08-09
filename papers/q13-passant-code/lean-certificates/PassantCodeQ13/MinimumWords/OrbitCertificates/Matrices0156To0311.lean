import PassantCodeQ13.MinimumWords.OrbitCertificate

/-!
# Minimum-word orbit images for normalized matrices 156 through 311

This module checks one consecutive 156-matrix block of each displayed minimum-word orbit against
the generated matrix-to-orbit-position tables.  Each declaration is independently kernel reduced;
the tables carry no trust.
-/

namespace PassantCodeQ13.MinimumWords

/-- The symmetric-stabilizer support images for normalized matrices 156 through 311. -/
theorem orbitSymmetric_matrixBlock0156To0311 :
    orbitImageBlockCheck representativeS4 orbitSymmetricSupports
      orbitSymmetricSupportsMatrixOrbitIndices 156 156 = true := by
  decide +kernel

/-- The first dihedral support images for normalized matrices 156 through 311. -/
theorem orbitDihedralA_matrixBlock0156To0311 :
    orbitImageBlockCheck representativeDihedralA orbitDihedralASupports
      orbitDihedralASupportsMatrixOrbitIndices 156 156 = true := by
  decide +kernel

/-- The second dihedral support images for normalized matrices 156 through 311. -/
theorem orbitDihedralB_matrixBlock0156To0311 :
    orbitImageBlockCheck representativeDihedralB orbitDihedralBSupports
      orbitDihedralBSupportsMatrixOrbitIndices 156 156 = true := by
  decide +kernel

/-- The third dihedral support images for normalized matrices 156 through 311. -/
theorem orbitDihedralC_matrixBlock0156To0311 :
    orbitImageBlockCheck representativeDihedralC orbitDihedralCSupports
      orbitDihedralCSupportsMatrixOrbitIndices 156 156 = true := by
  decide +kernel

end PassantCodeQ13.MinimumWords
