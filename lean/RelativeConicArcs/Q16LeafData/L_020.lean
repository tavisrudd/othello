import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_020_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,89,267}, reject := .fullRank { members := ![0,1,17,34,52,69,89,267], points := ![104,106,112,115,127,131], inverse := ![0,7,0,0,9,15,2,1,4,14,0,9,2,9,11,0,0,0,9,12,2,3,12,8,5,2,7,13,13,0,12,15,3,6,6,0] } }
theorem leafL_020_0_valid : (leafL_020_0).reject.ValidFor (leafL_020_0).leaf := by decide

noncomputable def leafL_020_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,89,268}, reject := .fullRank { members := ![0,1,17,34,52,69,89,268], points := ![106,110,112,115,122,131], inverse := ![2,15,10,4,13,15,13,15,5,14,0,9,5,15,10,0,0,0,14,4,13,9,6,8,4,13,9,15,15,0,8,12,4,3,3,0] } }
theorem leafL_020_1_valid : (leafL_020_1).reject.ValidFor (leafL_020_1).leaf := by decide

noncomputable def leafL_020_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,89,269}, reject := .fullRank { members := ![0,1,17,34,52,69,89,269], points := ![104,110,124,126,128,131], inverse := ![8,15,12,6,3,15,13,10,12,14,12,9,0,0,5,10,15,0,5,2,1,6,8,8,11,11,5,2,7,0,4,4,11,2,9,0] } }
theorem leafL_020_2_valid : (leafL_020_2).reject.ValidFor (leafL_020_2).leaf := by decide

noncomputable def leafL_020_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,89,271}, reject := .fullRank { members := ![0,1,17,34,52,69,89,271], points := ![99,104,110,115,122,150], inverse := ![7,13,6,1,15,3,1,3,15,9,8,12,7,13,10,0,0,0,6,10,6,0,13,7,10,4,14,15,15,0,12,14,2,3,3,0] } }
theorem leafL_020_3_valid : (leafL_020_3).reject.ValidFor (leafL_020_3).leaf := by decide

noncomputable def leafL_020_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,90,99}, reject := .fullRank { members := ![0,1,17,34,52,69,90,99], points := ![124,135,144,150,151,152], inverse := ![4,0,14,0,11,0,3,12,4,1,15,5,0,0,0,7,14,9,2,10,3,3,12,4,0,11,11,4,5,1,0,3,3,2,12,14] } }
theorem leafL_020_4_valid : (leafL_020_4).reject.ValidFor (leafL_020_4).leaf := by decide

noncomputable def leafL_020_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,90,104}, reject := .fullRank { members := ![0,1,17,34,52,69,90,104], points := ![115,126,127,139,155,166], inverse := ![7,13,8,8,13,6,13,5,11,8,11,0,15,9,6,0,0,0,12,4,11,8,10,1,10,9,13,14,14,14,13,11,10,12,12,12] } }
theorem leafL_020_5_valid : (leafL_020_5).reject.ValidFor (leafL_020_5).leaf := by decide

noncomputable def leafL_020_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,90,110}, reject := .fullRank { members := ![0,1,17,34,52,69,90,110], points := ![115,127,135,137,144,152], inverse := ![14,10,15,7,6,11,15,12,7,7,8,11,0,0,6,10,12,0,9,11,5,5,9,11,3,3,10,10,0,0,10,10,15,4,11,0] } }
theorem leafL_020_6_valid : (leafL_020_6).reject.ValidFor (leafL_020_6).leaf := by decide

noncomputable def leafL_020_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,90,112}, reject := .fullRank { members := ![0,1,17,34,52,69,90,112], points := ![124,126,135,139,151,155], inverse := ![7,3,9,7,7,12,11,8,13,5,4,15,2,2,9,9,8,8,3,1,11,2,5,14,11,11,7,7,1,1,0,0,15,15,15,15] } }
theorem leafL_020_7_valid : (leafL_020_7).reject.ValidFor (leafL_020_7).leaf := by decide

noncomputable def leavesL_020 : List RejectedLeaf := [leafL_020_0,leafL_020_1,leafL_020_2,leafL_020_3,leafL_020_4,leafL_020_5,leafL_020_6,leafL_020_7]

theorem leavesL_020_valid : LeafListValid leavesL_020 := by
  intro x hx
  simp only [leavesL_020, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_020_0_valid
  · exact leafL_020_1_valid
  · exact leafL_020_2_valid
  · exact leafL_020_3_valid
  · exact leafL_020_4_valid
  · exact leafL_020_5_valid
  · exact leafL_020_6_valid
  · exact leafL_020_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
