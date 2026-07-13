import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_121_0 : RejectedLeaf := { leaf := {0,1,17,34,52,70,89,127}, reject := .fullRank { members := ![0,1,17,34,52,70,89,127], points := ![104,110,135,140,141,149], inverse := ![7,14,6,6,13,5,12,14,8,3,15,6,0,0,5,11,14,0,3,14,4,11,14,12,1,1,9,2,11,0,6,6,6,0,6,0] } }
theorem leafL_121_0_valid : (leafL_121_0).reject.ValidFor (leafL_121_0).leaf := by decide

noncomputable def leafL_121_1 : RejectedLeaf := { leaf := {0,1,17,34,52,70,89,135}, reject := .fullRank { members := ![0,1,17,34,52,70,89,135], points := ![104,108,110,117,122,149], inverse := ![1,15,2,11,5,3,10,6,1,1,0,12,1,3,2,0,0,0,0,13,7,12,1,7,8,5,13,12,12,0,8,7,15,13,13,0] } }
theorem leafL_121_1_valid : (leafL_121_1).reject.ValidFor (leafL_121_1).leaf := by decide

noncomputable def leafL_121_2 : RejectedLeaf := { leaf := {0,1,17,34,52,70,89,139}, reject := .fullRank { members := ![0,1,17,34,52,70,89,139], points := ![103,110,115,117,120,151], inverse := ![5,9,6,7,15,3,13,0,8,5,12,12,0,0,4,12,8,0,0,10,14,4,7,7,10,10,0,1,1,0,3,3,2,13,15,0] } }
theorem leafL_121_2_valid : (leafL_121_2).reject.ValidFor (leafL_121_2).leaf := by decide

noncomputable def leafL_121_3 : RejectedLeaf := { leaf := {0,1,17,34,52,70,89,140}, reject := .fullRank { members := ![0,1,17,34,52,70,89,140], points := ![104,115,120,122,151,159], inverse := ![12,8,11,13,3,0,13,6,3,4,4,8,0,1,14,15,0,0,10,9,2,6,2,5,0,7,2,5,12,12,0,10,3,9,2,2] } }
theorem leafL_121_3_valid : (leafL_121_3).reject.ValidFor (leafL_121_3).leaf := by decide

noncomputable def leafL_121_4 : RejectedLeaf := { leaf := {0,1,17,34,52,70,89,149}, reject := .fullRank { members := ![0,1,17,34,52,70,89,149], points := ![103,104,122,126,127,135], inverse := ![11,12,10,10,9,15,7,0,10,6,2,9,0,0,8,10,2,0,5,2,1,13,3,8,2,2,13,2,15,0,14,14,1,7,6,0] } }
theorem leafL_121_4_valid : (leafL_121_4).reject.ValidFor (leafL_121_4).leaf := by decide

noncomputable def leafL_121_5 : RejectedLeaf := { leaf := {0,1,17,34,52,70,89,151}, reject := .fullRank { members := ![0,1,17,34,52,70,89,151], points := ![108,110,115,120,122,139], inverse := ![7,0,7,3,13,15,1,6,11,11,14,9,0,0,1,14,15,0,0,7,10,10,15,8,14,14,13,15,2,0,12,12,9,6,15,0] } }
theorem leafL_121_5_valid : (leafL_121_5).reject.ValidFor (leafL_121_5).leaf := by decide

noncomputable def leafL_121_6 : RejectedLeaf := { leaf := {0,1,17,34,52,70,89,154}, reject := .fullRank { members := ![0,1,17,34,52,70,89,154], points := ![104,108,117,126,131,139], inverse := ![10,13,10,3,2,13,0,7,4,10,14,7,3,3,15,15,14,14,10,13,9,6,0,8,2,2,4,4,1,1,3,3,13,13,1,1] } }
theorem leafL_121_6_valid : (leafL_121_6).reject.ValidFor (leafL_121_6).leaf := by decide

noncomputable def leafL_121_7 : RejectedLeaf := { leaf := {0,1,17,34,52,70,89,159}, reject := .fullRank { members := ![0,1,17,34,52,70,89,159], points := ![103,104,108,115,120,131], inverse := ![6,9,8,6,15,15,3,6,2,14,0,9,4,10,14,0,0,0,14,12,5,12,3,8,3,9,10,14,14,0,15,5,10,8,8,0] } }
theorem leafL_121_7_valid : (leafL_121_7).reject.ValidFor (leafL_121_7).leaf := by decide

noncomputable def leavesL_121 : List RejectedLeaf := [leafL_121_0,leafL_121_1,leafL_121_2,leafL_121_3,leafL_121_4,leafL_121_5,leafL_121_6,leafL_121_7]

theorem leavesL_121_valid : LeafListValid leavesL_121 := by
  intro x hx
  simp only [leavesL_121, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_121_0_valid
  · exact leafL_121_1_valid
  · exact leafL_121_2_valid
  · exact leafL_121_3_valid
  · exact leafL_121_4_valid
  · exact leafL_121_5_valid
  · exact leafL_121_6_valid
  · exact leafL_121_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
