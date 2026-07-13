import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_155_0 : RejectedLeaf := { leaf := {0,1,17,34,52,70,133,251}, reject := .fullRank { members := ![0,1,17,34,52,70,133,251], points := ![83,94,115,126,151,167], inverse := ![1,3,2,7,6,0,6,1,6,1,14,14,3,9,1,7,15,3,13,10,13,10,15,15,9,5,12,8,10,2,4,4,4,4,0,0] } }
theorem leafL_155_0_valid : (leafL_155_0).reject.ValidFor (leafL_155_0).leaf := by decide

noncomputable def leafL_155_1 : RejectedLeaf := { leaf := {0,1,17,34,52,70,133,267}, reject := .fullRank { members := ![0,1,17,34,52,70,133,267], points := ![94,95,115,120,127,154], inverse := ![2,0,5,0,0,6,9,12,11,0,3,13,0,0,2,5,7,0,13,14,3,1,8,9,1,1,8,3,11,0,7,7,10,3,9,0] } }
theorem leafL_155_1_valid : (leafL_155_1).reject.ValidFor (leafL_155_1).leaf := by decide

noncomputable def leafL_155_2 : RejectedLeaf := { leaf := {0,1,17,34,52,70,135,175}, reject := .fullRank { members := ![0,1,17,34,52,70,135,175], points := ![83,104,108,109,124,125], inverse := ![15,11,11,8,11,13,9,14,10,10,14,9,0,4,9,13,0,0,8,1,6,8,10,13,0,15,6,9,10,10,0,0,2,2,2,2] } }
theorem leafL_155_2_valid : (leafL_155_2).reject.ValidFor (leafL_155_2).leaf := by decide

noncomputable def leafL_155_3 : RejectedLeaf := { leaf := {0,1,17,34,52,70,135,185}, reject := .fullRank { members := ![0,1,17,34,52,70,135,185], points := ![94,104,109,110,117,125], inverse := ![15,1,3,10,13,11,9,5,4,15,11,12,0,9,5,12,0,0,8,14,12,13,7,0,0,13,9,4,2,2,0,10,6,12,5,5] } }
theorem leafL_155_3_valid : (leafL_155_3).reject.ValidFor (leafL_155_3).leaf := by decide

noncomputable def leafL_155_4 : RejectedLeaf := { leaf := {0,1,17,34,52,70,135,186}, reject := .fullRank { members := ![0,1,17,34,52,70,135,186], points := ![89,108,124,125,127,149], inverse := ![0,12,8,2,4,3,3,7,5,10,9,2,0,0,15,3,12,0,10,3,10,3,5,5,7,1,11,5,12,4,6,7,1,3,12,15] } }
theorem leafL_155_4_valid : (leafL_155_4).reject.ValidFor (leafL_155_4).leaf := by decide

noncomputable def leafL_155_5 : RejectedLeaf := { leaf := {0,1,17,34,52,70,135,202}, reject := .fullRank { members := ![0,1,17,34,52,70,135,202], points := ![94,95,104,108,109,117], inverse := ![8,7,1,11,2,6,3,10,7,8,1,7,0,0,4,9,13,0,8,0,8,12,11,7,3,3,0,11,11,0,14,14,3,4,7,0] } }
theorem leafL_155_5_valid : (leafL_155_5).reject.ValidFor (leafL_155_5).leaf := by decide

noncomputable def leafL_155_6 : RejectedLeaf := { leaf := {0,1,17,34,52,70,135,267}, reject := .fullRank { members := ![0,1,17,34,52,70,135,267], points := ![89,95,104,122,159,174], inverse := ![1,8,8,4,5,1,6,15,11,4,11,13,14,7,4,10,6,1,0,14,1,14,2,3,1,9,4,4,14,6,1,7,7,14,15,0] } }
theorem leafL_155_6_valid : (leafL_155_6).reject.ValidFor (leafL_155_6).leaf := by decide

noncomputable def leafL_155_7 : RejectedLeaf := { leaf := {0,1,17,34,52,70,137,186}, reject := .fullRank { members := ![0,1,17,34,52,70,137,186], points := ![91,95,96,101,103,124], inverse := ![3,7,11,4,12,6,7,10,4,5,11,7,6,13,11,0,0,0,5,15,2,6,9,7,8,11,3,2,2,0,10,5,15,9,9,0] } }
theorem leafL_155_7_valid : (leafL_155_7).reject.ValidFor (leafL_155_7).leaf := by decide

noncomputable def leavesL_155 : List RejectedLeaf := [leafL_155_0,leafL_155_1,leafL_155_2,leafL_155_3,leafL_155_4,leafL_155_5,leafL_155_6,leafL_155_7]

theorem leavesL_155_valid : LeafListValid leavesL_155 := by
  intro x hx
  simp only [leavesL_155, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_155_0_valid
  · exact leafL_155_1_valid
  · exact leafL_155_2_valid
  · exact leafL_155_3_valid
  · exact leafL_155_4_valid
  · exact leafL_155_5_valid
  · exact leafL_155_6_valid
  · exact leafL_155_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
