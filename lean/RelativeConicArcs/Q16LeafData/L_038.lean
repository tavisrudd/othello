import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_038_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,93,166}, reject := .fullRank { members := ![0,1,17,34,52,69,93,166], points := ![99,110,120,127,128,137], inverse := ![7,0,4,7,10,15,12,11,13,14,13,9,0,0,13,2,15,0,8,15,5,12,6,8,3,3,10,12,6,0,9,9,6,11,13,0] } }
theorem leafL_038_0_valid : (leafL_038_0).reject.ValidFor (leafL_038_0).leaf := by decide

noncomputable def leafL_038_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,93,172}, reject := .fullRank { members := ![0,1,17,34,52,69,93,172], points := ![103,110,115,120,128,139], inverse := ![5,2,9,14,14,15,13,10,8,15,9,9,0,0,10,3,9,0,0,7,1,7,9,8,10,10,6,3,5,0,3,3,10,6,12,0] } }
theorem leafL_038_1_valid : (leafL_038_1).reject.ValidFor (leafL_038_1).leaf := by decide

noncomputable def leafL_038_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,93,174}, reject := .fullRank { members := ![0,1,17,34,52,69,93,174], points := ![99,103,115,120,124,137], inverse := ![7,0,12,4,1,15,3,4,3,5,8,9,0,0,5,2,7,0,12,11,14,1,0,8,9,9,6,0,6,0,10,10,11,7,12,0] } }
theorem leafL_038_2_valid : (leafL_038_2).reject.ValidFor (leafL_038_2).leaf := by decide

noncomputable def leafL_038_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,93,175}, reject := .fullRank { members := ![0,1,17,34,52,69,93,175], points := ![110,120,124,126,144,152], inverse := ![1,14,1,3,8,4,8,8,12,11,13,10,0,1,3,2,0,0,2,8,2,11,5,6,4,8,12,2,11,9,15,12,7,10,4,10] } }
theorem leafL_038_3_valid : (leafL_038_3).reject.ValidFor (leafL_038_3).leaf := by decide

noncomputable def leafL_038_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,93,182}, reject := .fullRank { members := ![0,1,17,34,52,69,93,182], points := ![99,103,110,115,124,137], inverse := ![3,11,15,6,15,15,6,9,8,2,12,9,2,12,14,0,0,0,13,13,7,5,10,8,9,9,0,6,6,0,13,11,6,15,15,0] } }
theorem leafL_038_4_valid : (leafL_038_4).reject.ValidFor (leafL_038_4).leaf := by decide

noncomputable def leafL_038_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,93,183}, reject := .fullRank { members := ![0,1,17,34,52,69,93,183], points := ![110,120,124,126,139,144], inverse := ![7,8,3,2,1,14,7,7,9,0,11,2,0,1,3,2,0,0,7,13,1,3,8,0,0,12,1,13,15,15,0,3,2,1,11,11] } }
theorem leafL_038_5_valid : (leafL_038_5).reject.ValidFor (leafL_038_5).leaf := by decide

noncomputable def leafL_038_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,93,184}, reject := .fullRank { members := ![0,1,17,34,52,69,93,184], points := ![103,110,115,124,126,139], inverse := ![5,2,0,6,15,15,13,10,6,13,5,9,0,0,3,14,13,0,0,7,4,15,4,8,10,10,2,12,14,0,3,3,13,10,7,0] } }
theorem leafL_038_6_valid : (leafL_038_6).reject.ValidFor (leafL_038_6).leaf := by decide

noncomputable def leafL_038_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,93,186}, reject := .fullRank { members := ![0,1,17,34,52,69,93,186], points := ![99,103,115,124,127,137], inverse := ![7,0,8,5,4,15,3,4,6,13,5,9,0,0,7,5,2,0,12,11,15,1,1,8,9,9,6,6,0,0,10,10,12,11,7,0] } }
theorem leafL_038_7_valid : (leafL_038_7).reject.ValidFor (leafL_038_7).leaf := by decide

noncomputable def leavesL_038 : List RejectedLeaf := [leafL_038_0,leafL_038_1,leafL_038_2,leafL_038_3,leafL_038_4,leafL_038_5,leafL_038_6,leafL_038_7]

theorem leavesL_038_valid : LeafListValid leavesL_038 := by
  intro x hx
  simp only [leavesL_038, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_038_0_valid
  · exact leafL_038_1_valid
  · exact leafL_038_2_valid
  · exact leafL_038_3_valid
  · exact leafL_038_4_valid
  · exact leafL_038_5_valid
  · exact leafL_038_6_valid
  · exact leafL_038_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
