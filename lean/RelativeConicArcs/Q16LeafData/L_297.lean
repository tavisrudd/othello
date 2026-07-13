import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_297_0 : RejectedLeaf := { leaf := {0,1,17,34,52,74,92,117}, reject := .fullRank { members := ![0,1,17,34,52,74,92,117], points := ![107,109,112,137,143,147], inverse := ![6,3,12,1,12,5,12,0,14,8,12,6,4,12,8,0,0,0,9,13,9,5,4,12,8,13,5,4,4,0,10,10,0,10,10,0] } }
theorem leafL_297_0_valid : (leafL_297_0).reject.ValidFor (leafL_297_0).leaf := by decide

noncomputable def leafL_297_1 : RejectedLeaf := { leaf := {0,1,17,34,52,74,92,121}, reject := .fullRank { members := ![0,1,17,34,52,74,92,121], points := ![101,107,112,131,133,151], inverse := ![14,13,10,1,12,5,12,13,3,13,9,6,15,14,1,0,0,0,6,14,5,7,6,12,3,10,9,4,4,0,1,5,4,10,10,0] } }
theorem leafL_297_1_valid : (leafL_297_1).reject.ValidFor (leafL_297_1).leaf := by decide

noncomputable def leafL_297_2 : RejectedLeaf := { leaf := {0,1,17,34,52,74,92,152}, reject := .fullRank { members := ![0,1,17,34,52,74,92,152], points := ![109,112,121,125,131,143], inverse := ![4,3,2,11,1,14,5,2,3,13,2,11,6,6,5,5,11,11,8,15,2,13,5,13,6,6,0,0,2,2,5,5,3,3,13,13] } }
theorem leafL_297_2_valid : (leafL_297_2).reject.ValidFor (leafL_297_2).leaf := by decide

noncomputable def leafL_297_3 : RejectedLeaf := { leaf := {0,1,17,34,52,74,92,173}, reject := .fullRank { members := ![0,1,17,34,52,74,92,173], points := ![112,117,131,137,147,151], inverse := ![9,0,3,14,3,6,5,13,13,8,11,6,12,10,3,13,5,13,10,13,11,11,10,13,0,0,15,15,14,14,6,5,2,5,9,13] } }
theorem leafL_297_3_valid : (leafL_297_3).reject.ValidFor (leafL_297_3).leaf := by decide

noncomputable def leafL_297_4 : RejectedLeaf := { leaf := {0,1,17,34,52,74,92,203}, reject := .fullRank { members := ![0,1,17,34,52,74,92,203], points := ![109,112,125,131,133,137], inverse := ![9,14,9,5,0,10,7,0,14,6,2,13,0,0,0,2,3,1,5,2,15,2,3,9,6,6,0,0,2,2,7,7,0,15,4,11] } }
theorem leafL_297_4_valid : (leafL_297_4).reject.ValidFor (leafL_297_4).leaf := by decide

noncomputable def leafL_297_5 : RejectedLeaf := { leaf := {0,1,17,34,52,74,92,216}, reject := .fullRank { members := ![0,1,17,34,52,74,92,216], points := ![101,109,117,125,131,133], inverse := ![0,7,13,4,11,4,7,0,14,0,0,9,15,15,13,13,9,9,0,7,8,7,0,8,12,12,0,0,4,4,5,5,5,5,0,0] } }
theorem leafL_297_5_valid : (leafL_297_5).reject.ValidFor (leafL_297_5).leaf := by decide

noncomputable def leafL_297_6 : RejectedLeaf := { leaf := {0,1,17,34,52,74,92,231}, reject := .fullRank { members := ![0,1,17,34,52,74,92,231], points := ![101,107,109,117,125,131], inverse := ![2,4,1,15,6,15,10,9,4,3,13,9,2,9,11,0,0,0,4,8,11,12,3,8,14,4,10,2,2,0,5,0,5,5,5,0] } }
theorem leafL_297_6_valid : (leafL_297_6).reject.ValidFor (leafL_297_6).leaf := by decide

noncomputable def leafL_297_7 : RejectedLeaf := { leaf := {0,1,17,34,52,74,92,256}, reject := .fullRank { members := ![0,1,17,34,52,74,92,256], points := ![109,117,137,151,152,155], inverse := ![4,2,5,14,0,12,14,10,10,14,15,15,0,0,0,10,4,14,0,2,9,11,12,12,5,14,13,2,7,3,6,5,7,14,13,7] } }
theorem leafL_297_7_valid : (leafL_297_7).reject.ValidFor (leafL_297_7).leaf := by decide

noncomputable def leavesL_297 : List RejectedLeaf := [leafL_297_0,leafL_297_1,leafL_297_2,leafL_297_3,leafL_297_4,leafL_297_5,leafL_297_6,leafL_297_7]

theorem leavesL_297_valid : LeafListValid leavesL_297 := by
  intro x hx
  simp only [leavesL_297, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_297_0_valid
  · exact leafL_297_1_valid
  · exact leafL_297_2_valid
  · exact leafL_297_3_valid
  · exact leafL_297_4_valid
  · exact leafL_297_5_valid
  · exact leafL_297_6_valid
  · exact leafL_297_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
