import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_037_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,93,128}, reject := .fullRank { members := ![0,1,17,34,52,69,93,128], points := ![99,103,110,137,139,154], inverse := ![15,12,10,4,9,5,9,13,6,6,2,6,2,12,14,0,0,0,6,14,5,7,6,12,14,6,8,12,12,0,9,8,1,13,13,0] } }
theorem leafL_037_0_valid : (leafL_037_0).reject.ValidFor (leafL_037_0).leaf := by decide

noncomputable def leafL_037_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,93,137}, reject := .fullRank { members := ![0,1,17,34,52,69,93,137], points := ![103,110,120,127,128,152], inverse := ![6,10,6,5,13,3,1,12,7,5,3,12,0,0,13,2,15,0,7,13,2,13,2,7,10,10,8,15,7,0,3,3,8,2,10,0] } }
theorem leafL_037_1_valid : (leafL_037_1).reject.ValidFor (leafL_037_1).leaf := by decide

noncomputable def leafL_037_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,93,139}, reject := .fullRank { members := ![0,1,17,34,52,69,93,139], points := ![103,115,120,124,154,159], inverse := ![12,9,15,8,12,15,13,5,9,13,9,5,0,5,2,7,0,0,10,1,11,7,1,6,0,3,13,14,9,9,0,3,2,1,10,10] } }
theorem leafL_037_2_valid : (leafL_037_2).reject.ValidFor (leafL_037_2).leaf := by decide

noncomputable def leafL_037_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,93,152}, reject := .fullRank { members := ![0,1,17,34,52,69,93,152], points := ![99,103,110,124,126,137], inverse := ![7,0,0,0,9,15,11,1,13,9,7,9,2,12,14,0,0,0,11,10,6,11,4,8,13,2,15,9,9,0,7,2,5,12,12,0] } }
theorem leafL_037_3_valid : (leafL_037_3).reject.ValidFor (leafL_037_3).leaf := by decide

noncomputable def leafL_037_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,93,154}, reject := .fullRank { members := ![0,1,17,34,52,69,93,154], points := ![99,103,124,127,128,137], inverse := ![7,0,10,15,12,15,3,4,4,15,5,9,0,0,6,11,13,0,12,11,13,3,1,8,9,9,15,10,5,0,10,10,10,0,10,0] } }
theorem leafL_037_4_valid : (leafL_037_4).reject.ValidFor (leafL_037_4).leaf := by decide

noncomputable def leafL_037_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,93,155}, reject := .fullRank { members := ![0,1,17,34,52,69,93,155], points := ![110,115,120,128,144,163], inverse := ![0,9,4,2,5,11,3,12,12,1,11,9,0,10,3,9,0,0,10,10,14,14,7,7,11,2,14,8,12,3,4,5,3,9,2,9] } }
theorem leafL_037_5_valid : (leafL_037_5).reject.ValidFor (leafL_037_5).leaf := by decide

noncomputable def leafL_037_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,93,159}, reject := .fullRank { members := ![0,1,17,34,52,69,93,159], points := ![103,110,120,124,139,144], inverse := ![14,9,4,13,8,7,0,7,7,9,11,2,14,14,13,13,9,9,9,14,7,8,12,4,5,5,4,4,1,1,7,7,5,5,6,6] } }
theorem leafL_037_6_valid : (leafL_037_6).reject.ValidFor (leafL_037_6).leaf := by decide

noncomputable def leafL_037_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,93,163}, reject := .fullRank { members := ![0,1,17,34,52,69,93,163], points := ![110,126,127,139,154,155], inverse := ![7,8,1,15,3,3,6,5,3,15,3,12,3,9,2,10,8,10,4,12,8,2,8,10,5,0,14,13,13,11,0,1,1,0,1,1] } }
theorem leafL_037_7_valid : (leafL_037_7).reject.ValidFor (leafL_037_7).leaf := by decide

noncomputable def leavesL_037 : List RejectedLeaf := [leafL_037_0,leafL_037_1,leafL_037_2,leafL_037_3,leafL_037_4,leafL_037_5,leafL_037_6,leafL_037_7]

theorem leavesL_037_valid : LeafListValid leavesL_037 := by
  intro x hx
  simp only [leavesL_037, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_037_0_valid
  · exact leafL_037_1_valid
  · exact leafL_037_2_valid
  · exact leafL_037_3_valid
  · exact leafL_037_4_valid
  · exact leafL_037_5_valid
  · exact leafL_037_6_valid
  · exact leafL_037_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
