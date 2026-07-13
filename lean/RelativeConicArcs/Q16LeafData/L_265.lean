import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_265_0 : RejectedLeaf := { leaf := {0,1,17,34,52,72,125,172}, reject := .fullRank { members := ![0,1,17,34,52,72,125,172], points := ![90,91,103,135,138,139], inverse := ![9,0,14,8,4,10,13,3,9,9,13,3,0,0,0,15,9,6,6,9,8,8,6,9,4,4,0,2,2,0,11,11,0,0,11,11] } }
theorem leafL_265_0_valid : (leafL_265_0).reject.ValidFor (leafL_265_0).leaf := by decide

noncomputable def leafL_265_1 : RejectedLeaf := { leaf := {0,1,17,34,52,72,125,181}, reject := .fullRank { members := ![0,1,17,34,52,72,125,181], points := ![90,91,103,108,112,135], inverse := ![8,1,12,11,9,6,13,3,13,9,13,7,0,0,8,1,9,0,11,4,8,8,8,7,3,3,10,13,7,0,14,14,13,10,7,0] } }
theorem leafL_265_1_valid : (leafL_265_1).reject.ValidFor (leafL_265_1).leaf := by decide

noncomputable def leafL_265_2 : RejectedLeaf := { leaf := {0,1,17,34,52,72,125,190}, reject := .fullRank { members := ![0,1,17,34,52,72,125,190], points := ![90,99,139,144,147,149], inverse := ![8,0,13,14,15,5,10,4,4,4,6,8,12,4,10,3,0,1,2,2,11,0,5,14,12,4,7,14,5,4,13,10,5,9,13,6] } }
theorem leafL_265_2_valid : (leafL_265_2).reject.ValidFor (leafL_265_2).leaf := by decide

noncomputable def leafL_265_3 : RejectedLeaf := { leaf := {0,1,17,34,52,72,125,199}, reject := .fullRank { members := ![0,1,17,34,52,72,125,199], points := ![90,99,108,112,137,138], inverse := ![9,3,4,9,12,10,14,5,7,11,0,7,0,8,9,1,0,0,15,5,1,12,13,10,0,14,0,14,11,11,0,7,3,4,9,9] } }
theorem leafL_265_3_valid : (leafL_265_3).reject.ValidFor (leafL_265_3).leaf := by decide

noncomputable def leafL_265_4 : RejectedLeaf := { leaf := {0,1,17,34,52,72,125,201}, reject := .fullRank { members := ![0,1,17,34,52,72,125,201], points := ![90,92,99,103,112,139], inverse := ![15,6,8,13,11,6,7,9,12,3,6,7,0,0,1,9,8,0,11,4,4,10,6,7,11,11,8,12,4,0,9,9,11,14,5,0] } }
theorem leafL_265_4_valid : (leafL_265_4).reject.ValidFor (leafL_265_4).leaf := by decide

noncomputable def leafL_265_5 : RejectedLeaf := { leaf := {0,1,17,34,52,72,125,208}, reject := .fullRank { members := ![0,1,17,34,52,72,125,208], points := ![90,91,103,135,137,138], inverse := ![9,0,14,4,5,7,13,3,9,11,8,4,0,0,0,11,3,8,6,9,8,6,13,12,4,4,0,2,0,2,11,11,0,3,12,15] } }
theorem leafL_265_5_valid : (leafL_265_5).reject.ValidFor (leafL_265_5).leaf := by decide

noncomputable def leafL_265_6 : RejectedLeaf := { leaf := {0,1,17,34,52,72,125,213}, reject := .fullRank { members := ![0,1,17,34,52,72,125,213], points := ![91,99,103,108,138,139], inverse := ![9,4,3,9,15,9,14,3,4,14,0,7,0,9,1,8,0,0,15,13,8,13,3,4,0,11,11,0,8,8,0,10,5,15,7,7] } }
theorem leafL_265_6_valid : (leafL_265_6).reject.ValidFor (leafL_265_6).leaf := by decide

noncomputable def leafL_265_7 : RejectedLeaf := { leaf := {0,1,17,34,52,72,125,217}, reject := .fullRank { members := ![0,1,17,34,52,72,125,217], points := ![91,99,108,135,139,144], inverse := ![9,12,2,11,14,3,14,1,8,15,15,7,0,0,0,7,2,5,15,9,1,8,12,3,0,7,7,15,1,14,0,1,1,1,0,1] } }
theorem leafL_265_7_valid : (leafL_265_7).reject.ValidFor (leafL_265_7).leaf := by decide

noncomputable def leavesL_265 : List RejectedLeaf := [leafL_265_0,leafL_265_1,leafL_265_2,leafL_265_3,leafL_265_4,leafL_265_5,leafL_265_6,leafL_265_7]

theorem leavesL_265_valid : LeafListValid leavesL_265 := by
  intro x hx
  simp only [leavesL_265, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_265_0_valid
  · exact leafL_265_1_valid
  · exact leafL_265_2_valid
  · exact leafL_265_3_valid
  · exact leafL_265_4_valid
  · exact leafL_265_5_valid
  · exact leafL_265_6_valid
  · exact leafL_265_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
