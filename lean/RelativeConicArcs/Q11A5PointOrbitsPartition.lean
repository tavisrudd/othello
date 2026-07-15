import RelativeConicArcs.Q11A5PointOrbitsData

/-! Static partition certificates for the seven Q11 A5 point blocks. -/

namespace RelativeConicArcs.Examples.Q11A5PointOrbits

set_option maxHeartbeats 100000000
set_option maxRecDepth 100000

/-- Membership in a displayed block is equivalent to its compact block label. -/
theorem mem_orbitPoints_iff_orbitIndex :
    ∀ i : Fin 7, ∀ p : PointIndex, p ∈ orbitPoints i ↔ orbitIndex p = i := by
  intro i
  fin_cases i <;> decide

/-- The seven blocks are distinct, cover all 133 points, and have profile [6,10,12,15,30,30,30]. -/
theorem point_orbit_partition :
    ((Finset.univ : Finset (Fin 7)).image orbitPoints).card = 7 ∧
    (Finset.univ : Finset (Fin 7)).biUnion orbitPoints =
      (Finset.univ : Finset PointIndex) ∧
    ∀ i : Fin 7, (orbitPoints i).card = orbitSize i := by
  constructor
  · decide
  · constructor
    · decide
    · intro i
      fin_cases i <;> decide

/-- The witness is the unique six-point block. -/
theorem unique_six_orbit :
    ∀ i : Fin 7, (orbitPoints i).card = 6 ↔ orbitPoints i = witnessSet := by
  intro i
  fin_cases i <;> decide

/-- The standard conic is the unique twelve-point block. -/
theorem unique_twelve_orbit :
    ∀ i : Fin 7, (orbitPoints i).card = 12 ↔ orbitPoints i = standardConicIndices := by
  intro i
  fin_cases i <;> decide

end RelativeConicArcs.Examples.Q11A5PointOrbits
