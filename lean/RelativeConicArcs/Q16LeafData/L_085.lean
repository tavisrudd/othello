import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_085_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,120,262}, reject := .fullRank { members := ![0,1,17,34,52,69,120,262], points := ![91,95,99,106,107,137], inverse := ![14,7,12,1,3,6,9,7,13,1,5,7,0,0,6,3,5,0,3,12,7,2,13,7,12,12,15,3,12,0,13,13,1,7,6,0] } }
theorem leafL_085_0_valid : (leafL_085_0).reject.ValidFor (leafL_085_0).leaf := by decide

noncomputable def leafL_085_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,120,268}, reject := .fullRank { members := ![0,1,17,34,52,69,120,268], points := ![91,93,95,112,131,137], inverse := ![6,5,10,14,14,8,11,2,7,9,14,9,5,10,15,0,0,0,7,11,3,8,7,0,0,6,6,0,3,3,11,2,9,0,4,4] } }
theorem leafL_085_1_valid : (leafL_085_1).reject.ValidFor (leafL_085_1).leaf := by decide

noncomputable def leafL_085_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,120,269}, reject := .fullRank { members := ![0,1,17,34,52,69,120,269], points := ![91,107,112,144,155,159], inverse := ![3,5,13,2,11,3,10,4,0,0,14,0,14,3,8,3,11,13,0,12,1,1,12,0,15,9,12,6,0,12,13,6,12,12,11,0] } }
theorem leafL_085_2_valid : (leafL_085_2).reject.ValidFor (leafL_085_2).leaf := by decide

noncomputable def leafL_085_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,124,135}, reject := .fullRank { members := ![0,1,17,34,52,69,124,135], points := ![89,90,99,106,150,152], inverse := ![15,9,2,9,10,6,7,13,14,10,2,12,15,15,13,13,13,13,8,3,9,12,14,0,15,15,0,0,7,7,13,13,14,14,11,11] } }
theorem leafL_085_3_valid : (leafL_085_3).reject.ValidFor (leafL_085_3).leaf := by decide

noncomputable def leafL_085_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,124,139}, reject := .fullRank { members := ![0,1,17,34,52,69,124,139], points := ![86,89,93,103,106,152], inverse := ![12,13,7,13,6,12,0,9,3,2,6,14,8,1,9,0,0,0,4,3,12,6,3,14,9,2,11,6,6,0,7,6,1,8,8,0] } }
theorem leafL_085_4_valid : (leafL_085_4).reject.ValidFor (leafL_085_4).leaf := by decide

noncomputable def leafL_085_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,124,141}, reject := .fullRank { members := ![0,1,17,34,52,69,124,141], points := ![89,95,106,112,150,169], inverse := ![1,4,10,2,15,3,0,7,11,2,3,13,13,12,15,14,1,1,9,8,11,4,4,10,0,6,11,13,6,6,7,7,7,7,0,0] } }
theorem leafL_085_5_valid : (leafL_085_5).reject.ValidFor (leafL_085_5).leaf := by decide

noncomputable def leafL_085_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,124,150}, reject := .fullRank { members := ![0,1,17,34,52,69,124,150], points := ![89,95,99,103,107,135], inverse := ![10,3,11,15,10,6,10,4,6,13,2,7,0,0,7,11,12,0,6,9,6,5,11,7,8,8,13,9,4,0,7,7,3,8,11,0] } }
theorem leafL_085_6_valid : (leafL_085_6).reject.ValidFor (leafL_085_6).leaf := by decide

noncomputable def leafL_085_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,124,154}, reject := .fullRank { members := ![0,1,17,34,52,69,124,154], points := ![89,93,99,103,112,139], inverse := ![5,12,13,6,5,6,9,7,9,8,8,7,0,0,1,9,8,0,10,5,7,2,13,7,12,12,5,3,6,0,13,13,13,13,0,0] } }
theorem leafL_085_7_valid : (leafL_085_7).reject.ValidFor (leafL_085_7).leaf := by decide

noncomputable def leavesL_085 : List RejectedLeaf := [leafL_085_0,leafL_085_1,leafL_085_2,leafL_085_3,leafL_085_4,leafL_085_5,leafL_085_6,leafL_085_7]

theorem leavesL_085_valid : LeafListValid leavesL_085 := by
  intro x hx
  simp only [leavesL_085, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_085_0_valid
  · exact leafL_085_1_valid
  · exact leafL_085_2_valid
  · exact leafL_085_3_valid
  · exact leafL_085_4_valid
  · exact leafL_085_5_valid
  · exact leafL_085_6_valid
  · exact leafL_085_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
