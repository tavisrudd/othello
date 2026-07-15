import RelativeConicArcs.Q11A5PointOrbitsArithmetic

/-! Arithmetic row 0 for the Q11 A5 point action. -/

namespace RelativeConicArcs.Examples.Q11A5PointOrbits

set_option maxHeartbeats 100000000
set_option maxRecDepth 100000

private instance : Fact (Nat.Prime 11) := ⟨by decide⟩

theorem action_on_witness_row_0 :
    ∀ i : Fin 6, pointAction 0 (witnessIndex i) = witnessIndex (supportPerm 0 i) := by
  intro i
  rw [pointAction_eq_fast]
  revert i
  decide

/-- Canonical point-action values for group row 0. -/
def pointActionCode_0 (p : PointIndex) : PointIndex :=
  ![
    0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11,
    12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23,
    24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35,
    36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47,
    48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59,
    60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71,
    72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83,
    84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95,
    96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107,
    108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119,
    120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131,
    132
  ] p

/-- Numeric matrix normalization for group row 0, independent of orbit lookup. -/
theorem pointAction_eq_code_0 : ∀ p : PointIndex, pointAction 0 p = pointActionCode_0 p := by
  intro p
  rw [pointAction_eq_fast]
  revert p
  decide

/-- Pure table lookup: group row 0 preserves the orbit label. -/
theorem orbitIndex_code_0 : ∀ p : PointIndex, orbitIndex (pointActionCode_0 p) = orbitIndex p := by
  decide

theorem orbitIndex_pointAction_row_0 :
    ∀ p : PointIndex, orbitIndex (pointAction 0 p) = orbitIndex p := by
  intro p
  rw [pointAction_eq_code_0 p]
  exact orbitIndex_code_0 p

end RelativeConicArcs.Examples.Q11A5PointOrbits
