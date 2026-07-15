import RelativeConicArcs.Q11A5PointOrbitsData

/-! Matrix rows 10--14 for the Q11 A5 point action. -/

namespace RelativeConicArcs.Examples.Q11A5PointOrbits

set_option maxHeartbeats 100000000
set_option maxRecDepth 100000

private instance : Fact (Nat.Prime 11) := ⟨by decide⟩

theorem matrix_nonsingular_row_10 : matrixDet 10 ≠ 0 := by decide

theorem matrixVec_pointVec_ne_zero_row_10 :
    ∀ p : PointIndex, matrixVec 10 (pointVec p) ≠ 0 := by decide

theorem matrix_nonsingular_row_11 : matrixDet 11 ≠ 0 := by decide

theorem matrixVec_pointVec_ne_zero_row_11 :
    ∀ p : PointIndex, matrixVec 11 (pointVec p) ≠ 0 := by decide

theorem matrix_nonsingular_row_12 : matrixDet 12 ≠ 0 := by decide

theorem matrixVec_pointVec_ne_zero_row_12 :
    ∀ p : PointIndex, matrixVec 12 (pointVec p) ≠ 0 := by decide

theorem matrix_nonsingular_row_13 : matrixDet 13 ≠ 0 := by decide

theorem matrixVec_pointVec_ne_zero_row_13 :
    ∀ p : PointIndex, matrixVec 13 (pointVec p) ≠ 0 := by decide

theorem matrix_nonsingular_row_14 : matrixDet 14 ≠ 0 := by decide

theorem matrixVec_pointVec_ne_zero_row_14 :
    ∀ p : PointIndex, matrixVec 14 (pointVec p) ≠ 0 := by decide

end RelativeConicArcs.Examples.Q11A5PointOrbits
