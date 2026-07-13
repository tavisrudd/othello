import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_127_0 : RejectedLeaf := { leaf := {0,1,17,34,52,70,90,222}, reject := .fullRank { members := ![0,1,17,34,52,70,90,222], points := ![109,115,124,127,131,139], inverse := ![7,1,3,11,12,3,7,3,7,10,2,11,0,7,5,2,0,0,7,8,9,14,14,6,0,5,8,13,4,4,0,5,7,2,15,15] } }
theorem leafL_127_0_valid : (leafL_127_0).reject.ValidFor (leafL_127_0).leaf := by decide

noncomputable def leafL_127_1 : RejectedLeaf := { leaf := {0,1,17,34,52,70,90,223}, reject := .fullRank { members := ![0,1,17,34,52,70,90,223], points := ![108,115,135,144,147,151], inverse := ![1,12,3,11,9,13,2,0,6,2,2,4,13,2,13,5,14,9,14,11,5,14,5,11,5,14,14,3,2,4,9,4,10,9,13,3] } }
theorem leafL_127_1_valid : (leafL_127_1).reject.ValidFor (leafL_127_1).leaf := by decide

noncomputable def leafL_127_2 : RejectedLeaf := { leaf := {0,1,17,34,52,70,90,224}, reject := .fullRank { members := ![0,1,17,34,52,70,90,224], points := ![101,108,109,115,124,133], inverse := ![13,1,11,4,13,15,10,12,1,10,4,9,1,5,4,0,0,0,4,7,4,14,1,8,6,1,7,6,6,0,11,3,8,15,15,0] } }
theorem leafL_127_2_valid : (leafL_127_2).reject.ValidFor (leafL_127_2).leaf := by decide

noncomputable def leafL_127_3 : RejectedLeaf := { leaf := {0,1,17,34,52,70,90,231}, reject := .fullRank { members := ![0,1,17,34,52,70,90,231], points := ![108,109,115,124,125,139], inverse := ![7,0,3,4,14,15,6,1,10,11,15,9,0,0,6,12,10,0,1,6,13,5,7,8,12,12,1,8,9,0,2,2,0,2,2,0] } }
theorem leafL_127_3_valid : (leafL_127_3).reject.ValidFor (leafL_127_3).leaf := by decide

noncomputable def leafL_127_4 : RejectedLeaf := { leaf := {0,1,17,34,52,70,90,233}, reject := .fullRank { members := ![0,1,17,34,52,70,90,233], points := ![101,109,124,127,131,133], inverse := ![6,1,12,5,0,15,9,14,4,10,13,4,10,10,6,6,14,14,9,14,12,3,2,10,12,12,0,0,4,4,13,13,1,1,6,6] } }
theorem leafL_127_4_valid : (leafL_127_4).reject.ValidFor (leafL_127_4).leaf := by decide

noncomputable def leafL_127_5 : RejectedLeaf := { leaf := {0,1,17,34,52,70,90,237}, reject := .fullRank { members := ![0,1,17,34,52,70,90,237], points := ![110,115,131,139,144,149], inverse := ![1,12,14,8,14,4,11,4,6,9,8,8,0,0,9,3,10,0,2,1,4,4,5,6,5,14,6,15,4,6,13,2,8,15,15,7] } }
theorem leafL_127_5_valid : (leafL_127_5).reject.ValidFor (leafL_127_5).leaf := by decide

noncomputable def leafL_127_6 : RejectedLeaf := { leaf := {0,1,17,34,52,70,90,243}, reject := .fullRank { members := ![0,1,17,34,52,70,90,243], points := ![109,124,125,127,133,135], inverse := ![7,5,9,5,1,14,7,5,15,4,11,2,0,15,3,12,0,0,7,15,10,10,8,0,0,13,12,1,3,3,0,0,9,9,9,9] } }
theorem leafL_127_6_valid : (leafL_127_6).reject.ValidFor (leafL_127_6).leaf := by decide

noncomputable def leafL_127_7 : RejectedLeaf := { leaf := {0,1,17,34,52,70,90,247}, reject := .fullRank { members := ![0,1,17,34,52,70,90,247], points := ![110,115,124,126,139,144], inverse := ![7,11,1,3,1,14,7,9,12,11,11,2,0,3,14,13,0,0,7,4,15,4,8,0,0,7,2,5,15,15,0,5,6,3,11,11] } }
theorem leafL_127_7_valid : (leafL_127_7).reject.ValidFor (leafL_127_7).leaf := by decide

noncomputable def leavesL_127 : List RejectedLeaf := [leafL_127_0,leafL_127_1,leafL_127_2,leafL_127_3,leafL_127_4,leafL_127_5,leafL_127_6,leafL_127_7]

theorem leavesL_127_valid : LeafListValid leavesL_127 := by
  intro x hx
  simp only [leavesL_127, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_127_0_valid
  · exact leafL_127_1_valid
  · exact leafL_127_2_valid
  · exact leafL_127_3_valid
  · exact leafL_127_4_valid
  · exact leafL_127_5_valid
  · exact leafL_127_6_valid
  · exact leafL_127_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
