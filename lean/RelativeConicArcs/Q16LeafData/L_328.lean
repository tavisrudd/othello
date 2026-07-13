import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_328_0 : RejectedLeaf := { leaf := {0,1,17,34,52,101,124,141}, reject := .fullRank { members := ![0,1,17,34,52,101,124,141], points := ![70,71,72,83,147,158], inverse := ![7,15,0,12,7,2,8,15,10,9,4,0,7,14,9,0,0,0,11,0,8,12,0,15,15,3,12,0,1,1,9,4,13,0,14,14] } }
theorem leafL_328_0_valid : (leafL_328_0).reject.ValidFor (leafL_328_0).leaf := by decide

noncomputable def leafL_328_1 : RejectedLeaf := { leaf := {0,1,17,34,52,101,124,158}, reject := .fullRank { members := ![0,1,17,34,52,101,124,158], points := ![70,71,79,83,90,137], inverse := ![13,11,7,3,2,1,12,1,5,10,8,10,3,5,6,0,0,0,15,14,10,12,4,3,15,1,14,4,4,0,13,0,13,13,13,0] } }
theorem leafL_328_1_valid : (leafL_328_1).reject.ValidFor (leafL_328_1).leaf := by decide

noncomputable def leafL_328_2 : RejectedLeaf := { leaf := {0,1,17,34,52,107,120,239}, reject := .fullRank { members := ![0,1,17,34,52,107,120,239], points := ![70,73,94,131,133,137], inverse := ![2,3,1,8,2,11,13,5,2,5,0,15,0,0,0,2,3,1,9,2,8,3,1,1,7,7,0,1,6,7,1,1,0,9,15,6] } }
theorem leafL_328_2_valid : (leafL_328_2).reject.ValidFor (leafL_328_2).leaf := by decide

noncomputable def leafL_328_3 : RejectedLeaf := { leaf := {0,1,17,34,52,107,121,138}, reject := .fullRank { members := ![0,1,17,34,52,107,121,138], points := ![67,92,150,152,166,172], inverse := ![9,3,15,7,3,0,7,5,0,15,6,11,9,14,8,7,10,2,10,2,14,14,13,5,4,9,1,0,4,8,6,4,3,11,2,8] } }
theorem leafL_328_3_valid : (leafL_328_3).reject.ValidFor (leafL_328_3).leaf := by decide

noncomputable def leafL_328_4 : RejectedLeaf := { leaf := {0,1,17,34,52,107,156,205}, reject := .fullRank { members := ![0,1,17,34,52,107,156,205], points := ![67,69,86,94,96,117], inverse := ![3,0,5,6,14,15,0,15,13,11,5,12,0,0,8,14,6,0,4,9,3,11,7,2,4,4,12,12,0,0,1,1,7,11,12,0] } }
theorem leafL_328_4_valid : (leafL_328_4).reject.ValidFor (leafL_328_4).leaf := by decide

noncomputable def leafL_328_5 : RejectedLeaf := { leaf := {0,1,17,34,52,110,128,143}, reject := .fullRank { members := ![0,1,17,34,52,110,128,143], points := ![67,93,147,151,156,169], inverse := ![0,13,0,0,7,11,4,7,13,0,6,8,0,0,9,1,8,0,6,10,7,6,2,15,2,13,12,2,7,6,13,7,2,3,15,4] } }
theorem leafL_328_5_valid : (leafL_328_5).reject.ValidFor (leafL_328_5).leaf := by decide

noncomputable def leafL_328_6 : RejectedLeaf := { leaf := {0,1,17,34,52,128,138,171}, reject := .fullRank { members := ![0,1,17,34,52,128,138,171], points := ![69,71,78,83,86,99], inverse := ![9,15,1,5,1,2,9,10,2,6,0,7,1,11,10,0,0,0,6,0,7,9,14,6,10,3,9,9,9,0,14,5,11,7,7,0] } }
theorem leafL_328_6_valid : (leafL_328_6).reject.ValidFor (leafL_328_6).leaf := by decide

noncomputable def leafL_328_7 : RejectedLeaf := { leaf := {0,1,17,34,54,99,125,200}, reject := .forcedHit { members := ![0,1,17,34,54,99,125,200], points := ![140,158,191,215,233,140], coeffs := ![12,0,9,0,4,0], hit := 125 } }
theorem leafL_328_7_valid : (leafL_328_7).reject.ValidFor (leafL_328_7).leaf := by decide

noncomputable def leavesL_328 : List RejectedLeaf := [leafL_328_0,leafL_328_1,leafL_328_2,leafL_328_3,leafL_328_4,leafL_328_5,leafL_328_6,leafL_328_7]

theorem leavesL_328_valid : LeafListValid leavesL_328 := by
  intro x hx
  simp only [leavesL_328, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_328_0_valid
  · exact leafL_328_1_valid
  · exact leafL_328_2_valid
  · exact leafL_328_3_valid
  · exact leafL_328_4_valid
  · exact leafL_328_5_valid
  · exact leafL_328_6_valid
  · exact leafL_328_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
