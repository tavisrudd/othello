import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_082_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,115,268}, reject := .fullRank { members := ![0,1,17,34,52,69,115,268], points := ![89,90,91,104,106,139], inverse := ![1,2,10,2,12,6,1,15,0,11,2,7,9,14,7,0,0,0,15,12,12,3,11,7,1,12,13,12,12,0,15,4,11,3,3,0] } }
theorem leafL_082_0_valid : (leafL_082_0).reject.ValidFor (leafL_082_0).leaf := by decide

noncomputable def leafL_082_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,115,271}, reject := .fullRank { members := ![0,1,17,34,52,69,115,271], points := ![89,91,93,104,107,150], inverse := ![10,11,7,3,8,12,11,11,10,2,6,14,15,10,5,0,0,0,6,14,3,12,9,14,8,9,1,3,3,0,3,5,6,4,4,0] } }
theorem leafL_082_1_valid : (leafL_082_1).reject.ValidFor (leafL_082_1).leaf := by decide

noncomputable def leafL_082_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,120,131}, reject := .fullRank { members := ![0,1,17,34,52,69,120,131], points := ![95,96,107,112,151,159], inverse := ![13,11,7,12,4,8,4,14,4,0,7,9,11,11,11,11,12,12,7,12,11,14,1,15,0,0,15,15,11,11,11,11,1,1,5,5] } }
theorem leafL_082_2_valid : (leafL_082_2).reject.ValidFor (leafL_082_2).leaf := by decide

noncomputable def leafL_082_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,120,137}, reject := .fullRank { members := ![0,1,17,34,52,69,120,137], points := ![93,95,96,107,166,171], inverse := ![4,15,1,7,2,14,11,9,6,10,0,14,7,9,14,0,0,0,9,4,8,11,9,7,0,2,2,0,11,11,5,11,14,0,6,6] } }
theorem leafL_082_3_valid : (leafL_082_3).reject.ValidFor (leafL_082_3).leaf := by decide

noncomputable def leafL_082_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,120,139}, reject := .fullRank { members := ![0,1,17,34,52,69,120,139], points := ![93,96,106,112,159,166], inverse := ![1,14,2,0,5,9,3,5,1,9,2,12,6,14,5,13,8,8,1,3,7,11,7,9,8,14,8,14,6,6,3,13,5,11,14,14] } }
theorem leafL_082_4_valid : (leafL_082_4).reject.ValidFor (leafL_082_4).leaf := by decide

noncomputable def leafL_082_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,120,141}, reject := .fullRank { members := ![0,1,17,34,52,69,120,141], points := ![95,96,99,112,151,166], inverse := ![13,14,10,4,9,5,0,5,7,12,1,15,8,3,11,0,11,11,3,0,9,4,6,8,3,9,9,3,10,10,11,6,9,4,13,13] } }
theorem leafL_082_5_valid : (leafL_082_5).reject.ValidFor (leafL_082_5).leaf := by decide

noncomputable def leafL_082_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,120,151}, reject := .fullRank { members := ![0,1,17,34,52,69,120,151], points := ![91,93,94,107,112,131], inverse := ![4,11,6,5,11,6,2,11,7,3,10,7,1,7,6,0,0,0,13,13,15,0,8,7,2,11,9,10,10,0,4,14,10,11,11,0] } }
theorem leafL_082_6_valid : (leafL_082_6).reject.ValidFor (leafL_082_6).leaf := by decide

noncomputable def leafL_082_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,120,159}, reject := .fullRank { members := ![0,1,17,34,52,69,120,159], points := ![91,93,96,106,131,139], inverse := ![10,14,13,14,6,0,11,1,4,9,14,9,4,12,8,0,0,0,9,9,15,8,5,2,7,13,10,0,7,7,6,1,7,0,5,5] } }
theorem leafL_082_7_valid : (leafL_082_7).reject.ValidFor (leafL_082_7).leaf := by decide

noncomputable def leavesL_082 : List RejectedLeaf := [leafL_082_0,leafL_082_1,leafL_082_2,leafL_082_3,leafL_082_4,leafL_082_5,leafL_082_6,leafL_082_7]

theorem leavesL_082_valid : LeafListValid leavesL_082 := by
  intro x hx
  simp only [leavesL_082, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_082_0_valid
  · exact leafL_082_1_valid
  · exact leafL_082_2_valid
  · exact leafL_082_3_valid
  · exact leafL_082_4_valid
  · exact leafL_082_5_valid
  · exact leafL_082_6_valid
  · exact leafL_082_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
