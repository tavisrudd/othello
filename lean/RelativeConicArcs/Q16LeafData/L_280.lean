import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_280_0 : RejectedLeaf := { leaf := {0,1,17,34,52,72,174,213}, reject := .fullRank { members := ![0,1,17,34,52,72,174,213], points := ![91,92,93,103,112,122], inverse := ![14,4,5,14,6,6,13,10,14,4,10,7,7,6,1,0,0,0,7,7,8,9,6,7,3,4,7,8,8,0,12,4,8,2,2,0] } }
theorem leafL_280_0_valid : (leafL_280_0).reject.ValidFor (leafL_280_0).leaf := by decide

noncomputable def leafL_280_1 : RejectedLeaf := { leaf := {0,1,17,34,52,72,174,229}, reject := .fullRank { members := ![0,1,17,34,52,72,174,229], points := ![122,124,135,143,186,195], inverse := ![12,13,15,1,2,12,0,7,13,4,3,13,1,2,2,1,3,3,2,5,7,14,2,12,1,15,1,15,14,14,3,14,8,5,13,13] } }
theorem leafL_280_1_valid : (leafL_280_1).reject.ValidFor (leafL_280_1).leaf := by decide

noncomputable def leafL_280_2 : RejectedLeaf := { leaf := {0,1,17,34,52,72,174,233}, reject := .fullRank { members := ![0,1,17,34,52,72,174,233], points := ![91,93,101,112,117,135], inverse := ![9,2,2,14,2,4,14,14,8,15,14,9,4,6,11,9,2,2,10,8,9,12,13,10,7,9,3,13,14,14,6,15,3,10,9,9] } }
theorem leafL_280_2_valid : (leafL_280_2).reject.ValidFor (leafL_280_2).leaf := by decide

noncomputable def leafL_280_3 : RejectedLeaf := { leaf := {0,1,17,34,52,72,174,243}, reject := .fullRank { members := ![0,1,17,34,52,72,174,243], points := ![101,112,122,124,135,138], inverse := ![13,10,11,2,15,0,0,7,15,1,11,2,7,7,4,4,10,10,11,12,10,5,3,11,3,3,4,4,13,13,5,5,8,8,3,3] } }
theorem leafL_280_3_valid : (leafL_280_3).reject.ValidFor (leafL_280_3).leaf := by decide

noncomputable def leafL_280_4 : RejectedLeaf := { leaf := {0,1,17,34,52,72,174,267}, reject := .fullRank { members := ![0,1,17,34,52,72,174,267], points := ![92,93,99,101,112,135], inverse := ![5,12,14,13,13,6,7,9,15,4,2,7,0,0,15,8,7,0,9,6,6,4,10,7,13,13,13,4,9,0,6,6,8,15,7,0] } }
theorem leafL_280_4_valid : (leafL_280_4).reject.ValidFor (leafL_280_4).leaf := by decide

noncomputable def leafL_280_5 : RejectedLeaf := { leaf := {0,1,17,34,52,72,183,218}, reject := .fullRank { members := ![0,1,17,34,52,72,183,218], points := ![83,91,112,117,128,139], inverse := ![1,9,15,5,4,7,14,1,8,10,11,6,5,4,1,3,2,1,1,2,4,13,1,11,1,15,14,11,5,14,0,8,8,0,8,8] } }
theorem leafL_280_5_valid : (leafL_280_5).reject.ValidFor (leafL_280_5).leaf := by decide

noncomputable def leafL_280_6 : RejectedLeaf := { leaf := {0,1,17,34,52,72,183,222}, reject := .fullRank { members := ![0,1,17,34,52,72,183,222], points := ![83,107,117,124,137,138], inverse := ![0,7,15,6,11,4,2,5,4,8,8,3,13,13,7,10,0,13,8,15,15,8,1,1,14,14,8,6,6,8,10,10,4,14,1,11] } }
theorem leafL_280_6_valid : (leafL_280_6).reject.ValidFor (leafL_280_6).leaf := by decide

noncomputable def leafL_280_7 : RejectedLeaf := { leaf := {0,1,17,34,52,72,183,229}, reject := .fullRank { members := ![0,1,17,34,52,72,183,229], points := ![91,124,128,137,159,163], inverse := ![11,13,2,13,15,7,10,5,3,11,7,0,9,3,10,14,10,4,0,6,0,13,15,4,13,12,11,13,15,8,11,5,13,0,7,4] } }
theorem leafL_280_7_valid : (leafL_280_7).reject.ValidFor (leafL_280_7).leaf := by decide

noncomputable def leavesL_280 : List RejectedLeaf := [leafL_280_0,leafL_280_1,leafL_280_2,leafL_280_3,leafL_280_4,leafL_280_5,leafL_280_6,leafL_280_7]

theorem leavesL_280_valid : LeafListValid leavesL_280 := by
  intro x hx
  simp only [leavesL_280, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_280_0_valid
  · exact leafL_280_1_valid
  · exact leafL_280_2_valid
  · exact leafL_280_3_valid
  · exact leafL_280_4_valid
  · exact leafL_280_5_valid
  · exact leafL_280_6_valid
  · exact leafL_280_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
