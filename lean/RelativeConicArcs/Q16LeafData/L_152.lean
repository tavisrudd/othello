import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_152_0 : RejectedLeaf := { leaf := {0,1,17,34,52,70,125,195}, reject := .fullRank { members := ![0,1,17,34,52,70,125,195], points := ![91,94,103,135,137,139], inverse := ![12,5,14,3,9,12,5,11,9,12,15,4,0,0,0,13,8,5,6,9,8,9,3,13,14,14,0,6,8,14,2,2,0,4,12,8] } }
theorem leafL_152_0_valid : (leafL_152_0).reject.ValidFor (leafL_152_0).leaf := by decide

noncomputable def leafL_152_1 : RejectedLeaf := { leaf := {0,1,17,34,52,70,125,211}, reject := .fullRank { members := ![0,1,17,34,52,70,125,211], points := ![91,94,95,103,139,149], inverse := ![10,13,15,0,3,10,15,0,15,2,4,6,8,2,10,0,0,0,5,13,7,8,7,0,0,4,1,3,2,4,6,3,9,4,9,1] } }
theorem leafL_152_1_valid : (leafL_152_1).reject.ValidFor (leafL_152_1).leaf := by decide

noncomputable def leafL_152_2 : RejectedLeaf := { leaf := {0,1,17,34,52,70,125,240}, reject := .fullRank { members := ![0,1,17,34,52,70,125,240], points := ![90,94,95,101,103,131], inverse := ![5,13,1,11,5,6,14,9,9,1,8,7,8,10,2,0,0,0,6,8,1,2,10,7,13,0,13,2,2,0,8,4,12,9,9,0] } }
theorem leafL_152_2_valid : (leafL_152_2).reject.ValidFor (leafL_152_2).leaf := by decide

noncomputable def leafL_152_3 : RejectedLeaf := { leaf := {0,1,17,34,52,70,125,245}, reject := .fullRank { members := ![0,1,17,34,52,70,125,245], points := ![94,103,110,137,139,144], inverse := ![9,1,15,11,8,5,14,0,9,7,7,7,0,0,0,3,12,15,15,6,14,8,13,2,0,4,4,5,14,11,0,11,11,9,14,7] } }
theorem leafL_152_3_valid : (leafL_152_3).reject.ValidFor (leafL_152_3).leaf := by decide

noncomputable def leafL_152_4 : RejectedLeaf := { leaf := {0,1,17,34,52,70,125,251}, reject := .fullRank { members := ![0,1,17,34,52,70,125,251], points := ![94,101,110,131,135,144], inverse := ![9,5,11,12,1,11,14,0,9,8,11,4,0,0,0,1,9,8,15,13,5,8,6,9,0,7,7,9,8,1,0,1,1,0,1,1] } }
theorem leafL_152_4_valid : (leafL_152_4).reject.ValidFor (leafL_152_4).leaf := by decide

noncomputable def leafL_152_5 : RejectedLeaf := { leaf := {0,1,17,34,52,70,127,133}, reject := .fullRank { members := ![0,1,17,34,52,70,127,133], points := ![83,94,107,108,147,151], inverse := ![4,2,12,7,11,7,15,5,15,11,8,6,3,3,10,10,2,2,3,8,6,3,13,3,8,8,3,3,4,4,9,9,7,7,15,15] } }
theorem leafL_152_5_valid : (leafL_152_5).reject.ValidFor (leafL_152_5).leaf := by decide

noncomputable def leafL_152_6 : RejectedLeaf := { leaf := {0,1,17,34,52,70,127,135}, reject := .fullRank { members := ![0,1,17,34,52,70,127,135], points := ![83,89,90,104,108,149], inverse := ![6,0,0,0,11,12,11,2,3,5,1,14,9,12,5,0,0,0,11,11,11,7,2,14,0,5,5,14,14,0,15,2,13,10,10,0] } }
theorem leafL_152_6_valid : (leafL_152_6).reject.ValidFor (leafL_152_6).leaf := by decide

noncomputable def leafL_152_7 : RejectedLeaf := { leaf := {0,1,17,34,52,70,127,140}, reject := .fullRank { members := ![0,1,17,34,52,70,127,140], points := ![89,91,94,101,104,147], inverse := ![15,5,12,7,12,12,13,0,7,12,8,14,12,3,15,0,0,0,8,4,7,0,5,14,5,1,4,13,13,0,5,10,15,14,14,0] } }
theorem leafL_152_7_valid : (leafL_152_7).reject.ValidFor (leafL_152_7).leaf := by decide

noncomputable def leavesL_152 : List RejectedLeaf := [leafL_152_0,leafL_152_1,leafL_152_2,leafL_152_3,leafL_152_4,leafL_152_5,leafL_152_6,leafL_152_7]

theorem leavesL_152_valid : LeafListValid leavesL_152 := by
  intro x hx
  simp only [leavesL_152, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_152_0_valid
  · exact leafL_152_1_valid
  · exact leafL_152_2_valid
  · exact leafL_152_3_valid
  · exact leafL_152_4_valid
  · exact leafL_152_5_valid
  · exact leafL_152_6_valid
  · exact leafL_152_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
