import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_094_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,128,195}, reject := .fullRank { members := ![0,1,17,34,52,69,128,195], points := ![86,89,93,103,137,139], inverse := ![8,7,6,14,3,5,2,5,9,9,1,6,8,1,9,0,0,0,13,13,15,8,0,7,10,15,5,0,15,15,3,8,11,0,7,7] } }
theorem leafL_094_0_valid : (leafL_094_0).reject.ValidFor (leafL_094_0).leaf := by decide

noncomputable def leafL_094_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,128,198}, reject := .fullRank { members := ![0,1,17,34,52,69,128,198], points := ![93,99,110,131,137,138], inverse := ![9,1,15,10,2,14,14,4,13,9,4,10,0,0,0,9,12,5,15,9,1,15,13,5,0,15,15,10,9,3,0,4,4,10,11,1] } }
theorem leafL_094_1_valid : (leafL_094_1).reject.ValidFor (leafL_094_1).leaf := by decide

noncomputable def leafL_094_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,128,207}, reject := .fullRank { members := ![0,1,17,34,52,69,128,207], points := ![86,89,94,99,103,131], inverse := ![0,10,3,12,2,6,2,15,3,9,0,7,9,10,3,0,0,0,5,15,5,1,9,7,9,11,2,1,1,0,9,1,8,13,13,0] } }
theorem leafL_094_2_valid : (leafL_094_2).reject.ValidFor (leafL_094_2).leaf := by decide

noncomputable def leafL_094_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,128,214}, reject := .fullRank { members := ![0,1,17,34,52,69,128,214], points := ![89,93,99,103,137,138], inverse := ![9,0,1,15,1,7,9,7,8,1,9,14,12,12,10,10,11,11,4,11,9,1,6,1,9,9,15,15,10,10,13,13,13,13,0,0] } }
theorem leafL_094_3_valid : (leafL_094_3).reject.ValidFor (leafL_094_3).leaf := by decide

noncomputable def leafL_094_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,128,223}, reject := .fullRank { members := ![0,1,17,34,52,69,128,223], points := ![86,93,94,99,103,137], inverse := ![13,7,3,14,0,6,7,14,7,5,12,7,13,2,15,0,0,0,0,14,1,13,5,7,8,9,1,1,1,0,12,11,7,13,13,0] } }
theorem leafL_094_4_valid : (leafL_094_4).reject.ValidFor (leafL_094_4).leaf := by decide

noncomputable def leafL_094_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,128,236}, reject := .fullRank { members := ![0,1,17,34,52,69,128,236], points := ![86,89,93,99,110,131], inverse := ![12,6,3,2,12,6,3,4,9,9,0,7,8,1,9,0,0,0,8,4,3,11,3,7,9,2,11,6,6,0,7,6,1,8,8,0] } }
theorem leafL_094_5_valid : (leafL_094_5).reject.ValidFor (leafL_094_5).leaf := by decide

noncomputable def leafL_094_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,128,246}, reject := .fullRank { members := ![0,1,17,34,52,69,128,246], points := ![89,94,99,110,131,138], inverse := ![3,10,15,1,15,9,13,3,15,6,11,12,3,3,8,8,3,3,5,10,10,2,5,2,15,15,1,1,14,14,6,6,7,7,13,13] } }
theorem leafL_094_6_valid : (leafL_094_6).reject.ValidFor (leafL_094_6).leaf := by decide

noncomputable def leafL_094_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,128,262}, reject := .fullRank { members := ![0,1,17,34,52,69,128,262], points := ![99,138,155,156,169,175], inverse := ![0,10,0,15,4,0,10,13,14,5,4,8,8,9,11,6,6,10,13,1,12,0,7,7,10,6,4,7,3,12,13,10,5,0,6,4] } }
theorem leafL_094_7_valid : (leafL_094_7).reject.ValidFor (leafL_094_7).leaf := by decide

noncomputable def leavesL_094 : List RejectedLeaf := [leafL_094_0,leafL_094_1,leafL_094_2,leafL_094_3,leafL_094_4,leafL_094_5,leafL_094_6,leafL_094_7]

theorem leavesL_094_valid : LeafListValid leavesL_094 := by
  intro x hx
  simp only [leavesL_094, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_094_0_valid
  · exact leafL_094_1_valid
  · exact leafL_094_2_valid
  · exact leafL_094_3_valid
  · exact leafL_094_4_valid
  · exact leafL_094_5_valid
  · exact leafL_094_6_valid
  · exact leafL_094_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
