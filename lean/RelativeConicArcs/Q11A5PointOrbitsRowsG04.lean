import RelativeConicArcs.Q11A5PointOrbitsArithmetic

/-! Arithmetic row 4 for the Q11 A5 point action. -/

namespace RelativeConicArcs.Examples.Q11A5PointOrbits

set_option maxHeartbeats 100000000
set_option maxRecDepth 100000

private instance : Fact (Nat.Prime 11) := ⟨by decide⟩

theorem action_on_witness_row_4 :
    ∀ i : Fin 6, pointAction 4 (witnessIndex i) = witnessIndex (supportPerm 4 i) := by
  intro i
  rw [pointAction_eq_fast]
  revert i
  decide

/-- Canonical point-action values for group row 4. -/
def pointActionCode_4 (p : PointIndex) : PointIndex :=
  ![
    0, 120, 122, 36, 24, 108, 84, 96, 60, 72, 48, 99,
    42, 114, 46, 61, 80, 27, 125, 8, 76, 95, 55, 129,
    90, 117, 82, 4, 109, 47, 31, 74, 39, 44, 101, 5,
    87, 119, 94, 128, 62, 37, 69, 30, 121, 23, 78, 56,
    45, 111, 34, 100, 89, 67, 1, 88, 85, 102, 26, 40,
    124, 116, 9, 54, 71, 57, 77, 50, 41, 97, 3, 32,
    59, 115, 106, 68, 130, 33, 7, 65, 107, 126, 49, 91,
    28, 112, 70, 86, 11, 15, 17, 16, 19, 18, 20, 13,
    14, 132, 21, 22, 93, 53, 131, 103, 63, 2, 43, 83,
    73, 113, 110, 58, 29, 6, 98, 35, 52, 81, 127, 75,
    104, 66, 118, 25, 92, 51, 123, 105, 64, 10, 38, 79,
    12
  ] p

/-- Numeric matrix normalization for group row 4, independent of orbit lookup. -/
theorem pointAction_eq_code_4 : ∀ p : PointIndex, pointAction 4 p = pointActionCode_4 p := by
  intro p
  rw [pointAction_eq_fast]
  revert p
  decide

/-- Pure table lookup: group row 4 preserves the orbit label. -/
theorem orbitIndex_code_4 : ∀ p : PointIndex, orbitIndex (pointActionCode_4 p) = orbitIndex p := by
  decide

theorem orbitIndex_pointAction_row_4 :
    ∀ p : PointIndex, orbitIndex (pointAction 4 p) = orbitIndex p := by
  intro p
  rw [pointAction_eq_code_4 p]
  exact orbitIndex_code_4 p

end RelativeConicArcs.Examples.Q11A5PointOrbits
