import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_099_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,135,236}, reject := .fullRank { members := ![0,1,17,34,52,69,135,236], points := ![89,90,99,106,110,115], inverse := ![9,6,11,11,8,6,12,5,0,12,2,7,0,0,14,12,2,0,5,13,8,15,8,7,5,5,2,15,13,0,1,1,3,4,7,0] } }
theorem leafL_099_0_valid : (leafL_099_0).reject.ValidFor (leafL_099_0).leaf := by decide

noncomputable def leafL_099_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,135,248}, reject := .fullRank { members := ![0,1,17,34,52,69,135,248], points := ![89,90,91,106,110,115], inverse := ![14,13,12,15,7,6,12,5,0,12,2,7,9,14,7,0,0,0,9,5,4,2,13,7,6,7,1,1,1,0,10,2,8,13,13,0] } }
theorem leafL_099_1_valid : (leafL_099_1).reject.ValidFor (leafL_099_1).leaf := by decide

noncomputable def leafL_099_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,135,249}, reject := .fullRank { members := ![0,1,17,34,52,69,135,249], points := ![90,92,94,112,115,126], inverse := ![2,6,11,8,8,14,5,1,13,14,9,14,15,10,5,0,0,0,15,15,8,15,0,7,11,10,1,0,3,3,7,1,6,0,4,4] } }
theorem leafL_099_2_valid : (leafL_099_2).reject.ValidFor (leafL_099_2).leaf := by decide

noncomputable def leafL_099_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,135,262}, reject := .fullRank { members := ![0,1,17,34,52,69,135,262], points := ![90,91,92,106,112,124], inverse := ![5,11,1,2,10,6,10,7,4,5,11,7,7,14,9,0,0,0,8,8,8,14,1,7,12,14,2,15,15,0,6,13,11,7,7,0] } }
theorem leafL_099_3_valid : (leafL_099_3).reject.ValidFor (leafL_099_3).leaf := by decide

noncomputable def leafL_099_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,135,269}, reject := .fullRank { members := ![0,1,17,34,52,69,135,269], points := ![89,90,91,112,124,126], inverse := ![3,15,3,8,7,1,1,7,15,14,12,11,9,14,7,0,0,0,6,4,10,15,0,7,13,6,11,0,14,14,12,15,3,0,10,10] } }
theorem leafL_099_4_valid : (leafL_099_4).reject.ValidFor (leafL_099_4).leaf := by decide

noncomputable def leafL_099_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,135,270}, reject := .fullRank { members := ![0,1,17,34,52,69,135,270], points := ![91,99,112,122,124,127], inverse := ![15,2,10,5,8,11,9,12,2,12,6,13,0,0,0,3,12,15,8,0,15,2,4,1,0,8,8,10,0,10,0,13,13,8,14,6] } }
theorem leafL_099_5_valid : (leafL_099_5).reject.ValidFor (leafL_099_5).leaf := by decide

noncomputable def leafL_099_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,138,150}, reject := .fullRank { members := ![0,1,17,34,52,69,138,150], points := ![91,95,99,107,115,128], inverse := ![14,1,5,13,1,7,2,11,8,6,13,10,2,2,15,15,2,2,10,2,11,4,15,8,14,14,6,6,2,2,6,6,7,7,11,11] } }
theorem leafL_099_6_valid : (leafL_099_6).reject.ValidFor (leafL_099_6).leaf := by decide

noncomputable def leafL_099_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,138,166}, reject := .fullRank { members := ![0,1,17,34,52,69,138,166], points := ![99,128,151,152,155,183], inverse := ![6,10,0,5,11,3,10,9,12,7,14,6,0,0,10,4,14,0,11,8,13,6,15,7,3,15,12,7,14,9,2,10,11,13,0,14] } }
theorem leafL_099_7_valid : (leafL_099_7).reject.ValidFor (leafL_099_7).leaf := by decide

noncomputable def leavesL_099 : List RejectedLeaf := [leafL_099_0,leafL_099_1,leafL_099_2,leafL_099_3,leafL_099_4,leafL_099_5,leafL_099_6,leafL_099_7]

theorem leavesL_099_valid : LeafListValid leavesL_099 := by
  intro x hx
  simp only [leavesL_099, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_099_0_valid
  · exact leafL_099_1_valid
  · exact leafL_099_2_valid
  · exact leafL_099_3_valid
  · exact leafL_099_4_valid
  · exact leafL_099_5_valid
  · exact leafL_099_6_valid
  · exact leafL_099_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
