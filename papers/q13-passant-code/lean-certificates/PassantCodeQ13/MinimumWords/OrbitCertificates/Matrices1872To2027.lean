import PassantCodeQ13.MinimumWords.OrbitCertificate

/-!
# Minimum-word orbit images for normalized matrices 1872 through 2027

This module checks one consecutive 156-matrix block of each displayed minimum-word orbit against
the generated matrix-to-orbit-position tables.  Each declaration is independently kernel reduced;
the tables carry no trust.
-/

namespace PassantCodeQ13.MinimumWords

/-- The symmetric-stabilizer support images for normalized matrices 1872 through 2027. -/
theorem orbitSymmetric_matrixBlock1872To2027 :
    orbitImageBlockCheck representativeS4 orbitSymmetricSupports
      orbitSymmetricSupportsMatrixOrbitIndices 1872 156 = true := by
  decide +kernel

/-- The first dihedral support images for normalized matrices 1872 through 2027. -/
theorem orbitDihedralA_matrixBlock1872To2027 :
    orbitImageBlockCheck representativeDihedralA orbitDihedralASupports
      orbitDihedralASupportsMatrixOrbitIndices 1872 156 = true := by
  decide +kernel

/-- The second dihedral support images for normalized matrices 1872 through 2027. -/
theorem orbitDihedralB_matrixBlock1872To2027 :
    orbitImageBlockCheck representativeDihedralB orbitDihedralBSupports
      orbitDihedralBSupportsMatrixOrbitIndices 1872 156 = true := by
  decide +kernel

/-- The third dihedral support images for normalized matrices 1872 through 2027. -/
theorem orbitDihedralC_matrixBlock1872To2027 :
    orbitImageBlockCheck representativeDihedralC orbitDihedralCSupports
      orbitDihedralCSupportsMatrixOrbitIndices 1872 156 = true := by
  decide +kernel

end PassantCodeQ13.MinimumWords
