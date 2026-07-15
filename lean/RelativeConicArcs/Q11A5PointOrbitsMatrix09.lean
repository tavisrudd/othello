import RelativeConicArcs.Q11A5PointOrbitsData

/-! Matrix rows 45--49 for the Q11 A5 point action. -/

namespace RelativeConicArcs.Examples.Q11A5PointOrbits

set_option maxHeartbeats 100000000
set_option maxRecDepth 100000

private instance : Fact (Nat.Prime 11) := ⟨by decide⟩

theorem matrix_nonsingular_row_45 : matrixDet 45 ≠ 0 := by decide

theorem matrixVec_pointVec_ne_zero_row_45 :
    ∀ p : PointIndex, matrixVec 45 (pointVec p) ≠ 0 := by decide

theorem matrix_nonsingular_row_46 : matrixDet 46 ≠ 0 := by decide

theorem matrixVec_pointVec_ne_zero_row_46 :
    ∀ p : PointIndex, matrixVec 46 (pointVec p) ≠ 0 := by decide

theorem matrix_nonsingular_row_47 : matrixDet 47 ≠ 0 := by decide

theorem matrixVec_pointVec_ne_zero_row_47 :
    ∀ p : PointIndex, matrixVec 47 (pointVec p) ≠ 0 := by decide

theorem matrix_nonsingular_row_48 : matrixDet 48 ≠ 0 := by decide

theorem matrixVec_pointVec_ne_zero_row_48 :
    ∀ p : PointIndex, matrixVec 48 (pointVec p) ≠ 0 := by decide

theorem matrix_nonsingular_row_49 : matrixDet 49 ≠ 0 := by decide

theorem matrixVec_pointVec_ne_zero_row_49 :
    ∀ p : PointIndex, matrixVec 49 (pointVec p) ≠ 0 := by decide

end RelativeConicArcs.Examples.Q11A5PointOrbits
