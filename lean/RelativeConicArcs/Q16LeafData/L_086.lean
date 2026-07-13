import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_086_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,124,171}, reject := .fullRank { members := ![0,1,17,34,52,69,124,171], points := ![86,90,99,103,106,141], inverse := ![7,14,4,10,0,6,13,3,1,0,8,7,0,0,12,2,14,0,8,7,11,7,4,7,4,4,0,6,6,0,10,10,7,14,9,0] } }
theorem leafL_086_0_valid : (leafL_086_0).reject.ValidFor (leafL_086_0).leaf := by decide

noncomputable def leafL_086_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,124,186}, reject := .fullRank { members := ![0,1,17,34,52,69,124,186], points := ![89,93,103,107,112,159], inverse := ![7,1,11,2,2,12,5,15,14,14,4,14,0,0,7,2,5,0,6,13,15,1,11,14,12,12,0,10,10,0,13,13,7,9,14,0] } }
theorem leafL_086_1_valid : (leafL_086_1).reject.ValidFor (leafL_086_1).leaf := by decide

noncomputable def leafL_086_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,124,207}, reject := .fullRank { members := ![0,1,17,34,52,69,124,207], points := ![89,90,103,135,139,171], inverse := ![14,6,9,5,1,4,10,6,7,12,15,8,5,10,11,8,5,9,14,11,11,1,1,14,10,0,3,10,13,14,10,6,2,9,2,5] } }
theorem leafL_086_2_valid : (leafL_086_2).reject.ValidFor (leafL_086_2).leaf := by decide

noncomputable def leafL_086_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,124,217}, reject := .fullRank { members := ![0,1,17,34,52,69,124,217], points := ![93,95,107,135,154,159], inverse := ![0,12,13,4,3,7,10,13,14,12,0,5,5,0,3,2,13,9,14,10,0,6,9,11,11,14,3,2,15,11,2,5,12,8,8,11] } }
theorem leafL_086_3_valid : (leafL_086_3).reject.ValidFor (leafL_086_3).leaf := by decide

noncomputable def leafL_086_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,124,222}, reject := .fullRank { members := ![0,1,17,34,52,69,124,222], points := ![89,90,93,99,106,139], inverse := ![11,6,4,6,8,6,11,7,2,14,7,7,13,11,6,0,0,0,14,14,15,5,13,7,2,6,4,7,7,0,10,3,9,5,5,0] } }
theorem leafL_086_4_valid : (leafL_086_4).reject.ValidFor (leafL_086_4).leaf := by decide

noncomputable def leafL_086_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,124,240}, reject := .fullRank { members := ![0,1,17,34,52,69,124,240], points := ![90,95,106,150,154,159], inverse := ![4,2,11,15,7,4,10,0,4,0,14,0,0,0,0,4,9,13,6,13,5,0,3,13,4,4,0,15,8,7,9,9,0,0,9,9] } }
theorem leafL_086_5_valid : (leafL_086_5).reject.ValidFor (leafL_086_5).leaf := by decide

noncomputable def leafL_086_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,124,246}, reject := .fullRank { members := ![0,1,17,34,52,69,124,246], points := ![89,95,99,139,141,152], inverse := ![8,15,5,4,1,6,6,7,12,2,3,12,15,8,12,0,8,3,0,7,1,9,0,15,6,7,14,5,0,10,12,12,0,12,12,0] } }
theorem leafL_086_6_valid : (leafL_086_6).reject.ValidFor (leafL_086_6).leaf := by decide

noncomputable def leafL_086_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,124,247}, reject := .fullRank { members := ![0,1,17,34,52,69,124,247], points := ![93,106,107,112,139,150], inverse := ![13,7,12,8,1,14,11,2,8,0,5,4,0,12,8,4,0,0,7,13,15,3,9,15,1,4,14,4,5,10,11,6,9,7,1,2] } }
theorem leafL_086_7_valid : (leafL_086_7).reject.ValidFor (leafL_086_7).leaf := by decide

noncomputable def leavesL_086 : List RejectedLeaf := [leafL_086_0,leafL_086_1,leafL_086_2,leafL_086_3,leafL_086_4,leafL_086_5,leafL_086_6,leafL_086_7]

theorem leavesL_086_valid : LeafListValid leavesL_086 := by
  intro x hx
  simp only [leavesL_086, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_086_0_valid
  · exact leafL_086_1_valid
  · exact leafL_086_2_valid
  · exact leafL_086_3_valid
  · exact leafL_086_4_valid
  · exact leafL_086_5_valid
  · exact leafL_086_6_valid
  · exact leafL_086_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
