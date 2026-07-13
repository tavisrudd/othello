import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_156_0 : RejectedLeaf := { leaf := {0,1,17,34,52,70,137,195}, reject := .fullRank { members := ![0,1,17,34,52,70,137,195], points := ![91,94,103,109,125,127], inverse := ![9,6,3,11,4,2,8,1,6,8,8,15,8,8,2,2,5,5,14,6,3,12,10,13,8,8,9,9,13,13,4,4,5,5,12,12] } }
theorem leafL_156_0_valid : (leafL_156_0).reject.ValidFor (leafL_156_0).leaf := by decide

noncomputable def leafL_156_1 : RejectedLeaf := { leaf := {0,1,17,34,52,70,137,245}, reject := .fullRank { members := ![0,1,17,34,52,70,137,245], points := ![94,95,96,103,108,120], inverse := ![3,15,3,7,15,6,1,6,14,3,13,7,7,14,9,0,0,0,2,15,5,9,6,7,15,8,7,3,3,0,2,5,7,4,4,0] } }
theorem leafL_156_1_valid : (leafL_156_1).reject.ValidFor (leafL_156_1).leaf := by decide

noncomputable def leafL_156_2 : RejectedLeaf := { leaf := {0,1,17,34,52,70,137,247}, reject := .fullRank { members := ![0,1,17,34,52,70,137,247], points := ![83,96,107,110,124,127], inverse := ![10,5,8,0,13,11,5,12,1,15,14,9,10,10,10,10,7,7,5,13,0,15,15,8,10,10,6,6,9,9,12,12,14,14,3,3] } }
theorem leafL_156_2_valid : (leafL_156_2).reject.ValidFor (leafL_156_2).leaf := by decide

noncomputable def leafL_156_3 : RejectedLeaf := { leaf := {0,1,17,34,52,70,140,158}, reject := .fullRank { members := ![0,1,17,34,52,70,140,158], points := ![91,101,107,115,120,122], inverse := ![15,9,1,5,10,9,9,0,14,15,13,5,0,0,0,1,14,15,8,10,5,15,7,15,0,6,6,14,14,0,0,1,1,0,1,1] } }
theorem leafL_156_3_valid : (leafL_156_3).reject.ValidFor (leafL_156_3).leaf := by decide

noncomputable def leafL_156_4 : RejectedLeaf := { leaf := {0,1,17,34,52,70,140,195}, reject := .fullRank { members := ![0,1,17,34,52,70,140,195], points := ![89,91,94,104,126,151], inverse := ![12,15,5,11,0,12,7,2,9,3,14,1,12,3,15,0,0,0,2,7,5,10,13,7,5,10,9,7,14,15,5,12,1,5,10,7] } }
theorem leafL_156_4_valid : (leafL_156_4).reject.ValidFor (leafL_156_4).leaf := by decide

noncomputable def leafL_156_5 : RejectedLeaf := { leaf := {0,1,17,34,52,70,140,237}, reject := .fullRank { members := ![0,1,17,34,52,70,140,237], points := ![91,96,104,107,115,127], inverse := ![13,2,10,2,0,6,13,4,10,4,13,10,4,4,10,10,1,1,7,15,8,7,2,5,13,13,14,14,3,3,13,13,11,11,8,8] } }
theorem leafL_156_5_valid : (leafL_156_5).reject.ValidFor (leafL_156_5).leaf := by decide

noncomputable def leafL_156_6 : RejectedLeaf := { leaf := {0,1,17,34,52,70,140,245}, reject := .fullRank { members := ![0,1,17,34,52,70,140,245], points := ![89,94,104,120,122,147], inverse := ![14,10,7,8,3,9,13,6,2,11,7,5,2,12,2,2,6,8,2,3,12,9,8,12,14,14,0,6,6,0,7,3,11,3,6,10] } }
theorem leafL_156_6_valid : (leafL_156_6).reject.ValidFor (leafL_156_6).leaf := by decide

noncomputable def leafL_156_7 : RejectedLeaf := { leaf := {0,1,17,34,52,70,140,251}, reject := .fullRank { members := ![0,1,17,34,52,70,140,251], points := ![89,101,104,115,126,149], inverse := ![12,13,15,0,1,14,7,6,10,13,14,8,12,8,6,7,8,13,2,13,11,5,3,2,5,9,4,4,13,1,5,13,0,6,15,1] } }
theorem leafL_156_7_valid : (leafL_156_7).reject.ValidFor (leafL_156_7).leaf := by decide

noncomputable def leavesL_156 : List RejectedLeaf := [leafL_156_0,leafL_156_1,leafL_156_2,leafL_156_3,leafL_156_4,leafL_156_5,leafL_156_6,leafL_156_7]

theorem leavesL_156_valid : LeafListValid leavesL_156 := by
  intro x hx
  simp only [leavesL_156, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_156_0_valid
  · exact leafL_156_1_valid
  · exact leafL_156_2_valid
  · exact leafL_156_3_valid
  · exact leafL_156_4_valid
  · exact leafL_156_5_valid
  · exact leafL_156_6_valid
  · exact leafL_156_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
