import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_266_0 : RejectedLeaf := { leaf := {0,1,17,34,52,72,125,229}, reject := .fullRank { members := ![0,1,17,34,52,72,125,229], points := ![90,91,108,135,137,147], inverse := ![1,4,10,10,5,1,11,5,9,8,15,0,13,0,10,6,10,11,12,3,8,3,4,0,10,4,11,12,15,6,0,11,8,8,9,2] } }
theorem leafL_266_0_valid : (leafL_266_0).reject.ValidFor (leafL_266_0).leaf := by decide

noncomputable def leafL_266_1 : RejectedLeaf := { leaf := {0,1,17,34,52,72,125,239}, reject := .fullRank { members := ![0,1,17,34,52,72,125,239], points := ![90,103,108,112,137,139], inverse := ![9,1,10,5,3,5,14,1,11,3,13,10,0,8,1,9,0,0,15,7,9,6,2,5,0,7,0,7,12,12,0,11,12,7,13,13] } }
theorem leafL_266_1_valid : (leafL_266_1).reject.ValidFor (leafL_266_1).leaf := by decide

noncomputable def leafL_266_2 : RejectedLeaf := { leaf := {0,1,17,34,52,72,125,240}, reject := .fullRank { members := ![0,1,17,34,52,72,125,240], points := ![90,92,99,103,137,138], inverse := ![7,14,13,3,2,4,13,3,6,15,3,4,2,2,8,8,2,2,1,14,14,6,3,4,10,10,5,5,1,1,5,5,8,8,12,12] } }
theorem leafL_266_2_valid : (leafL_266_2).reject.ValidFor (leafL_266_2).leaf := by decide

noncomputable def leafL_266_3 : RejectedLeaf := { leaf := {0,1,17,34,52,72,125,251}, reject := .fullRank { members := ![0,1,17,34,52,72,125,251], points := ![92,99,103,112,135,138], inverse := ![9,11,1,4,14,8,14,3,12,6,9,14,0,1,9,8,0,0,15,12,1,5,3,4,0,6,4,2,7,7,0,3,9,10,4,4] } }
theorem leafL_266_3_valid : (leafL_266_3).reject.ValidFor (leafL_266_3).leaf := by decide

noncomputable def leafL_266_4 : RejectedLeaf := { leaf := {0,1,17,34,52,72,125,268}, reject := .fullRank { members := ![0,1,17,34,52,72,125,268], points := ![90,91,103,112,137,139], inverse := ![8,1,11,5,7,1,3,13,10,3,12,11,12,12,9,9,5,5,9,6,14,6,9,14,0,0,7,7,12,12,15,15,7,7,4,4] } }
theorem leafL_266_4_valid : (leafL_266_4).reject.ValidFor (leafL_266_4).leaf := by decide

noncomputable def leafL_266_5 : RejectedLeaf := { leaf := {0,1,17,34,52,72,126,135}, reject := .fullRank { members := ![0,1,17,34,52,72,126,135], points := ![92,149,163,166,176,195], inverse := ![10,5,7,4,7,10,2,5,1,15,15,6,0,0,11,14,5,0,6,1,10,1,8,4,9,6,15,9,4,13,1,12,9,6,11,9] } }
theorem leafL_266_5_valid : (leafL_266_5).reject.ValidFor (leafL_266_5).leaf := by decide

noncomputable def leafL_266_6 : RejectedLeaf := { leaf := {0,1,17,34,52,72,126,185}, reject := .fullRank { members := ![0,1,17,34,52,72,126,185], points := ![92,93,96,103,139,149], inverse := ![1,2,11,0,3,10,15,0,15,2,4,6,8,2,10,0,0,0,7,1,9,8,7,0,15,0,10,3,2,4,1,2,15,4,9,1] } }
theorem leafL_266_6_valid : (leafL_266_6).reject.ValidFor (leafL_266_6).leaf := by decide

noncomputable def leafL_266_7 : RejectedLeaf := { leaf := {0,1,17,34,52,72,126,201}, reject := .fullRank { members := ![0,1,17,34,52,72,126,201], points := ![92,96,103,112,143,149], inverse := ![10,14,4,0,10,11,8,15,5,11,12,5,12,15,11,10,15,13,13,2,12,4,7,0,5,10,9,12,6,12,14,10,4,9,7,14] } }
theorem leafL_266_7_valid : (leafL_266_7).reject.ValidFor (leafL_266_7).leaf := by decide

noncomputable def leavesL_266 : List RejectedLeaf := [leafL_266_0,leafL_266_1,leafL_266_2,leafL_266_3,leafL_266_4,leafL_266_5,leafL_266_6,leafL_266_7]

theorem leavesL_266_valid : LeafListValid leavesL_266 := by
  intro x hx
  simp only [leavesL_266, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_266_0_valid
  · exact leafL_266_1_valid
  · exact leafL_266_2_valid
  · exact leafL_266_3_valid
  · exact leafL_266_4_valid
  · exact leafL_266_5_valid
  · exact leafL_266_6_valid
  · exact leafL_266_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
