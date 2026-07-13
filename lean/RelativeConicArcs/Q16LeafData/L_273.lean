import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_273_0 : RejectedLeaf := { leaf := {0,1,17,34,52,72,147,270}, reject := .fullRank { members := ![0,1,17,34,52,72,147,270], points := ![96,101,112,117,124,137], inverse := ![11,14,2,0,2,4,1,4,2,9,6,8,9,13,4,9,0,9,10,3,14,13,8,2,10,15,5,1,11,10,15,13,2,6,9,15] } }
theorem leafL_273_0_valid : (leafL_273_0).reject.ValidFor (leafL_273_0).leaf := by decide

noncomputable def leafL_273_1 : RejectedLeaf := { leaf := {0,1,17,34,52,72,147,271}, reject := .fullRank { members := ![0,1,17,34,52,72,147,271], points := ![91,103,112,117,124,125], inverse := ![15,1,9,4,14,12,9,6,8,6,11,10,0,0,0,1,5,4,8,0,15,13,13,7,0,4,4,8,4,12,0,15,15,11,3,8] } }
theorem leafL_273_1_valid : (leafL_273_1).reject.ValidFor (leafL_273_1).leaf := by decide

noncomputable def leafL_273_2 : RejectedLeaf := { leaf := {0,1,17,34,52,72,149,191}, reject := .fullRank { members := ![0,1,17,34,52,72,149,191], points := ![90,91,92,99,103,122], inverse := ![7,8,0,4,12,6,14,14,9,12,2,7,7,14,9,0,0,0,2,14,4,4,11,7,1,7,6,1,1,0,8,2,10,13,13,0] } }
theorem leafL_273_2_valid : (leafL_273_2).reject.ValidFor (leafL_273_2).leaf := by decide

noncomputable def leafL_273_3 : RejectedLeaf := { leaf := {0,1,17,34,52,72,149,203}, reject := .fullRank { members := ![0,1,17,34,52,72,149,203], points := ![92,122,126,141,166,173], inverse := ![15,6,13,4,14,15,3,4,6,8,3,10,5,10,7,14,5,3,0,4,13,2,7,12,14,14,12,9,4,1,10,5,12,15,9,5] } }
theorem leafL_273_3_valid : (leafL_273_3).reject.ValidFor (leafL_273_3).leaf := by decide

noncomputable def leafL_273_4 : RejectedLeaf := { leaf := {0,1,17,34,52,72,149,217}, reject := .fullRank { members := ![0,1,17,34,52,72,149,217], points := ![91,94,99,107,122,125], inverse := ![15,0,11,3,2,4,11,2,6,8,2,5,15,15,2,2,7,7,11,3,1,14,0,7,8,8,6,6,12,12,12,12,2,2,11,11] } }
theorem leafL_273_4_valid : (leafL_273_4).reject.ValidFor (leafL_273_4).leaf := by decide

noncomputable def leafL_273_5 : RejectedLeaf := { leaf := {0,1,17,34,52,72,149,233}, reject := .fullRank { members := ![0,1,17,34,52,72,149,233], points := ![91,94,99,128,135,163], inverse := ![1,15,15,6,2,4,4,12,3,4,7,8,5,6,15,1,5,8,1,10,15,13,11,2,6,13,15,4,9,9,2,11,1,4,13,1] } }
theorem leafL_273_5_valid : (leafL_273_5).reject.ValidFor (leafL_273_5).leaf := by decide

noncomputable def leafL_273_6 : RejectedLeaf := { leaf := {0,1,17,34,52,72,149,251}, reject := .fullRank { members := ![0,1,17,34,52,72,149,251], points := ![94,99,103,122,125,126], inverse := ![15,10,2,10,10,6,9,2,12,6,11,10,0,0,0,6,11,13,8,15,0,7,5,5,0,9,9,15,10,5,0,10,10,10,0,10] } }
theorem leafL_273_6_valid : (leafL_273_6).reject.ValidFor (leafL_273_6).leaf := by decide

noncomputable def leafL_273_7 : RejectedLeaf := { leaf := {0,1,17,34,52,72,149,263}, reject := .fullRank { members := ![0,1,17,34,52,72,149,263], points := ![90,94,107,122,128,144], inverse := ![1,9,15,12,13,7,3,3,7,15,1,9,13,7,10,14,4,10,14,2,11,6,5,4,4,4,0,14,14,0,2,8,10,4,14,10] } }
theorem leafL_273_7_valid : (leafL_273_7).reject.ValidFor (leafL_273_7).leaf := by decide

noncomputable def leavesL_273 : List RejectedLeaf := [leafL_273_0,leafL_273_1,leafL_273_2,leafL_273_3,leafL_273_4,leafL_273_5,leafL_273_6,leafL_273_7]

theorem leavesL_273_valid : LeafListValid leavesL_273 := by
  intro x hx
  simp only [leavesL_273, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_273_0_valid
  · exact leafL_273_1_valid
  · exact leafL_273_2_valid
  · exact leafL_273_3_valid
  · exact leafL_273_4_valid
  · exact leafL_273_5_valid
  · exact leafL_273_6_valid
  · exact leafL_273_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
