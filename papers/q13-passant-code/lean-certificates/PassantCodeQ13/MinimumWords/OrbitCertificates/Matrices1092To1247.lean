import PassantCodeQ13.MinimumWords.OrbitCertificate

/-!
# Minimum-word orbit images for normalized matrices 1092 through 1247

This module checks one consecutive 156-matrix block of each displayed minimum-word orbit against
the generated matrix-to-orbit-position tables.  Each declaration is independently kernel reduced;
the tables carry no trust.
-/

namespace PassantCodeQ13.MinimumWords

/-- The symmetric-stabilizer support images for normalized matrices 1092 through 1247. -/
theorem orbitSymmetric_matrixBlock1092To1247 :
    orbitImageBlockCheck representativeS4 orbitSymmetricSupports
      orbitSymmetricSupportsMatrixOrbitIndices 1092 156 = true := by
  decide +kernel

/-- The first dihedral support images for normalized matrices 1092 through 1247. -/
theorem orbitDihedralA_matrixBlock1092To1247 :
    orbitImageBlockCheck representativeDihedralA orbitDihedralASupports
      orbitDihedralASupportsMatrixOrbitIndices 1092 156 = true := by
  decide +kernel

/-- The second dihedral support images for normalized matrices 1092 through 1247. -/
theorem orbitDihedralB_matrixBlock1092To1247 :
    orbitImageBlockCheck representativeDihedralB orbitDihedralBSupports
      orbitDihedralBSupportsMatrixOrbitIndices 1092 156 = true := by
  decide +kernel

/-- The third dihedral support images for normalized matrices 1092 through 1247. -/
theorem orbitDihedralC_matrixBlock1092To1247 :
    orbitImageBlockCheck representativeDihedralC orbitDihedralCSupports
      orbitDihedralCSupportsMatrixOrbitIndices 1092 156 = true := by
  decide +kernel

end PassantCodeQ13.MinimumWords
