import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_028_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,91,159}, reject := .fullRank { members := ![0,1,17,34,52,69,91,159], points := ![103,104,106,115,120,135], inverse := ![9,8,6,14,7,15,5,4,6,8,6,9,8,3,11,0,0,0,13,1,11,6,9,8,0,6,6,14,14,0,12,10,6,8,8,0] } }
theorem leafL_028_0_valid : (leafL_028_0).reject.ValidFor (leafL_028_0).leaf := by decide

noncomputable def leafL_028_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,91,163}, reject := .fullRank { members := ![0,1,17,34,52,69,91,163], points := ![110,112,122,135,137,150], inverse := ![3,7,2,13,8,2,7,1,6,1,14,15,4,8,10,6,8,8,13,4,6,8,2,5,12,4,12,10,15,1,6,8,9,15,13,5] } }
theorem leafL_028_1_valid : (leafL_028_1).reject.ValidFor (leafL_028_1).leaf := by decide

noncomputable def leafL_028_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,91,169}, reject := .fullRank { members := ![0,1,17,34,52,69,91,169], points := ![103,104,106,144,150,159], inverse := ![8,10,11,13,3,6,11,2,11,4,13,11,8,3,11,0,0,0,5,9,1,1,2,14,5,0,5,0,8,8,13,5,8,0,7,7] } }
theorem leafL_028_2_valid : (leafL_028_2).reject.ValidFor (leafL_028_2).leaf := by decide

noncomputable def leafL_028_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,91,174}, reject := .fullRank { members := ![0,1,17,34,52,69,91,174], points := ![99,103,106,115,135,138], inverse := ![14,7,14,9,5,10,14,10,3,14,10,3,12,2,14,0,0,0,15,5,13,15,5,13,8,2,10,0,7,7,0,4,4,0,4,4] } }
theorem leafL_028_3_valid : (leafL_028_3).reject.ValidFor (leafL_028_3).leaf := by decide

noncomputable def leafL_028_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,91,175}, reject := .fullRank { members := ![0,1,17,34,52,69,91,175], points := ![104,110,120,122,135,138], inverse := ![12,11,15,6,3,12,11,12,8,6,6,15,14,14,7,7,15,15,12,11,10,5,12,4,9,9,4,4,4,4,14,14,4,4,7,7] } }
theorem leafL_028_4_valid : (leafL_028_4).reject.ValidFor (leafL_028_4).leaf := by decide

noncomputable def leafL_028_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,91,183}, reject := .fullRank { members := ![0,1,17,34,52,69,91,183], points := ![106,120,122,137,138,144], inverse := ![7,13,4,6,1,8,7,0,14,0,9,0,0,0,0,6,7,1,7,8,7,11,13,14,0,9,9,15,5,10,0,3,3,5,10,15] } }
theorem leafL_028_5_valid : (leafL_028_5).reject.ValidFor (leafL_028_5).leaf := by decide

noncomputable def leafL_028_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,91,184}, reject := .fullRank { members := ![0,1,17,34,52,69,91,184], points := ![99,103,110,150,154,163], inverse := ![11,14,8,1,11,6,8,7,1,8,12,10,2,12,14,0,0,0,9,15,8,5,0,11,9,14,7,3,3,0,13,15,2,14,14,0] } }
theorem leafL_028_6_valid : (leafL_028_6).reject.ValidFor (leafL_028_6).leaf := by decide

noncomputable def leafL_028_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,91,186}, reject := .fullRank { members := ![0,1,17,34,52,69,91,186], points := ![99,103,115,137,144,163], inverse := ![2,5,9,12,3,0,6,0,9,0,0,15,10,0,3,14,11,12,4,13,3,7,8,5,3,11,13,9,13,1,0,15,11,10,4,10] } }
theorem leafL_028_7_valid : (leafL_028_7).reject.ValidFor (leafL_028_7).leaf := by decide

noncomputable def leavesL_028 : List RejectedLeaf := [leafL_028_0,leafL_028_1,leafL_028_2,leafL_028_3,leafL_028_4,leafL_028_5,leafL_028_6,leafL_028_7]

theorem leavesL_028_valid : LeafListValid leavesL_028 := by
  intro x hx
  simp only [leavesL_028, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_028_0_valid
  · exact leafL_028_1_valid
  · exact leafL_028_2_valid
  · exact leafL_028_3_valid
  · exact leafL_028_4_valid
  · exact leafL_028_5_valid
  · exact leafL_028_6_valid
  · exact leafL_028_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
