import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_170_0 : RejectedLeaf := { leaf := {0,1,17,34,52,71,94,109}, reject := .fullRank { members := ![0,1,17,34,52,71,94,109], points := ![120,124,127,131,140,155], inverse := ![0,0,4,14,0,11,0,13,14,3,11,11,7,2,5,0,0,0,5,12,11,6,15,11,4,1,5,12,12,0,2,0,2,2,2,0] } }
theorem leafL_170_0_valid : (leafL_170_0).reject.ValidFor (leafL_170_0).leaf := by decide

noncomputable def leafL_170_1 : RejectedLeaf := { leaf := {0,1,17,34,52,71,94,128}, reject := .fullRank { members := ![0,1,17,34,52,71,94,128], points := ![101,104,131,140,155,166], inverse := ![9,8,6,2,8,12,6,3,1,9,0,13,1,6,9,5,6,13,15,4,2,1,13,5,7,0,12,0,6,13,2,10,10,3,13,12] } }
theorem leafL_170_1_valid : (leafL_170_1).reject.ValidFor (leafL_170_1).leaf := by decide

noncomputable def leafL_170_2 : RejectedLeaf := { leaf := {0,1,17,34,52,71,94,131}, reject := .fullRank { members := ![0,1,17,34,52,71,94,131], points := ![101,109,121,128,156,169], inverse := ![2,3,1,5,12,8,13,12,10,15,10,14,13,2,12,9,14,4,3,9,3,14,7,0,6,10,11,15,6,14,9,15,11,9,3,7] } }
theorem leafL_170_2_valid : (leafL_170_2).reject.ValidFor (leafL_170_2).leaf := by decide

noncomputable def leafL_170_3 : RejectedLeaf := { leaf := {0,1,17,34,52,71,94,140}, reject := .fullRank { members := ![0,1,17,34,52,71,94,140], points := ![104,106,109,120,127,155], inverse := ![0,12,0,0,14,3,12,1,0,8,9,12,15,14,1,0,0,0,3,11,2,14,3,7,13,10,7,6,6,0,9,5,12,15,15,0] } }
theorem leafL_170_3_valid : (leafL_170_3).reject.ValidFor (leafL_170_3).leaf := by decide

noncomputable def leafL_170_4 : RejectedLeaf := { leaf := {0,1,17,34,52,71,94,155}, reject := .fullRank { members := ![0,1,17,34,52,71,94,155], points := ![101,104,109,120,128,140], inverse := ![7,3,3,8,1,15,12,9,2,7,9,9,5,3,6,0,0,0,15,6,14,15,0,8,3,11,8,2,2,0,5,0,5,5,5,0] } }
theorem leafL_170_4_valid : (leafL_170_4).reject.ValidFor (leafL_170_4).leaf := by decide

noncomputable def leafL_170_5 : RejectedLeaf := { leaf := {0,1,17,34,52,71,94,166}, reject := .fullRank { members := ![0,1,17,34,52,71,94,166], points := ![106,109,120,121,128,133], inverse := ![1,6,14,3,4,15,6,1,4,2,8,9,0,0,1,5,4,0,0,7,0,2,13,8,5,5,3,5,6,0,8,8,15,4,11,0] } }
theorem leafL_170_5_valid : (leafL_170_5).reject.ValidFor (leafL_170_5).leaf := by decide

noncomputable def leafL_170_6 : RejectedLeaf := { leaf := {0,1,17,34,52,71,94,169}, reject := .fullRank { members := ![0,1,17,34,52,71,94,169], points := ![104,106,122,124,127,131], inverse := ![0,7,0,0,9,15,12,11,15,3,2,9,0,0,3,12,15,0,14,9,0,4,11,8,6,6,0,14,14,0,1,1,11,2,9,0] } }
theorem leafL_170_6_valid : (leafL_170_6).reject.ValidFor (leafL_170_6).leaf := by decide

noncomputable def leafL_170_7 : RejectedLeaf := { leaf := {0,1,17,34,52,71,94,172}, reject := .fullRank { members := ![0,1,17,34,52,71,94,172], points := ![104,106,120,128,131,133], inverse := ![11,12,12,5,11,4,1,6,7,9,12,5,10,10,8,8,3,3,12,11,6,9,6,14,8,8,4,4,12,12,6,6,6,6,6,6] } }
theorem leafL_170_7_valid : (leafL_170_7).reject.ValidFor (leafL_170_7).leaf := by decide

noncomputable def leavesL_170 : List RejectedLeaf := [leafL_170_0,leafL_170_1,leafL_170_2,leafL_170_3,leafL_170_4,leafL_170_5,leafL_170_6,leafL_170_7]

theorem leavesL_170_valid : LeafListValid leavesL_170 := by
  intro x hx
  simp only [leavesL_170, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_170_0_valid
  · exact leafL_170_1_valid
  · exact leafL_170_2_valid
  · exact leafL_170_3_valid
  · exact leafL_170_4_valid
  · exact leafL_170_5_valid
  · exact leafL_170_6_valid
  · exact leafL_170_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
