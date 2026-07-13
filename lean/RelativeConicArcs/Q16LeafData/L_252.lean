import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_252_0 : RejectedLeaf := { leaf := {0,1,17,34,52,72,93,243}, reject := .fullRank { members := ![0,1,17,34,52,72,93,243], points := ![101,124,139,144,151,159], inverse := ![0,4,0,14,11,0,4,5,6,5,13,15,7,13,11,10,10,1,3,9,3,0,12,5,4,6,4,15,5,12,14,9,2,0,6,3] } }
theorem leafL_252_0_valid : (leafL_252_0).reject.ValidFor (leafL_252_0).leaf := by decide

noncomputable def leafL_252_1 : RejectedLeaf := { leaf := {0,1,17,34,52,72,93,249}, reject := .fullRank { members := ![0,1,17,34,52,72,93,249], points := ![103,108,115,117,126,144], inverse := ![8,15,0,6,15,15,9,14,14,7,7,9,0,0,13,14,3,0,14,9,7,6,14,8,8,8,13,8,5,0,13,13,14,5,11,0] } }
theorem leafL_252_1_valid : (leafL_252_1).reject.ValidFor (leafL_252_1).leaf := by decide

noncomputable def leafL_252_2 : RejectedLeaf := { leaf := {0,1,17,34,52,72,93,251}, reject := .fullRank { members := ![0,1,17,34,52,72,93,251], points := ![101,103,124,126,128,137], inverse := ![14,9,7,7,9,15,6,1,13,15,12,9,0,0,5,10,15,0,11,12,3,7,11,8,1,1,10,15,5,0,7,7,0,7,7,0] } }
theorem leafL_252_2_valid : (leafL_252_2).reject.ValidFor (leafL_252_2).leaf := by decide

noncomputable def leafL_252_3 : RejectedLeaf := { leaf := {0,1,17,34,52,72,93,263}, reject := .fullRank { members := ![0,1,17,34,52,72,93,263], points := ![101,108,115,128,139,144], inverse := ![10,13,1,8,11,4,4,3,5,11,2,11,3,3,3,3,15,15,7,0,15,0,14,6,11,11,4,4,14,14,11,11,15,15,10,10] } }
theorem leafL_252_3_valid : (leafL_252_3).reject.ValidFor (leafL_252_3).leaf := by decide

noncomputable def leafL_252_4 : RejectedLeaf := { leaf := {0,1,17,34,52,72,93,268}, reject := .fullRank { members := ![0,1,17,34,52,72,93,268], points := ![103,126,137,139,144,150], inverse := ![4,2,5,15,15,2,13,1,8,11,3,12,0,0,3,12,15,0,14,11,1,14,4,14,2,3,14,11,9,13,12,10,6,3,11,8] } }
theorem leafL_252_4_valid : (leafL_252_4).reject.ValidFor (leafL_252_4).leaf := by decide

noncomputable def leafL_252_5 : RejectedLeaf := { leaf := {0,1,17,34,52,72,93,270}, reject := .fullRank { members := ![0,1,17,34,52,72,93,270], points := ![101,108,117,124,128,137], inverse := ![15,8,5,0,12,15,4,3,14,1,1,9,0,0,14,2,12,0,0,7,13,1,3,8,3,3,14,6,8,0,9,9,9,9,0,0] } }
theorem leafL_252_5_valid : (leafL_252_5).reject.ValidFor (leafL_252_5).leaf := by decide

noncomputable def leafL_252_6 : RejectedLeaf := { leaf := {0,1,17,34,52,72,94,103}, reject := .fullRank { members := ![0,1,17,34,52,72,94,103], points := ![124,143,149,150,169,173], inverse := ![1,11,9,7,0,5,15,4,0,7,15,3,7,7,5,2,5,2,10,1,9,10,0,8,11,11,15,4,4,15,8,8,3,11,15,7] } }
theorem leafL_252_6_valid : (leafL_252_6).reject.ValidFor (leafL_252_6).leaf := by decide

noncomputable def leafL_252_7 : RejectedLeaf := { leaf := {0,1,17,34,52,72,94,107}, reject := .fullRank { members := ![0,1,17,34,52,72,94,107], points := ![122,124,137,144,149,166], inverse := ![10,15,1,14,10,1,11,15,5,10,12,7,4,12,7,15,8,8,6,1,4,8,14,5,3,2,12,13,1,1,14,0,14,0,14,14] } }
theorem leafL_252_7_valid : (leafL_252_7).reject.ValidFor (leafL_252_7).leaf := by decide

noncomputable def leavesL_252 : List RejectedLeaf := [leafL_252_0,leafL_252_1,leafL_252_2,leafL_252_3,leafL_252_4,leafL_252_5,leafL_252_6,leafL_252_7]

theorem leavesL_252_valid : LeafListValid leavesL_252 := by
  intro x hx
  simp only [leavesL_252, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_252_0_valid
  · exact leafL_252_1_valid
  · exact leafL_252_2_valid
  · exact leafL_252_3_valid
  · exact leafL_252_4_valid
  · exact leafL_252_5_valid
  · exact leafL_252_6_valid
  · exact leafL_252_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
