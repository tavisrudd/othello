import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_249_0 : RejectedLeaf := { leaf := {0,1,17,34,52,72,91,268}, reject := .fullRank { members := ![0,1,17,34,52,72,91,268], points := ![101,103,125,137,141,144], inverse := ![1,6,9,3,2,14,8,15,14,7,11,5,0,0,0,8,10,2,11,12,15,2,1,11,5,5,0,4,13,9,13,13,0,4,2,6] } }
theorem leafL_249_0_valid : (leafL_249_0).reject.ValidFor (leafL_249_0).leaf := by decide

noncomputable def leafL_249_1 : RejectedLeaf := { leaf := {0,1,17,34,52,72,91,269}, reject := .fullRank { members := ![0,1,17,34,52,72,91,269], points := ![103,112,115,117,135,138], inverse := ![3,4,15,6,7,8,1,6,10,4,7,14,12,12,2,2,15,15,12,11,0,15,0,8,9,9,12,12,3,3,6,6,6,6,6,6] } }
theorem leafL_249_1_valid : (leafL_249_1).reject.ValidFor (leafL_249_1).leaf := by decide

noncomputable def leafL_249_2 : RejectedLeaf := { leaf := {0,1,17,34,52,72,92,107}, reject := .fullRank { members := ![0,1,17,34,52,72,92,107], points := ![126,138,149,169,173,175], inverse := ![11,1,4,1,14,0,9,2,1,7,15,2,0,0,0,5,15,10,8,3,1,6,14,2,15,15,15,1,1,15,13,13,13,5,10,2] } }
theorem leafL_249_2_valid : (leafL_249_2).reject.ValidFor (leafL_249_2).leaf := by decide

noncomputable def leafL_249_3 : RejectedLeaf := { leaf := {0,1,17,34,52,72,92,122}, reject := .fullRank { members := ![0,1,17,34,52,72,92,122], points := ![112,135,143,147,149,151], inverse := ![9,6,11,3,0,6,2,9,13,9,9,6,0,0,0,5,10,15,13,0,1,9,11,14,0,8,8,15,2,13,0,1,1,6,8,14] } }
theorem leafL_249_3_valid : (leafL_249_3).reject.ValidFor (leafL_249_3).leaf := by decide

noncomputable def leafL_249_4 : RejectedLeaf := { leaf := {0,1,17,34,52,72,92,126}, reject := .fullRank { members := ![0,1,17,34,52,72,92,126], points := ![101,107,112,135,138,149], inverse := ![11,9,11,6,11,5,15,15,2,8,12,6,15,14,1,0,0,0,8,14,11,1,0,12,11,14,5,7,7,0,6,15,9,4,4,0] } }
theorem leafL_249_4_valid : (leafL_249_4).reject.ValidFor (leafL_249_4).leaf := by decide

noncomputable def leafL_249_5 : RejectedLeaf := { leaf := {0,1,17,34,52,72,92,147}, reject := .fullRank { members := ![0,1,17,34,52,72,92,147], points := ![101,112,122,125,137,138], inverse := ![1,6,15,6,14,1,3,4,8,6,2,11,11,11,11,11,8,8,6,1,0,15,8,0,8,8,12,12,15,15,10,10,1,1,7,7] } }
theorem leafL_249_5_valid : (leafL_249_5).reject.ValidFor (leafL_249_5).leaf := by decide

noncomputable def leafL_249_6 : RejectedLeaf := { leaf := {0,1,17,34,52,72,92,149}, reject := .fullRank { members := ![0,1,17,34,52,72,92,149], points := ![99,107,122,125,126,135], inverse := ![5,2,2,14,5,15,13,10,1,12,3,9,0,0,6,11,13,0,0,7,11,11,15,8,13,13,0,3,3,0,5,5,1,10,11,0] } }
theorem leafL_249_6_valid : (leafL_249_6).reject.ValidFor (leafL_249_6).leaf := by decide

noncomputable def leafL_249_7 : RejectedLeaf := { leaf := {0,1,17,34,52,72,92,151}, reject := .fullRank { members := ![0,1,17,34,52,72,92,151], points := ![99,101,112,122,125,138], inverse := ![6,14,15,14,7,15,7,7,7,14,0,9,15,8,7,0,0,0,15,5,13,11,4,8,12,5,9,14,14,0,3,4,7,8,8,0] } }
theorem leafL_249_7_valid : (leafL_249_7).reject.ValidFor (leafL_249_7).leaf := by decide

noncomputable def leavesL_249 : List RejectedLeaf := [leafL_249_0,leafL_249_1,leafL_249_2,leafL_249_3,leafL_249_4,leafL_249_5,leafL_249_6,leafL_249_7]

theorem leavesL_249_valid : LeafListValid leavesL_249 := by
  intro x hx
  simp only [leavesL_249, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_249_0_valid
  · exact leafL_249_1_valid
  · exact leafL_249_2_valid
  · exact leafL_249_3_valid
  · exact leafL_249_4_valid
  · exact leafL_249_5_valid
  · exact leafL_249_6_valid
  · exact leafL_249_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
