import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_058_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,103,195}, reject := .fullRank { members := ![0,1,17,34,52,69,103,195], points := ![86,93,94,126,127,137], inverse := ![10,12,1,14,0,8,15,9,1,1,8,14,13,2,15,0,0,0,3,7,3,14,6,15,12,9,5,15,15,0,13,11,6,7,7,0] } }
theorem leafL_058_0_valid : (leafL_058_0).reject.ValidFor (leafL_058_0).leaf := by decide

noncomputable def leafL_058_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,103,201}, reject := .fullRank { members := ![0,1,17,34,52,69,103,201], points := ![86,91,96,124,126,139], inverse := ![5,11,9,4,10,8,8,4,11,3,10,14,10,7,13,0,0,0,7,8,8,13,5,15,13,7,10,14,14,0,15,1,14,10,10,0] } }
theorem leafL_058_1_valid : (leafL_058_1).reject.ValidFor (leafL_058_1).leaf := by decide

noncomputable def leafL_058_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,103,203}, reject := .fullRank { members := ![0,1,17,34,52,69,103,203], points := ![95,96,126,127,131,152], inverse := ![1,1,12,8,14,11,13,5,7,0,5,10,6,15,7,10,10,14,5,8,14,3,12,12,14,5,7,11,4,3,15,6,0,13,10,14] } }
theorem leafL_058_2_valid : (leafL_058_2).reject.ValidFor (leafL_058_2).leaf := by decide

noncomputable def leafL_058_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,103,211}, reject := .fullRank { members := ![0,1,17,34,52,69,103,211], points := ![86,91,94,124,127,137], inverse := ![2,0,5,11,5,8,6,8,9,14,7,14,1,5,4,0,0,0,4,9,10,11,3,15,3,5,6,5,5,0,1,6,7,12,12,0] } }
theorem leafL_058_3_valid : (leafL_058_3).reject.ValidFor (leafL_058_3).leaf := by decide

noncomputable def leafL_058_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,103,214}, reject := .fullRank { members := ![0,1,17,34,52,69,103,214], points := ![93,94,96,127,128,137], inverse := ![7,2,2,15,1,8,13,1,11,10,3,14,14,9,7,0,0,0,7,12,12,9,1,15,13,10,7,2,2,0,9,9,0,9,9,0] } }
theorem leafL_058_4_valid : (leafL_058_4).reject.ValidFor (leafL_058_4).leaf := by decide

noncomputable def leafL_058_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,103,223}, reject := .fullRank { members := ![0,1,17,34,52,69,103,223], points := ![93,94,126,128,137,139], inverse := ![8,15,9,7,3,11,7,0,4,13,1,15,14,14,9,9,14,14,14,9,14,6,13,2,15,15,11,11,12,12,0,0,9,9,9,9] } }
theorem leafL_058_5_valid : (leafL_058_5).reject.ValidFor (leafL_058_5).leaf := by decide

noncomputable def leafL_058_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,103,230}, reject := .fullRank { members := ![0,1,17,34,52,69,103,230], points := ![91,93,127,128,139,154], inverse := ![1,10,6,14,10,8,11,9,3,1,6,6,15,6,10,7,10,14,9,5,15,11,11,3,8,12,13,15,15,9,6,3,1,10,8,6] } }
theorem leafL_058_6_valid : (leafL_058_6).reject.ValidFor (leafL_058_6).leaf := by decide

noncomputable def leafL_058_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,103,235}, reject := .fullRank { members := ![0,1,17,34,52,69,103,235], points := ![86,93,96,124,127,131], inverse := ![7,0,0,0,14,8,0,3,4,15,6,14,11,15,4,0,0,0,0,13,10,9,1,15,3,11,8,5,5,0,14,5,11,12,12,0] } }
theorem leafL_058_7_valid : (leafL_058_7).reject.ValidFor (leafL_058_7).leaf := by decide

noncomputable def leavesL_058 : List RejectedLeaf := [leafL_058_0,leafL_058_1,leafL_058_2,leafL_058_3,leafL_058_4,leafL_058_5,leafL_058_6,leafL_058_7]

theorem leavesL_058_valid : LeafListValid leavesL_058 := by
  intro x hx
  simp only [leavesL_058, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_058_0_valid
  · exact leafL_058_1_valid
  · exact leafL_058_2_valid
  · exact leafL_058_3_valid
  · exact leafL_058_4_valid
  · exact leafL_058_5_valid
  · exact leafL_058_6_valid
  · exact leafL_058_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
