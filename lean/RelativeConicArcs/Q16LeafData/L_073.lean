import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_073_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,110,166}, reject := .fullRank { members := ![0,1,17,34,52,69,110,166], points := ![89,90,93,127,135,137], inverse := ![2,5,0,14,2,10,7,11,11,9,6,8,13,11,6,0,0,0,4,15,12,8,2,13,4,3,7,0,4,4,2,15,13,0,1,1] } }
theorem leafL_073_0_valid : (leafL_073_0).reject.ValidFor (leafL_073_0).leaf := by decide

noncomputable def leafL_073_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,110,172}, reject := .fullRank { members := ![0,1,17,34,52,69,110,172], points := ![86,91,93,115,122,135], inverse := ![5,14,12,11,5,8,13,2,8,3,10,14,3,13,14,0,0,0,9,5,11,10,2,15,2,14,12,10,10,0,2,13,15,11,11,0] } }
theorem leafL_073_1_valid : (leafL_073_1).reject.ValidFor (leafL_073_1).leaf := by decide

noncomputable def leafL_073_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,110,182}, reject := .fullRank { members := ![0,1,17,34,52,69,110,182], points := ![93,115,122,128,131,137], inverse := ![7,14,10,10,10,2,7,15,11,13,3,13,0,7,8,15,0,0,7,10,2,0,9,6,0,13,10,7,14,14,0,2,13,15,12,12] } }
theorem leafL_073_2_valid : (leafL_073_2).reject.ValidFor (leafL_073_2).leaf := by decide

noncomputable def leafL_073_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,110,183}, reject := .fullRank { members := ![0,1,17,34,52,69,110,183], points := ![86,89,90,122,127,131], inverse := ![7,0,0,0,14,8,14,0,9,7,14,14,14,4,10,0,0,0,6,11,10,15,7,15,10,2,8,12,12,0,1,5,4,3,3,0] } }
theorem leafL_073_3_valid : (leafL_073_3).reject.ValidFor (leafL_073_3).leaf := by decide

noncomputable def leafL_073_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,110,198}, reject := .fullRank { members := ![0,1,17,34,52,69,110,198], points := ![90,91,93,127,128,131], inverse := ![10,12,1,14,0,8,3,9,13,15,6,14,8,12,4,0,0,0,5,11,9,3,11,15,12,3,15,2,2,0,15,11,4,9,9,0] } }
theorem leafL_073_4_valid : (leafL_073_4).reject.ValidFor (leafL_073_4).leaf := by decide

noncomputable def leafL_073_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,110,201}, reject := .fullRank { members := ![0,1,17,34,52,69,110,201], points := ![86,91,122,127,144,159], inverse := ![5,5,7,3,14,11,4,0,8,9,7,2,15,2,2,13,5,7,7,4,1,11,0,9,3,0,7,15,9,2,13,12,11,2,7,15] } }
theorem leafL_073_5_valid : (leafL_073_5).reject.ValidFor (leafL_073_5).leaf := by decide

noncomputable def leafL_073_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,110,203}, reject := .fullRank { members := ![0,1,17,34,52,69,110,203], points := ![89,90,115,122,127,131], inverse := ![2,5,2,15,3,8,4,3,4,10,7,14,0,0,4,13,9,0,5,2,14,4,2,15,3,3,1,2,3,0,9,9,12,7,11,0] } }
theorem leafL_073_6_valid : (leafL_073_6).reject.ValidFor (leafL_073_6).leaf := by decide

noncomputable def leafL_073_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,110,211}, reject := .fullRank { members := ![0,1,17,34,52,69,110,211], points := ![86,91,127,137,155,156], inverse := ![2,0,5,0,6,0,11,7,5,10,0,3,6,15,13,10,12,2,2,10,6,4,4,14,10,8,1,14,11,6,8,11,8,9,4,6] } }
theorem leafL_073_7_valid : (leafL_073_7).reject.ValidFor (leafL_073_7).leaf := by decide

noncomputable def leavesL_073 : List RejectedLeaf := [leafL_073_0,leafL_073_1,leafL_073_2,leafL_073_3,leafL_073_4,leafL_073_5,leafL_073_6,leafL_073_7]

theorem leavesL_073_valid : LeafListValid leavesL_073 := by
  intro x hx
  simp only [leavesL_073, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_073_0_valid
  · exact leafL_073_1_valid
  · exact leafL_073_2_valid
  · exact leafL_073_3_valid
  · exact leafL_073_4_valid
  · exact leafL_073_5_valid
  · exact leafL_073_6_valid
  · exact leafL_073_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
