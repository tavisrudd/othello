import PassantCodeQ13.MinimumWords.OrbitDihedralA
import PassantCodeQ13.MinimumWords.OrbitDihedralB
import PassantCodeQ13.MinimumWords.OrbitDihedralC

/-! # Aggregate for the three dihedral minimum-word orbits

Each orbit is identified with a displayed list of supports in its own module, so pairwise
disjointness is decided by kernel reduction on those lists.
-/

namespace PassantCodeQ13.MinimumWords

/-- The three dihedral orbits are pairwise disjoint. -/
theorem dihedral_orbits_pairwise_disjoint :
    (supportOrbit representativeDihedralA).all
        (fun support => !(supportOrbit representativeDihedralB).contains support) = true ∧
      (supportOrbit representativeDihedralA).all
        (fun support => !(supportOrbit representativeDihedralC).contains support) = true ∧
      (supportOrbit representativeDihedralB).all
        (fun support => !(supportOrbit representativeDihedralC).contains support) = true := by
  rw [supportOrbit_representativeDihedralA_eq, supportOrbit_representativeDihedralB_eq,
    supportOrbit_representativeDihedralC_eq]
  decide +kernel

end PassantCodeQ13.MinimumWords
