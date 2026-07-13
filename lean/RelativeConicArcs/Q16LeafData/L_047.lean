import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_047_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,95,138}, reject := .fullRank { members := ![0,1,17,34,52,69,95,138], points := ![107,115,126,150,151,155], inverse := ![12,9,7,11,2,10,13,13,12,15,8,11,0,0,0,9,6,15,10,12,1,5,2,0,0,7,7,1,4,5,0,11,11,11,0,11] } }
theorem leafL_047_0_valid : (leafL_047_0).reject.ValidFor (leafL_047_0).leaf := by decide

noncomputable def leafL_047_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,95,139}, reject := .fullRank { members := ![0,1,17,34,52,69,95,139], points := ![103,106,112,115,124,150], inverse := ![4,10,2,8,6,3,3,9,7,15,14,12,3,13,14,0,0,0,14,2,6,1,12,7,12,15,3,6,6,0,15,0,15,15,15,0] } }
theorem leafL_047_1_valid : (leafL_047_1).reject.ValidFor (leafL_047_1).leaf := by decide

noncomputable def leafL_047_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,95,141}, reject := .fullRank { members := ![0,1,17,34,52,69,95,141], points := ![99,106,112,120,124,150], inverse := ![3,11,4,14,0,3,14,7,4,6,7,12,7,8,15,0,0,0,0,4,14,5,8,7,4,9,13,13,13,0,1,9,8,6,6,0] } }
theorem leafL_047_2_valid : (leafL_047_2).reject.ValidFor (leafL_047_2).leaf := by decide

noncomputable def leafL_047_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,95,150}, reject := .fullRank { members := ![0,1,17,34,52,69,95,150], points := ![99,103,107,115,124,131], inverse := ![9,11,5,5,12,15,7,0,0,14,0,9,7,11,12,0,0,0,6,3,2,2,13,8,9,9,0,6,6,0,9,8,1,15,15,0] } }
theorem leafL_047_3_valid : (leafL_047_3).reject.ValidFor (leafL_047_3).leaf := by decide

noncomputable def leafL_047_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,95,151}, reject := .fullRank { members := ![0,1,17,34,52,69,95,151], points := ![99,107,112,115,120,131], inverse := ![0,11,12,6,15,15,7,0,0,14,0,9,9,3,10,0,0,0,7,3,3,12,3,8,11,10,1,14,14,0,0,8,8,8,8,0] } }
theorem leafL_047_4_valid : (leafL_047_4).reject.ValidFor (leafL_047_4).leaf := by decide

noncomputable def leafL_047_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,95,169}, reject := .fullRank { members := ![0,1,17,34,52,69,95,169], points := ![99,103,106,131,139,150], inverse := ![8,14,15,4,9,5,5,15,8,14,10,6,12,2,14,0,0,0,1,11,7,9,8,12,13,10,7,3,3,0,1,3,2,14,14,0] } }
theorem leafL_047_5_valid : (leafL_047_5).reject.ValidFor (leafL_047_5).leaf := by decide

noncomputable def leafL_047_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,95,172}, reject := .fullRank { members := ![0,1,17,34,52,69,95,172], points := ![103,107,115,120,138,139], inverse := ![2,5,12,5,12,3,4,3,0,14,5,12,6,6,3,3,14,14,11,12,10,5,11,3,12,12,2,2,13,13,7,7,1,1,12,12] } }
theorem leafL_047_6_valid : (leafL_047_6).reject.ValidFor (leafL_047_6).leaf := by decide

noncomputable def leafL_047_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,95,173}, reject := .fullRank { members := ![0,1,17,34,52,69,95,173], points := ![106,107,112,115,124,131], inverse := ![4,2,1,5,12,15,4,8,11,14,0,9,12,8,4,0,0,0,14,7,14,2,13,8,11,6,13,6,6,0,5,14,11,15,15,0] } }
theorem leafL_047_7_valid : (leafL_047_7).reject.ValidFor (leafL_047_7).leaf := by decide

noncomputable def leavesL_047 : List RejectedLeaf := [leafL_047_0,leafL_047_1,leafL_047_2,leafL_047_3,leafL_047_4,leafL_047_5,leafL_047_6,leafL_047_7]

theorem leavesL_047_valid : LeafListValid leavesL_047 := by
  intro x hx
  simp only [leavesL_047, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_047_0_valid
  · exact leafL_047_1_valid
  · exact leafL_047_2_valid
  · exact leafL_047_3_valid
  · exact leafL_047_4_valid
  · exact leafL_047_5_valid
  · exact leafL_047_6_valid
  · exact leafL_047_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
