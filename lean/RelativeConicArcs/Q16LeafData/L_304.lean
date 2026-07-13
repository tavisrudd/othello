import RelativeConicArcs.Q16CertificateLevels

namespace RelativeConicArcs.Q16Classification.Q16CertificateData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable def leafL_304_0 : RejectedLeaf := { leaf := {0,1,17,34,52,74,125,203}, reject := .fullRank { members := ![0,1,17,34,52,74,125,203], points := ![92,103,108,110,131,137], inverse := ![9,8,6,0,7,1,14,5,14,2,6,1,0,7,15,8,0,0,15,14,7,1,9,14,0,4,0,4,13,13,0,1,14,15,6,6] } }
theorem leafL_304_0_valid : (leafL_304_0).reject.ValidFor (leafL_304_0).leaf := by decide

noncomputable def leafL_304_1 : RejectedLeaf := { leaf := {0,1,17,34,52,74,125,239}, reject := .fullRank { members := ![0,1,17,34,52,74,125,239], points := ![86,94,103,108,131,137], inverse := ![3,10,13,3,2,4,15,1,10,3,12,11,1,1,5,5,5,5,11,4,15,7,3,4,9,9,5,5,6,6,10,10,6,6,2,2] } }
theorem leafL_304_1_valid : (leafL_304_1).reject.ValidFor (leafL_304_1).leaf := by decide

noncomputable def leafL_304_2 : RejectedLeaf := { leaf := {0,1,17,34,52,74,128,205}, reject := .fullRank { members := ![0,1,17,34,52,74,128,205], points := ![86,94,101,104,137,147], inverse := ![6,15,1,15,6,0,2,12,11,2,7,0,6,11,12,6,12,11,15,4,0,5,0,14,10,3,6,1,11,5,0,6,3,1,13,9] } }
theorem leafL_304_2_valid : (leafL_304_2).reject.ValidFor (leafL_304_2).leaf := by decide

noncomputable def leafL_304_3 : RejectedLeaf := { leaf := {0,1,17,34,52,74,128,216}, reject := .fullRank { members := ![0,1,17,34,52,74,128,216], points := ![86,95,101,103,109,131], inverse := ![9,0,15,11,10,6,7,9,0,2,11,7,0,0,14,6,8,0,4,11,10,5,7,7,2,2,5,1,4,0,5,5,14,10,4,0] } }
theorem leafL_304_3_valid : (leafL_304_3).reject.ValidFor (leafL_304_3).leaf := by decide

noncomputable def leafL_304_4 : RejectedLeaf := { leaf := {0,1,17,34,52,74,128,233}, reject := .fullRank { members := ![0,1,17,34,52,74,128,233], points := ![86,94,95,104,108,131], inverse := ![4,2,15,12,2,6,13,15,12,11,2,7,6,5,3,0,0,0,15,7,7,9,1,7,9,7,14,14,14,0,4,8,12,10,10,0] } }
theorem leafL_304_4_valid : (leafL_304_4).reject.ValidFor (leafL_304_4).leaf := by decide

noncomputable def leafL_304_5 : RejectedLeaf := { leaf := {0,1,17,34,52,74,140,203}, reject := .fullRank { members := ![0,1,17,34,52,74,140,203], points := ![89,93,112,128,147,149], inverse := ![9,0,15,8,1,14,5,9,3,14,4,5,15,8,1,2,3,7,15,12,0,10,0,9,4,0,11,5,2,8,0,6,7,14,10,5] } }
theorem leafL_304_5_valid : (leafL_304_5).reject.ValidFor (leafL_304_5).leaf := by decide

noncomputable def leafL_304_6 : RejectedLeaf := { leaf := {0,1,17,34,52,74,140,237}, reject := .fullRank { members := ![0,1,17,34,52,74,140,237], points := ![89,104,147,149,152,163], inverse := ![0,13,15,4,1,6,3,13,3,2,6,9,0,0,4,12,8,0,11,5,15,3,2,0,6,6,13,13,6,6,4,4,15,9,2,4] } }
theorem leafL_304_6_valid : (leafL_304_6).reject.ValidFor (leafL_304_6).leaf := by decide

noncomputable def leafL_304_7 : RejectedLeaf := { leaf := {0,1,17,34,52,74,141,172}, reject := .fullRank { members := ![0,1,17,34,52,74,141,172], points := ![83,86,95,117,120,151], inverse := ![15,5,8,7,2,6,1,10,14,9,1,13,9,13,4,0,0,0,1,7,5,7,13,9,4,13,9,15,15,0,2,10,8,7,7,0] } }
theorem leafL_304_7_valid : (leafL_304_7).reject.ValidFor (leafL_304_7).leaf := by decide

noncomputable def leavesL_304 : List RejectedLeaf := [leafL_304_0,leafL_304_1,leafL_304_2,leafL_304_3,leafL_304_4,leafL_304_5,leafL_304_6,leafL_304_7]

theorem leavesL_304_valid : LeafListValid leavesL_304 := by
  intro x hx
  simp only [leavesL_304, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact leafL_304_0_valid
  · exact leafL_304_1_valid
  · exact leafL_304_2_valid
  · exact leafL_304_3_valid
  · exact leafL_304_4_valid
  · exact leafL_304_5_valid
  · exact leafL_304_6_valid
  · exact leafL_304_7_valid

end RelativeConicArcs.Q16Classification.Q16CertificateData
