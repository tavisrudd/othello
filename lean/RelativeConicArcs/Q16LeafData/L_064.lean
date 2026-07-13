import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_064_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,106,120}, reject := .fullRank { members := ![0,1,17,34,52,69,106,120], points := ![91,94,95,139,144,159], inverse := ![1,0,9,12,15,10,3,4,1,12,5,15,8,2,10,0,0,0,6,0,2,6,0,2,7,1,6,6,6,0,3,15,12,8,8,0] } }
theorem leafL_064_0_valid : (leafL_064_0).reject.ValidFor (leafL_064_0).leaf := by decide

noncomputable def leafL_064_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,106,124}, reject := .fullRank { members := ![0,1,17,34,52,69,106,124], points := ![89,95,135,139,141,152], inverse := ![1,9,4,8,15,10,9,15,1,1,9,15,0,0,1,3,2,0,12,8,10,4,8,2,2,2,6,15,9,0,12,12,0,12,12,0] } }
theorem leafL_064_1_valid : (leafL_064_1).reject.ValidFor (leafL_064_1).leaf := by decide

noncomputable def leafL_064_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,106,135}, reject := .fullRank { members := ![0,1,17,34,52,69,106,135], points := ![89,91,94,115,124,152], inverse := ![9,13,6,14,11,6,9,4,8,7,15,13,12,3,15,0,0,0,3,5,5,5,15,9,10,1,11,4,4,0,2,10,8,1,1,0] } }
theorem leafL_064_2_valid : (leafL_064_2).reject.ValidFor (leafL_064_2).leaf := by decide

noncomputable def leafL_064_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,106,139}, reject := .fullRank { members := ![0,1,17,34,52,69,106,139], points := ![89,95,96,120,124,152], inverse := ![3,3,2,3,6,6,7,8,10,8,0,13,1,7,6,0,0,0,7,7,3,2,8,9,8,14,6,7,7,0,15,2,13,5,5,0] } }
theorem leafL_064_3_valid : (leafL_064_3).reject.ValidFor (leafL_064_3).leaf := by decide

noncomputable def leafL_064_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,106,141}, reject := .fullRank { members := ![0,1,17,34,52,69,106,141], points := ![89,95,96,124,126,152], inverse := ![0,10,8,3,6,6,15,5,15,11,3,13,1,7,6,0,0,0,5,9,15,14,4,9,15,8,7,14,14,0,10,10,0,10,10,0] } }
theorem leafL_064_4_valid : (leafL_064_4).reject.ValidFor (leafL_064_4).leaf := by decide

noncomputable def leafL_064_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,106,159}, reject := .fullRank { members := ![0,1,17,34,52,69,106,159], points := ![89,91,96,115,120,135], inverse := ![10,14,3,5,11,8,5,5,7,12,5,14,3,12,15,0,0,0,9,14,0,9,1,15,15,7,8,5,5,0,0,12,12,12,12,0] } }
theorem leafL_064_5_valid : (leafL_064_5).reject.ValidFor (leafL_064_5).leaf := by decide

noncomputable def leafL_064_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,106,166}, reject := .fullRank { members := ![0,1,17,34,52,69,106,166], points := ![94,96,120,135,139,141], inverse := ![14,9,14,1,13,4,15,8,9,9,5,2,0,0,0,1,3,2,9,14,8,10,6,3,6,6,0,3,0,3,7,7,0,13,8,5] } }
theorem leafL_064_6_valid : (leafL_064_6).reject.ValidFor (leafL_064_6).leaf := by decide

noncomputable def leafL_064_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,106,169}, reject := .fullRank { members := ![0,1,17,34,52,69,106,169], points := ![91,94,95,124,139,141], inverse := ![3,7,3,14,4,12,4,8,11,9,2,12,8,2,10,0,0,0,0,0,7,8,9,6,1,9,8,0,5,5,11,13,6,0,12,12] } }
theorem leafL_064_7_valid : (leafL_064_7).reject.ValidFor (leafL_064_7).leaf := by decide

noncomputable def leavesL_064 : List RejectedLeaf := [leafL_064_0,leafL_064_1,leafL_064_2,leafL_064_3,leafL_064_4,leafL_064_5,leafL_064_6,leafL_064_7]

theorem leavesL_064_valid : LeafListValid leavesL_064 := by
  intro x hx
  simp only [leavesL_064, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_064_0_valid
  · exact leafL_064_1_valid
  · exact leafL_064_2_valid
  · exact leafL_064_3_valid
  · exact leafL_064_4_valid
  · exact leafL_064_5_valid
  · exact leafL_064_6_valid
  · exact leafL_064_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
