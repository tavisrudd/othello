import PassantCodeQ13.MinimumWords.OrbitCertificate

/-!
# Minimum-word orbit images for normalized matrices 936 through 1091

This module checks one consecutive 156-matrix block of each displayed minimum-word orbit against
the generated matrix-to-orbit-position tables.  Each declaration is independently kernel reduced;
the tables carry no trust.
-/

namespace PassantCodeQ13.MinimumWords

/-- The symmetric-stabilizer support images for normalized matrices 936 through 1091. -/
theorem orbitSymmetric_matrixBlock0936To1091 :
    orbitImageBlockCheck representativeS4 orbitSymmetricSupports
      orbitSymmetricSupportsMatrixOrbitIndices 936 156 = true := by
  decide +kernel

/-- The first dihedral support images for normalized matrices 936 through 1091. -/
theorem orbitDihedralA_matrixBlock0936To1091 :
    orbitImageBlockCheck representativeDihedralA orbitDihedralASupports
      orbitDihedralASupportsMatrixOrbitIndices 936 156 = true := by
  decide +kernel

/-- The second dihedral support images for normalized matrices 936 through 1091. -/
theorem orbitDihedralB_matrixBlock0936To1091 :
    orbitImageBlockCheck representativeDihedralB orbitDihedralBSupports
      orbitDihedralBSupportsMatrixOrbitIndices 936 156 = true := by
  decide +kernel

/-- The third dihedral support images for normalized matrices 936 through 1091. -/
theorem orbitDihedralC_matrixBlock0936To1091 :
    orbitImageBlockCheck representativeDihedralC orbitDihedralCSupports
      orbitDihedralCSupportsMatrixOrbitIndices 936 156 = true := by
  decide +kernel

end PassantCodeQ13.MinimumWords
