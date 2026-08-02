import RelativeConicArcs.Gates.PassantCodeQ13
import PassantCodeQ13.WeightTen.Aggregate
import PassantCodeQ13.MinimumWords.Reconstruction
import PassantCodeQ13.SemanticTransports
import PassantCodeQ13.AssociationAlgebra

/-!
# Aggregate finite gate for the q=13 passant code

This gate imports separately elaborated weight-ten and minimum-orbit leaves.  It establishes the
fixed-base syndrome exclusions, four 91-element projective orbits, span rank 36 for each orbit,
pair-concurrence recovery of passant joins, and the zero-triple signatures of all 78 geometric
passant rows.

The gate does not claim the full minimum-distance or reconstruction theorem.  Its scope excludes
parity-profile exhaustion from arbitrary weight-ten codewords, exhaustive equality of the four
orbits with the complete weight-twelve layer, uniqueness of the recovered row family, and the
projective anchor theorem for all coordinate automorphisms.
-/

namespace PassantCodeQ13.Gates.Main

open PassantCodeQ13.WeightTen
open PassantCodeQ13.MinimumWords

/-- The semantic incidence map has rank 42, hence the binary passant code has dimension 36. -/
theorem incidenceRankAndCodeDimension :
    RelativeConicArcs.PassantCodeQ13.IncidenceMapHasRankFortyTwo ∧
      Module.finrank (ZMod 2) RelativeConicArcs.PassantCodeQ13.passantCode = 36 := by
  have rank := PassantCodeQ13.SemanticTransports.incidenceMap_has_rank_fortyTwo
  exact ⟨rank, RelativeConicArcs.PassantCodeQ13.passantCode_finrank_eq_thirtySix rank⟩

/-- The two weight-ten syndrome profiles are empty in every shard. -/
theorem weightTenCertificate :
    localPartitionCheck = true ∧
      (isolatedProfileCheck 0 = true ∧ isolatedProfileCheck 1 = true ∧
        isolatedProfileCheck 2 = true ∧ isolatedProfileCheck 3 = true ∧
        isolatedProfileCheck 4 = true ∧ isolatedProfileCheck 5 = true ∧
        isolatedProfileCheck 6 = true) ∧
      (cycleProfileCheck 0 = true ∧ cycleProfileCheck 1 = true ∧
        cycleProfileCheck 2 = true ∧ cycleProfileCheck 3 = true ∧
        cycleProfileCheck 4 = true ∧ cycleProfileCheck 5 = true ∧
        cycleProfileCheck 6 = true) :=
  ⟨local_partition, all_isolated_profiles_disjoint, all_cycle_profiles_disjoint⟩

/-- The four displayed projective orbits are kernel orbits of size 91 and binary span rank 36. -/
theorem minimumOrbitCertificate :
    minimumSupportCodes.length = 364 ∧
      binaryRank (supportOrbit representativeS4) = 36 ∧
      binaryRank (supportOrbit representativeDihedralA) = 36 ∧
      binaryRank (supportOrbit representativeDihedralB) = 36 ∧
      binaryRank (supportOrbit representativeDihedralC) = 36 := by
  exact ⟨minimumSupportCodes_length, orbitS4_rank, orbitDihedralA_certificate.2.2,
    orbitDihedralB_certificate.2.2, orbitDihedralC_certificate.2.2⟩

end PassantCodeQ13.Gates.Main
