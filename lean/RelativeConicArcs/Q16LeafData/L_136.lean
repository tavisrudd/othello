import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_136_0 : RejectedLeaf := { leaf := {0,1,17,34,52,70,94,263}, reject := .fullRank { members := ![0,1,17,34,52,70,94,263], points := ![101,104,107,127,144,152], inverse := ![11,2,2,3,1,8,15,4,11,3,8,11,1,13,12,0,0,0,1,0,3,1,5,6,5,6,11,12,5,1,7,13,13,13,1,11] } }
theorem leafL_136_0_valid : (leafL_136_0).reject.ValidFor (leafL_136_0).leaf := by decide

noncomputable def leafL_136_1 : RejectedLeaf := { leaf := {0,1,17,34,52,70,94,264}, reject := .fullRank { members := ![0,1,17,34,52,70,94,264], points := ![103,108,122,124,125,133], inverse := ![12,11,8,7,6,15,10,13,13,13,14,9,0,0,12,3,15,0,11,12,12,13,14,8,8,8,0,10,10,0,13,13,14,8,6,0] } }
theorem leafL_136_1_valid : (leafL_136_1).reject.ValidFor (leafL_136_1).leaf := by decide

noncomputable def leafL_136_2 : RejectedLeaf := { leaf := {0,1,17,34,52,70,94,265}, reject := .fullRank { members := ![0,1,17,34,52,70,94,265], points := ![101,103,108,124,135,152], inverse := ![13,10,15,8,11,10,8,13,15,12,1,7,4,2,6,0,0,0,4,10,6,14,12,10,12,2,11,14,13,6,6,3,4,8,6,15] } }
theorem leafL_136_2_valid : (leafL_136_2).reject.ValidFor (leafL_136_2).leaf := by decide

noncomputable def leafL_136_3 : RejectedLeaf := { leaf := {0,1,17,34,52,70,94,267}, reject := .fullRank { members := ![0,1,17,34,52,70,94,267], points := ![101,104,122,133,137,144], inverse := ![7,0,9,15,15,15,4,3,14,0,10,3,0,0,0,4,9,13,14,9,15,15,15,8,6,6,0,2,2,0,7,7,0,8,2,10] } }
theorem leafL_136_3_valid : (leafL_136_3).reject.ValidFor (leafL_136_3).leaf := by decide

noncomputable def leafL_136_4 : RejectedLeaf := { leaf := {0,1,17,34,52,70,95,107}, reject := .fullRank { members := ![0,1,17,34,52,70,95,107], points := ![115,120,124,133,137,149], inverse := ![3,6,1,12,2,11,13,11,5,8,0,11,5,2,7,0,0,0,7,13,8,7,14,11,9,8,1,9,9,0,0,10,10,10,10,0] } }
theorem leafL_136_4_valid : (leafL_136_4).reject.ValidFor (leafL_136_4).leaf := by decide

noncomputable def leafL_136_5 : RejectedLeaf := { leaf := {0,1,17,34,52,70,95,120}, reject := .fullRank { members := ![0,1,17,34,52,70,95,120], points := ![103,107,109,133,137,147], inverse := ![14,1,6,6,11,5,3,14,15,6,2,6,1,3,2,0,0,0,12,3,2,2,3,12,4,15,11,2,2,0,5,5,0,5,5,0] } }
theorem leafL_136_5_valid : (leafL_136_5).reject.ValidFor (leafL_136_5).leaf := by decide

noncomputable def leafL_136_6 : RejectedLeaf := { leaf := {0,1,17,34,52,70,95,125}, reject := .fullRank { members := ![0,1,17,34,52,70,95,125], points := ![103,131,135,137,149,158], inverse := ![9,13,2,2,1,4,2,4,5,5,13,11,0,3,4,7,0,0,13,3,10,8,3,15,0,14,13,3,9,9,0,4,10,14,3,3] } }
theorem leafL_136_6_valid : (leafL_136_6).reject.ValidFor (leafL_136_6).leaf := by decide

noncomputable def leafL_136_7 : RejectedLeaf := { leaf := {0,1,17,34,52,70,95,126}, reject := .fullRank { members := ![0,1,17,34,52,70,95,126], points := ![104,107,131,133,135,147], inverse := ![12,5,4,10,3,5,12,14,2,12,10,6,0,0,5,10,15,0,12,1,3,13,15,12,14,14,3,10,9,0,2,2,3,11,8,0] } }
theorem leafL_136_7_valid : (leafL_136_7).reject.ValidFor (leafL_136_7).leaf := by decide

noncomputable def leavesL_136 : List RejectedLeaf := [leafL_136_0,leafL_136_1,leafL_136_2,leafL_136_3,leafL_136_4,leafL_136_5,leafL_136_6,leafL_136_7]

theorem leavesL_136_valid : LeafListValid leavesL_136 := by
  intro x hx
  simp only [leavesL_136, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_136_0_valid
  · exact leafL_136_1_valid
  · exact leafL_136_2_valid
  · exact leafL_136_3_valid
  · exact leafL_136_4_valid
  · exact leafL_136_5_valid
  · exact leafL_136_6_valid
  · exact leafL_136_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
