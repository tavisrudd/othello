import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_024_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,90,222}, reject := .fullRank { members := ![0,1,17,34,52,69,90,222], points := ![99,104,115,124,127,137], inverse := ![7,0,8,5,4,15,9,14,15,2,3,9,0,0,7,5,2,0,5,2,12,5,6,8,5,5,8,12,4,0,8,8,0,8,8,0] } }
theorem leafL_024_0_valid : (leafL_024_0).reject.ValidFor (leafL_024_0).leaf := by decide

noncomputable def leafL_024_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,90,223}, reject := .fullRank { members := ![0,1,17,34,52,69,90,223], points := ![104,112,126,135,137,139], inverse := ![6,1,9,9,12,10,5,2,14,9,6,6,0,0,0,13,8,5,15,8,15,8,4,4,12,12,0,11,3,8,14,14,0,12,3,15] } }
theorem leafL_024_1_valid : (leafL_024_1).reject.ValidFor (leafL_024_1).leaf := by decide

noncomputable def leafL_024_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,90,230}, reject := .fullRank { members := ![0,1,17,34,52,69,90,230], points := ![104,110,112,115,127,139], inverse := ![7,1,1,12,5,15,1,0,6,11,5,9,8,6,14,0,0,0,7,8,8,12,3,8,11,11,0,13,13,0,7,8,15,6,6,0] } }
theorem leafL_024_2_valid : (leafL_024_2).reject.ValidFor (leafL_024_2).leaf := by decide

noncomputable def leafL_024_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,90,235}, reject := .fullRank { members := ![0,1,17,34,52,69,90,235], points := ![104,110,124,126,127,135], inverse := ![10,13,7,2,12,15,5,2,6,13,5,9,0,0,4,12,8,0,14,9,13,5,7,8,11,11,8,10,2,0,4,4,15,9,6,0] } }
theorem leafL_024_3_valid : (leafL_024_3).reject.ValidFor (leafL_024_3).leaf := by decide

noncomputable def leafL_024_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,90,236}, reject := .fullRank { members := ![0,1,17,34,52,69,90,236], points := ![99,112,115,126,135,137], inverse := ![7,0,0,9,0,15,8,15,7,9,7,14,4,4,3,3,5,5,13,10,2,13,5,13,2,2,5,5,1,1,4,4,11,11,6,6] } }
theorem leafL_024_4_valid : (leafL_024_4).reject.ValidFor (leafL_024_4).leaf := by decide

noncomputable def leafL_024_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,90,240}, reject := .fullRank { members := ![0,1,17,34,52,69,90,240], points := ![99,104,110,124,127,137], inverse := ![15,12,4,7,14,15,6,15,14,5,11,9,7,13,10,0,0,0,9,8,6,6,9,8,13,9,4,14,14,0,8,8,0,8,8,0] } }
theorem leafL_024_5_valid : (leafL_024_5).reject.ValidFor (leafL_024_5).leaf := by decide

noncomputable def leafL_024_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,90,248}, reject := .fullRank { members := ![0,1,17,34,52,69,90,248], points := ![99,115,124,135,137,144], inverse := ![7,6,15,12,8,11,7,14,0,14,5,2,0,0,0,6,10,12,7,11,4,5,15,2,0,14,14,15,5,10,0,2,2,2,0,2] } }
theorem leafL_024_6_valid : (leafL_024_6).reject.ValidFor (leafL_024_6).leaf := by decide

noncomputable def leafL_024_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,90,249}, reject := .fullRank { members := ![0,1,17,34,52,69,90,249], points := ![104,112,126,135,144,155], inverse := ![10,12,1,8,1,15,2,6,5,6,5,2,15,3,10,3,13,8,4,1,12,2,6,13,14,9,13,0,1,11,0,6,5,9,14,4] } }
theorem leafL_024_7_valid : (leafL_024_7).reject.ValidFor (leafL_024_7).leaf := by decide

noncomputable def leavesL_024 : List RejectedLeaf := [leafL_024_0,leafL_024_1,leafL_024_2,leafL_024_3,leafL_024_4,leafL_024_5,leafL_024_6,leafL_024_7]

theorem leavesL_024_valid : LeafListValid leavesL_024 := by
  intro x hx
  simp only [leavesL_024, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_024_0_valid
  · exact leafL_024_1_valid
  · exact leafL_024_2_valid
  · exact leafL_024_3_valid
  · exact leafL_024_4_valid
  · exact leafL_024_5_valid
  · exact leafL_024_6_valid
  · exact leafL_024_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
