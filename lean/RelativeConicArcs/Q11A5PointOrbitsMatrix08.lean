import RelativeConicArcs.Q11A5PointOrbitsData

/-! Matrix rows 40--44 for the Q11 A5 point action. -/

namespace RelativeConicArcs.Examples.Q11A5PointOrbits

set_option maxHeartbeats 100000000
set_option maxRecDepth 100000

private instance : Fact (Nat.Prime 11) := ⟨by decide⟩

theorem matrix_nonsingular_row_40 : matrixDet 40 ≠ 0 := by decide

theorem matrixVec_pointVec_ne_zero_row_40 :
    ∀ p : PointIndex, matrixVec 40 (pointVec p) ≠ 0 := by decide

theorem matrix_nonsingular_row_41 : matrixDet 41 ≠ 0 := by decide

theorem matrixVec_pointVec_ne_zero_row_41 :
    ∀ p : PointIndex, matrixVec 41 (pointVec p) ≠ 0 := by decide

theorem matrix_nonsingular_row_42 : matrixDet 42 ≠ 0 := by decide

theorem matrixVec_pointVec_ne_zero_row_42 :
    ∀ p : PointIndex, matrixVec 42 (pointVec p) ≠ 0 := by decide

theorem matrix_nonsingular_row_43 : matrixDet 43 ≠ 0 := by decide

theorem matrixVec_pointVec_ne_zero_row_43 :
    ∀ p : PointIndex, matrixVec 43 (pointVec p) ≠ 0 := by decide

theorem matrix_nonsingular_row_44 : matrixDet 44 ≠ 0 := by decide

theorem matrixVec_pointVec_ne_zero_row_44 :
    ∀ p : PointIndex, matrixVec 44 (pointVec p) ≠ 0 := by decide

end RelativeConicArcs.Examples.Q11A5PointOrbits
