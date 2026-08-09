import PassantCodeQ13.MinimumWords.OrbitCertificate

/-!
# Minimum-word orbit images for normalized matrices 312 through 467

This module checks one consecutive 156-matrix block of each displayed minimum-word orbit against
the generated matrix-to-orbit-position tables.  Each declaration is independently kernel reduced;
the tables carry no trust.
-/

namespace PassantCodeQ13.MinimumWords

/-- The symmetric-stabilizer support images for normalized matrices 312 through 467. -/
theorem orbitSymmetric_matrixBlock0312To0467 :
    orbitImageBlockCheck representativeS4 orbitSymmetricSupports
      orbitSymmetricSupportsMatrixOrbitIndices 312 156 = true := by
  decide +kernel

/-- The first dihedral support images for normalized matrices 312 through 467. -/
theorem orbitDihedralA_matrixBlock0312To0467 :
    orbitImageBlockCheck representativeDihedralA orbitDihedralASupports
      orbitDihedralASupportsMatrixOrbitIndices 312 156 = true := by
  decide +kernel

/-- The second dihedral support images for normalized matrices 312 through 467. -/
theorem orbitDihedralB_matrixBlock0312To0467 :
    orbitImageBlockCheck representativeDihedralB orbitDihedralBSupports
      orbitDihedralBSupportsMatrixOrbitIndices 312 156 = true := by
  decide +kernel

/-- The third dihedral support images for normalized matrices 312 through 467. -/
theorem orbitDihedralC_matrixBlock0312To0467 :
    orbitImageBlockCheck representativeDihedralC orbitDihedralCSupports
      orbitDihedralCSupportsMatrixOrbitIndices 312 156 = true := by
  decide +kernel

end PassantCodeQ13.MinimumWords
