import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_046_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,95,107}, reject := .fullRank { members := ![0,1,17,34,52,69,95,107], points := ![115,120,124,137,138,150], inverse := ![12,13,5,9,7,11,11,11,3,10,2,11,5,2,7,0,0,0,11,9,0,3,10,11,7,11,12,6,6,0,12,3,15,1,1,0] } }
theorem leafL_046_0_valid : (leafL_046_0).reject.ValidFor (leafL_046_0).leaf := by decide

noncomputable def leafL_046_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,95,112}, reject := .fullRank { members := ![0,1,17,34,52,69,95,112], points := ![120,124,126,131,139,151], inverse := ![4,8,8,2,12,11,4,0,7,12,4,11,1,3,2,0,0,0,5,6,1,0,9,11,4,10,14,4,4,0,14,6,8,15,15,0] } }
theorem leafL_046_1_valid : (leafL_046_1).reject.ValidFor (leafL_046_1).leaf := by decide

noncomputable def leafL_046_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,95,115}, reject := .fullRank { members := ![0,1,17,34,52,69,95,115], points := ![106,107,138,139,150,155], inverse := ![3,10,8,5,6,3,0,2,0,4,0,6,2,2,4,4,15,15,3,14,3,2,0,12,0,0,4,4,2,2,7,7,7,7,0,0] } }
theorem leafL_046_2_valid : (leafL_046_2).reject.ValidFor (leafL_046_2).leaf := by decide

noncomputable def leafL_046_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,95,120}, reject := .fullRank { members := ![0,1,17,34,52,69,95,120], points := ![99,106,107,131,137,151], inverse := ![3,13,7,9,4,5,12,14,0,3,7,6,6,3,5,0,0,0,1,9,5,3,2,12,4,4,0,13,13,0,8,3,11,6,6,0] } }
theorem leafL_046_3_valid : (leafL_046_3).reject.ValidFor (leafL_046_3).leaf := by decide

noncomputable def leafL_046_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,95,124}, reject := .fullRank { members := ![0,1,17,34,52,69,95,124], points := ![99,103,106,139,141,150], inverse := ![3,10,0,12,1,5,7,1,4,14,10,6,12,2,14,0,0,0,2,2,13,14,15,12,7,9,14,4,4,0,3,13,14,10,10,0] } }
theorem leafL_046_4_valid : (leafL_046_4).reject.ValidFor (leafL_046_4).leaf := by decide

noncomputable def leafL_046_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,95,126}, reject := .fullRank { members := ![0,1,17,34,52,69,95,126], points := ![106,112,131,138,139,150], inverse := ![7,14,6,1,10,5,6,4,11,11,4,6,0,0,6,3,5,0,0,13,11,1,11,12,3,3,1,1,0,0,10,10,15,9,6,0] } }
theorem leafL_046_5_valid : (leafL_046_5).reject.ValidFor (leafL_046_5).leaf := by decide

noncomputable def leafL_046_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,95,131}, reject := .fullRank { members := ![0,1,17,34,52,69,95,131], points := ![103,112,120,126,150,151], inverse := ![10,6,13,3,2,1,11,6,2,3,5,9,13,13,6,6,2,2,14,4,5,8,0,7,7,7,9,9,11,11,2,2,2,2,2,2] } }
theorem leafL_046_6_valid : (leafL_046_6).reject.ValidFor (leafL_046_6).leaf := by decide

noncomputable def leafL_046_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,95,137}, reject := .fullRank { members := ![0,1,17,34,52,69,95,137], points := ![103,107,120,156,173,174], inverse := ![3,8,2,9,10,11,6,8,0,4,9,3,12,11,12,10,1,0,11,8,10,10,5,6,7,2,3,11,9,4,5,1,13,2,1,10] } }
theorem leafL_046_7_valid : (leafL_046_7).reject.ValidFor (leafL_046_7).leaf := by decide

noncomputable def leavesL_046 : List RejectedLeaf := [leafL_046_0,leafL_046_1,leafL_046_2,leafL_046_3,leafL_046_4,leafL_046_5,leafL_046_6,leafL_046_7]

theorem leavesL_046_valid : LeafListValid leavesL_046 := by
  intro x hx
  simp only [leavesL_046, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_046_0_valid
  · exact leafL_046_1_valid
  · exact leafL_046_2_valid
  · exact leafL_046_3_valid
  · exact leafL_046_4_valid
  · exact leafL_046_5_valid
  · exact leafL_046_6_valid
  · exact leafL_046_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
