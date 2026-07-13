import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_083_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,120,166}, reject := .fullRank { members := ![0,1,17,34,52,69,120,166], points := ![93,94,96,106,112,137], inverse := ![4,4,9,3,13,6,1,14,1,3,10,7,14,9,7,0,0,0,6,13,4,8,0,7,14,2,12,15,15,0,13,11,6,7,7,0] } }
theorem leafL_083_0_valid : (leafL_083_0).reject.ValidFor (leafL_083_0).leaf := by decide

noncomputable def leafL_083_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,120,171}, reject := .fullRank { members := ![0,1,17,34,52,69,120,171], points := ![94,99,106,137,141,144], inverse := ![9,13,3,5,15,12,14,10,3,11,6,10,0,0,0,8,10,2,15,11,3,7,12,12,0,4,4,10,9,3,0,11,11,6,9,15] } }
theorem leafL_083_1_valid : (leafL_083_1).reject.ValidFor (leafL_083_1).leaf := by decide

noncomputable def leafL_083_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,120,172}, reject := .fullRank { members := ![0,1,17,34,52,69,120,172], points := ![91,93,94,106,139,141], inverse := ![1,3,11,14,14,8,7,11,2,9,13,10,1,7,6,0,0,0,6,15,6,8,11,12,4,3,7,0,5,5,12,12,0,0,12,12] } }
theorem leafL_083_2_valid : (leafL_083_2).reject.ValidFor (leafL_083_2).leaf := by decide

noncomputable def leafL_083_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,120,183}, reject := .fullRank { members := ![0,1,17,34,52,69,120,183], points := ![91,93,95,106,131,137], inverse := ![13,15,11,14,6,0,12,13,15,9,2,5,5,10,15,0,0,0,14,9,8,8,0,7,0,6,6,0,3,3,11,2,9,0,4,4] } }
theorem leafL_083_3_valid : (leafL_083_3).reject.ValidFor (leafL_083_3).leaf := by decide

noncomputable def leafL_083_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,120,189}, reject := .fullRank { members := ![0,1,17,34,52,69,120,189], points := ![95,96,99,106,107,131], inverse := ![5,12,6,13,5,6,10,4,15,3,5,7,0,0,6,3,5,0,5,10,15,5,2,7,5,5,3,5,6,0,1,1,12,8,4,0] } }
theorem leafL_083_4_valid : (leafL_083_4).reject.ValidFor (leafL_083_4).leaf := by decide

noncomputable def leafL_083_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,120,198}, reject := .fullRank { members := ![0,1,17,34,52,69,120,198], points := ![91,93,95,99,106,131], inverse := ![13,15,11,0,14,6,12,9,11,9,0,7,5,10,15,0,0,0,14,10,11,2,10,7,0,11,11,7,7,0,11,12,7,5,5,0] } }
theorem leafL_083_5_valid : (leafL_083_5).reject.ValidFor (leafL_083_5).leaf := by decide

noncomputable def leafL_083_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,120,207}, reject := .fullRank { members := ![0,1,17,34,52,69,120,207], points := ![91,94,99,131,139,141], inverse := ![13,4,14,1,8,15,13,3,9,8,8,7,0,0,0,2,11,9,13,2,8,7,11,11,14,14,0,7,7,0,2,2,0,15,4,11] } }
theorem leafL_083_6_valid : (leafL_083_6).reject.ValidFor (leafL_083_6).leaf := by decide

noncomputable def leafL_083_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,120,211}, reject := .fullRank { members := ![0,1,17,34,52,69,120,211], points := ![91,94,95,137,139,151], inverse := ![6,7,9,14,13,10,11,5,8,3,10,15,8,2,10,0,0,0,5,1,0,6,0,2,9,11,2,15,15,0,9,4,13,7,7,0] } }
theorem leafL_083_7_valid : (leafL_083_7).reject.ValidFor (leafL_083_7).leaf := by decide

noncomputable def leavesL_083 : List RejectedLeaf := [leafL_083_0,leafL_083_1,leafL_083_2,leafL_083_3,leafL_083_4,leafL_083_5,leafL_083_6,leafL_083_7]

theorem leavesL_083_valid : LeafListValid leavesL_083 := by
  intro x hx
  simp only [leavesL_083, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_083_0_valid
  · exact leafL_083_1_valid
  · exact leafL_083_2_valid
  · exact leafL_083_3_valid
  · exact leafL_083_4_valid
  · exact leafL_083_5_valid
  · exact leafL_083_6_valid
  · exact leafL_083_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
