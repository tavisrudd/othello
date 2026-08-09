import PassantCodeQ13.MinimumWords.OrbitCertificate

/-!
# Minimum-word orbit images for normalized matrices 468 through 623

This module checks one consecutive 156-matrix block of each displayed minimum-word orbit against
the generated matrix-to-orbit-position tables.  Each declaration is independently kernel reduced;
the tables carry no trust.
-/

namespace PassantCodeQ13.MinimumWords

/-- The symmetric-stabilizer support images for normalized matrices 468 through 623. -/
theorem orbitSymmetric_matrixBlock0468To0623 :
    orbitImageBlockCheck representativeS4 orbitSymmetricSupports
      orbitSymmetricSupportsMatrixOrbitIndices 468 156 = true := by
  decide +kernel

/-- The first dihedral support images for normalized matrices 468 through 623. -/
theorem orbitDihedralA_matrixBlock0468To0623 :
    orbitImageBlockCheck representativeDihedralA orbitDihedralASupports
      orbitDihedralASupportsMatrixOrbitIndices 468 156 = true := by
  decide +kernel

/-- The second dihedral support images for normalized matrices 468 through 623. -/
theorem orbitDihedralB_matrixBlock0468To0623 :
    orbitImageBlockCheck representativeDihedralB orbitDihedralBSupports
      orbitDihedralBSupportsMatrixOrbitIndices 468 156 = true := by
  decide +kernel

/-- The third dihedral support images for normalized matrices 468 through 623. -/
theorem orbitDihedralC_matrixBlock0468To0623 :
    orbitImageBlockCheck representativeDihedralC orbitDihedralCSupports
      orbitDihedralCSupportsMatrixOrbitIndices 468 156 = true := by
  decide +kernel

end PassantCodeQ13.MinimumWords
