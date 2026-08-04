import RelativeConicArcs.Q11A5PointOrbitsBlocks

/-! Identification of the Brianchon points of the order-eleven Clebsch witness with a displayed
point block, and of the triple-chord-intersection ledger with the Brianchon set. -/

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
