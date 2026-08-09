import PassantCodeQ13.MinimumWords.OrbitCertificate

/-!
# Minimum-word orbit images for normalized matrices 624 through 779

This module checks one consecutive 156-matrix block of each displayed minimum-word orbit against
the generated matrix-to-orbit-position tables.  Each declaration is independently kernel reduced;
the tables carry no trust.
-/

namespace PassantCodeQ13.MinimumWords

/-- The symmetric-stabilizer support images for normalized matrices 624 through 779. -/
theorem orbitSymmetric_matrixBlock0624To0779 :
    orbitImageBlockCheck representativeS4 orbitSymmetricSupports
      orbitSymmetricSupportsMatrixOrbitIndices 624 156 = true := by
  decide +kernel

/-- The first dihedral support images for normalized matrices 624 through 779. -/
theorem orbitDihedralA_matrixBlock0624To0779 :
    orbitImageBlockCheck representativeDihedralA orbitDihedralASupports
      orbitDihedralASupportsMatrixOrbitIndices 624 156 = true := by
  decide +kernel

/-- The second dihedral support images for normalized matrices 624 through 779. -/
theorem orbitDihedralB_matrixBlock0624To0779 :
    orbitImageBlockCheck representativeDihedralB orbitDihedralBSupports
      orbitDihedralBSupportsMatrixOrbitIndices 624 156 = true := by
  decide +kernel

/-- The third dihedral support images for normalized matrices 624 through 779. -/
theorem orbitDihedralC_matrixBlock0624To0779 :
    orbitImageBlockCheck representativeDihedralC orbitDihedralCSupports
      orbitDihedralCSupportsMatrixOrbitIndices 624 156 = true := by
  decide +kernel

end PassantCodeQ13.MinimumWords
