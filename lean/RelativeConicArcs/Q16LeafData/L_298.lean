import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_298_0 : RejectedLeaf := { leaf := {0,1,17,34,52,74,93,110}, reject := .fullRank { members := ![0,1,17,34,52,74,93,110], points := ![115,117,133,143,151,152], inverse := ![4,0,8,6,8,3,1,2,15,7,11,0,8,8,13,13,14,14,0,2,7,14,8,3,10,10,12,12,9,9,13,13,15,15,4,4] } }
theorem leafL_298_0_valid : (leafL_298_0).reject.ValidFor (leafL_298_0).leaf := by decide

noncomputable def leafL_298_1 : RejectedLeaf := { leaf := {0,1,17,34,52,74,93,117}, reject := .fullRank { members := ![0,1,17,34,52,74,93,117], points := ![110,143,144,150,155,166], inverse := ![13,13,13,5,15,6,3,13,7,8,9,8,14,3,8,0,12,9,11,13,14,0,13,5,8,2,11,2,15,12,7,0,12,12,10,13] } }
theorem leafL_298_1_valid : (leafL_298_1).reject.ValidFor (leafL_298_1).leaf := by decide

noncomputable def leafL_298_2 : RejectedLeaf := { leaf := {0,1,17,34,52,74,93,155}, reject := .fullRank { members := ![0,1,17,34,52,74,93,155], points := ![101,108,115,117,120,140], inverse := ![14,9,14,8,15,15,0,7,2,11,7,9,0,0,4,12,8,0,12,11,10,13,8,8,3,3,6,11,13,0,9,9,3,14,13,0] } }
theorem leafL_298_2_valid : (leafL_298_2).reject.ValidFor (leafL_298_2).leaf := by decide

noncomputable def leafL_298_3 : RejectedLeaf := { leaf := {0,1,17,34,52,74,93,222}, reject := .fullRank { members := ![0,1,17,34,52,74,93,222], points := ![108,115,121,124,140,144], inverse := ![7,13,8,12,8,7,7,0,0,14,9,0,0,11,4,15,0,0,7,10,11,14,14,6,0,5,4,1,8,8,0,4,1,5,13,13] } }
theorem leafL_298_3_valid : (leafL_298_3).reject.ValidFor (leafL_298_3).leaf := by decide

noncomputable def leafL_298_4 : RejectedLeaf := { leaf := {0,1,17,34,52,74,93,235}, reject := .fullRank { members := ![0,1,17,34,52,74,93,235], points := ![103,108,110,117,121,144], inverse := ![1,13,11,15,6,15,0,12,11,1,15,9,7,15,8,0,0,0,0,4,3,6,9,8,4,13,9,13,13,0,1,8,9,6,6,0] } }
theorem leafL_298_4_valid : (leafL_298_4).reject.ValidFor (leafL_298_4).leaf := by decide

noncomputable def leafL_298_5 : RejectedLeaf := { leaf := {0,1,17,34,52,74,94,107}, reject := .fullRank { members := ![0,1,17,34,52,74,94,107], points := ![120,124,131,137,144,149], inverse := ![9,13,12,0,2,11,7,4,7,12,3,11,0,0,5,14,11,0,5,7,5,11,7,11,3,3,15,6,9,0,10,10,1,14,15,0] } }
theorem leafL_298_5_valid : (leafL_298_5).reject.ValidFor (leafL_298_5).leaf := by decide

noncomputable def leafL_298_6 : RejectedLeaf := { leaf := {0,1,17,34,52,74,94,125}, reject := .fullRank { members := ![0,1,17,34,52,74,94,125], points := ![108,131,137,144,149,151], inverse := ![9,1,6,10,5,0,2,7,7,4,4,2,0,5,14,11,0,0,13,13,8,4,2,14,0,1,6,7,15,15,0,3,14,13,4,4] } }
theorem leafL_298_6_valid : (leafL_298_6).reject.ValidFor (leafL_298_6).leaf := by decide

noncomputable def leafL_298_7 : RejectedLeaf := { leaf := {0,1,17,34,52,74,94,151}, reject := .fullRank { members := ![0,1,17,34,52,74,94,151], points := ![101,107,108,120,125,133], inverse := ![5,5,7,14,7,15,0,11,12,11,5,9,11,3,8,0,0,0,0,6,1,9,6,8,13,5,8,15,15,0,15,4,11,3,3,0] } }
theorem leafL_298_7_valid : (leafL_298_7).reject.ValidFor (leafL_298_7).leaf := by decide

noncomputable def leavesL_298 : List RejectedLeaf := [leafL_298_0,leafL_298_1,leafL_298_2,leafL_298_3,leafL_298_4,leafL_298_5,leafL_298_6,leafL_298_7]

theorem leavesL_298_valid : LeafListValid leavesL_298 := by
  intro x hx
  simp only [leavesL_298, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_298_0_valid
  · exact leafL_298_1_valid
  · exact leafL_298_2_valid
  · exact leafL_298_3_valid
  · exact leafL_298_4_valid
  · exact leafL_298_5_valid
  · exact leafL_298_6_valid
  · exact leafL_298_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
