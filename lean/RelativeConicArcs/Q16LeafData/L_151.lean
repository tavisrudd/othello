import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_151_0 : RejectedLeaf := { leaf := {0,1,17,34,52,70,125,147}, reject := .fullRank { members := ![0,1,17,34,52,70,125,147], points := ![90,91,101,103,110,137], inverse := ![5,12,2,7,11,6,5,11,7,5,11,7,0,0,1,11,10,0,3,12,10,15,13,7,3,3,5,6,3,0,14,14,8,2,10,0] } }
theorem leafL_151_0_valid : (leafL_151_0).reject.ValidFor (leafL_151_0).leaf := by decide

noncomputable def leafL_151_1 : RejectedLeaf := { leaf := {0,1,17,34,52,70,125,149}, reject := .fullRank { members := ![0,1,17,34,52,70,125,149], points := ![91,95,103,135,144,171], inverse := ![5,5,4,0,7,2,5,4,2,11,1,9,3,8,4,2,7,10,11,5,15,9,12,4,14,12,14,14,10,8,7,5,14,8,12,8] } }
theorem leafL_151_1_valid : (leafL_151_1).reject.ValidFor (leafL_151_1).leaf := by decide

noncomputable def leafL_151_2 : RejectedLeaf := { leaf := {0,1,17,34,52,70,125,152}, reject := .fullRank { members := ![0,1,17,34,52,70,125,152], points := ![90,94,103,135,137,139], inverse := ![9,0,14,11,12,1,2,12,9,10,8,5,0,0,0,13,8,5,13,2,8,13,8,2,3,3,0,3,5,6,10,10,0,9,4,13] } }
theorem leafL_151_2_valid : (leafL_151_2).reject.ValidFor (leafL_151_2).leaf := by decide

noncomputable def leafL_151_3 : RejectedLeaf := { leaf := {0,1,17,34,52,70,125,158}, reject := .fullRank { members := ![0,1,17,34,52,70,125,158], points := ![95,101,103,131,139,172], inverse := ![5,1,13,6,11,5,5,15,2,2,0,10,4,5,10,13,5,3,1,8,12,10,2,13,0,5,5,3,3,0,7,15,9,2,12,15] } }
theorem leafL_151_3_valid : (leafL_151_3).reject.ValidFor (leafL_151_3).leaf := by decide

noncomputable def leafL_151_4 : RejectedLeaf := { leaf := {0,1,17,34,52,70,125,171}, reject := .fullRank { members := ![0,1,17,34,52,70,125,171], points := ![90,94,101,103,137,144], inverse := ![7,14,1,15,11,13,5,11,9,0,11,12,1,1,3,3,12,12,15,0,6,14,14,9,3,3,0,0,8,8,11,11,3,3,14,14] } }
theorem leafL_151_4_valid : (leafL_151_4).reject.ValidFor (leafL_151_4).leaf := by decide

noncomputable def leafL_151_5 : RejectedLeaf := { leaf := {0,1,17,34,52,70,125,185}, reject := .fullRank { members := ![0,1,17,34,52,70,125,185], points := ![91,94,135,139,144,147], inverse := ![9,1,8,12,7,10,11,13,6,13,2,15,0,0,7,2,5,0,7,3,8,14,0,2,14,14,12,9,5,0,2,2,11,5,14,0] } }
theorem leafL_151_5_valid : (leafL_151_5).reject.ValidFor (leafL_151_5).leaf := by decide

noncomputable def leafL_151_6 : RejectedLeaf := { leaf := {0,1,17,34,52,70,125,186}, reject := .fullRank { members := ![0,1,17,34,52,70,125,186], points := ![91,95,101,103,131,135], inverse := ![8,1,5,11,10,12,8,6,9,0,10,13,6,6,10,10,3,3,10,5,1,9,14,9,8,8,14,14,2,2,10,10,0,0,10,10] } }
theorem leafL_151_6_valid : (leafL_151_6).reject.ValidFor (leafL_151_6).leaf := by decide

noncomputable def leafL_151_7 : RejectedLeaf := { leaf := {0,1,17,34,52,70,125,188}, reject := .fullRank { members := ![0,1,17,34,52,70,125,188], points := ![90,94,103,110,131,137], inverse := ![11,2,7,9,4,2,5,11,12,5,11,12,5,5,12,12,1,1,3,12,2,10,12,11,0,0,4,4,13,13,11,11,13,13,15,15] } }
theorem leafL_151_7_valid : (leafL_151_7).reject.ValidFor (leafL_151_7).leaf := by decide

noncomputable def leavesL_151 : List RejectedLeaf := [leafL_151_0,leafL_151_1,leafL_151_2,leafL_151_3,leafL_151_4,leafL_151_5,leafL_151_6,leafL_151_7]

theorem leavesL_151_valid : LeafListValid leavesL_151 := by
  intro x hx
  simp only [leavesL_151, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_151_0_valid
  · exact leafL_151_1_valid
  · exact leafL_151_2_valid
  · exact leafL_151_3_valid
  · exact leafL_151_4_valid
  · exact leafL_151_5_valid
  · exact leafL_151_6_valid
  · exact leafL_151_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
