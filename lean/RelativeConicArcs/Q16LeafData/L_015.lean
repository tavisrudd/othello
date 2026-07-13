import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_015_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,89,112}, reject := .fullRank { members := ![0,1,17,34,52,69,89,112], points := ![122,124,126,131,135,151], inverse := ![6,0,2,5,11,11,12,4,11,0,8,11,15,10,5,0,0,0,0,9,11,8,1,11,12,14,2,8,8,0,13,0,13,13,13,0] } }
theorem leafL_015_0_valid : (leafL_015_0).reject.ValidFor (leafL_015_0).leaf := by decide

noncomputable def leafL_015_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,89,115}, reject := .fullRank { members := ![0,1,17,34,52,69,89,115], points := ![104,106,135,139,150,155], inverse := ![15,6,15,2,1,4,5,7,8,12,1,7,10,10,1,1,15,15,1,12,15,14,3,15,15,15,9,9,3,3,2,2,4,4,15,15] } }
theorem leafL_015_1_valid : (leafL_015_1).reject.ValidFor (leafL_015_1).leaf := by decide

noncomputable def leafL_015_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,89,122}, reject := .fullRank { members := ![0,1,17,34,52,69,89,122], points := ![99,110,112,135,139,150], inverse := ![6,13,2,9,4,5,13,13,2,5,1,6,6,4,2,0,0,0,8,1,4,14,15,12,9,11,2,2,2,0,1,2,3,5,5,0] } }
theorem leafL_015_2_valid : (leafL_015_2).reject.ValidFor (leafL_015_2).leaf := by decide

noncomputable def leafL_015_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,89,124}, reject := .fullRank { members := ![0,1,17,34,52,69,89,124], points := ![99,106,112,135,139,150], inverse := ![8,9,8,9,4,5,3,9,8,5,1,6,7,8,15,0,0,0,5,2,10,14,15,12,15,5,10,2,2,0,8,4,12,5,5,0] } }
theorem leafL_015_3_valid : (leafL_015_3).reject.ValidFor (leafL_015_3).leaf := by decide

noncomputable def leafL_015_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,89,126}, reject := .fullRank { members := ![0,1,17,34,52,69,89,126], points := ![104,106,112,131,139,155], inverse := ![0,9,0,13,0,5,9,12,7,0,4,6,2,9,11,0,0,0,8,8,13,6,7,12,15,4,11,3,3,0,14,0,14,14,14,0] } }
theorem leafL_015_4_valid : (leafL_015_4).reject.ValidFor (leafL_015_4).leaf := by decide

noncomputable def leafL_015_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,89,127}, reject := .fullRank { members := ![0,1,17,34,52,69,89,127], points := ![104,110,135,151,154,156], inverse := ![13,4,13,12,7,14,9,11,4,11,7,10,0,0,0,6,4,2,3,14,1,10,8,14,14,14,0,1,5,4,5,5,0,7,9,14] } }
theorem leafL_015_5_valid : (leafL_015_5).reject.ValidFor (leafL_015_5).leaf := by decide

noncomputable def leafL_015_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,89,128}, reject := .fullRank { members := ![0,1,17,34,52,69,89,128], points := ![110,131,139,150,151,155], inverse := ![9,4,9,0,9,12,2,10,14,9,12,3,0,0,0,9,6,15,13,6,7,3,7,8,0,8,8,13,8,5,0,1,1,3,8,11] } }
theorem leafL_015_6_valid : (leafL_015_6).reject.ValidFor (leafL_015_6).leaf := by decide

noncomputable def leafL_015_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,89,131}, reject := .fullRank { members := ![0,1,17,34,52,69,89,131], points := ![110,112,126,128,150,154], inverse := ![4,8,11,5,15,12,1,12,4,5,14,2,7,7,15,15,13,13,8,2,7,10,1,6,15,15,5,5,9,9,7,7,7,7,0,0] } }
theorem leafL_015_7_valid : (leafL_015_7).reject.ValidFor (leafL_015_7).leaf := by decide

noncomputable def leavesL_015 : List RejectedLeaf := [leafL_015_0,leafL_015_1,leafL_015_2,leafL_015_3,leafL_015_4,leafL_015_5,leafL_015_6,leafL_015_7]

theorem leavesL_015_valid : LeafListValid leavesL_015 := by
  intro x hx
  simp only [leavesL_015, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_015_0_valid
  · exact leafL_015_1_valid
  · exact leafL_015_2_valid
  · exact leafL_015_3_valid
  · exact leafL_015_4_valid
  · exact leafL_015_5_valid
  · exact leafL_015_6_valid
  · exact leafL_015_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
