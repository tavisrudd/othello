import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_122_0 : RejectedLeaf := { leaf := {0,1,17,34,52,70,89,167}, reject := .fullRank { members := ![0,1,17,34,52,70,89,167], points := ![104,115,117,120,140,154], inverse := ![5,9,14,13,3,13,12,6,15,0,6,3,0,4,12,8,0,0,6,7,7,7,14,15,11,9,1,15,15,3,4,8,13,3,11,9] } }
theorem leafL_122_0_valid : (leafL_122_0).reject.ValidFor (leafL_122_0).leaf := by decide

noncomputable def leafL_122_1 : RejectedLeaf := { leaf := {0,1,17,34,52,70,89,168}, reject := .fullRank { members := ![0,1,17,34,52,70,89,168], points := ![103,108,110,126,131,135], inverse := ![13,5,15,9,12,3,13,1,11,14,3,10,7,15,8,0,0,0,1,15,9,15,2,10,9,1,8,0,6,6,7,5,2,0,15,15] } }
theorem leafL_122_1_valid : (leafL_122_1).reject.ValidFor (leafL_122_1).leaf := by decide

noncomputable def leafL_122_2 : RejectedLeaf := { leaf := {0,1,17,34,52,70,89,174}, reject := .fullRank { members := ![0,1,17,34,52,70,89,174], points := ![103,115,117,120,131,135], inverse := ![7,14,8,15,5,10,7,9,3,4,0,9,0,4,12,8,0,0,7,5,8,2,8,0,0,8,7,15,8,8,0,15,12,3,13,13] } }
theorem leafL_122_2_valid : (leafL_122_2).reject.ValidFor (leafL_122_2).leaf := by decide

noncomputable def leafL_122_3 : RejectedLeaf := { leaf := {0,1,17,34,52,70,89,176}, reject := .fullRank { members := ![0,1,17,34,52,70,89,176], points := ![108,110,115,117,120,131], inverse := ![11,12,11,4,6,15,4,3,11,15,10,9,0,0,4,12,8,0,15,8,1,4,10,8,14,14,2,7,5,0,12,12,12,12,0,0] } }
theorem leafL_122_3_valid : (leafL_122_3).reject.ValidFor (leafL_122_3).leaf := by decide

noncomputable def leafL_122_4 : RejectedLeaf := { leaf := {0,1,17,34,52,70,89,191}, reject := .fullRank { members := ![0,1,17,34,52,70,89,191], points := ![103,108,110,115,117,139], inverse := ![3,11,15,3,10,15,7,14,14,4,10,9,7,15,8,0,0,0,13,1,11,9,6,8,1,10,11,9,9,0,0,12,12,12,12,0] } }
theorem leafL_122_4_valid : (leafL_122_4).reject.ValidFor (leafL_122_4).leaf := by decide

noncomputable def leafL_122_5 : RejectedLeaf := { leaf := {0,1,17,34,52,70,89,195}, reject := .fullRank { members := ![0,1,17,34,52,70,89,195], points := ![103,108,126,127,135,140], inverse := ![8,15,8,1,2,13,9,14,11,5,8,1,6,6,1,1,10,10,4,3,5,10,6,14,6,6,13,13,1,1,2,2,0,0,2,2] } }
theorem leafL_122_5_valid : (leafL_122_5).reject.ValidFor (leafL_122_5).leaf := by decide

noncomputable def leafL_122_6 : RejectedLeaf := { leaf := {0,1,17,34,52,70,89,203}, reject := .fullRank { members := ![0,1,17,34,52,70,89,203], points := ![103,110,115,122,126,131], inverse := ![6,1,12,0,5,15,1,6,8,1,7,9,0,0,14,12,2,0,7,0,15,7,7,8,10,10,7,2,5,0,3,3,3,3,0,0] } }
theorem leafL_122_6_valid : (leafL_122_6).reject.ValidFor (leafL_122_6).leaf := by decide

noncomputable def leafL_122_7 : RejectedLeaf := { leaf := {0,1,17,34,52,70,89,205}, reject := .fullRank { members := ![0,1,17,34,52,70,89,205], points := ![120,122,126,135,159,167], inverse := ![10,3,8,11,14,5,4,15,3,3,0,11,7,4,3,0,0,0,12,11,2,14,12,7,14,0,2,12,12,12,7,12,9,2,2,2] } }
theorem leafL_122_7_valid : (leafL_122_7).reject.ValidFor (leafL_122_7).leaf := by decide

noncomputable def leavesL_122 : List RejectedLeaf := [leafL_122_0,leafL_122_1,leafL_122_2,leafL_122_3,leafL_122_4,leafL_122_5,leafL_122_6,leafL_122_7]

theorem leavesL_122_valid : LeafListValid leavesL_122 := by
  intro x hx
  simp only [leavesL_122, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_122_0_valid
  · exact leafL_122_1_valid
  · exact leafL_122_2_valid
  · exact leafL_122_3_valid
  · exact leafL_122_4_valid
  · exact leafL_122_5_valid
  · exact leafL_122_6_valid
  · exact leafL_122_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
