import PassantCodeQ13.MinimumWords.OrbitCertificate

/-!
# Minimum-word orbit images for normalized matrices 2028 through 2183

This module checks one consecutive 156-matrix block of each displayed minimum-word orbit against
the generated matrix-to-orbit-position tables.  Each declaration is independently kernel reduced;
the tables carry no trust.
-/

namespace PassantCodeQ13.MinimumWords

/-- The symmetric-stabilizer support images for normalized matrices 2028 through 2183. -/
theorem orbitSymmetric_matrixBlock2028To2183 :
    orbitImageBlockCheck representativeS4 orbitSymmetricSupports
      orbitSymmetricSupportsMatrixOrbitIndices 2028 156 = true := by
  decide +kernel

/-- The first dihedral support images for normalized matrices 2028 through 2183. -/
theorem orbitDihedralA_matrixBlock2028To2183 :
    orbitImageBlockCheck representativeDihedralA orbitDihedralASupports
      orbitDihedralASupportsMatrixOrbitIndices 2028 156 = true := by
  decide +kernel

/-- The second dihedral support images for normalized matrices 2028 through 2183. -/
theorem orbitDihedralB_matrixBlock2028To2183 :
    orbitImageBlockCheck representativeDihedralB orbitDihedralBSupports
      orbitDihedralBSupportsMatrixOrbitIndices 2028 156 = true := by
  decide +kernel

/-- The third dihedral support images for normalized matrices 2028 through 2183. -/
theorem orbitDihedralC_matrixBlock2028To2183 :
    orbitImageBlockCheck representativeDihedralC orbitDihedralCSupports
      orbitDihedralCSupportsMatrixOrbitIndices 2028 156 = true := by
  decide +kernel

end PassantCodeQ13.MinimumWords
