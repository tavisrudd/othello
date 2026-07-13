import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_138_0 : RejectedLeaf := { leaf := {0,1,17,34,52,70,95,184}, reject := .fullRank { members := ![0,1,17,34,52,70,95,184], points := ![109,124,131,133,139,147], inverse := ![9,0,4,3,10,5,14,10,13,5,2,14,0,0,11,9,2,0,15,3,11,11,13,1,8,12,6,15,12,1,5,14,2,15,0,6] } }
theorem leafL_138_0_valid : (leafL_138_0).reject.ValidFor (leafL_138_0).leaf := by decide

noncomputable def leafL_138_1 : RejectedLeaf := { leaf := {0,1,17,34,52,70,95,186}, reject := .fullRank { members := ![0,1,17,34,52,70,95,186], points := ![103,115,124,125,131,133], inverse := ![7,14,4,3,3,12,7,14,8,8,7,14,0,6,12,10,0,0,7,3,15,3,8,0,0,6,13,11,1,1,0,6,10,12,7,7] } }
theorem leafL_138_1_valid : (leafL_138_1).reject.ValidFor (leafL_138_1).leaf := by decide

noncomputable def leafL_138_2 : RejectedLeaf := { leaf := {0,1,17,34,52,70,95,211}, reject := .fullRank { members := ![0,1,17,34,52,70,95,211], points := ![104,109,120,124,125,137], inverse := ![9,14,14,6,1,15,6,1,13,15,12,9,0,0,4,9,13,0,13,10,3,2,14,8,10,10,5,12,9,0,3,3,3,0,3,0] } }
theorem leafL_138_2_valid : (leafL_138_2).reject.ValidFor (leafL_138_2).leaf := by decide

noncomputable def leafL_138_3 : RejectedLeaf := { leaf := {0,1,17,34,52,70,95,220}, reject := .fullRank { members := ![0,1,17,34,52,70,95,220], points := ![120,135,137,139,147,149], inverse := ![4,0,4,10,4,15,3,10,8,10,12,7,0,13,8,5,0,0,2,2,13,6,9,2,0,4,13,9,5,5,0,8,1,9,13,13] } }
theorem leafL_138_3_valid : (leafL_138_3).reject.ValidFor (leafL_138_3).leaf := by decide

noncomputable def leafL_138_4 : RejectedLeaf := { leaf := {0,1,17,34,52,70,95,222}, reject := .fullRank { members := ![0,1,17,34,52,70,95,222], points := ![104,107,115,124,131,139], inverse := ![0,7,7,14,14,1,12,11,3,13,6,15,11,11,11,11,12,12,9,14,3,12,1,9,3,3,13,13,12,12,11,11,9,9,3,3] } }
theorem leafL_138_4_valid : (leafL_138_4).reject.ValidFor (leafL_138_4).leaf := by decide

noncomputable def leafL_138_5 : RejectedLeaf := { leaf := {0,1,17,34,52,70,95,248}, reject := .fullRank { members := ![0,1,17,34,52,70,95,248], points := ![107,109,125,126,131,135], inverse := ![10,13,10,3,11,4,14,9,10,4,4,13,11,11,13,13,9,9,13,10,0,15,2,10,13,13,4,4,14,14,1,1,13,13,6,6] } }
theorem leafL_138_5_valid : (leafL_138_5).reject.ValidFor (leafL_138_5).leaf := by decide

noncomputable def leafL_138_6 : RejectedLeaf := { leaf := {0,1,17,34,52,70,95,249}, reject := .fullRank { members := ![0,1,17,34,52,70,95,249], points := ![103,104,107,115,120,131], inverse := ![14,1,8,6,15,15,1,4,2,14,0,9,10,4,14,0,0,0,11,9,5,12,3,8,9,3,10,14,14,0,5,15,10,8,8,0] } }
theorem leafL_138_6_valid : (leafL_138_6).reject.ValidFor (leafL_138_6).leaf := by decide

noncomputable def leafL_138_7 : RejectedLeaf := { leaf := {0,1,17,34,52,70,95,256}, reject := .fullRank { members := ![0,1,17,34,52,70,95,256], points := ![103,109,115,126,133,139], inverse := ![3,4,3,10,1,14,0,7,9,7,5,12,2,2,9,9,8,8,14,9,1,14,5,13,1,1,0,0,14,14,2,2,1,1,11,11] } }
theorem leafL_138_7_valid : (leafL_138_7).reject.ValidFor (leafL_138_7).leaf := by decide

noncomputable def leavesL_138 : List RejectedLeaf := [leafL_138_0,leafL_138_1,leafL_138_2,leafL_138_3,leafL_138_4,leafL_138_5,leafL_138_6,leafL_138_7]

theorem leavesL_138_valid : LeafListValid leavesL_138 := by
  intro x hx
  simp only [leavesL_138, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_138_0_valid
  · exact leafL_138_1_valid
  · exact leafL_138_2_valid
  · exact leafL_138_3_valid
  · exact leafL_138_4_valid
  · exact leafL_138_5_valid
  · exact leafL_138_6_valid
  · exact leafL_138_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
