import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_268_0 : RejectedLeaf := { leaf := {0,1,17,34,52,72,135,190}, reject := .fullRank { members := ![0,1,17,34,52,72,135,190], points := ![90,99,115,122,149,150], inverse := ![6,11,3,3,1,13,14,15,9,12,10,14,6,7,15,1,15,0,2,6,5,3,5,7,10,9,3,2,8,10,8,5,8,2,4,3] } }
theorem leafL_268_0_valid : (leafL_268_0).reject.ValidFor (leafL_268_0).leaf := by decide

noncomputable def leafL_268_1 : RejectedLeaf := { leaf := {0,1,17,34,52,72,135,208}, reject := .fullRank { members := ![0,1,17,34,52,72,135,208], points := ![91,94,108,117,125,126], inverse := ![9,6,8,9,15,0,10,3,14,1,8,14,0,0,0,13,15,2,3,11,15,3,5,1,10,10,0,6,1,7,3,3,0,4,11,15] } }
theorem leafL_268_1_valid : (leafL_268_1).reject.ValidFor (leafL_268_1).leaf := by decide

noncomputable def leafL_268_2 : RejectedLeaf := { leaf := {0,1,17,34,52,72,135,213}, reject := .fullRank { members := ![0,1,17,34,52,72,135,213], points := ![91,99,108,122,126,128], inverse := ![15,13,5,10,13,1,9,15,1,7,13,13,0,0,0,5,15,10,8,1,14,15,5,13,0,4,4,8,3,11,0,15,15,14,6,8] } }
theorem leafL_268_2_valid : (leafL_268_2).reject.ValidFor (leafL_268_2).leaf := by decide

noncomputable def leafL_268_3 : RejectedLeaf := { leaf := {0,1,17,34,52,72,135,239}, reject := .fullRank { members := ![0,1,17,34,52,72,135,239], points := ![90,94,108,115,117,126], inverse := ![11,4,8,3,0,5,4,13,14,15,5,13,0,0,0,13,14,3,15,7,15,8,11,4,4,4,0,14,14,0,15,15,0,7,4,3] } }
theorem leafL_268_3_valid : (leafL_268_3).reject.ValidFor (leafL_268_3).leaf := by decide

noncomputable def leafL_268_4 : RejectedLeaf := { leaf := {0,1,17,34,52,72,135,243}, reject := .fullRank { members := ![0,1,17,34,52,72,135,243], points := ![90,117,122,125,149,159], inverse := ![2,15,3,9,5,3,5,6,9,7,9,4,0,9,10,3,0,0,3,5,5,10,11,2,0,13,12,1,1,1,0,1,9,8,7,7] } }
theorem leafL_268_4_valid : (leafL_268_4).reject.ValidFor (leafL_268_4).leaf := by decide

noncomputable def leafL_268_5 : RejectedLeaf := { leaf := {0,1,17,34,52,72,135,262}, reject := .fullRank { members := ![0,1,17,34,52,72,135,262], points := ![90,91,92,108,125,126], inverse := ![15,3,3,8,2,4,6,12,3,14,1,6,7,14,9,0,0,0,6,0,14,15,13,10,7,13,10,0,2,2,0,9,9,0,9,9] } }
theorem leafL_268_5_valid : (leafL_268_5).reject.ValidFor (leafL_268_5).leaf := by decide

noncomputable def leafL_268_6 : RejectedLeaf := { leaf := {0,1,17,34,52,72,135,269}, reject := .fullRank { members := ![0,1,17,34,52,72,135,269], points := ![91,92,94,115,117,149], inverse := ![1,3,0,13,8,6,10,13,2,0,8,13,6,7,1,0,0,0,6,4,1,14,4,9,7,8,15,14,14,0,0,10,10,10,10,0] } }
theorem leafL_268_6_valid : (leafL_268_6).reject.ValidFor (leafL_268_6).leaf := by decide

noncomputable def leafL_268_7 : RejectedLeaf := { leaf := {0,1,17,34,52,72,138,147}, reject := .fullRank { members := ![0,1,17,34,52,72,138,147], points := ![91,92,101,103,125,128], inverse := ![10,5,12,4,1,7,15,6,0,14,6,1,4,4,13,13,10,10,6,14,12,3,3,4,4,4,12,12,11,11,13,13,13,13,13,13] } }
theorem leafL_268_7_valid : (leafL_268_7).reject.ValidFor (leafL_268_7).leaf := by decide

noncomputable def leavesL_268 : List RejectedLeaf := [leafL_268_0,leafL_268_1,leafL_268_2,leafL_268_3,leafL_268_4,leafL_268_5,leafL_268_6,leafL_268_7]

theorem leavesL_268_valid : LeafListValid leavesL_268 := by
  intro x hx
  simp only [leavesL_268, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_268_0_valid
  · exact leafL_268_1_valid
  · exact leafL_268_2_valid
  · exact leafL_268_3_valid
  · exact leafL_268_4_valid
  · exact leafL_268_5_valid
  · exact leafL_268_6_valid
  · exact leafL_268_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
