import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_025_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,90,253}, reject := .fullRank { members := ![0,1,17,34,52,69,90,253], points := ![99,104,110,115,124,137], inverse := ![9,9,7,6,15,15,4,12,15,2,12,9,7,13,10,0,0,0,12,6,13,5,10,8,11,12,7,6,6,0,7,9,14,15,15,0] } }
theorem leafL_025_0_valid : (leafL_025_0).reject.ValidFor (leafL_025_0).leaf := by decide

noncomputable def leafL_025_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,90,254}, reject := .fullRank { members := ![0,1,17,34,52,69,90,254], points := ![139,150,152,169,171,184], inverse := ![0,5,14,9,12,15,13,12,9,12,1,5,11,1,0,5,8,7,9,1,2,1,8,3,5,15,13,14,7,14,0,9,9,9,9,0] } }
theorem leafL_025_1_valid : (leafL_025_1).reject.ValidFor (leafL_025_1).leaf := by decide

noncomputable def leafL_025_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,90,256}, reject := .fullRank { members := ![0,1,17,34,52,69,90,256], points := ![99,115,126,127,150,152], inverse := ![12,11,4,1,4,7,13,13,5,9,13,1,0,15,9,6,0,0,10,14,14,13,7,0,0,14,5,11,5,5,0,2,9,11,8,8] } }
theorem leafL_025_2_valid : (leafL_025_2).reject.ValidFor (leafL_025_2).leaf := by decide

noncomputable def leafL_025_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,90,259}, reject := .fullRank { members := ![0,1,17,34,52,69,90,259], points := ![110,126,127,137,144,151], inverse := ![7,10,3,13,2,0,15,3,1,10,6,1,7,6,11,13,12,11,11,7,2,8,14,8,13,9,11,5,13,7,15,5,4,7,3,10] } }
theorem leafL_025_3_valid : (leafL_025_3).reject.ValidFor (leafL_025_3).leaf := by decide

noncomputable def leafL_025_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,90,262}, reject := .fullRank { members := ![0,1,17,34,52,69,90,262], points := ![99,112,124,126,127,135], inverse := ![11,12,1,8,0,15,14,9,8,12,10,9,0,0,4,12,8,0,6,1,14,0,1,8,8,8,5,14,11,0,13,13,10,6,12,0] } }
theorem leafL_025_4_valid : (leafL_025_4).reject.ValidFor (leafL_025_4).leaf := by decide

noncomputable def leafL_025_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,90,265}, reject := .fullRank { members := ![0,1,17,34,52,69,90,265], points := ![110,112,115,124,139,144], inverse := ![14,9,8,1,15,0,3,4,2,12,2,11,5,5,14,14,6,6,8,15,0,15,2,10,8,8,2,2,14,14,9,9,6,6,5,5] } }
theorem leafL_025_5_valid : (leafL_025_5).reject.ValidFor (leafL_025_5).leaf := by decide

noncomputable def leafL_025_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,90,268}, reject := .fullRank { members := ![0,1,17,34,52,69,90,268], points := ![104,110,112,115,137,139], inverse := ![10,15,2,9,2,13,12,14,5,14,2,11,8,6,14,0,0,0,13,3,9,15,15,7,3,9,10,0,12,12,0,13,13,0,13,13] } }
theorem leafL_025_6_valid : (leafL_025_6).reject.ValidFor (leafL_025_6).leaf := by decide

noncomputable def leafL_025_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,90,269}, reject := .fullRank { members := ![0,1,17,34,52,69,90,269], points := ![104,110,112,124,135,150], inverse := ![0,5,3,1,9,15,12,12,5,13,5,13,8,6,14,0,0,0,15,11,2,7,14,15,11,9,12,9,2,5,7,13,2,12,5,1] } }
theorem leafL_025_7_valid : (leafL_025_7).reject.ValidFor (leafL_025_7).leaf := by decide

noncomputable def leavesL_025 : List RejectedLeaf := [leafL_025_0,leafL_025_1,leafL_025_2,leafL_025_3,leafL_025_4,leafL_025_5,leafL_025_6,leafL_025_7]

theorem leavesL_025_valid : LeafListValid leavesL_025 := by
  intro x hx
  simp only [leavesL_025, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_025_0_valid
  · exact leafL_025_1_valid
  · exact leafL_025_2_valid
  · exact leafL_025_3_valid
  · exact leafL_025_4_valid
  · exact leafL_025_5_valid
  · exact leafL_025_6_valid
  · exact leafL_025_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
