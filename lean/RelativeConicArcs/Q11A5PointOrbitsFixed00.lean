import RelativeConicArcs.Q11A5PointOrbitsFixedFast

/-! Fixed-union point rows 0--18 for the Q11 A5 action. -/

namespace RelativeConicArcs.Examples.Q11A5PointOrbits

set_option maxHeartbeats 100000000
set_option maxRecDepth 100000

private instance : Fact (Nat.Prime 11) := ⟨by decide⟩

theorem orderFiveFixedUnion_mem_0 :
    (0 : PointIndex) ∈ orderFiveFixedUnion ↔
      (0 : PointIndex) ∈ witnessSet ∪ standardConicIndices := by
  rw [orderFiveFixedUnion_eq_fast, orderFiveFixedUnionFast_eq_expected]

theorem orderFiveFixedUnion_mem_1 :
    (1 : PointIndex) ∈ orderFiveFixedUnion ↔
      (1 : PointIndex) ∈ witnessSet ∪ standardConicIndices := by
  rw [orderFiveFixedUnion_eq_fast, orderFiveFixedUnionFast_eq_expected]

theorem orderFiveFixedUnion_mem_2 :
    (2 : PointIndex) ∈ orderFiveFixedUnion ↔
      (2 : PointIndex) ∈ witnessSet ∪ standardConicIndices := by
  rw [orderFiveFixedUnion_eq_fast, orderFiveFixedUnionFast_eq_expected]

theorem orderFiveFixedUnion_mem_3 :
    (3 : PointIndex) ∈ orderFiveFixedUnion ↔
      (3 : PointIndex) ∈ witnessSet ∪ standardConicIndices := by
  rw [orderFiveFixedUnion_eq_fast, orderFiveFixedUnionFast_eq_expected]

theorem orderFiveFixedUnion_mem_4 :
    (4 : PointIndex) ∈ orderFiveFixedUnion ↔
      (4 : PointIndex) ∈ witnessSet ∪ standardConicIndices := by
  rw [orderFiveFixedUnion_eq_fast, orderFiveFixedUnionFast_eq_expected]

theorem orderFiveFixedUnion_mem_5 :
    (5 : PointIndex) ∈ orderFiveFixedUnion ↔
      (5 : PointIndex) ∈ witnessSet ∪ standardConicIndices := by
  rw [orderFiveFixedUnion_eq_fast, orderFiveFixedUnionFast_eq_expected]

theorem orderFiveFixedUnion_mem_6 :
    (6 : PointIndex) ∈ orderFiveFixedUnion ↔
      (6 : PointIndex) ∈ witnessSet ∪ standardConicIndices := by
  rw [orderFiveFixedUnion_eq_fast, orderFiveFixedUnionFast_eq_expected]

theorem orderFiveFixedUnion_mem_7 :
    (7 : PointIndex) ∈ orderFiveFixedUnion ↔
      (7 : PointIndex) ∈ witnessSet ∪ standardConicIndices := by
  rw [orderFiveFixedUnion_eq_fast, orderFiveFixedUnionFast_eq_expected]

theorem orderFiveFixedUnion_mem_8 :
    (8 : PointIndex) ∈ orderFiveFixedUnion ↔
      (8 : PointIndex) ∈ witnessSet ∪ standardConicIndices := by
  rw [orderFiveFixedUnion_eq_fast, orderFiveFixedUnionFast_eq_expected]

theorem orderFiveFixedUnion_mem_9 :
    (9 : PointIndex) ∈ orderFiveFixedUnion ↔
      (9 : PointIndex) ∈ witnessSet ∪ standardConicIndices := by
  rw [orderFiveFixedUnion_eq_fast, orderFiveFixedUnionFast_eq_expected]

theorem orderFiveFixedUnion_mem_10 :
    (10 : PointIndex) ∈ orderFiveFixedUnion ↔
      (10 : PointIndex) ∈ witnessSet ∪ standardConicIndices := by
  rw [orderFiveFixedUnion_eq_fast, orderFiveFixedUnionFast_eq_expected]

theorem orderFiveFixedUnion_mem_11 :
    (11 : PointIndex) ∈ orderFiveFixedUnion ↔
      (11 : PointIndex) ∈ witnessSet ∪ standardConicIndices := by
  rw [orderFiveFixedUnion_eq_fast, orderFiveFixedUnionFast_eq_expected]

theorem orderFiveFixedUnion_mem_12 :
    (12 : PointIndex) ∈ orderFiveFixedUnion ↔
      (12 : PointIndex) ∈ witnessSet ∪ standardConicIndices := by
  rw [orderFiveFixedUnion_eq_fast, orderFiveFixedUnionFast_eq_expected]

theorem orderFiveFixedUnion_mem_13 :
    (13 : PointIndex) ∈ orderFiveFixedUnion ↔
      (13 : PointIndex) ∈ witnessSet ∪ standardConicIndices := by
  rw [orderFiveFixedUnion_eq_fast, orderFiveFixedUnionFast_eq_expected]

theorem orderFiveFixedUnion_mem_14 :
    (14 : PointIndex) ∈ orderFiveFixedUnion ↔
      (14 : PointIndex) ∈ witnessSet ∪ standardConicIndices := by
  rw [orderFiveFixedUnion_eq_fast, orderFiveFixedUnionFast_eq_expected]

theorem orderFiveFixedUnion_mem_15 :
    (15 : PointIndex) ∈ orderFiveFixedUnion ↔
      (15 : PointIndex) ∈ witnessSet ∪ standardConicIndices := by
  rw [orderFiveFixedUnion_eq_fast, orderFiveFixedUnionFast_eq_expected]

theorem orderFiveFixedUnion_mem_16 :
    (16 : PointIndex) ∈ orderFiveFixedUnion ↔
      (16 : PointIndex) ∈ witnessSet ∪ standardConicIndices := by
  rw [orderFiveFixedUnion_eq_fast, orderFiveFixedUnionFast_eq_expected]

theorem orderFiveFixedUnion_mem_17 :
    (17 : PointIndex) ∈ orderFiveFixedUnion ↔
      (17 : PointIndex) ∈ witnessSet ∪ standardConicIndices := by
  rw [orderFiveFixedUnion_eq_fast, orderFiveFixedUnionFast_eq_expected]

theorem orderFiveFixedUnion_mem_18 :
    (18 : PointIndex) ∈ orderFiveFixedUnion ↔
      (18 : PointIndex) ∈ witnessSet ∪ standardConicIndices := by
  rw [orderFiveFixedUnion_eq_fast, orderFiveFixedUnionFast_eq_expected]

end RelativeConicArcs.Examples.Q11A5PointOrbits
