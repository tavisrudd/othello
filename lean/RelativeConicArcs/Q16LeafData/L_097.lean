import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_097_0 : RejectedLeaf := { leaf := {0,1,17,34,52,69,131,268}, reject := .fullRank { members := ![0,1,17,34,52,69,131,268], points := ![89,95,103,112,120,128], inverse := ![14,1,7,15,1,7,9,0,11,5,4,3,7,7,13,13,5,5,0,8,8,7,8,15,3,3,15,15,6,6,12,12,5,5,6,6] } }
theorem leafL_097_0_valid : (leafL_097_0).reject.ValidFor (leafL_097_0).leaf := by decide

noncomputable def leafL_097_1 : RejectedLeaf := { leaf := {0,1,17,34,52,69,131,269}, reject := .fullRank { members := ![0,1,17,34,52,69,131,269], points := ![89,92,103,107,110,126], inverse := ![9,6,2,11,1,6,1,8,9,14,9,7,0,0,4,9,13,0,9,1,12,0,3,7,3,3,0,11,11,0,14,14,3,4,7,0] } }
theorem leafL_097_1_valid : (leafL_097_1).reject.ValidFor (leafL_097_1).leaf := by decide

noncomputable def leafL_097_2 : RejectedLeaf := { leaf := {0,1,17,34,52,69,131,270}, reject := .fullRank { members := ![0,1,17,34,52,69,131,270], points := ![95,112,128,151,152,154], inverse := ![10,5,15,5,15,11,0,13,1,4,9,1,0,0,0,8,3,11,12,4,2,10,8,8,15,4,8,7,2,6,10,9,1,5,0,7] } }
theorem leafL_097_2_valid : (leafL_097_2).reject.ValidFor (leafL_097_2).leaf := by decide

noncomputable def leafL_097_3 : RejectedLeaf := { leaf := {0,1,17,34,52,69,135,150}, reject := .fullRank { members := ![0,1,17,34,52,69,135,150], points := ![90,91,94,99,115,122], inverse := ![0,14,1,8,1,7,5,3,15,14,7,0,10,2,8,0,0,0,14,8,14,15,2,5,1,1,0,0,10,10,9,15,6,0,11,11] } }
theorem leafL_097_3_valid : (leafL_097_3).reject.ValidFor (leafL_097_3).leaf := by decide

noncomputable def leafL_097_4 : RejectedLeaf := { leaf := {0,1,17,34,52,69,135,159}, reject := .fullRank { members := ![0,1,17,34,52,69,135,159], points := ![89,91,106,115,122,124], inverse := ![5,10,8,6,7,7,4,13,14,15,0,8,0,0,0,10,11,1,3,11,15,2,1,4,8,8,0,7,4,3,13,13,0,0,13,13] } }
theorem leafL_097_4_valid : (leafL_097_4).reject.ValidFor (leafL_097_4).leaf := by decide

noncomputable def leafL_097_5 : RejectedLeaf := { leaf := {0,1,17,34,52,69,135,163}, reject := .fullRank { members := ![0,1,17,34,52,69,135,163], points := ![90,91,94,112,122,126], inverse := ![3,10,6,8,13,11,3,8,2,14,10,13,10,2,8,0,0,0,1,3,10,15,0,7,10,8,2,0,9,9,15,0,15,0,15,15] } }
theorem leafL_097_5_valid : (leafL_097_5).reject.ValidFor (leafL_097_5).leaf := by decide

noncomputable def leafL_097_6 : RejectedLeaf := { leaf := {0,1,17,34,52,69,135,166}, reject := .fullRank { members := ![0,1,17,34,52,69,135,166], points := ![89,94,99,106,110,127], inverse := ![11,4,10,11,9,6,7,14,15,6,7,7,0,0,14,12,2,0,1,9,5,11,1,7,1,1,14,13,3,0,11,11,14,1,15,0] } }
theorem leafL_097_6_valid : (leafL_097_6).reject.ValidFor (leafL_097_6).leaf := by decide

noncomputable def leafL_097_7 : RejectedLeaf := { leaf := {0,1,17,34,52,69,135,172}, reject := .fullRank { members := ![0,1,17,34,52,69,135,172], points := ![94,106,110,122,155,182], inverse := ![4,0,13,15,4,3,5,15,9,5,7,1,13,0,2,7,11,3,12,14,8,8,12,14,12,10,5,10,14,7,6,4,0,1,10,9] } }
theorem leafL_097_7_valid : (leafL_097_7).reject.ValidFor (leafL_097_7).leaf := by decide

noncomputable def leavesL_097 : List RejectedLeaf := [leafL_097_0,leafL_097_1,leafL_097_2,leafL_097_3,leafL_097_4,leafL_097_5,leafL_097_6,leafL_097_7]

theorem leavesL_097_valid : LeafListValid leavesL_097 := by
  intro x hx
  simp only [leavesL_097, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_097_0_valid
  · exact leafL_097_1_valid
  · exact leafL_097_2_valid
  · exact leafL_097_3_valid
  · exact leafL_097_4_valid
  · exact leafL_097_5_valid
  · exact leafL_097_6_valid
  · exact leafL_097_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
