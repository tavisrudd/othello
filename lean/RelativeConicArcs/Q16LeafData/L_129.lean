import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_129_0 : RejectedLeaf := { leaf := {0,1,17,34,52,70,91,125}, reject := .fullRank { members := ![0,1,17,34,52,70,91,125], points := ![101,103,110,137,147,149], inverse := ![8,4,5,13,15,10,0,4,6,4,12,10,1,11,10,0,0,0,0,4,9,1,10,6,14,5,11,0,6,6,1,12,13,0,15,15] } }
theorem leafL_129_0_valid : (leafL_129_0).reject.ValidFor (leafL_129_0).leaf := by decide

noncomputable def leafL_129_1 : RejectedLeaf := { leaf := {0,1,17,34,52,70,91,127}, reject := .fullRank { members := ![0,1,17,34,52,70,91,127], points := ![101,104,108,137,140,147], inverse := ![13,11,15,6,11,5,1,6,5,15,11,6,9,6,15,0,0,0,6,8,3,9,8,12,14,12,2,8,8,0,7,7,0,7,7,0] } }
theorem leafL_129_1_valid : (leafL_129_1).reject.ValidFor (leafL_129_1).leaf := by decide

noncomputable def leafL_129_2 : RejectedLeaf := { leaf := {0,1,17,34,52,70,91,140}, reject := .fullRank { members := ![0,1,17,34,52,70,91,140], points := ![104,120,122,127,147,149], inverse := ![12,8,1,7,1,2,13,4,15,10,6,10,0,6,10,12,0,0,10,1,4,8,0,7,0,8,4,12,3,3,0,10,7,13,9,9] } }
theorem leafL_129_2_valid : (leafL_129_2).reject.ValidFor (leafL_129_2).leaf := by decide

noncomputable def leafL_129_3 : RejectedLeaf := { leaf := {0,1,17,34,52,70,91,144}, reject := .fullRank { members := ![0,1,17,34,52,70,91,144], points := ![108,109,110,120,122,147], inverse := ![5,1,8,1,15,3,13,15,15,14,15,12,1,6,7,0,0,0,3,9,0,8,5,7,3,8,11,5,5,0,5,3,6,1,1,0] } }
theorem leafL_129_3_valid : (leafL_129_3).reject.ValidFor (leafL_129_3).leaf := by decide

noncomputable def leafL_129_4 : RejectedLeaf := { leaf := {0,1,17,34,52,70,91,147}, reject := .fullRank { members := ![0,1,17,34,52,70,91,147], points := ![101,103,104,117,122,140], inverse := ![0,7,0,9,0,15,9,10,4,9,7,9,7,9,14,0,0,0,15,8,0,7,8,8,1,1,0,12,12,0,15,12,3,13,13,0] } }
theorem leafL_129_4_valid : (leafL_129_4).reject.ValidFor (leafL_129_4).leaf := by decide

noncomputable def leafL_129_5 : RejectedLeaf := { leaf := {0,1,17,34,52,70,91,154}, reject := .fullRank { members := ![0,1,17,34,52,70,91,154], points := ![108,109,117,125,137,144], inverse := ![7,0,5,12,7,8,15,8,6,8,7,14,11,11,1,1,14,14,5,2,10,5,14,6,13,13,7,7,3,3,3,3,0,0,3,3] } }
theorem leafL_129_5_valid : (leafL_129_5).reject.ValidFor (leafL_129_5).leaf := by decide

noncomputable def leafL_129_6 : RejectedLeaf := { leaf := {0,1,17,34,52,70,91,159}, reject := .fullRank { members := ![0,1,17,34,52,70,91,159], points := ![103,104,108,120,122,144], inverse := ![5,6,4,3,10,15,8,11,4,6,8,9,4,10,14,0,0,0,1,3,5,3,12,8,14,15,1,5,5,0,9,10,3,1,1,0] } }
theorem leafL_129_6_valid : (leafL_129_6).reject.ValidFor (leafL_129_6).leaf := by decide

noncomputable def leafL_129_7 : RejectedLeaf := { leaf := {0,1,17,34,52,70,91,168}, reject := .fullRank { members := ![0,1,17,34,52,70,91,168], points := ![101,103,109,122,137,147], inverse := ![13,15,1,15,4,9,14,10,12,15,13,10,14,6,8,0,0,0,12,1,6,5,6,8,1,6,1,5,7,4,4,14,5,1,4,10] } }
theorem leafL_129_7_valid : (leafL_129_7).reject.ValidFor (leafL_129_7).leaf := by decide

noncomputable def leavesL_129 : List RejectedLeaf := [leafL_129_0,leafL_129_1,leafL_129_2,leafL_129_3,leafL_129_4,leafL_129_5,leafL_129_6,leafL_129_7]

theorem leavesL_129_valid : LeafListValid leavesL_129 := by
  intro x hx
  simp only [leavesL_129, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_129_0_valid
  · exact leafL_129_1_valid
  · exact leafL_129_2_valid
  · exact leafL_129_3_valid
  · exact leafL_129_4_valid
  · exact leafL_129_5_valid
  · exact leafL_129_6_valid
  · exact leafL_129_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
