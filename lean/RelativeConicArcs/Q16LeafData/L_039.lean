import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_039_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,93,195}, reject := .fullRank { members := ![0,1,17,34,52,69,93,195], points := ![103,127,128,137,139,144], inverse := ![7,12,5,11,6,2,7,7,9,1,2,10,0,0,0,3,12,15,7,8,7,9,7,6,0,7,7,13,14,3,0,1,1,12,14,2] } }
theorem leafL_039_0_valid : (leafL_039_0).reject.ValidFor (leafL_039_0).leaf := by decide

noncomputable def leafL_039_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,93,198}, reject := .fullRank { members := ![0,1,17,34,52,69,93,198], points := ![99,110,120,124,126,137], inverse := ![7,0,0,0,9,15,12,11,10,4,0,9,0,0,1,3,2,0,8,15,8,0,7,8,3,3,7,0,7,0,9,9,7,5,2,0] } }
theorem leafL_039_1_valid : (leafL_039_1).reject.ValidFor (leafL_039_1).leaf := by decide

noncomputable def leafL_039_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,93,214}, reject := .fullRank { members := ![0,1,17,34,52,69,93,214], points := ![103,115,120,127,137,139], inverse := ![7,9,6,6,14,1,7,5,0,11,3,10,0,2,5,7,0,0,7,3,0,12,6,14,0,12,3,15,3,3,0,5,3,6,9,9] } }
theorem leafL_039_2_valid : (leafL_039_2).reject.ValidFor (leafL_039_2).leaf := by decide

noncomputable def leafL_039_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,93,217}, reject := .fullRank { members := ![0,1,17,34,52,69,93,217], points := ![99,115,120,124,144,152], inverse := ![10,8,3,0,7,7,15,12,10,4,12,1,0,5,2,7,0,0,7,5,3,9,8,0,14,14,0,7,2,5,12,6,7,11,14,8] } }
theorem leafL_039_3_valid : (leafL_039_3).reject.ValidFor (leafL_039_3).leaf := by decide

noncomputable def leafL_039_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,93,222}, reject := .fullRank { members := ![0,1,17,34,52,69,93,222], points := ![99,115,124,127,137,139], inverse := ![7,8,5,4,15,0,7,2,3,15,2,11,0,7,5,2,0,0,7,4,3,8,7,15,0,15,3,12,3,3,0,6,3,5,9,9] } }
theorem leafL_039_4_valid : (leafL_039_4).reject.ValidFor (leafL_039_4).leaf := by decide

noncomputable def leafL_039_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,93,223}, reject := .fullRank { members := ![0,1,17,34,52,69,93,223], points := ![99,103,126,128,139,144], inverse := ![13,10,7,14,2,13,14,9,7,9,12,5,2,2,8,8,9,9,11,12,14,1,3,11,6,6,1,1,7,7,14,14,4,4,1,1] } }
theorem leafL_039_5_valid : (leafL_039_5).reject.ValidFor (leafL_039_5).leaf := by decide

noncomputable def leafL_039_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,93,230}, reject := .fullRank { members := ![0,1,17,34,52,69,93,230], points := ![99,103,115,120,128,139], inverse := ![12,11,0,4,13,15,9,14,3,11,6,9,0,0,10,3,9,0,1,6,4,15,4,8,9,9,13,7,10,0,10,10,14,9,7,0] } }
theorem leafL_039_6_valid : (leafL_039_6).reject.ValidFor (leafL_039_6).leaf := by decide

noncomputable def leafL_039_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,93,235}, reject := .fullRank { members := ![0,1,17,34,52,69,93,235], points := ![103,110,124,126,127,137], inverse := ![1,6,14,8,15,15,14,9,12,8,10,9,0,0,4,12,8,0,5,2,14,11,10,8,10,10,0,1,1,0,3,3,2,13,15,0] } }
theorem leafL_039_7_valid : (leafL_039_7).reject.ValidFor (leafL_039_7).leaf := by decide

noncomputable def leavesL_039 : List RejectedLeaf := [leafL_039_0,leafL_039_1,leafL_039_2,leafL_039_3,leafL_039_4,leafL_039_5,leafL_039_6,leafL_039_7]

theorem leavesL_039_valid : LeafListValid leavesL_039 := by
  intro x hx
  simp only [leavesL_039, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_039_0_valid
  · exact leafL_039_1_valid
  · exact leafL_039_2_valid
  · exact leafL_039_3_valid
  · exact leafL_039_4_valid
  · exact leafL_039_5_valid
  · exact leafL_039_6_valid
  · exact leafL_039_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
