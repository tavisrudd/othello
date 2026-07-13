import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_092_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,127,203}, reject := .fullRank { members := ![0,1,17,34,52,69,127,203], points := ![90,92,96,103,110,137], inverse := ![7,12,2,2,12,6,12,9,11,1,8,7,10,15,5,0,0,0,14,13,12,13,5,7,11,11,0,7,7,0,12,7,11,5,5,0] } }
theorem leafL_092_0_valid : (leafL_092_0).reject.ValidFor (leafL_092_0).leaf := by decide

noncomputable def leafL_092_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,127,211}, reject := .fullRank { members := ![0,1,17,34,52,69,127,211], points := ![92,94,103,104,110,137], inverse := ![8,1,1,4,11,6,9,7,13,3,7,7,0,0,5,12,9,0,12,3,2,7,13,7,8,8,15,2,13,0,7,7,9,3,10,0] } }
theorem leafL_092_1_valid : (leafL_092_1).reject.ValidFor (leafL_092_1).leaf := by decide

noncomputable def leafL_092_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,127,214}, reject := .fullRank { members := ![0,1,17,34,52,69,127,214], points := ![89,92,93,103,135,137], inverse := ![6,0,15,14,13,11,15,4,5,9,7,0,10,2,8,0,0,0,7,6,14,8,1,6,15,13,2,0,4,4,3,12,15,0,1,1] } }
theorem leafL_092_2_valid : (leafL_092_2).reject.ValidFor (leafL_092_2).leaf := by decide

noncomputable def leafL_092_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,127,222}, reject := .fullRank { members := ![0,1,17,34,52,69,127,222], points := ![89,90,93,107,137,144], inverse := ![12,4,1,14,7,1,12,4,6,9,5,2,13,11,6,0,0,0,4,11,0,8,2,5,3,0,3,0,8,8,7,11,12,0,2,2] } }
theorem leafL_092_3_valid : (leafL_092_3).reject.ValidFor (leafL_092_3).leaf := by decide

noncomputable def leafL_092_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,127,232}, reject := .fullRank { members := ![0,1,17,34,52,69,127,232], points := ![89,94,96,107,110,135], inverse := ![4,14,3,10,4,6,3,7,10,14,7,7,15,12,3,0,0,0,11,6,2,6,14,7,6,2,4,11,11,0,6,0,6,6,6,0] } }
theorem leafL_092_4_valid : (leafL_092_4).reject.ValidFor (leafL_092_4).leaf := by decide

noncomputable def leafL_092_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,127,240}, reject := .fullRank { members := ![0,1,17,34,52,69,127,240], points := ![90,92,94,104,110,137], inverse := ![3,10,0,9,7,6,4,0,10,13,4,7,15,10,5,0,0,0,6,8,1,14,6,7,2,5,7,5,5,0,8,6,14,12,12,0] } }
theorem leafL_092_5_valid : (leafL_092_5).reject.ValidFor (leafL_092_5).leaf := by decide

noncomputable def leafL_092_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,127,247}, reject := .fullRank { members := ![0,1,17,34,52,69,127,247], points := ![92,96,104,107,137,154], inverse := ![2,10,15,15,3,10,13,8,2,3,6,2,5,6,4,5,15,13,10,14,12,12,6,2,1,11,8,14,4,8,6,14,6,15,14,15] } }
theorem leafL_092_6_valid : (leafL_092_6).reject.ValidFor (leafL_092_6).leaf := by decide

noncomputable def leafL_092_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,127,256}, reject := .fullRank { members := ![0,1,17,34,52,69,127,256], points := ![90,92,93,103,104,137], inverse := ![7,11,5,3,13,6,8,10,12,14,7,7,12,3,15,0,0,0,7,3,11,9,1,7,15,10,5,4,4,0,14,12,2,1,1,0] } }
theorem leafL_092_7_valid : (leafL_092_7).reject.ValidFor (leafL_092_7).leaf := by decide

noncomputable def leavesL_092 : List RejectedLeaf := [leafL_092_0,leafL_092_1,leafL_092_2,leafL_092_3,leafL_092_4,leafL_092_5,leafL_092_6,leafL_092_7]

theorem leavesL_092_valid : LeafListValid leavesL_092 := by
  intro x hx
  simp only [leavesL_092, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_092_0_valid
  · exact leafL_092_1_valid
  · exact leafL_092_2_valid
  · exact leafL_092_3_valid
  · exact leafL_092_4_valid
  · exact leafL_092_5_valid
  · exact leafL_092_6_valid
  · exact leafL_092_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
