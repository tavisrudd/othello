import RelativeConicArcs.Q11A5PointOrbitsData

/-! Matrix rows 35--39 for the Q11 A5 point action. -/

namespace RelativeConicArcs.Examples.Q11A5PointOrbits

set_option maxHeartbeats 100000000
set_option maxRecDepth 100000

private instance : Fact (Nat.Prime 11) := ⟨by decide⟩

theorem matrix_nonsingular_row_35 : matrixDet 35 ≠ 0 := by decide

theorem matrixVec_pointVec_ne_zero_row_35 :
    ∀ p : PointIndex, matrixVec 35 (pointVec p) ≠ 0 := by decide

theorem matrix_nonsingular_row_36 : matrixDet 36 ≠ 0 := by decide

theorem matrixVec_pointVec_ne_zero_row_36 :
    ∀ p : PointIndex, matrixVec 36 (pointVec p) ≠ 0 := by decide

theorem matrix_nonsingular_row_37 : matrixDet 37 ≠ 0 := by decide

theorem matrixVec_pointVec_ne_zero_row_37 :
    ∀ p : PointIndex, matrixVec 37 (pointVec p) ≠ 0 := by decide

theorem matrix_nonsingular_row_38 : matrixDet 38 ≠ 0 := by decide

theorem matrixVec_pointVec_ne_zero_row_38 :
    ∀ p : PointIndex, matrixVec 38 (pointVec p) ≠ 0 := by decide

theorem matrix_nonsingular_row_39 : matrixDet 39 ≠ 0 := by decide

theorem matrixVec_pointVec_ne_zero_row_39 :
    ∀ p : PointIndex, matrixVec 39 (pointVec p) ≠ 0 := by decide

end RelativeConicArcs.Examples.Q11A5PointOrbits
