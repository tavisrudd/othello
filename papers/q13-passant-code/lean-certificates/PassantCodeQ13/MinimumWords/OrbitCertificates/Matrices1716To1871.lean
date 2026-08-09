import PassantCodeQ13.MinimumWords.OrbitCertificate

/-!
# Minimum-word orbit images for normalized matrices 1716 through 1871

This module checks one consecutive 156-matrix block of each displayed minimum-word orbit against
the generated matrix-to-orbit-position tables.  Each declaration is independently kernel reduced;
the tables carry no trust.
-/

namespace PassantCodeQ13.MinimumWords

/-- The symmetric-stabilizer support images for normalized matrices 1716 through 1871. -/
theorem orbitSymmetric_matrixBlock1716To1871 :
    orbitImageBlockCheck representativeS4 orbitSymmetricSupports
      orbitSymmetricSupportsMatrixOrbitIndices 1716 156 = true := by
  decide +kernel

/-- The first dihedral support images for normalized matrices 1716 through 1871. -/
theorem orbitDihedralA_matrixBlock1716To1871 :
    orbitImageBlockCheck representativeDihedralA orbitDihedralASupports
      orbitDihedralASupportsMatrixOrbitIndices 1716 156 = true := by
  decide +kernel

/-- The second dihedral support images for normalized matrices 1716 through 1871. -/
theorem orbitDihedralB_matrixBlock1716To1871 :
    orbitImageBlockCheck representativeDihedralB orbitDihedralBSupports
      orbitDihedralBSupportsMatrixOrbitIndices 1716 156 = true := by
  decide +kernel

/-- The third dihedral support images for normalized matrices 1716 through 1871. -/
theorem orbitDihedralC_matrixBlock1716To1871 :
    orbitImageBlockCheck representativeDihedralC orbitDihedralCSupports
      orbitDihedralCSupportsMatrixOrbitIndices 1716 156 = true := by
  decide +kernel

end PassantCodeQ13.MinimumWords
