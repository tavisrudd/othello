import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_021_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,90,115}, reject := .fullRank { members := ![0,1,17,34,52,69,90,115], points := ![104,110,135,139,150,155], inverse := ![4,13,5,8,13,8,10,8,1,5,15,9,4,4,12,12,8,8,4,9,8,9,8,4,6,6,11,11,14,14,10,10,2,2,11,11] } }
theorem leafL_021_0_valid : (leafL_021_0).reject.ValidFor (leafL_021_0).leaf := by decide

noncomputable def leafL_021_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,90,124}, reject := .fullRank { members := ![0,1,17,34,52,69,90,124], points := ![99,112,135,152,169,171], inverse := ![15,1,1,3,3,14,6,4,4,6,14,14,9,1,9,13,13,1,1,13,15,11,5,13,5,3,2,1,3,6,8,2,6,3,6,9] } }
theorem leafL_021_1_valid : (leafL_021_1).reject.ValidFor (leafL_021_1).leaf := by decide

noncomputable def leafL_021_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,90,126}, reject := .fullRank { members := ![0,1,17,34,52,69,90,126], points := ![104,112,135,139,150,152], inverse := ![1,8,3,14,1,4,1,3,14,10,7,1,3,3,4,4,7,7,4,9,15,14,9,5,10,10,10,10,14,14,8,8,13,13,14,14] } }
theorem leafL_021_2_valid : (leafL_021_2).reject.ValidFor (leafL_021_2).leaf := by decide

noncomputable def leafL_021_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,90,127}, reject := .fullRank { members := ![0,1,17,34,52,69,90,127], points := ![104,110,135,137,144,151], inverse := ![9,0,0,0,13,5,9,11,9,4,9,6,0,0,6,10,12,0,9,4,13,13,1,12,1,1,14,14,0,0,6,6,4,15,11,0] } }
theorem leafL_021_3_valid : (leafL_021_3).reject.ValidFor (leafL_021_3).leaf := by decide

noncomputable def leafL_021_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,90,135}, reject := .fullRank { members := ![0,1,17,34,52,69,90,135], points := ![99,110,112,115,124,150], inverse := ![1,3,14,8,6,3,15,6,4,15,14,12,6,4,2,0,0,0,6,8,4,1,12,7,14,4,10,6,6,0,5,1,4,15,15,0] } }
theorem leafL_021_4_valid : (leafL_021_4).reject.ValidFor (leafL_021_4).leaf := by decide

noncomputable def leafL_021_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,90,137}, reject := .fullRank { members := ![0,1,17,34,52,69,90,137], points := ![110,127,150,152,163,166], inverse := ![15,15,0,11,12,6,9,12,15,1,15,4,12,4,9,15,8,6,2,4,4,7,1,4,15,5,11,5,15,11,9,7,2,15,8,11] } }
theorem leafL_021_5_valid : (leafL_021_5).reject.ValidFor (leafL_021_5).leaf := by decide

noncomputable def leafL_021_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,90,139}, reject := .fullRank { members := ![0,1,17,34,52,69,90,139], points := ![104,112,115,126,152,163], inverse := ![1,14,5,10,11,10,4,8,2,13,5,6,15,2,14,4,15,8,0,14,12,12,5,11,2,15,5,15,15,8,13,14,13,12,8,10] } }
theorem leafL_021_6_valid : (leafL_021_6).reject.ValidFor (leafL_021_6).leaf := by decide

noncomputable def leafL_021_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,90,144}, reject := .fullRank { members := ![0,1,17,34,52,69,90,144], points := ![99,110,127,150,155,169], inverse := ![2,1,11,10,7,4,3,7,6,0,1,3,12,3,5,10,4,4,0,10,13,3,4,0,13,7,6,1,4,9,6,6,0,6,6,0] } }
theorem leafL_021_7_valid : (leafL_021_7).reject.ValidFor (leafL_021_7).leaf := by decide

noncomputable def leavesL_021 : List RejectedLeaf := [leafL_021_0,leafL_021_1,leafL_021_2,leafL_021_3,leafL_021_4,leafL_021_5,leafL_021_6,leafL_021_7]

theorem leavesL_021_valid : LeafListValid leavesL_021 := by
  intro x hx
  simp only [leavesL_021, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_021_0_valid
  · exact leafL_021_1_valid
  · exact leafL_021_2_valid
  · exact leafL_021_3_valid
  · exact leafL_021_4_valid
  · exact leafL_021_5_valid
  · exact leafL_021_6_valid
  · exact leafL_021_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
