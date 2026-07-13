import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_076_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,112,131}, reject := .fullRank { members := ![0,1,17,34,52,69,112,131], points := ![89,94,95,120,151,152], inverse := ![13,15,0,5,12,10,8,11,6,8,0,13,4,8,12,0,0,0,2,12,13,10,3,10,5,15,10,0,14,14,15,11,4,0,10,10] } }
theorem leafL_076_0_valid : (leafL_076_0).reject.ValidFor (leafL_076_0).leaf := by decide

noncomputable def leafL_076_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,112,135}, reject := .fullRank { members := ![0,1,17,34,52,69,112,135], points := ![89,90,91,122,126,152], inverse := ![13,7,8,11,14,6,9,10,6,7,15,13,9,14,7,0,0,0,10,7,14,9,3,9,15,11,4,9,9,0,5,1,4,15,15,0] } }
theorem leafL_076_1_valid : (leafL_076_1).reject.ValidFor (leafL_076_1).leaf := by decide

noncomputable def leafL_076_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,112,141}, reject := .fullRank { members := ![0,1,17,34,52,69,112,141], points := ![89,95,120,124,126,151], inverse := ![10,8,12,2,11,6,12,9,14,7,1,13,0,0,1,3,2,0,13,14,1,4,15,9,9,9,6,4,2,0,10,10,0,10,10,0] } }
theorem leafL_076_2_valid : (leafL_076_2).reject.ValidFor (leafL_076_2).leaf := by decide

noncomputable def leafL_076_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,112,152}, reject := .fullRank { members := ![0,1,17,34,52,69,112,152], points := ![94,122,124,126,131,135], inverse := ![7,5,14,5,7,15,7,15,10,12,2,12,0,15,10,5,0,0,7,3,7,12,10,5,0,12,14,2,8,8,0,13,0,13,13,13] } }
theorem leafL_076_3_valid : (leafL_076_3).reject.ValidFor (leafL_076_3).leaf := by decide

noncomputable def leafL_076_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,112,154}, reject := .fullRank { members := ![0,1,17,34,52,69,112,154], points := ![89,91,124,131,173,174], inverse := ![8,13,2,11,9,4,1,3,4,0,7,1,0,2,12,3,2,15,10,13,8,15,14,14,1,15,2,9,13,8,2,9,15,7,15,12] } }
theorem leafL_076_4_valid : (leafL_076_4).reject.ValidFor (leafL_076_4).leaf := by decide

noncomputable def leafL_076_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,112,155}, reject := .fullRank { members := ![0,1,17,34,52,69,112,155], points := ![90,95,120,126,135,163], inverse := ![7,8,15,4,4,1,0,5,4,1,13,13,14,4,1,8,15,12,15,6,1,11,6,5,1,7,5,2,5,4,6,10,9,7,10,8] } }
theorem leafL_076_5_valid : (leafL_076_5).reject.ValidFor (leafL_076_5).leaf := by decide

noncomputable def leafL_076_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,112,163}, reject := .fullRank { members := ![0,1,17,34,52,69,112,163], points := ![90,91,94,122,126,135], inverse := ![4,8,11,1,15,8,11,2,14,3,10,14,10,2,8,0,0,0,2,4,1,1,9,15,10,8,2,9,9,0,15,0,15,15,15,0] } }
theorem leafL_076_6_valid : (leafL_076_6).reject.ValidFor (leafL_076_6).leaf := by decide

noncomputable def leafL_076_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,112,166}, reject := .fullRank { members := ![0,1,17,34,52,69,112,166], points := ![89,90,94,120,135,139], inverse := ![10,12,1,14,3,11,9,2,12,9,8,6,11,13,6,0,0,0,13,4,14,8,2,13,15,11,4,0,11,11,12,5,9,0,6,6] } }
theorem leafL_076_7_valid : (leafL_076_7).reject.ValidFor (leafL_076_7).leaf := by decide

noncomputable def leavesL_076 : List RejectedLeaf := [leafL_076_0,leafL_076_1,leafL_076_2,leafL_076_3,leafL_076_4,leafL_076_5,leafL_076_6,leafL_076_7]

theorem leavesL_076_valid : LeafListValid leavesL_076 := by
  intro x hx
  simp only [leavesL_076, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_076_0_valid
  · exact leafL_076_1_valid
  · exact leafL_076_2_valid
  · exact leafL_076_3_valid
  · exact leafL_076_4_valid
  · exact leafL_076_5_valid
  · exact leafL_076_6_valid
  · exact leafL_076_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
