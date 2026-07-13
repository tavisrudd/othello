import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_168_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,93,197}, reject := .fullRank { members := ![0,1,17,34,52,71,93,197], points := ![99,106,110,121,128,139], inverse := ![10,14,3,7,14,15,4,7,4,10,4,9,14,12,2,0,0,0,4,15,12,0,15,8,14,5,11,10,10,0,14,6,8,2,2,0] } }
theorem leafL_168_0_valid : (leafL_168_0).reject.ValidFor (leafL_168_0).leaf := by decide

noncomputable def leafL_168_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,93,203}, reject := .fullRank { members := ![0,1,17,34,52,71,93,203], points := ![99,110,127,128,140,158], inverse := ![7,12,6,5,1,8,3,9,15,3,1,7,9,15,5,0,7,4,8,0,0,14,12,10,4,6,0,3,12,13,5,10,15,14,4,10] } }
theorem leafL_168_1_valid : (leafL_168_1).reject.ValidFor (leafL_168_1).leaf := by decide

noncomputable def leafL_168_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,93,214}, reject := .fullRank { members := ![0,1,17,34,52,71,93,214], points := ![101,127,128,139,158,159], inverse := ![14,4,9,12,13,3,11,1,5,7,9,1,13,4,6,8,8,15,1,4,14,15,10,14,8,0,12,5,3,2,8,8,4,5,4,5] } }
theorem leafL_168_2_valid : (leafL_168_2).reject.ValidFor (leafL_168_2).leaf := by decide

noncomputable def leafL_168_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,93,223}, reject := .fullRank { members := ![0,1,17,34,52,71,93,223], points := ![99,101,106,121,139,140], inverse := ![15,10,2,9,5,10,8,0,15,14,8,1,8,15,7,0,0,0,3,1,5,15,15,7,0,14,14,0,11,11,5,6,3,0,9,9] } }
theorem leafL_168_3_valid : (leafL_168_3).reject.ValidFor (leafL_168_3).leaf := by decide

noncomputable def leafL_168_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,93,224}, reject := .fullRank { members := ![0,1,17,34,52,71,93,224], points := ![99,101,120,124,150,154], inverse := ![9,5,13,3,4,7,2,15,8,9,8,4,2,2,4,4,5,5,11,1,7,10,12,11,11,11,7,7,1,1,0,0,13,13,13,13] } }
theorem leafL_168_4_valid : (leafL_168_4).reject.ValidFor (leafL_168_4).leaf := by decide

noncomputable def leafL_168_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,93,232}, reject := .fullRank { members := ![0,1,17,34,52,71,93,232], points := ![101,110,127,128,144,154], inverse := ![3,7,3,1,5,2,6,6,12,15,8,11,14,5,8,15,15,3,7,15,0,14,12,10,11,14,0,14,13,6,8,4,10,0,14,8] } }
theorem leafL_168_5_valid : (leafL_168_5).reject.ValidFor (leafL_168_5).leaf := by decide

noncomputable def leafL_168_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,93,233}, reject := .fullRank { members := ![0,1,17,34,52,71,93,233], points := ![99,106,124,127,139,144], inverse := ![7,0,7,14,9,6,5,2,8,6,0,9,15,15,15,15,1,1,12,11,9,6,7,15,6,6,2,2,10,10,0,0,11,11,11,11] } }
theorem leafL_168_6_valid : (leafL_168_6).reject.ValidFor (leafL_168_6).leaf := by decide

noncomputable def leafL_168_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,93,235}, reject := .fullRank { members := ![0,1,17,34,52,71,93,235], points := ![99,101,110,121,124,144], inverse := ![12,5,14,0,9,15,14,5,12,10,4,9,13,14,3,0,0,0,8,7,8,4,11,8,1,9,8,1,1,0,8,13,5,11,11,0] } }
theorem leafL_168_7_valid : (leafL_168_7).reject.ValidFor (leafL_168_7).leaf := by decide

noncomputable def leavesL_168 : List RejectedLeaf := [leafL_168_0,leafL_168_1,leafL_168_2,leafL_168_3,leafL_168_4,leafL_168_5,leafL_168_6,leafL_168_7]

theorem leavesL_168_valid : LeafListValid leavesL_168 := by
  intro x hx
  simp only [leavesL_168, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_168_0_valid
  · exact leafL_168_1_valid
  · exact leafL_168_2_valid
  · exact leafL_168_3_valid
  · exact leafL_168_4_valid
  · exact leafL_168_5_valid
  · exact leafL_168_6_valid
  · exact leafL_168_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
