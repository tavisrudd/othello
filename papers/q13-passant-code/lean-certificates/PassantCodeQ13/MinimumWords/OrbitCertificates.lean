import PassantCodeQ13.MinimumWords.OrbitCertificates.Matrices0000To0155
import PassantCodeQ13.MinimumWords.OrbitCertificates.Matrices0156To0311
import PassantCodeQ13.MinimumWords.OrbitCertificates.Matrices0312To0467
import PassantCodeQ13.MinimumWords.OrbitCertificates.Matrices0468To0623
import PassantCodeQ13.MinimumWords.OrbitCertificates.Matrices0624To0779
import PassantCodeQ13.MinimumWords.OrbitCertificates.Matrices0780To0935
import PassantCodeQ13.MinimumWords.OrbitCertificates.Matrices0936To1091
import PassantCodeQ13.MinimumWords.OrbitCertificates.Matrices1092To1247
import PassantCodeQ13.MinimumWords.OrbitCertificates.Matrices1248To1403
import PassantCodeQ13.MinimumWords.OrbitCertificates.Matrices1404To1559
import PassantCodeQ13.MinimumWords.OrbitCertificates.Matrices1560To1715
import PassantCodeQ13.MinimumWords.OrbitCertificates.Matrices1716To1871
import PassantCodeQ13.MinimumWords.OrbitCertificates.Matrices1872To2027
import PassantCodeQ13.MinimumWords.OrbitCertificates.Matrices2028To2183

/-!
# Assembly of the bounded minimum-word orbit certificates

The fourteen matrix-block modules cover the normalized projective matrix list in consecutive blocks
of 156.  This module assembles their already elaborated checks and verifies, separately for each
orbit, that removing repetitions from the displayed matrix-index expansion gives the 91 displayed
supports in their stated order.  The assembly performs no projective action computation.
-/

namespace PassantCodeQ13.MinimumWords

/-- All fourteen normalized-matrix blocks agree with the symmetric-stabilizer orbit table. -/
theorem orbitSymmetric_allMatrixBlocks : ∀ block : Fin 14,
    orbitImageBlockCheck representativeS4 orbitSymmetricSupports
      orbitSymmetricSupportsMatrixOrbitIndices (block.1 * 156) 156 = true := by
  intro block
  fin_cases block
  · exact orbitSymmetric_matrixBlock0000To0155
  · exact orbitSymmetric_matrixBlock0156To0311
  · exact orbitSymmetric_matrixBlock0312To0467
  · exact orbitSymmetric_matrixBlock0468To0623
  · exact orbitSymmetric_matrixBlock0624To0779
  · exact orbitSymmetric_matrixBlock0780To0935
  · exact orbitSymmetric_matrixBlock0936To1091
  · exact orbitSymmetric_matrixBlock1092To1247
  · exact orbitSymmetric_matrixBlock1248To1403
  · exact orbitSymmetric_matrixBlock1404To1559
  · exact orbitSymmetric_matrixBlock1560To1715
  · exact orbitSymmetric_matrixBlock1716To1871
  · exact orbitSymmetric_matrixBlock1872To2027
  · exact orbitSymmetric_matrixBlock2028To2183

/-- All fourteen normalized-matrix blocks agree with the first dihedral orbit table. -/
theorem orbitDihedralA_allMatrixBlocks : ∀ block : Fin 14,
    orbitImageBlockCheck representativeDihedralA orbitDihedralASupports
      orbitDihedralASupportsMatrixOrbitIndices (block.1 * 156) 156 = true := by
  intro block
  fin_cases block
  · exact orbitDihedralA_matrixBlock0000To0155
  · exact orbitDihedralA_matrixBlock0156To0311
  · exact orbitDihedralA_matrixBlock0312To0467
  · exact orbitDihedralA_matrixBlock0468To0623
  · exact orbitDihedralA_matrixBlock0624To0779
  · exact orbitDihedralA_matrixBlock0780To0935
  · exact orbitDihedralA_matrixBlock0936To1091
  · exact orbitDihedralA_matrixBlock1092To1247
  · exact orbitDihedralA_matrixBlock1248To1403
  · exact orbitDihedralA_matrixBlock1404To1559
  · exact orbitDihedralA_matrixBlock1560To1715
  · exact orbitDihedralA_matrixBlock1716To1871
  · exact orbitDihedralA_matrixBlock1872To2027
  · exact orbitDihedralA_matrixBlock2028To2183

/-- All fourteen normalized-matrix blocks agree with the second dihedral orbit table. -/
theorem orbitDihedralB_allMatrixBlocks : ∀ block : Fin 14,
    orbitImageBlockCheck representativeDihedralB orbitDihedralBSupports
      orbitDihedralBSupportsMatrixOrbitIndices (block.1 * 156) 156 = true := by
  intro block
  fin_cases block
  · exact orbitDihedralB_matrixBlock0000To0155
  · exact orbitDihedralB_matrixBlock0156To0311
  · exact orbitDihedralB_matrixBlock0312To0467
  · exact orbitDihedralB_matrixBlock0468To0623
  · exact orbitDihedralB_matrixBlock0624To0779
  · exact orbitDihedralB_matrixBlock0780To0935
  · exact orbitDihedralB_matrixBlock0936To1091
  · exact orbitDihedralB_matrixBlock1092To1247
  · exact orbitDihedralB_matrixBlock1248To1403
  · exact orbitDihedralB_matrixBlock1404To1559
  · exact orbitDihedralB_matrixBlock1560To1715
  · exact orbitDihedralB_matrixBlock1716To1871
  · exact orbitDihedralB_matrixBlock1872To2027
  · exact orbitDihedralB_matrixBlock2028To2183

/-- All fourteen normalized-matrix blocks agree with the third dihedral orbit table. -/
theorem orbitDihedralC_allMatrixBlocks : ∀ block : Fin 14,
    orbitImageBlockCheck representativeDihedralC orbitDihedralCSupports
      orbitDihedralCSupportsMatrixOrbitIndices (block.1 * 156) 156 = true := by
  intro block
  fin_cases block
  · exact orbitDihedralC_matrixBlock0000To0155
  · exact orbitDihedralC_matrixBlock0156To0311
  · exact orbitDihedralC_matrixBlock0312To0467
  · exact orbitDihedralC_matrixBlock0468To0623
  · exact orbitDihedralC_matrixBlock0624To0779
  · exact orbitDihedralC_matrixBlock0780To0935
  · exact orbitDihedralC_matrixBlock0936To1091
  · exact orbitDihedralC_matrixBlock1092To1247
  · exact orbitDihedralC_matrixBlock1248To1403
  · exact orbitDihedralC_matrixBlock1404To1559
  · exact orbitDihedralC_matrixBlock1560To1715
  · exact orbitDihedralC_matrixBlock1716To1871
  · exact orbitDihedralC_matrixBlock1872To2027
  · exact orbitDihedralC_matrixBlock2028To2183

/-- The symmetric-stabilizer matrix-index table has one entry per normalized projective matrix. -/
theorem orbitSymmetric_matrixIndices_length :
    orbitSymmetricSupportsMatrixOrbitIndices.length = 2184 := by
  decide +kernel

/-- The first dihedral matrix-index table has one entry per normalized projective matrix. -/
theorem orbitDihedralA_matrixIndices_length :
    orbitDihedralASupportsMatrixOrbitIndices.length = 2184 := by
  decide +kernel

/-- The second dihedral matrix-index table has one entry per normalized projective matrix. -/
theorem orbitDihedralB_matrixIndices_length :
    orbitDihedralBSupportsMatrixOrbitIndices.length = 2184 := by
  decide +kernel

/-- The third dihedral matrix-index table has one entry per normalized projective matrix. -/
theorem orbitDihedralC_matrixIndices_length :
    orbitDihedralCSupportsMatrixOrbitIndices.length = 2184 := by
  decide +kernel

/-- First occurrences in the symmetric-stabilizer matrix-index table reproduce its displayed
91-support orbit in order. -/
theorem orbitSymmetric_indexExpansion_eraseDups :
    (orbitIndexExpansion orbitSymmetricSupports
      orbitSymmetricSupportsMatrixOrbitIndices).eraseDups = orbitSymmetricSupports := by
  decide +kernel

/-- First occurrences in the first dihedral matrix-index table reproduce its displayed orbit. -/
theorem orbitDihedralA_indexExpansion_eraseDups :
    (orbitIndexExpansion orbitDihedralASupports
      orbitDihedralASupportsMatrixOrbitIndices).eraseDups = orbitDihedralASupports := by
  decide +kernel

/-- First occurrences in the second dihedral matrix-index table reproduce its displayed orbit. -/
theorem orbitDihedralB_indexExpansion_eraseDups :
    (orbitIndexExpansion orbitDihedralBSupports
      orbitDihedralBSupportsMatrixOrbitIndices).eraseDups = orbitDihedralBSupports := by
  decide +kernel

/-- First occurrences in the third dihedral matrix-index table reproduce its displayed orbit. -/
theorem orbitDihedralC_indexExpansion_eraseDups :
    (orbitIndexExpansion orbitDihedralCSupports
      orbitDihedralCSupportsMatrixOrbitIndices).eraseDups = orbitDihedralCSupports := by
  decide +kernel

end PassantCodeQ13.MinimumWords
