import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_036_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,93,99}, reject := .fullRank { members := ![0,1,17,34,52,69,93,99], points := ![120,124,128,144,151,152], inverse := ![0,4,0,14,11,0,1,2,0,8,7,12,12,11,7,0,0,0,0,9,11,9,5,14,0,6,6,0,10,10,8,7,15,0,3,3] } }
theorem leafL_036_0_valid : (leafL_036_0).reject.ValidFor (leafL_036_0).leaf := by decide

noncomputable def leafL_036_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,93,103}, reject := .fullRank { members := ![0,1,17,34,52,69,93,103], points := ![126,127,128,137,139,152], inverse := ![5,10,11,12,2,11,7,5,1,1,9,11,7,14,9,0,0,0,4,12,10,4,13,11,4,15,11,3,3,0,9,0,9,9,9,0] } }
theorem leafL_036_1_valid : (leafL_036_1).reject.ValidFor (leafL_036_1).leaf := by decide

noncomputable def leafL_036_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,93,110}, reject := .fullRank { members := ![0,1,17,34,52,69,93,110], points := ![115,128,137,152,155,159], inverse := ![6,2,14,8,1,2,2,1,8,12,15,8,0,0,0,8,1,9,7,5,9,13,6,0,10,10,0,12,3,15,12,12,0,12,12,0] } }
theorem leafL_036_2_valid : (leafL_036_2).reject.ValidFor (leafL_036_2).leaf := by decide

noncomputable def leafL_036_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,93,115}, reject := .fullRank { members := ![0,1,17,34,52,69,93,115], points := ![110,139,151,155,172,174], inverse := ![14,1,8,11,10,7,2,4,14,8,3,3,4,13,15,0,1,7,11,3,12,1,9,12,12,4,7,5,14,4,14,11,6,10,13,4] } }
theorem leafL_036_3_valid : (leafL_036_3).reject.ValidFor (leafL_036_3).leaf := by decide

noncomputable def leafL_036_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,93,120}, reject := .fullRank { members := ![0,1,17,34,52,69,93,120], points := ![99,137,139,144,151,155], inverse := ![9,9,3,7,3,6,2,2,3,5,4,2,0,3,12,15,0,0,13,12,13,0,5,9,0,13,12,1,11,11,0,12,2,14,15,15] } }
theorem leafL_036_4_valid : (leafL_036_4).reject.ValidFor (leafL_036_4).leaf := by decide

noncomputable def leafL_036_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,93,124}, reject := .fullRank { members := ![0,1,17,34,52,69,93,124], points := ![99,139,152,154,159,174], inverse := ![0,10,10,3,6,4,4,6,7,15,15,5,0,0,6,10,12,0,6,9,14,12,10,7,12,4,0,0,2,10,8,9,15,6,4,12] } }
theorem leafL_036_5_valid : (leafL_036_5).reject.ValidFor (leafL_036_5).leaf := by decide

noncomputable def leafL_036_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,93,126}, reject := .fullRank { members := ![0,1,17,34,52,69,93,126], points := ![103,139,144,152,163,175], inverse := ![5,11,2,7,7,13,7,9,14,14,9,7,8,12,5,13,13,1,2,11,15,7,1,0,12,13,9,2,7,13,12,4,0,2,15,5] } }
theorem leafL_036_6_valid : (leafL_036_6).reject.ValidFor (leafL_036_6).leaf := by decide

noncomputable def leafL_036_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,93,127}, reject := .fullRank { members := ![0,1,17,34,52,69,93,127], points := ![103,137,151,152,154,163], inverse := ![5,9,12,7,12,10,6,9,10,1,2,6,0,0,8,3,11,0,3,10,13,5,8,9,7,12,0,0,6,13,11,8,14,13,7,7] } }
theorem leafL_036_7_valid : (leafL_036_7).reject.ValidFor (leafL_036_7).leaf := by decide

noncomputable def leavesL_036 : List RejectedLeaf := [leafL_036_0,leafL_036_1,leafL_036_2,leafL_036_3,leafL_036_4,leafL_036_5,leafL_036_6,leafL_036_7]

theorem leavesL_036_valid : LeafListValid leavesL_036 := by
  intro x hx
  simp only [leavesL_036, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_036_0_valid
  · exact leafL_036_1_valid
  · exact leafL_036_2_valid
  · exact leafL_036_3_valid
  · exact leafL_036_4_valid
  · exact leafL_036_5_valid
  · exact leafL_036_6_valid
  · exact leafL_036_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
