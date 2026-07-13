import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_146_0 : RejectedLeaf := { leaf := {0,1,17,34,52,70,110,218}, reject := .fullRank { members := ![0,1,17,34,52,70,110,218], points := ![83,89,91,117,125,131], inverse := ![15,5,13,10,4,8,15,6,14,11,2,14,8,6,14,0,0,0,3,10,14,1,9,15,14,5,11,13,13,0,14,0,14,14,14,0] } }
theorem leafL_146_0_valid : (leafL_146_0).reject.ValidFor (leafL_146_0).leaf := by decide

noncomputable def leafL_146_1 : RejectedLeaf := { leaf := {0,1,17,34,52,70,110,220}, reject := .fullRank { members := ![0,1,17,34,52,70,110,220], points := ![90,91,115,117,137,139], inverse := ![1,6,5,11,14,6,14,9,15,6,1,15,13,13,2,2,4,4,11,12,14,6,11,4,14,14,15,15,2,2,1,1,15,15,10,10] } }
theorem leafL_146_1_valid : (leafL_146_1).reject.ValidFor (leafL_146_1).leaf := by decide

noncomputable def leafL_146_2 : RejectedLeaf := { leaf := {0,1,17,34,52,70,110,224}, reject := .fullRank { members := ![0,1,17,34,52,70,110,224], points := ![89,91,115,135,137,139], inverse := ![3,4,14,11,4,7,15,8,9,10,4,0,0,0,0,13,8,5,1,6,8,13,15,13,6,6,0,9,12,5,7,7,0,0,7,7] } }
theorem leafL_146_2_valid : (leafL_146_2).reject.ValidFor (leafL_146_2).leaf := by decide

noncomputable def leafL_146_3 : RejectedLeaf := { leaf := {0,1,17,34,52,70,110,237}, reject := .fullRank { members := ![0,1,17,34,52,70,110,237], points := ![90,91,115,117,127,131], inverse := ![8,15,4,9,3,8,10,13,3,12,6,14,0,0,3,2,1,0,4,3,10,1,3,15,1,1,6,15,9,0,7,7,4,15,11,0] } }
theorem leafL_146_3_valid : (leafL_146_3).reject.ValidFor (leafL_146_3).leaf := by decide

noncomputable def leafL_146_4 : RejectedLeaf := { leaf := {0,1,17,34,52,70,110,245}, reject := .fullRank { members := ![0,1,17,34,52,70,110,245], points := ![89,125,139,144,147,152], inverse := ![6,7,3,12,12,3,13,12,8,5,15,3,7,10,15,9,2,9,14,5,8,13,10,4,8,4,11,6,12,13,0,0,7,7,7,7] } }
theorem leafL_146_4_valid : (leafL_146_4).reject.ValidFor (leafL_146_4).leaf := by decide

noncomputable def leafL_146_5 : RejectedLeaf := { leaf := {0,1,17,34,52,70,110,247}, reject := .fullRank { members := ![0,1,17,34,52,70,110,247], points := ![83,90,91,115,131,137], inverse := ![3,10,14,14,14,6,7,0,0,9,14,0,6,3,5,0,0,0,5,4,6,8,7,8,14,3,13,0,3,3,1,2,3,0,4,4] } }
theorem leafL_146_5_valid : (leafL_146_5).reject.ValidFor (leafL_146_5).leaf := by decide

noncomputable def leafL_146_6 : RejectedLeaf := { leaf := {0,1,17,34,52,70,110,265}, reject := .fullRank { members := ![0,1,17,34,52,70,110,265], points := ![83,90,115,135,139,151], inverse := ![6,15,9,0,4,5,7,2,8,14,14,13,0,1,9,12,11,15,1,9,6,14,10,10,9,7,7,15,3,5,3,15,6,9,11,8] } }
theorem leafL_146_6_valid : (leafL_146_6).reject.ValidFor (leafL_146_6).leaf := by decide

noncomputable def leafL_146_7 : RejectedLeaf := { leaf := {0,1,17,34,52,70,110,269}, reject := .fullRank { members := ![0,1,17,34,52,70,110,269], points := ![83,89,90,115,117,144], inverse := ![11,10,6,8,6,8,2,4,1,2,11,14,9,12,5,0,0,0,7,11,11,10,2,15,14,11,5,14,14,0,5,8,13,10,10,0] } }
theorem leafL_146_7_valid : (leafL_146_7).reject.ValidFor (leafL_146_7).leaf := by decide

noncomputable def leavesL_146 : List RejectedLeaf := [leafL_146_0,leafL_146_1,leafL_146_2,leafL_146_3,leafL_146_4,leafL_146_5,leafL_146_6,leafL_146_7]

theorem leavesL_146_valid : LeafListValid leavesL_146 := by
  intro x hx
  simp only [leavesL_146, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_146_0_valid
  · exact leafL_146_1_valid
  · exact leafL_146_2_valid
  · exact leafL_146_3_valid
  · exact leafL_146_4_valid
  · exact leafL_146_5_valid
  · exact leafL_146_6_valid
  · exact leafL_146_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
