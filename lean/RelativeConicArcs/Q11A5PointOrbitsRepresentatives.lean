import RelativeConicArcs.Q11A5PointOrbitsArithmetic

/-! Representative-image certificates for the seven Q11 A5 point orbits. -/

namespace RelativeConicArcs.Examples.Q11A5PointOrbits

set_option maxHeartbeats 100000000
set_option maxRecDepth 100000

private instance : Fact (Nat.Prime 11) := ⟨by decide⟩

theorem representative_pointOrbit_row_0 :
    pointOrbit (orbitRepresentative 0) = orbitPoints 0 := by
  rw [pointOrbit_eq_fast]
  decide

theorem representative_pointOrbit_row_1 :
    pointOrbit (orbitRepresentative 1) = orbitPoints 1 := by
  rw [pointOrbit_eq_fast]
  decide

theorem representative_pointOrbit_row_2 :
    pointOrbit (orbitRepresentative 2) = orbitPoints 2 := by
  rw [pointOrbit_eq_fast]
  decide

theorem representative_pointOrbit_row_3 :
    pointOrbit (orbitRepresentative 3) = orbitPoints 3 := by
  rw [pointOrbit_eq_fast]
  decide

theorem representative_pointOrbit_row_4 :
    pointOrbit (orbitRepresentative 4) = orbitPoints 4 := by
  rw [pointOrbit_eq_fast]
  decide

theorem representative_pointOrbit_row_5 :
    pointOrbit (orbitRepresentative 5) = orbitPoints 5 := by
  rw [pointOrbit_eq_fast]
  decide

theorem representative_pointOrbit_row_6 :
    pointOrbit (orbitRepresentative 6) = orbitPoints 6 := by
  rw [pointOrbit_eq_fast]
  decide


/-- Each explicit orbit block is the image of its displayed representative. -/
theorem representative_pointOrbit (i : Fin 7) :
    pointOrbit (orbitRepresentative i) = orbitPoints i := by
  fin_cases i
  · exact representative_pointOrbit_row_0
  · exact representative_pointOrbit_row_1
  · exact representative_pointOrbit_row_2
  · exact representative_pointOrbit_row_3
  · exact representative_pointOrbit_row_4
  · exact representative_pointOrbit_row_5
  · exact representative_pointOrbit_row_6

end RelativeConicArcs.Examples.Q11A5PointOrbits
