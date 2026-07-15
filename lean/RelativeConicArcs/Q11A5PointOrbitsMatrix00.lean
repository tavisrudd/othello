import RelativeConicArcs.Q11A5PointOrbitsData

/-! Matrix rows 0--4 for the Q11 A5 point action. -/

namespace RelativeConicArcs.Examples.Q11A5PointOrbits

set_option maxHeartbeats 100000000
set_option maxRecDepth 100000

private instance : Fact (Nat.Prime 11) := ⟨by decide⟩

theorem matrix_nonsingular_row_0 : matrixDet 0 ≠ 0 := by decide

theorem matrixVec_pointVec_ne_zero_row_0 :
    ∀ p : PointIndex, matrixVec 0 (pointVec p) ≠ 0 := by decide

theorem matrix_nonsingular_row_1 : matrixDet 1 ≠ 0 := by decide

theorem matrixVec_pointVec_ne_zero_row_1 :
    ∀ p : PointIndex, matrixVec 1 (pointVec p) ≠ 0 := by decide

theorem matrix_nonsingular_row_2 : matrixDet 2 ≠ 0 := by decide

theorem matrixVec_pointVec_ne_zero_row_2 :
    ∀ p : PointIndex, matrixVec 2 (pointVec p) ≠ 0 := by decide

theorem matrix_nonsingular_row_3 : matrixDet 3 ≠ 0 := by decide

theorem matrixVec_pointVec_ne_zero_row_3 :
    ∀ p : PointIndex, matrixVec 3 (pointVec p) ≠ 0 := by decide

theorem matrix_nonsingular_row_4 : matrixDet 4 ≠ 0 := by decide

theorem matrixVec_pointVec_ne_zero_row_4 :
    ∀ p : PointIndex, matrixVec 4 (pointVec p) ≠ 0 := by decide

end RelativeConicArcs.Examples.Q11A5PointOrbits
