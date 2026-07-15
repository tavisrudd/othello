import RelativeConicArcs.Q11A5PointOrbitsArithmetic

/-! Arithmetic row 3 for the Q11 A5 point action. -/

namespace RelativeConicArcs.Examples.Q11A5PointOrbits

set_option maxHeartbeats 100000000
set_option maxRecDepth 100000

private instance : Fact (Nat.Prime 11) := ⟨by decide⟩

theorem action_on_witness_row_3 :
    ∀ i : Fin 6, pointAction 3 (witnessIndex i) = witnessIndex (supportPerm 3 i) := by
  intro i
  rw [pointAction_eq_fast]
  revert i
  decide

/-- Canonical point-action values for group row 3. -/
def pointActionCode_3 (p : PointIndex) : PointIndex :=
  ![
    0, 54, 105, 70, 27, 35, 113, 78, 19, 62, 129, 88,
    132, 95, 96, 89, 91, 90, 93, 92, 94, 98, 99, 45,
    4, 123, 58, 17, 84, 112, 43, 30, 71, 77, 50, 115,
    3, 41, 130, 32, 59, 68, 12, 106, 33, 48, 14, 29,
    10, 82, 67, 125, 116, 101, 63, 22, 47, 65, 111, 72,
    8, 15, 40, 104, 128, 79, 121, 53, 75, 42, 86, 64,
    9, 108, 31, 119, 20, 66, 46, 131, 16, 117, 26, 107,
    6, 56, 87, 36, 55, 52, 24, 83, 124, 100, 38, 21,
    7, 69, 114, 11, 51, 34, 57, 103, 120, 127, 74, 80,
    5, 28, 110, 49, 85, 109, 13, 73, 61, 25, 122, 37,
    1, 44, 2, 126, 60, 18, 81, 118, 39, 23, 76, 102,
    97
  ] p

/-- Numeric matrix normalization for group row 3, independent of orbit lookup. -/
theorem pointAction_eq_code_3 : ∀ p : PointIndex, pointAction 3 p = pointActionCode_3 p := by
  intro p
  rw [pointAction_eq_fast]
  revert p
  decide

/-- Pure table lookup: group row 3 preserves the orbit label. -/
theorem orbitIndex_code_3 : ∀ p : PointIndex, orbitIndex (pointActionCode_3 p) = orbitIndex p := by
  decide

theorem orbitIndex_pointAction_row_3 :
    ∀ p : PointIndex, orbitIndex (pointAction 3 p) = orbitIndex p := by
  intro p
  rw [pointAction_eq_code_3 p]
  exact orbitIndex_code_3 p

end RelativeConicArcs.Examples.Q11A5PointOrbits
