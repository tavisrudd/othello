import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_247_0 : RejectedLeaf := { leaf := {0,1,17,34,52,72,91,101}, reject := .fullRank { members := ![0,1,17,34,52,72,91,101], points := ![115,137,138,141,147,150], inverse := ![4,8,15,9,8,3,3,3,1,10,11,0,0,13,11,6,0,0,2,9,15,15,1,10,0,3,0,3,8,8,0,4,9,13,5,5] } }
theorem leafL_247_0_valid : (leafL_247_0).reject.ValidFor (leafL_247_0).leaf := by decide

noncomputable def leafL_247_1 : RejectedLeaf := { leaf := {0,1,17,34,52,72,91,103}, reject := .fullRank { members := ![0,1,17,34,52,72,91,103], points := ![125,138,143,147,149,159], inverse := ![4,0,14,3,12,4,3,10,2,3,11,3,0,0,0,3,2,1,2,15,6,0,8,3,0,14,14,8,2,10,0,5,5,6,14,8] } }
theorem leafL_247_1_valid : (leafL_247_1).reject.ValidFor (leafL_247_1).leaf := by decide

noncomputable def leafL_247_2 : RejectedLeaf := { leaf := {0,1,17,34,52,72,91,108}, reject := .fullRank { members := ![0,1,17,34,52,72,91,108], points := ![115,125,135,137,141,150], inverse := ![13,9,7,15,6,11,11,8,2,4,14,11,0,0,7,4,3,0,12,14,5,3,15,11,9,9,6,7,1,0,3,3,3,3,0,0] } }
theorem leafL_247_2_valid : (leafL_247_2).reject.ValidFor (leafL_247_2).leaf := by decide

noncomputable def leafL_247_3 : RejectedLeaf := { leaf := {0,1,17,34,52,72,91,115}, reject := .fullRank { members := ![0,1,17,34,52,72,91,115], points := ![101,108,138,143,150,151], inverse := ![1,8,14,3,9,12,14,12,8,12,12,10,2,2,3,3,13,13,8,5,0,1,12,0,12,12,4,4,2,2,12,12,15,15,1,1] } }
theorem leafL_247_3_valid : (leafL_247_3).reject.ValidFor (leafL_247_3).leaf := by decide

noncomputable def leafL_247_4 : RejectedLeaf := { leaf := {0,1,17,34,52,72,91,125}, reject := .fullRank { members := ![0,1,17,34,52,72,91,125], points := ![103,108,112,135,137,147], inverse := ![10,14,13,1,12,5,0,15,13,1,5,6,8,1,9,0,0,0,11,4,2,14,15,12,5,13,8,14,14,0,14,10,4,8,8,0] } }
theorem leafL_247_4_valid : (leafL_247_4).reject.ValidFor (leafL_247_4).leaf := by decide

noncomputable def leafL_247_5 : RejectedLeaf := { leaf := {0,1,17,34,52,72,91,138}, reject := .fullRank { members := ![0,1,17,34,52,72,91,138], points := ![101,103,115,125,147,163], inverse := ![4,7,1,10,13,4,0,0,11,0,3,8,10,15,3,0,11,13,1,15,2,2,5,11,5,7,10,5,1,12,9,14,13,1,10,1] } }
theorem leafL_247_5_valid : (leafL_247_5).reject.ValidFor (leafL_247_5).leaf := by decide

noncomputable def leafL_247_6 : RejectedLeaf := { leaf := {0,1,17,34,52,72,91,147}, reject := .fullRank { members := ![0,1,17,34,52,72,91,147], points := ![101,103,112,117,125,138], inverse := ![11,1,13,2,11,15,9,9,7,2,12,9,11,1,10,0,0,0,0,12,11,15,0,8,2,14,12,2,2,0,8,1,9,5,5,0] } }
theorem leafL_247_6_valid : (leafL_247_6).reject.ValidFor (leafL_247_6).leaf := by decide

noncomputable def leafL_247_7 : RejectedLeaf := { leaf := {0,1,17,34,52,72,91,151}, reject := .fullRank { members := ![0,1,17,34,52,72,91,151], points := ![101,112,115,117,125,141], inverse := ![10,13,14,8,15,15,11,12,2,10,6,9,0,0,9,11,2,0,12,11,4,14,5,8,10,10,7,10,13,0,3,3,9,14,7,0] } }
theorem leafL_247_7_valid : (leafL_247_7).reject.ValidFor (leafL_247_7).leaf := by decide

noncomputable def leavesL_247 : List RejectedLeaf := [leafL_247_0,leafL_247_1,leafL_247_2,leafL_247_3,leafL_247_4,leafL_247_5,leafL_247_6,leafL_247_7]

theorem leavesL_247_valid : LeafListValid leavesL_247 := by
  intro x hx
  simp only [leavesL_247, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_247_0_valid
  · exact leafL_247_1_valid
  · exact leafL_247_2_valid
  · exact leafL_247_3_valid
  · exact leafL_247_4_valid
  · exact leafL_247_5_valid
  · exact leafL_247_6_valid
  · exact leafL_247_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
