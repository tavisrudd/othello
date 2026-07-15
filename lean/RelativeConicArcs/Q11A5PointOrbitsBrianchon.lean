import RelativeConicArcs.Q11A5PointOrbitsData

/-! Static Brianchon-to-orbit bridges for the Q11 Clebsch witness. -/

namespace RelativeConicArcs.Examples.Q11A5PointOrbits

set_option maxHeartbeats 100000000
set_option maxRecDepth 100000

/-- The complete triple-point set from the 45-intersection ledger is the Brianchon set. -/
theorem triplePointSet_eq_brianchonSet : triplePointSet = brianchonSet := by
  have h := Q11BrianchonPetersen.disjoint_chord_intersection_ledger
  exact congrArg
    (fun s : Finset Q11BrianchonPetersen.AffinePointCode => s.map codeEmbedding)
    h.2.2.2.2.2

/-- The ten Brianchon points form block 3. -/
theorem brianchon_points_one_orbit :
    brianchonSet.card = 10 ∧ orbitPoints 3 = brianchonSet := by decide

end RelativeConicArcs.Examples.Q11A5PointOrbits
