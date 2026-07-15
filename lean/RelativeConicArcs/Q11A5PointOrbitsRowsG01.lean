import RelativeConicArcs.Q11A5PointOrbitsArithmetic

/-! Arithmetic row 1 for the Q11 A5 point action. -/

namespace RelativeConicArcs.Examples.Q11A5PointOrbits

set_option maxHeartbeats 100000000
set_option maxRecDepth 100000

private instance : Fact (Nat.Prime 11) := ⟨by decide⟩

theorem action_on_witness_row_1 :
    ∀ i : Fin 6, pointAction 1 (witnessIndex i) = witnessIndex (supportPerm 1 i) := by
  intro i
  rw [pointAction_eq_fast]
  revert i
  decide

/-- Canonical point-action values for group row 1. -/
def pointActionCode_1 (p : PointIndex) : PointIndex :=
  ![
    103, 89, 41, 86, 27, 13, 117, 44, 124, 72, 10, 39,
    111, 5, 77, 54, 107, 24, 125, 92, 20, 73, 71, 45,
    17, 84, 97, 4, 123, 112, 30, 43, 99, 96, 67, 114,
    87, 105, 130, 11, 40, 2, 49, 31, 7, 23, 66, 85,
    129, 42, 50, 93, 120, 101, 15, 64, 56, 65, 132, 62,
    60, 63, 59, 61, 55, 57, 46, 34, 122, 82, 70, 22,
    9, 21, 106, 118, 94, 14, 121, 102, 80, 113, 69, 91,
    25, 47, 3, 36, 128, 1, 90, 83, 19, 51, 76, 108,
    33, 26, 115, 32, 100, 53, 79, 0, 116, 37, 74, 16,
    95, 126, 110, 12, 29, 81, 35, 98, 104, 6, 75, 127,
    52, 78, 68, 28, 8, 18, 109, 119, 88, 48, 38, 131,
    58
  ] p

/-- Numeric matrix normalization for group row 1, independent of orbit lookup. -/
theorem pointAction_eq_code_1 : ∀ p : PointIndex, pointAction 1 p = pointActionCode_1 p := by
  intro p
  rw [pointAction_eq_fast]
  revert p
  decide

/-- Pure table lookup: group row 1 preserves the orbit label. -/
theorem orbitIndex_code_1 : ∀ p : PointIndex, orbitIndex (pointActionCode_1 p) = orbitIndex p := by
  decide

theorem orbitIndex_pointAction_row_1 :
    ∀ p : PointIndex, orbitIndex (pointAction 1 p) = orbitIndex p := by
  intro p
  rw [pointAction_eq_code_1 p]
  exact orbitIndex_code_1 p

end RelativeConicArcs.Examples.Q11A5PointOrbits
