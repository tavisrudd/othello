import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_102_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,139,201}, reject := .fullRank { members := ![0,1,17,34,52,69,139,201], points := ![86,92,96,103,104,120], inverse := ![9,3,5,15,7,6,8,6,7,0,14,7,7,4,3,0,0,0,6,9,7,7,8,7,9,0,9,4,4,0,8,10,2,1,1,0] } }
theorem leafL_102_0_valid : (leafL_102_0).reject.ValidFor (leafL_102_0).leaf := by decide

noncomputable def leafL_102_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,139,207}, reject := .fullRank { members := ![0,1,17,34,52,69,139,207], points := ![86,89,90,103,115,120], inverse := ![7,2,10,8,2,4,13,13,9,14,4,3,14,4,10,0,0,0,10,3,1,15,10,13,7,1,6,0,5,5,15,1,14,0,12,12] } }
theorem leafL_102_1_valid : (leafL_102_1).reject.ValidFor (leafL_102_1).leaf := by decide

noncomputable def leafL_102_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,139,211}, reject := .fullRank { members := ![0,1,17,34,52,69,139,211], points := ![86,95,103,104,112,120], inverse := ![13,2,13,8,13,6,12,5,1,0,15,7,0,0,2,15,13,0,15,7,2,11,6,7,2,2,14,2,12,0,5,5,6,13,11,0] } }
theorem leafL_102_2_valid : (leafL_102_2).reject.ValidFor (leafL_102_2).leaf := by decide

noncomputable def leafL_102_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,139,214}, reject := .fullRank { members := ![0,1,17,34,52,69,139,214], points := ![89,92,93,106,112,115], inverse := ![1,15,1,3,11,6,15,2,4,3,13,7,10,2,8,0,0,0,2,10,0,8,7,7,13,11,6,15,15,0,10,4,14,7,7,0] } }
theorem leafL_102_3_valid : (leafL_102_3).reject.ValidFor (leafL_102_3).leaf := by decide

noncomputable def leafL_102_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,139,218}, reject := .fullRank { members := ![0,1,17,34,52,69,139,218], points := ![86,95,96,112,120,124], inverse := ![6,11,2,8,9,15,9,5,5,14,12,11,9,5,12,0,0,0,12,15,11,15,10,13,4,13,9,0,7,7,14,15,1,0,5,5] } }
theorem leafL_102_4_valid : (leafL_102_4).reject.ValidFor (leafL_102_4).leaf := by decide

noncomputable def leafL_102_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,139,222}, reject := .fullRank { members := ![0,1,17,34,52,69,139,222], points := ![89,90,93,104,124,150], inverse := ![2,5,8,8,6,0,6,10,4,8,11,11,13,11,6,0,0,0,0,11,7,4,2,10,6,9,14,6,12,11,11,4,2,8,3,6] } }
theorem leafL_102_5_valid : (leafL_102_5).reject.ValidFor (leafL_102_5).leaf := by decide

noncomputable def leafL_102_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,139,223}, reject := .fullRank { members := ![0,1,17,34,52,69,139,223], points := ![86,90,93,103,104,122], inverse := ![0,6,9,11,3,6,9,15,15,11,5,7,7,2,5,0,0,0,15,12,11,12,3,7,1,13,12,4,4,0,15,3,12,1,1,0] } }
theorem leafL_102_6_valid : (leafL_102_6).reject.ValidFor (leafL_102_6).leaf := by decide

noncomputable def leafL_102_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,139,232}, reject := .fullRank { members := ![0,1,17,34,52,69,139,232], points := ![86,89,92,112,115,126], inverse := ![11,1,5,8,8,14,5,14,2,14,9,14,12,13,1,0,0,0,8,14,14,15,0,7,10,3,9,0,3,3,14,15,1,0,4,4] } }
theorem leafL_102_7_valid : (leafL_102_7).reject.ValidFor (leafL_102_7).leaf := by decide

noncomputable def leavesL_102 : List RejectedLeaf := [leafL_102_0,leafL_102_1,leafL_102_2,leafL_102_3,leafL_102_4,leafL_102_5,leafL_102_6,leafL_102_7]

theorem leavesL_102_valid : LeafListValid leavesL_102 := by
  intro x hx
  simp only [leavesL_102, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_102_0_valid
  · exact leafL_102_1_valid
  · exact leafL_102_2_valid
  · exact leafL_102_3_valid
  · exact leafL_102_4_valid
  · exact leafL_102_5_valid
  · exact leafL_102_6_valid
  · exact leafL_102_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
