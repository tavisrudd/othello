import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_019_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,89,222}, reject := .fullRank { members := ![0,1,17,34,52,69,89,222], points := ![99,104,106,115,124,139], inverse := ![0,1,6,8,1,15,6,10,11,15,1,9,1,14,15,0,0,0,15,7,15,1,14,8,7,10,13,6,6,0,12,5,9,15,15,0] } }
theorem leafL_019_0_valid : (leafL_019_0).reject.ValidFor (leafL_019_0).leaf := by decide

noncomputable def leafL_019_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,89,230}, reject := .fullRank { members := ![0,1,17,34,52,69,89,230], points := ![99,104,106,115,127,131], inverse := ![0,0,7,0,9,15,7,0,0,14,0,9,1,14,15,0,0,0,10,8,5,3,12,8,8,15,7,13,13,0,15,4,11,6,6,0] } }
theorem leafL_019_1_valid : (leafL_019_1).reject.ValidFor (leafL_019_1).leaf := by decide

noncomputable def leafL_019_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,89,231}, reject := .fullRank { members := ![0,1,17,34,52,69,89,231], points := ![99,106,115,124,126,131], inverse := ![0,7,1,6,14,15,7,0,14,0,0,9,0,0,3,14,13,0,1,6,6,7,14,8,10,10,2,12,14,0,3,3,13,10,7,0] } }
theorem leafL_019_2_valid : (leafL_019_2).reject.ValidFor (leafL_019_2).leaf := by decide

noncomputable def leafL_019_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,89,232}, reject := .fullRank { members := ![0,1,17,34,52,69,89,232], points := ![110,112,115,122,126,135], inverse := ![3,4,9,2,2,15,5,2,1,5,10,9,0,0,14,12,2,0,4,3,4,2,9,8,1,1,9,14,7,0,7,7,15,1,14,0] } }
theorem leafL_019_3_valid : (leafL_019_3).reject.ValidFor (leafL_019_3).leaf := by decide

noncomputable def leafL_019_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,89,236}, reject := .fullRank { members := ![0,1,17,34,52,69,89,236], points := ![99,106,110,115,126,135], inverse := ![15,9,1,5,12,15,5,9,11,12,2,9,14,12,2,0,0,0,0,8,15,8,7,8,6,8,14,11,11,0,9,0,9,9,9,0] } }
theorem leafL_019_4_valid : (leafL_019_4).reject.ValidFor (leafL_019_4).leaf := by decide

noncomputable def leafL_019_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,89,246}, reject := .fullRank { members := ![0,1,17,34,52,69,89,246], points := ![99,104,110,115,122,131], inverse := ![15,9,1,4,13,15,7,0,0,14,0,9,7,13,10,0,0,0,12,15,4,9,6,8,10,4,14,15,15,0,12,14,2,3,3,0] } }
theorem leafL_019_5_valid : (leafL_019_5).reject.ValidFor (leafL_019_5).leaf := by decide

noncomputable def leafL_019_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,89,248}, reject := .fullRank { members := ![0,1,17,34,52,69,89,248], points := ![99,106,110,115,128,131], inverse := ![2,9,12,2,11,15,7,0,0,14,0,9,14,12,2,0,0,0,12,3,8,6,9,8,4,6,2,12,12,0,12,8,4,13,13,0] } }
theorem leafL_019_6_valid : (leafL_019_6).reject.ValidFor (leafL_019_6).leaf := by decide

noncomputable def leafL_019_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,89,253}, reject := .fullRank { members := ![0,1,17,34,52,69,89,253], points := ![99,104,112,124,126,131], inverse := ![0,15,8,13,4,15,5,14,12,8,6,9,10,3,9,0,0,0,7,10,10,8,7,8,5,5,0,9,9,0,2,11,9,12,12,0] } }
theorem leafL_019_7_valid : (leafL_019_7).reject.ValidFor (leafL_019_7).leaf := by decide

noncomputable def leavesL_019 : List RejectedLeaf := [leafL_019_0,leafL_019_1,leafL_019_2,leafL_019_3,leafL_019_4,leafL_019_5,leafL_019_6,leafL_019_7]

theorem leavesL_019_valid : LeafListValid leavesL_019 := by
  intro x hx
  simp only [leavesL_019, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_019_0_valid
  · exact leafL_019_1_valid
  · exact leafL_019_2_valid
  · exact leafL_019_3_valid
  · exact leafL_019_4_valid
  · exact leafL_019_5_valid
  · exact leafL_019_6_valid
  · exact leafL_019_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
